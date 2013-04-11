Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62220 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3DKLKf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:10:35 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	"Linux NFC" <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [RFC] [PATCH 1/2 v2] rfkill: Add NFC to the list of supported radios
Date: Thu, 11 Apr 2013 13:09:21 +0200
Message-Id: <1365678562-5583-2-git-send-email-sameo@linux.intel.com> (sfid-20130411_131038_447169_152AD858)
In-Reply-To: <1365678562-5583-1-git-send-email-sameo@linux.intel.com>
References: <1365678562-5583-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And return the proper string for it.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/uapi/linux/rfkill.h |    2 ++
 net/rfkill/core.c           |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/rfkill.h b/include/uapi/linux/rfkill.h
index 2753c6c..058757f 100644
--- a/include/uapi/linux/rfkill.h
+++ b/include/uapi/linux/rfkill.h
@@ -37,6 +37,7 @@
  * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
  * @RFKILL_TYPE_GPS: switch is on a GPS device.
  * @RFKILL_TYPE_FM: switch is on a FM radio device.
+ * @RFKILL_TYPE_NFC: switch is on an NFC device.
  * @NUM_RFKILL_TYPES: number of defined rfkill types
  */
 enum rfkill_type {
@@ -48,6 +49,7 @@ enum rfkill_type {
 	RFKILL_TYPE_WWAN,
 	RFKILL_TYPE_GPS,
 	RFKILL_TYPE_FM,
+	RFKILL_TYPE_NFC,
 	NUM_RFKILL_TYPES,
 };
 
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 9b9be52..1cec5e4 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -587,7 +587,7 @@ static ssize_t rfkill_name_show(struct device *dev,
 
 static const char *rfkill_get_type_str(enum rfkill_type type)
 {
-	BUILD_BUG_ON(NUM_RFKILL_TYPES != RFKILL_TYPE_FM + 1);
+	BUILD_BUG_ON(NUM_RFKILL_TYPES != RFKILL_TYPE_NFC + 1);
 
 	switch (type) {
 	case RFKILL_TYPE_WLAN:
@@ -604,6 +604,8 @@ static const char *rfkill_get_type_str(enum rfkill_type type)
 		return "gps";
 	case RFKILL_TYPE_FM:
 		return "fm";
+	case RFKILL_TYPE_NFC:
+		return "nfc";
 	default:
 		BUG();
 	}
-- 
1.7.10.4

