Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52301 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1GWOXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 10:23:16 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 10/11] ath6kl: Use ath6kl_cfg80211_scan_node() directly instead of function pointer
Date: Sat, 23 Jul 2011 19:43:16 +0530
Message-ID: <1311430397-4960-10-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110723_162318_476003_F78917D3)
In-Reply-To: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    5 ++---
 drivers/net/wireless/ath/ath6kl/common.h   |    5 ++---
 drivers/net/wireless/ath/ath6kl/node.c     |    5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index cf5ab55..d28e72a 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -721,7 +721,7 @@ static inline bool is_ch_11a(u16 ch)
 }
 
 /* struct ath6kl_node_table::nt_nodelock is locked when calling this */
-static void ath6kl_cfg80211_scan_node(void *arg, struct bss *ni)
+void ath6kl_cfg80211_scan_node(void *arg, struct bss *ni)
 {
 	struct wiphy *wiphy = (struct wiphy *)arg;
 	u16 size;
@@ -833,8 +833,7 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl *ar, int status)
 	}
 
 	/* Translate data to cfg80211 mgmt format */
-	wlan_iterate_nodes(&ar->scan_table, ath6kl_cfg80211_scan_node,
-			   ar->wdev->wiphy);
+	wlan_iterate_nodes(&ar->scan_table, ar->wdev->wiphy);
 
 	cfg80211_scan_done(ar->scan_req, false);
 
diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index e37ae9b..ab03f44 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -151,9 +151,7 @@ struct bss *wlan_find_node(struct ath6kl_node_table *nt,
 			   const u8 *mac_addr);
 void wlan_node_reclaim(struct ath6kl_node_table *nt, struct bss *ni);
 void wlan_free_allnodes(struct ath6kl_node_table *nt);
-void wlan_iterate_nodes(struct ath6kl_node_table *nt,
-			void (*f) (void *arg, struct bss *),
-			void *arg);
+void wlan_iterate_nodes(struct ath6kl_node_table *nt, void *arg);
 
 void wlan_node_table_init(struct ath6kl_node_table *nt);
 void wlan_node_table_cleanup(struct ath6kl_node_table *nt);
@@ -179,4 +177,5 @@ struct ath6kl *ath6kl_core_alloc(struct device *sdev);
 int ath6kl_core_init(struct ath6kl *ar);
 int ath6kl_unavail_ev(struct ath6kl *ar);
 struct sk_buff *ath6kl_buf_alloc(int size);
+void ath6kl_cfg80211_scan_node(void *arg, struct bss *ni);
 #endif /* COMMON_H */
diff --git a/drivers/net/wireless/ath/ath6kl/node.c b/drivers/net/wireless/ath/ath6kl/node.c
index 7c9fbde..131205c 100644
--- a/drivers/net/wireless/ath/ath6kl/node.c
+++ b/drivers/net/wireless/ath/ath6kl/node.c
@@ -146,15 +146,14 @@ void wlan_free_allnodes(struct ath6kl_node_table *nt)
 		wlan_node_reclaim(nt, ni);
 }
 
-void wlan_iterate_nodes(struct ath6kl_node_table *nt,
-			void (*f) (void *arg, struct bss *), void *arg)
+void wlan_iterate_nodes(struct ath6kl_node_table *nt, void *arg)
 {
 	struct bss *ni;
 
 	spin_lock_bh(&nt->nt_nodelock);
 	for (ni = nt->nt_node_first; ni; ni = ni->ni_list_next) {
 			ni->ni_refcnt++;
-			(*f) (arg, ni);
+			ath6kl_cfg80211_scan_node(arg, ni);
 			wlan_node_dec_free(ni);
 	}
 	spin_unlock_bh(&nt->nt_nodelock);
-- 
1.7.0.4

