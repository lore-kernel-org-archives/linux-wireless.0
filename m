Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:49399 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166Ab2KJCAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 21:00:32 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] nl/cfg80211: advertise OBSS scan offload capability
Date: Fri,  9 Nov 2012 17:51:30 -0800
Message-Id: <1352512290-7316-1-git-send-email-bzhao@marvell.com> (sfid-20121110_030041_280290_F9B05D91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

wpa_supplicant will do OBSS scan for drivers that implement
auth/assoc API. Drivers that implement nl80211 connect API
(rather than auth/assoc) may need wpa_supplicant to do this
as well.

New flag is added to inform userspace that this driver will
make use of wpa_supplicant's OBSS scan feature.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: change flag documentation and commit log to be more specific
    (Johannes Berg)

 include/uapi/linux/nl80211.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index cbd2d6b..8ee60c8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3057,6 +3057,9 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_SCAN_FLUSH: Scan flush is supported
  * @NL80211_FEATURE_AP_SCAN: Support scanning using an AP vif
  * @NL80211_FEATURE_VIF_TXPOWER: The driver supports per-vif TX power setting
+ * @NL80211_FEATURE_OBSS_SCAN_OFFLOAD: The driver expects user space to
+ *	perform OBSS scan and generate 20/40 BSS coex reports. This flag is
+ *	interested in only in the case of a driver that has connect API.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3069,6 +3072,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_SCAN_FLUSH			= 1 << 7,
 	NL80211_FEATURE_AP_SCAN				= 1 << 8,
 	NL80211_FEATURE_VIF_TXPOWER			= 1 << 9,
+	NL80211_FEATURE_OBSS_SCAN_OFFLOAD		= 1 << 10,
 };
 
 /**
-- 
1.8.0

