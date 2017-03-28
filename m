Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:45041 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754730AbdC1I62 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 04:58:28 -0400
From: Elena Reshetova <elena.reshetova@intel.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-wireless@vger.kernel.org,
        ganeshgr@chelsio.com, nbd@openwrt.org, blogic@openwrt.org,
        matthias.bgg@gmail.com, yishaih@mellanox.com, saeedm@mellanox.com,
        matanb@mellanox.com, leonro@mellanox.com,
        ajk@comnets.uni-bremen.de, paulus@samba.org, j@w1.fi,
        kvalo@codeaurora.org, peterz@infradead.org, keescook@chromium.org,
        gregkh@linuxfoundation.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        David Windsor <dwindsor@gmail.com>
Subject: [PATCH 07/16] drivers, net, mlx5: convert fs_node.refcount from atomic_t to refcount_t
Date: Tue, 28 Mar 2017 11:56:34 +0300
Message-Id: <1490691403-4016-8-git-send-email-elena.reshetova@intel.com> (sfid-20170328_110902_165303_0C989F71)
In-Reply-To: <1490691403-4016-1-git-send-email-elena.reshetova@intel.com>
References: <1490691403-4016-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 24 +++++++++++------------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h |  3 ++-
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 2478516..4f74d15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -163,7 +163,7 @@ static void tree_init_node(struct fs_node *node,
 			   unsigned int refcount,
 			   void (*remove_func)(struct fs_node *))
 {
-	atomic_set(&node->refcount, refcount);
+	refcount_set(&node->refcount, refcount);
 	INIT_LIST_HEAD(&node->list);
 	INIT_LIST_HEAD(&node->children);
 	mutex_init(&node->lock);
@@ -173,7 +173,7 @@ static void tree_init_node(struct fs_node *node,
 static void tree_add_node(struct fs_node *node, struct fs_node *parent)
 {
 	if (parent)
-		atomic_inc(&parent->refcount);
+		refcount_inc(&parent->refcount);
 	node->parent = parent;
 
 	/* Parent is the root */
@@ -185,7 +185,7 @@ static void tree_add_node(struct fs_node *node, struct fs_node *parent)
 
 static void tree_get_node(struct fs_node *node)
 {
-	atomic_inc(&node->refcount);
+	refcount_inc(&node->refcount);
 }
 
 static void nested_lock_ref_node(struct fs_node *node,
@@ -193,7 +193,7 @@ static void nested_lock_ref_node(struct fs_node *node,
 {
 	if (node) {
 		mutex_lock_nested(&node->lock, class);
-		atomic_inc(&node->refcount);
+		refcount_inc(&node->refcount);
 	}
 }
 
@@ -201,14 +201,14 @@ static void lock_ref_node(struct fs_node *node)
 {
 	if (node) {
 		mutex_lock(&node->lock);
-		atomic_inc(&node->refcount);
+		refcount_inc(&node->refcount);
 	}
 }
 
 static void unlock_ref_node(struct fs_node *node)
 {
 	if (node) {
-		atomic_dec(&node->refcount);
+		refcount_dec(&node->refcount);
 		mutex_unlock(&node->lock);
 	}
 }
@@ -218,7 +218,7 @@ static void tree_put_node(struct fs_node *node)
 	struct fs_node *parent_node = node->parent;
 
 	lock_ref_node(parent_node);
-	if (atomic_dec_and_test(&node->refcount)) {
+	if (refcount_dec_and_test(&node->refcount)) {
 		if (parent_node)
 			list_del_init(&node->list);
 		if (node->remove_func)
@@ -233,8 +233,8 @@ static void tree_put_node(struct fs_node *node)
 
 static int tree_remove_node(struct fs_node *node)
 {
-	if (atomic_read(&node->refcount) > 1) {
-		atomic_dec(&node->refcount);
+	if (refcount_read(&node->refcount) > 1) {
+		refcount_dec(&node->refcount);
 		return -EEXIST;
 	}
 	tree_put_node(node);
@@ -982,7 +982,7 @@ static void destroy_flow_handle(struct fs_fte *fte,
 				int i)
 {
 	for (; --i >= 0;) {
-		if (atomic_dec_and_test(&handle->rule[i]->node.refcount)) {
+		if (refcount_dec_and_test(&handle->rule[i]->node.refcount)) {
 			fte->dests_size--;
 			list_del(&handle->rule[i]->node.list);
 			kfree(handle->rule[i]);
@@ -1013,7 +1013,7 @@ create_flow_handle(struct fs_fte *fte,
 		if (dest) {
 			rule = find_flow_rule(fte, dest + i);
 			if (rule) {
-				atomic_inc(&rule->node.refcount);
+				refcount_inc(&rule->node.refcount);
 				goto rule_found;
 			}
 		}
@@ -1282,7 +1282,7 @@ static struct mlx5_flow_handle *add_rule_fg(struct mlx5_flow_group *fg,
 	list_add(&fte->node.list, prev);
 add_rules:
 	for (i = 0; i < handle->num_rules; i++) {
-		if (atomic_read(&handle->rule[i]->node.refcount) == 1)
+		if (refcount_read(&handle->rule[i]->node.refcount) == 1)
 			tree_add_node(&handle->rule[i]->node, &fte->node);
 	}
 unlock_fte:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 8e668c6..86bc743b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -33,6 +33,7 @@
 #ifndef _MLX5_FS_CORE_
 #define _MLX5_FS_CORE_
 
+#include <linux/refcount.h>
 #include <linux/mlx5/fs.h>
 
 enum fs_node_type {
@@ -80,7 +81,7 @@ struct fs_node {
 	struct fs_node		*root;
 	/* lock the node for writing and traversing */
 	struct mutex		lock;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	void			(*remove_func)(struct fs_node *);
 };
 
-- 
2.7.4
