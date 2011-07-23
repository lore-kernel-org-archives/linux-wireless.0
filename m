Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15210 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1GWOWc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 10:22:32 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 03/11] ath6kl: Cleanup parameters for wlan_refresh_inactive_nodes()
Date: Sat, 23 Jul 2011 19:43:09 +0530
Message-ID: <1311430397-4960-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110723_162235_770127_2E507036)
In-Reply-To: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And remove the reference to wmi in ath6kl_node_table.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/common.h |    3 +--
 drivers/net/wireless/ath/ath6kl/node.c   |    6 +++---
 drivers/net/wireless/ath/ath6kl/wmi.c    |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index 0a3a1d8..cc8b040 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -88,7 +88,6 @@ enum crypto_type {
  * is a second table for associated stations or neighbors.
  */
 struct ath6kl_node_table {
-	void *nt_wmi;		/* back reference */
 	spinlock_t nt_nodelock;	/* on node table */
 	struct bss *nt_node_first;	/* information of all nodes */
 	struct bss *nt_node_last;	/* information of all nodes */
@@ -159,7 +158,7 @@ void wlan_iterate_nodes(struct ath6kl_node_table *nt,
 void wlan_node_table_init(void *wmip, struct ath6kl_node_table *nt);
 void wlan_node_table_cleanup(struct ath6kl_node_table *nt);
 
-void wlan_refresh_inactive_nodes(struct ath6kl_node_table *nt);
+void wlan_refresh_inactive_nodes(struct ath6kl *ar);
 
 struct bss *wlan_find_ssid_node(struct ath6kl_node_table *nt, u8 *ssid,
 				  u32 ssid_len, bool is_wpa2, bool match_ssid);
diff --git a/drivers/net/wireless/ath/ath6kl/node.c b/drivers/net/wireless/ath/ath6kl/node.c
index b0f9ba2..533588c 100644
--- a/drivers/net/wireless/ath/ath6kl/node.c
+++ b/drivers/net/wireless/ath/ath6kl/node.c
@@ -169,17 +169,17 @@ void wlan_node_table_init(void *wmi, struct ath6kl_node_table *nt)
 
 	spin_lock_init(&nt->nt_nodelock);
 
-	nt->nt_wmi = wmi;
 	nt->nt_node_age = WLAN_NODE_INACT_TIMEOUT_MSEC;
 }
 
-void wlan_refresh_inactive_nodes(struct ath6kl_node_table *nt)
+void wlan_refresh_inactive_nodes(struct ath6kl *ar)
 {
+	struct ath6kl_node_table *nt = &ar->scan_table;
 	struct bss *bss;
 	u8 my_bssid[ETH_ALEN];
 	u32 now;
 
-	ath6kl_wmi_get_current_bssid(nt->nt_wmi, my_bssid);
+	ath6kl_wmi_get_current_bssid(ar->wmi, my_bssid);
 
 	now = jiffies_to_msecs(jiffies);
 	bss = nt->nt_node_first;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 2e1b411..ea123c9 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1009,7 +1009,7 @@ static int ath6kl_wmi_scan_complete_rx(struct wmi *wmi, u8 *datap, int len)
 	ev = (struct wmi_scan_complete_event *) datap;
 
 	if (a_sle32_to_cpu(ev->status) == 0)
-		wlan_refresh_inactive_nodes(&wmi->parent_dev->scan_table);
+		wlan_refresh_inactive_nodes(wmi->parent_dev);
 
 	ath6kl_scan_complete_evt(wmi->parent_dev, a_sle32_to_cpu(ev->status));
 	wmi->is_probe_ssid = false;
-- 
1.7.0.4

