Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F114AA005
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368044; cv=none; b=gYyQjiE8ZAezHxPGao4FJyb0VAwMe6dg/cg7voHaAVd2NWb//fsEmgEcy2MNH1FftLdwg82u+rLzmdWfgjqyFSeZMfIweKgMmYavgt1OCNpKiisLOa7aHrXYOa2eoKPgKEtk7T0VpvDXhKxiTas5DxqqVuJI+v7gorU6GmHBZLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368044; c=relaxed/simple;
	bh=71/A7JOSPnaeOof3P2wOPcISQe+UV4RiYHzf/JxFJ8s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mWeCVGkJQmXzEjj7LjYUTakEVC8+bA0+caBIjKs8wcoQyBzGZzW2dOal1QDekDGbs08N9VVupngNNWy05B9U8zwD1YR8cbLY4ejcPA3dmkbRC/RKx0Bi+TGJVosEw9kki5AQq58B4y3Pa482xIYwf5siCaY+9BH+9gKyGHG85XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=NCDnZfnz; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="NCDnZfnz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788368042; x=1819904042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=71/A7JOSPnaeOof3P2wOPcISQe+UV4RiYHzf/JxFJ8s=;
  b=NCDnZfnzVlLhIW3IbRauni+cjWvRrCM3/EL2VTX0HZi0ICTdRF8XH1cY
   Dc7ldNdNmOJMR/ochkkTp+OJde7NW7hflk0K6cUk2t6ACMNvAbv7shmTa
   Fm4JUA4hxB18SyJs+XUkjVnDhsoFMp4cglNUDNXx9ax4iuCaLakXuadXn
   o=;
X-CSE-ConnectionGUID: PQnq2EH/RyGseh9G4EwW0Q==
X-CSE-MsgGUID: 130U9IMBSLK09fk+GD8aXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="159196556"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="159196556"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE805.infineon.com) ([172.23.29.31])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:53:59 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE805.infineon.com
 (172.23.29.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:53:59 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:53:57 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 13/25] wifi: inffmac: add interface.c/h
Date: Wed, 2 Sep 2026 16:50:44 +0000
Message-ID: <20260902165057.456447-14-gokulkumar.sivakumar@infineon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
References: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE813.infineon.com (172.23.29.39) To
 MUCSE827.infineon.com (172.23.29.20)

Implementions the functions for creating, mananging and deleting various
type of WLAN interfaces.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 .../net/wireless/infineon/inffmac/interface.c | 496 ++++++++++++++++++
 .../net/wireless/infineon/inffmac/interface.h | 155 ++++++
 2 files changed, 651 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/interface.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/interface.h

