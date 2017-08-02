Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:35554 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752616AbdHBVBH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 17:01:07 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v2 6/9] wil6210: notify wiphy on wowlan support
Date: Thu,  3 Aug 2017 00:00:46 +0300
Message-Id: <1501707649-9665-7-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170802_230110_744089_055222A2)
In-Reply-To: <1501707649-9665-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1501707649-9665-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set wowlan to indicate that 11ad device can wake-up
on any trigger and disconnect.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index c860c0c..61e872c 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -34,6 +34,12 @@
 module_param(scan_timeout, uint, 0644);
 MODULE_PARM_DESC(scan_timeout, " Scan timeout (seconds)");
 
+#ifdef CONFIG_PM
+static struct wiphy_wowlan_support wil_wowlan_support = {
+	.flags = WIPHY_WOWLAN_ANY | WIPHY_WOWLAN_DISCONNECT,
+};
+#endif
+
 #define CHAN60G(_channel, _flags) {				\
 	.band			= NL80211_BAND_60GHZ,		\
 	.center_freq		= 56160 + (2160 * (_channel)),	\
@@ -1819,6 +1825,10 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 
 	wiphy->n_vendor_commands = ARRAY_SIZE(wil_nl80211_vendor_commands);
 	wiphy->vendor_commands = wil_nl80211_vendor_commands;
+
+#ifdef CONFIG_PM
+	wiphy->wowlan = &wil_wowlan_support;
+#endif
 }
 
 struct wireless_dev *wil_cfg80211_init(struct device *dev)
-- 
1.9.1
