Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45253 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab2DJMLO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 08:11:14 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
Date: Tue, 10 Apr 2012 15:11:49 +0300
Message-Id: <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120410_141120_556160_FD038CE7)
In-Reply-To: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Add new interface type VIRTUAL_AMP80211 which emulates Bluetooth AMP
Controller. AMP is Alternate MAC/PHYs Controller for Bluetooth sybsystem.
When an AMP is common between the two devices, the Bluetooth system
provides mechanisms for moving data traffic from BR/EDR Controller to
an AMP Controller.

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    3 +-
 include/linux/nl80211.h               |    1 +
 net/mac80211/Kconfig                  |    8 ++
 net/mac80211/Makefile                 |    2 +
 net/mac80211/ieee80211_i.h            |    4 +
 net/mac80211/iface.c                  |   25 ++++
 net/mac80211/util.c                   |    1 +
 net/mac80211/virtual_amp.c            |  205 +++++++++++++++++++++++++++++++++
 net/mac80211/virtual_amp.h            |   29 +++++
 9 files changed, 277 insertions(+), 1 deletions(-)
 create mode 100644 net/mac80211/virtual_amp.c
 create mode 100644 net/mac80211/virtual_amp.h

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b7ce6a6..c98b775 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1783,7 +1783,8 @@ static int __init init_mac80211_hwsim(void)
 			BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			BIT(NL80211_IFTYPE_P2P_GO) |
 			BIT(NL80211_IFTYPE_ADHOC) |
-			BIT(NL80211_IFTYPE_MESH_POINT);
+			BIT(NL80211_IFTYPE_MESH_POINT) |
+			BIT(NL80211_IFTYPE_VIRTUAL_AMP80211);
 
 		hw->flags = IEEE80211_HW_MFP_CAPABLE |
 			    IEEE80211_HW_SIGNAL_DBM |
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e474f6e..5f2b84b 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1546,6 +1546,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_MESH_POINT,
 	NL80211_IFTYPE_P2P_CLIENT,
 	NL80211_IFTYPE_P2P_GO,
+	NL80211_IFTYPE_VIRTUAL_AMP80211,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 96ddb72..6658721 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -67,6 +67,14 @@ config MAC80211_RC_DEFAULT_MINSTREL
 
 endchoice
 
+config MAC80211_VIRTUAL_AMP
+	bool "Virtual AMP80211 device"
+	---help---
+	  Enable Bluetooth Virtual / Software AMP 80211 controller.
+	  When AMP is common between two devices data may be routed
+	  through fast 80211 connection from standard Bluetooth BR/EDR
+	  connection.
+
 config MAC80211_RC_DEFAULT
 	string
 	default "minstrel_ht" if MAC80211_RC_DEFAULT_MINSTREL && MAC80211_RC_MINSTREL_HT
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 1be7a45..cda3c08 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -40,6 +40,8 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
 	mesh_plink.o \
 	mesh_hwmp.o
 
+mac80211-$(CONFIG_MAC80211_VIRTUAL_AMP) += virtual_amp.o
+
 mac80211-$(CONFIG_PM) += pm.o
 
 CFLAGS_driver-trace.o := -I$(src)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d9798a3..0e39ed7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -709,6 +709,10 @@ struct ieee80211_sub_if_data {
 	u32 rc_rateidx_mask[IEEE80211_NUM_BANDS];
 	u8  rc_rateidx_mcs_mask[IEEE80211_NUM_BANDS][IEEE80211_HT_MCS_MASK_LEN];
 
+#ifdef CONFIG_MAC80211_VIRTUAL_AMP
+	struct hci_dev *hdev;
+#endif
+
 	union {
 		struct ieee80211_if_ap ap;
 		struct ieee80211_if_wds wds;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 401c01f..0718cc4 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -25,6 +25,7 @@
 #include "driver-ops.h"
 #include "wme.h"
 #include "rate.h"
+#include "virtual_amp.h"
 
 /**
  * DOC: Interface list locking
@@ -217,6 +218,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	case NUM_NL80211_IFTYPES:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_VIRTUAL_AMP80211:
 		/* cannot happen */
 		WARN_ON(1);
 		break;
@@ -898,6 +900,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_AP_VLAN:
 		break;
+	case NL80211_IFTYPE_VIRTUAL_AMP80211:
+#ifdef CONFIG_MAC80211_VIRTUAL_AMP
+		ieee80211_vamp_setup_sdata(sdata);
+		break;
+#endif
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
 		BUG();
@@ -907,6 +914,19 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	ieee80211_debugfs_add_netdev(sdata);
 }
 
+static void ieee80211_clean_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_VIRTUAL_AMP80211:
+#ifdef CONFIG_MAC80211_VIRTUAL_AMP
+		ieee80211_vamp_clean_sdata(sdata);
+#endif
+		break;
+	default:
+		break;
+	}
+}
+
 static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 					   enum nl80211_iftype type)
 {
@@ -1230,6 +1250,9 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_path_flush_by_iface(sdata);
 
+	/* clean up type-dependent data */
+	ieee80211_clean_sdata(sdata);
+
 	synchronize_rcu();
 	unregister_netdevice(sdata->dev);
 }
