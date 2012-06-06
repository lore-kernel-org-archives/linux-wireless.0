Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45563 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab2FFKHT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:19 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 12/29] NFC: Introduce target mode rx data callback
Date: Wed,  6 Jun 2012 12:16:29 +0200
Message-Id: <1338977806-30279-13-git-send-email-sameo@linux.intel.com> (sfid-20120606_120726_518082_6758221D)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This routine will be called by drivers whenever they receive data in target
mode. This should be unexpected events and as such should be handled by a
standalone API (i.e. not as a callback pointer from an existing API).

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nfc.h |    1 +
 net/nfc/core.c        |   12 ++++++++++++
 net/nfc/llcp/llcp.c   |   15 +++++++++++++++
 net/nfc/nfc.h         |    7 +++++++
 4 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 45c4c97..180964b 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -202,5 +202,6 @@ int nfc_dep_link_is_up(struct nfc_dev *dev, u32 target_idx,
 int nfc_tm_activated(struct nfc_dev *dev, u32 protocol, u8 comm_mode,
 		     u8 *gb, size_t gb_len);
 int nfc_tm_deactivated(struct nfc_dev *dev);
+int nfc_tm_data_received(struct nfc_dev *dev, struct sk_buff *skb);
 
 #endif /* __NET_NFC_H */
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 76c1e20..6a3799e 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -462,6 +462,18 @@ u8 *nfc_get_local_general_bytes(struct nfc_dev *dev, size_t *gb_len)
 }
 EXPORT_SYMBOL(nfc_get_local_general_bytes);
 
+int nfc_tm_data_received(struct nfc_dev *dev, struct sk_buff *skb)
+{
+	/* Only LLCP target mode for now */
+	if (dev->dep_link_up == false) {
+		kfree_skb(skb);
+		return -ENOLINK;
+	}
+
+	return nfc_llcp_data_received(dev, skb);
+}
+EXPORT_SYMBOL(nfc_tm_data_received);
+
 int nfc_tm_activated(struct nfc_dev *dev, u32 protocol, u8 comm_mode,
 		     u8 *gb, size_t gb_len)
 {
diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 5f7aa3f..5705e6d 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -937,6 +937,21 @@ void nfc_llcp_recv(void *data, struct sk_buff *skb, int err)
 	return;
 }
 
+int nfc_llcp_data_received(struct nfc_dev *dev, struct sk_buff *skb)
+{
+	struct nfc_llcp_local *local;
+
+	local = nfc_llcp_find_local(dev);
+	if (local == NULL)
+		return -ENODEV;
+
+	local->rx_pending = skb_get(skb);
+	del_timer(&local->link_timer);
+	queue_work(local->rx_wq, &local->rx_work);
+
+	return 0;
+}
+
 void nfc_llcp_mac_is_down(struct nfc_dev *dev)
 {
 	struct nfc_llcp_local *local;
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index cd9fcbe..c5e42b7 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -55,6 +55,7 @@ int nfc_llcp_register_device(struct nfc_dev *dev);
 void nfc_llcp_unregister_device(struct nfc_dev *dev);
 int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len);
 u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, size_t *general_bytes_len);
+int nfc_llcp_data_received(struct nfc_dev *dev, struct sk_buff *skb);
 int __init nfc_llcp_init(void);
 void nfc_llcp_exit(void);
 
@@ -90,6 +91,12 @@ static inline u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, size_t *gb_len)
 	return NULL;
 }
 
+static inline int nfc_llcp_data_received(struct nfc_dev *dev,
+					 struct sk_buff *skb)
+{
+	return 0;
+}
+
 static inline int nfc_llcp_init(void)
 {
 	return 0;
-- 
1.7.9.1

