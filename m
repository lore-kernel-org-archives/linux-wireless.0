Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44335 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467AbaBDAkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 19:40:36 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 15/30] mwifiex: move station list functions to common code
Date: Mon, 3 Feb 2014 16:39:59 -0800
Message-ID: <1391474403-8060-5-git-send-email-bzhao@marvell.com> (sfid-20140204_014045_316671_D47C6DE6)
In-Reply-To: <1391474403-8060-1-git-send-email-bzhao@marvell.com>
References: <1391474403-8060-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

These functions are now needed by TDLS while managing station list.
Move them from AP related file to utility file.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h      |  10 +++
 drivers/net/wireless/mwifiex/uap_event.c | 118 -------------------------------
 drivers/net/wireless/mwifiex/util.c      | 114 +++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+), 118 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 58855af..ab53fad 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1167,6 +1167,16 @@ void mwifiex_dnld_txpwr_table(struct mwifiex_private *priv);
 
 extern const struct ethtool_ops mwifiex_ethtool_ops;
 
+void mwifiex_del_all_sta_list(struct mwifiex_private *priv);
+void mwifiex_del_sta_entry(struct mwifiex_private *priv, u8 *mac);
+void
+mwifiex_set_sta_ht_cap(struct mwifiex_private *priv, const u8 *ies,
+		       int ies_len, struct mwifiex_sta_node *node);
+struct mwifiex_sta_node *
+mwifiex_add_sta_entry(struct mwifiex_private *priv, u8 *mac);
+struct mwifiex_sta_node *
+mwifiex_get_sta_entry(struct mwifiex_private *priv, u8 *mac);
+
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 7180665..2d47ba7 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -21,126 +21,8 @@
 #include "main.h"
 #include "11n.h"
 
