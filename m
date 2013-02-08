Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3669 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759982Ab3BHO4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/27] brcmfmac: add support for creating P2P client/GO
 interface
Date: Fri, 8 Feb 2013 15:53:37 +0100
Message-ID: <1360335242-12608-3-git-send-email-arend@broadcom.com> (sfid-20130208_163812_936418_CAF7ACAD)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allow the creation of P2P client and group owner
virtual interfaces in the driver.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 +
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   42 +++++++
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  112 +++++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  123 ++++++++++++++++++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   26 ++++-
 5 files changed, 289 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 7c78131..b61254d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -72,6 +72,7 @@
 #define BRCMF_C_SET_WSEC			134
 #define BRCMF_C_GET_PHY_NOISE			135
 #define BRCMF_C_GET_BSS_INFO			136
+#define BRCMF_C_SET_SCB_TIMEOUT			158
 #define BRCMF_C_GET_PHYLIST			180
 #define BRCMF_C_SET_SCAN_CHANNEL_TIME		185
 #define BRCMF_C_SET_SCAN_UNASSOC_TIME		187
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
new file mode 100644
index 0000000..d21d9b2
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+
+#ifndef FWIL_TYPES_H_
+#define FWIL_TYPES_H_
+
+#include <linux/if_ether.h>
+
+enum brcmf_fil_p2p_if_types {
+	BRCMF_FIL_P2P_IF_CLIENT,
+	BRCMF_FIL_P2P_IF_GO,
+	BRCMF_FIL_P2P_IF_DYNBCN_GO,
+	BRCMF_FIL_P2P_IF_DEV,
+};
+
+struct brcmf_fil_p2p_if_le {
+	u8 addr[ETH_ALEN];
+	enum brcmf_fil_p2p_if_types type;
+	__le16 chspec;
+};
+
+struct brcmf_fil_chan_info_le {
+	__le32 hw_channel;
+	__le32 target_channel;
+	__le32 scan_channel;
+};
+
+#endif /* FWIL_TYPES_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 22d9de8..25c6b7d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -23,6 +23,7 @@
 #include <dhd.h>
 #include <dhd_dbg.h>
 #include "fwil.h"
+#include "fwil_types.h"
 #include "p2p.h"
 #include "wl_cfg80211.h"
 
@@ -45,6 +46,8 @@
 #define SOCIAL_CHAN_CNT		3
 #define AF_PEER_SEARCH_CNT	2
 
+#define BRCMF_SCB_TIMEOUT_VALUE	20
+
 /**
  * struct brcmf_p2p_disc_st_le - set discovery state in firmware.
  *
@@ -285,7 +288,7 @@ static s32 brcmf_p2p_init_discovery(struct brcmf_p2p_info *p2p)
 	}
 
 	/* create a vif for it */
-	vif = brcmf_alloc_vif(p2p->cfg, NULL, NL80211_IFTYPE_P2P_DEVICE, false);
+	vif = brcmf_alloc_vif(p2p->cfg, NL80211_IFTYPE_P2P_DEVICE, false);
 	if (IS_ERR(vif)) {
 		brcmf_err("could not create discovery vif\n");
 		kfree(ifp);
@@ -691,6 +694,43 @@ void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
 	memset(p2p, 0, sizeof(*p2p));
 }
 
