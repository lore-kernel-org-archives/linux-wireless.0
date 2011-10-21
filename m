Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3106 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab1JUNzc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 09:55:32 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/17] brcm80211: smac: modified Mac80211 callback
 interface
Date: Fri, 21 Oct 2011 15:55:11 +0200
Message-ID: <1319205319-16891-10-git-send-email-arend@broadcom.com> (sfid-20111021_155540_668331_0CC1D420)
In-Reply-To: <1319205319-16891-1-git-send-email-arend@broadcom.com>
References: <1319205319-16891-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Upon ops_start(), a Mac80211 driver should enable receive functionality to
support monitor mode. Also, upon ops_stop(), it should disable rx.

Driver did not follow this rule so code has been changed.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   84 +++++++++-----------
 1 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 915b741..f38ba17 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -284,6 +284,7 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
 {
 	struct brcms_info *wl = hw->priv;
 	bool blocked;
+	int err;
 
 	ieee80211_wake_queues(hw);
 	spin_lock_bh(&wl->lock);
@@ -292,20 +293,48 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
 	if (!blocked)
 		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
 
-	return 0;
+	spin_lock_bh(&wl->lock);
+	if (!wl->pub->up)
+		err = brcms_up(wl);
+	else
+		err = -ENODEV;
+	spin_unlock_bh(&wl->lock);
+
+	if (err != 0)
+		wiphy_err(hw->wiphy, "%s: brcms_up() returned %d\n", __func__,
+			  err);
+	return err;
 }
 
 static void brcms_ops_stop(struct ieee80211_hw *hw)
 {
+	struct brcms_info *wl = hw->priv;
+	int status;
+
 	ieee80211_stop_queues(hw);
+
+	if (wl->wlc == NULL)
+		return;
+
+	spin_lock_bh(&wl->lock);
+	status = brcms_c_chipmatch(wl->wlc->hw->vendorid,
+				   wl->wlc->hw->deviceid);
+	spin_unlock_bh(&wl->lock);
+	if (!status) {
+		wiphy_err(wl->wiphy,
+			  "wl: brcms_ops_stop: chipmatch failed\n");
+		return;
+	}
+
+	/* put driver in down state */
+	spin_lock_bh(&wl->lock);
+	brcms_down(wl);
+	spin_unlock_bh(&wl->lock);
 }
 
 static int
 brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	struct brcms_info *wl;
-	int err;
-
 	/* Just STA for now */
 	if (vif->type != NL80211_IFTYPE_AP &&
 	    vif->type != NL80211_IFTYPE_MESH_POINT &&
@@ -317,32 +346,12 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		return -EOPNOTSUPP;
 	}
 
-	wl = hw->priv;
-	spin_lock_bh(&wl->lock);
-	if (!wl->pub->up)
-		err = brcms_up(wl);
-	else
-		err = -ENODEV;
-	spin_unlock_bh(&wl->lock);
-
-	if (err != 0)
-		wiphy_err(hw->wiphy, "%s: brcms_up() returned %d\n", __func__,
-			  err);
-
-	return err;
+	return 0;
 }
 
 static void
 brcms_ops_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	struct brcms_info *wl;
-
-	wl = hw->priv;
-
-	/* put driver in down state */
-	spin_lock_bh(&wl->lock);
-	brcms_down(wl);
-	spin_unlock_bh(&wl->lock);
 }
 
 static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
@@ -874,37 +883,18 @@ static void brcms_free(struct brcms_info *wl)
 }
 
 /*
-* called from both kernel as from this kernel module.
+* called from both kernel as from this kernel module (error flow on attach)
 * precondition: perimeter lock is not acquired.
 */
 static void brcms_remove(struct pci_dev *pdev)
 {
-	struct brcms_info *wl;
-	struct ieee80211_hw *hw;
-	int status;
-
-	hw = pci_get_drvdata(pdev);
-	wl = hw->priv;
-	if (!wl) {
-		pr_err("wl: brcms_remove: pci_get_drvdata failed\n");
-		return;
-	}
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct brcms_info *wl = hw->priv;
 
-	spin_lock_bh(&wl->lock);
-	status = brcms_c_chipmatch(pdev->vendor, pdev->device);
-	spin_unlock_bh(&wl->lock);
-	if (!status) {
-		wiphy_err(wl->wiphy, "wl: brcms_remove: chipmatch "
-				     "failed\n");
-		return;
-	}
 	if (wl->wlc) {
 		wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, false);
 		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
 		ieee80211_unregister_hw(hw);
-		spin_lock_bh(&wl->lock);
-		brcms_down(wl);
-		spin_unlock_bh(&wl->lock);
 	}
 	pci_disable_device(pdev);
 
-- 
1.7.4.1


