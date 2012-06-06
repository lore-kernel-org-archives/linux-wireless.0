Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14338 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab2FFKG7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:06:59 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 07/29] NFC: Add target mode protocols to the polling loop startup routine
Date: Wed,  6 Jun 2012 12:16:24 +0200
Message-Id: <1338977806-30279-8-git-send-email-sameo@linux.intel.com> (sfid-20120606_120702_190430_9B859650)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c     |   39 +++++++++++++++++++++++++++++----------
 drivers/nfc/pn544_hci.c |   10 ++++++----
 include/linux/nfc.h     |    4 ++++
 include/net/nfc/hci.h   |    3 ++-
 include/net/nfc/nfc.h   |    3 ++-
 include/net/nfc/shdlc.h |    3 ++-
 net/nfc/core.c          |   10 +++++-----
 net/nfc/hci/core.c      |    5 +++--
 net/nfc/hci/shdlc.c     |    6 ++++--
 net/nfc/nci/core.c      |    7 ++++---
 net/nfc/netlink.c       |   19 +++++++++++++++----
 net/nfc/nfc.h           |    2 +-
 12 files changed, 77 insertions(+), 34 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 19110f0..38a523c 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1078,27 +1078,23 @@ stop_poll:
 	return 0;
 }
 
-static int pn533_start_poll(struct nfc_dev *nfc_dev, u32 protocols)
+static int pn533_init_target(struct nfc_dev *nfc_dev, u32 protocols)
+{
+	return 0;
+}
+
+static int pn533_start_im_poll(struct nfc_dev *nfc_dev, u32 protocols)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 	struct pn533_poll_modulations *start_mod;
 	int rc;
 
-	nfc_dev_dbg(&dev->interface->dev, "%s - protocols=0x%x", __func__,
-								protocols);
-
 	if (dev->poll_mod_count) {
 		nfc_dev_err(&dev->interface->dev, "Polling operation already"
 								" active");
 		return -EBUSY;
 	}
 
-	if (dev->tgt_active_prot) {
-		nfc_dev_err(&dev->interface->dev, "Cannot poll with a target"
-							" already activated");
-		return -EBUSY;
-	}
-
 	pn533_poll_create_mod_list(dev, protocols);
 
 	if (!dev->poll_mod_count) {
@@ -1135,6 +1131,29 @@ error:
 	return rc;
 }
 
+static int pn533_start_poll(struct nfc_dev *nfc_dev,
+			    u32 im_protocols, u32 tm_protocols)
+{
+	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
+
+	nfc_dev_dbg(&dev->interface->dev,
+		    "%s: im protocols 0x%x tm protocols 0x%x",
+		    __func__, im_protocols, tm_protocols);
+
+	if (dev->tgt_active_prot) {
+		nfc_dev_err(&dev->interface->dev,
+			    "Cannot poll with a target already activated");
+		return -EBUSY;
+	}
+
+	if (!tm_protocols)
+		return pn533_start_im_poll(nfc_dev, im_protocols);
+	else if (!im_protocols)
+		return pn533_init_target(nfc_dev, tm_protocols);
+	else
+		return -EINVAL;
+}
+
 static void pn533_stop_poll(struct nfc_dev *nfc_dev)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
diff --git a/drivers/nfc/pn544_hci.c b/drivers/nfc/pn544_hci.c
index 281f18c..457eac3 100644
--- a/drivers/nfc/pn544_hci.c
+++ b/drivers/nfc/pn544_hci.c
@@ -576,7 +576,8 @@ static int pn544_hci_xmit(struct nfc_shdlc *shdlc, struct sk_buff *skb)
 	return pn544_hci_i2c_write(client, skb->data, skb->len);
 }
 
