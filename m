Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:37234 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbYFULvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 07:51:35 -0400
Date: Sat, 21 Jun 2008 07:51:33 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Let drivers have access to TKIP key offets for TX and RX MIC
Message-ID: <20080621115133.GI17936@ruslug.rutgers.edu> (sfid-20080621_135139_220433_07376217)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers may want to to use the TKIP key offsets for TX and RX
MIC so lets move this out.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/cfg80211.h |    5 +++++
 net/mac80211/key.h     |   37 ++++++++++++-------------------------
 2 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e007508..6cb8b02 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -12,6 +12,11 @@
  * Copyright 2006, 2007	Johannes Berg <johannes@sipsolutions.net>
  */
 
+/* Starting offsets for each key for TKIP */
+#define ALG_TKIP_TEMP_ENCR_KEY		0
+#define ALG_TKIP_TEMP_AUTH_TX_MIC_KEY	16
+#define ALG_TKIP_TEMP_AUTH_RX_MIC_KEY	24
+
 /**
  * struct vif_params - describes virtual interface parameters
  * @mesh_id: mesh ID to use
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index a0f774a..425816e 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -16,31 +16,18 @@
 #include <linux/rcupdate.h>
 #include <net/mac80211.h>
 
-/* ALG_TKIP
- * struct ieee80211_key::key is encoded as a 256-bit (32 byte) data block:
- * Temporal Encryption Key (128 bits)
- * Temporal Authenticator Tx MIC Key (64 bits)
- * Temporal Authenticator Rx MIC Key (64 bits)
- */
-
-#define WEP_IV_LEN 4
-#define WEP_ICV_LEN 4
-
-#define ALG_TKIP_KEY_LEN 32
-/* Starting offsets for each key */
-#define ALG_TKIP_TEMP_ENCR_KEY 0
-#define ALG_TKIP_TEMP_AUTH_TX_MIC_KEY 16
-#define ALG_TKIP_TEMP_AUTH_RX_MIC_KEY 24
-#define TKIP_IV_LEN 8
-#define TKIP_ICV_LEN 4
-
-#define ALG_CCMP_KEY_LEN 16
-#define CCMP_HDR_LEN 8
-#define CCMP_MIC_LEN 8
-#define CCMP_TK_LEN 16
-#define CCMP_PN_LEN 6
-
-#define NUM_RX_DATA_QUEUES 17
+#define WEP_IV_LEN		4
+#define WEP_ICV_LEN		4
+#define ALG_TKIP_KEY_LEN	32
+#define ALG_CCMP_KEY_LEN	16
+#define CCMP_HDR_LEN		8
+#define CCMP_MIC_LEN		8
+#define CCMP_TK_LEN		16
+#define CCMP_PN_LEN		6
+#define TKIP_IV_LEN		8
+#define TKIP_ICV_LEN		4
+
+#define NUM_RX_DATA_QUEUES	17
 
 struct ieee80211_local;
 struct ieee80211_sub_if_data;
-- 
1.5.5.3

