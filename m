Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52301 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1GWOXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 10:23:12 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 09/11] ath6kl: Remove ath6kl_wmi_iterate_nodes()
Date: Sat, 23 Jul 2011 19:43:15 +0530
Message-ID: <1311430397-4960-9-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110723_162315_208262_F374BA05)
In-Reply-To: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use wlan_iterate_nodes() directly.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 ++--
 drivers/net/wireless/ath/ath6kl/wmi.c      |    7 -------
 drivers/net/wireless/ath/ath6kl/wmi.h      |    3 ---
 3 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 9eaa1b1..cf5ab55 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -833,8 +833,8 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl *ar, int status)
 	}
 
 	/* Translate data to cfg80211 mgmt format */
-	ath6kl_wmi_iterate_nodes(&ar->scan_table, ath6kl_cfg80211_scan_node,
-				 ar->wdev->wiphy);
+	wlan_iterate_nodes(&ar->scan_table, ath6kl_cfg80211_scan_node,
+			   ar->wdev->wiphy);
 
 	cfg80211_scan_done(ar->scan_req, false);
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 6a6f79c..f5aa33d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -386,13 +386,6 @@ int ath6kl_wmi_data_hdr_remove(struct wmi *wmi, struct sk_buff *skb)
 	return 0;
 }
 
-void ath6kl_wmi_iterate_nodes(struct ath6kl_node_table *scan_tbl,
-			      void (*f) (void *arg, struct bss *),
-			      void *arg)
-{
-	wlan_iterate_nodes(scan_tbl, f, arg);
-}
-
 static void ath6kl_wmi_convert_bssinfo_hdr2_to_hdr(struct sk_buff *skb,
 						   u8 *datap)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index a9f8f9e..fe3ddce 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1931,9 +1931,6 @@ int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, struct sk_buff *skb,
 				       u8 *ac);
 
 int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb);
-void ath6kl_wmi_iterate_nodes(struct ath6kl_node_table *scan_tbl,
-			      void (*f) (void *arg, struct bss *),
-			      void *arg);
 struct bss *ath6kl_wmi_find_node(struct wmi *wmi, const u8 *mac_addr);
 void ath6kl_wmi_node_free(struct wmi *wmi, const u8 *mac_addr);
 
-- 
1.7.0.4

