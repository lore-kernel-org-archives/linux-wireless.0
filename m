Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0040.outbound.protection.outlook.com ([104.47.34.40]:39072
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751002AbdFTTz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 15:55:58 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 3/8] qtnfmac: implement AP_VLAN iftype support
Date: Tue, 20 Jun 2017 22:55:12 +0300
Message-Id: <20170620195517.18373-4-sergey.matyukevich.os@quantenna.com> (sfid-20170620_215603_912928_26F5E0B9)
In-Reply-To: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements AP_VLAN interface type support enabling
the use of dynamic VLAN mode in hostapd.

Implementation notes.

1. Passing dynamic VLAN tag to firmware
Currently there is no established way to pass VLAN tag assigned to STA
by Radius server to wireless driver. It is assumed that hostapd is able
to setup all the bridging and tagging on its own. However qtnf firmware
needs to know the assigned dynamic VLAN tags in order to perform various
internal tasks including group key management, filtering, acceleration,
and more.

Current implementation makes use of the following workaround.
Driver obtains dynamic VLAN tags assigned by Radius server
from AP/VLAN interface names:
- for primary interfaces: wlanX.Z
  where X and Z are macid and vlan tag respectively
- for MBSS virtual interfaces: wlanX_Y.Z
  where X, Y, Z are macid, vifid, and vlan tag respectively

Such a naming convention can be configured using
hostapd vlan_file configuration file.

2. Packet routing to/from AP/VLAN interfaces
Firmware operates with tagged packets after dynamic VLAN mode is
configured. In particular, packets destined to STAs should be
properly tagged before they can be passed to firmware. Packets
received from STAs are properly tagged by firmware and then
passed to wireless driver. As a result, packet routing to AP/VLAN
interfaces is straightforward: it is enough to check VLAN tags.

Normally hostapd expects untagged packets from AP/VLAN interfaces.
Meanwhile firmware performs tagging using h/w acceleration. That
is why it makes sense to avoid untagging packets in driver if
they are supposed to by tagged again on host. To enable this
behavior a new module parameter 'dyn_vlan_tagged' has been
introduced:

- dyn_vlan_tagged = 0 (default)
In this case untagged packets are sent to and expected from AP/VLAN interfaces.
Driver tags/untags packets going to/from firmware. This behaviour is expected
by hostapd which is able to create bridges and VLAN interfaces automatically
when hostapd is built with CONFIG_FULL_DYNAMIC_VLAN option enabled.

- dyn_vlan_tagged = 1
In this case tagged packets are sent to and expected from AP/VLAN interfaces.
Hostapd build option CONFIG_FULL_DYNAMIC_VLAN should be disabled. Setup of
networking topology on host is left up to the implementers.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |   1 +
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  | 247 ++++++++++++++++++---
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |  28 ++-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  78 ++++++-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |  25 ++-
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    |   5 +
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  10 +-
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    |   3 +
 drivers/net/wireless/quantenna/qtnfmac/util.c      |  74 ++++--
 drivers/net/wireless/quantenna/qtnfmac/util.h      |  34 ++-
 10 files changed, 428 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wireless/quantenna/qtnfmac/bus.h
index dda05003d522..819ba3ba0f05 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -52,6 +52,7 @@ struct qtnf_bus {
 	enum qtnf_fw_state fw_state;
 	u32 chip;
 	u32 chiprev;
+	u8 dyn_vlan_tagged;
 	const struct qtnf_bus_ops *bus_ops;
 	struct qtnf_wmac *mac[QTNF_MAX_MAC];
 	struct qtnf_qlink_transport trans;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 825a6334fbfe..e222e8d038d3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -77,6 +77,35 @@ qtnf_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	},
 };
 
