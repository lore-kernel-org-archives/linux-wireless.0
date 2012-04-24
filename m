Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab2DXNRk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 09:17:40 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [RFCv2 1/6] mac80211: softamp: Adds Bluetooth Software AMP
Date: Tue, 24 Apr 2012 16:17:35 +0300
Message-Id: <1335273460-12682-2-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120424_151757_538854_521E8B0B)
In-Reply-To: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Add new interface type BLUETOOTH_SOFTAMP which emulates Bluetooth AMP
Controller. AMP is Alternate MAC/PHYs Controller for Bluetooth subsystem.
When an AMP is common between the two devices, the Bluetooth system
provides mechanisms for moving data traffic from BR/EDR Controller to
an AMP Controller.

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 include/linux/nl80211.h    |    1 +
 net/mac80211/ieee80211_i.h |    5 +
 net/mac80211/iface.c       |    9 ++
 net/mac80211/util.c        |    1 +
 net/mac80211/virtual_amp.c |  341 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/virtual_amp.h |   37 +++++
 6 files changed, 394 insertions(+)
 create mode 100644 net/mac80211/virtual_amp.c
 create mode 100644 net/mac80211/virtual_amp.h

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e474f6e..ed1bf6d 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1546,6 +1546,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_MESH_POINT,
 	NL80211_IFTYPE_P2P_CLIENT,
 	NL80211_IFTYPE_P2P_GO,
+	NL80211_IFTYPE_BLUETOOTH_SOFTAMP,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d9798a3..1e0af56 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -602,6 +602,10 @@ struct ieee80211_if_mesh {
 	} security;
 };
 
+struct ieee80211_if_bt_softamp {
+	struct hci_dev *hdev;
+};
+
 #ifdef CONFIG_MAC80211_MESH
 #define IEEE80211_IFSTA_MESH_CTR_INC(msh, name)	\
 	do { (msh)->mshstats.name++; } while (0)
@@ -716,6 +720,7 @@ struct ieee80211_sub_if_data {
 		struct ieee80211_if_managed mgd;
 		struct ieee80211_if_ibss ibss;
 		struct ieee80211_if_mesh mesh;
+		struct ieee80211_if_bt_softamp softamp;
 		u32 mntr_flags;
 	} u;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 96f8773..b92d8e3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -25,6 +25,7 @@
 #include "driver-ops.h"
 #include "wme.h"
 #include "rate.h"
+#include "virtual_amp.h"
 
 /**
  * DOC: Interface list locking
@@ -211,6 +212,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_BLUETOOTH_SOFTAMP:
 		/* no special treatment */
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -898,6 +900,9 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_AP_VLAN:
 		break;
+	case NL80211_IFTYPE_BLUETOOTH_SOFTAMP:
+		ieee80211_vamp_setup_sdata(sdata);
+		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
 		BUG();
@@ -914,6 +919,10 @@ static void ieee80211_clean_sdata(struct ieee80211_sub_if_data *sdata)
 		mesh_path_flush_by_iface(sdata);
 		break;
 
+	case NL80211_IFTYPE_BLUETOOTH_SOFTAMP:
+		ieee80211_vamp_clean_sdata(sdata);
+		break;
+
 	default:
 		break;
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 32f7a3b..8b7b40a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1290,6 +1290,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			ieee80211_bss_info_change_notify(sdata, changed);
 			break;
 		case NL80211_IFTYPE_WDS:
+		case NL80211_IFTYPE_BLUETOOTH_SOFTAMP:
 			break;
 		case NL80211_IFTYPE_AP_VLAN:
 		case NL80211_IFTYPE_MONITOR:
