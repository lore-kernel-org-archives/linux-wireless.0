Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43416 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880AbZCaCai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 22:30:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 8/9] ath: space cleanup
Date: Mon, 30 Mar 2009 22:30:34 -0400
Message-Id: <1238466635-23280-9-git-send-email-lrodriguez@atheros.com> (sfid-20090331_043045_449055_5DA2F6A3)
In-Reply-To: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
References: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/regd.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 3ccf21c..4b5c851 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -173,9 +173,9 @@ static bool ath_is_radar_freq(u16 center_freq)
  *   received a beacon on a channel we can enable active scan and
  *   adhoc (or beaconing).
  */
-static void ath_reg_apply_beaconing_flags(
-	struct wiphy *wiphy,
-	enum nl80211_reg_initiator initiator)
+static void
+ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
+			      enum nl80211_reg_initiator initiator)
 {
 	enum ieee80211_band band;
 	struct ieee80211_supported_band *sband;
@@ -232,9 +232,9 @@ static void ath_reg_apply_beaconing_flags(
 }
 
 /* Allows active scan scan on Ch 12 and 13 */
-static void ath_reg_apply_active_scan_flags(
-	struct wiphy *wiphy,
-	enum nl80211_reg_initiator initiator)
+static void
+ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
+				enum nl80211_reg_initiator initiator)
 {
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
@@ -316,8 +316,8 @@ static void ath_reg_apply_radar_flags(struct wiphy *wiphy)
 }
 
 static void ath_reg_apply_world_flags(struct wiphy *wiphy,
-				 enum nl80211_reg_initiator initiator,
-				 struct ath_regulatory *reg)
+				      enum nl80211_reg_initiator initiator,
+				      struct ath_regulatory *reg)
 {
 	switch (reg->regpair->regDmnEnum) {
 	case 0x60:
@@ -335,7 +335,8 @@ static void ath_reg_apply_world_flags(struct wiphy *wiphy,
 }
 
 int ath_reg_notifier_apply(struct wiphy *wiphy,
-	struct regulatory_request *request, struct ath_regulatory *reg)
+			   struct regulatory_request *request,
+			   struct ath_regulatory *reg)
 {
 	/* We always apply this */
 	ath_reg_apply_radar_flags(wiphy);
@@ -433,8 +434,10 @@ ath_get_regpair(int regdmn)
 	return NULL;
 }
 
-static int ath_regd_init_wiphy(struct ath_regulatory *reg, struct wiphy *wiphy,
-			       int (*reg_notifier)(struct wiphy *wiphy,
+static int
+ath_regd_init_wiphy(struct ath_regulatory *reg,
+		    struct wiphy *wiphy,
+		    int (*reg_notifier)(struct wiphy *wiphy,
 					struct regulatory_request *request))
 {
 	const struct ieee80211_regdomain *regd;
@@ -464,9 +467,11 @@ static int ath_regd_init_wiphy(struct ath_regulatory *reg, struct wiphy *wiphy,
 	return 0;
 }
 
-int ath_regd_init(struct ath_regulatory *reg, struct wiphy *wiphy,
-		  int (*reg_notifier)(struct wiphy *wiphy,
-			    struct regulatory_request *request))
+int
+ath_regd_init(struct ath_regulatory *reg,
+	      struct wiphy *wiphy,
+	      int (*reg_notifier)(struct wiphy *wiphy,
+				  struct regulatory_request *request))
 {
 	struct country_code_to_enum_rd *country = NULL;
 	u16 regdmn;
-- 
1.6.0.6

