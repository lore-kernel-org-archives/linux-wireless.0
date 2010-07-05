Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61205 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab0GETwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 15:52:32 -0400
Received: by pwi5 with SMTP id 5so1598384pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jul 2010 12:52:32 -0700 (PDT)
From: greearb@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [ath9k] ath9k:  Expose virtual wiphy indexes to debugfs.
Date: Mon,  5 Jul 2010 12:52:25 -0700
Message-Id: <1278359545-29013-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It is very difficult to map phyX devices to real/virtual
entities because the phyX devices change on module
reload.  This patch makes it slightly easier to
associate virtual phy devices with phyX entities.

 # echo add=5 > /debug/ath9k/phy0/wiphy
 # cat /debug/ath9k/phy0/wiphy
primary: phy0 (ACTIVE chan=0 ht=0)
secondary[5]: phy1 (ACTIVE chan=0 ht=0)
addr: ef:be:ad:de:ef:be
addrmask: ef:be:ad:de:ef:be

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 6e486a5... a58ff60... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 54aae93... f63423c... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 89423ca... 03fd64d... M	drivers/net/wireless/ath/ath9k/virtual.c
 drivers/net/wireless/ath/ath9k/ath9k.h   |    2 +-
 drivers/net/wireless/ath/ath9k/debug.c   |   12 ++++++++----
 drivers/net/wireless/ath/ath9k/virtual.c |   26 ++++++++++++++++++++------
 3 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 6e486a5..a58ff60 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -670,7 +670,7 @@ void ath9k_ps_wakeup(struct ath_softc *sc);
 void ath9k_ps_restore(struct ath_softc *sc);
 
 void ath9k_set_bssid_mask(struct ieee80211_hw *hw);
-int ath9k_wiphy_add(struct ath_softc *sc);
+int ath9k_wiphy_add(struct ath_softc *sc, const char* id);
 int ath9k_wiphy_del(struct ath_wiphy *aphy);
 void ath9k_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb);
 int ath9k_wiphy_pause(struct ath_wiphy *aphy);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 54aae93..f63423c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -503,8 +503,8 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 		if (aphy == NULL)
 			continue;
 		len += snprintf(buf + len, sizeof(buf) - len,
-				"secondary: %s (%s chan=%d ht=%d)\n",
-				wiphy_name(aphy->hw->wiphy),
+				"secondary[%i]: %s (%s chan=%d ht=%d)\n",
+				i, wiphy_name(aphy->hw->wiphy),
 				ath_wiphy_state_str(aphy->state),
 				aphy->chan_idx, aphy->chan_is_ht);
 	}
@@ -589,8 +589,12 @@ static ssize_t write_file_wiphy(struct file *file, const char __user *user_buf,
 	if (len > 0 && buf[len - 1] == '\n')
 		buf[len - 1] = '\0';
 
-	if (strncmp(buf, "add", 3) == 0) {
-		int res = ath9k_wiphy_add(sc);
+	if (strncmp(buf, "add=", 4) == 0) {
+		int res = ath9k_wiphy_add(sc, buf + 4);
+		if (res < 0)
+			return res;
+	} else if (strncmp(buf, "add", 3) == 0) {
+		int res = ath9k_wiphy_add(sc, NULL);
 		if (res < 0)
 			return res;
 	} else if (strncmp(buf, "del=", 4) == 0) {
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index 89423ca..03fd64d 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -99,9 +99,10 @@ void ath9k_set_bssid_mask(struct ieee80211_hw *hw)
 	ath_hw_setbssidmask(common);
 }
 
-int ath9k_wiphy_add(struct ath_softc *sc)
+int ath9k_wiphy_add(struct ath_softc *sc, const char* id)
 {
 	int i, error;
+	int nid = 0;
 	struct ath_wiphy *aphy;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ieee80211_hw *hw;
@@ -112,16 +113,26 @@ int ath9k_wiphy_add(struct ath_softc *sc)
 		return -ENOMEM;
 
 	spin_lock_bh(&sc->wiphy_lock);
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
+	if (id && id[0]) {
+		nid = simple_strtoul(id, NULL, 0);
+		if (nid < 0 || nid > 10000) { /* 10,000 should be plenty! */
+			printk("ath9k: id out of range in wiphy_add:"
+                               " %i, ignoring.", nid);
+			nid = 0;
+		}
+	}
+	
+	for (i = nid; i < sc->num_sec_wiphy; i++) {
 		if (sc->sec_wiphy[i] == NULL)
 			break;
 	}
 
-	if (i == sc->num_sec_wiphy) {
+	if (i >= sc->num_sec_wiphy) {
 		/* No empty slot available; increase array length */
 		struct ath_wiphy **n;
+		int q;
 		n = krealloc(sc->sec_wiphy,
-			     (sc->num_sec_wiphy + 1) *
+			     (i + 1) *
 			     sizeof(struct ath_wiphy *),
 			     GFP_ATOMIC);
 		if (n == NULL) {
@@ -129,9 +140,12 @@ int ath9k_wiphy_add(struct ath_softc *sc)
 			ieee80211_free_hw(hw);
 			return -ENOMEM;
 		}
-		n[i] = NULL;
+		// Null out any new memory allocated.
+		for (q = sc->num_sec_wiphy; q <= i; q++) {
+			n[q] = NULL;
+		}
 		sc->sec_wiphy = n;
-		sc->num_sec_wiphy++;
+		sc->num_sec_wiphy = i+1;
 	}
 
 	SET_IEEE80211_DEV(hw, sc->dev);
-- 
1.7.0.1

