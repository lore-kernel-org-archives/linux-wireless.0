Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:50006 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753245AbZBHTwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 14:52:33 -0500
From: Florian Sesser <flomaillist@cosetrain.com>
To: linux-wireless@vger.kernel.org
Cc: Florian Sesser <flomaillist@cosetrain.com>
Subject: [PATCH 3/3] mac80211: Modul. mesh path prot: Skeleton Module
Date: Sun,  8 Feb 2009 20:52:22 +0100
Message-Id: <944d8e06a2b02e5ae6d612fb435d540958023ff9.1234118418.git.flomaillist@cosetrain.com> (sfid-20090208_205238_672681_BE3F6B7E)
In-Reply-To: <897787d59c53459e0bff3a6829ac470f6ed2e84e.1234118418.git.flomaillist@cosetrain.com>
References: <498F36B7.40806@cosetrain.com>
 <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com>
 <897787d59c53459e0bff3a6829ac470f6ed2e84e.1234118418.git.flomaillist@cosetrain.com>
In-Reply-To: <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com>
References: <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modularize mesh path selection protocol.

This patch provides a skeleton module, which registers itself
upon being loaded into the kernel, but does not really do path
selection.

Make a mesh device use this module by insmodding it and
issuing:
iw dev <mesh-dev> set mesh_param mesh_path_selection_protocol_id 000F0F0F
(of course after patching IW).

Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
---
 net/mac80211/Kconfig       |   19 +++++++++--
 net/mac80211/Makefile      |    2 +
 net/mac80211/mesh_pptest.c |   81 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 3 deletions(-)
 create mode 100644 net/mac80211/mesh_pptest.c

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 60c1616..e635f15 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -65,10 +65,23 @@ config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
 	depends on MAC80211 && EXPERIMENTAL
 	---help---
-	 This options enables support of Draft 802.11s mesh networking.
-	 The implementation is based on Draft 1.08 of the Mesh Networking
-	 amendment. For more information visit http://o11s.org/.
+	  This options enables support of Draft 802.11s mesh networking.
+	  The implementation is based on Draft 1.08 of the Mesh Networking
+	  amendment. For more information visit http://o11s.org/.
 
+	  Includes the HWMP Mesh path selection protocol, as that
+	  is a requirement of the (Draft) standard.
+
+config MAC80211_MESH_PP_TEST
+	tristate "80211s: Path selection protocol test module"
+	default n
+	depends on MAC80211_MESH && MAC80211 && EXPERIMENTAL && m
+	---help---
+	  Skeleton module for the path selection protocol modularization
+	  code. Does not do actual path selection, just registers
+	  itself and has the required methods.
+
+	  Do not select this option, rather look at the code in mesh_pptest.c.
 
 config MAC80211_LEDS
 	bool "Enable LED triggers"
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 58c94bb..7b3b5bd 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -38,6 +38,8 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
 	mesh_plink.o \
 	mesh_hwmp.o
 
+obj-$(CONFIG_MAC80211_MESH_PP_TEST) += mesh_pptest.o
+
 mac80211-$(CONFIG_PM) += pm.o
 
 # objects for PID algorithm
diff --git a/net/mac80211/mesh_pptest.c b/net/mac80211/mesh_pptest.c
new file mode 100644
index 0000000..a50264a
--- /dev/null
+++ b/net/mac80211/mesh_pptest.c
@@ -0,0 +1,81 @@
+#include <linux/init.h>
+#include <linux/module.h>
+#include "mesh.h"
+MODULE_LICENSE("GPL");
+
+static struct mesh_path_sel_proto pptest;
+
+static void pptest_path_start_discovery(struct ieee80211_sub_if_data *sdata)
+{
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+}
+
+static int pptest_nexthop_lookup(struct sk_buff *skb,
+				 struct ieee80211_sub_if_data *sdata)
+{
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+	return 0;
+}
+
+static void pptest_queue_preq(struct mesh_path *mpath, u8 flags)
+{
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+}
+
+static int pptest_path_error_tx(u8 *dst, __le32 dst_dsn, u8 *ra,
+				struct ieee80211_sub_if_data *sdata)
+{
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+	return 0;
+}
+
+static void pptest_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_mgmt *mgmt, size_t len)
+{
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+}
+
+static void pptest_path_sel_start(struct ieee80211_if_mesh *sta)
+{
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+}
+
+static void pptest_path_sel_stop(struct ieee80211_if_mesh *sta)
+{
+	printk(KERN_INFO "pptest: %s has been called.\n", __func__);
+}
+
+static int __init init_mesh_pptest(void)
+{
+	/* init code here */
+	printk(KERN_ALERT "Hello, this is mesh_pptest speaking (__init)\n");
+	ieee80211_mesh_path_sel_proto_register(&pptest);
+	return 0;
+}
+
+static void __exit cleanup_mesh_pptest(void)
+{
+	/* cleanup code here */
+	printk(KERN_ALERT "Goodbye, this is mesh_pptest dying\n");
+	ieee80211_mesh_path_sel_proto_unregister(&pptest);
+}
+
+static struct mesh_path_sel_ops pptest_ops = {
+	.path_start_discovery = pptest_path_start_discovery,
+	.nexthop_lookup = pptest_nexthop_lookup,
+	.queue_preq = pptest_queue_preq,
+	.path_error_tx = pptest_path_error_tx,
+	.rx_path_sel_frame = pptest_rx_path_sel_frame,
+	.path_sel_start = pptest_path_sel_start,
+	.path_sel_stop = pptest_path_sel_stop,
+};
+
+static struct mesh_path_sel_proto pptest = {
+	.name = "mesh_pptest",
+	.id = 0x000F0F0F,
+	.ops = &pptest_ops,
+	.owner = THIS_MODULE,
+};
+
+module_init(init_mesh_pptest);
+module_exit(cleanup_mesh_pptest);
-- 
1.5.6.5

