Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42515 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbGTPwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 11:52:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	nbd@openwrt.org, sujith@msujith.org, chaitanya.mgit@gmail.com
Subject: Re: [PATCH 1/3 v2] ath9k: handle RoC cancel correctly
References: <1435049662-20477-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 20 Jul 2015 18:52:08 +0300
In-Reply-To: <1435049662-20477-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 23 Jun 2015 10:54:22 +0200")
Message-ID: <87380isu6v.fsf@kamboji.qca.qualcomm.com> (sfid-20150720_175221_342264_87B710CD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> In case we will get ROC cancel from mac80211 we
> should not call ieee80211_remain_on_channel_expired().
>
> In other case I hit such warning on MIPS and
> p2p negotiation failed (tested with use_chanctx=1).
>
> ath: phy0: Starting RoC period
> ath: phy0: Channel definition created: 2412 MHz
> ath: phy0: Assigned next_chan to 2412 MHz
> ath: phy0: Offchannel duration for chan 2412 MHz : 506632
> ath: phy0: ath_chanctx_set_next: current: 2412 MHz, next: 2412 MHz
> ath: phy0: Stopping current chanctx: 2412
> ath: phy0: Flush timeout: 200
> ath: phy0: ath_chanctx_set_next: Set channel 2412 MHz
> ath: phy0: Set channel: 2412 MHz width: 0
> ath: phy0: Reset to 2412 MHz, HT40: 0 fastcc: 0
> ath: phy0: cur_chan: 2412 MHz, event: ATH_CHANCTX_EVENT_TSF_TIMER, state: ATH_CHANCTX_STATE_IDLE
> ath: phy0: ath_offchannel_channel_change: offchannel state: ATH_OFFCHANNEL_ROC_START
> ath: phy0: cur_chan: 2412 MHz, event: ATH_CHANCTX_EVENT_SWITCH, state: ATH_CHANCTX_STATE_IDLE
> ath: phy0: Cancel RoC
> ath: phy0: RoC aborted
> ath: phy0: RoC request on vif: 00:03:7f:4e:a0:cd, type: 1 duration: 500
> ath: phy0: Starting RoC period
> ath: phy0: Channel definition created: 2412 MHz
> ath: phy0: Assigned next_chan to 2412 MHz
> ath: phy0: Offchannel duration for chan 2412 MHz : 506705
> ath: phy0: ath_chanctx_set_next: current: 2412 MHz, next: 2412 MHz
> ath: phy0: ath_offchannel_channel_change: offchannel state: ATH_OFFCHANNEL_ROC_START
> ath: phy0: cur_chan: 2412 MHz, event: ATH_CHANCTX_EVENT_SWITCH, state: ATH_CHANCTX_STATE_IDLE
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 3312 at drivers/net/wireless/ath/ath9k/main.c:2319
> Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

When changing something in a patchset please resend the whole series,
not just the patch which has changed. So please resend the whole series
as v3.

-- 
Kalle Valo
