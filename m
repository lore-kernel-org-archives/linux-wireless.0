Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1092 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbZK0JaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 04:30:12 -0500
Subject: Re: [RFC 1/2] wireless: add ieee80211_asmdu_to_8023s
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259313653.5428.5.camel@johannes.local>
References: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
	 <1259229943.32372.50.camel@johannes.local>
	 <1259290376.13126.219.camel@debian>
	 <1259313653.5428.5.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Nov 2009 17:30:17 +0800
Message-ID: <1259314217.12157.3.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-11-27 at 17:20 +0800, Johannes Berg wrote:
> Is it? I don't think so. Many drivers go up beyond that as far as I
> know. Then some do different things like putting it in a different DMA
> block.
> 
> > While for those drivers really need a bigger
> > extra headroom and support Rx aggregation, this probably means
> > ieee80211_skb_resize. But the resize should always happen for every
> > packet from the IP stack, right?
> 
> No, davem and I optimised that away a long time ago via using
> netdev->needed_headroom and netdev->needed_tailroom. It even works for
> bridges and their slave devices, iirc. 

I missed this. Will check it. If so, I'll add another parameter to pass
the extra hw tx headroom to ieee80211_asmdu_to_8023s.

Thanks,
-yi

