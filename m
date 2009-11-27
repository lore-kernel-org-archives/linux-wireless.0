Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29975 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbZK0Cwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 21:52:51 -0500
Subject: Re: [RFC 1/2] wireless: add ieee80211_asmdu_to_8023s
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259229943.32372.50.camel@johannes.local>
References: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
	 <1259229943.32372.50.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Nov 2009 10:52:56 +0800
Message-ID: <1259290376.13126.219.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-11-26 at 18:05 +0800, Johannes Berg wrote:
> Oh one more thing, can you make addr const?

Sure.

> Also -- you lost the extra TX headroom which I think mac80211 as an AP
> requires since it could forward these frames? Or does that not happen?
> Not sure right now why that was there to start with. 

Yes, I'd like to hear more feedback on this. I think it's a trade off
between performance optimization and clean interface. As we already use
dev_alloc_skb to reserve 32 bytes headroom, it should be enough for most
of the current drivers. While for those drivers really need a bigger
extra headroom and support Rx aggregation, this probably means
ieee80211_skb_resize. But the resize should always happen for every
packet from the IP stack, right?

Thanks,
-yi

