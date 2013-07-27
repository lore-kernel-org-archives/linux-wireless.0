Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:43255 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417Ab3G0AFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 20:05:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Avinash Patil <patila@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] ieee80211: add definition for interworking support
Date: Fri, 26 Jul 2013 17:02:29 -0700
Message-ID: <1374883349-22912-1-git-send-email-bzhao@marvell.com> (sfid-20130727_020524_573843_860E270E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

IEEE802.11u interworking support is advertised via extended
capabilities IE bit 31. This is 7th bit of 4th byte of extended
capabilities.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/ieee80211.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b0dc87a..22c9094 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1860,6 +1860,11 @@ enum ieee80211_tdls_actioncode {
 	WLAN_TDLS_DISCOVERY_REQUEST = 10,
 };
 
+/* Interworking capabilities are set in 7th bit of 4th byte of the
+ * @WLAN_EID_EXT_CAPABILITY information element
+ */
+#define WLAN_EXT_CAPA4_INTERWORKING_ENABLED	BIT(7)
+
 /*
  * TDLS capabililites to be enabled in the 5th byte of the
  * @WLAN_EID_EXT_CAPABILITY information element
-- 
1.8.0

