Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2440 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1GWOZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 10:25:39 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 08/11] ath6kl: Pass only the needed scan_table to ath6kl_wmi_iterate_nodes()
Date: Sat, 23 Jul 2011 19:43:14 +0530
Message-ID: <1311430397-4960-8-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110723_162552_614137_A5350BF5)
In-Reply-To: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.c      |    4 ++--
 drivers/net/wireless/ath/ath6kl/wmi.h      |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d1d4794..9eaa1b1 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -833,7 +833,7 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl *ar, int status)
 	}
 
 	/* Translate data to cfg80211 mgmt format */
-	ath6kl_wmi_iterate_nodes(ar->wmi, ath6kl_cfg80211_scan_node,
+	ath6kl_wmi_iterate_nodes(&ar->scan_table, ath6kl_cfg80211_scan_node,
 				 ar->wdev->wiphy);
 
 	cfg80211_scan_done(ar->scan_req, false);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 742eaa1..6a6f79c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -386,11 +386,11 @@ int ath6kl_wmi_data_hdr_remove(struct wmi *wmi, struct sk_buff *skb)
 	return 0;
 }
 
-void ath6kl_wmi_iterate_nodes(struct wmi *wmi,
+void ath6kl_wmi_iterate_nodes(struct ath6kl_node_table *scan_tbl,
 			      void (*f) (void *arg, struct bss *),
 			      void *arg)
 {
-	wlan_iterate_nodes(&wmi->parent_dev->scan_table, f, arg);
+	wlan_iterate_nodes(scan_tbl, f, arg);
 }
 
 static void ath6kl_wmi_convert_bssinfo_hdr2_to_hdr(struct sk_buff *skb,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 991d29f..a9f8f9e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1931,7 +1931,7 @@ int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, struct sk_buff *skb,
 				       u8 *ac);
 
 int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb);
-void ath6kl_wmi_iterate_nodes(struct wmi *wmi,
+void ath6kl_wmi_iterate_nodes(struct ath6kl_node_table *scan_tbl,
 			      void (*f) (void *arg, struct bss *),
 			      void *arg);
 struct bss *ath6kl_wmi_find_node(struct wmi *wmi, const u8 *mac_addr);
-- 
1.7.0.4

