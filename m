Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15218 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1GWOWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 10:22:44 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 05/11] ath6kl: Remove ath6kl_wmi_get_current_bssid()
Date: Sat, 23 Jul 2011 19:43:11 +0530
Message-ID: <1311430397-4960-5-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110723_162246_815048_A1F0A655)
In-Reply-To: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the bssid from ath6kl directly.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/node.c |    5 +----
 drivers/net/wireless/ath/ath6kl/wmi.c  |    6 ------
 drivers/net/wireless/ath/ath6kl/wmi.h  |    1 -
 3 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/node.c b/drivers/net/wireless/ath/ath6kl/node.c
index 533588c..9611541 100644
--- a/drivers/net/wireless/ath/ath6kl/node.c
+++ b/drivers/net/wireless/ath/ath6kl/node.c
@@ -176,16 +176,13 @@ void wlan_refresh_inactive_nodes(struct ath6kl *ar)
 {
 	struct ath6kl_node_table *nt = &ar->scan_table;
 	struct bss *bss;
-	u8 my_bssid[ETH_ALEN];
 	u32 now;
 
-	ath6kl_wmi_get_current_bssid(ar->wmi, my_bssid);
-
 	now = jiffies_to_msecs(jiffies);
 	bss = nt->nt_node_first;
 	while (bss != NULL) {
 		/* refresh all nodes except the current bss */
-		if (memcmp(my_bssid, bss->ni_macaddr, sizeof(my_bssid)) != 0) {
+		if (memcmp(ar->bssid, bss->ni_macaddr, ETH_ALEN) != 0) {
 			if (((now - bss->ni_tstamp) > nt->nt_node_age)
 			    || --bss->ni_actcnt == 0) {
 				wlan_node_reclaim(nt, bss);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ff71b7f..50cee9b 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2247,12 +2247,6 @@ int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi)
 	return ath6kl_wmi_simple_cmd(wmi, WMI_GET_TX_PWR_CMDID);
 }
 
-void ath6kl_wmi_get_current_bssid(struct wmi *wmi, u8 *bssid)
-{
-	if (bssid)
-		memcpy(bssid, wmi->parent_dev->bssid, ETH_ALEN);
-}
-
 int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 status, u8 preamble_policy)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 1646a92..991d29f 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1995,7 +1995,6 @@ int ath6kl_wmi_setpmkid_cmd(struct wmi *wmi, const u8 *bssid,
 			    const u8 *pmkid, bool set);
 int ath6kl_wmi_set_tx_pwr_cmd(struct wmi *wmi, u8 dbM);
 int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi);
-void ath6kl_wmi_get_current_bssid(struct wmi *wmi, u8 *bssid);
 
 int ath6kl_wmi_set_wmm_txop(struct wmi *wmi, enum wmi_txop_cfg cfg);
 int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 keep_alive_intvl);
-- 
1.7.0.4