+static int qtnf_vlan_vif_exists(struct qtnf_vif *vif, u16 vlanid)
+{
+	struct qtnf_vif *vlan_vif;
+
+	vlan_vif = qtnf_vlan_list_lookup(&vif->vlan_list, vlanid);
+	if (vlan_vif)
+		return 1;
+
+	return 0;
+}
+
+static struct qtnf_vif *qtnf_add_vlan_vif(struct qtnf_vif *vif, u16 vlanid)
+{
+	struct qtnf_vif *vlan_vif;
+
+	vlan_vif = qtnf_vlan_list_add(&vif->vlan_list, vlanid);
+	if (vlan_vif) {
+		vlan_vif->u.vlan.parent = vif;
+		vlan_vif->u.vlan.vlanid = vlanid;
+	}
+
+	return vlan_vif;
+}
+
+static int qtnf_del_vlan_vif(struct qtnf_vif *vif, u16 vlanid)
+{
+	return qtnf_vlan_list_del(&vif->vlan_list, vlanid);
+}
+
 static int
 qtnf_change_virtual_intf(struct wiphy *wiphy,
 			 struct net_device *dev,
@@ -92,7 +121,15 @@ qtnf_change_virtual_intf(struct wiphy *wiphy,
 	else
 		mac_addr = NULL;
 
-	qtnf_scan_done(vif->mac, true);
+	switch (type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_AP:
+		qtnf_scan_done(vif->mac, true);
+		break;
+	default:
+		pr_err("unsupported virtual interface type (%d)\n", type);
+		return -ENOTSUPP;
+	}
 
 	ret = qtnf_cmd_send_change_intf_type(vif, type, mac_addr);
 	if (ret) {
@@ -108,29 +145,57 @@ qtnf_change_virtual_intf(struct wiphy *wiphy,
 int qtnf_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
 	struct net_device *netdev =  wdev->netdev;
+	struct qtnf_vif *parent;
 	struct qtnf_vif *vif;
+	u16 vlanid;
 
 	if (WARN_ON(!netdev))
 		return -EFAULT;
 
+	netif_tx_stop_all_queues(netdev);
+	if (netif_carrier_ok(netdev))
+		netif_carrier_off(netdev);
+
 	vif = qtnf_netdev_get_priv(wdev->netdev);
 
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_AP:
+		qtnf_virtual_intf_cleanup(vif);
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		break;
+	default:
+		pr_err("unsupported virtual interface type (%d)\n",
+		       wdev->iftype);
+		return -ENOTSUPP;
+	}
+
 	if (qtnf_cmd_send_del_intf(vif))
 		pr_err("VIF%u.%u: failed to delete VIF\n", vif->mac->macid,
 		       vif->vifid);
 
-	/* Stop data */
-	netif_tx_stop_all_queues(netdev);
-	if (netif_carrier_ok(netdev))
-		netif_carrier_off(netdev);
-
 	if (netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdevice(netdev);
 
-	vif->netdev->ieee80211_ptr = NULL;
-	vif->netdev = NULL;
-	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
-	eth_zero_addr(vif->mac_addr);
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_AP:
+		vif->netdev->ieee80211_ptr = NULL;
+		vif->netdev = NULL;
+		vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+		eth_zero_addr(vif->mac_addr);
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		parent = vif->u.vlan.parent;
+		vlanid = vif->u.vlan.vlanid;
+		if (!qtnf_del_vlan_vif(parent, vlanid))
+			pr_warn("failed to delete AP_VLAN for VLAN tag %u",
+				vlanid);
+		break;
+	default:
+		break;
+	}
 
 	return 0;
 }
@@ -143,7 +208,12 @@ static struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
 {
 	struct qtnf_wmac *mac;
 	struct qtnf_vif *vif;
+	struct qtnf_vif *parent_vif;
 	u8 *mac_addr = NULL;
+	u32 vlanid = 0;
+	u32 macid;
+	u32 vifid;
+	int ret;
 
 	mac = wiphy_priv(wiphy);
 
@@ -164,24 +234,86 @@ static struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
 		vif->wdev.wiphy = wiphy;
 		vif->wdev.iftype = type;
 		vif->sta_state = QTNF_STA_DISCONNECTED;
+
+		if (params)
+			mac_addr = params->macaddr;
+
+		if (qtnf_cmd_send_add_intf(vif, type, mac_addr)) {
+			pr_err("VIF%u.%u: failed to add VIF\n", mac->macid,
+			       vif->vifid);
+			goto err_cmd;
+		}
+
+		if (!is_valid_ether_addr(vif->mac_addr)) {
+			pr_err("VIF%u.%u: FW reported bad MAC: %pM\n",
+			       mac->macid, vif->vifid, vif->mac_addr);
+			goto err_mac;
+		}
+
 		break;
-	default:
-		pr_err("MAC%u: unsupported IF type %d\n", mac->macid, type);
-		return ERR_PTR(-ENOTSUPP);
-	}
+	case NL80211_IFTYPE_AP_VLAN:
+		/* Note: expect two valid inputs:
+		 *   wlan%d.%d -> macid/vlanid
+		 *   wlan%d_%d.%d -> macid/vifid/vlanid
+		 * Note: don't care about macid since wiphy is known
+		 */
+		ret = sscanf(name, "wlan%u_%u.%u", &macid, &vifid, &vlanid);
+		if (ret != 3) {
+			ret = sscanf(name, "wlan%u.%u", &macid, &vlanid);
+			if (ret != 2) {
+				pr_err("unsupported AP_VLAN interface naming");
+				return ERR_PTR(-ENOTSUPP);
+			}
+
+			vifid = 0;
+		}
 
-	if (params)
-		mac_addr = params->macaddr;
+		if (vifid >= QTNF_MAX_INTF) {
+			pr_err("VIF index %d is out of range\n", vifid);
+			return ERR_PTR(-EINVAL);
+		}
 
-	if (qtnf_cmd_send_add_intf(vif, type, mac_addr)) {
-		pr_err("VIF%u.%u: failed to add VIF\n", mac->macid, vif->vifid);
-		goto err_cmd;
-	}
+		macid = mac->macid;
+
+		pr_debug("add AP_VLAN with tag %u to mac/vif %u/%u\n",
+			 vlanid, macid, vifid);
+
+		parent_vif = &mac->iflist[vifid];
+		if (parent_vif->wdev.iftype != NL80211_IFTYPE_AP) {
+			pr_err("only AP supports VLAN virtual iterface\n");
+			return ERR_PTR(-ENOTSUPP);
+		}
 
-	if (!is_valid_ether_addr(vif->mac_addr)) {
-		pr_err("VIF%u.%u: FW reported bad MAC: %pM\n",
-		       mac->macid, vif->vifid, vif->mac_addr);
-		goto err_mac;
+		if (qtnf_vlan_vif_exists(parent_vif, vlanid)) {
+			pr_err("AP_VLAN for tag %u already exists for %s\n",
+			       vlanid, name);
+			return ERR_PTR(-EEXIST);
+		}
+
+		vif = qtnf_add_vlan_vif(parent_vif, vlanid);
+		if (!vif) {
+			pr_err("couldn't create VLAN vif for tag %u\n", vlanid);
+			return ERR_PTR(-EFAULT);
+		}
+
+		vif->mac = mac;
+		vif->vifid = vifid;
+
+		eth_zero_addr(vif->mac_addr);
+		vif->bss_priority = QTNF_DEF_BSS_PRIORITY;
+		vif->wdev.wiphy = wiphy;
+		vif->wdev.iftype = type;
+		vif->sta_state = QTNF_STA_DISCONNECTED;
+
+		if (qtnf_cmd_send_add_intf(vif, type, NULL)) {
+			pr_err("failed to send add_intf command\n");
+			goto err_cmd;
+		}
+
+		break;
+	default:
+		pr_err("MAC%u: unsupported IF type %d\n", mac->macid, type);
+		return ERR_PTR(-ENOTSUPP);
 	}
 
 	if (qtnf_core_net_attach(mac, vif, name, name_assign_t, type)) {
@@ -198,7 +330,17 @@ static struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
 err_mac:
 	qtnf_cmd_send_del_intf(vif);
 err_cmd:
-	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+	switch (type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_AP:
+		vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		qtnf_del_vlan_vif(vif->u.vlan.parent, vlanid);
+		break;
+	default:
+		break;
+	}
 
 	return ERR_PTR(-EFAULT);
 }
@@ -541,8 +683,28 @@ qtnf_change_station(struct wiphy *wiphy, struct net_device *dev,
 		    const u8 *mac, struct station_parameters *params)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	struct qtnf_sta_node *sta_node;
 	int ret;
 
+	if (mac && params && params->vlan) {
+		sta_node = qtnf_sta_list_lookup(&vif->sta_list, mac);
+		if (unlikely(!sta_node)) {
+			pr_err("VIF%u.%u: STA %pM does not exist\n",
+			       vif->mac->macid, vif->vifid, mac);
+			return -ENOENT;
+		}
+
+		vif = qtnf_netdev_get_priv(params->vlan);
+		if (vif->wdev.iftype != NL80211_IFTYPE_AP_VLAN) {
+			pr_err("VIF%u.%u: interface %s: unexpected type %d\n",
+			       vif->mac->macid, vif->vifid, params->vlan->name,
+			       vif->wdev.iftype);
+			return -EINVAL;
+		}
+
+		sta_node->ndev = params->vlan;
+	}
+
 	ret = qtnf_cmd_send_change_sta(vif, mac, params);
 	if (ret)
 		pr_err("VIF%u.%u: failed to change STA %pM\n",
@@ -898,14 +1060,26 @@ void qtnf_netdev_updown(struct net_device *ndev, bool up)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
 
-	if (qtnf_cmd_send_updown_intf(vif, up))
-		pr_err("failed to send up/down command to FW\n");
+	switch (vif->wdev.iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_AP:
+		if (qtnf_cmd_send_updown_intf(vif, up))
+			pr_err("failed to send up/down command to FW\n");
+		break;
+	default:
+		pr_err("unsupported virtual interface type (%d)\n",
+		       vif->wdev.iftype);
+		break;
+	}
 }
 
-void qtnf_virtual_intf_cleanup(struct net_device *ndev)
+void qtnf_virtual_intf_cleanup(struct qtnf_vif *vif)
 {
-	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
 	struct qtnf_wmac *mac = wiphy_priv(vif->wdev.wiphy);
+	struct qtnf_sta_node *sta;
+	struct qtnf_vif *vlan;
+	struct qtnf_vif *tmp;
+	struct qtnf_list *list;
 
 	if (vif->wdev.iftype == NL80211_IFTYPE_STATION) {
 		switch (vif->sta_state) {
@@ -917,20 +1091,31 @@ void qtnf_virtual_intf_cleanup(struct net_device *ndev)
 						NULL, 0,
 						WLAN_STATUS_UNSPECIFIED_FAILURE,
 						GFP_KERNEL);
-			qtnf_disconnect(vif->wdev.wiphy, ndev,
+			qtnf_disconnect(vif->wdev.wiphy, vif->netdev,
 					WLAN_REASON_DEAUTH_LEAVING);
 			break;
 		case QTNF_STA_CONNECTED:
 			cfg80211_disconnected(vif->netdev,
 					      WLAN_REASON_DEAUTH_LEAVING,
 					      NULL, 0, 1, GFP_KERNEL);
-			qtnf_disconnect(vif->wdev.wiphy, ndev,
+			qtnf_disconnect(vif->wdev.wiphy, vif->netdev,
 					WLAN_REASON_DEAUTH_LEAVING);
 			break;
 		}
 
 		vif->sta_state = QTNF_STA_DISCONNECTED;
 		qtnf_scan_done(mac, true);
+	} else if (vif->wdev.iftype == NL80211_IFTYPE_AP) {
+		if (qtnf_list_empty(&vif->vlan_list))
+			return;
+
+		list = &vif->vlan_list;
+		list_for_each_entry_safe(vlan, tmp, &list->head, u.vlan.list)
+			qtnf_del_virtual_intf(vlan->wdev.wiphy, &vlan->wdev);
+
+		list = &vif->sta_list;
+		list_for_each_entry(sta, &list->head, list)
+			sta->ndev = NULL;
 	}
 }
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 5a6caf5b685b..221804f8c43a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -719,6 +719,10 @@ static int qtnf_cmd_send_add_change_intf(struct qtnf_vif *vif,
 	case NL80211_IFTYPE_STATION:
 		cmd->intf_info.if_type = cpu_to_le16(QLINK_IFTYPE_STATION);
 		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		cmd->intf_info.if_type = cpu_to_le16(QLINK_IFTYPE_AP_VLAN);
+		cmd->intf_info.vlanid = cpu_to_le16(vif->u.vlan.vlanid);
+		break;
 	default:
 		pr_err("VIF%u.%u: unsupported type %d\n", vif->mac->macid,
 		       vif->vifid, iftype);
@@ -745,7 +749,15 @@ static int qtnf_cmd_send_add_change_intf(struct qtnf_vif *vif,
 	}
 
 	resp = (const struct qlink_resp_manage_intf *)resp_skb->data;
-	ether_addr_copy(vif->mac_addr, resp->intf_info.mac_addr);
+
+	switch (iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_STATION:
+		ether_addr_copy(vif->mac_addr, resp->intf_info.mac_addr);
+		break;
+	default:
+		break;
+	}
 
 out:
 	qtnf_bus_unlock(vif->mac->bus);
@@ -792,6 +804,10 @@ int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
 	case NL80211_IFTYPE_STATION:
 		cmd->intf_info.if_type = cpu_to_le16(QLINK_IFTYPE_STATION);
 		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		cmd->intf_info.if_type = cpu_to_le16(QLINK_IFTYPE_AP_VLAN);
+		cmd->intf_info.vlanid = cpu_to_le16(vif->u.vlan.vlanid);
+		break;
 	default:
 		pr_warn("VIF%u.%u: unsupported iftype %d\n", vif->mac->macid,
 			vif->vifid, vif->wdev.iftype);
@@ -1051,8 +1067,9 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 			limits[rec].types = qlink_iface_type_to_nl_mask(
 				le16_to_cpu(limit_record->type));
 
-			/* supported modes: STA, AP */
+			/* supported modes: STA, AP, AP_VLAN */
 			limits[rec].types &= BIT(NL80211_IFTYPE_AP) |
+					     BIT(NL80211_IFTYPE_AP_VLAN) |
 					     BIT(NL80211_IFTYPE_STATION);
 
 			pr_debug("MAC%u: MAX: %u; TYPES: %.4X\n", mac->macid,
@@ -1645,6 +1662,9 @@ int qtnf_cmd_send_add_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
 					 params->seq,
 					 params->seq_len);
 
+	if (vif->wdev.iftype == NL80211_IFTYPE_AP_VLAN)
+		cmd->vlanid = cpu_to_le16(vif->u.vlan.vlanid);
+
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
 	if (unlikely(ret))
 		goto out;
@@ -1826,6 +1846,10 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
 		cmd->sta_flags_set = cpu_to_le32(qtnf_encode_sta_flags(
 						 params->sta_flags_set));
 		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		cmd->if_type = cpu_to_le16(QLINK_IFTYPE_AP_VLAN);
+		cmd->vlanid = cpu_to_le16(vif->u.vlan.vlanid);
+		break;
 	default:
 		pr_err("unsupported iftype %d\n", vif->wdev.iftype);
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index 21cbe6dcf6fa..3d9b217790ed 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -16,6 +16,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/if_vlan.h>
 #include <linux/if_ether.h>
 
 #include "core.h"
@@ -59,6 +60,18 @@ struct qtnf_wmac *qtnf_core_get_mac(const struct qtnf_bus *bus, u8 macid)
  */
 static int qtnf_netdev_open(struct net_device *ndev)
 {
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+
+	if (unlikely(!vif || !vif->mac || !vif->mac->bus)) {
+		pr_warn("invalid network device\n");
+		return -ENODEV;
+	}
+
+	if (vif->wdev.iftype == NL80211_IFTYPE_AP_VLAN) {
+		netif_carrier_on(ndev);
+		return 0;
+	}
+
 	netif_carrier_off(ndev);
 	qtnf_netdev_updown(ndev, 1);
 	return 0;
@@ -68,8 +81,14 @@ static int qtnf_netdev_open(struct net_device *ndev)
  */
 static int qtnf_netdev_close(struct net_device *ndev)
 {
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+
 	netif_carrier_off(ndev);
-	qtnf_virtual_intf_cleanup(ndev);
+
+	if (vif->wdev.iftype == NL80211_IFTYPE_AP_VLAN)
+		return 0;
+
+	qtnf_virtual_intf_cleanup(vif);
 	qtnf_netdev_updown(ndev, 0);
 	return 0;
 }
@@ -111,6 +130,19 @@ qtnf_netdev_hard_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		return 0;
 	}
 
+	if (vif->wdev.iftype == NL80211_IFTYPE_AP_VLAN) {
+		if (!mac->bus->dyn_vlan_tagged) {
+			skb = vlan_insert_tag(skb, htons(ETH_P_8021Q),
+					      vif->u.vlan.vlanid);
+			if (unlikely(!skb)) {
+				pr_err_ratelimited("failed to insert VLAN %d\n",
+						   vif->u.vlan.vlanid);
+				ndev->stats.tx_dropped++;
+				return 0;
+			}
+		}
+	}
+
 	/* tx path is enabled: reset vif timeout */
 	vif->cons_tx_timeout_cnt = 0;
 
@@ -150,13 +182,29 @@ static void qtnf_netdev_tx_timeout(struct net_device *ndev)
 	}
 }
 
+static int qtnf_netdev_set_mac_address(struct net_device *ndev, void *addr)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+	struct sockaddr *sa = addr;
+	int ret;
+
+	if (vif->wdev.iftype == NL80211_IFTYPE_AP_VLAN) {
+		ret = eth_mac_addr(ndev, sa);
+		if (ret == 0)
+			ether_addr_copy(vif->mac_addr, sa->sa_data);
+	}
+
+	return 0;
+}
+
 /* Network device ops handlers */
-const struct net_device_ops qtnf_netdev_ops = {
+const struct net_device_ops qtnf_bss_netdev_ops = {
 	.ndo_open = qtnf_netdev_open,
 	.ndo_stop = qtnf_netdev_close,
 	.ndo_start_xmit = qtnf_netdev_hard_start_xmit,
 	.ndo_tx_timeout = qtnf_netdev_tx_timeout,
 	.ndo_get_stats = qtnf_netdev_get_stats,
+	.ndo_set_mac_address = qtnf_netdev_set_mac_address,
 };
 
 static int qtnf_mac_init_single_band(struct wiphy *wiphy,
@@ -180,7 +228,6 @@ static int qtnf_mac_init_single_band(struct wiphy *wiphy,
 
 	qtnf_band_init_rates(wiphy->bands[band]);
 	qtnf_band_setup_htvht_caps(&mac->macinfo, wiphy->bands[band]);
-
 	return 0;
 }
 
@@ -287,7 +334,8 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
 		mac->iflist[i].wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
 		mac->iflist[i].mac = mac;
 		mac->iflist[i].vifid = i;
-		qtnf_sta_list_init(&mac->iflist[i].sta_list);
+		qtnf_list_init(&mac->iflist[i].sta_list);
+		qtnf_list_init(&mac->iflist[i].vlan_list);
 	}
 
 	qtnf_mac_init_primary_intf(mac);
@@ -314,8 +362,8 @@ int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 	}
 
 	vif->netdev = dev;
+	dev->netdev_ops = &qtnf_bss_netdev_ops;
 
-	dev->netdev_ops = &qtnf_netdev_ops;
 	dev->destructor = free_netdev;
 	dev_net_set(dev, wiphy_net(wiphy));
 	dev->ieee80211_ptr = &vif->wdev;
@@ -360,7 +408,7 @@ static void qtnf_core_mac_detach(struct qtnf_bus *bus, unsigned int macid)
 		rtnl_lock();
 		if (vif->netdev &&
 		    vif->wdev.iftype != NL80211_IFTYPE_UNSPECIFIED) {
-			qtnf_virtual_intf_cleanup(vif->netdev);
+			qtnf_virtual_intf_cleanup(vif);
 			qtnf_del_virtual_intf(wiphy, &vif->wdev);
 		}
 		rtnl_unlock();
@@ -567,6 +615,8 @@ struct net_device *qtnf_classify_skb(struct qtnf_bus *bus, struct sk_buff *skb)
 	struct net_device *ndev = NULL;
 	struct qtnf_wmac *mac;
 	struct qtnf_vif *vif;
+	struct qtnf_vif *vlan_vif;
+	u16 vlanid;
 
 	meta = (struct qtnf_frame_meta_info *)
 		(skb_tail_pointer(skb) - sizeof(*meta));
@@ -603,6 +653,22 @@ struct net_device *qtnf_classify_skb(struct qtnf_bus *bus, struct sk_buff *skb)
 
 	ndev = vif->netdev;
 
+	if (!qtnf_list_empty(&vif->vlan_list)) {
+		if (__vlan_get_tag(skb, &vlanid) == 0) {
+			vlan_vif = qtnf_vlan_list_lookup(
+				&vif->vlan_list, vlanid & VLAN_VID_MASK);
+			if (vlan_vif) {
+				ndev = vlan_vif->netdev;
+				if (!mac->bus->dyn_vlan_tagged) {
+					/* remove tag */
+					memmove(skb->data + VLAN_HLEN,
+						skb->data, ETH_ALEN * 2);
+					skb_pull(skb, VLAN_HLEN);
+				}
+			}
+		}
+	}
+
 	if (unlikely(!ndev)) {
 		pr_err_ratelimited("netdev for wlan%u.%u does not exists\n",
 				   meta->macid, meta->ifidx);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 31b7ec2bfd3e..0d06ec932caf 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -54,7 +54,8 @@
 #define QTNF_STATE_AP_CONFIG		BIT(2)
 #define QTNF_STATE_AP_START		BIT(1)
 
-extern const struct net_device_ops qtnf_netdev_ops;
+extern const struct net_device_ops qtnf_bss_netdev_ops;
+
 struct qtnf_bus;
 struct qtnf_vif;
 
@@ -76,9 +77,10 @@ struct qtnf_bss_config {
 struct qtnf_sta_node {
 	struct list_head list;
 	u8 mac_addr[ETH_ALEN];
+	struct net_device *ndev;
 };
 
-struct qtnf_sta_list {
+struct qtnf_list {
 	struct list_head head;
 	atomic_t size;
 };
@@ -89,6 +91,12 @@ enum qtnf_sta_state {
 	QTNF_STA_CONNECTED
 };
 
+struct qtnf_vif_vlan {
+	struct qtnf_vif *parent;
+	struct list_head list;
+	u16 vlanid;
+};
+
 struct qtnf_vif {
 	struct wireless_dev wdev;
 	u8 vifid;
@@ -101,8 +109,14 @@ struct qtnf_vif {
 	u8 mac_addr[ETH_ALEN];
 	struct work_struct reset_work;
 	struct qtnf_bss_config bss_cfg;
-	struct qtnf_sta_list sta_list;
 	unsigned long cons_tx_timeout_cnt;
+
+	struct qtnf_list sta_list;
+	struct qtnf_list vlan_list;
+
+	union {
+		struct qtnf_vif_vlan vlan;
+	} u;
 };
 
 struct qtnf_mac_info {
@@ -151,16 +165,15 @@ struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus);
 int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *priv,
 			 const char *name, unsigned char name_assign_type,
 			 enum nl80211_iftype iftype);
+
 void qtnf_main_work_queue(struct work_struct *work);
 int qtnf_cmd_send_update_phy_params(struct qtnf_wmac *mac, u32 changed);
 int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *mac);
 
 struct qtnf_wmac *qtnf_core_get_mac(const struct qtnf_bus *bus, u8 macid);
 struct net_device *qtnf_classify_skb(struct qtnf_bus *bus, struct sk_buff *skb);
-struct net_device *qtnf_classify_skb_no_mbss(struct qtnf_bus *bus,
-					     struct sk_buff *skb);
 
-void qtnf_virtual_intf_cleanup(struct net_device *ndev);
+void qtnf_virtual_intf_cleanup(struct qtnf_vif *vif);
 
 void qtnf_netdev_updown(struct net_device *ndev, bool up);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 4814d90c8040..82bde70b1f96 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -52,6 +52,10 @@ static u8 flashboot = 1;
 module_param(flashboot, byte, 0644);
 MODULE_PARM_DESC(flashboot, "set to 0 to use FW binary file on FS");
 
+static u8 dyn_vlan_tagged;
+module_param(dyn_vlan_tagged, byte, 0444);
+MODULE_PARM_DESC(dyn_vlan_tagged, "enable tagged traffic on AP_VLAN ports");
+
 #define DRV_NAME	"qtnfmac_pearl_pcie"
 
 static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
@@ -1151,6 +1155,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	bus->bus_ops = &qtnf_pcie_bus_ops;
 	bus->dev = &pdev->dev;
 	bus->fw_state = QTNF_FW_STATE_RESET;
+	bus->dyn_vlan_tagged = dyn_vlan_tagged;
 	pcie_priv->pdev = pdev;
 
 	strcpy(bus->fwname, QTN_PCI_PEARL_FW_NAME);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 8bcd8a55ad11..892752599109 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -19,7 +19,7 @@
 
 #include <linux/ieee80211.h>
 
-#define QLINK_PROTO_VER		4
+#define QLINK_PROTO_VER		5
 
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -77,6 +77,7 @@ enum qlink_iface_type {
 	QLINK_IFTYPE_ADHOC	= 3,
 	QLINK_IFTYPE_MONITOR	= 4,
 	QLINK_IFTYPE_WDS	= 5,
+	QLINK_IFTYPE_AP_VLAN	= 6,
 };
 
 /**
@@ -85,11 +86,12 @@ enum qlink_iface_type {
  * Data describing a single virtual interface.
  *
  * @if_type: Mode of interface operation, one of &enum qlink_iface_type
- * @flags: interface flagsmap.
+ * @vlanid: VLAN ID for AP_VLAN interface type
  * @mac_addr: MAC address of virtual interface.
  */
 struct qlink_intf_info {
 	__le16 if_type;
+	__le16 vlanid;
 	u8 mac_addr[ETH_ALEN];
 	u8 rsvd[2];
 } __packed;
@@ -297,6 +299,7 @@ struct qlink_cmd_add_key {
 	u8 pairwise;
 	u8 addr[ETH_ALEN];
 	__le32 cipher;
+	__le16 vlanid;
 	u8 key_data[0];
 } __packed;
 
@@ -343,6 +346,8 @@ struct qlink_cmd_set_def_mgmt_key {
  *
  * @sta_flags_mask: STA flags mask, bitmap of &enum qlink_sta_flags
  * @sta_flags_set: STA flags values, bitmap of &enum qlink_sta_flags
+ * @if_type: Mode of interface operation, one of &enum qlink_iface_type
+ * @vlanid: VLAN ID to assign to specific STA
  * @sta_addr: address of the STA for which parameters are set.
  */
 struct qlink_cmd_change_sta {
@@ -350,6 +355,7 @@ struct qlink_cmd_change_sta {
 	__le32 sta_flags_mask;
 	__le32 sta_flags_set;
 	__le16 if_type;
+	__le16 vlanid;
 	u8 sta_addr[ETH_ALEN];
 } __packed;
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
index 22fa631d692d..cf024c995fd6 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -37,6 +37,9 @@ u16 qlink_iface_type_to_nl_mask(u16 qlink_type)
 	case QLINK_IFTYPE_WDS:
 		result |= BIT(NL80211_IFTYPE_WDS);
 		break;
+	case QLINK_IFTYPE_AP_VLAN:
+		result |= BIT(NL80211_IFTYPE_AP_VLAN);
+		break;
 	}
 
 	return result;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.c b/drivers/net/wireless/quantenna/qtnfmac/util.c
index ed38e87471bf..8de6f2fc0600 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.c
@@ -16,16 +16,7 @@
 
 #include "util.h"
 
-void qtnf_sta_list_init(struct qtnf_sta_list *list)
-{
-	if (unlikely(!list))
-		return;
-
-	INIT_LIST_HEAD(&list->head);
-	atomic_set(&list->size, 0);
-}
-
-struct qtnf_sta_node *qtnf_sta_list_lookup(struct qtnf_sta_list *list,
+struct qtnf_sta_node *qtnf_sta_list_lookup(struct qtnf_list *list,
 					   const u8 *mac)
 {
 	struct qtnf_sta_node *node;
@@ -41,12 +32,12 @@ struct qtnf_sta_node *qtnf_sta_list_lookup(struct qtnf_sta_list *list,
 	return NULL;
 }
 
-struct qtnf_sta_node *qtnf_sta_list_lookup_index(struct qtnf_sta_list *list,
+struct qtnf_sta_node *qtnf_sta_list_lookup_index(struct qtnf_list *list,
 						 size_t index)
 {
 	struct qtnf_sta_node *node;
 
-	if (qtnf_sta_list_size(list) <= index)
+	if (qtnf_list_size(list) <= index)
 		return NULL;
 
 	list_for_each_entry(node, &list->head, list) {
@@ -57,8 +48,7 @@ struct qtnf_sta_node *qtnf_sta_list_lookup_index(struct qtnf_sta_list *list,
 	return NULL;
 }
 
-struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_sta_list *list,
-					const u8 *mac)
+struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_list *list, const u8 *mac)
 {
 	struct qtnf_sta_node *node;
 
@@ -82,10 +72,10 @@ struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_sta_list *list,
 	return node;
 }
 
-bool qtnf_sta_list_del(struct qtnf_sta_list *list, const u8 *mac)
+int qtnf_sta_list_del(struct qtnf_list *list, const u8 *mac)
 {
 	struct qtnf_sta_node *node;
-	bool ret = false;
+	int ret = 0;
 
 	node = qtnf_sta_list_lookup(list, mac);
 
@@ -93,13 +83,13 @@ bool qtnf_sta_list_del(struct qtnf_sta_list *list, const u8 *mac)
 		list_del(&node->list);
 		atomic_dec(&list->size);
 		kfree(node);
-		ret = true;
+		ret = 1;
 	}
 
 	return ret;
 }
 
-void qtnf_sta_list_free(struct qtnf_sta_list *list)
+void qtnf_sta_list_free(struct qtnf_list *list)
 {
 	struct qtnf_sta_node *node, *tmp;
 
@@ -112,3 +102,51 @@ void qtnf_sta_list_free(struct qtnf_sta_list *list)
 
 	INIT_LIST_HEAD(&list->head);
 }
+
+struct qtnf_vif *qtnf_vlan_list_lookup(struct qtnf_list *list, const u16 vlanid)
+{
+	struct qtnf_vif *node;
+
+	list_for_each_entry(node, &list->head, u.vlan.list) {
+		if (node->u.vlan.vlanid ==  vlanid)
+			return node;
+	}
+
+	return NULL;
+}
+
+struct qtnf_vif *qtnf_vlan_list_add(struct qtnf_list *list, const u16 vlanid)
+{
+	struct qtnf_vif *node;
+
+	/* don't use existing vlan vif */
+	node = qtnf_vlan_list_lookup(list, vlanid);
+	if (node)
+		return NULL;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (unlikely(!node))
+		return NULL;
+
+	list_add_tail(&node->u.vlan.list, &list->head);
+	atomic_inc(&list->size);
+
+	return node;
+}
+
+int qtnf_vlan_list_del(struct qtnf_list *list, const u16 vlanid)
+{
+	struct qtnf_vif *node;
+	int ret = 0;
+
+	node = qtnf_vlan_list_lookup(list, vlanid);
+
+	if (node) {
+		list_del(&node->u.vlan.list);
+		atomic_dec(&list->size);
+		kfree(node);
+		ret = 1;
+	}
+
+	return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.h b/drivers/net/wireless/quantenna/qtnfmac/util.h
index 0359eae8c24b..85144b07a2ce 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.h
@@ -20,26 +20,36 @@
 #include <linux/kernel.h>
 #include "core.h"
 
-void qtnf_sta_list_init(struct qtnf_sta_list *list);
-
-struct qtnf_sta_node *qtnf_sta_list_lookup(struct qtnf_sta_list *list,
-					   const u8 *mac);
-struct qtnf_sta_node *qtnf_sta_list_lookup_index(struct qtnf_sta_list *list,
-						 size_t index);
-struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_sta_list *list,
-					const u8 *mac);
-bool qtnf_sta_list_del(struct qtnf_sta_list *list, const u8 *mac);
+static inline void qtnf_list_init(struct qtnf_list *list)
+{
+	if (unlikely(!list))
+		return;
 
-void qtnf_sta_list_free(struct qtnf_sta_list *list);
+	INIT_LIST_HEAD(&list->head);
+	atomic_set(&list->size, 0);
+}
 
-static inline size_t qtnf_sta_list_size(const struct qtnf_sta_list *list)
+static inline size_t qtnf_list_size(const struct qtnf_list *list)
 {
 	return atomic_read(&list->size);
 }
 
-static inline bool qtnf_sta_list_empty(const struct qtnf_sta_list *list)
+static inline int qtnf_list_empty(const struct qtnf_list *list)
 {
 	return list_empty(&list->head);
 }
 
+struct qtnf_sta_node *qtnf_sta_list_lookup(struct qtnf_list *list,
+					   const u8 *mac);
+struct qtnf_sta_node *qtnf_sta_list_lookup_index(struct qtnf_list *list,
+						 size_t index);
+struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_list *list, const u8 *mac);
+int qtnf_sta_list_del(struct qtnf_list *list, const u8 *mac);
+void qtnf_sta_list_free(struct qtnf_list *list);
+
+struct qtnf_vif *qtnf_vlan_list_lookup(struct qtnf_list *list,
+				       const u16 vlanid);
+struct qtnf_vif *qtnf_vlan_list_add(struct qtnf_list *list, const u16 vlanid);
+int qtnf_vlan_list_del(struct qtnf_list *list, const u16 vlanid);
+
 #endif /* QTNFMAC_UTIL_H */
-- 
2.11.0