-static int pn544_hci_start_poll(struct nfc_shdlc *shdlc, u32 protocols)
+static int pn544_hci_start_poll(struct nfc_shdlc *shdlc,
+				u32 im_protocols, u32 tm_protocols)
 {
 	struct nfc_hci_dev *hdev = nfc_shdlc_get_hci_dev(shdlc);
 	u8 phases = 0;
@@ -584,7 +585,8 @@ static int pn544_hci_start_poll(struct nfc_shdlc *shdlc, u32 protocols)
 	u8 duration[2];
 	u8 activated;
 
-	pr_info(DRIVER_DESC ": %s protocols = %d\n", __func__, protocols);
+	pr_info(DRIVER_DESC ": %s protocols 0x%x 0x%x\n",
+		__func__, im_protocols, tm_protocols);
 
 	r = nfc_hci_send_event(hdev, NFC_HCI_RF_READER_A_GATE,
 			       NFC_HCI_EVT_END_OPERATION, NULL, 0);
@@ -604,10 +606,10 @@ static int pn544_hci_start_poll(struct nfc_shdlc *shdlc, u32 protocols)
 	if (r < 0)
 		return r;
 
-	if (protocols & (NFC_PROTO_ISO14443_MASK | NFC_PROTO_MIFARE_MASK |
+	if (im_protocols & (NFC_PROTO_ISO14443_MASK | NFC_PROTO_MIFARE_MASK |
 			 NFC_PROTO_JEWEL_MASK))
 		phases |= 1;		/* Type A */
-	if (protocols & NFC_PROTO_FELICA_MASK) {
+	if (im_protocols & NFC_PROTO_FELICA_MASK) {
 		phases |= (1 << 2);	/* Type F 212 */
 		phases |= (1 << 3);	/* Type F 424 */
 	}
diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index 0ae9b58..5487158 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -94,6 +94,8 @@ enum nfc_commands {
  * @NFC_ATTR_TARGET_SENSF_RES: NFC-F targets extra information, max 18 bytes
  * @NFC_ATTR_COMM_MODE: Passive or active mode
  * @NFC_ATTR_RF_MODE: Initiator or target
+ * @NFC_ATTR_IM_PROTOCOLS: Initiator mode protocols to poll for
+ * @NFC_ATTR_TM_PROTOCOLS: Target mode protocols to listen for
  */
 enum nfc_attrs {
 	NFC_ATTR_UNSPEC,
@@ -109,6 +111,8 @@ enum nfc_attrs {
 	NFC_ATTR_COMM_MODE,
 	NFC_ATTR_RF_MODE,
 	NFC_ATTR_DEVICE_POWERED,
+	NFC_ATTR_IM_PROTOCOLS,
+	NFC_ATTR_TM_PROTOCOLS,
 /* private: internal use only */
 	__NFC_ATTR_AFTER_LAST
 };
diff --git a/include/net/nfc/hci.h b/include/net/nfc/hci.h
index 4467c94..e30e6a8 100644
--- a/include/net/nfc/hci.h
+++ b/include/net/nfc/hci.h
@@ -31,7 +31,8 @@ struct nfc_hci_ops {
 	void (*close) (struct nfc_hci_dev *hdev);
 	int (*hci_ready) (struct nfc_hci_dev *hdev);
 	int (*xmit) (struct nfc_hci_dev *hdev, struct sk_buff *skb);
-	int (*start_poll) (struct nfc_hci_dev *hdev, u32 protocols);
+	int (*start_poll) (struct nfc_hci_dev *hdev,
+			   u32 im_protocols, u32 tm_protocols);
 	int (*target_from_gate) (struct nfc_hci_dev *hdev, u8 gate,
 				 struct nfc_target *target);
 	int (*complete_target_discovered) (struct nfc_hci_dev *hdev, u8 gate,
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 3116f92..97aa0e8 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -53,7 +53,8 @@ struct nfc_target;
 struct nfc_ops {
 	int (*dev_up)(struct nfc_dev *dev);
 	int (*dev_down)(struct nfc_dev *dev);
-	int (*start_poll)(struct nfc_dev *dev, u32 protocols);
+	int (*start_poll)(struct nfc_dev *dev,
+			  u32 im_protocols, u32 tm_protocols);
 	void (*stop_poll)(struct nfc_dev *dev);
 	int (*dep_link_up)(struct nfc_dev *dev, struct nfc_target *target,
 			   u8 comm_mode, u8 *gb, size_t gb_len);
diff --git a/include/net/nfc/shdlc.h b/include/net/nfc/shdlc.h
index ab06afd..35e930d 100644
--- a/include/net/nfc/shdlc.h
+++ b/include/net/nfc/shdlc.h
@@ -27,7 +27,8 @@ struct nfc_shdlc_ops {
 	void (*close) (struct nfc_shdlc *shdlc);
 	int (*hci_ready) (struct nfc_shdlc *shdlc);
 	int (*xmit) (struct nfc_shdlc *shdlc, struct sk_buff *skb);
-	int (*start_poll) (struct nfc_shdlc *shdlc, u32 protocols);
+	int (*start_poll) (struct nfc_shdlc *shdlc,
+			   u32 im_protocols, u32 tm_protocols);
 	int (*target_from_gate) (struct nfc_shdlc *shdlc, u8 gate,
 				 struct nfc_target *target);
 	int (*complete_target_discovered) (struct nfc_shdlc *shdlc, u8 gate,
diff --git a/net/nfc/core.c b/net/nfc/core.c
index f5a43f7..c83717b 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -121,14 +121,14 @@ error:
  * The device remains polling for targets until a target is found or
  * the nfc_stop_poll function is called.
  */
-int nfc_start_poll(struct nfc_dev *dev, u32 protocols)
+int nfc_start_poll(struct nfc_dev *dev, u32 im_protocols, u32 tm_protocols)
 {
 	int rc;
 
-	pr_debug("dev_name=%s protocols=0x%x\n",
-		 dev_name(&dev->dev), protocols);
+	pr_debug("dev_name %s initiator protocols 0x%x target protocols 0x%x\n",
+		 dev_name(&dev->dev), im_protocols, tm_protocols);
 
-	if (!protocols)
+	if (!im_protocols && !tm_protocols)
 		return -EINVAL;
 
 	device_lock(&dev->dev);
@@ -143,7 +143,7 @@ int nfc_start_poll(struct nfc_dev *dev, u32 protocols)
 		goto error;
 	}
 
-	rc = dev->ops->start_poll(dev, protocols);
+	rc = dev->ops->start_poll(dev, im_protocols, tm_protocols);
 	if (!rc)
 		dev->polling = true;
 
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index e1a640d..281f3a3 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -481,12 +481,13 @@ static int hci_dev_down(struct nfc_dev *nfc_dev)
 	return 0;
 }
 
-static int hci_start_poll(struct nfc_dev *nfc_dev, u32 protocols)
+static int hci_start_poll(struct nfc_dev *nfc_dev,
+			  u32 im_protocols, u32 tm_protocols)
 {
 	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
 
 	if (hdev->ops->start_poll)
-		return hdev->ops->start_poll(hdev, protocols);
+		return hdev->ops->start_poll(hdev, im_protocols, tm_protocols);
 	else
 		return nfc_hci_send_event(hdev, NFC_HCI_RF_READER_A_GATE,
 				       NFC_HCI_EVT_READER_REQUESTED, NULL, 0);
diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index 5665dc6..6b836e6 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -765,14 +765,16 @@ static int nfc_shdlc_xmit(struct nfc_hci_dev *hdev, struct sk_buff *skb)
 	return 0;
 }
 
-static int nfc_shdlc_start_poll(struct nfc_hci_dev *hdev, u32 protocols)
+static int nfc_shdlc_start_poll(struct nfc_hci_dev *hdev,
+				u32 im_protocols, u32 tm_protocols)
 {
 	struct nfc_shdlc *shdlc = nfc_hci_get_clientdata(hdev);
 
 	pr_debug("\n");
 
 	if (shdlc->ops->start_poll)
-		return shdlc->ops->start_poll(shdlc, protocols);
+		return shdlc->ops->start_poll(shdlc,
+					      im_protocols, tm_protocols);
 
 	return 0;
 }
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index d560e6f..0f71898 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -387,7 +387,8 @@ static int nci_dev_down(struct nfc_dev *nfc_dev)
 	return nci_close_device(ndev);
 }
 
-static int nci_start_poll(struct nfc_dev *nfc_dev, __u32 protocols)
+static int nci_start_poll(struct nfc_dev *nfc_dev,
+			  __u32 im_protocols, __u32 tm_protocols)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 	int rc;
@@ -413,11 +414,11 @@ static int nci_start_poll(struct nfc_dev *nfc_dev, __u32 protocols)
 			return -EBUSY;
 	}
 
-	rc = nci_request(ndev, nci_rf_discover_req, protocols,
+	rc = nci_request(ndev, nci_rf_discover_req, im_protocols,
 			 msecs_to_jiffies(NCI_RF_DISC_TIMEOUT));
 
 	if (!rc)
-		ndev->poll_prots = protocols;
+		ndev->poll_prots = im_protocols;
 
 	return rc;
 }
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 581d419..a18fd56 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -49,6 +49,8 @@ static const struct nla_policy nfc_genl_policy[NFC_ATTR_MAX + 1] = {
 	[NFC_ATTR_COMM_MODE] = { .type = NLA_U8 },
 	[NFC_ATTR_RF_MODE] = { .type = NLA_U8 },
 	[NFC_ATTR_DEVICE_POWERED] = { .type = NLA_U8 },
+	[NFC_ATTR_IM_PROTOCOLS] = { .type = NLA_U32 },
+	[NFC_ATTR_TM_PROTOCOLS] = { .type = NLA_U32 },
 };
 
 static int nfc_genl_send_target(struct sk_buff *msg, struct nfc_target *target,
@@ -519,16 +521,25 @@ static int nfc_genl_start_poll(struct sk_buff *skb, struct genl_info *info)
 	struct nfc_dev *dev;
 	int rc;
 	u32 idx;
-	u32 protocols;
+	u32 im_protocols = 0, tm_protocols = 0;
 
 	pr_debug("Poll start\n");
 
 	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
-	    !info->attrs[NFC_ATTR_PROTOCOLS])
+	    ((!info->attrs[NFC_ATTR_IM_PROTOCOLS] &&
+	      !info->attrs[NFC_ATTR_PROTOCOLS]) &&
+	     !info->attrs[NFC_ATTR_TM_PROTOCOLS]))
 		return -EINVAL;
 
 	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
-	protocols = nla_get_u32(info->attrs[NFC_ATTR_PROTOCOLS]);
+
+	if (info->attrs[NFC_ATTR_TM_PROTOCOLS])
+		tm_protocols = nla_get_u32(info->attrs[NFC_ATTR_TM_PROTOCOLS]);
+	else if (info->attrs[NFC_ATTR_PROTOCOLS])
+		tm_protocols = nla_get_u32(info->attrs[NFC_ATTR_PROTOCOLS]);
+
+	if (info->attrs[NFC_ATTR_IM_PROTOCOLS])
+		im_protocols = nla_get_u32(info->attrs[NFC_ATTR_IM_PROTOCOLS]);
 
 	dev = nfc_get_device(idx);
 	if (!dev)
@@ -536,7 +547,7 @@ static int nfc_genl_start_poll(struct sk_buff *skb, struct genl_info *info)
 
 	mutex_lock(&dev->genl_data.genl_data_mutex);
 
-	rc = nfc_start_poll(dev, protocols);
+	rc = nfc_start_poll(dev, im_protocols, tm_protocols);
 	if (!rc)
 		dev->genl_data.poll_req_pid = info->snd_pid;
 
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 3dd4232..7d9708f 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -158,7 +158,7 @@ int nfc_dev_up(struct nfc_dev *dev);
 
 int nfc_dev_down(struct nfc_dev *dev);
 
-int nfc_start_poll(struct nfc_dev *dev, u32 protocols);
+int nfc_start_poll(struct nfc_dev *dev, u32 im_protocols, u32 tm_protocols);
 
 int nfc_stop_poll(struct nfc_dev *dev);
 
-- 
1.7.9.1

