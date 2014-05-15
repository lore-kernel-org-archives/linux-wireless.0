Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:49431 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752415AbaEORSW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:18:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, andrei.otcheretianski@intel.com
Date: Thu, 15 May 2014 20:18:09 +0300
Message-Id: <1400174289-22108-1-git-send-email-luca@coelho.fi> (sfid-20140515_191825_327061_0E4FF157)
Subject: [PATCH] cfg80211: add documentation for max_num_csa_coutners
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Move the comment in the structure to a description of the
max_num_csa_counters field in the docbook area.

This fixes a warning when building htmldocs (at least):

 Warning(include/net/cfg80211.h:3064): No description found for parameter 'max_num_csa_counters'

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 447cb58..955fdec 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2936,6 +2936,11 @@ struct wiphy_vendor_command {
  *	(including P2P GO) or 0 to indicate no such limit is advertised. The
  *	driver is allowed to advertise a theoretical limit that it can reach in
  *	some cases, but may not always reach.
+ *
+ * @max_num_csa_counters: Number of supported csa_counters in beacons
+ *	and probe responses.  This value should be set if the driver
+ *	wishes to limit the number of csa counters. Default (0) means
+ *	infinite.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3053,11 +3058,6 @@ struct wiphy {
 
 	u16 max_ap_assoc_sta;
 
-	/*
-	 * Number of supported csa_counters in beacons and probe responses.
-	 * This value should be set if the driver wishes to limit the number of
-	 * csa counters. Default (0) means infinite.
-	 */
 	u8 max_num_csa_counters;
 
 	char priv[0] __aligned(NETDEV_ALIGN);
-- 
2.0.0.rc0

