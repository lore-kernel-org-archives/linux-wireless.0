Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1679 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab1ECJgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 25/61] staging: brcm80211: removed all ASSERTs from
 wl_mac80211.c
Date: Tue, 3 May 2011 11:35:25 +0200
Message-ID: <1304415361-7813-26-git-send-email-arend@broadcom.com> (sfid-20110503_113811_404168_1363BEF6)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>


Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   56 ++++++++--------------
 1 files changed, 20 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index c38d080..dd46d2e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -185,10 +185,6 @@ static int wl_ops_start(struct ieee80211_hw *hw)
 
 static void wl_ops_stop(struct ieee80211_hw *hw)
 {
-#ifdef BRCMDBG
-	struct wl_info *wl = hw->priv;
-	ASSERT(wl);
-#endif /*BRCMDBG*/
 	ieee80211_stop_queues(hw);
 }
 
@@ -280,7 +276,6 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 			goto config_out;
 		}
 		wlc_iovar_getint(wl->wlc, "bcn_li_bcn", &new_int);
-		ASSERT(new_int == conf->listen_interval);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
 		wiphy_err(wiphy, "%s: change monitor mode: %s (implement)\n",
@@ -617,13 +612,12 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
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
 		break;
@@ -636,7 +630,7 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
 		if (!status) {
 			wiphy_err(wl->wiphy, "START: tid %d is not agg\'able\n",
 				  tid);
-			return -1;
+			return -EINVAL;
 		}
 		/* XXX: Use the starting sequence number provided ... */
 		*ssn = 0;
@@ -721,7 +715,7 @@ static int wl_set_hint(struct wl_info *wl, char *abbrev)
 static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 			    uint bustype, void *btparam, uint irq)
 {
-	struct wl_info *wl;
+	struct wl_info *wl = NULL;
 	int unit, err;
 
 	unsigned long base_addr;
@@ -737,8 +731,10 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	/* allocate private info */
 	hw = pci_get_drvdata(btparam);	/* btparam == pdev */
-	wl = hw->priv;
-	ASSERT(wl);
+	if (hw != NULL)
+		wl = hw->priv;
+	if (WARN_ON(hw == NULL) || WARN_ON(wl == NULL))
+		return NULL;
 	wl->wiphy = hw->wiphy;
 
 	atomic_set(&wl->callbacks, 0);
@@ -774,7 +770,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 			  "%s\n", KBUILD_MODNAME, "/lib/firmware/brcm");
 		wl_release_fw(wl);
 		wl_remove((struct pci_dev *)btparam);
-		goto fail1;
+		return NULL;
 	}
 
 	/* common load-time initialization */
@@ -789,9 +785,6 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	wl->pub = wlc_pub(wl->wlc);
 
 	wl->pub->ieee_hw = hw;
-	ASSERT(wl->pub->ieee_hw);
-	ASSERT(wl->pub->ieee_hw->priv == wl);
-
 
 	if (wlc_iovar_setint(wl->wlc, "mpc", 0)) {
 		wiphy_err(wl->wiphy, "wl%d: Error setting MPC variable to 0\n",
@@ -816,7 +809,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	}
 
 	memcpy(perm, &wl->pub->cur_etheraddr, ETH_ALEN);
-	ASSERT(is_valid_ether_addr(perm));
+	if (WARN_ON(!is_valid_ether_addr(perm)))
+		goto fail;
 	SET_IEEE80211_PERM_ADDR(hw, perm);
 
 	err = ieee80211_register_hw(hw);
@@ -839,7 +833,6 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 fail:
 	wl_free(wl);
-fail1:
 	return NULL;
 }
 
@@ -1037,8 +1030,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 		}
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl_band_2GHz_nphy;
 	} else {
-		BUG();
-		return -1;
+		return -EPERM;
 	}
 
 	/* Assume all bands use the same phy.  True for 11n devices. */
@@ -1048,7 +1040,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 			hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			    &wl_band_5GHz_nphy;
 		} else {
-			return -1;
+			return -EPERM;
 		}
 	}
 	return 0;
@@ -1098,8 +1090,6 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ieee80211_hw *hw;
 	u32 val;
 
-	ASSERT(pdev);
-
 	WL_TRACE("%s: bus %d slot %d func %d irq %d\n",
 		 __func__, pdev->bus->number, PCI_SLOT(pdev->devfn),
 		 PCI_FUNC(pdev->devfn), pdev->irq);
@@ -1126,8 +1116,7 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw = ieee80211_alloc_hw(sizeof(struct wl_info), &wl_ops);
 	if (!hw) {
 		pr_err("%s: ieee80211_alloc_hw failed\n", __func__);
-		rc = -ENOMEM;
-		goto err_1;
+		return -ENOMEM;
 	}
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
@@ -1145,9 +1134,6 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 	return 0;
- err_1:
-	pr_err("%s: err_1: Major hoarkage\n", __func__);
-	return 0;
 }
 
 static int wl_suspend(struct pci_dev *pdev, pm_message_t state)
@@ -1337,7 +1323,6 @@ static void wl_free(struct wl_info *wl)
 {
 	struct wl_timer *t, *next;
 
-	ASSERT(wl);
 	/* free ucode data */
 	if (wl->fw.fw_cnt)
 		wl_ucode_data_free();
@@ -1533,7 +1518,6 @@ static irqreturn_t BCMFASTPATH wl_isr(int irq, void *dev_id)
 
 			/* ...and call the second level interrupt handler */
 			/* schedule dpc */
-			ASSERT(wl->resched == false);
 			tasklet_schedule(&wl->tasklet);
 		}
 	}
@@ -1661,8 +1645,6 @@ void wl_add_timer(struct wl_info *wl, struct wl_timer *t, uint ms, int periodic)
 			  __func__, t->name, periodic);
 	}
 #endif
-	ASSERT(!t->set);
-
 	t->ms = ms;
 	t->periodic = (bool) periodic;
 	t->set = true;
@@ -1738,8 +1720,6 @@ static int wl_linux_watchdog(void *ctx)
 	uint id;
 	/* refresh stats */
 	if (wl->pub->up) {
-		ASSERT(wl->stats_id < 2);
-
 		cnt = wl->pub->_cnt;
 		id = 1 - wl->stats_id;
 		stats = &wl->stats_watchdog[id];
@@ -1824,14 +1804,18 @@ int wl_ucode_init_uint(struct wl_info *wl, u32 *data, u32 idx)
 		     entry++, hdr++) {
 			if (hdr->idx == idx) {
 				pdata = wl->fw.fw_bin[i]->data + hdr->offset;
-				ASSERT(hdr->len == 4);
+				if (hdr->len != 4) {
+					wiphy_err(wl->wiphy,
+						  "ERROR: fw hdr len\n");
+					return -ENOMSG;
+				}
 				*data = *((u32 *) pdata);
 				return 0;
 			}
 		}
 	}
 	wiphy_err(wl->wiphy, "ERROR: ucode tag:%d can not be found!\n", idx);
-	return -1;
+	return -ENOMSG;
 }
 
 /*
-- 
1.7.4.1


