Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:46608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752835AbdDLPTR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 11:19:17 -0400
Date: Wed, 12 Apr 2017 11:19:13 -0400 (EDT)
Message-Id: <20170412.111913.497795978751789475.davem@davemloft.net> (sfid-20170412_171920_677374_A893F82D)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org
Subject: Re: [RFC 1/3] bpf/wireless: add wifimon program type
From: David Miller <davem@davemloft.net>
In-Reply-To: <1492007254.2855.10.camel@sipsolutions.net>
References: <20170412110726.9689-1-johannes@sipsolutions.net>
        <1492007254.2855.10.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 12 Apr 2017 16:27:34 +0200

> This works. An example BPF program is here:
> https://p.sipsolutions.net/ca32264f2b705e5e.txt
 ...
> One thing I'm not so sure about is the usage of __sk_buff.
 ...
> Instead it may make more sense to just have a "wifi_info(skb, info)"
> function you can call, e.g. with a structure that has various fields
> and flags to see which you care about.

I would advise against this, let the parsing part use __sk_buff and
therefore have maximum flexibility.  You really cannot predict the
future, so in my opinion it might be unwise to constrain at this point.
