Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36018 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3LIWhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 17:37:52 -0500
Received: by mail-ee0-f49.google.com with SMTP id c41so1857472eek.8
        for <linux-wireless@vger.kernel.org>; Mon, 09 Dec 2013 14:37:51 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	rmanohar@qti.qualcomm.com
Subject: [PATCH] ath9k: initialize retry chain flags in tx99 code
Date: Mon,  9 Dec 2013 23:37:49 +0100
Message-Id: <1386628669-15039-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20131209_233756_681050_0C111568)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize first chain flags in ath9k_build_tx99_skb() according to
configured channel mode and channel width

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/tx99.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index 57d7757..b686a74 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -48,7 +48,9 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 			       0x02, 0x23, 0x23, 0xab, 0x63, 0x89, 0x51, 0xb3,
 			       0xe7, 0x8b, 0x72, 0x90, 0x4c, 0xe8, 0xfb, 0xc0};
 	u32 len = 1200;
+	struct ieee80211_tx_rate *rate;
 	struct ieee80211_hw *hw = sc->hw;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info;
 	struct sk_buff *skb;
@@ -73,10 +75,16 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 
 	tx_info = IEEE80211_SKB_CB(skb);
 	memset(tx_info, 0, sizeof(*tx_info));
+	rate = &tx_info->control.rates[0];
 	tx_info->band = hw->conf.chandef.chan->band;
 	tx_info->flags = IEEE80211_TX_CTL_NO_ACK;
 	tx_info->control.vif = sc->tx99_vif;
-	tx_info->control.rates[0].count = 1;
+	rate->count = 1;
+	if (ah->curchan && IS_CHAN_HT(ah->curchan)) {
+		rate->flags |= IEEE80211_TX_RC_MCS;
+		if (IS_CHAN_HT40(ah->curchan))
+			rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+	}
 
 	memcpy(skb->data + sizeof(*hdr), PN9Data, sizeof(PN9Data));
 
-- 
1.8.3.2

