Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:54052 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbeAQGPu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 01:15:50 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 04/10] rtlwifi: enable mac80211 fast-tx support
Date: Wed, 17 Jan 2018 14:15:24 +0800
Message-ID: <20180117061530.30049-5-pkshih@realtek.com> (sfid-20180117_071555_709604_FA916240)
In-Reply-To: <20180117061530.30049-1-pkshih@realtek.com>
References: <20180117061530.30049-1-pkshih@realtek.com>
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
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
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
index a16aa94273e8..cef511f7aa05 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -992,6 +992,11 @@ static int _rtl_get_hal_qnum(u16 queue)
 	return qnum;
 }
 
+static int rtl_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
+{
+	return -EOPNOTSUPP;
+}
+
 /*
  *for mac80211 VO = 0, VI = 1, BE = 2, BK = 3
  *for rtl819x  BE = 0, BK = 1, VI = 2, VO = 3
@@ -1896,6 +1901,7 @@ const struct ieee80211_ops rtl_ops = {
 	.config = rtl_op_config,
 	.configure_filter = rtl_op_configure_filter,
 	.set_key = rtl_op_set_key,
+	.set_frag_threshold = rtl_op_set_frag_threshold,
 	.conf_tx = rtl_op_conf_tx,
 	.bss_info_changed = rtl_op_bss_info_changed,
 	.get_tsf = rtl_op_get_tsf,
-- 
2.15.1