+static int brcmf_p2p_request_p2p_if(struct brcmf_if *ifp, u8 ea[ETH_ALEN],
+				    enum brcmf_fil_p2p_if_types iftype)
+{
+	struct brcmf_fil_p2p_if_le if_request;
+	struct brcmf_fil_chan_info_le ci;
+	u16 chanspec = 11 & WL_CHANSPEC_CHAN_MASK;
+	int err;
+
+	/* we need a default channel */
+	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_CHANNEL, &ci, sizeof(ci));
+	if (!err) {
+		chanspec = le32_to_cpu(ci.hw_channel) & WL_CHANSPEC_CHAN_MASK;
+		if (chanspec < CH_MAX_2G_CHANNEL)
+			chanspec |= WL_CHANSPEC_BAND_2G;
+		else
+			chanspec |= WL_CHANSPEC_BAND_5G;
+	}
+	chanspec |= WL_CHANSPEC_BW_20 | WL_CHANSPEC_CTL_SB_NONE;
+
+	/* fill the firmware request */
+	memcpy(if_request.addr, ea, ETH_ALEN);
+	if_request.type = iftype;
+	if_request.chspec = cpu_to_le16(chanspec);
+
+	err = brcmf_fil_iovar_data_set(ifp, "p2p_ifadd", &if_request,
+				       sizeof(if_request));
+	if (err)
+		return err;
+
+	if (iftype == BRCMF_FIL_P2P_IF_GO) {
+		/* set station timeout for p2p */
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCB_TIMEOUT,
+					    BRCMF_SCB_TIMEOUT_VALUE);
+	}
+	return err;
+}
+
 /**
  * brcmf_p2p_add_vif() - create a new P2P virtual interface.
  *
@@ -699,16 +739,67 @@ void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
  * @type: nl80211 interface type.
  * @flags: TBD
  * @params: TBD
- *
- * TODO: not yet supported.
  */
 struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 				       enum nl80211_iftype type, u32 *flags,
 				       struct vif_params *params)
 {
-	brcmf_err("enter - not supported yet\n");
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct brcmf_cfg80211_vif *vif;
+	enum brcmf_fil_p2p_if_types iftype;
+	enum wl_mode mode;
+	int err;
+
+	if (brcmf_cfg80211_vif_event_armed(cfg))
+		return ERR_PTR(-EBUSY);
+
 	brcmf_dbg(INFO, "adding vif \"%s\" (type=%d)\n", name, type);
-	return ERR_PTR(-EOPNOTSUPP);
+
+	switch (type) {
+	case NL80211_IFTYPE_P2P_CLIENT:
+		iftype = BRCMF_FIL_P2P_IF_CLIENT;
+		mode = WL_MODE_BSS;
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		iftype = BRCMF_FIL_P2P_IF_GO;
+		mode = WL_MODE_AP;
+		break;
+	default:
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	vif = brcmf_alloc_vif(cfg, type, false);
+	brcmf_cfg80211_arm_vif_event(cfg, vif);
+
+	err = brcmf_p2p_request_p2p_if(ifp, cfg->p2p.int_addr, iftype);
+	if (err)
+		goto fail;
+
+	/* wait for firmware event */
+	err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_ADD,
+						    msecs_to_jiffies(1500));
+	brcmf_cfg80211_arm_vif_event(cfg, NULL);
+	if (!err) {
+		brcmf_err("timeout occurred\n");
+		err = -EIO;
+		goto fail;
+	}
+
+	/* interface created in firmware */
+	ifp = vif->ifp;
+	if (!ifp) {
+		brcmf_err("no if pointer provided\n");
+		err = -ENOENT;
+	}
+
+	strncpy(ifp->ndev->name, name, sizeof(ifp->ndev->name) - 1);
+	brcmf_cfg80211_vif_complete(cfg);
+	return &ifp->vif->wdev;
+
+fail:
+	brcmf_free_vif(vif);
+	return ERR_PTR(err);
 }
 
 /**
@@ -721,9 +812,20 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
  */
 int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
 	struct brcmf_cfg80211_vif *vif;
+	int err;
 
 	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
+
+	if (brcmf_cfg80211_vif_event_armed(cfg))
+		return -EBUSY;
+
+	brcmf_cfg80211_arm_vif_event(cfg, vif);
+	/* wait for firmware event */
+	err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_DEL,
+						    msecs_to_jiffies(1500));
+	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (wdev->netdev)
 		brcmf_dbg(INFO, "deleting vif \"%s\"\n", wdev->netdev->name);
 	else
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 5c4d1fc..6b4e877 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3812,7 +3812,6 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 }
 
 struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
