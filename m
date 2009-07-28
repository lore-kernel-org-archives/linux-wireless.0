Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12468 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZG1B34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 21:29:56 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 18:29:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC] cfg80211: send country ie processing on the reg_work struct
Date: Mon, 27 Jul 2009 18:29:53 -0700
Message-ID: <1248744593-6597-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Did this in a flash, so just want to see if this is you like this
approach. Of course a lot of cleaning can be done here but ignore that
for now (like the fact that beacon hint doesn't really process IEs,
and the functions names used here).

This just compiles for me, never tested it.

 net/wireless/reg.c |  101 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 93 insertions(+), 8 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index fb40428..3005ddf 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -73,9 +73,35 @@ static spinlock_t reg_pending_beacons_lock;
 /* Used to keep track of processed beacon hints */
 static LIST_HEAD(reg_beacon_list);
 
+/**
+ * enum beacon_hint_type - type of regulatory beacon hint
+ *
+ * Beacons contain useful information for regulatory purposes.
+ * Regular beacons are useful as they indicate to world
+ * roaming stations that an AP is nearby. With careful precautions
+ * taken one can use this to assess whether or not one can lift
+ * passive scan flags and no-ibss flags on a channel.
+ * Beacons also contain certain information elements, the country
+ * IE is very specific to regulatory and contains channels specific
+ * information an AP is indicating should be respected.
+ *
+ * @REG_BEACON: indicates a beacon has been received on a
+ *	specified channel. This is useful for world roaming.
+ * @REG_BEACON_COUNTRY_IE: indicates a beacon has been received
+ *	with a country IE attached.
+ */
+enum beacon_hint_type {
+	REG_BEACON,
+	REG_BEACON_COUNTRY_IE,
+};
+
 struct reg_beacon {
+	enum beacon_hint_type type;
+	struct wiphy *wiphy;
 	struct list_head list;
 	struct ieee80211_channel chan;
+	u8 *ie;
+	u8 ie_len;
 };
 
 /* We keep a static world regulatory domain in case of the absence of CRDA */
@@ -1607,10 +1633,35 @@ static void reg_process_pending_hints(void)
 	spin_unlock(&reg_requests_lock);
 }
 
-/* Processes beacon hints -- this has nothing to do with country IEs */
-static void reg_process_pending_beacon_hints(void)
+static void processs_reg_beacon(struct reg_beacon *reg_beacon)
 {
 	struct cfg80211_registered_device *rdev;
+
+	/* Applies the beacon hint to current wiphys */
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list)
+		wiphy_update_new_beacon(&rdev->wiphy, reg_beacon);
+
+	/* Remembers the beacon hint for new wiphys or reg changes */
+	list_add_tail(&reg_beacon->list, &reg_beacon_list);
+}
+
+
+static void regulatory_hint_11d_work(struct wiphy *wiphy,
+				     u8 *country_ie,
+				     u8 country_ie_len);
+
+static void process_reg_beacon_country_ie(struct reg_beacon *reg_beacon)
+{
+	regulatory_hint_11d_work(reg_beacon->wiphy,
+				 reg_beacon->ie,
+				 reg_beacon->ie_len);
+	kfree(reg_beacon->ie);
+	kfree(reg_beacon);
+}
+
+/* Processes beacon hints */
+static void reg_process_pending_beacon_hints(void)
+{
 	struct reg_beacon *pending_beacon, *tmp;
 
 	mutex_lock(&cfg80211_mutex);
@@ -1628,12 +1679,14 @@ static void reg_process_pending_beacon_hints(void)
 
 		list_del_init(&pending_beacon->list);
 
-		/* Applies the beacon hint to current wiphys */
-		list_for_each_entry(rdev, &cfg80211_rdev_list, list)
-			wiphy_update_new_beacon(&rdev->wiphy, pending_beacon);
-
-		/* Remembers the beacon hint for new wiphys or reg changes */
-		list_add_tail(&pending_beacon->list, &reg_beacon_list);
+		switch (pending_beacon->type) {
+		case REG_BEACON:
+			processs_reg_beacon(pending_beacon);
+			break;
+		case REG_BEACON_COUNTRY_IE:
+			process_reg_beacon_country_ie(pending_beacon);
+			break;
+		}
 	}
 
 	spin_unlock_bh(&reg_pending_beacons_lock);
@@ -1766,6 +1819,37 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 			u8 *country_ie,
 			u8 country_ie_len)
 {
+	struct reg_beacon *reg_beacon;
+
+	reg_beacon = kzalloc(sizeof(struct reg_beacon), GFP_KERNEL);
+	if (!reg_beacon)
+		return;
+
+	reg_beacon->ie = kzalloc(country_ie_len, GFP_KERNEL);
+	if (!reg_beacon->ie) {
+		kfree(reg_beacon);
+		return;
+	}
+
+	reg_beacon->wiphy = wiphy;
+	reg_beacon->ie_len = country_ie_len;
+	reg_beacon->type = REG_BEACON_COUNTRY_IE;
+
+	memcpy(&reg_beacon->ie, country_ie, reg_beacon->ie_len);
+
+	spin_lock_bh(&reg_pending_beacons_lock);
+	list_add_tail(&reg_beacon->list, &reg_pending_beacons);
+	spin_unlock_bh(&reg_pending_beacons_lock);
+
+	schedule_work(&reg_work);
+
+	return;
+}
+
+static void regulatory_hint_11d_work(struct wiphy *wiphy,
+				     u8 *country_ie,
+				     u8 country_ie_len)
+{
 	struct ieee80211_regdomain *rd = NULL;
 	char alpha2[2];
 	u32 checksum = 0;
@@ -1933,6 +2017,7 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
 	memcpy(&reg_beacon->chan, beacon_chan,
 		sizeof(struct ieee80211_channel));
 
+	reg_beacon->type = REG_BEACON;
 
 	/*
 	 * Since we can be called from BH or and non-BH context
-- 
1.6.3.3

