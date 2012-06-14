Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58851 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab2FNV14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 17:27:56 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	c_manoha@qca.qualcomm.com, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 3.5] ath9k: fix invalid pointer access in the tx path
Date: Thu, 14 Jun 2012 23:27:42 +0200
Message-Id: <1339709262-59805-1-git-send-email-nbd@openwrt.org> (sfid-20120614_232800_078515_095ADB91)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After setup_frame_info has been called, only info->control.rates is still
valid, other control fields have been overwritten by the ath_frame_info
data. Move the access to info->control.vif for checking short preamble
to setup_frame_info before it gets overwritten.

This regression was introduced in commit d47a61aa
"ath9k: Fix multi-VIF BSS handling"

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Thomas Hühn <thomas@net.t-labs.tu-berlin.de>
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: stable@vger.kernel.org [3.4]
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c  |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a277cf6..b5136a1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -214,6 +214,7 @@ struct ath_frame_info {
 	enum ath9k_key_type keytype;
 	u8 keyix;
 	u8 retries;
+	bool short_preamble;
 };
 
 struct ath_buf_state {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d59dd01..59fbe5b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -938,6 +938,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 	struct ieee80211_tx_rate *rates;
 	const struct ieee80211_rate *rate;
 	struct ieee80211_hdr *hdr;
+	struct ath_frame_info *fi = get_frame_info(bf->bf_mpdu);
 	int i;
 	u8 rix = 0;
 
@@ -957,8 +958,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 	rate = ieee80211_get_rts_cts_rate(sc->hw, tx_info);
 	info->rtscts_rate = rate->hw_value;
 
-	if (tx_info->control.vif &&
-	    tx_info->control.vif->bss_conf.use_short_preamble)
+	if (fi->short_preamble)
 		info->rtscts_rate |= rate->hw_value_short;
 
 	for (i = 0; i < 4; i++) {
@@ -1779,6 +1779,11 @@ static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath_frame_info *fi = get_frame_info(skb);
 	struct ath_node *an = NULL;
 	enum ath9k_key_type keytype;
+	bool short_preamble = false;
+
+	if (tx_info->control.vif &&
+	    tx_info->control.vif->bss_conf.use_short_preamble)
+		short_preamble = true;
 
 	keytype = ath9k_cmn_get_hw_crypto_keytype(skb);
 
@@ -1794,6 +1799,7 @@ static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
 		fi->keyix = ATH9K_TXKEYIX_INVALID;
 	fi->keytype = keytype;
 	fi->framelen = framelen;
+	fi->short_preamble = short_preamble;
 }
 
 u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
-- 
1.7.3.2

