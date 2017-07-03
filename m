Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34230 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754158AbdGCSku (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Jul 2017 14:40:50 -0400
Received: by mail-oi0-f65.google.com with SMTP id d77so20095247oig.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jul 2017 11:40:50 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 05/11] rtlwifi: Implement rtl_get_tx_hw_rate to yield correct hw_rate
Date: Mon,  3 Jul 2017 13:40:32 -0500
Message-Id: <20170703184038.24669-6-Larry.Finger@lwfinger.net> (sfid-20170703_204108_713185_917E40E3)
In-Reply-To: <20170703184038.24669-1-Larry.Finger@lwfinger.net>
References: <20170703184038.24669-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Originally, we get legacy rate only, so we extend to get HT and VHT rate.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 42 ++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 40e281273a55..38c8e94d2d6b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1100,6 +1100,42 @@ int rtlwifi_rate_mapping(struct ieee80211_hw *hw, bool isht, bool isvht,
 }
 EXPORT_SYMBOL(rtlwifi_rate_mapping);
 
+static u8 _rtl_get_tx_hw_rate(struct ieee80211_hw *hw,
+			      struct ieee80211_tx_info *info)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ieee80211_tx_rate *r = &info->status.rates[0];
+	struct ieee80211_rate *txrate;
+	u8 hw_value = 0x0;
+
+	if (r->flags & IEEE80211_TX_RC_MCS) {
+		/* HT MCS0-15 */
+		hw_value = rtlpriv->cfg->maps[RTL_RC_HT_RATEMCS15] - 15 +
+			   r->idx;
+	} else if (r->flags & IEEE80211_TX_RC_VHT_MCS) {
+		/* VHT MCS0-9, NSS */
+		if (ieee80211_rate_get_vht_nss(r) == 2)
+			hw_value = rtlpriv->cfg->maps[RTL_RC_VHT_RATE_2SS_MCS9];
+		else
+			hw_value = rtlpriv->cfg->maps[RTL_RC_VHT_RATE_1SS_MCS9];
+
+		hw_value = hw_value - 9 + ieee80211_rate_get_vht_mcs(r);
+	} else {
+		/* legacy */
+		txrate = ieee80211_get_tx_rate(hw, info);
+
+		if (txrate)
+			hw_value = txrate->hw_value;
+	}
+
+	/* check 5G band */
+	if (rtlpriv->rtlhal.current_bandtype == BAND_ON_5G &&
+	    hw_value < rtlpriv->cfg->maps[RTL_RC_OFDM_RATE6M])
+		hw_value = rtlpriv->cfg->maps[RTL_RC_OFDM_RATE6M];
+
+	return hw_value;
+}
+
 void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 		      struct ieee80211_tx_info *info,
 		      struct ieee80211_sta *sta,
@@ -1108,12 +1144,10 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *rtlmac = rtl_mac(rtl_priv(hw));
 	struct ieee80211_hdr *hdr = rtl_get_hdr(skb);
-	struct ieee80211_rate *txrate;
+
 	__le16 fc = rtl_get_fc(skb);
 
-	txrate = ieee80211_get_tx_rate(hw, info);
-	if (txrate)
-		tcb_desc->hw_rate = txrate->hw_value;
+	tcb_desc->hw_rate = _rtl_get_tx_hw_rate(hw, info);
 
 	if (rtl_is_tx_report_skb(hw, skb))
 		tcb_desc->use_spe_rpt = 1;
-- 
2.12.3
