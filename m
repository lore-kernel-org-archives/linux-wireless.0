Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41626 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab2FOBFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 21:05:15 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	c_manoha@qca.qualcomm.com, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v2 3.5 2/2] ath9k: fix invalid pointer access in the tx path
Date: Fri, 15 Jun 2012 03:04:53 +0200
Message-Id: <1339722293-28613-2-git-send-email-nbd@openwrt.org> (sfid-20120615_030520_135385_CCE70BA0)
In-Reply-To: <1339722293-28613-1-git-send-email-nbd@openwrt.org>
References: <1339722293-28613-1-git-send-email-nbd@openwrt.org>
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
 drivers/net/wireless/ath/ath9k/xmit.c  |   29 +++++++++++++++++------------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a277cf6..4866550 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -214,6 +214,7 @@ struct ath_frame_info {
 	enum ath9k_key_type keytype;
 	u8 keyix;
 	u8 retries;
+	u8 rtscts_rate;
 };
 
 struct ath_buf_state {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index efb7f00..4d57139 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -938,6 +938,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 	struct ieee80211_tx_rate *rates;
 	const struct ieee80211_rate *rate;
 	struct ieee80211_hdr *hdr;
+	struct ath_frame_info *fi = get_frame_info(bf->bf_mpdu);
 	int i;
 	u8 rix = 0;
 
@@ -948,18 +949,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 
 	/* set dur_update_en for l-sig computation except for PS-Poll frames */
 	info->dur_update = !ieee80211_is_pspoll(hdr->frame_control);
-
-	/*
-	 * We check if Short Preamble is needed for the CTS rate by
-	 * checking the BSS's global flag.
-	 * But for the rate series, IEEE80211_TX_RC_USE_SHORT_PREAMBLE is used.
-	 */
-	rate = ieee80211_get_rts_cts_rate(sc->hw, tx_info);
-	info->rtscts_rate = rate->hw_value;
-
-	if (tx_info->control.vif &&
-	    tx_info->control.vif->bss_conf.use_short_preamble)
-		info->rtscts_rate |= rate->hw_value_short;
+	info->rtscts_rate = fi->rtscts_rate;
 
 	for (i = 0; i < 4; i++) {
 		bool is_40, is_sgi, is_sp;
@@ -1776,10 +1766,22 @@ static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_sta *sta = tx_info->control.sta;
 	struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	const struct ieee80211_rate *rate;
 	struct ath_frame_info *fi = get_frame_info(skb);
 	struct ath_node *an = NULL;
 	enum ath9k_key_type keytype;
+	bool short_preamble = false;
+
+	/*
+	 * We check if Short Preamble is needed for the CTS rate by
+	 * checking the BSS's global flag.
+	 * But for the rate series, IEEE80211_TX_RC_USE_SHORT_PREAMBLE is used.
+	 */
+	if (tx_info->control.vif &&
+	    tx_info->control.vif->bss_conf.use_short_preamble)
+		short_preamble = true;
 
+	rate = ieee80211_get_rts_cts_rate(hw, tx_info);
 	keytype = ath9k_cmn_get_hw_crypto_keytype(skb);
 
 	if (sta)
@@ -1794,6 +1796,9 @@ static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
 		fi->keyix = ATH9K_TXKEYIX_INVALID;
 	fi->keytype = keytype;
 	fi->framelen = framelen;
+	fi->rtscts_rate = rate->hw_value;
+	if (short_preamble)
+		fi->rtscts_rate |= rate->hw_value_short;
 }
 
 u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
-- 
1.7.3.2

