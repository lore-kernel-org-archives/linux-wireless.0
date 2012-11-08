Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:51730 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756661Ab2KHW70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 17:59:26 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] nl/cfg80211: advertise OBSS scan offload capability
Date: Thu,  8 Nov 2012 14:54:00 -0800
Message-Id: <1352415240-5168-1-git-send-email-bzhao@marvell.com> (sfid-20121108_235951_925340_19AC9F56)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

New flag is added to inform userspace that this driver doesn't
internally perform OBSS scan. It can use this feature available
in userspace application.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/uapi/linux/nl80211.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index cbd2d6b..97c096c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3057,6 +3057,8 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_SCAN_FLUSH: Scan flush is supported
  * @NL80211_FEATURE_AP_SCAN: Support scanning using an AP vif
  * @NL80211_FEATURE_VIF_TXPOWER: The driver supports per-vif TX power setting
+ * @NL80211_FEATURE_OBSS_SCAN_OFFLOAD: This driver expects user space to perform
+ *	OBSS scan and generate 20/40 BSS coex reports.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3069,6 +3071,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_SCAN_FLUSH			= 1 << 7,
 	NL80211_FEATURE_AP_SCAN				= 1 << 8,
 	NL80211_FEATURE_VIF_TXPOWER			= 1 << 9,
+	NL80211_FEATURE_OBSS_SCAN_OFFLOAD		= 1 << 10,
 };
 
 /**
-- 
1.8.0

