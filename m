Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45044 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756816AbdEOLqN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 07:46:13 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Lior David <qca_liord@qca.qualcomm.com>
Subject: [PATCH v2 4/5] wil6210: add option to ignore OTA regulatory hints
Date: Mon, 15 May 2017 14:45:58 +0300
Message-Id: <1494848759-3651-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170515_134621_879054_1FAFAF3A)
In-Reply-To: <1494848759-3651-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1494848759-3651-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some platforms, the regulatory domain (country) is set
using mechanisms external to WIFI, such as cellular modem
and GPS. In these scenarios the regulatory hints that
are received over the air (in beacons and similar) can
conflict and even cause an incorrect country to be set.
Add an option to ignore the OTA regulatory hints to better
support such scenarios.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 567fe43..0f297c0 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -26,6 +26,11 @@
 module_param(disable_ap_sme, bool, 0444);
 MODULE_PARM_DESC(disable_ap_sme, " let user space handle AP mode SME");
 
+static bool ignore_reg_hints;
+module_param(ignore_reg_hints, bool, 0444);
+MODULE_PARM_DESC(ignore_reg_hints,
+		 " Ignore OTA regulatory hints (Default: false)");
+
 #define CHAN60G(_channel, _flags) {				\
 	.band			= NL80211_BAND_60GHZ,		\
 	.center_freq		= 56160 + (2160 * (_channel)),	\
@@ -1763,6 +1768,11 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 
 	wiphy->n_vendor_commands = ARRAY_SIZE(wil_nl80211_vendor_commands);
 	wiphy->vendor_commands = wil_nl80211_vendor_commands;
+
+	if (ignore_reg_hints) {
+		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS;
+		wiphy->regulatory_flags |= REGULATORY_COUNTRY_IE_IGNORE;
+	}
 }
 
 struct wireless_dev *wil_cfg80211_init(struct device *dev)
-- 
1.9.1
