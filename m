Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43600 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab3FRWDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 18:03:51 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/6] wireless:  Add memory usage debugging.
Date: Tue, 18 Jun 2013 15:03:32 -0700
Message-Id: <1371593017-10985-1-git-send-email-greearb@candelatech.com> (sfid-20130619_000356_212228_4AEA7C87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The bss objects are reference counted, and the ies
are also tricky to keep track of.  Add option to
track allocation and freeing of the ies and bss objects,
and add debugfs files to show the current objects.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/wireless/Kconfig   |   13 +++++
 net/wireless/core.c    |    5 +-
 net/wireless/core.h    |   17 ++++++
 net/wireless/debugfs.c |  117 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/debugfs.h |    2 +
 net/wireless/scan.c    |  127 ++++++++++++++++++++++++++++++++++++++++++------
 6 files changed, 264 insertions(+), 17 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 16d08b3..43ec2cd 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -115,6 +115,19 @@ config CFG80211_DEBUGFS
 
 	  If unsure, say N.
 
+config CFG80211_MEM_DEBUGGING
+	bool "cfg80211 memory debugging logic"
+	default n
+	depends on CFG80211_DEBUGFS
+	---help---
+	  Enable this if you want to debug memory handling for bss and ies
+	  objects.  New debugfs files: ieee80211/all_ies and all_bss will
+	  be created to display these objects.  This has a moderate CPU cost
+	  and uses a bit more memory than normal, but otherwise is not very
+	  expensive.
+
+	  If unsure, say N.
+
 config CFG80211_INTERNAL_REGDB
 	bool "use statically compiled regulatory rules database" if EXPERT
 	default n
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9f08203..eb3e1de 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1123,6 +1123,7 @@ static int __init cfg80211_init(void)
 		goto out_fail_nl80211;
 
 	ieee80211_debugfs_dir = debugfs_create_dir("ieee80211", NULL);
+	ieee80211_debugfs_add_glbl(ieee80211_debugfs_dir);
 
 	err = regulatory_init();
 	if (err)
@@ -1137,7 +1138,7 @@ static int __init cfg80211_init(void)
 out_fail_wq:
 	regulatory_exit();
 out_fail_reg:
-	debugfs_remove(ieee80211_debugfs_dir);
+	debugfs_remove_recursive(ieee80211_debugfs_dir);
 out_fail_nl80211:
 	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
 out_fail_notifier:
@@ -1151,7 +1152,7 @@ subsys_initcall(cfg80211_init);
 
 static void __exit cfg80211_exit(void)
 {
-	debugfs_remove(ieee80211_debugfs_dir);
+	debugfs_remove_recursive(ieee80211_debugfs_dir);
 	nl80211_exit();
 	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
 	wiphy_sysfs_exit();
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 71b7285..e75be56 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -126,6 +126,23 @@ static inline void assert_cfg80211_lock(void)
 	lockdep_assert_held(&cfg80211_mutex);
 }
 
+#ifdef CONFIG_CFG80211_MEM_DEBUGGING
+
+struct wifi_mem_tracker {
+	struct list_head mylist;
+	char buf[40];
+	void *ptr;
+};
+extern struct list_head ies_list;
+extern spinlock_t ies_lock;
+extern atomic_t ies_count;
+
+extern struct list_head bss_list;
+extern spinlock_t bss_lock;
+extern atomic_t bss_count;
+
+#endif
+
 struct cfg80211_internal_bss {
 	struct list_head list;
 	struct list_head hidden_list;
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 920cabe..96dc757 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -31,6 +31,110 @@ static const struct file_operations name## _ops = {			\
 	.llseek = generic_file_llseek,					\
 };
 
+#define DEBUGFS_READONLY_FILE_OPS(name) \
+static const struct file_operations name## _ops = {			\
+	.read = name## _read,						\
+	.open = simple_open,						\
+	.llseek = generic_file_llseek,					\
+};
+
+#ifdef CONFIG_CFG80211_MEM_DEBUGGING
+static ssize_t all_ies_read(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	int mxln = 31500;
+	char *buf = kzalloc(mxln, GFP_KERNEL);
+	int q, res = 0;
+	struct wifi_mem_tracker *iesm;
+
+	if (!buf)
+		return 0;
+
+	spin_lock_bh(&ies_lock);
+	res += sprintf(buf + res, "Total: %i\n", atomic_read(&ies_count));
+	list_for_each_entry(iesm, &ies_list, mylist) {
+		res += sprintf(buf + res, "%p: %s\n",
+			       iesm->ptr, iesm->buf);
+		if (res >= mxln) {
+			res = mxln;
+			break;
+		}
+	}
+	spin_unlock_bh(&ies_lock);
+
+	q = simple_read_from_buffer(user_buf, count, ppos, buf, res);
+	kfree(buf);
+	return q;
+}
+
+static ssize_t all_bss_read(struct file *file, char __user *user_buf,
+			    size_t count, loff_t *ppos)
+{
+	int mxln = 31500;
+	char *buf = kzalloc(mxln, GFP_KERNEL);
+	int q, res = 0;
+	struct wifi_mem_tracker *bssm;
+
+	if (!buf)
+		return 0;
+
+	spin_lock_bh(&bss_lock);
+	res += sprintf(buf + res, "Total: %i\n", atomic_read(&bss_count));
+	list_for_each_entry(bssm, &bss_list, mylist) {
+		struct cfg80211_internal_bss *bss;
+		bss = (struct cfg80211_internal_bss *)(bssm->ptr);
+		res += sprintf(buf + res, "%p: #%lu %s\n",
+			       bssm->ptr, bss->refcount, bssm->buf);
+		if (res >= mxln) {
+			res = mxln;
+			break;
+		}
+	}
+	spin_unlock_bh(&bss_lock);
+
+	q = simple_read_from_buffer(user_buf, count, ppos, buf, res);
+	kfree(buf);
+	return q;
+}
+
+DEBUGFS_READONLY_FILE_OPS(all_ies);
+DEBUGFS_READONLY_FILE_OPS(all_bss);
+
+#endif
+
+static ssize_t bss_read(struct file *file, char __user *user_buf,
+			size_t count, loff_t *ppos)
+{
+	struct wiphy *wiphy = file->private_data;
+	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
+	int mxln = 31500;
+	char *buf = kzalloc(mxln, GFP_KERNEL);
+	int q, res = 0;
+	struct cfg80211_internal_bss *bss;
+
+	if (!buf)
+		return 0;
+
+	spin_lock_bh(&dev->bss_lock);
+	list_for_each_entry(bss, &dev->bss_list, list) {
+		res += sprintf(buf + res,
+			       "%p: #%lu  bcn: %p  pr: %p  hidden: %p\n",
+			       bss, bss->refcount,
+			       rcu_access_pointer(bss->pub.beacon_ies),
+			       rcu_access_pointer(bss->pub.proberesp_ies),
+			       bss->pub.hidden_beacon_bss);
+		if (res >= mxln) {
+			res = mxln;
+			break;
+		}
+	}
+	spin_unlock_bh(&dev->bss_lock);
+
+	q = simple_read_from_buffer(user_buf, count, ppos, buf, res);
+	kfree(buf);
+	return q;
+}
+
 DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
 		      wiphy->rts_threshold)
 DEBUGFS_READONLY_FILE(fragmentation_threshold, 20, "%d",
@@ -39,6 +143,7 @@ DEBUGFS_READONLY_FILE(short_retry_limit, 20, "%d",
 		      wiphy->retry_short)
 DEBUGFS_READONLY_FILE(long_retry_limit, 20, "%d",
 		      wiphy->retry_long);
+DEBUGFS_READONLY_FILE_OPS(bss);
 
 static int ht_print_chan(struct ieee80211_channel *chan,
 			 char *buf, int buf_size, int offset)
@@ -112,4 +217,16 @@ void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev)
 	DEBUGFS_ADD(short_retry_limit);
 	DEBUGFS_ADD(long_retry_limit);
 	DEBUGFS_ADD(ht40allow_map);
