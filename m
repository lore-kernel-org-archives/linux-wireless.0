Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1666 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162007Ab3DEI6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:09 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/16] brcmfmac: support creation of P2P_DEVICE through
 user-space
Date: Fri, 5 Apr 2013 10:57:50 +0200
Message-ID: <1365152274-4252-13-git-send-email-arend@broadcom.com> (sfid-20130405_105830_516357_E7FC2097)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current driver code creates a P2P_DEVICE through a module
parameter. This device has a dummy netdevice which is not how this
interface type is intended. This patch add proper support for the
P2P_DEVICE interface type. This requires a wpa_supplicant with such
support as well.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  148 ++++++++++++++++++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 +-
 2 files changed, 143 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index e587dfb..5d5d1e4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -15,6 +15,7 @@
  */
 #include <linux/slab.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <net/cfg80211.h>
 
 #include <brcmu_wifi.h>
@@ -455,7 +456,9 @@ static int brcmf_p2p_set_firmware(struct brcmf_if *ifp, u8 *p2p_mac)
 {
 	s32 ret = 0;
 
+	brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
 	brcmf_fil_iovar_int_set(ifp, "apsta", 1);
+	brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 
 	/* In case of COB type, firmware has default mac address
 	 * After Initializing firmware, we have to set current mac address to
@@ -473,21 +476,29 @@ static int brcmf_p2p_set_firmware(struct brcmf_if *ifp, u8 *p2p_mac)
  * brcmf_p2p_generate_bss_mac() - derive mac addresses for P2P.
  *
  * @p2p: P2P specific data.
+ * @dev_addr: optional device address.
  *
- * P2P needs mac addresses for P2P device and interface. These are
- * derived from the primary net device, ie. the permanent ethernet
- * address of the device.
+ * P2P needs mac addresses for P2P device and interface. If no device
+ * address it specified, these are derived from the primary net device, ie.
+ * the permanent ethernet address of the device.
  */
-static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p)
+static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p, u8 *dev_addr)
 {
 	struct brcmf_if *pri_ifp = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
 	struct brcmf_if *p2p_ifp = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->ifp;
+	bool local_admin = false;
+
+	if (!dev_addr || is_zero_ether_addr(dev_addr)) {
+		dev_addr = pri_ifp->mac_addr;
+		local_admin = true;
+	}
 
 	/* Generate the P2P Device Address.  This consists of the device's
 	 * primary MAC address with the locally administered bit set.
 	 */
-	memcpy(p2p->dev_addr, pri_ifp->mac_addr, ETH_ALEN);
-	p2p->dev_addr[0] |= 0x02;
+	memcpy(p2p->dev_addr, dev_addr, ETH_ALEN);
+	if (local_admin)
+		p2p->dev_addr[0] |= 0x02;
 	memcpy(p2p_ifp->mac_addr, p2p->dev_addr, ETH_ALEN);
 
 	/* Generate the P2P Interface Address.  If the discovery and connection
@@ -495,6 +506,7 @@ static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p)
 	 * different from the P2P Device Address, but also locally administered.
 	 */
 	memcpy(p2p->int_addr, p2p->dev_addr, ETH_ALEN);
+	p2p->int_addr[0] |= 0x02;
 	p2p->int_addr[4] ^= 0x80;
 }
 
@@ -1935,7 +1947,7 @@ s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
 
 		p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = p2p_vif;
 
-		brcmf_p2p_generate_bss_mac(p2p);
+		brcmf_p2p_generate_bss_mac(p2p, NULL);
 		brcmf_p2p_set_firmware(pri_ifp, p2p->dev_addr);
 
 		/* Initialize P2P Discovery in the firmware */
