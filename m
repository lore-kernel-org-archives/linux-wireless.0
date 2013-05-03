Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:46821 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757973Ab3ECJ5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 05:57:53 -0400
Date: Fri, 3 May 2013 11:57:50 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [rfkill] Add NFC support
Message-ID: <20130503095750.GN4563@zurbaran> (sfid-20130503_115757_742221_6076606B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfkill.h is synced with the kernel header, man page is updated and
RFKILL_TYPE_NFC is mapped to "nfc".

---
 rfkill.8 |    2 +-
 rfkill.c |    3 +++
 rfkill.h |    2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/rfkill.8 b/rfkill.8
index aa11fde..24baccc 100644
--- a/rfkill.8
+++ b/rfkill.8
@@ -24,7 +24,7 @@ or just all of the given type.
 .BI block " index|type"
 Disable the device corresponding to the given index.
 \fItype\fR is one of "all", "wifi", "wlan", "bluetooth", "uwb",
-"ultrawideband", "wimax", "wwan", "gps" or "fm".
+"ultrawideband", "wimax", "wwan", "gps", "fm" or "nfc".
 .TP
 .BI unblock " index|type"
 Enable the device corresponding to the given index. If the device is
diff --git a/rfkill.c b/rfkill.c
index bda649a..b2672ee 100644
--- a/rfkill.c
+++ b/rfkill.c
@@ -111,6 +111,8 @@ static const char *type2string(enum rfkill_type type)
 		return "GPS";
 	case RFKILL_TYPE_FM:
 		return "FM";
+	case RFKILL_TYPE_NFC:
+		return "NFC";
 	case NUM_RFKILL_TYPES:
 		return NULL;
 	}
@@ -133,6 +135,7 @@ static const struct rfkill_type_str rfkill_type_strings[] = {
 	{	.type = RFKILL_TYPE_WWAN,		.name = "wwan"	},
 	{	.type = RFKILL_TYPE_GPS,		.name = "gps"	},
 	{	.type = RFKILL_TYPE_FM,			.name = "fm"	},
+	{	.type = RFKILL_TYPE_NFC,		.name = "nfc"	},
 	{	.name = NULL }
 };
 
diff --git a/rfkill.h b/rfkill.h
index 97059d0..d253b4e 100644
--- a/rfkill.h
+++ b/rfkill.h
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
 
-- 
1.7.10.4

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
