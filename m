Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43644 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755481AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 16/20] rtl8xxxu: Determine the need for SGI before handling specific TX desc formats
Date: Fri, 19 Aug 2016 17:46:38 -0400
Message-Id: <1471643202-26250-17-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234745_805985_AAAD10A3)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

In order to be able to split out the TX descriptor handling code,
determine in advance the need to mark SGI.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 2f951cf..6dc3f52 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4770,7 +4770,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	u16 rate_flag = tx_info->control.rates[0].flags;
 	int tx_desc_size = priv->fops->tx_desc_size;
 	int ret;
-	bool usedesc40, ampdu_enable;
+	bool usedesc40, ampdu_enable, sgi = false;
 
 	if (skb_headroom(skb) < tx_desc_size) {
 		dev_warn(dev,
@@ -4854,6 +4854,12 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	else
 		rate = tx_rate->hw_value;
 
+	if (rate_flag & IEEE80211_TX_RC_SHORT_GI ||
+	    (ieee80211_is_data_qos(hdr->frame_control) &&
+	     sta && sta->ht_cap.cap &
+	     (IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_SGI_20)))
+		sgi = true;
+
 	seq_number = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
 	if (!usedesc40) {
 		tx_desc->txdw5 = cpu_to_le32(rate);
@@ -4886,12 +4892,8 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 		    (sta && vif && vif->bss_conf.use_short_preamble))
 			tx_desc->txdw4 |= cpu_to_le32(TXDESC32_SHORT_PREAMBLE);
 
-		if (rate_flag & IEEE80211_TX_RC_SHORT_GI ||
-		    (ieee80211_is_data_qos(hdr->frame_control) &&
-		     sta && sta->ht_cap.cap &
-		     (IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_SGI_20))) {
+		if (sgi)
 			tx_desc->txdw5 |= cpu_to_le32(TXDESC32_SHORT_GI);
-		}
 
 		if (rate_flag & IEEE80211_TX_RC_USE_RTS_CTS) {
 			/*
-- 
2.7.4
