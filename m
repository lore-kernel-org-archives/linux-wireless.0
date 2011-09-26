Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44884 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1IZKzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 06:55:10 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so3462643eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 03:55:09 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalyan C Gaddam <chakkal@iit.edu>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 3/5] mac80211: handle TDLS high-level commands and frames
Date: Mon, 26 Sep 2011 13:54:51 +0300
Message-Id: <1317034493-5300-4-git-send-email-arik@wizery.com> (sfid-20110926_125515_791883_21717CE9)
In-Reply-To: <1317034493-5300-1-git-send-email-arik@wizery.com>
References: <1317034493-5300-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register and implement the TDLS cfg80211 callback functions.

Internally prepare and send TDLS management frames. We incorporate
local STA capabilities and supported rates with extra IEs given by
usermode. The resulting packet is either encapsulated in a data frame,
or assembled as an action frame. It is transmitted either directly or
through the AP, as mandated by the TDLS specification.

Declare support for the TDLS external setup wiphy capability. This
tells usermode to handle link setup and discovery on its own, and use the
kernel driver for sending TDLS mgmt packets.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Cc: Kalyan C Gaddam <chakkal@iit.edu>
---
 include/linux/ieee80211.h |   85 ++++++++++++
 include/linux/if_ether.h  |    1 +
 net/mac80211/Kconfig      |   12 ++
 net/mac80211/cfg.c        |  314 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/main.c       |    4 +
 5 files changed, 416 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b5e0a5c..f5c8ced 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -759,6 +759,12 @@ struct ieee80211_mgmt {
 					u8 action;
 					u8 smps_control;
 				} __attribute__ ((packed)) ht_smps;
+				struct {
+					u8 action_code;
+					u8 dialog_token;
+					__le16 capability;
+					u8 variable[0];
+				} __packed tdls_discover_resp;
 			} u;
 		} __attribute__ ((packed)) action;
 	} u;
@@ -805,6 +811,52 @@ struct ieee80211_pspoll {
 	u8 ta[6];
 } __attribute__ ((packed));
 
+/* TDLS */
+
+/* Link-id information element */
+struct ieee80211_tdls_lnkie {
+	u8 ie_type; /* Link Identifier IE */
+	u8 ie_len;
+	u8 bssid[6];
+	u8 init_sta[6];
+	u8 resp_sta[6];
+} __packed;
+
+struct ieee80211_tdls_data {
+	u8 da[6];
+	u8 sa[6];
+	__be16 ether_type;
+	u8 payload_type;
+	u8 category;
+	u8 action_code;
+	union {
+		struct {
+			u8 dialog_token;
+			__le16 capability;
+			u8 variable[0];
+		} __packed setup_req;
+		struct {
+			__le16 status_code;
+			u8 dialog_token;
+			__le16 capability;
+			u8 variable[0];
+		} __packed setup_resp;
+		struct {
+			__le16 status_code;
+			u8 dialog_token;
+			u8 variable[0];
+		} __packed setup_cfm;
+		struct {
+			__le16 reason_code;
+			u8 variable[0];
+		} __packed teardown;
+		struct {
+			u8 dialog_token;
+			u8 variable[0];
+		} __packed discover_req;
+	} u;
+} __packed;
+
 /**
  * struct ieee80211_bar - HT Block Ack Request
  *
@@ -1196,6 +1248,8 @@ enum ieee80211_eid {
 	WLAN_EID_TS_DELAY = 43,
 	WLAN_EID_TCLAS_PROCESSING = 44,
 	WLAN_EID_QOS_CAPA = 46,
+	/* 802.11z */
+	WLAN_EID_LINK_ID = 101,
 	/* 802.11s */
 	WLAN_EID_MESH_CONFIG = 113,
 	WLAN_EID_MESH_ID = 114,