@@ -1252,6 +1275,8 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 		if (ieee80211_vif_is_mesh(&sdata->vif))
 			mesh_path_flush_by_iface(sdata);
 
+		ieee80211_clean_sdata(sdata);
+
 		unregister_netdevice_queue(sdata->dev, &unreg_list);
 	}
 	mutex_unlock(&local->iflist_mtx);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 32f7a3b..2c235c7 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1299,6 +1299,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NUM_NL80211_IFTYPES:
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_P2P_GO:
+		case NL80211_IFTYPE_VIRTUAL_AMP80211:
 			WARN_ON(1);
 			break;
 		}
diff --git a/net/mac80211/virtual_amp.c b/net/mac80211/virtual_amp.c
new file mode 100644
index 0000000..beccf15
--- /dev/null
+++ b/net/mac80211/virtual_amp.c
@@ -0,0 +1,205 @@
+/*
+ * Virtual/Software AMP 80211 BT Controller. AMP is Alternate MAC/PHYs
+ * Controller for Bluetooth sybsystem. When an AMP is common between the
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
+static void vamp_command_packet(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct hci_command_hdr *hdr = (void *) skb->data;
+	__u16 opcode = le16_to_cpu(hdr->opcode);
+
+	BT_DBG("%s", hdev->name);
+
+	skb_pull(skb, HCI_EVENT_HDR_SIZE);
+
+	switch (opcode) {
+	default:
+		BT_DBG("%s opcode 0x%x", hdev->name, opcode);
+		break;
+	}
+
+	kfree_skb(skb);
+}
+
+static void vamp_acldata_packet(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct hci_acl_hdr *hdr = (void *) skb->data;
+	__u16 handle, flags;
+
+	skb_pull(skb, HCI_ACL_HDR_SIZE);
+
+	handle = __le16_to_cpu(hdr->handle);
+	flags  = hci_flags(handle);
+	handle = hci_handle(handle);
+
+	BT_DBG("%s len %d handle 0x%x flags 0x%x", hdev->name, skb->len,
+	       handle, flags);
+
+	/* Send data through WIFI */
+
+	kfree_skb(skb);
+}
+
+static void vamp_work(struct work_struct *work)
+{
+	struct vamp_data *data = container_of(work, struct vamp_data, work);
+	struct hci_dev *hdev = data->hdev;
+	struct sk_buff *skb;
+
+	BT_DBG("%s", data->hdev->name);
+
+	while ((skb = skb_dequeue(&data->txq))) {
+		/* Process frame */
+		switch (bt_cb(skb)->pkt_type) {
+		case HCI_COMMAND_PKT:
+			vamp_command_packet(hdev, skb);
+			break;
+
+		case HCI_ACLDATA_PKT:
+			BT_DBG("%s ACL data packet", hdev->name);
+			vamp_acldata_packet(hdev, skb);
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
+	skb_queue_head_init(&data->txq);
+
+	INIT_WORK(&data->work, vamp_work);
+
+	hdev = hci_alloc_dev();
+	if (!hdev) {
+		kfree(data);
+		return -ENOMEM;
+	}
+
+	data->hdev = hdev;
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
+	sdata->hdev = hdev;
+
+	return 0;
+}
+
+void ieee80211_vamp_setup_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	pr_info("Create virtual AMP device");
+
+	virtual_amp_init(sdata);
+
+}
+
+void ieee80211_vamp_clean_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	struct hci_dev *hdev = sdata->hdev;
+	struct vamp_data *data = hci_get_drvdata(hdev);
+
+	pr_info("Clean up virtual AMP device");
+
+	hci_unregister_dev(hdev);
+	hci_free_dev(hdev);
+	kfree(data);
+}
diff --git a/net/mac80211/virtual_amp.h b/net/mac80211/virtual_amp.h
new file mode 100644
index 0000000..5b7d219
--- /dev/null
+++ b/net/mac80211/virtual_amp.h
@@ -0,0 +1,29 @@
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
+#ifdef CONFIG_MAC80211_VIRTUAL_AMP
+
+void ieee80211_vamp_setup_sdata(struct ieee80211_sub_if_data *sdata);
+void ieee80211_vamp_clean_sdata(struct ieee80211_sub_if_data *sdata);
+
+struct vamp_data {
+	struct hci_dev *hdev;
+
+	unsigned long flags;
+
+	struct work_struct work;
+	struct sk_buff_head txq;
+};
+
+#endif /* CONFIG_MAC80211_VIRTUAL_AMP */
-- 
1.7.9.1

