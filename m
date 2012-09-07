Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:60290 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab2IGJIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 05:08:38 -0400
From: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
To: <linux-wireless@vger.kernel.org>, <linux-nfc@lists.01.org>,
	<eric.lapuyade@intel.com>
CC: <sameo@linux.intel.com>,
	Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: [PATCH v2 1/2] NFC: Remove crc generation from shdlc layer
Date: Fri, 7 Sep 2012 11:08:29 +0200
Message-ID: <1347008910-11472-1-git-send-email-waldemar.rymarkiewicz@tieto.com> (sfid-20120907_110841_882179_C98F5F4A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Checksum is specific for a chip spcification and it varies
(in size and type) between different hardware. It should be
handled in the driver then.

Moreover, shdlc spec doesn't mention crc as a part of the frame.

Update pn544_hci driver as well.

Signed-off-by: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
---
 drivers/nfc/pn544_hci.c |   32 ++++++++++++++++++++++++++++++--
 net/nfc/hci/shdlc.c     |   27 ++-------------------------
 2 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/nfc/pn544_hci.c b/drivers/nfc/pn544_hci.c
index 9458d53..d90aecf 100644
--- a/drivers/nfc/pn544_hci.c
+++ b/drivers/nfc/pn544_hci.c
@@ -128,6 +128,8 @@ static struct nfc_hci_gate pn544_gates[] = {
 
 /* Largest headroom needed for outgoing custom commands */
 #define PN544_CMDS_HEADROOM	2
+#define PN544_FRAME_HEADROOM 1
+#define PN544_FRAME_TAILROOM 2
 
 struct pn544_hci_info {
 	struct i2c_client *i2c_dev;
@@ -576,15 +578,40 @@ static int pn544_hci_ready(struct nfc_shdlc *shdlc)
 	return 0;
 }
 
+static void pn544_hci_add_len_crc(struct sk_buff *skb)
+{
+	u16 crc;
+	int len;
+
+	len = skb->len + 2;
+	*skb_push(skb, 1) = len;
+
+	crc = crc_ccitt(0xffff, skb->data, skb->len);
+	crc = ~crc;
+	*skb_put(skb, 1) = crc & 0xff;
+	*skb_put(skb, 1) = crc >> 8;
+}
+
+static void pn544_hci_remove_len_crc(struct sk_buff *skb)
+{
+	skb_pull(skb, PN544_FRAME_HEADROOM);
+	skb_trim(skb, PN544_FRAME_TAILROOM);
+}
+
 static int pn544_hci_xmit(struct nfc_shdlc *shdlc, struct sk_buff *skb)
 {
 	struct pn544_hci_info *info = nfc_shdlc_get_clientdata(shdlc);
 	struct i2c_client *client = info->i2c_dev;
+	int r;
 
 	if (info->hard_fault != 0)
 		return info->hard_fault;
 
-	return pn544_hci_i2c_write(client, skb->data, skb->len);
+	pn544_hci_add_len_crc(skb);
+	r = pn544_hci_i2c_write(client, skb->data, skb->len);
+	pn544_hci_remove_len_crc(skb);
+
+	return r;
 }
 
 static int pn544_hci_start_poll(struct nfc_shdlc *shdlc,
@@ -874,7 +901,8 @@ static int __devinit pn544_hci_probe(struct i2c_client *client,
 
 	info->shdlc = nfc_shdlc_allocate(&pn544_shdlc_ops,
 					 &init_data, protocols,
-					 PN544_CMDS_HEADROOM, 0,
+					 PN544_FRAME_HEADROOM + PN544_CMDS_HEADROOM,
+					 PN544_FRAME_TAILROOM,
 					 PN544_HCI_LLC_MAX_PAYLOAD,
 					 dev_name(&client->dev));
 	if (!info->shdlc) {
diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index d4fe5e9..8a5f034 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -22,7 +22,6 @@
 #include <linux/sched.h>
 #include <linux/export.h>
 #include <linux/wait.h>
-#include <linux/crc-ccitt.h>
 #include <linux/slab.h>
 #include <linux/skbuff.h>
 
@@ -30,7 +29,6 @@
 #include <net/nfc/shdlc.h>
 
 #define SHDLC_LLC_HEAD_ROOM	2
-#define SHDLC_LLC_TAIL_ROOM	2
 
 #define SHDLC_MAX_WINDOW	4
 #define SHDLC_SREJ_SUPPORT	false
@@ -94,28 +92,13 @@ static struct sk_buff *nfc_shdlc_alloc_skb(struct nfc_shdlc *shdlc,
 	struct sk_buff *skb;
 
 	skb = alloc_skb(shdlc->client_headroom + SHDLC_LLC_HEAD_ROOM +
-			shdlc->client_tailroom + SHDLC_LLC_TAIL_ROOM +
-			payload_len, GFP_KERNEL);
+			shdlc->client_tailroom + payload_len, GFP_KERNEL);
 	if (skb)
 		skb_reserve(skb, shdlc->client_headroom + SHDLC_LLC_HEAD_ROOM);
 
 	return skb;
 }
 
-static void nfc_shdlc_add_len_crc(struct sk_buff *skb)
-{
-	u16 crc;
-	int len;
-
-	len = skb->len + 2;
-	*skb_push(skb, 1) = len;
-
-	crc = crc_ccitt(0xffff, skb->data, skb->len);
-	crc = ~crc;
-	*skb_put(skb, 1) = crc & 0xff;
-	*skb_put(skb, 1) = crc >> 8;
-}
-
 /* immediately sends an S frame. */
 static int nfc_shdlc_send_s_frame(struct nfc_shdlc *shdlc,
 				  enum sframe_type sframe_type, int nr)
@@ -131,8 +114,6 @@ static int nfc_shdlc_send_s_frame(struct nfc_shdlc *shdlc,
 
 	*skb_push(skb, 1) = SHDLC_CONTROL_HEAD_S | (sframe_type << 3) | nr;
 
-	nfc_shdlc_add_len_crc(skb);
-
 	r = shdlc->ops->xmit(shdlc, skb);
 
 	kfree_skb(skb);
@@ -151,8 +132,6 @@ static int nfc_shdlc_send_u_frame(struct nfc_shdlc *shdlc,
 
 	*skb_push(skb, 1) = SHDLC_CONTROL_HEAD_U | uframe_modifier;
 
-	nfc_shdlc_add_len_crc(skb);
-
 	r = shdlc->ops->xmit(shdlc, skb);
 
 	kfree_skb(skb);
@@ -510,8 +489,6 @@ static void nfc_shdlc_handle_send_queue(struct nfc_shdlc *shdlc)
 			 shdlc->nr);
 	/*	SHDLC_DUMP_SKB("shdlc frame written", skb); */
 
-		nfc_shdlc_add_len_crc(skb);
-
 		r = shdlc->ops->xmit(shdlc, skb);
 		if (r < 0) {
 			shdlc->hard_fault = r;
@@ -881,7 +858,7 @@ struct nfc_shdlc *nfc_shdlc_allocate(struct nfc_shdlc_ops *ops,
 
 	shdlc->hdev = nfc_hci_allocate_device(&shdlc_ops, init_data, protocols,
 					      tx_headroom + SHDLC_LLC_HEAD_ROOM,
-					      tx_tailroom + SHDLC_LLC_TAIL_ROOM,
+					      tx_tailroom,
 					      max_link_payload);
 	if (shdlc->hdev == NULL)
 		goto err_allocdev;
-- 
1.7.10

