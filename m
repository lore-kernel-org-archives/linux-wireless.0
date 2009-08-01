Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37087 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbZHAXgv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 19:36:51 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] rfkill: add the GPS radio type
Date: Sun,  2 Aug 2009 02:36:49 +0300
Message-Id: <1249169809-11853-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Althoug GPS is a technology w/o transmitting radio
and thus not a primary candidate for rfkill switch,
rfkill gives unified interface point for devices with
wireless technology.

The input key is not supplied as it is too be deprecated.

Cc: johannes@sipsolutions.net
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/linux/rfkill.h |    1 +
 net/rfkill/core.c      |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 1020290..21ca51b 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -47,6 +47,7 @@ enum rfkill_type {
 	RFKILL_TYPE_UWB,
 	RFKILL_TYPE_WIMAX,
 	RFKILL_TYPE_WWAN,
+	RFKILL_TYPE_GPS,
 	NUM_RFKILL_TYPES,
 };
 
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 044de1c..dbeaf29 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -589,11 +589,13 @@ static const char *rfkill_get_type_str(enum rfkill_type type)
 		return "wimax";
 	case RFKILL_TYPE_WWAN:
 		return "wwan";
+	case RFKILL_TYPE_GPS:
+		return "gps";
 	default:
 		BUG();
 	}
 
-	BUILD_BUG_ON(NUM_RFKILL_TYPES != RFKILL_TYPE_WWAN + 1);
+	BUILD_BUG_ON(NUM_RFKILL_TYPES != RFKILL_TYPE_GPS + 1);
 }
 
 static ssize_t rfkill_type_show(struct device *dev,
-- 
1.6.0.6

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

