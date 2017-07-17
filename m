Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36216 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdGQPKJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 11:10:09 -0400
Received: by mail-oi0-f68.google.com with SMTP id n2so18150678oig.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 08:10:08 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 06/11] rtlwifi: Add rtl_get_hal_edca_param() to generate register's format of EDCA.
Date: Mon, 17 Jul 2017 10:09:49 -0500
Message-Id: <20170717150954.1441-7-Larry.Finger@lwfinger.net> (sfid-20170717_171029_017666_BCD3D442)
In-Reply-To: <20170717150954.1441-1-Larry.Finger@lwfinger.net>
References: <20170717150954.1441-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Convert from the value of ieee80211_tx_queue_params to Realtek's
register value.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - no changes
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 36 +++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/base.h |  4 ++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index f71b44c48ec0..9e6fcdde7475 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1558,6 +1558,42 @@ void rtl_wait_tx_report_acked(struct ieee80211_hw *hw, u32 wait_ms)
 			 "Wait 1ms (%d/%d) to disable key.\n", i, wait_ms);
 	}
 }
+
+u32 rtl_get_hal_edca_param(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif,
+			   enum wireless_mode wirelessmode,
+			   struct ieee80211_tx_queue_params *param)
+{
+	u32 reg = 0;
+	u8 sifstime = 10;
+	u8 slottime = 20;
+
+	/* AIFS = AIFSN * slot time + SIFS */
+	switch (wirelessmode) {
+	case WIRELESS_MODE_A:
+	case WIRELESS_MODE_N_24G:
+	case WIRELESS_MODE_N_5G:
+	case WIRELESS_MODE_AC_5G:
+	case WIRELESS_MODE_AC_24G:
+		sifstime = 16;
+		slottime = 9;
+		break;
+	case WIRELESS_MODE_G:
+		slottime = (vif->bss_conf.use_short_slot ? 9 : 20);
+		break;
+	default:
+		break;
+	}
+
+	reg |= (param->txop & 0x7FF) << 16;
+	reg |= (fls(param->cw_max) & 0xF) << 12;
+	reg |= (fls(param->cw_min) & 0xF) << 8;
+	reg |= (param->aifs & 0x0F) * slottime + sifstime;
+
+	return reg;
+}
+EXPORT_SYMBOL_GPL(rtl_get_hal_edca_param);
+
 /*********************************************************
  *
  * functions called by core.c
diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
index ab7d81904d25..4371dd4f75cb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.h
+++ b/drivers/net/wireless/realtek/rtlwifi/base.h
@@ -135,6 +135,10 @@ void rtl_tx_report_handler(struct ieee80211_hw *hw, u8 *tmp_buf,
 			   u8 c2h_cmd_len);
 bool rtl_check_tx_report_acked(struct ieee80211_hw *hw);
 void rtl_wait_tx_report_acked(struct ieee80211_hw *hw, u32 wait_ms);
+u32 rtl_get_hal_edca_param(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif,
+			   enum wireless_mode wirelessmode,
+			   struct ieee80211_tx_queue_params *param);
 
 void rtl_beacon_statistic(struct ieee80211_hw *hw, struct sk_buff *skb);
 void rtl_collect_scan_list(struct ieee80211_hw *hw, struct sk_buff *skb);
-- 
2.12.3
