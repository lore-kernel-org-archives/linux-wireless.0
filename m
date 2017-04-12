Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:46648 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752513AbdDLPWO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 11:22:14 -0400
Date: Wed, 12 Apr 2017 11:22:12 -0400 (EDT)
Message-Id: <20170412.112212.441025205054195351.davem@davemloft.net> (sfid-20170412_172218_188423_CE34A7F3)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC 3/3] mac80211: support bpf monitor filter
From: David Miller <davem@davemloft.net>
In-Reply-To: <1492007347.2855.12.camel@sipsolutions.net>
References: <20170412110726.9689-1-johannes@sipsolutions.net>
        <20170412110726.9689-3-johannes@sipsolutions.net>
        <1492007347.2855.12.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 12 Apr 2017 16:29:07 +0200

> On Wed, 2017-04-12 at 13:07 +0200, Johannes Berg wrote:
>> 
>>  struct ieee80211_if_mntr {
>>  	u32 flags;
>> 
> [...]
> +	bool deliver;
> 
> That's ... broken for multi-queue RX. I haven't really found a good
> other way to do it. The best way will likely be to copy the SKB the
> first time it's needed, build the radiotap header, and then keep a
> reference to it to be able to clone it later if it's needed again.

If you don't recurse into the receive path for different devices before
you are done with this boolean, simply make a global per-cpu boolean
and use that.
