Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:41251 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbZHUVZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 17:25:07 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Joerg Albert <jal2@gmx.de>
Subject: [PATCH 1/2 v3] ar9170: cleanup of bss_info_changed and beacon config
Date: Fri, 21 Aug 2009 23:25:07 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4A8F0798.6050908@gmx.de>
In-Reply-To: <4A8F0798.6050908@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200908212325.07664.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joerg Albert <jal2@gmx.de>

Add beacon control by BSS_CHANGED_BEACON_ENABLED and
bss_conf->enable_beacon from mac80211.
 
Signed-off-by: Joerg Albert <jal2@gmx.de>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
About time they show up ;-)

changes from v2:
	- fixed both checkpatch.pl complains
	- removed a few empty lines.

hope this one is fine...
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index ce40724..914e471 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -178,6 +178,7 @@ struct ar9170 {
 	/* beaconing */
 	struct sk_buff *beacon;
 	struct work_struct beacon_work;
+	bool enable_beacon;
 
 	/* cryptographic engine */
 	u64 usedkeys;
diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
index 6004936..614e321 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -383,24 +383,26 @@ int ar9170_set_beacon_timers(struct ar9170 *ar)
 	if (ar->vif) {
 		v |= ar->vif->bss_conf.beacon_int;
 
-		switch (ar->vif->type) {
-		case NL80211_IFTYPE_MESH_POINT:
-		case NL80211_IFTYPE_ADHOC:
-			v |= BIT(25);
-			break;
-		case NL80211_IFTYPE_AP:
-			v |= BIT(24);
-			pretbtt = (ar->vif->bss_conf.beacon_int - 6) << 16;
-			break;
-		default:
+		if (ar->enable_beacon) {
+			switch (ar->vif->type) {
+			case NL80211_IFTYPE_MESH_POINT:
+			case NL80211_IFTYPE_ADHOC:
+				v |= BIT(25);
+				break;
+			case NL80211_IFTYPE_AP:
+				v |= BIT(24);
+				pretbtt = (ar->vif->bss_conf.beacon_int - 6) <<
+					  16;
+				break;
+			default:
 			break;
+			}
 		}
 
 		v |= ar->vif->bss_conf.dtim_period << 16;
 	}
 
 	ar9170_regwrite_begin(ar);
-
 	ar9170_regwrite(AR9170_MAC_REG_PRETBTT, pretbtt);
 	ar9170_regwrite(AR9170_MAC_REG_BCN_PERIOD, v);
 	ar9170_regwrite_finish();
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 658b323..c0fc355 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2148,11 +2148,17 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 	}
 
-	if (changed & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED)) {
+	if (changed & BSS_CHANGED_BEACON_ENABLED)
+		ar->enable_beacon = bss_conf->enable_beacon;
+
+	if (changed & BSS_CHANGED_BEACON) {
 		err = ar9170_update_beacon(ar);
 		if (err)
 			goto out;
+	}
 
+	if (changed & (BSS_CHANGED_BEACON_ENABLED | BSS_CHANGED_BEACON |
+		       BSS_CHANGED_BEACON_INT)) {
 		err = ar9170_set_beacon_timers(ar);
 		if (err)
 			goto out;
@@ -2165,12 +2171,6 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
 #endif /* CONFIG_AR9170_LEDS */
 	}
 
-	if (changed & BSS_CHANGED_BEACON_INT) {
-		err = ar9170_set_beacon_timers(ar);
-		if (err)
-			goto out;
-	}
-
 	if (changed & BSS_CHANGED_HT) {
 		/* TODO */
 		err = 0;