-					   struct net_device *netdev,
 					   enum nl80211_iftype type,
 					   bool pm_block)
 {
@@ -3828,15 +3827,8 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 		return ERR_PTR(-ENOMEM);
 
 	vif->wdev.wiphy = cfg->wiphy;
-	vif->wdev.netdev = netdev;
 	vif->wdev.iftype = type;
 
-	if (netdev) {
-		vif->ifp = netdev_priv(netdev);
-		netdev->ieee80211_ptr = &vif->wdev;
-		SET_NETDEV_DEV(netdev, wiphy_dev(cfg->wiphy));
-	}
-
 	vif->mode = brcmf_nl80211_iftype_to_mode(type);
 	vif->pm_block = pm_block;
 	vif->roam_off = -1;
@@ -4195,6 +4187,57 @@ brcmf_notify_mic_status(struct brcmf_if *ifp,
 	return 0;
 }
 
+static s32 brcmf_notify_vif_event(struct brcmf_if *ifp,
+				  const struct brcmf_event_msg *e, void *data)
+{
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_if_event *ifevent = (struct brcmf_if_event *)data;
+	struct brcmf_cfg80211_vif_event *event = &cfg->vif_event;
+	struct brcmf_cfg80211_vif *vif;
+
+	brcmf_dbg(TRACE, "Enter: action %u flags %u ifidx %u bsscfg %u\n",
+		  ifevent->action, ifevent->flags, ifevent->ifidx,
+		  ifevent->bssidx);
+
+
+	mutex_lock(&event->vif_event_lock);
+	event->action = ifevent->action;
+	vif = event->vif;
+
+	switch (ifevent->action) {
+	case BRCMF_E_IF_ADD:
+		/* waiting process may have timed out */
+		if (!cfg->vif_event.vif)
+			return -EBADF;
+
+		ifp->vif = vif;
+		vif->ifp = ifp;
+		vif->wdev.netdev = ifp->ndev;
+		ifp->ndev->ieee80211_ptr = &vif->wdev;
+		SET_NETDEV_DEV(ifp->ndev, wiphy_dev(cfg->wiphy));
+		mutex_unlock(&event->vif_event_lock);
+		wake_up(&event->vif_wq);
+
+		/* waiting process need to set the netdev name */
+		wait_for_completion(&event->vif_complete);
+		return brcmf_net_attach(ifp);
+
+	case BRCMF_E_IF_DEL:
+		ifp->vif = NULL;
+		brcmf_free_vif(vif);
+		mutex_unlock(&event->vif_event_lock);
+		/* event may not be upon user request */
+		if (brcmf_cfg80211_vif_event_armed(cfg))
+			wake_up(&event->vif_wq);
+		return 0;
+
+	default:
+		mutex_unlock(&event->vif_event_lock);
+		break;
+	}
+	return -EINVAL;
+}
+
 static void brcmf_init_conf(struct brcmf_cfg80211_conf *conf)
 {
 	conf->frag_threshold = (u32)-1;
@@ -4226,6 +4269,8 @@ static void brcmf_register_event_handlers(struct brcmf_cfg80211_info *cfg)
 			    brcmf_notify_connect_status);
 	brcmf_fweh_register(cfg->pub, BRCMF_E_PFN_NET_FOUND,
 			    brcmf_notify_sched_scan_results);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_IF,
+			    brcmf_notify_vif_event);
 }
 
 static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
@@ -4292,6 +4337,13 @@ static void wl_deinit_priv(struct brcmf_cfg80211_info *cfg)
 	brcmf_deinit_priv_mem(cfg);
 }
 
+static void init_vif_event(struct brcmf_cfg80211_vif_event *event)
+{
+	init_waitqueue_head(&event->vif_wq);
+	init_completion(&event->vif_complete);
+	mutex_init(&event->vif_event_lock);
+}
+
 struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 						  struct device *busdev)
 {
@@ -4315,14 +4367,20 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	cfg = wiphy_priv(wiphy);
 	cfg->wiphy = wiphy;
 	cfg->pub = drvr;
+	init_vif_event(&cfg->vif_event);
 	INIT_LIST_HEAD(&cfg->vif_list);
 
-	vif = brcmf_alloc_vif(cfg, ndev, NL80211_IFTYPE_STATION, false);
+	vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_STATION, false);
 	if (IS_ERR(vif)) {
 		wiphy_free(wiphy);
 		return NULL;
 	}
 
+	vif->ifp = ifp;
+	vif->wdev.netdev = ndev;
+	ndev->ieee80211_ptr = &vif->wdev;
+	SET_NETDEV_DEV(ndev, wiphy_dev(cfg->wiphy));
+
 	err = wl_init_priv(cfg);
 	if (err) {
 		brcmf_err("Failed to init iwm_priv (%d)\n", err);
@@ -4585,3 +4643,50 @@ u32 wl_get_vif_state_all(struct brcmf_cfg80211_info *cfg, unsigned long state)
 	}
 	return result;
 }