+	DEBUGFS_ADD(bss);
+}
+
+#define DEBUGFS_ADD_GLBL(name)						\
+	debugfs_create_file(#name, S_IRUGO, dir, NULL, &name## _ops);
+
+void ieee80211_debugfs_add_glbl(struct dentry *dir)
+{
+#ifdef CONFIG_CFG80211_MEM_DEBUGGING
+	DEBUGFS_ADD_GLBL(all_ies);
+	DEBUGFS_ADD_GLBL(all_bss);
+#endif
 }
diff --git a/net/wireless/debugfs.h b/net/wireless/debugfs.h
index 74fdd38..f644869 100644
--- a/net/wireless/debugfs.h
+++ b/net/wireless/debugfs.h
@@ -3,9 +3,11 @@
 
 #ifdef CONFIG_CFG80211_DEBUGFS
 void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev);
+void ieee80211_debugfs_add_glbl(struct dentry *dir);
 #else
 static inline
 void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev) {}
+static inline void ieee80211_debugfs_add_glbl(struct dentry *dir) { }
 #endif
 
 #endif /* __CFG80211_DEBUGFS_H */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index fd99ea4..542ff6d 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -57,6 +57,106 @@
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)
 
+#ifdef CONFIG_CFG80211_MEM_DEBUGGING
+
+LIST_HEAD(ies_list);
+DEFINE_SPINLOCK(ies_lock);
+atomic_t ies_count = ATOMIC_INIT(0);
+
+LIST_HEAD(bss_list);
+DEFINE_SPINLOCK(bss_lock);
+atomic_t bss_count = ATOMIC_INIT(0);
+
+
+static void my_kfree_rcu_ies(struct cfg80211_bss_ies *ies)
+{
+	struct wifi_mem_tracker *iesm;
+	spin_lock_bh(&ies_lock);
+	list_for_each_entry(iesm, &ies_list, mylist) {
+		if (iesm->ptr == ies) {
+			list_del(&iesm->mylist);
+			kfree(iesm);
+			break;
+		}
+	}
+	spin_unlock_bh(&ies_lock);
+	atomic_sub(1, &ies_count);
+	kfree_rcu(ies, rcu_head);
+}
+
+#define my_kmalloc_ies(s, g)				\
+	_my_kmalloc_ies(s, g, __LINE__);
+
+static void* _my_kmalloc_ies(size_t s, gfp_t gfp, int l)
+{
+	void *rv = kmalloc(s, gfp);
+	if (rv) {
+		struct wifi_mem_tracker *iesm = kmalloc(sizeof(*iesm), gfp);
+		atomic_add(1, &ies_count);
+		if (iesm) {
+			snprintf(iesm->buf, sizeof(iesm->buf), "%i", l);
+			iesm->buf[sizeof(iesm->buf)-1] = 0;
+			iesm->ptr = rv;
+			INIT_LIST_HEAD(&iesm->mylist);
+			spin_lock_bh(&ies_lock);
+			list_add(&iesm->mylist, &ies_list);
+			spin_unlock_bh(&ies_lock);
+		} else {
+			pr_err("ERROR:  Could not allocate iesm.\n");
+		}
+	}
+	return rv;
+}
+
+static void my_kfree_bss(struct cfg80211_internal_bss *bss)
+{
+	struct wifi_mem_tracker *bssm;
+	spin_lock_bh(&bss_lock);
+	list_for_each_entry(bssm, &bss_list, mylist) {
+		if (bssm->ptr == bss) {
+			list_del(&bssm->mylist);
+			kfree(bssm);
+			break;
+		}
+	}
+	atomic_sub(1, &bss_count);
+	spin_unlock_bh(&bss_lock);
+	kfree(bss);
+}
+
+#define my_kzalloc_bss(s, g)				\
+	_my_kzalloc_bss(s, g, __LINE__);
+
+static void* _my_kzalloc_bss(size_t s, gfp_t gfp, int l)
+{
+	void *rv = kmalloc(s, gfp);
+	if (rv) {
+		struct wifi_mem_tracker *bssm = kmalloc(sizeof(*bssm), gfp);
+		atomic_add(1, &bss_count);
+		if (bssm) {
+			snprintf(bssm->buf, sizeof(bssm->buf), "%i", l);
+			bssm->buf[sizeof(bssm->buf)-1] = 0;
+			bssm->ptr = rv;
+			INIT_LIST_HEAD(&bssm->mylist);
+			spin_lock_bh(&bss_lock);
+			list_add(&bssm->mylist, &bss_list);
+			spin_unlock_bh(&bss_lock);
+		} else {
+			pr_err("ERROR:  Could not allocate bssm for bss.\n");
+		}
+	}
+	return rv;
+}
+
+#else
+
+#define my_kfree_rcu_ies(ies) kfree_rcu(ies, rcu_head)
+#define my_kmalloc_ies(s, g) kmalloc(s, g)
+#define my_kfree_bss(a) kfree(a)
+#define my_kzalloc_bss(s, g) kzalloc(s, g)
+
+#endif
+
 static void bss_free(struct cfg80211_internal_bss *bss)
 {
 	struct cfg80211_bss_ies *ies;
@@ -66,10 +166,10 @@ static void bss_free(struct cfg80211_internal_bss *bss)
 
 	ies = (void *)rcu_access_pointer(bss->pub.beacon_ies);
 	if (ies && !bss->pub.hidden_beacon_bss)
-		kfree_rcu(ies, rcu_head);
+		my_kfree_rcu_ies(ies);
 	ies = (void *)rcu_access_pointer(bss->pub.proberesp_ies);
 	if (ies)
-		kfree_rcu(ies, rcu_head);
+		my_kfree_rcu_ies(ies);
 
 	/*
 	 * This happens when the module is removed, it doesn't
@@ -78,7 +178,7 @@ static void bss_free(struct cfg80211_internal_bss *bss)
 	if (!list_empty(&bss->hidden_list))
 		list_del(&bss->hidden_list);
 
-	kfree(bss);
+	my_kfree_bss(bss);
 }
 
 static inline void bss_ref_get(struct cfg80211_registered_device *dev,
@@ -710,8 +810,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 			rcu_assign_pointer(found->pub.ies,
 					   tmp->pub.proberesp_ies);
 			if (old)
-				kfree_rcu((struct cfg80211_bss_ies *)old,
-					  rcu_head);
+				my_kfree_rcu_ies((struct cfg80211_bss_ies *)old);
 		} else if (rcu_access_pointer(tmp->pub.beacon_ies)) {
 			const struct cfg80211_bss_ies *old;
 			struct cfg80211_internal_bss *bss;
@@ -731,8 +830,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 				 */
 
 				f = rcu_access_pointer(tmp->pub.beacon_ies);
-				kfree_rcu((struct cfg80211_bss_ies *)f,
-					  rcu_head);
+				my_kfree_rcu_ies((struct cfg80211_bss_ies *)f);
 				goto drop;
 			}
 