-/*
- * This function will return the pointer to station entry in station list
- * table which matches specified mac address.
- * This function should be called after acquiring RA list spinlock.
- * NULL is returned if station entry is not found in associated STA list.
- */
-struct mwifiex_sta_node *
-mwifiex_get_sta_entry(struct mwifiex_private *priv, u8 *mac)
-{
-	struct mwifiex_sta_node *node;
-
-	if (!mac)
-		return NULL;
-
-	list_for_each_entry(node, &priv->sta_list, list) {
-		if (!memcmp(node->mac_addr, mac, ETH_ALEN))
-			return node;
-	}
 
-	return NULL;
-}
-
-/*
- * This function will add a sta_node entry to associated station list
- * table with the given mac address.
- * If entry exist already, existing entry is returned.
- * If received mac address is NULL, NULL is returned.
- */
-static struct mwifiex_sta_node *
-mwifiex_add_sta_entry(struct mwifiex_private *priv, u8 *mac)
-{
-	struct mwifiex_sta_node *node;
-	unsigned long flags;
 
-	if (!mac)
-		return NULL;
-
-	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
-	node = mwifiex_get_sta_entry(priv, mac);
-	if (node)
-		goto done;
-
-	node = kzalloc(sizeof(struct mwifiex_sta_node), GFP_ATOMIC);
-	if (!node)
-		goto done;
-
-	memcpy(node->mac_addr, mac, ETH_ALEN);
-	list_add_tail(&node->list, &priv->sta_list);
-
-done:
-	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
-	return node;
-}
-
-/*
- * This function will search for HT IE in association request IEs
- * and set station HT parameters accordingly.
- */
-static void
-mwifiex_set_sta_ht_cap(struct mwifiex_private *priv, const u8 *ies,
-		       int ies_len, struct mwifiex_sta_node *node)
-{
-	const struct ieee80211_ht_cap *ht_cap;
-
-	if (!ies)
-		return;
-
-	ht_cap = (void *)cfg80211_find_ie(WLAN_EID_HT_CAPABILITY, ies, ies_len);
-	if (ht_cap) {
-		node->is_11n_enabled = 1;
-		node->max_amsdu = le16_to_cpu(ht_cap->cap_info) &
-				  IEEE80211_HT_CAP_MAX_AMSDU ?
-				  MWIFIEX_TX_DATA_BUF_SIZE_8K :
-				  MWIFIEX_TX_DATA_BUF_SIZE_4K;
-	} else {
-		node->is_11n_enabled = 0;
-	}
-
-	return;
-}
-
-/*
- * This function will delete a station entry from station list
- */
-static void mwifiex_del_sta_entry(struct mwifiex_private *priv, u8 *mac)
-{
-	struct mwifiex_sta_node *node;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
-
-	node = mwifiex_get_sta_entry(priv, mac);
-	if (node) {
-		list_del(&node->list);
-		kfree(node);
-	}
-
-	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
-	return;
-}
-
-/*
- * This function will delete all stations from associated station list.
- */
-static void mwifiex_del_all_sta_list(struct mwifiex_private *priv)
-{
-	struct mwifiex_sta_node *node, *tmp;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
-
-	list_for_each_entry_safe(node, tmp, &priv->sta_list, list) {
-		list_del(&node->list);
-		kfree(node);
-	}
-
-	INIT_LIST_HEAD(&priv->sta_list);
-	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
-	return;
-}
 
 /*
  * This function handles AP interface specific events generated by firmware.
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 9b82e22..8d37bfc 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -252,3 +252,117 @@ int mwifiex_complete_cmd(struct mwifiex_adapter *adapter,
 
 	return 0;
 }
+
+/* This function will return the pointer to station entry in station list
+ * table which matches specified mac address.
+ * This function should be called after acquiring RA list spinlock.
+ * NULL is returned if station entry is not found in associated STA list.
+ */
+struct mwifiex_sta_node *
+mwifiex_get_sta_entry(struct mwifiex_private *priv, u8 *mac)
+{
+	struct mwifiex_sta_node *node;
+
+	if (!mac)
+		return NULL;
+
+	list_for_each_entry(node, &priv->sta_list, list) {
+		if (!memcmp(node->mac_addr, mac, ETH_ALEN))
+			return node;
+	}
+
+	return NULL;
+}
+
+/* This function will add a sta_node entry to associated station list
+ * table with the given mac address.
+ * If entry exist already, existing entry is returned.
+ * If received mac address is NULL, NULL is returned.
+ */
+struct mwifiex_sta_node *
+mwifiex_add_sta_entry(struct mwifiex_private *priv, u8 *mac)
+{
+	struct mwifiex_sta_node *node;
+	unsigned long flags;
+
+	if (!mac)
+		return NULL;
+
+	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+	node = mwifiex_get_sta_entry(priv, mac);
+	if (node)
+		goto done;
+
+	node = kzalloc(sizeof(*node), GFP_ATOMIC);
+	if (!node)
+		goto done;
+
+	memcpy(node->mac_addr, mac, ETH_ALEN);
+	list_add_tail(&node->list, &priv->sta_list);
+
+done:
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+	return node;
+}
+
+/* This function will search for HT IE in association request IEs
+ * and set station HT parameters accordingly.
+ */
+void
+mwifiex_set_sta_ht_cap(struct mwifiex_private *priv, const u8 *ies,
+		       int ies_len, struct mwifiex_sta_node *node)
+{
+	const struct ieee80211_ht_cap *ht_cap;
+
+	if (!ies)
+		return;
+
+	ht_cap = (void *)cfg80211_find_ie(WLAN_EID_HT_CAPABILITY, ies, ies_len);
+	if (ht_cap) {
+		node->is_11n_enabled = 1;
+		node->max_amsdu = le16_to_cpu(ht_cap->cap_info) &
+				  IEEE80211_HT_CAP_MAX_AMSDU ?
+				  MWIFIEX_TX_DATA_BUF_SIZE_8K :
+				  MWIFIEX_TX_DATA_BUF_SIZE_4K;
+	} else {
+		node->is_11n_enabled = 0;
+	}
+
+	return;
+}
+
+/* This function will delete a station entry from station list */
+void mwifiex_del_sta_entry(struct mwifiex_private *priv, u8 *mac)
+{
+	struct mwifiex_sta_node *node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+
+	node = mwifiex_get_sta_entry(priv, mac);
+	if (node) {
+		list_del(&node->list);
+		kfree(node);
+	}
+
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+	return;
+}
+
+/* This function will delete all stations from associated station list. */
+void mwifiex_del_all_sta_list(struct mwifiex_private *priv)
+{
+	struct mwifiex_sta_node *node, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+
+	list_for_each_entry_safe(node, tmp, &priv->sta_list, list) {
+		list_del(&node->list);
+		kfree(node);
+	}
+
+	INIT_LIST_HEAD(&priv->sta_list);
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+	return;
+}
-- 
1.8.2.3

