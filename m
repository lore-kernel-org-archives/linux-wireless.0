Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3003 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab1DRJcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 05:32:04 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] staging: brcm80211: removed all ASSERTs from
 wl_mac80211.c
Date: Mon, 18 Apr 2011 11:31:47 +0200
Message-ID: <1303119108-32487-3-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303119108-32487-1-git-send-email-rvossen@broadcom.com>
References: <1303119108-32487-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   60 +++++++---------------
 1 files changed, 19 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index ba4d6de..169d26b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -188,10 +188,6 @@ static int wl_ops_start(struct ieee80211_hw *hw)
 
 static void wl_ops_stop(struct ieee80211_hw *hw)
 {
-#ifdef BRCMDBG
-	struct wl_info *wl = hw->priv;
-	ASSERT(wl);
-#endif /*BRCMDBG*/
 	ieee80211_stop_queues(hw);
 }
 
@@ -283,7 +279,6 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 			goto config_out;
 		}
 		wlc_iovar_getint(wl->wlc, "bcn_li_bcn", &new_int);
-		ASSERT(new_int == conf->listen_interval);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
 		wiphy_err(wiphy, "%s: change monitor mode: %s (implement)\n",
@@ -635,13 +630,12 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
 		    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
 		    u8 buf_size)
 {
-#if defined(BCMDBG)
 	struct scb *scb = (struct scb *)sta->drv_priv;
-#endif
 	struct wl_info *wl = hw->priv;
 	int status;
 
-	ASSERT(scb->magic == SCB_MAGIC);
+	if (WARN_ON(scb->magic != SCB_MAGIC))
+		return -EIDRM;
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		no_printk("%s: action = IEEE80211_AMPDU_RX_START\n", __func__);
@@ -656,7 +650,7 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
 		if (!status) {
 			dev_err(wl->dev, "START: tid %d is not agg\'able\n",
 				tid);
-			return -1;
+			return -EINVAL;
 		}
 		/* XXX: Use the starting sequence number provided ... */
 		*ssn = 0;
@@ -746,7 +740,7 @@ static int wl_set_hint(struct wl_info *wl, char *abbrev)
 static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 			    uint bustype, void *btparam, uint irq)
 {
-	struct wl_info *wl;
+	struct wl_info *wl = NULL;
 	int unit, err;
 
 	unsigned long base_addr;
@@ -759,14 +753,10 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	/* allocate private info */
 	hw = pci_get_drvdata(btparam);	/* btparam == pdev */
-	wl = hw->priv;
-	ASSERT(wl);
-	wl->dev = &hw->wiphy->dev;
-
-	if (unit < 0) {
-		dev_err(wl->dev, "wl%d: unit number overflow, exiting\n", unit);
+	if (hw != NULL)
+		wl = hw->priv;
+	if (WARN_ON(hw == NULL) || WARN_ON(wl == NULL))
 		return NULL;
-	}
 
 	atomic_set(&wl->callbacks, 0);
 
@@ -801,7 +791,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 			KBUILD_MODNAME, "/lib/firmware/brcm");
 		wl_release_fw(wl);
 		wl_remove((struct pci_dev *)btparam);
-		goto fail1;
+		return NULL;
 	}
 
 	/* common load-time initialization */
@@ -817,9 +807,6 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	wl->pub = wlc_pub(wl->wlc);
 
 	wl->pub->ieee_hw = hw;
-	ASSERT(wl->pub->ieee_hw);
-	ASSERT(wl->pub->ieee_hw->priv == wl);
-
 
 	if (wlc_iovar_setint(wl->wlc, "mpc", 0)) {
 		dev_err(wl->dev, "wl%d: Error setting MPC variable to 0\n",
@@ -844,7 +831,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	}
 
 	memcpy(perm, &wl->pub->cur_etheraddr, ETH_ALEN);
-	ASSERT(is_valid_ether_addr(perm));
+	if (WARN_ON(!is_valid_ether_addr(perm)))
+		goto fail;
 	SET_IEEE80211_PERM_ADDR(hw, perm);
 
 	err = ieee80211_register_hw(hw);
@@ -867,7 +855,6 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 fail:
 	wl_free(wl);
-fail1:
 	return NULL;
 }
 
@@ -1066,8 +1053,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 		}
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl_band_2GHz_nphy;
 	} else {
-		BUG();
-		return -1;
+		return -EPERM;
 	}
 
 	/* Assume all bands use the same phy.  True for 11n devices. */
@@ -1077,7 +1063,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 			hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			    &wl_band_5GHz_nphy;
 		} else {
-			return -1;
+			return -EPERM;
 		}
 	}
 
@@ -1130,8 +1116,6 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ieee80211_hw *hw;
 	u32 val;
 
-	ASSERT(pdev);
-
 	WL_TRACE("%s: bus %d slot %d func %d irq %d\n",
 		 __func__, pdev->bus->number, PCI_SLOT(pdev->devfn),
 		 PCI_FUNC(pdev->devfn), pdev->irq);
@@ -1158,8 +1142,7 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw = ieee80211_alloc_hw(sizeof(struct wl_info), &wl_ops);
 	if (!hw) {
 		pr_err("%s: ieee80211_alloc_hw failed\n", __func__);
-		rc = -ENOMEM;
-		goto err_1;
+		return -ENOMEM;
 	}
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
@@ -1177,9 +1160,6 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 	return 0;
- err_1:
-	pr_err("%s: err_1: Major hoarkage\n", __func__);
-	return 0;
 }
 
 static int wl_suspend(struct pci_dev *pdev, pm_message_t state)
@@ -1370,7 +1350,6 @@ static void wl_free(struct wl_info *wl)
 {
 	struct wl_timer *t, *next;
 
-	ASSERT(wl);
 	/* free ucode data */
 	if (wl->fw.fw_cnt)
 		wl_ucode_data_free();
@@ -1566,7 +1545,6 @@ static irqreturn_t BCMFASTPATH wl_isr(int irq, void *dev_id)
 
 			/* ...and call the second level interrupt handler */
 			/* schedule dpc */
-			ASSERT(wl->resched == false);
 			tasklet_schedule(&wl->tasklet);
 		}
 	}
@@ -1694,8 +1672,6 @@ void wl_add_timer(struct wl_info *wl, struct wl_timer *t, uint ms, int periodic)
 			__func__, t->name, periodic);
 	}
 #endif
-	ASSERT(!t->set);
-
 	t->ms = ms;
 	t->periodic = (bool) periodic;
 	t->set = true;
@@ -1771,8 +1747,6 @@ static int wl_linux_watchdog(void *ctx)
 	uint id;
 	/* refresh stats */
 	if (wl->pub->up) {
-		ASSERT(wl->stats_id < 2);
-
 		cnt = wl->pub->_cnt;
 		id = 1 - wl->stats_id;
 		stats = &wl->stats_watchdog[id];
@@ -1858,14 +1832,18 @@ int wl_ucode_init_uint(struct wl_info *wl, u32 *data, u32 idx)
 		     entry++, hdr++) {
 			if (hdr->idx == idx) {
 				pdata = wl->fw.fw_bin[i]->data + hdr->offset;
-				ASSERT(hdr->len == 4);
+				if (hdr->len != 4) {
+					dev_err(wl->dev,
+						"ERROR: fw hdr len\n");
+					return -ENOMSG;
+				}
 				*data = *((u32 *) pdata);
 				return 0;
 			}
 		}
 	}
 	dev_err(wl->dev, "ERROR: ucode tag:%d can not be found!\n", idx);
-	return -1;
+	return -ENOMSG;
 }
 
 /*
-- 
1.7.1


