Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:53724 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab3CKMBX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 08:01:23 -0400
Date: Mon, 11 Mar 2013 13:01:03 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Adrian Chadd <adrian@freebsd.org>, Felix Fietkau <nbd@openwrt.org>,
	Antonio Quartulli <antonio@open-mesh.com>,
	linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Message-ID: <19067804.31217.1363003263903.JavaMail.root@neratec.com> (sfid-20130311_130126_586078_E89D5675)
In-Reply-To: <20130308141327.GA3363@pandem0nium>
References: <20130215171938.GA4140@pandem0nium> <51279AFA.3000608@openwrt.org> <20130222163643.GB3757@open-mesh.com> <5127A4E0.8080101@openwrt.org> <CAJ-Vmo=zj19mxK7aK28NkGq_KWdQtn2SYPMvdvrsd9i4-H6GPw@mail.gmail.com> <20130225102817.GA2069@pandem0nium> <20130308141327.GA3363@pandem0nium>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Simon,

tested and looks good.

I had to apply below patch to make it compile on latest
compat-drivers (hlist_for_each_entry_* API changed in 3.9).

It is definitively useful and I will start on top of it
when I get back to work on our statistics module.

I have no preferences whether to keep it separated or
integrate it upstream. If statistics are required for
mesh, there's maybe no choice other than integrating.

As for the API, I'd propose to leave it as simple as it is
now, i.e. whoever needs more / different statistics hooks
into ws_handle_frame() and adds his handlers after
ws_sta_parse_ieee80211_hdr().



Thanks for sharing this,
Zefir

---
diff --git a/Makefile b/Makefile
new file mode 100644
index 0000000..1d8cbd2
--- /dev/null
+++ b/Makefile
@@ -0,0 +1,3 @@
+obj-m += wifi_statistics.o
+wifi_statistics-y = debugfs.o hash.o station.o main.o
+
diff --git a/debugfs.c b/debugfs.c
index 94724ed..414ee4e 100644
--- a/debugfs.c
+++ b/debugfs.c
@@ -26,7 +26,6 @@ int ws_sta_seq_read(struct seq_file *seq, void *offset)
 {
 	struct ws_hash *hash = &ws_hash;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct ws_sta *ws_sta;
 	int i;
 
@@ -34,7 +33,7 @@ int ws_sta_seq_read(struct seq_file *seq, void *offset)
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(ws_sta, node, head, hash_entry)
+		hlist_for_each_entry_rcu(ws_sta, head, hash_entry)
 			ws_sta_seq_print(ws_sta, seq, offset);
 		rcu_read_unlock();
 	}
