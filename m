Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46354 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbcEIHbd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 03:31:33 -0400
Message-ID: <1462779090.30690.3.camel@sipsolutions.net> (sfid-20160509_093137_651595_730854DD)
Subject: Re: [PATCH 2/2] mac80211_hwsim: Allow managing radios from
 non-initial namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: David Laight <David.Laight@ACULAB.COM>,
	'Martin Willi' <martin@strongswan.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 09 May 2016 09:31:30 +0200
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D5F4B5302@AcuExch.aculab.com>
References: <1462258398-6749-1-git-send-email-martin@strongswan.org>
	 <1462258398-6749-3-git-send-email-martin@strongswan.org>
	 <063D6719AE5E284EB5DD2968C1650D6D5F4B5302@AcuExch.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > 
> > +	data->netgroup = *(int *)net_generic(net, hwsim_net_id);
> Anything doing *(integer_type *) rings alarm bells.
> 
> I suspect you should be defining a structure that currently contains
> one integer member.
> Something (maybe a compile time assert) needs to check that buffer
> space you are accessing (where ever it is) is large enough.
> 

It does look a bit awkward, but there's no value in having a struct -
you still have an opaque pointer here and cast it to something whose
size you assume to be present... it really makes no difference.

johannes
