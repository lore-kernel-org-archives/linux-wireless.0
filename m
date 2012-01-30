Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50684 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2A3Lpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:45:39 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v3 2/4] ath6kl: Configure WOW patterns while going to wow_suspend
Date: Mon, 30 Jan 2012 17:13:10 +0530
Message-ID: <1327923792-16408-3-git-send-email-rmani@qca.qualcomm.com> (sfid-20120130_124544_088402_FF5DCEC8)
In-Reply-To: <1327923792-16408-1-git-send-email-rmani@qca.qualcomm.com>
References: <1327923792-16408-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

First preference is given to the user configured WOW patterns.
If the user doesn't configure any patterns (for ex, via iw command),
the default patterns will be configured based on the current mode
(vif->nw_type) while going to WOW suspend.

Summary of changes:

  * ath6kl_wow_ap() is added to configure the below default
    patterns when the system enters into WOW suspend in AP mode.
      + Unicast IP, EAPOL-like and ARP packet pattern
      + ARP packet pattern
      + mDNS/SSDP/LLMNR pattern
      + DHCP broadcast pattern

 * ath6kl_wow_sta() is added to configure the below default
   patterns when the system enters into WOW suspend in STA mode.
      + Unicast packet pattern
      + mDNS/SSDP/LLMNR pattern

  * Move the user provided WOW patterns configuration code
    from ath6kl_wow_suspend() to a separate function called
    ath6kl_wow_usr().

  * Two argument variable's ('filter' and 'mask) data type in
    ath6kl_wmi_add_wow_pattern_cmd() are changed from 'u8 *' to
    'const u8 *'. This is needed to make all pattern and mask
    arrays to be 'static const u8' in the caller function.

  * New conditional check is added to make sure user
    configured pattern count is within the limit (WOW_MAX_FILTERS_PER_LIST).

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  231 +++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath6kl/wmi.c      |    3 +-
 drivers/net/wireless/ath/ath6kl/wmi.h      |    3 +-
 3 files changed, 193 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index fed7b80..e676cfc 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1723,32 +1723,14 @@ static int ath6kl_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return 0;
 }
 
-static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
+static int ath6kl_wow_usr(struct ath6kl *ar, struct ath6kl_vif *vif,
+			  struct cfg80211_wowlan *wow, u32 *filter)
 {
-	struct in_device *in_dev;
-	struct in_ifaddr *ifa;
-	struct ath6kl_vif *vif;
-	int ret, pos, left;
-	u32 filter = 0;
+	int ret, pos;
+	u8 mask[WOW_MASK_SIZE];
 	u16 i;
-	u8 mask[WOW_MASK_SIZE], index = 0;
-	__be32 ips[MAX_IP_ADDRS];
-
-	vif = ath6kl_vif_first(ar);
-	if (!vif)
-		return -EIO;
-
-	if (!ath6kl_cfg80211_ready(vif))
-		return -EIO;
-
-	if (!test_bit(CONNECTED, &vif->flags))
-		return -EINVAL;
 
-	/* Clear existing WOW patterns */
-	for (i = 0; i < WOW_MAX_FILTERS_PER_LIST; i++)
-		ath6kl_wmi_del_wow_pattern_cmd(ar->wmi, vif->fw_vif_idx,
-					       WOW_LIST_ID, i);
-	/* Configure new WOW patterns */
+	/* Configure the patterns that we received from the user. */
 	for (i = 0; i < wow->n_patterns; i++) {
 
 		/*
@@ -1771,14 +1753,194 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 		 * matched from the first byte of received pkt in the firmware.
 		 */
 		ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
-					vif->fw_vif_idx, WOW_LIST_ID,
-					wow->patterns[i].pattern_len,
-					0 /* pattern offset */,
-					wow->patterns[i].pattern, mask);
+				vif->fw_vif_idx, WOW_LIST_ID,
+				wow->patterns[i].pattern_len,
+				0 /* pattern offset */,
+				wow->patterns[i].pattern, mask);
 		if (ret)
 			return ret;
 	}
 
