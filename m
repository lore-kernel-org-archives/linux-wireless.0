Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42882 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab3HFQfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 12:35:52 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20993.9487.618902.977950@gargle.gargle.HOWL> (sfid-20130806_183555_641846_CEA258AE)
Date: Tue, 6 Aug 2013 22:02:15 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 07/12] ath9k: prepare queueing code for handling unaggregated
 traffic
In-Reply-To: <5200C64F.4080900@openwrt.org>
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
	<1375732583-39001-7-git-send-email-nbd@openwrt.org>
	<20992.43399.220167.743676@gargle.gargle.HOWL>
	<5200C64F.4080900@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Because the previous value doesn't matter here. With software
> scheduling, clearing the ps filter is triggered via
> tid->ac->clear_ps_filter, and that is used to set the flag when a frame
> is put into the hardware queue.
> The IEEE80211_TX_CTL_CLEAR_PS_FILT is checked whenever a frame enters
> the tid queue, and if it's set, tid->ac->clear_ps_filter gets set.
> That way it doesn't have to loop the entire tid traffic up to the new
> frame through the hw queue as filtered until the destination index gets
> cleared.

Ok.

> When going from aggregated to un-aggregated, the TID still needs to be
> scheduled, and txtid->paused == true would prevent that.

Yeah, makes sense.

Sujith