diff --git a/net/mac80211/virtual_amp.c b/net/mac80211/virtual_amp.c
new file mode 100644
index 0000000..3c81fda
--- /dev/null
+++ b/net/mac80211/virtual_amp.c
@@ -0,0 +1,341 @@
+/*
+ * Virtual/Software AMP 80211 BT Controller. AMP is Alternate MAC/PHYs
+ * Controller for Bluetooth subsystem. When an AMP is common between the
+ * two devices, the Bluetooth system provides mechanisms for moving data
+ * traffic from BR/EDR Controller to an AMP Controller.
+ *
+ * Copyright 2012 Intel Corp.
+ *
+ * Written by andrei.emeltchenko@intel.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+#include <net/bluetooth/l2cap.h>
+#include "virtual_amp.h"
+
+static int vamp_open_dev(struct hci_dev *hdev)
+{
+	BT_DBG("%s", hdev->name);
+
+	set_bit(HCI_RUNNING, &hdev->flags);
+
+	return 0;
+}
+
+static int vamp_close_dev(struct hci_dev *hdev)
+{
+	struct vamp_data *data = hci_get_drvdata(hdev);
+
+	BT_DBG("%s", hdev->name);
+
+	if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
+		return 0;
+
+	skb_queue_purge(&data->txq);
+
+	return 0;
+}
+
+static int vamp_send_frame(struct sk_buff *skb)
+{
+	struct hci_dev *hdev = (struct hci_dev *) skb->dev;
+	struct vamp_data *data;
+
+	BT_DBG("%s", hdev->name);
+
+	if (!hdev) {
+		BT_ERR("Frame for unknown HCI device (hdev=NULL)");
+		return -ENODEV;
+	}
+
+	if (!test_bit(HCI_RUNNING, &hdev->flags))
+		return -EBUSY;
+
+	data = hci_get_drvdata(hdev);
+
+	skb_queue_tail(&data->txq, skb);
+
+	schedule_work(&data->work);
+
+	return 0;
+}
+
+static int vamp_flush(struct hci_dev *hdev)
+{
+	struct vamp_data *data = hci_get_drvdata(hdev);
+
+	BT_DBG("%s", hdev->name);
+
+	skb_queue_purge(&data->txq);
+
+	return 0;
+}
+
+static struct sk_buff *__hci_alloc_evt(size_t plen, __u8 evt_type)
+{
+	size_t len = HCI_EVENT_HDR_SIZE + plen;
+	struct hci_event_hdr *hdr;
+	struct sk_buff *skb;
+
+	skb = bt_skb_alloc(len, GFP_KERNEL);
+	if (!skb) {
+		BT_ERR("No memory for HCI event");
+		return NULL;
+	}
+
+	hdr = (struct hci_event_hdr *) skb_put(skb, HCI_EVENT_HDR_SIZE);
+	hdr->evt = evt_type;
+	hdr->plen = plen;
+
+	return skb;
+}
+
+static int hci_send_evt_cmplt(struct hci_dev *hdev, __u16 opcode, __u32 plen,
+			      void *param)
+{
+	struct hci_ev_cmd_complete *hdr_cmplt;
+	struct sk_buff *skb;
+
+	skb = __hci_alloc_evt(plen + sizeof(*hdr_cmplt), HCI_EV_CMD_COMPLETE);
+	if (!skb)
+		return -ENOMEM;
+
+	hdr_cmplt = (struct hci_ev_cmd_complete *) skb_put(skb,
+							   sizeof(*hdr_cmplt));
+	hdr_cmplt->ncmd = 1;
+	hdr_cmplt->opcode = cpu_to_le16(opcode);
+
+	if (plen)
+		memcpy(skb_put(skb, plen), param, plen);
+
+	bt_cb(skb)->pkt_type = HCI_EVENT_PKT;
+	skb->dev = (void *) hdev;
+
+	return hci_recv_frame(skb);
+}
+
+/* Process HCI command packets */
+static void vamp_cmd_read_bd_addr(struct vamp_data *data, struct sk_buff *skb)
+{
+	struct hci_rp_read_bd_addr rp;
+	struct hci_dev *hdev = data->hdev;
+	struct ieee80211_sub_if_data *sdata = data->sdata;
+
+	rp.status = 0;
+
+	/* Use vif address as BT address */
+	baswap(&rp.bdaddr, (bdaddr_t *) sdata->vif.addr);
+
+	BT_DBG("Read BDADDR %pM", sdata->vif.addr);
+
+	hci_send_evt_cmplt(hdev, HCI_OP_READ_BD_ADDR, sizeof(rp), &rp);
+}
+
+static void vamp_cmd_read_local_version(struct vamp_data *data,
+					struct sk_buff *skb)
+{
+	struct hci_rp_read_local_version rp;
+	struct hci_dev *hdev = data->hdev;
+
+	BT_DBG("%s", hdev->name);
+
+	rp.status = 0x00;
+
+	rp.hci_ver = 0x06;
+	rp.hci_rev = cpu_to_le16(0x0000);
+	rp.lmp_ver = 0x06;
+
+	/* Not Assigned */
+	rp.manufacturer = cpu_to_le16(0xffff);
+	rp.lmp_subver = cpu_to_le16(0x0000);
+
+	hci_send_evt_cmplt(hdev, HCI_OP_READ_LOCAL_VERSION, sizeof(rp), &rp);
+}
+
+static void vamp_cmd_read_local_amp_info(struct vamp_data *data,
+					 struct sk_buff *skb)
+{
+	struct hci_dev *hdev = data->hdev;
+	struct hci_rp_read_local_amp_info rp;
+
+	memset(&rp, 0, sizeof(rp));
+
+	rp.status = 0x00;
+
+	/* BT only */
+	rp.amp_status = 0x01;
+	rp.max_pdu = cpu_to_le32(L2CAP_DEFAULT_MTU);
+	rp.amp_type = HCI_AMP;
+	rp.max_assoc_size = cpu_to_le16(HCI_MAX_ACL_SIZE);
+	/* No flushing at all */
+	rp.max_flush_to = cpu_to_le32(0xFFFFFFFF);
+	rp.be_flush_to = cpu_to_le32(0xFFFFFFFF);
+
+	hci_send_evt_cmplt(hdev, HCI_OP_READ_LOCAL_AMP_INFO, sizeof(rp), &rp);
+}
+
+static void vamp_cmd_reset(struct vamp_data *data, struct sk_buff *skb)
+{
+	struct hci_dev *hdev = data->hdev;
+	u8 status;
+
+	BT_DBG("Reset %s", hdev->name);
+
+	hci_send_evt_cmplt(hdev, HCI_OP_RESET, sizeof(status), &status);
+}
+
+static void vamp_command_packet(struct vamp_data *data, struct sk_buff *skb)
+{
+	struct hci_command_hdr *hdr = (void *) skb->data;
+	__u16 opcode = le16_to_cpu(hdr->opcode);
+
+	/* Check packet size */
+	if (skb->len < sizeof(*hdr) || skb->len != hdr->plen + sizeof(*hdr))
+		goto drop;
+
+	BT_DBG("%s opcode 0x%x", data->hdev->name, opcode);
+
+	skb_pull(skb, HCI_COMMAND_HDR_SIZE);
+
+	switch (opcode) {
+	case HCI_OP_READ_BD_ADDR:
+		vamp_cmd_read_bd_addr(data, skb);
+		break;
+
+	case HCI_OP_READ_LOCAL_VERSION:
+		vamp_cmd_read_local_version(data, skb);
+		break;
+
+	case HCI_OP_READ_LOCAL_AMP_INFO:
+		vamp_cmd_read_local_amp_info(data, skb);
+		break;
+
+	case HCI_OP_RESET:
+		vamp_cmd_reset(data, skb);
+		break;
+
+	default:
+		break;
+	}
+
+drop:
+	kfree_skb(skb);
+}
+
+static void vamp_acldata_packet(struct vamp_data *data, struct sk_buff *skb)
+{
+	struct hci_acl_hdr *hdr = (void *) skb->data;
+	__u16 handle, flags;
+
+	if (skb->len < sizeof(*hdr))
+		goto drop;
+
+	skb_pull(skb, HCI_ACL_HDR_SIZE);
+
+	handle = __le16_to_cpu(hdr->handle);
+	flags  = hci_flags(handle);
+	handle = hci_handle(handle);
+
+	BT_DBG("%s len %d handle 0x%x flags 0x%x", data->hdev->name, skb->len,
+	       handle, flags);
+
+	/* Send data through WIFI */
+
+drop:
+	kfree_skb(skb);
+}
+
+static void vamp_work(struct work_struct *work)
+{
+	struct vamp_data *data = container_of(work, struct vamp_data, work);
+	struct sk_buff *skb;
+
+	BT_DBG("%s", data->hdev->name);
+
+	while ((skb = skb_dequeue(&data->txq))) {
+		/* Process frame */
+		switch (bt_cb(skb)->pkt_type) {
+		case HCI_COMMAND_PKT:
+			vamp_command_packet(data, skb);
+			break;
+
+		case HCI_ACLDATA_PKT:
+			vamp_acldata_packet(data, skb);
+			break;
+
+		default:
+			BT_ERR("Unknown frame type %d", bt_cb(skb)->pkt_type);
+			kfree_skb(skb);
+			break;
+		}
+
+	}
+}
+
+static int virtual_amp_init(struct ieee80211_sub_if_data *sdata)
+{
+	struct hci_dev *hdev;
+	struct vamp_data *data;
+
+	data = kzalloc(sizeof(struct vamp_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	hdev = hci_alloc_dev();
+	if (!hdev) {
+		kfree(data);
+		return -ENOMEM;
+	}
+
+	skb_queue_head_init(&data->txq);
+
+	INIT_WORK(&data->work, vamp_work);
+
+	data->hdev = hdev;
+	data->sdata = sdata;
+
+	hdev->bus = HCI_VIRTUAL;
+	hci_set_drvdata(hdev, data);
+
+	hdev->dev_type = HCI_AMP;
+
+	hdev->open     = vamp_open_dev;
+	hdev->close    = vamp_close_dev;
+	hdev->flush    = vamp_flush;
+	hdev->send     = vamp_send_frame;
+
+	if (hci_register_dev(hdev) < 0) {
+		BT_ERR("Can't register HCI device");
+		kfree(data);
+		hci_free_dev(hdev);
+		return -EBUSY;
+	}
+
+	sdata->u.softamp.hdev = hdev;
+
+	return 0;
+}
+
+void ieee80211_vamp_setup_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	virtual_amp_init(sdata);
+
+	pr_info("Created virtual AMP device %s", sdata->u.softamp.hdev->name);
+}
+
+void ieee80211_vamp_clean_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	struct hci_dev *hdev = sdata->u.softamp.hdev;
+	struct vamp_data *data = hci_get_drvdata(hdev);
+
+	pr_info("Clean up virtual AMP device %s", hdev->name);
+
+	hci_unregister_dev(hdev);
+	hci_free_dev(hdev);
+	kfree(data);
+}
diff --git a/net/mac80211/virtual_amp.h b/net/mac80211/virtual_amp.h
new file mode 100644
index 0000000..e45f58b
--- /dev/null
+++ b/net/mac80211/virtual_amp.h
@@ -0,0 +1,37 @@
+/*
+ * Virtual / Software AMP 80211 BT Controller header
+ *
+ * Copyright 2012 Intel Corp.
+ *
+ * Written by andrei.emeltchenko@intel.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "ieee80211_i.h"
+
+#ifdef CONFIG_MAC80211_BLUETOOTH_SOFTAMP
+
+void ieee80211_vamp_setup_sdata(struct ieee80211_sub_if_data *sdata);
+void ieee80211_vamp_clean_sdata(struct ieee80211_sub_if_data *sdata);
+
+struct vamp_data {
+	struct hci_dev *hdev;
+	struct ieee80211_sub_if_data *sdata;
+	unsigned long flags;
+
+	struct work_struct work;
+	struct sk_buff_head txq;
+};
+
+#else /* CONFIG_MAC80211_BLUETOOTH_SOFTAMP */
+
+static inline void
+ieee80211_vamp_setup_sdata(struct ieee80211_sub_if_data *sdata) {}
+
+static inline void
+ieee80211_vamp_clean_sdata(struct ieee80211_sub_if_data *sdata) {}
+
+#endif /* CONFIG_MAC80211_BLUETOOTH_SOFTAMP */
-- 
1.7.9.5