+	if (wow->disconnect)
+		*filter |= WOW_FILTER_OPTION_NWK_DISASSOC;
+
+	if (wow->magic_pkt)
+		*filter |= WOW_FILTER_OPTION_MAGIC_PACKET;
+
+	if (wow->gtk_rekey_failure)
+		*filter |= WOW_FILTER_OPTION_GTK_ERROR;
+
+	if (wow->eap_identity_req)
+		*filter |= WOW_FILTER_OPTION_EAP_REQ;
+
+	if (wow->four_way_handshake)
+		*filter |= WOW_FILTER_OPTION_8021X_4WAYHS;
+
+	return 0;
+}
+
+static int ath6kl_wow_ap(struct ath6kl *ar, struct ath6kl_vif *vif)
+{
+	static const u8 unicst_pattern[] = { 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x08 };
+	static const u8 unicst_mask[] = { 0x01, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x7f };
+	u8 unicst_offset = 0;
+	static const u8 arp_pattern[] = { 0x08, 0x06 };
+	static const u8 arp_mask[] = { 0xff, 0xff };
+	u8 arp_offset = 20;
+	static const u8 discvr_pattern[] = { 0xe0, 0x00, 0x00, 0xf8 };
+	static const u8 discvr_mask[] = { 0xf0, 0x00, 0x00, 0xf8 };
+	u8 discvr_offset = 38;
+	static const u8 dhcp_pattern[] = { 0xff, 0xff, 0xff, 0xff,
+		0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x43 /* port 67 */ };
+	static const u8 dhcp_mask[] = { 0xff, 0xff, 0xff, 0xff,
+		0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0xff, 0xff /* port 67 */ };
+	u8 dhcp_offset = 0;
+	int ret;
+
+	/* Setup unicast IP, EAPOL-like and ARP pkt pattern */
+	ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
+			vif->fw_vif_idx, WOW_LIST_ID,
+			sizeof(unicst_pattern), unicst_offset,
+			unicst_pattern, unicst_mask);
+	if (ret) {
+		ath6kl_err("failed to add WOW unicast IP pattern\n");
+		return ret;
+	}
+
+	/* Setup all ARP pkt pattern */
+	ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
+			vif->fw_vif_idx, WOW_LIST_ID,
+			sizeof(arp_pattern), arp_offset,
+			arp_pattern, arp_mask);
+	if (ret) {
+		ath6kl_err("failed to add WOW ARP pattern\n");
+		return ret;
+	}
+
+	/*
+	 * Setup multicast pattern for mDNS 224.0.0.251,
+	 * SSDP 239.255.255.250 and LLMNR  224.0.0.252
+	 */
+	ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
+			vif->fw_vif_idx, WOW_LIST_ID,
+			sizeof(discvr_pattern), discvr_offset,
+			discvr_pattern, discvr_mask);
+	if (ret) {
+		ath6kl_err("failed to add WOW mDNS/SSDP/LLMNR pattern\n");
+		return ret;
+	}
+
+	/* Setup all DHCP broadcast pkt pattern */
+	ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
+			vif->fw_vif_idx, WOW_LIST_ID,
+			sizeof(dhcp_pattern), dhcp_offset,
+			dhcp_pattern, dhcp_mask);
+	if (ret) {
+		ath6kl_err("failed to add WOW DHCP broadcast pattern\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ath6kl_wow_sta(struct ath6kl *ar, struct ath6kl_vif *vif)
+{
+	struct net_device *ndev = vif->ndev;
+	static const u8 discvr_pattern[] = { 0xe0, 0x00, 0x00, 0xf8 };
+	static const u8 discvr_mask[] = { 0xf0, 0x00, 0x00, 0xf8 };
+	u8 discvr_offset = 38;
+	u8 mac_mask[ETH_ALEN];
+	int ret;
+
+	/* Setup unicast pkt pattern */
+	memset(mac_mask, 0xff, ETH_ALEN);
+	ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
+				vif->fw_vif_idx, WOW_LIST_ID,
+				ETH_ALEN, 0, ndev->dev_addr,
+				mac_mask);
+	if (ret) {
+		ath6kl_err("failed to add WOW unicast pattern\n");
+		return ret;
+	}
+
+	/*
+	 * Setup multicast pattern for mDNS 224.0.0.251,
+	 * SSDP 239.255.255.250 and LLMNR 224.0.0.252
+	 */
+	if ((ndev->flags & IFF_ALLMULTI) ||
+	    (ndev->flags & IFF_MULTICAST && netdev_mc_count(ndev) > 0)) {
+		ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
+				vif->fw_vif_idx, WOW_LIST_ID,
+				sizeof(discvr_pattern), discvr_offset,
+				discvr_pattern, discvr_mask);
+		if (ret) {
+			ath6kl_err("failed to add WOW mDNS/SSDP/LLMNR "
+				   "pattern\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
+{
+	struct in_device *in_dev;
+	struct in_ifaddr *ifa;
+	struct ath6kl_vif *vif;
+	int ret, left;
+	u32 filter = 0;
+	u16 i;
+	u8 index = 0;
+	__be32 ips[MAX_IP_ADDRS];
+
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
+	if (!ath6kl_cfg80211_ready(vif))
+		return -EIO;
+
+	if (!test_bit(CONNECTED, &vif->flags))
+		return -EINVAL;
+
+	if (wow && (wow->n_patterns > WOW_MAX_FILTERS_PER_LIST))
+		return -EINVAL;
+
+	/* Clear existing WOW patterns */
+	for (i = 0; i < WOW_MAX_FILTERS_PER_LIST; i++)
+		ath6kl_wmi_del_wow_pattern_cmd(ar->wmi, vif->fw_vif_idx,
+					       WOW_LIST_ID, i);
+
+	/*
+	 * Skip the default WOW pattern configuration
+	 * if the driver receives any WOW patterns from
+	 * the user.
+	 */
+	if (wow)
+		ret = ath6kl_wow_usr(ar, vif, wow, &filter);
+	else if (vif->nw_type == AP_NETWORK)
+		ret = ath6kl_wow_ap(ar, vif);
+	else
+		ret = ath6kl_wow_sta(ar, vif);
+
+	if (ret)
+		return ret;
+
 	/* Setup own IP addr for ARP agent. */
 	in_dev = __in_dev_get_rtnl(vif->ndev);
 	if (!in_dev)
@@ -1806,21 +1968,6 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	}
 
 skip_arp:
-	if (wow->disconnect)
-		filter |= WOW_FILTER_OPTION_NWK_DISASSOC;
-
-	if (wow->magic_pkt)
-		filter |= WOW_FILTER_OPTION_MAGIC_PACKET;
-
-	if (wow->gtk_rekey_failure)
-		filter |= WOW_FILTER_OPTION_GTK_ERROR;
-
-	if (wow->eap_identity_req)
-		filter |= WOW_FILTER_OPTION_EAP_REQ;
-
-	if (wow->four_way_handshake)
-		filter |= WOW_FILTER_OPTION_8021X_4WAYHS;
-
 	ret = ath6kl_wmi_set_wow_mode_cmd(ar->wmi, vif->fw_vif_idx,
 					  ATH6KL_WOW_MODE_ENABLE,
 					  filter,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 5d678bf..9c8e4df 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2620,7 +2620,8 @@ int ath6kl_wmi_set_wow_mode_cmd(struct wmi *wmi, u8 if_idx,
 
 int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 				   u8 list_id, u8 filter_size,
-				   u8 filter_offset, u8 *filter, u8 *mask)
+				   u8 filter_offset, const u8 *filter,
+				   const u8 *mask)
 {
 	struct sk_buff *skb;
 	struct wmi_add_wow_pattern_cmd *cmd;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 48e9d26..85698ef 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2461,7 +2461,8 @@ int ath6kl_wmi_set_wow_mode_cmd(struct wmi *wmi, u8 if_idx,
 				u32 filter, u16 host_req_delay);
 int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 				   u8 list_id, u8 filter_size,
-				   u8 filter_offset, u8 *filter, u8 *mask);
+				   u8 filter_offset, const u8 *filter,
+				   const u8 *mask);
 int ath6kl_wmi_del_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 				   u16 list_id, u16 filter_id);
 int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi);
-- 
1.7.1

