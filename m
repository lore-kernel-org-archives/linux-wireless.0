Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51337 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2AIIhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 03:37:42 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 5/8] ath6kl: Move WOW patterns config code to a separate function.
Date: Mon, 9 Jan 2012 14:06:19 +0530
Message-ID: <1326098182-9103-6-git-send-email-rmani@qca.qualcomm.com> (sfid-20120109_093745_412847_AC84E78A)
In-Reply-To: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
References: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Move the user provided WOW patterns configuration code
from ath6kl_wow_suspend() to a separate function called
ath6kl_add_usr_wow_patterns().

It gives more modularity to the existing code.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  108 +++++++++++++++------------
 1 files changed, 60 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 65e4609..347c5a4 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1727,6 +1727,64 @@ static int ath6kl_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return 0;
 }
 
+static int ath6kl_add_usr_wow_patterns(struct ath6kl *ar,
+				       struct ath6kl_vif *vif,
+				       struct cfg80211_wowlan *wow,
+				       u32 *filter)
+{
+	int ret, pos;
+	u8 mask[WOW_MASK_SIZE];
+	u16 i;
+
+	/* Configure the patterns that we received from the user. */
+	for (i = 0; i < wow->n_patterns; i++) {
+
+		/*
+		 * Convert given nl80211 specific mask value to equivalent
+		 * driver specific mask value and send it to the chip along
+		 * with patterns. For example, If the mask value defined in
+		 * struct cfg80211_wowlan is 0xA (equivalent binary is 1010),
+		 * then equivalent driver specific mask value is
+		 * "0xFF 0x00 0xFF 0x00".
+		 */
+		memset(&mask, 0, sizeof(mask));
+		for (pos = 0; pos < wow->patterns[i].pattern_len; pos++) {
+			if (wow->patterns[i].mask[pos / 8] & (0x1 << (pos % 8)))
+				mask[pos] = 0xFF;
+		}
+		/*
+		 * Note: Pattern's offset is not passed as part of wowlan
+		 * parameter from CFG layer. So it's always passed as ZERO
+		 * to the firmware. It means, given WOW patterns are always
+		 * matched from the first byte of received pkt in the firmware.
+		 */
+		ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
+					vif->fw_vif_idx, WOW_LIST_ID,
+					wow->patterns[i].pattern_len,
+					0 /* pattern offset */,
+					wow->patterns[i].pattern, mask);
+		if (ret)
+			return ret;
+	}
+
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
 static int ath6kl_ap_add_default_wow_patterns(struct ath6kl *ar,
 		struct ath6kl_vif *vif)
 {
@@ -1849,10 +1907,10 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	struct in_device *in_dev;
 	struct in_ifaddr *ifa;
 	struct ath6kl_vif *vif;
-	int ret, pos, left;
+	int ret, left;
 	u32 filter = 0;
 	u16 i;
-	u8 mask[WOW_MASK_SIZE], index = 0;
+	u8 index = 0;
 	__be32 ips[MAX_IP_ADDRS];
 
 	vif = ath6kl_vif_first(ar);
@@ -1869,37 +1927,6 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	for (i = 0; i < WOW_MAX_FILTERS_PER_LIST; i++)
 		ath6kl_wmi_del_wow_pattern_cmd(ar->wmi, vif->fw_vif_idx,
 					       WOW_LIST_ID, i);
-	/* Configure new WOW patterns */
-	for (i = 0; i < wow->n_patterns; i++) {
-
-		/*
-		 * Convert given nl80211 specific mask value to equivalent
-		 * driver specific mask value and send it to the chip along
-		 * with patterns. For example, If the mask value defined in
-		 * struct cfg80211_wowlan is 0xA (equivalent binary is 1010),
-		 * then equivalent driver specific mask value is
-		 * "0xFF 0x00 0xFF 0x00".
-		 */
-		memset(&mask, 0, sizeof(mask));
-		for (pos = 0; pos < wow->patterns[i].pattern_len; pos++) {
-			if (wow->patterns[i].mask[pos / 8] & (0x1 << (pos % 8)))
-				mask[pos] = 0xFF;
-		}
-		/*
-		 * Note: Pattern's offset is not passed as part of wowlan
-		 * parameter from CFG layer. So it's always passed as ZERO
-		 * to the firmware. It means, given WOW patterns are always
-		 * matched from the first byte of received pkt in the firmware.
-		 */
-		ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
-					vif->fw_vif_idx, WOW_LIST_ID,
-					wow->patterns[i].pattern_len,
-					0 /* pattern offset */,
-					wow->patterns[i].pattern, mask);
-		if (ret)
-			return ret;
-	}
-
 	/* Setup own IP addr for ARP agent. */
 	in_dev = __in_dev_get_rtnl(vif->ndev);
 	if (!in_dev)
@@ -1927,21 +1954,6 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
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
-- 
1.7.1

