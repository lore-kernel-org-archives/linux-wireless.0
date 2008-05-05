Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.183]:28350 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759641AbYEEO1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 10:27:22 -0400
Received: by el-out-1112.google.com with SMTP id n30so708785elf.21
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 07:27:21 -0700 (PDT)
Message-ID: <1ba2fa240805050727r2060b0b4x3a9b3240647b66b1@mail.gmail.com> (sfid-20080505_162644_854898_5236F515)
Date: Mon, 5 May 2008 17:27:20 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
Cc: "David Miller" <davem@davemloft.net>, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1209972139.3655.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1209936253.7304.10.camel@johannes.berg>
	 <1209936745.7304.16.camel@johannes.berg>
	 <20080504.173051.133197507.davem@davemloft.net>
	 <1209972139.3655.9.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  > If we can ensure that, things like mac80211 and others will not need
>  > to skb_realloc_headroom() or anything like that unless they need to
>  > modify packet contents after skb->data and the packet is shared
>  > (ie. the pskb_expand_headroom(skb, 0, 0, GFP_*) case the TSO drivers
>  > use).
>
>  That would be nice, but I don't think it's possible.
>
Not sure this is connected so sorry if I'm hijacking on wrong thread.
I might miss some emails on this thread.
I would like to request some comments on the following observation.
I'm just diving into this part of the kernel so please fix me if I've
missed something.

I've did some measurement of the TX path  on an embedded system (2.6.23 kernel)
When bridging packets from an ethernet device to wireless  there is
loss of 12% in the CPU utilization and equivalent throughput reduction
in data packets that are checked and expanded in
ieee80211_subif_start_xmit function.
The expansion is just due to bigger size of the 80211 header size, yet
the whole packet is reallocated and copied. As we are reaching 11n
rates 200bps and up this starts to be visible.
When header was reserved to the  proper side already in the ethernet
driver the overhead was gone. Yet this doesn't seems to be a correct
solution for bridging or forwarding.
For example Iwlwifi HW supports scattered packets this would allow
just reallocate the header, providing data portion is aligned.


Thanks
Tomas






>  johannes
>