@@ -1279,6 +1333,7 @@ enum ieee80211_category {
 	WLAN_CATEGORY_HT = 7,
 	WLAN_CATEGORY_SA_QUERY = 8,
 	WLAN_CATEGORY_PROTECTED_DUAL_OF_ACTION = 9,
+	WLAN_CATEGORY_TDLS = 12,
 	WLAN_CATEGORY_MESH_ACTION = 13,
 	WLAN_CATEGORY_MULTIHOP_ACTION = 14,
 	WLAN_CATEGORY_SELF_PROTECTED = 15,
@@ -1342,6 +1397,36 @@ enum ieee80211_key_len {
 	WLAN_KEY_LEN_AES_CMAC = 16,
 };
 
+/* Public action codes */
+enum ieee80211_pub_actioncode {
+	WLAN_PUB_ACTION_TDLS_DISCOVER_RES = 14,
+};
+
+/* TDLS action codes */
+enum ieee80211_tdls_actioncode {
+	WLAN_TDLS_SETUP_REQUEST = 0,
+	WLAN_TDLS_SETUP_RESPONSE = 1,
+	WLAN_TDLS_SETUP_CONFIRM = 2,
+	WLAN_TDLS_TEARDOWN = 3,
+	WLAN_TDLS_PEER_TRAFFIC_INDICATION = 4,
+	WLAN_TDLS_CHANNEL_SWITCH_REQUEST = 5,
+	WLAN_TDLS_CHANNEL_SWITCH_RESPONSE = 6,
+	WLAN_TDLS_PEER_PSM_REQUEST = 7,
+	WLAN_TDLS_PEER_PSM_RESPONSE = 8,
+	WLAN_TDLS_PEER_TRAFFIC_RESPONSE = 9,
+	WLAN_TDLS_DISCOVERY_REQUEST = 10,
+};
+
+/*
+ * TDLS capabililites to be enabled in the 5th byte of the
+ * @WLAN_EID_EXT_CAPABILITY information element
+ */
+#define WLAN_EXT_CAPA_TDLS_ENABLED	BIT(5)
+#define WLAN_EXT_CAPA_TDLS_PROHIBITED	BIT(6)
+
+/* TDLS specific payload type in the LLC/SNAP header */
+#define WLAN_TDLS_SNAP_RFTYPE	0x2
+
 /**
  * enum - mesh path selection protocol identifier
  *
diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index a3d99ff..49c38fc 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -83,6 +83,7 @@
 #define ETH_P_8021AH	0x88E7          /* 802.1ah Backbone Service Tag */
 #define ETH_P_1588	0x88F7		/* IEEE 1588 Timesync */
 #define ETH_P_FCOE	0x8906		/* Fibre Channel over Ethernet  */
+#define ETH_P_TDLS	0x890D          /* TDLS */
 #define ETH_P_FIP	0x8914		/* FCoE Initialization Protocol */
 #define ETH_P_QINQ1	0x9100		/* deprecated QinQ VLAN [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_QINQ2	0x9200		/* deprecated QinQ VLAN [ NOT AN OFFICIALLY REGISTERED ID ] */
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index d1886b5..7d3b438 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -225,6 +225,18 @@ config MAC80211_VERBOSE_MHWMP_DEBUG
 
 	  Do not select this option.
 
+config MAC80211_VERBOSE_TDLS_DEBUG
+	bool "Verbose TDLS debugging"
+	depends on MAC80211_DEBUG_MENU
+	---help---
+	  Selecting this option causes mac80211 to print out very
+	  verbose TDLS selection debugging messages (when mac80211
+	  is a TDLS STA).
+	  It should not be selected on production systems as those
+	  messages are remotely triggerable.
+
+	  Do not select this option.
+
 config MAC80211_DEBUG_COUNTERS
 	bool "Extra statistics for TX/RX debugging"
 	depends on MAC80211_DEBUG_MENU
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b57ddf9..1adf823 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <net/net_namespace.h>
 #include <linux/rcupdate.h>
+#include <linux/if_ether.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
@@ -2120,6 +2121,317 @@ static int ieee80211_set_rekey_data(struct wiphy *wiphy,
 	return 0;
 }
 
+static void ieee80211_tdls_add_ext_capab(struct sk_buff *skb)
+{
+	u8 *pos = (void *)skb_put(skb, 7);
+
+	*pos++ = WLAN_EID_EXT_CAPABILITY;
+	*pos++ = 5; /* len */
+	*pos++ = 0x0;
+	*pos++ = 0x0;
+	*pos++ = 0x0;
+	*pos++ = 0x0;
+	*pos++ = WLAN_EXT_CAPA_TDLS_ENABLED;
+}
+
+static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	u16 capab;
+
+	capab = 0;
+	if (local->oper_channel->band != IEEE80211_BAND_2GHZ)
+		return capab;
+
+	if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
+		capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
+	if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE))
+		capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
+
+	return capab;
+}
+
+static void ieee80211_tdls_add_link_ie(struct sk_buff *skb, u8 *src_addr,
+				       u8 *peer, u8 *bssid)
+{
+	struct ieee80211_tdls_lnkie *lnkid;
+
+	lnkid = (void *)skb_put(skb, sizeof(struct ieee80211_tdls_lnkie));
+
+	lnkid->ie_type = WLAN_EID_LINK_ID;
+	lnkid->ie_len = sizeof(struct ieee80211_tdls_lnkie) - 2;
+
+	memcpy(lnkid->bssid, bssid, ETH_ALEN);
+	memcpy(lnkid->init_sta, src_addr, ETH_ALEN);
+	memcpy(lnkid->resp_sta, peer, ETH_ALEN);
+}
+
+static int
+ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
+			       u8 *peer, u8 action_code, u8 dialog_token,
+			       u16 status_code, struct sk_buff *skb)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_tdls_data *tf;
+
+	tf = (void *)skb_put(skb, offsetof(struct ieee80211_tdls_data, u));
+
+	memcpy(tf->da, peer, ETH_ALEN);
+	memcpy(tf->sa, sdata->vif.addr, ETH_ALEN);
+	tf->ether_type = cpu_to_be16(ETH_P_TDLS);
+	tf->payload_type = WLAN_TDLS_SNAP_RFTYPE;
+
+	switch (action_code) {
+	case WLAN_TDLS_SETUP_REQUEST:
+		tf->category = WLAN_CATEGORY_TDLS;
+		tf->action_code = WLAN_TDLS_SETUP_REQUEST;
+
+		skb_put(skb, sizeof(tf->u.setup_req));
+		tf->u.setup_req.dialog_token = dialog_token;
+		tf->u.setup_req.capability =
+			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
+
+		ieee80211_add_srates_ie(&sdata->vif, skb);
+		ieee80211_add_ext_srates_ie(&sdata->vif, skb);
+		ieee80211_tdls_add_ext_capab(skb);
+		break;
+	case WLAN_TDLS_SETUP_RESPONSE:
+		tf->category = WLAN_CATEGORY_TDLS;
+		tf->action_code = WLAN_TDLS_SETUP_RESPONSE;
+
+		skb_put(skb, sizeof(tf->u.setup_resp));
+		tf->u.setup_resp.status_code = cpu_to_le16(status_code);
+		tf->u.setup_resp.dialog_token = dialog_token;
+		tf->u.setup_resp.capability =
+			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
+
+		ieee80211_add_srates_ie(&sdata->vif, skb);
+		ieee80211_add_ext_srates_ie(&sdata->vif, skb);
+		ieee80211_tdls_add_ext_capab(skb);
+		break;
+	case WLAN_TDLS_SETUP_CONFIRM:
+		tf->category = WLAN_CATEGORY_TDLS;
+		tf->action_code = WLAN_TDLS_SETUP_CONFIRM;
+
+		skb_put(skb, sizeof(tf->u.setup_cfm));
+		tf->u.setup_cfm.status_code = cpu_to_le16(status_code);
+		tf->u.setup_cfm.dialog_token = dialog_token;
+		break;
+	case WLAN_TDLS_TEARDOWN:
+		tf->category = WLAN_CATEGORY_TDLS;
+		tf->action_code = WLAN_TDLS_TEARDOWN;
+
+		skb_put(skb, sizeof(tf->u.teardown));
+		tf->u.teardown.reason_code = cpu_to_le16(status_code);
+		break;
+	case WLAN_TDLS_DISCOVERY_REQUEST:
+		tf->category = WLAN_CATEGORY_TDLS;
+		tf->action_code = WLAN_TDLS_DISCOVERY_REQUEST;
+
+		skb_put(skb, sizeof(tf->u.discover_req));
+		tf->u.discover_req.dialog_token = dialog_token;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
+			   u8 *peer, u8 action_code, u8 dialog_token,
+			   u16 status_code, struct sk_buff *skb)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_mgmt *mgmt;
+
+	mgmt = (void *)skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, peer, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
+	memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
+
+	switch (action_code) {
+	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
+		skb_put(skb, 1 + sizeof(mgmt->u.action.u.tdls_discover_resp));
+		mgmt->u.action.category = WLAN_CATEGORY_PUBLIC;
+		mgmt->u.action.u.tdls_discover_resp.action_code =
+			WLAN_PUB_ACTION_TDLS_DISCOVER_RES;
+		mgmt->u.action.u.tdls_discover_resp.dialog_token =
+			dialog_token;
+		mgmt->u.action.u.tdls_discover_resp.capability =
+			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
+
+		ieee80211_add_srates_ie(&sdata->vif, skb);
+		ieee80211_add_ext_srates_ie(&sdata->vif, skb);
+		ieee80211_tdls_add_ext_capab(skb);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
+			       u8 *peer, u8 action_code, u8 dialog_token,
+			       u16 status_code, const u8 *extra_ies,
+			       size_t extra_ies_len)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_tx_info *info;
+	struct sk_buff *skb = NULL;
+	bool send_direct;
+	int ret;
+
+	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
+		return -ENOTSUPP;
+
+	/* make sure we are in managed mode, and associated */
+	if (sdata->vif.type != NL80211_IFTYPE_STATION ||
+	    !sdata->u.mgd.associated)
+		return -EINVAL;
+
+#ifdef CONFIG_MAC80211_VERBOSE_TDLS_DEBUG
+	printk(KERN_DEBUG "TDLS mgmt action %d peer %pM\n", action_code, peer);
+#endif
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    max(sizeof(struct ieee80211_mgmt),
+				sizeof(struct ieee80211_tdls_data)) +
+			    50 + /* supported rates */
+			    7 + /* ext capab */
+			    extra_ies_len +
+			    sizeof(struct ieee80211_tdls_lnkie));
+	if (!skb)
+		return -ENOMEM;
+
+	info = IEEE80211_SKB_CB(skb);
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	switch (action_code) {
+	case WLAN_TDLS_SETUP_REQUEST:
+	case WLAN_TDLS_SETUP_RESPONSE:
+	case WLAN_TDLS_SETUP_CONFIRM:
+	case WLAN_TDLS_TEARDOWN:
+	case WLAN_TDLS_DISCOVERY_REQUEST:
+		ret = ieee80211_prep_tdls_encap_data(wiphy, dev, peer,
+						     action_code, dialog_token,
+						     status_code, skb);
+		send_direct = false;
+		break;
+	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
+		ret = ieee80211_prep_tdls_direct(wiphy, dev, peer, action_code,
+						 dialog_token, status_code,
+						 skb);
+		send_direct = true;
+		break;
+	default:
+		ret = -ENOTSUPP;
+		break;
+	}
+
+	if (ret < 0)
+		goto fail;
+
+	if (extra_ies_len)
+		memcpy(skb_put(skb, extra_ies_len), extra_ies, extra_ies_len);
+
+	/* the TDLS link IE is always added last */
+	switch (action_code) {
+	case WLAN_TDLS_SETUP_REQUEST:
+	case WLAN_TDLS_SETUP_CONFIRM:
+	case WLAN_TDLS_TEARDOWN:
+	case WLAN_TDLS_DISCOVERY_REQUEST:
+		/* we are the initiator */
+		ieee80211_tdls_add_link_ie(skb, sdata->vif.addr, peer,
+					   sdata->u.mgd.bssid);
+		break;
+	case WLAN_TDLS_SETUP_RESPONSE:
+	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
+		/* we are the responder */
+		ieee80211_tdls_add_link_ie(skb, peer, sdata->vif.addr,
+					   sdata->u.mgd.bssid);
+		break;
+	default:
+		ret = -ENOTSUPP;
+		goto fail;
+	}
+
+	if (send_direct) {
+		ieee80211_tx_skb(sdata, skb);
+		return 0;
+	}
+
+	/*
+	 * According to 802.11z: Setup req/resp are sent in AC_BK, otherwise
+	 * we should default to AC_VI.
+	 */
+	switch (action_code) {
+	case WLAN_TDLS_SETUP_REQUEST:
+	case WLAN_TDLS_SETUP_RESPONSE:
+		skb_set_queue_mapping(skb, IEEE80211_AC_BK);
+		skb->priority = 2;
+		break;
+	default:
+		skb_set_queue_mapping(skb, IEEE80211_AC_VI);
+		skb->priority = 5;
+		break;
+	}
+
+	/* disable bottom halves when entering the Tx path */
+	local_bh_disable();
+	ret = ieee80211_subif_start_xmit(skb, dev);
+	local_bh_enable();
+
+	return ret;
+
+fail:
+	dev_kfree_skb(skb);
+	return ret;
+}
+
+static int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
+			       u8 *peer, enum nl80211_tdls_operation oper)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
+		return -ENOTSUPP;
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EINVAL;
+
+#ifdef CONFIG_MAC80211_VERBOSE_TDLS_DEBUG
+	printk(KERN_DEBUG "TDLS oper %d peer %pM\n", oper, peer);
+#endif
+
+	switch (oper) {
+	case NL80211_TDLS_ENABLE_LINK:
+		break;
+	case NL80211_TDLS_DISABLE_LINK:
+		return sta_info_destroy_addr(sdata, peer);
+	case NL80211_TDLS_TEARDOWN:
+	case NL80211_TDLS_SETUP:
+	case NL80211_TDLS_DISCOVERY_REQ:
+		/* We don't support in-driver setup/teardown/discovery */
+		return -ENOTSUPP;
+	case NL80211_TDLS_DISABLE:
+	case NL80211_TDLS_ENABLE:
+		/* TODO */
+		return -ENOTSUPP;
+	default:
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -2183,4 +2495,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.set_ringparam = ieee80211_set_ringparam,
 	.get_ringparam = ieee80211_get_ringparam,
 	.set_rekey_data = ieee80211_set_rekey_data,
+	.tdls_oper = ieee80211_tdls_oper,
+	.tdls_mgmt = ieee80211_tdls_mgmt,
 };
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a5809a1..336ceb9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -863,6 +863,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (local->ops->sched_scan_start)
 		local->hw.wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 
+	/* mac80211 based drivers don't support internal TDLS setup */
+	if (local->hw.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS)
+		local->hw.wiphy->flags |= WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		goto fail_wiphy_register;
-- 
1.7.4.1

