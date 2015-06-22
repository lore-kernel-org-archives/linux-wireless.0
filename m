Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:33932 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbbFVLnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 07:43:33 -0400
Received: by lbnk3 with SMTP id k3so782547lbn.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 04:43:32 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, nbd@openwrt.org, sujith@msujith.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/3] ath9k: handle RoC abort correctly
Date: Mon, 22 Jun 2015 13:43:03 +0200
Message-Id: <1434973385-15865-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150622_134337_747034_54C3727A)
In-Reply-To: <1434973385-15865-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1434973385-15865-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case we will get ROC abort we should not call
ieee80211_remain_on_channel_expired().

In other case I hit such warning on MIPS and
p2p negotiation failed (tested with use_chanctx=1).

ath: phy0: Starting RoC period
ath: phy0: Channel definition created: 2412 MHz
ath: phy0: Assigned next_chan to 2412 MHz
ath: phy0: Offchannel duration for chan 2412 MHz : 506632
ath: phy0: ath_chanctx_set_next: current: 2412 MHz, next: 2412 MHz
ath: phy0: Stopping current chanctx: 2412
ath: phy0: Flush timeout: 200
ath: phy0: ath_chanctx_set_next: Set channel 2412 MHz
ath: phy0: Set channel: 2412 MHz width: 0
ath: phy0: Reset to 2412 MHz, HT40: 0 fastcc: 0
ath: phy0: cur_chan: 2412 MHz, event: ATH_CHANCTX_EVENT_TSF_TIMER, state: ATH_CHANCTX_STATE_IDLE
ath: phy0: ath_offchannel_channel_change: offchannel state: ATH_OFFCHANNEL_ROC_START
ath: phy0: cur_chan: 2412 MHz, event: ATH_CHANCTX_EVENT_SWITCH, state: ATH_CHANCTX_STATE_IDLE
ath: phy0: Cancel RoC
ath: phy0: RoC aborted
ath: phy0: RoC request on vif: 00:03:7f:4e:a0:cd, type: 1 duration: 500
ath: phy0: Starting RoC period
ath: phy0: Channel definition created: 2412 MHz
ath: phy0: Assigned next_chan to 2412 MHz
ath: phy0: Offchannel duration for chan 2412 MHz : 506705
ath: phy0: ath_chanctx_set_next: current: 2412 MHz, next: 2412 MHz
ath: phy0: ath_offchannel_channel_change: offchannel state: ATH_OFFCHANNEL_ROC_START
ath: phy0: cur_chan: 2412 MHz, event: ATH_CHANCTX_EVENT_SWITCH, state: ATH_CHANCTX_STATE_IDLE
------------[ cut here ]------------
WARNING: CPU: 0 PID: 3312 at drivers/net/wireless/ath/ath9k/main.c:2319
Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 2066650..e211325 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -926,7 +926,8 @@ void ath_roc_complete(struct ath_softc *sc, bool abort)
 
 	sc->offchannel.roc_vif = NULL;
 	sc->offchannel.roc_chan = NULL;
-	ieee80211_remain_on_channel_expired(sc->hw);
+	if (!abort)
+		ieee80211_remain_on_channel_expired(sc->hw);
 	ath_offchannel_next(sc);
 	ath9k_ps_restore(sc);
 }
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
