Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab2CMPLu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 11:11:50 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlegacy: do not nulify il->vif on reset
Date: Tue, 13 Mar 2012 16:11:27 +0100
Message-Id: <1331651487-4403-1-git-send-email-sgruszka@redhat.com> (sfid-20120313_161154_402437_82A0AFA4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This il->vif is dereferenced in different part of iwlegacy code, so do
not nullify it. This should fix random crashes observed in companion
with microcode errors i.e. crash in il3945_config_ap().

Additionally this should address also
WARNING: at drivers/net/wireless/iwlegacy/common.c:4656 il_mac_remove_interface
at least one of the possible reasons of that warning.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    2 --
 drivers/net/wireless/iwlegacy/4965-mac.c |    2 --
 drivers/net/wireless/iwlegacy/common.c   |   15 ++++++++++++---
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 0c12093..faec404 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -2673,8 +2673,6 @@ il3945_bg_restart(struct work_struct *data)
 
 	if (test_and_clear_bit(S_FW_ERROR, &il->status)) {
 		mutex_lock(&il->mutex);
-		/* FIXME: vif can be dereferenced */
-		il->vif = NULL;
 		il->is_open = 0;
 		mutex_unlock(&il->mutex);
 		il3945_down(il);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 7b54dbb..b88bb27 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5651,8 +5651,6 @@ il4965_bg_restart(struct work_struct *data)
 
 	if (test_and_clear_bit(S_FW_ERROR, &il->status)) {
 		mutex_lock(&il->mutex);
-		/* FIXME: do we dereference vif without mutex locked ? */
-		il->vif = NULL;
 		il->is_open = 0;
 
 		__il4965_down(il);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index b42052b..755fe9b 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4508,6 +4508,7 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct il_priv *il = hw->priv;
 	int err;
+	bool reset;
 
 	mutex_lock(&il->mutex);
 	D_MAC80211("enter: type %d, addr %pM\n", vif->type, vif->addr);
@@ -4518,7 +4519,12 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		goto out;
 	}
 
-	if (il->vif) {
+	/*
+	 * We do not support multiple virtual interfaces, but on hardware reset
+	 * we have to add the same interface again.
+	 */
+	reset = (il->vif == vif);
+	if (il->vif && !reset) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -4528,8 +4534,11 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	err = il_set_mode(il);
 	if (err) {
-		il->vif = NULL;
-		il->iw_mode = NL80211_IFTYPE_STATION;
+		IL_WARN("Fail to set mode %d\n", vif->type);
+		if (!reset) {
+			il->vif = NULL;
+			il->iw_mode = NL80211_IFTYPE_STATION;
+		}
 	}
 
 out:
-- 
1.7.1