diff --git a/drivers/net/wireless/infineon/inffmac/interface.c b/drivers/net/wireless/infineon/inffmac/interface.c
new file mode 100644
index 000000000000..25cb28d08ebc
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/interface.c
@@ -0,0 +1,496 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/etherdevice.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/string.h>
+#include <net/cfg80211.h>
+#include <net/netlink.h>
+
+#include "main.h"
+#include "utils.h"
+#include "chan.h"
+#include "debug.h"
+#include "bus_proto.h"
+#include "fwsignal.h"
+#include "cfg80211.h"
+#include "interface.h"
+#include "feature.h"
+#include "dev_cmd.h"
+#include "dev_evt.h"
+#include "net.h"
+#include "chip.h"
+
+void
+inff_cp_cfg80211_link_down(struct inff_if *ifp)
+{
+	struct net_device *ndev = ifp->ndev;
+
+	if (!test_and_clear_bit(INFF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state))
+		return;
+
+	cfg80211_disconnected(ndev, 0, NULL, 0, true, GFP_KERNEL);
+}
+
+void
+inff_link_down(struct inff_cfg80211_vif *vif, u16 reason,
+	       bool locally_generated)
+{
+	struct inff_cfg80211_info *cfg = wiphy_to_cfg(vif->wdev.wiphy);
+	struct inff_pub *drvr = cfg->pub;
+	bool bus_up = drvr->bus_if->state == INFF_BUS_UP;
+	s32 err = 0;
+
+	if (test_and_clear_bit(INFF_VIF_STATUS_CONNECTED, &vif->sme_state)) {
+		if (bus_up) {
+			inff_dbg(INFO, "Call WLC_DISASSOC to stop excess roaming\n");
+			err = inff_fwcmd_data_set(vif->ifp,
+						  INFF_C_DISASSOC, NULL, 0);
+			if (err)
+				iphy_err(drvr, "WLC_DISASSOC failed (%d)\n", err);
+		}
+
+		if (vif->wdev.iftype == NL80211_IFTYPE_STATION)
+			cfg80211_disconnected(vif->wdev.netdev, reason, NULL, 0,
+					      locally_generated, GFP_KERNEL);
+	}
+	clear_bit(INFF_VIF_STATUS_CONNECTING, &vif->sme_state);
+	clear_bit(INFF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state);
+	clear_bit(INFF_VIF_STATUS_ASSOC_SUCCESS, &vif->sme_state);
+	clear_bit(INFF_SCAN_STATUS_SUPPRESS, &cfg->scan_status);
+}
+
+static bool
+inff_vif_event_equals(struct inff_cfg80211_vif_event *event,
+		      u8 action)
+{
+	u8 evt_action;
+
+	spin_lock(&event->vif_event_lock);
+	evt_action = event->action;
+	spin_unlock(&event->vif_event_lock);
+	return evt_action == action;
+}
+
+void
+inff_arm_vif_event(struct inff_cfg80211_info *cfg,
+		   struct inff_cfg80211_vif *vif)
+{
+	struct inff_cfg80211_vif_event *event = &cfg->vif_event;
+
+	spin_lock(&event->vif_event_lock);
+	event->vif = vif;
+	event->action = 0;
+	spin_unlock(&event->vif_event_lock);
+}
+
+void
+inff_disarm_vif_event(struct inff_cfg80211_info *cfg)
+{
+	struct inff_cfg80211_vif_event *event = &cfg->vif_event;
+
+	spin_lock(&event->vif_event_lock);
+	event->vif = NULL;
+	event->action = 0;
+	spin_unlock(&event->vif_event_lock);
+}
+
+bool
+inff_vif_event_armed(struct inff_cfg80211_info *cfg)
+{
+	struct inff_cfg80211_vif_event *event = &cfg->vif_event;
+	bool armed;
+
+	spin_lock(&event->vif_event_lock);
+	armed = (event->vif) ? true : false;
+	spin_unlock(&event->vif_event_lock);
+
+	return armed;
+}
+
+int
+inff_wait_vif_event(struct inff_cfg80211_info *cfg,
+		    u8 action, ulong timeout)
+{
+	struct inff_cfg80211_vif_event *event = &cfg->vif_event;
+
+	return wait_event_timeout(event->vif_wq,
+				  inff_vif_event_equals(event, action),
+				  timeout);
+}
+
+int
+inff_vif_change_validate(struct inff_cfg80211_info *cfg,
+			 struct inff_cfg80211_vif *vif,
+			 enum nl80211_iftype new_type)
+{
+	struct inff_cfg80211_vif *pos;
+	bool check_combos = false;
+	int ret = 0;
+	struct iface_combination_params params = {
+		.num_different_channels = 1,
+	};
+
+	list_for_each_entry(pos, &cfg->vif_list, list)
+		if (pos == vif) {
+			params.iftype_num[new_type]++;
+		} else {
+			/* concurrent interfaces so need check combinations */
+			check_combos = true;
+			params.iftype_num[pos->wdev.iftype]++;
+		}
+
+	if (check_combos)
+		ret = cfg80211_check_combinations(cfg->wiphy, &params);
+
+	return ret;
+}
+
+bool
+inff_check_vif_up(struct inff_cfg80211_vif *vif)
+{
+	if (!test_bit(INFF_VIF_STATUS_READY, &vif->sme_state)) {
+		inff_dbg(INFO, "device is not ready : status (%lu)\n",
+			 vif->sme_state);
+		return false;
+	}
+	return true;
+}
+
+static void
+inff_set_vif_macaddr(struct inff_if *ifp, u8 *mac_addr)
+{
+	u8 mac_idx = ifp->drvr->sta_mac_idx;
+
+	/* set difference MAC address with locally administered bit */
+	memcpy(mac_addr, ifp->mac_addr, ETH_ALEN);
+	mac_addr[0] |= 0x02;
+	mac_addr[3] ^= mac_idx ? 0xC0 : 0xA0;
+	mac_idx++;
+	mac_idx = mac_idx % 2;
+	ifp->drvr->sta_mac_idx = mac_idx;
+}
+
+static int
+inff_vif_req_create(struct inff_if *ifp, enum nl80211_iftype type,
+		    u8 *vif_macaddr)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	struct inff_interface_create_v3 iface_v3;
+	u8 macaddr[ETH_ALEN];
+	u32 iface_create_ver = 0;
+	u8 iftype;
+	int err;
+
+	switch (type) {
+	case NL80211_IFTYPE_STATION:
+		iftype = INFF_INTERFACE_CREATE_STA;
+		if (!is_zero_ether_addr(vif_macaddr))
+			memcpy(macaddr, vif_macaddr, ETH_ALEN);
+		else
+			inff_set_vif_macaddr(ifp, macaddr);
+		break;
+	case NL80211_IFTYPE_AP:
+		iftype = INFF_INTERFACE_CREATE_AP;
+		inff_set_vif_macaddr(ifp, macaddr);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		goto fail;
+	}
+
+	switch (drvr->bus_if->chip) {
+	case INF_CC_ACW74XX_CHIP_ID:
+		fallthrough;
+	case INF_CC_CYW5591X_CHIP_ID:
+		/* interface_create version 3+ */
+		/* get supported version from firmware side */
+		err = inff_fwcmd_bsscfg_int_get(ifp, "interface_create",
+						&iface_create_ver);
+		if (err) {
+			iphy_err(drvr,
+				 "failed to get interface create ver, err=%d\n",
+				 err);
+			err = -EOPNOTSUPP;
+			break;
+		}
+
+		switch (iface_create_ver) {
+		case INFF_INTERFACE_CREATE_VER_3:
+			memset(&iface_v3, 0, sizeof(iface_v3));
+			iface_v3.ver = INFF_INTERFACE_CREATE_VER_3;
+			iface_v3.flags = INFF_INTERFACE_MAC_USE;
+			iface_v3.iftype = iftype;
+			memcpy(iface_v3.mac_addr, macaddr, ETH_ALEN);
+
+			err = inff_fwcmd_iovar_data_get(ifp, "interface_create",
+							&iface_v3, sizeof(iface_v3));
+			break;
+		default:
+			inff_err("unsupported interface create ver (v%d)\n",
+				 iface_create_ver);
+			err = -EOPNOTSUPP;
+			break;
+		}
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+fail:
+	if (err) {
+		iphy_err(drvr,
+			 "failed to request interface creation, err=%d\n",
+			 err);
+		return -EIO;
+	}
+
+	inff_dbg(INFO, "requested interface creation\n");
+
+	return 0;
+}
+
+/**
+ * inff_apsta_add_vif() - create a new AP or STA virtual interface
+ *
+ * @wiphy: wiphy device of new interface.
+ * @name: name of the new interface.
+ * @params: contains mac address for AP or STA device.
+ * @type: interface type.
+ *
+ * Return: pointer to new vif on success, ERR_PTR(-errno) if not
+ */
+struct wireless_dev *
+inff_apsta_add_vif(struct wiphy *wiphy, const char *name,
+		   struct vif_params *params,
+		   enum nl80211_iftype type)
+{
+	struct inff_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct inff_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct inff_pub *drvr = cfg->pub;
+	struct inff_cfg80211_vif *vif;
+	int err;
+
+	if (type != NL80211_IFTYPE_STATION && type != NL80211_IFTYPE_AP)
+		return ERR_PTR(-EINVAL);
+
+	if (inff_vif_event_armed(cfg))
+		return ERR_PTR(-EBUSY);
+
+	inff_dbg(INFO, "Adding vif \"%s\"\n", name);
+
+	vif = inff_alloc_vif(cfg, type);
+	if (IS_ERR(vif))
+		return (struct wireless_dev *)vif;
+
+	inff_arm_vif_event(cfg, vif);
+
+	err = inff_vif_req_create(ifp, type, params->macaddr);
+	if (err)
+		goto fail;
+
+	/* wait for firmware event */
+	err = inff_wait_vif_event(cfg, INFF_E_IF_ADD,
+				  INFF_VIF_EVENT_TIMEOUT);
+	if (!err) {
+		iphy_err(drvr, "vif event timeout occurred\n");
+		err = -EIO;
+		goto fail;
+	}
+
+	/* interface created in firmware */
+	ifp = vif->ifp;
+	if (!ifp) {
+		iphy_err(drvr, "no if pointer provided\n");
+		err = -ENOENT;
+		goto fail;
+	}
+
+	strscpy(ifp->ndev->name, name, sizeof(ifp->ndev->name));
+	err = inff_net_attach(ifp, true);
+	if (err) {
+		iphy_err(drvr, "Registering netdevice failed\n");
+		free_netdev(ifp->ndev);
+		goto fail;
+	}
+	inff_disarm_vif_event(cfg);
+
+	return &ifp->vif->wdev;
+
+fail:
+	inff_disarm_vif_event(cfg);
+	inff_free_vif(vif);
+	return ERR_PTR(err);
+}
+
+/**
+ * inff_setup_ifmodes() - determine interface modes and combinations.
+ *
+ * @wiphy: wiphy object.
+ * @ifp: interface object needed for feat module api.
+ *
+ * The interface modes and combinations are determined dynamically here
+ * based on firmware functionality.
+ *
+ * no mbss:
+ *
+ *	#STA <= 1, #AP <= 1, channels = 1, 2 total
+ *
+ * mbss:
+ *
+ *	#STA <= 1, #AP <= 1, channels = 1, 2 total
+ *	#AP <= 4, matching BI, channels = 1, 4 total
+ *
+ * rsdb:
+ *	#STA <= 1, #AP <= 2, channels = 2, 4 total
+ *
+ * Return: 0 on success, negative errno on failure
+ */
+int
+inff_setup_ifmodes(struct wiphy *wiphy, struct inff_if *ifp)
+{
+	struct ieee80211_iface_combination *combo = NULL;
+	struct ieee80211_iface_limit *c0_limits = NULL;
+	struct ieee80211_iface_limit *mbss_limits = NULL;
+	bool mbss, rsdb;
+	int i, c, n_combos, n_limits;
+
+	if (inff_socitype_is_cp(ifp->drvr->bus_if)) {
+		n_combos = 1;
+		combo = kcalloc(n_combos, sizeof(*combo), GFP_KERNEL);
+		if (!combo)
+			goto err;
+
+		wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+					 BIT(NL80211_IFTYPE_AP);
+
+		c = 0;
+		i = 0;
+		n_limits = 2;
+		c0_limits = kcalloc(n_limits, sizeof(*c0_limits), GFP_KERNEL);
+		if (!c0_limits)
+			goto err;
+
+		combo[c].num_different_channels = 1;
+		c0_limits[i].max = 1;
+		c0_limits[i++].types = BIT(NL80211_IFTYPE_STATION);
+
+		c0_limits[i].max = 1;
+		c0_limits[i++].types = BIT(NL80211_IFTYPE_AP);
+
+		combo[c].max_interfaces = i;
+
+		combo[c].n_limits = i;
+		combo[c].limits = c0_limits;
+
+	} else {
+		mbss = inff_feat_is_enabled(ifp, INFF_FEAT_MBSS);
+		rsdb = inff_feat_is_enabled(ifp, INFF_FEAT_RSDB);
+
+		n_combos = 1 + !!mbss;
+		combo = kzalloc_objs(*combo, n_combos);
+		if (!combo)
+			goto err;
+
+		wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+					 BIT(NL80211_IFTYPE_AP);
+
+		c = 0;
+		i = 0;
+		n_limits = 2;
+
+		c0_limits = kzalloc_objs(*c0_limits, n_limits);
+		if (!c0_limits)
+			goto err;
+
+		combo[c].num_different_channels = 1 + rsdb;
+		c0_limits[i].max = 1;
+		c0_limits[i++].types = BIT(NL80211_IFTYPE_STATION);
+
+		if (rsdb) {
+			c0_limits[i].max = 2;
+			c0_limits[i++].types = BIT(NL80211_IFTYPE_AP);
+			combo[c].max_interfaces = 3;
+		} else {
+			c0_limits[i].max = 1;
+			c0_limits[i++].types = BIT(NL80211_IFTYPE_AP);
+			combo[c].max_interfaces = i;
+		}
+		combo[c].n_limits = i;
+		combo[c].limits = c0_limits;
+
+		if (mbss) {
+			c++;
+			i = 0;
+			n_limits = 1;
+			mbss_limits = kzalloc_objs(*mbss_limits, n_limits);
+			if (!mbss_limits)
+				goto err;
+			mbss_limits[i].max = 4;
+			mbss_limits[i++].types = BIT(NL80211_IFTYPE_AP);
+			combo[c].beacon_int_infra_match = true;
+			combo[c].num_different_channels = 1;
+			combo[c].max_interfaces = 4;
+			combo[c].n_limits = i;
+			combo[c].limits = mbss_limits;
+		}
+	}
+	wiphy->n_iface_combinations = n_combos;
+	wiphy->iface_combinations = combo;
+	return 0;
+
+err:
+	kfree(c0_limits);
+	kfree(mbss_limits);
+	kfree(combo);
+	return -ENOMEM;
+}
+
+struct inff_cfg80211_vif *
+inff_alloc_vif(struct inff_cfg80211_info *cfg,
+	       enum nl80211_iftype type)
+{
+	struct inff_cfg80211_vif *vif_walk;
+	struct inff_cfg80211_vif *vif;
+	bool mbss;
+	struct inff_if *ifp = inff_get_ifp(cfg->pub, 0);
+
+	inff_dbg(TRACE, "allocating virtual interface (size=%zu)\n",
+		 sizeof(*vif));
+	vif = kzalloc_obj(*vif);
+	if (!vif)
+		return ERR_PTR(-ENOMEM);
+
+	vif->wdev.wiphy = cfg->wiphy;
+	vif->wdev.iftype = type;
+
+	if (type == NL80211_IFTYPE_AP &&
+	    inff_feat_is_enabled(ifp, INFF_FEAT_MBSS)) {
+		mbss = false;
+		list_for_each_entry(vif_walk, &cfg->vif_list, list) {
+			if (vif_walk->wdev.iftype == NL80211_IFTYPE_AP) {
+				mbss = true;
+				break;
+			}
+		}
+		vif->mbss = mbss;
+	}
+
+	init_completion(&vif->mgmt_tx);
+	list_add_tail(&vif->list, &cfg->vif_list);
+	return vif;
+}
+
+void
+inff_free_vif(struct inff_cfg80211_vif *vif)
+{
+	list_del(&vif->list);
+	kfree(vif);
+}
diff --git a/drivers/net/wireless/infineon/inffmac/interface.h b/drivers/net/wireless/infineon/inffmac/interface.h
new file mode 100644
index 000000000000..ab0ad5f1802d
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/interface.h
@@ -0,0 +1,155 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_INTERFACE_H
+#define INFF_INTERFACE_H
+
+#define INFF_VIF_EVENT_TIMEOUT		msecs_to_jiffies(1500)
+
+#define INFF_INTERFACE_CREATE_VER_2		2
+#define INFF_INTERFACE_CREATE_VER_3		3
+
+#define INFF_INTERFACE_MAC_DONT_USE	0x0
+#define INFF_INTERFACE_MAC_USE		0x2
+
+#define INFF_INTERFACE_CREATE_STA	0x0
+#define INFF_INTERFACE_CREATE_AP	0x1
+
+#define INFF_INTERFACE_PRI_BSSCFGIDX (0)
+#define INFF_INTERFACE_PRI_IFIDX     (0)
+
+#define INFF_INTERFACE_SEC_BSSCFGIDX (1)
+#define INFF_INTERFACE_SEC_IFIDX     (1)
+
+struct inff_interface_create_v2 {
+	u16	ver;			/* structure version */
+	u8	pad1[2];
+	u32	flags;			/* flags for operation */
+	u8	mac_addr[ETH_ALEN];	/* MAC address */
+	u8	iftype;			/* type of interface created */
+	u8	pad2;
+	u32	wlc_index;		/* optional for wlc index */
+};
+
+struct inff_interface_create_v3 {
+	u16 ver;			/* structure version */
+	u16 len;			/* length of structure + data */
+	u16 fixed_len;			/* length of structure */
+	u8 iftype;			/* type of interface created */
+	u8 wlc_index;			/* optional for wlc index */
+	u32 flags;			/* flags for operation */
+	u8 mac_addr[ETH_ALEN];		/* MAC address */
+	u8 bssid[ETH_ALEN];		/* optional for BSSID */
+	u8 if_index;			/* interface index request */
+	u8 pad[3];
+	u8 data[];			/* Optional for specific data */
+};
+
+#define WL_IOV_OP_BSSCFG_DISABLE		0
+#define WL_IOV_OP_BSSCFG_ENABLE			1
+#define WL_IOV_OP_MANUAL_STA_BSSCFG_CREATE	2
+#define WL_IOV_OP_MANUAL_AP_BSSCFG_CREATE	3
+
+/**
+ * enum inff_vif_status - bit indices for vif status.
+ *
+ * @INFF_VIF_STATUS_READY: ready for operation.
+ * @INFF_VIF_STATUS_CONNECTING: connect/join in progress.
+ * @INFF_VIF_STATUS_CONNECTED: connected/joined successfully.
+ * @INFF_VIF_STATUS_DISCONNECTING: disconnect/disable in progress.
+ * @INFF_VIF_STATUS_AP_CREATED: AP operation started.
+ * @INFF_VIF_STATUS_EAP_SUCCUSS: EAPOL handshake successful.
+ * @INFF_VIF_STATUS_ASSOC_SUCCESS: successful SET_SSID received.
+ */
+enum inff_vif_status {
+	INFF_VIF_STATUS_READY,
+	INFF_VIF_STATUS_CONNECTING,
+	INFF_VIF_STATUS_CONNECTED,
+	INFF_VIF_STATUS_DISCONNECTING,
+	INFF_VIF_STATUS_AP_CREATED,
+	INFF_VIF_STATUS_EAP_SUCCESS,
+	INFF_VIF_STATUS_ASSOC_SUCCESS,
+};
+
+/**
+ * struct inff_vif_saved_ie - holds saved IEs for a virtual interface.
+ *
+ * @probe_req_ie: IE info for probe request.
+ * @probe_res_ie: IE info for probe response.
+ * @beacon_ie: IE info for beacon frame.
+ * @assoc_req_ie: IE info for association request frame.
+ * @assoc_res_ie: IE info for association response frame.
+ * @probe_req_ie_len: IE info length for probe request.
+ * @probe_res_ie_len: IE info length for probe response.
+ * @beacon_ie_len: IE info length for beacon frame.
+ * @assoc_req_ie_len: IE info length for association request frame.
+ * @assoc_res_ie_len: IE info length for association response frame.
+ */
+struct inff_vif_saved_ie {
+	u8  probe_req_ie[IE_MAX_LEN];
+	u8  probe_res_ie[IE_MAX_LEN];
+	u8  beacon_ie[IE_MAX_LEN];
+	u8  assoc_req_ie[IE_MAX_LEN];
+	u8  assoc_res_ie[IE_MAX_LEN];
+	u32 probe_req_ie_len;
+	u32 probe_res_ie_len;
+	u32 beacon_ie_len;
+	u32 assoc_req_ie_len;
+	u32 assoc_res_ie_len;
+};
+
+/**
+ * struct inff_cfg80211_vif - virtual interface specific information.
+ *
+ * @ifp: lower layer interface pointer
+ * @wdev: wireless device.
+ * @sme_state: SME state using enum inff_vif_status bits.
+ * @saved_id: saved IE info for a vif.
+ * @list: linked list.
+ * @mgmt_rx_reg: registered rx mgmt frame types.
+ * @mbss: Multiple BSS type, set if not first AP
+ * @is_11d: beacon contains country IE, enable regulatory 802.11d support
+ */
+struct inff_cfg80211_vif {
+	struct inff_if *ifp;
+	struct wireless_dev wdev;
+	unsigned long sme_state;
+	struct inff_vif_saved_ie saved_ie;
+	struct list_head list;
+	struct completion mgmt_tx;
+	unsigned long mgmt_tx_status;
+	u32 mgmt_tx_id;
+	u16 mgmt_rx_reg;
+	bool mbss;
+	int is_11d;
+};
+
+void inff_link_down(struct inff_cfg80211_vif *vif, u16 reason,
+		    bool locally_generated);
+void inff_arm_vif_event(struct inff_cfg80211_info *cfg,
+			struct inff_cfg80211_vif *vif);
+void inff_disarm_vif_event(struct inff_cfg80211_info *cfg);
+bool inff_vif_event_armed(struct inff_cfg80211_info *cfg);
+int inff_wait_vif_event(struct inff_cfg80211_info *cfg,
+			u8 action, ulong timeout);
+int inff_vif_change_validate(struct inff_cfg80211_info *cfg,
+			     struct inff_cfg80211_vif *vif,
+			     enum nl80211_iftype new_type);
+bool inff_check_vif_up(struct inff_cfg80211_vif *vif);
+struct wireless_dev *
+inff_apsta_add_vif(struct wiphy *wiphy, const char *name,
+		   struct vif_params *params,
+		   enum nl80211_iftype type);
+int inff_setup_ifmodes(struct wiphy *wiphy, struct inff_if *ifp);
+struct inff_cfg80211_vif *
+inff_alloc_vif(struct inff_cfg80211_info *cfg, enum nl80211_iftype type);
+void inff_free_vif(struct inff_cfg80211_vif *vif);
+
+void inff_cp_cfg80211_link_down(struct inff_if *ifp);
+
+#endif /* INFF_INTERFACE_H */
-- 
2.43.0

