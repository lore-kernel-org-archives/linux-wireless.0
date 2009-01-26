Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:40901 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751957AbZAZUjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 15:39:20 -0500
From: Florian Sesser <flomaillist@cosetrain.com>
To: linux-wireless@vger.kernel.org
Cc: Florian Sesser <flomaillist@cosetrain.com>
Subject: [PATCH 6/6] mac80211: Path Selection Protocol dummy module
Date: Mon, 26 Jan 2009 21:39:15 +0100
Message-Id: <46580f6a1518f12dc2386f835865610a73d1f136.1233001803.git.flomaillist@cosetrain.com> (sfid-20090126_213928_364187_6CF41D80)
In-Reply-To: <4ffda2b82d85e1a020ec30132906e35caeaa90e0.1233001803.git.flomaillist@cosetrain.com>
References: <497E1B90.4060803@cosetrain.com>
 <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
 <3202b18e8531aa78c29636c163de20875ae1a9cf.1233001802.git.flomaillist@cosetrain.com>
 <e236615740b8ce8c9515c14aac3a2d9d93806a98.1233001802.git.flomaillist@cosetrain.com>
 <79a59b62a4378b8b88cb3a33b1ec3cbd3808906e.1233001802.git.flomaillist@cosetrain.com>
 <4ffda2b82d85e1a020ec30132906e35caeaa90e0.1233001803.git.flomaillist@cosetrain.com>
In-Reply-To: <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
References: <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can be inserted and 'used' for Path Selection
by insmodding and issuing:
iw dev <mesh-dev> set mesh_param mesh_path_selection_protocol_id 000F0F0F

Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
---
 net/mac80211/Makefile      |    2 +
 net/mac80211/mesh_pptest.c |   71 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 0 deletions(-)
 create mode 100644 net/mac80211/mesh_pptest.c

diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 796e7a6..add8ffc 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -42,6 +42,8 @@ ifdef CONFIG_MAC80211_MESH
 obj-m += mesh_hwmp.o
 endif
 
+obj-m += mesh_pptest.o
+
 mac80211-$(CONFIG_PM) += pm.o
 
 # objects for PID algorithm
diff --git a/net/mac80211/mesh_pptest.c b/net/mac80211/mesh_pptest.c
new file mode 100644
index 0000000..9841d2d
--- /dev/null
+++ b/net/mac80211/mesh_pptest.c
@@ -0,0 +1,71 @@
+#include <linux/init.h>
+#include <linux/module.h>
+#include "mesh.h"
+MODULE_LICENSE("GPL");
+
+static struct mesh_path_sel_algo pptest;
+
+static void pptest_path_start_discovery_fn (struct ieee80211_sub_if_data *sdata) {
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+}
+static int pptest_nexthop_lookup_fn (struct sk_buff *skb, struct ieee80211_sub_if_data *sdata) {
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+	return 0;
+}
+static void pptest_queue_preq_fn (struct mesh_path *mpath, u8 flags) {
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+}
+static int pptest_path_error_tx_fn (u8 *dst, __le32 dst_dsn, u8 *ra,
+				struct ieee80211_sub_if_data *sdata) {
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+	return 0;
+}
+static void pptest_path_timer_fn (unsigned long data) {
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+}
+static void pptest_rx_path_sel_frame_fn (struct ieee80211_sub_if_data *sdata,
+				struct ieee80211_mgmt *mgmt, size_t len) {
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+}
+static void pptest_path_sel_start_fn (struct ieee80211_if_mesh *sta) {
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+}
+static void pptest_path_sel_stop_fn (struct ieee80211_if_mesh *sta) {
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+}
+
+static struct mesh_path_sel_ops pptest_ops = {
+	.path_start_discovery_fn = &pptest_path_start_discovery_fn,
+	.nexthop_lookup_fn = &pptest_nexthop_lookup_fn,
+	.queue_preq_fn = &pptest_queue_preq_fn,
+	.path_error_tx_fn = &pptest_path_error_tx_fn,
+	.path_timer_fn = &pptest_path_timer_fn,
+	.rx_path_sel_frame_fn = &pptest_rx_path_sel_frame_fn,
+	.path_sel_start_fn = &pptest_path_sel_start_fn,
+	.path_sel_stop_fn = &pptest_path_sel_stop_fn,
+};
+
+static struct mesh_path_sel_algo pptest = {
+	.name = "mesh_pptest",
+	.id = 0x000F0F0F,
+	.ops = &pptest_ops,
+	.owner = THIS_MODULE,
+};
+
+static int __init init_mesh_pptest(void)
+{
+	/* init code here */
+	printk(KERN_ALERT "Hello, this is mesh_pptest speaking (__init)\n");
+	mesh_path_sel_algo_register(&pptest);
+	return 0;
+}
+
+static void __exit cleanup_mesh_pptest(void)
+{
+	/* cleanup code here */
+	printk(KERN_ALERT "Goodbye, this is mesh_pptest dying\n");
+	mesh_path_sel_algo_unregister(&pptest);
+}
+
+module_init(init_mesh_pptest);
+module_exit(cleanup_mesh_pptest);
-- 
1.5.6.5

