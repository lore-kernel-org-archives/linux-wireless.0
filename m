Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10711 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab1LNPia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 10:38:30 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/8] NFC: Add tx skb allocation routine
Date: Wed, 14 Dec 2011 16:43:06 +0100
Message-Id: <1323877392-20567-3-git-send-email-sameo@linux.intel.com> (sfid-20111214_163832_344649_C10518A0)
In-Reply-To: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
References: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a factorization of the current rawsock tx skb allocation routine,
as it will be used by the LLCP code.
We also rename nfc_alloc_skb to nfc_alloc_recv_skb for consistency sake.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c   |    2 +-
 include/net/nfc/nfc.h |    5 ++++-
 net/nfc/core.c        |   30 +++++++++++++++++++++++++++---
 net/nfc/rawsock.c     |    7 ++-----
 4 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index dbf214e..ea1caae 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1368,7 +1368,7 @@ static int pn533_data_exchange(struct nfc_dev *nfc_dev, u32 target_idx,
 			PN533_CMD_DATAEXCH_DATA_MAXLEN +
 			PN533_FRAME_TAIL_SIZE;
 
-	skb_resp = nfc_alloc_skb(skb_resp_len, GFP_KERNEL);
+	skb_resp = nfc_alloc_recv_skb(skb_resp_len, GFP_KERNEL);
 	if (!skb_resp) {
 		rc = -ENOMEM;
 		goto error;
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 6a7f602..3a3304c 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -157,7 +157,10 @@ static inline const char *nfc_device_name(struct nfc_dev *dev)
 	return dev_name(&dev->dev);
 }
 
-struct sk_buff *nfc_alloc_skb(unsigned int size, gfp_t gfp);
+struct sk_buff *nfc_alloc_send_skb(struct nfc_dev *dev, struct sock *sk,
+					unsigned int flags, unsigned int size,
+					unsigned int *err);
+struct sk_buff *nfc_alloc_recv_skb(unsigned int size, gfp_t gfp);
 
 int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
 							int ntargets);
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 2a838b0..f53f88a 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/nfc.h>
 
 #include "nfc.h"
 
@@ -275,12 +276,35 @@ error:
 }
 
 /**
- * nfc_alloc_skb - allocate a skb for data exchange responses
+ * nfc_alloc_send_skb - allocate a skb for data exchange responses
  *
  * @size: size to allocate
  * @gfp: gfp flags
  */
-struct sk_buff *nfc_alloc_skb(unsigned int size, gfp_t gfp)
+struct sk_buff *nfc_alloc_send_skb(struct nfc_dev *dev, struct sock *sk,
+					unsigned int flags, unsigned int size,
+					unsigned int *err)
+{
+	struct sk_buff *skb;
+	unsigned int total_size;
+
+	total_size = size +
+		dev->tx_headroom + dev->tx_tailroom + NFC_HEADER_SIZE;
+
+	skb = sock_alloc_send_skb(sk, total_size, flags & MSG_DONTWAIT, err);
+	if (skb)
+		skb_reserve(skb, dev->tx_headroom + NFC_HEADER_SIZE);
+
+	return skb;
+}
+
+/**
+ * nfc_alloc_recv_skb - allocate a skb for data exchange responses
+ *
+ * @size: size to allocate
+ * @gfp: gfp flags
+ */
+struct sk_buff *nfc_alloc_recv_skb(unsigned int size, gfp_t gfp)
 {
 	struct sk_buff *skb;
 	unsigned int total_size;
@@ -293,7 +317,7 @@ struct sk_buff *nfc_alloc_skb(unsigned int size, gfp_t gfp)
 
 	return skb;
 }
-EXPORT_SYMBOL(nfc_alloc_skb);
+EXPORT_SYMBOL(nfc_alloc_recv_skb);
 
 /**
  * nfc_targets_found - inform that targets were found
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 5e9b991..11ac0a1 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -208,13 +208,10 @@ static int rawsock_sendmsg(struct kiocb *iocb, struct socket *sock,
 	if (sock->state != SS_CONNECTED)
 		return -ENOTCONN;
 
-	skb = sock_alloc_send_skb(sk, len + dev->tx_headroom + dev->tx_tailroom + NFC_HEADER_SIZE,
-					msg->msg_flags & MSG_DONTWAIT, &rc);
-	if (!skb)
+	skb = nfc_alloc_send_skb(dev, sk, msg->msg_flags, len, &rc);
+	if (skb == NULL)
 		return rc;
 
-	skb_reserve(skb, dev->tx_headroom + NFC_HEADER_SIZE);
-
 	rc = memcpy_fromiovec(skb_put(skb, len), msg->msg_iov, len);
 	if (rc < 0) {
 		kfree_skb(skb);
-- 
1.7.7.3

