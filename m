Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37038 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932530AbZHUUqR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:46:17 -0400
Message-ID: <4A8F0798.6050908@gmx.de>
Date: Fri, 21 Aug 2009 22:46:16 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>
Subject: [PATCH 1/2 v2] ar9170: cleanup of bss_info_changed and beacon config
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add beacon control by BSS_CHANGED_BEACON_ENABLED and
bss_conf->enable_beacon from mac80211.

Signed-off-by: Joerg Albert <jal2@gmx.de>

---

As suggested by Christian this version preserves the old behaviour for STA mode.

 drivers/net/wireless/ath/ar9170/ar9170.h |    1 +
 drivers/net/wireless/ath/ar9170/mac.c    |   24 ++++++++++++++----------
 drivers/net/wireless/ath/ar9170/main.c   |   15 ++++++++-------
 3 files changed, 23 insertions(+), 17 deletions(-)

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
index 6004936..71eeef5 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -383,20 +383,24 @@ int ar9170_set_beacon_timers(struct ar9170 *ar)
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
+
+			switch (ar->vif->type) {
+			case NL80211_IFTYPE_MESH_POINT:
+			case NL80211_IFTYPE_ADHOC:
+				v |= BIT(25);
+				break;
+			case NL80211_IFTYPE_AP:
+				v |= BIT(24);
+				pretbtt = (ar->vif->bss_conf.beacon_int - 6) << 16;
+				break;
+			default:
 			break;
+			}
 		}
 
 		v |= ar->vif->bss_conf.dtim_period << 16;
+
 	}
 
 	ar9170_regwrite_begin(ar);
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 658b323..911e502 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2148,11 +2148,18 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 	}
 
-	if (changed & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED)) {
+	if (changed & BSS_CHANGED_BEACON_ENABLED) {
+		ar->enable_beacon = bss_conf->enable_beacon;
+	}
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
@@ -2165,12 +2172,6 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
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
-- 
1.6.0.4

