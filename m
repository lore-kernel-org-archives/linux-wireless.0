Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16196 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2AIIh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 03:37:27 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 3/8] ath6kl: Add a new func to configure default WOW patterns for AP mode
Date: Mon, 9 Jan 2012 14:06:17 +0530
Message-ID: <1326098182-9103-4-git-send-email-rmani@qca.qualcomm.com> (sfid-20120109_093729_564254_D478A47E)
In-Reply-To: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
References: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

ath6kl_ap_add_default_wow_patterns() is added to configure the below
default patterns when the system enters into WOW suspend in AP mode.

  * Unicast IP, EAPOL-like and ARP packet pattern
  * ARP packet pattern
  * mDNS/SSDP/LLMNR pattern
  * DHCP broadcast pattern

This will be called from ath6kl_wow_suspend() func.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   77 ++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2a166cc..deba99c 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1727,6 +1727,83 @@ static int ath6kl_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return 0;
 }
 
+static int ath6kl_ap_add_default_wow_patterns(struct ath6kl *ar,
+		struct ath6kl_vif *vif)
+{
+	static u8 unicst_pattern[] = { 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08 };
+	static u8 unicst_mask[] = { 0x01, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7f };
+	u8 unicst_offset = 0;
+	static u8 arp_pattern[] = { 0x08, 0x06 };
+	static u8 arp_mask[] = { 0xff, 0xff };
+	u8 arp_offset = 20;
+	static u8 discvr_pattern[] = { 0xe0, 0x00, 0x00, 0xf8 };
+	static u8 discvr_mask[] = { 0xf0, 0x00, 0x00, 0xf8 };
+	u8 discvr_offset = 38;
+	static u8 dhcp_pattern[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x43 /* port 67 */ };
+	static u8 dhcp_mask[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0xff, 0xff /* port 67 */ };
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
-- 
1.7.1

