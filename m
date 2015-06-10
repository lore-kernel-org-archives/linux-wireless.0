Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37627 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbbFJFDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 01:03:30 -0400
Received: by wifx6 with SMTP id x6so34702456wif.0
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2015 22:03:28 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, nbd@openwrt.org,
	c_manoha@qca.qualcomm.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC] ath9k: allow to receive probe request when offchannel
Date: Wed, 10 Jun 2015 07:03:03 +0200
Message-Id: <1433912583-15918-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150610_070333_700634_EA46928B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fix problem that p2p group negotiation didn't work
correctly when chanctx used, because we didn't receive
probe requests when offchannel and use_chanctx=1

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
@Felix, Sujith could you review? I am not sure I put this in correct place.

 drivers/net/wireless/ath/ath9k/channel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 2066650..6301d44 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1157,6 +1157,7 @@ static bool ath_chanctx_defer_switch(struct ath_softc *sc)
 static void ath_offchannel_channel_change(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	u32 rfilt;
 
 	ath_dbg(common, CHAN_CTX, "%s: offchannel state: %s\n",
 		__func__, offchannel_state_string(sc->offchannel.state));
@@ -1179,6 +1180,11 @@ static void ath_offchannel_channel_change(struct ath_softc *sc)
 		ath_scan_complete(sc, false);
 		break;
 	case ATH_OFFCHANNEL_ROC_START:
+		/* Allow to receive probe requests */
+		rfilt = ath_calcrxfilter(sc);
+		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
+		ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
+
 		if (sc->cur_chan != &sc->offchannel.chan)
 			break;
 
-- 
1.9.1