@@ -2125,13 +2137,96 @@ static int brcmf_p2p_release_p2p_if(struct brcmf_cfg80211_vif *vif)
 }
 
 /**
+ * brcmf_p2p_create_p2pdev() - create a P2P_DEVICE virtual interface.
+ *
+ * @p2p: P2P specific data.
+ * @wiphy: wiphy device of new interface.
+ * @addr: mac address for this new interface.
+ */
+static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
+						    struct wiphy *wiphy,
+						    u8 *addr)
+{
+	struct brcmf_cfg80211_vif *p2p_vif;
+	struct brcmf_if *p2p_ifp;
+	struct brcmf_if *pri_ifp;
+	int err;
+	u32 bssidx;
+
+	if (p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
+		return ERR_PTR(-ENOSPC);
+
+	p2p_vif = brcmf_alloc_vif(p2p->cfg, NL80211_IFTYPE_P2P_DEVICE,
+				  false);
+	if (IS_ERR(p2p_vif)) {
+		brcmf_err("could not create discovery vif\n");
+		return (struct wireless_dev *)p2p_vif;
+	}
+
+	/* create ifp here */
+	p2p_ifp = kzalloc(sizeof(*p2p_ifp), GFP_KERNEL);
+	if (!p2p_ifp)
+		return ERR_PTR(-ENOMEM);
+
+	p2p_vif->ifp = p2p_ifp;
+	p2p_ifp->vif = p2p_vif;
+
+	p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = p2p_vif;
+	brcmf_p2p_generate_bss_mac(p2p, addr);
+	memcpy(&p2p_vif->wdev.address, p2p->dev_addr, sizeof(p2p->dev_addr));
+
+	pri_ifp = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
+	brcmf_p2p_set_firmware(pri_ifp, p2p->dev_addr);
+
+	/* Initialize P2P Discovery in the firmware */
+	err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
+	if (err < 0) {
+		brcmf_err("set p2p_disc error\n");
+		brcmf_free_vif(p2p_vif);
+		return ERR_PTR(err);
+	}
+	/* obtain bsscfg index for P2P discovery */
+	err = brcmf_fil_iovar_int_get(pri_ifp, "p2p_dev", &bssidx);
+	if (err < 0) {
+		brcmf_err("retrieving discover bsscfg index failed\n");
+		brcmf_free_vif(p2p_vif);
+		return ERR_PTR(err);
+	}
+
+	p2p_ifp->drvr = p2p->cfg->pub;
+	p2p_ifp->bssidx = bssidx;
+
+	init_completion(&p2p->send_af_done);
+	INIT_WORK(&p2p->afx_hdl.afx_work, brcmf_p2p_afx_handler);
+	init_completion(&p2p->afx_hdl.act_frm_scan);
+	init_completion(&p2p->wait_next_af);
+
+	return &p2p_vif->wdev;
+}
+
+/**
+ * brcmf_p2p_delete_p2pdev() - delete P2P_DEVICE virtual interface.
+ *
+ * @vif: virtual interface object to delete.
+ */
+static void brcmf_p2p_delete_p2pdev(struct brcmf_cfg80211_vif *vif)
+{
+	struct brcmf_p2p_info *p2p = &vif->ifp->drvr->config->p2p;
+
+	cfg80211_unregister_wdev(&vif->wdev);
+	p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
+	kfree(vif->ifp);
+	brcmf_free_vif(vif);
+}
+
+/**
  * brcmf_p2p_add_vif() - create a new P2P virtual interface.
  *
  * @wiphy: wiphy device of new interface.
  * @name: name of the new interface.
  * @type: nl80211 interface type.
- * @flags: TBD
- * @params: TBD
+ * @flags: not used.
+ * @params: contains mac address for P2P device.
  */
 struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 				       enum nl80211_iftype type, u32 *flags,
@@ -2158,6 +2253,9 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 		iftype = BRCMF_FIL_P2P_IF_GO;
 		mode = WL_MODE_AP;
 		break;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		return brcmf_p2p_create_p2pdev(&cfg->p2p, wiphy,
+					       params->macaddr);
 	default:
 		return ERR_PTR(-EOPNOTSUPP);
 	}
@@ -2245,6 +2343,8 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 		break;
 
 	case NL80211_IFTYPE_P2P_DEVICE:
+		brcmf_p2p_delete_p2pdev(vif);
+		return 0;
 	default:
 		return -ENOTSUPP;
 		break;
@@ -2276,3 +2376,33 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 
 	return err;
 }
+
+int brcmf_p2p_start_device(struct wiphy *wiphy, struct wireless_dev *wdev)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct brcmf_cfg80211_vif *vif;
+	int err;
+
+	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
+	mutex_lock(&cfg->usr_sync);
+	err = brcmf_p2p_enable_discovery(p2p);
+	if (!err)
+		set_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state);
+	mutex_unlock(&cfg->usr_sync);
+	return err;
+}
+
+void brcmf_p2p_stop_device(struct wiphy *wiphy, struct wireless_dev *wdev)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct brcmf_cfg80211_vif *vif;
+
+	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
+	mutex_lock(&cfg->usr_sync);
+	(void)brcmf_p2p_deinit_discovery(p2p);
+	brcmf_abort_scanning(cfg);
+	clear_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state);
+	mutex_unlock(&cfg->usr_sync);
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d4e1201..cba757b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -482,9 +482,9 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 		return ERR_PTR(-EOPNOTSUPP);
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		return brcmf_p2p_add_vif(wiphy, name, type, flags, params);
 	case NL80211_IFTYPE_UNSPECIFIED:
-	case NL80211_IFTYPE_P2P_DEVICE:
 	default:
 		return ERR_PTR(-EINVAL);
 	}
@@ -594,9 +594,9 @@ int brcmf_cfg80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
 		return -EOPNOTSUPP;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		return brcmf_p2p_del_vif(wiphy, wdev);
 	case NL80211_IFTYPE_UNSPECIFIED:
-	case NL80211_IFTYPE_P2P_DEVICE:
 	default:
 		return -EINVAL;
 	}
@@ -4023,6 +4023,8 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.mgmt_tx = brcmf_cfg80211_mgmt_tx,
 	.remain_on_channel = brcmf_p2p_remain_on_channel,
 	.cancel_remain_on_channel = brcmf_cfg80211_cancel_remain_on_channel,
+	.start_p2p_device = brcmf_p2p_start_device,
+	.stop_p2p_device = brcmf_p2p_stop_device,
 #ifdef CONFIG_NL80211_TESTMODE
 	.testmode_cmd = brcmf_cfg80211_testmode
 #endif
-- 
1.7.10.4


