Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30870 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2ATNgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 08:36:46 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 2/8] ath6kl: Add a new func to configure default WOW patterns for AP mode
Date: Fri, 20 Jan 2012 19:05:38 +0530
Message-ID: <1327066544-23779-3-git-send-email-rmani@qca.qualcomm.com> (sfid-20120120_143649_794384_7BC2CA6D)
In-Reply-To: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com>
References: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

ath6kl_ap_add_default_wow_patterns() is added to configure
the below default patterns when the system enters into WOW
suspend in AP mode.

  * Unicast IP, EAPOL-like and ARP packet pattern
  * ARP packet pattern
  * mDNS/SSDP/LLMNR pattern
  * DHCP broadcast pattern

This will be called from ath6kl_wow_suspend() func.

In addition, two argument variable's ('filter' and 'mask)
data type in ath6kl_wmi_add_wow_pattern_cmd() are changed
from 'u8 *' to 'const u8 *'. This is needed to make all
pattern and mask arrays to be 'static const u8' in
the caller function.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   79 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.c      |    3 +-
 drivers/net/wireless/ath/ath6kl/wmi.h      |    3 +-
 3 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 594d246..88cce8f 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1723,6 +1723,85 @@ static int ath6kl_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return 0;
 }
 
+static int ath6kl_ap_add_default_wow_patterns(struct ath6kl *ar,
+		struct ath6kl_vif *vif)
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
 static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 {
 	struct in_device *in_dev;
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

