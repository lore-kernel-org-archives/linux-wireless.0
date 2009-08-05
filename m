Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58436 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932530AbZHEANT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 20:13:19 -0400
Message-ID: <4A78CE98.70903@gmx.de>
Date: Wed, 05 Aug 2009 02:13:12 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>
Subject: [PATCH 1/2] ar9170: cleanup of bss_info_changed and beacon config
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable/Disable the beacon in ar910_set_beacon_timers() independently
of ar->vif, but controlled by BSS_CHANGED_BEACON_ENABLED and
bss_conf->enable_beacon from mac80211.

---
 drivers/net/wireless/ath/ar9170/ar9170.h |    1 +
 drivers/net/wireless/ath/ar9170/mac.c    |    4 +++-
 drivers/net/wireless/ath/ar9170/main.c   |   15 ++++++++-------
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index e6c3ee3..0db304a 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -177,6 +177,7 @@ struct ar9170 {
 	/* beaconing */
 	struct sk_buff *beacon;
 	struct work_struct beacon_work;
+	bool enable_beacon;
 
 	/* cryptographic engine */
 	u64 usedkeys;
diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
index d9f1f46..9f2801c 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -388,7 +388,9 @@ int ar9170_set_beacon_timers(struct ar9170 *ar)
 	u32 v = 0;
 	u32 pretbtt = 0;
 
-	if (ar->vif) {
+	if (ar->enable_beacon) {
+		if (WARN_ON(!ar->vif))
+			return -ENODEV;
 		v |= ar->vif->bss_conf.beacon_int;
 
 		switch (ar->vif->type) {
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 099ed3c..d51b6ad 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2177,11 +2177,18 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
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
@@ -2194,12 +2201,6 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
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

