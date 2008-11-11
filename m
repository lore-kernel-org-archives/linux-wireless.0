Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57360 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbYKKWBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 17:01:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC PATCH 2/4] lib80211: consolidate crypt init routines
Date: Tue, 11 Nov 2008 16:51:03 -0500
Message-Id: <1226440265-21240-2-git-send-email-linville@tuxdriver.com> (sfid-20081111_230119_106489_ECA76D13)
In-Reply-To: <1226440265-21240-1-git-send-email-linville@tuxdriver.com>
References: <>
 <1226440265-21240-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/hostap/hostap_hw.c    |   61 +---------------------------
 drivers/net/wireless/hostap/hostap_ioctl.c |   43 ++++---------------
 include/net/lib80211.h                     |    3 +
 net/ieee80211/ieee80211_module.c           |   26 +-----------
 net/wireless/lib80211.c                    |   38 +++++++++++++++++
 5 files changed, 54 insertions(+), 117 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 5c5dfd6..89f41f6 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -2792,46 +2792,6 @@ static void prism2_check_sta_fw_version(local_info_t *local)
 }
 
 
-static void prism2_crypt_deinit_entries(local_info_t *local, int force)
-{
-	struct list_head *ptr, *n;
-	struct lib80211_crypt_data *entry;
-
-	for (ptr = local->crypt_info.crypt_deinit_list.next, n = ptr->next;
-	     ptr != &local->crypt_info.crypt_deinit_list;
-	     ptr = n, n = ptr->next) {
-		entry = list_entry(ptr, struct lib80211_crypt_data, list);
-
-		if (atomic_read(&entry->refcnt) != 0 && !force)
-			continue;
-
-		list_del(ptr);
-
-		if (entry->ops)
-			entry->ops->deinit(entry->priv);
-		kfree(entry);
-	}
-}
-
-
-static void prism2_crypt_deinit_handler(unsigned long data)
-{
-	local_info_t *local = (local_info_t *) data;
-	unsigned long flags;
-
-	spin_lock_irqsave(&local->lock, flags);
-	prism2_crypt_deinit_entries(local, 0);
-	if (!list_empty(&local->crypt_info.crypt_deinit_list)) {
-		printk(KERN_DEBUG "%s: entries remaining in delayed crypt "
-		       "deletion list\n", local->dev->name);
-		local->crypt_info.crypt_deinit_timer.expires = jiffies + HZ;
-		add_timer(&local->crypt_info.crypt_deinit_timer);
-	}
-	spin_unlock_irqrestore(&local->lock, flags);
-
-}
-
-
 static void hostap_passive_scan(unsigned long data)
 {
 	local_info_t *local = (local_info_t *) data;
@@ -3256,12 +3216,7 @@ while (0)
 	INIT_LIST_HEAD(&local->cmd_queue);
 	init_waitqueue_head(&local->hostscan_wq);
 
-	local->crypt_info.name = dev->name;
-	local->crypt_info.lock = &local->lock;
-	INIT_LIST_HEAD(&local->crypt_info.crypt_deinit_list);
-	init_timer(&local->crypt_info.crypt_deinit_timer);
-	local->crypt_info.crypt_deinit_timer.data = (unsigned long) local;
-	local->crypt_info.crypt_deinit_timer.function = prism2_crypt_deinit_handler;
+	lib80211_crypt_info_init(&local->crypt_info, dev->name, &local->lock);
 
 	init_timer(&local->passive_scan_timer);
 	local->passive_scan_timer.data = (unsigned long) local;
@@ -3362,9 +3317,7 @@ static void prism2_free_local_data(struct net_device *dev)
 
 	flush_scheduled_work();
 
-	if (timer_pending(&local->crypt_info.crypt_deinit_timer))
-		del_timer(&local->crypt_info.crypt_deinit_timer);
-	prism2_crypt_deinit_entries(local, 1);
+	lib80211_crypt_info_free(&local->crypt_info);
 
 	if (timer_pending(&local->passive_scan_timer))
 		del_timer(&local->passive_scan_timer);
@@ -3381,16 +3334,6 @@ static void prism2_free_local_data(struct net_device *dev)
 	if (local->dev_enabled)
 		prism2_callback(local, PRISM2_CALLBACK_DISABLE);
 
-	for (i = 0; i < WEP_KEYS; i++) {
-		struct lib80211_crypt_data *crypt = local->crypt_info.crypt[i];
-		if (crypt) {
-			if (crypt->ops)
-				crypt->ops->deinit(crypt->priv);
-			kfree(crypt);
-			local->crypt_info.crypt[i] = NULL;
-		}
-	}
-
 	if (local->ap != NULL)
 		hostap_free_data(local->ap);
 
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index baf0a26..6bb9be0 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -116,32 +116,6 @@ static int prism2_get_name(struct net_device *dev,
 }
 
 
-static void prism2_crypt_delayed_deinit(local_info_t *local,
-					struct lib80211_crypt_data **crypt)
-{
-	struct lib80211_crypt_data *tmp;
-	unsigned long flags;
-
-	tmp = *crypt;
-	*crypt = NULL;
-
-	if (tmp == NULL)
-		return;
-
-	/* must not run ops->deinit() while there may be pending encrypt or
-	 * decrypt operations. Use a list of delayed deinits to avoid needing
-	 * locking. */
-
-	spin_lock_irqsave(&local->lock, flags);
-	list_add(&tmp->list, &local->crypt_info.crypt_deinit_list);
-	if (!timer_pending(&local->crypt_info.crypt_deinit_timer)) {
-		local->crypt_info.crypt_deinit_timer.expires = jiffies + HZ;
-		add_timer(&local->crypt_info.crypt_deinit_timer);
-	}
-	spin_unlock_irqrestore(&local->lock, flags);
-}
-
-
 static int prism2_ioctl_siwencode(struct net_device *dev,
 				  struct iw_request_info *info,
 				  struct iw_point *erq, char *keybuf)
@@ -166,14 +140,14 @@ static int prism2_ioctl_siwencode(struct net_device *dev,
 
 	if (erq->flags & IW_ENCODE_DISABLED) {
 		if (*crypt)
-			prism2_crypt_delayed_deinit(local, crypt);
+			lib80211_crypt_delayed_deinit(&local->crypt_info, crypt);
 		goto done;
 	}
 
 	if (*crypt != NULL && (*crypt)->ops != NULL &&
 	    strcmp((*crypt)->ops->name, "WEP") != 0) {
 		/* changing to use WEP; deinit previously used algorithm */
-		prism2_crypt_delayed_deinit(local, crypt);
+		lib80211_crypt_delayed_deinit(&local->crypt_info, crypt);
 	}
 
 	if (*crypt == NULL) {
@@ -189,7 +163,7 @@ static int prism2_ioctl_siwencode(struct net_device *dev,
 			request_module("lib80211_crypt_wep");
 			new_crypt->ops = lib80211_get_crypto_ops("WEP");
 		}
-		if (new_crypt->ops)
+		if (new_crypt->ops && try_module_get(new_crypt->ops->owner))
 			new_crypt->priv = new_crypt->ops->init(i);
 		if (!new_crypt->ops || !new_crypt->priv) {
 			kfree(new_crypt);
@@ -3271,7 +3245,7 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 	if ((erq->flags & IW_ENCODE_DISABLED) ||
 	    ext->alg == IW_ENCODE_ALG_NONE) {
 		if (*crypt)
-			prism2_crypt_delayed_deinit(local, crypt);
+			lib80211_crypt_delayed_deinit(&local->crypt_info, crypt);
 		goto done;
 	}
 
@@ -3319,7 +3293,7 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 	if (*crypt == NULL || (*crypt)->ops != ops) {
 		struct lib80211_crypt_data *new_crypt;
 
-		prism2_crypt_delayed_deinit(local, crypt);
+		lib80211_crypt_delayed_deinit(&local->crypt_info, crypt);
 
 		new_crypt = kzalloc(sizeof(struct lib80211_crypt_data),
 				GFP_KERNEL);
@@ -3328,7 +3302,8 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 			goto done;
 		}
 		new_crypt->ops = ops;
-		new_crypt->priv = new_crypt->ops->init(i);
+		if (new_crypt->ops && try_module_get(new_crypt->ops->owner))
+			new_crypt->priv = new_crypt->ops->init(i);
 		if (new_crypt->priv == NULL) {
 			kfree(new_crypt);
 			ret = -EINVAL;
@@ -3505,7 +3480,7 @@ static int prism2_ioctl_set_encryption(local_info_t *local,
 
 	if (strcmp(param->u.crypt.alg, "none") == 0) {
 		if (crypt)
-			prism2_crypt_delayed_deinit(local, crypt);
+			lib80211_crypt_delayed_deinit(&local->crypt_info, crypt);
 		goto done;
 	}
 
@@ -3535,7 +3510,7 @@ static int prism2_ioctl_set_encryption(local_info_t *local,
 	if (*crypt == NULL || (*crypt)->ops != ops) {
 		struct lib80211_crypt_data *new_crypt;
 
-		prism2_crypt_delayed_deinit(local, crypt);
+		lib80211_crypt_delayed_deinit(&local->crypt_info, crypt);
 
 		new_crypt = kzalloc(sizeof(struct lib80211_crypt_data),
 				GFP_KERNEL);
diff --git a/include/net/lib80211.h b/include/net/lib80211.h
index dd1079f..a269b23 100644
--- a/include/net/lib80211.h
+++ b/include/net/lib80211.h
@@ -114,6 +114,9 @@ struct lib80211_crypt_info {
 	int crypt_quiesced;
 };
 
+int lib80211_crypt_info_init(struct lib80211_crypt_info *info, char *name,
+                                spinlock_t *lock);
+void lib80211_crypt_info_free(struct lib80211_crypt_info *info);
 int lib80211_register_crypto_ops(struct lib80211_crypto_ops *ops);
 int lib80211_unregister_crypto_ops(struct lib80211_crypto_ops *ops);
 struct lib80211_crypto_ops *lib80211_get_crypto_ops(const char *name);
diff --git a/net/ieee80211/ieee80211_module.c b/net/ieee80211/ieee80211_module.c
index cf21f0b..a2f5616 100644
--- a/net/ieee80211/ieee80211_module.c
+++ b/net/ieee80211/ieee80211_module.c
@@ -182,13 +182,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 
 	spin_lock_init(&ieee->lock);
 
-	ieee->crypt_info.name = dev->name;
-	ieee->crypt_info.lock = &ieee->lock;
-	INIT_LIST_HEAD(&ieee->crypt_info.crypt_deinit_list);
-	setup_timer(&ieee->crypt_info.crypt_deinit_timer,
-			lib80211_crypt_deinit_handler,
-			(unsigned long)&ieee->crypt_info);
-	ieee->crypt_info.crypt_quiesced = 0;
+	lib80211_crypt_info_init(&ieee->crypt_info, dev->name, &ieee->lock);
 
 	ieee->wpa_enabled = 0;
 	ieee->drop_unencrypted = 0;
@@ -206,23 +200,7 @@ void free_ieee80211(struct net_device *dev)
 {
 	struct ieee80211_device *ieee = netdev_priv(dev);
 
-	int i;
-
-	lib80211_crypt_quiescing(&ieee->crypt_info);
-	del_timer_sync(&ieee->crypt_info.crypt_deinit_timer);
-	lib80211_crypt_deinit_entries(&ieee->crypt_info, 1);
-
-	for (i = 0; i < WEP_KEYS; i++) {
-		struct lib80211_crypt_data *crypt = ieee->crypt_info.crypt[i];
-		if (crypt) {
-			if (crypt->ops) {
-				crypt->ops->deinit(crypt->priv);
-				module_put(crypt->ops->owner);
-			}
-			kfree(crypt);
-			ieee->crypt_info.crypt[i] = NULL;
-		}
-	}
+	lib80211_crypt_info_free(&ieee->crypt_info);
 
 	ieee80211_networks_free(ieee);
 	free_netdev(dev);
diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index d681721..97d411f 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -71,6 +71,44 @@ const char *print_ssid(char *buf, const char *ssid, u8 ssid_len)
 }
 EXPORT_SYMBOL(print_ssid);
 
+int lib80211_crypt_info_init(struct lib80211_crypt_info *info, char *name,
+				spinlock_t *lock)
+{
+	memset(info, 0, sizeof(*info));
+
+	info->name = name;
+	info->lock = lock;
+
+	INIT_LIST_HEAD(&info->crypt_deinit_list);
+	setup_timer(&info->crypt_deinit_timer, lib80211_crypt_deinit_handler,
+			(unsigned long)info);
+
+	return 0;
+}
+EXPORT_SYMBOL(lib80211_crypt_info_init);
+
+void lib80211_crypt_info_free(struct lib80211_crypt_info *info)
+{
+	int i;
+
+        lib80211_crypt_quiescing(info);
+        del_timer_sync(&info->crypt_deinit_timer);
+        lib80211_crypt_deinit_entries(info, 1);
+
+        for (i = 0; i < NUM_WEP_KEYS; i++) {
+                struct lib80211_crypt_data *crypt = info->crypt[i];
+                if (crypt) {
+                        if (crypt->ops) {
+                                crypt->ops->deinit(crypt->priv);
+                                module_put(crypt->ops->owner);
+                        }
+                        kfree(crypt);
+                        info->crypt[i] = NULL;
+                }
+        }
+}
+EXPORT_SYMBOL(lib80211_crypt_info_free);
+
 void lib80211_crypt_deinit_entries(struct lib80211_crypt_info *info, int force)
 {
 	struct lib80211_crypt_data *entry, *next;
-- 
1.5.4.3