@@ -759,8 +857,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 			}
 
 			if (old)
-				kfree_rcu((struct cfg80211_bss_ies *)old,
-					  rcu_head);
+				my_kfree_rcu_ies((struct cfg80211_bss_ies *)old);
 		}
 
 		found->pub.beacon_interval = tmp->pub.beacon_interval;
@@ -777,15 +874,15 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 		 * is allocated on the stack since it's not needed in the
 		 * more common case of an update
 		 */
-		new = kzalloc(sizeof(*new) + dev->wiphy.bss_priv_size,
-			      GFP_ATOMIC);
+		new = my_kzalloc_bss(sizeof(*new) + dev->wiphy.bss_priv_size,
+				     GFP_ATOMIC);
 		if (!new) {
 			ies = (void *)rcu_dereference(tmp->pub.beacon_ies);
 			if (ies)
-				kfree_rcu(ies, rcu_head);
+				my_kfree_rcu_ies(ies);
 			ies = (void *)rcu_dereference(tmp->pub.proberesp_ies);
 			if (ies)
-				kfree_rcu(ies, rcu_head);
+				my_kfree_rcu_ies(ies);
 			goto drop;
 		}
 		memcpy(new, tmp, sizeof(*new));
@@ -899,7 +996,7 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 	 * override the IEs pointer should we have received an earlier
 	 * indication of Probe Response data.
 	 */
-	ies = kmalloc(sizeof(*ies) + ielen, gfp);
+	ies = my_kmalloc_ies(sizeof(*ies) + ielen, gfp);
 	if (!ies)
 		return NULL;
 	ies->len = ielen;
@@ -956,7 +1053,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	if (!channel)
 		return NULL;
 
-	ies = kmalloc(sizeof(*ies) + ielen, gfp);
+	ies = my_kmalloc_ies(sizeof(*ies) + ielen, gfp);
 	if (!ies)
 		return NULL;
 	ies->len = ielen;
-- 
1.7.3.4

