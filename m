Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:42901 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753074AbeAJFUe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 00:20:34 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/10] rtlwifi: Add sta_statistics of mac80211's op, and set filled=0 by default
Date: Wed, 10 Jan 2018 13:19:55 +0800
Message-ID: <20180110052002.9544-4-pkshih@realtek.com> (sfid-20180110_062041_475434_510407AA)
In-Reply-To: <20180110052002.9544-1-pkshih@realtek.com>
References: <20180110052002.9544-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

When using iwconfig to check wifi status, wext uses 'static struct' of
sinfo to get station info so sinfo->filled will be persistent. Since the
commit 2b9a7e1bac24 ("mac80211: allow drivers to provide most station
statistics") assumes driver initializes sinfo->filled to declare supported
fields, without initialization it will report wrong info. This commit
simply set 'filled' to be zero simply, and left sinfo to be filled by
mac80211.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index a78b828f531a..ec639fa8095e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -992,6 +992,15 @@ static int _rtl_get_hal_qnum(u16 queue)
 	return qnum;
 }
 
+static void rtl_op_sta_statistics(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_sta *sta,
+				  struct station_info *sinfo)
+{
+	/* nothing filled by driver, so mac80211 will update all info */
+	sinfo->filled = 0;
+}
+
 /*
  *for mac80211 VO = 0, VI = 1, BE = 2, BK = 3
  *for rtl819x  BE = 0, BK = 1, VI = 2, VO = 3
@@ -1878,6 +1887,7 @@ const struct ieee80211_ops rtl_ops = {
 	.config = rtl_op_config,
 	.configure_filter = rtl_op_configure_filter,
 	.set_key = rtl_op_set_key,
+	.sta_statistics = rtl_op_sta_statistics,
 	.conf_tx = rtl_op_conf_tx,
 	.bss_info_changed = rtl_op_bss_info_changed,
 	.get_tsf = rtl_op_get_tsf,
-- 
2.15.1
