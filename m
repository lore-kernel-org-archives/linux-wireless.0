Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:50842 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbYGTPfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 11:35:22 -0400
Received: by py-out-1112.google.com with SMTP id p76so818578pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2008 08:35:21 -0700 (PDT)
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction
	in	RCU.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kaber@trash.net, davem@davemloft.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <E1KKZmE-0000ty-00@gondolin.me.apana.org.au>
References: <E1KKZmE-0000ty-00@gondolin.me.apana.org.au>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 11:35:19 -0400
Message-Id: <1216568119.4847.101.camel@localhost> (sfid-20080720_173528_960902_9528397B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-20-07 at 22:20 +0800, Herbert Xu wrote:

> Not all actions :) That nat action for example wasn't intended to
> be shared at all.  In fact I still need to submit a patch to make
> it skip the shared hash as otherwise it simply won't scale as the
> number of nat actions increases (e.g., to 256K).

True, sharing in the case of nat will cause scaling challenges because
there is a per-action locking. So you dont want to share in that case.
Let me clarify the global "sharedness" of actions, because i dont think
there is an issue:

All actions (on a per-type hash table basis) have an index.
You create filter rule X and specify action nat.
You may specify the index of the action when you create the filter X. 
If you then create another filter rule Y, also using the same action
index, then that nat action is shared between rule X and rule Y[1].

If you dont specify the index a new nat action is created.
So in essence, if you create 256K rules each with an action and
as long as you dont specify the action index, you should be fine
because none will be shared.
The only scaling thing i can think of is to try and make the nat action
hash table large to reduce the init lookup. Other than that, once the
action is bound to a filter lookup cost is zero.

cheers,
jamal

[1]This is useful for tow reasons:
a) memory saving purposes: If you dont care that much about performance
or on a uniprocessor machine, one action would just be sufficient for
many rules.
b) accounting purposes; as you know qdiscs/filters/actions are
per-device. Over the years, a need has arosen from some users to have a
"per system" accounting (refer to the IMQ/IFB approach). Eg, if i wanted
the policer action to account for ingress eth0 and egress eth1 for a
user, i couldnt do it without some acrobatics.

