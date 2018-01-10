Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:42893 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752943AbeAJFUb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 00:20:31 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/10] rtlwifi: enable mac80211 fast-tx support
Date: Wed, 10 Jan 2018 13:19:57 +0800
Message-ID: <20180110052002.9544-6-pkshih@realtek.com> (sfid-20180110_062037_358994_A893B520)
In-Reply-To: <20180110052002.9544-1-pkshih@realtek.com>
References: <20180110052002.9544-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

To enable the mac80211 fast-tx feature, the hw/driver needs to support
dynamic power saving and fragmentation. Since our driver does not
need to fragment packet into smaller pieces, we just hook an empty
callback of set_frag_threshold to avoid fragmentation in mac80211.

After this, the mac80211 will not fragment the packets and can transmit
them faster by cache the header information.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/core.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 89ec318598ea..e902cd7adbfe 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -395,6 +395,8 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, CONNECTION_MONITOR);
 	ieee80211_hw_set(hw, MFP_CAPABLE);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, SUPPORTS_TX_FRAG);
+	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 
 	/* swlps or hwlps has been set in diff chip in init_sw_vars */
 	if (rtlpriv->psc.swctrl_lps) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 6c698123ac07..d454c38fc9cd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1001,6 +1001,11 @@ static void rtl_op_sta_statistics(struct ieee80211_hw *hw,
 	sinfo->filled = 0;
 }
 
+static int rtl_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
+{
+	return -EOPNOTSUPP;
+}
+
 /*
  *for mac80211 VO = 0, VI = 1, BE = 2, BK = 3
  *for rtl819x  BE = 0, BK = 1, VI = 2, VO = 3
@@ -1906,6 +1911,7 @@ const struct ieee80211_ops rtl_ops = {
 	.configure_filter = rtl_op_configure_filter,
 	.set_key = rtl_op_set_key,
 	.sta_statistics = rtl_op_sta_statistics,
+	.set_frag_threshold = rtl_op_set_frag_threshold,
 	.conf_tx = rtl_op_conf_tx,
 	.bss_info_changed = rtl_op_bss_info_changed,
 	.get_tsf = rtl_op_get_tsf,
-- 
2.15.1
