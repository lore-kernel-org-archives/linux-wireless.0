Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38478 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbZIJTaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 15:30:24 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 05/10] ar9170: make use of common macaddr and curbssid
Date: Thu, 10 Sep 2009 15:30:22 -0400
Message-Id: <1252611027-5285-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
References: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are provided by ath_common.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ar9170/ar9170.h |    2 --
 drivers/net/wireless/ath/ar9170/mac.c    |    5 +++--
 drivers/net/wireless/ath/ar9170/main.c   |    6 ++++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index 914e471..c5576ee 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -172,8 +172,6 @@ struct ar9170 {
 
 	/* interface mode settings */
 	struct ieee80211_vif *vif;
-	u8 mac_addr[ETH_ALEN];
-	u8 bssid[ETH_ALEN];
 
 	/* beaconing */
 	struct sk_buff *beacon;
diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
index 0c6273a..ddc8c09 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -311,13 +311,14 @@ static int ar9170_set_promiscouous(struct ar9170 *ar)
 
 int ar9170_set_operating_mode(struct ar9170 *ar)
 {
+	struct ath_common *common = &ar->common;
 	u32 pm_mode = AR9170_MAC_REG_POWERMGT_DEFAULTS;
 	u8 *mac_addr, *bssid;
 	int err;
 
 	if (ar->vif) {
-		mac_addr = ar->mac_addr;
-		bssid = ar->bssid;
+		mac_addr = common->macaddr;
+		bssid = common->curbssid;
 
 		switch (ar->vif->type) {
 		case NL80211_IFTYPE_MESH_POINT:
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index c1f8c69..81c6cf1 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1952,6 +1952,7 @@ static int ar9170_op_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_if_init_conf *conf)
 {
 	struct ar9170 *ar = hw->priv;
+	struct ath_common *common = &ar->common;
 	int err = 0;
 
 	mutex_lock(&ar->mutex);
@@ -1962,7 +1963,7 @@ static int ar9170_op_add_interface(struct ieee80211_hw *hw,
 	}
 
 	ar->vif = conf->vif;
-	memcpy(ar->mac_addr, conf->mac_addr, ETH_ALEN);
+	memcpy(common->macaddr, conf->mac_addr, ETH_ALEN);
 
 	if (modparam_nohwcrypt || (ar->vif->type != NL80211_IFTYPE_STATION)) {
 		ar->rx_software_decryption = true;
@@ -2131,12 +2132,13 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
 				       u32 changed)
 {
 	struct ar9170 *ar = hw->priv;
+	struct ath_common *common = &ar->common;
 	int err = 0;
 
 	mutex_lock(&ar->mutex);
 
 	if (changed & BSS_CHANGED_BSSID) {
-		memcpy(ar->bssid, bss_conf->bssid, ETH_ALEN);
+		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 		err = ar9170_set_operating_mode(ar);
 		if (err)
 			goto out;
-- 
1.6.3.3