@@ -45,7 +44,7 @@ int ws_sta_seq_read_reset(struct seq_file *seq, void *offset)
 {
 	struct ws_hash *hash = &ws_hash;
 	struct hlist_head *head;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node;
 	spinlock_t *list_lock;	/* protects write access to the hash lists */
 	struct ws_sta *ws_sta;
 	int i;
@@ -56,7 +55,7 @@ int ws_sta_seq_read_reset(struct seq_file *seq, void *offset)
 
 		/* TODO: can we write while doing spinlocks?! */
 		spin_lock_bh(list_lock);
-		hlist_for_each_entry_safe(ws_sta, node, node_tmp, head, hash_entry) {
+		hlist_for_each_entry_safe(ws_sta, node, head, hash_entry) {
 			ws_sta_seq_print(ws_sta, seq, offset);
 			ws_sta_free_ref(ws_sta);
 			hlist_del_rcu(node);
diff --git a/hash.c b/hash.c
index 81e08d3..c76fc10 100644
--- a/hash.c
+++ b/hash.c
@@ -41,7 +41,6 @@ struct ws_sta *ws_hash_find(struct ws_hash *hash, u8 *mac)
 	struct ws_sta *res = NULL, *tmp_sta;
 	spinlock_t *list_lock; /* spinlock to protect write access */
 	struct hlist_head *head;
-	struct hlist_node *node;
 	u32 index;
 
 	index = ws_hash_choose(mac);
@@ -49,7 +48,7 @@ struct ws_sta *ws_hash_find(struct ws_hash *hash, u8 *mac)
 	list_lock = &hash->list_locks[index];
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(tmp_sta, node, head, hash_entry) {
+	hlist_for_each_entry_rcu(tmp_sta, head, hash_entry) {
 		if (memcmp(mac, tmp_sta->mac, ETH_ALEN))
 			continue;
 
@@ -104,7 +103,7 @@ int ws_hash_free(void)
 {
 	struct ws_hash *hash = &ws_hash; /* static for now */
 	struct ws_sta *ws_sta;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node;
 	struct hlist_head *head;
 	spinlock_t *list_lock;	/* protects write access to the hash lists */
 	int i;
@@ -114,7 +113,7 @@ int ws_hash_free(void)
 		list_lock = &hash->list_locks[i];
 
 		spin_lock_bh(list_lock);
-		hlist_for_each_entry_safe(ws_sta, node, node_tmp, head, hash_entry) {
+		hlist_for_each_entry_safe(ws_sta, node, head, hash_entry) {
 			ws_sta_free_ref(ws_sta);
 			hlist_del_rcu(node);
 		}
diff --git a/wifi-statistics.mod.c b/wifi-statistics.mod.c
deleted file mode 100644
index 198264b..0000000
--- a/wifi-statistics.mod.c
+++ /dev/null
@@ -1,64 +0,0 @@
-#include <linux/module.h>
-#include <linux/vermagic.h>
-#include <linux/compiler.h>
-
-MODULE_INFO(vermagic, VERMAGIC_STRING);
-
-struct module __this_module
-__attribute__((section(".gnu.linkonce.this_module"))) = {
- .name = KBUILD_MODNAME,
- .init = init_module,
-#ifdef CONFIG_MODULE_UNLOAD
- .exit = cleanup_module,
-#endif
- .arch = MODULE_ARCH_INIT,
-};
-
-static const struct modversion_info ____versions[]
-__used
-__attribute__((section("__versions"))) = {
-	{ 0x568fba06, "module_layout" },
-	{ 0x5a5e7ea3, "simple_read_from_buffer" },
-	{ 0xd5f8162f, "debugfs_create_dir" },
-	{ 0x9b5b51b2, "single_open" },
-	{ 0x60a13e90, "rcu_barrier" },
-	{ 0xfd492070, "single_release" },
-	{ 0x4d884691, "malloc_sizes" },
-	{ 0x34ec54de, "netdev_rx_handler_register" },
-	{ 0xc7a4fbed, "rtnl_lock" },
-	{ 0x1637ff0f, "_raw_spin_lock_bh" },
-	{ 0xb53c5051, "skb_clone" },
-	{ 0xfa1d0ed8, "dev_get_by_name" },
-	{ 0x21a7d814, "seq_printf" },
-	{ 0xc63f1b81, "ieee80211_radiotap_iterator_next" },
-	{ 0xc2a3e73d, "debugfs_create_file" },
-	{ 0x60152b00, "debugfs_remove_recursive" },
-	{ 0xcb49c52f, "seq_read" },
-	{ 0x7d11c268, "jiffies" },
-	{ 0x760a4192, "__pskb_pull_tail" },
-	{ 0x8bfe7988, "default_llseek" },
-	{ 0x37befc70, "jiffies_to_msecs" },
-	{ 0x2fa5a500, "memcmp" },
-	{ 0x982e6b6d, "ieee80211_radiotap_iterator_init" },
-	{ 0xa1c76e0a, "_cond_resched" },
-	{ 0x85abc85f, "strncmp" },
-	{ 0x86856070, "skb_pull" },
-	{ 0x3775290c, "init_net" },
-	{ 0xba63339c, "_raw_spin_unlock_bh" },
-	{ 0xb6251ac0, "netdev_rx_handler_unregister" },
-	{ 0xbb0ebf03, "kfree_skb" },
-	{ 0x7a172b67, "kmem_cache_alloc_trace" },
-	{ 0xa4b3ff06, "ieee80211_get_hdrlen_from_skb" },
-	{ 0x10166945, "seq_lseek" },
-	{ 0x50f5e532, "call_rcu_sched" },
-	{ 0x77e2f33, "_copy_from_user" },
-	{ 0x6e720ff2, "rtnl_unlock" },
-};
-
-static const char __module_depends[]
-__used
-__attribute__((section(".modinfo"))) =
-"depends=cfg80211";
-
-
-MODULE_INFO(srcversion, "2D50C255DD87C856632A707");
