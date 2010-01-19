Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9861 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab0ASHFZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 02:05:25 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] update rfkill.h from kernel 2.6.33
Date: Tue, 19 Jan 2010 09:05:21 +0200
Message-Id: <1263884721-11008-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1. add FM radio type
2. update rfkill_type docs

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 rfkill.c |    3 +++
 rfkill.h |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/rfkill.c b/rfkill.c
index 216e6ac..3f71181 100644
--- a/rfkill.c
+++ b/rfkill.c
@@ -109,6 +109,8 @@ static const char *type2string(enum rfkill_type type)
 		return "Wireless WAN";
 	case RFKILL_TYPE_GPS:
 		return "GPS";
+	case RFKILL_TYPE_FM:
+		return "FM";
 	case NUM_RFKILL_TYPES:
 		return NULL;
 	}
@@ -203,6 +205,7 @@ static struct rfkill_type_str rfkill_type_strings[] = {
 	{	.type = RFKILL_TYPE_WIMAX,		.name = "wimax"	},
 	{	.type = RFKILL_TYPE_WWAN,		.name = "wwan"	},
 	{	.type = RFKILL_TYPE_GPS,		.name = "gps"	},
+	{	.type = RFKILL_TYPE_FM,			.name = "fm"	},
 	{	.name = NULL }
 };
 
diff --git a/rfkill.h b/rfkill.h
index 3392c59..97059d0 100644
--- a/rfkill.h
+++ b/rfkill.h
@@ -35,6 +35,8 @@
  * @RFKILL_TYPE_UWB: switch is on a ultra wideband device.
  * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
  * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
+ * @RFKILL_TYPE_GPS: switch is on a GPS device.
+ * @RFKILL_TYPE_FM: switch is on a FM radio device.
  * @NUM_RFKILL_TYPES: number of defined rfkill types
  */
 enum rfkill_type {
@@ -45,6 +47,7 @@ enum rfkill_type {
 	RFKILL_TYPE_WIMAX,
 	RFKILL_TYPE_WWAN,
 	RFKILL_TYPE_GPS,
+	RFKILL_TYPE_FM,
 	NUM_RFKILL_TYPES,
 };
 
-- 
1.6.0.6

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

