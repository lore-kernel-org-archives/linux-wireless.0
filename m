Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0045.outbound.protection.outlook.com ([104.47.42.45]:64231
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966988AbdLSL3g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 06:29:36 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH v2 09/10] qtnfmac: keeping track of "generation" for STA info
Date: Tue, 19 Dec 2017 14:28:55 +0300
Message-Id: <20171219112856.22463-10-sergey.matyukevich.os@quantenna.com> (sfid-20171219_122952_405122_7FD6F991)
In-Reply-To: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
References: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Keep generation in per-VIF data structure and increment it whenever STA
list is changed. Use generation value to fill struct station_info when
required.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 5 ++++-
 drivers/net/wireless/quantenna/qtnfmac/core.h     | 1 +
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 5 +++--
 drivers/net/wireless/quantenna/qtnfmac/util.c     | 8 ++++++--
 drivers/net/wireless/quantenna/qtnfmac/util.h     | 4 ++--
 5 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index be15d0ed362c..cedb18e04bc2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -418,6 +418,7 @@ qtnf_get_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
 
+	sinfo->generation = vif->generation;
 	return qtnf_cmd_get_sta_info(vif, mac, sinfo);
 }
 
@@ -439,11 +440,13 @@ qtnf_dump_station(struct wiphy *wiphy, struct net_device *dev,
 	ret = qtnf_cmd_get_sta_info(vif, sta_node->mac_addr, sinfo);
 
 	if (unlikely(ret == -ENOENT)) {
-		qtnf_sta_list_del(&vif->sta_list, mac);
+		qtnf_sta_list_del(vif, mac);
 		cfg80211_del_sta(vif->netdev, mac, GFP_KERNEL);
 		sinfo->filled = 0;
 	}
 
+	sinfo->generation = vif->generation;
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index d7e295efb07d..e7bd21ed371b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -88,6 +88,7 @@ struct qtnf_vif {
 	struct work_struct reset_work;
 	struct qtnf_sta_list sta_list;
 	unsigned long cons_tx_timeout_cnt;
+	int generation;
 };
 
 struct qtnf_mac_info {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index b3489b5b5d9e..8a3d2b1194e4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -59,10 +59,11 @@ qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 	pr_debug("VIF%u.%u: MAC:%pM FC:%x\n", mac->macid, vif->vifid, sta_addr,
 		 frame_control);
 
-	qtnf_sta_list_add(&vif->sta_list, sta_addr);
+	qtnf_sta_list_add(vif, sta_addr);
 
 	sinfo.assoc_req_ies = NULL;
 	sinfo.assoc_req_ies_len = 0;
+	sinfo.generation = vif->generation;
 
 	payload_len = len - sizeof(*sta_assoc);
 	tlv = (const struct qlink_tlv_hdr *)sta_assoc->ies;
@@ -132,7 +133,7 @@ qtnf_event_handle_sta_deauth(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 	pr_debug("VIF%u.%u: MAC:%pM reason:%x\n", mac->macid, vif->vifid,
 		 sta_addr, reason);
 
-	if (qtnf_sta_list_del(&vif->sta_list, sta_addr))
+	if (qtnf_sta_list_del(vif, sta_addr))
 		cfg80211_del_sta(vif->netdev, sta_deauth->sta_addr,
 				 GFP_KERNEL);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.c b/drivers/net/wireless/quantenna/qtnfmac/util.c
index ed38e87471bf..e745733ba417 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.c
@@ -57,9 +57,10 @@ struct qtnf_sta_node *qtnf_sta_list_lookup_index(struct qtnf_sta_list *list,
 	return NULL;
 }
 
-struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_sta_list *list,
+struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_vif *vif,
 					const u8 *mac)
 {
+	struct qtnf_sta_list *list = &vif->sta_list;
 	struct qtnf_sta_node *node;
 
 	if (unlikely(!mac))
@@ -77,13 +78,15 @@ struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_sta_list *list,
 	ether_addr_copy(node->mac_addr, mac);
 	list_add_tail(&node->list, &list->head);
 	atomic_inc(&list->size);
+	++vif->generation;
 
 done:
 	return node;
 }
 
-bool qtnf_sta_list_del(struct qtnf_sta_list *list, const u8 *mac)
+bool qtnf_sta_list_del(struct qtnf_vif *vif, const u8 *mac)
 {
+	struct qtnf_sta_list *list = &vif->sta_list;
 	struct qtnf_sta_node *node;
 	bool ret = false;
 
@@ -93,6 +96,7 @@ bool qtnf_sta_list_del(struct qtnf_sta_list *list, const u8 *mac)
 		list_del(&node->list);
 		atomic_dec(&list->size);
 		kfree(node);
+		++vif->generation;
 		ret = true;
 	}
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.h b/drivers/net/wireless/quantenna/qtnfmac/util.h
index 0359eae8c24b..0d4d92b11540 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.h
@@ -26,9 +26,9 @@ struct qtnf_sta_node *qtnf_sta_list_lookup(struct qtnf_sta_list *list,
 					   const u8 *mac);
 struct qtnf_sta_node *qtnf_sta_list_lookup_index(struct qtnf_sta_list *list,
 						 size_t index);
-struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_sta_list *list,
+struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_vif *vif,
 					const u8 *mac);
-bool qtnf_sta_list_del(struct qtnf_sta_list *list, const u8 *mac);
+bool qtnf_sta_list_del(struct qtnf_vif *vif, const u8 *mac);
 
 void qtnf_sta_list_free(struct qtnf_sta_list *list);
 
-- 
2.11.0