+
+static inline bool vif_event_equals(struct brcmf_cfg80211_vif_event *event,
+				    u8 action)
+{
+	u8 evt_action;
+
+	mutex_lock(&event->vif_event_lock);
+	evt_action = event->action;
+	mutex_unlock(&event->vif_event_lock);
+	return evt_action == action;
+}
+
+void brcmf_cfg80211_arm_vif_event(struct brcmf_cfg80211_info *cfg,
+				  struct brcmf_cfg80211_vif *vif)
+{
+	struct brcmf_cfg80211_vif_event *event = &cfg->vif_event;
+
+	mutex_lock(&event->vif_event_lock);
+	event->vif = vif;
+	event->action = 0;
+	mutex_unlock(&event->vif_event_lock);
+}
+
+bool brcmf_cfg80211_vif_event_armed(struct brcmf_cfg80211_info *cfg)
+{
+	struct brcmf_cfg80211_vif_event *event = &cfg->vif_event;
+	bool armed;
+
+	mutex_lock(&event->vif_event_lock);
+	armed = event->vif != NULL;
+	mutex_unlock(&event->vif_event_lock);
+
+	return armed;
+}
+int brcmf_cfg80211_wait_vif_event_timeout(struct brcmf_cfg80211_info *cfg,
+					  u8 action, ulong timeout)
+{
+	struct brcmf_cfg80211_vif_event *event = &cfg->vif_event;
+
+	return wait_event_timeout(event->vif_wq,
+				  vif_event_equals(event, action), timeout);
+}
+
+void brcmf_cfg80211_vif_complete(struct brcmf_cfg80211_info *cfg)
+{
+	complete(&cfg->vif_event.vif_complete);
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 014a463..691f613 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -320,6 +320,23 @@ struct brcmf_pno_scanresults_le {
 };
 
 /**
+ * struct brcmf_cfg80211_vif_event - virtual interface event information.
+ *
+ * @vif_wq: waitqueue awaiting interface event from firmware.
+ * @vif_event_lock: protects other members in this structure.
+ * @vif_complete: completion for net attach.
+ * @action: either add, change, or delete.
+ * @vif: virtual interface object related to the event.
+ */
+struct brcmf_cfg80211_vif_event {
+	wait_queue_head_t vif_wq;
+	struct mutex vif_event_lock;
+	struct completion vif_complete;
+	u8 action;
+	struct brcmf_cfg80211_vif *vif;
+};
+
+/**
  * struct brcmf_cfg80211_info - dongle private data of cfg80211 interface
  *
  * @wiphy: wiphy object for cfg80211 interface.
@@ -352,6 +369,7 @@ struct brcmf_pno_scanresults_le {
  * @escan_ioctl_buf: dongle command buffer for escan commands.
  * @vif_list: linked list of vif instances.
  * @vif_cnt: number of vif instances.
+ * @vif_event: vif event signalling.
  */
 struct brcmf_cfg80211_info {
 	struct wiphy *wiphy;
@@ -384,6 +402,7 @@ struct brcmf_cfg80211_info {
 	u8 *escan_ioctl_buf;
 	struct list_head vif_list;
 	u8 vif_cnt;
+	struct brcmf_cfg80211_vif_event vif_event;
 };
 
 /**
@@ -452,7 +471,6 @@ s32 brcmf_cfg80211_up(struct net_device *ndev);
 s32 brcmf_cfg80211_down(struct net_device *ndev);
 
 struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
-					   struct net_device *netdev,
 					   enum nl80211_iftype type,
 					   bool pm_block);
 void brcmf_free_vif(struct brcmf_cfg80211_vif *vif);
@@ -462,5 +480,11 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key);
 u16 channel_to_chanspec(struct ieee80211_channel *ch);
 u32 wl_get_vif_state_all(struct brcmf_cfg80211_info *cfg, unsigned long state);
+void brcmf_cfg80211_arm_vif_event(struct brcmf_cfg80211_info *cfg,
+				  struct brcmf_cfg80211_vif *vif);
+bool brcmf_cfg80211_vif_event_armed(struct brcmf_cfg80211_info *cfg);
+int brcmf_cfg80211_wait_vif_event_timeout(struct brcmf_cfg80211_info *cfg,
+					  u8 action, ulong timeout);
+void brcmf_cfg80211_vif_complete(struct brcmf_cfg80211_info *info);
 
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.10.4


