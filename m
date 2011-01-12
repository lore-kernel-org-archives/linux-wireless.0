Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1397 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab1ALR7k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 12:59:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH] staging: brcm80211: fix suspend/resume issue in
 brcmsmac
Date: Wed, 12 Jan 2011 18:59:27 +0100
Message-ID: <1294855167-3718-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PCI PM suspend callback took down the interface and resume brought
it back up. In the mac80211 context this is done in subsequent calls.
Rework implementation so that suspend only stores config, and sets
PCI power state. The resume return to full power state (D0), restores
the config, and brings hardware back up. Full bringup is done by
subsequent mac80211 calls.

Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   28 ++++++++++++---------
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.h |    4 +--
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index c2663bd..8f11409 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -179,7 +179,6 @@ static void wl_ops_stop(struct ieee80211_hw *hw)
 	struct wl_info *wl = hw->priv;
 	ASSERT(wl);
 	WL_LOCK(wl);
-	wl_down(wl);
 	ieee80211_stop_queues(hw);
 	WL_UNLOCK(wl);
 
@@ -216,6 +215,14 @@ wl_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 static void
 wl_ops_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
+	struct wl_info *wl;
+
+	wl = HW_TO_WL(hw);
+
+	/* put driver in down state */
+	WL_LOCK(wl);
+	wl_down(wl);
+	WL_UNLOCK(wl);
 	return;
 }
 
@@ -1059,7 +1066,6 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 }
 
-#ifdef LINUXSTA_PS
 static int wl_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct wl_info *wl;
@@ -1074,11 +1080,12 @@ static int wl_suspend(struct pci_dev *pdev, pm_message_t state)
 		return -ENODEV;
 	}
 
+	/* only need to flag hw is down for proper resume */
 	WL_LOCK(wl);
-	wl_down(wl);
 	wl->pub->hw_up = false;
 	WL_UNLOCK(wl);
-	pci_save_state(pdev, wl->pci_psstate);
+
+	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	return pci_set_power_state(pdev, PCI_D3hot);
 }
@@ -1102,7 +1109,7 @@ static int wl_resume(struct pci_dev *pdev)
 	if (err)
 		return err;
 
-	pci_restore_state(pdev, wl->pci_psstate);
+	pci_restore_state(pdev);
 
 	err = pci_enable_device(pdev);
 	if (err)
@@ -1114,13 +1121,12 @@ static int wl_resume(struct pci_dev *pdev)
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
-	WL_LOCK(wl);
-	err = wl_up(wl);
-	WL_UNLOCK(wl);
-
+	/*
+	*  done. driver will be put in up state
+	*  in wl_ops_add_interface() call.
+	*/
 	return err;
 }
-#endif				/* LINUXSTA_PS */
 
 static void wl_remove(struct pci_dev *pdev)
 {
@@ -1155,10 +1161,8 @@ static void wl_remove(struct pci_dev *pdev)
 static struct pci_driver wl_pci_driver = {
 	.name  = KBUILD_MODNAME,
 	.probe = wl_pci_probe,
-#ifdef LINUXSTA_PS
 	.suspend = wl_suspend,
 	.resume  = wl_resume,
-#endif				/* LINUXSTA_PS */
 	.remove   = __devexit_p(wl_remove),
 	.id_table = wl_id_table,
 };
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
index 070fa94..f6b7354 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
@@ -67,9 +67,7 @@ struct wl_info {
 	struct wl_timer *timers;	/* timer cleanup queue */
 	struct tasklet_struct tasklet;	/* dpc tasklet */
 	bool resched;		/* dpc needs to be and is rescheduled */
-#ifdef LINUXSTA_PS
-	u32 pci_psstate[16];	/* pci ps-state save/restore */
-#endif
+
 	/* RPC, handle, lock, txq, workitem */
 	uint stats_id;		/* the current set of stats */
 	/* ping-pong stats counters updated by Linux watchdog */
-- 
1.7.1


