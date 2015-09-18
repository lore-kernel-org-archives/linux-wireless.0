Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38384 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbbIRGNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 02:13:17 -0400
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [PATCH] staging: rtl8188eu: Introduce monitor interface for IEEE 802.11 frames
Date: Fri, 18 Sep 2015 08:13:00 +0200
Message-Id: <1442556780-12098-2-git-send-email-jsitnicki@gmail.com> (sfid-20150918_081338_085177_EA152C4A)
In-Reply-To: <1442556780-12098-1-git-send-email-jsitnicki@gmail.com>
References: <1442556780-12098-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for monitoring IEEE 802.11 Data and Management frames
received or transmitted by a RTL8188EU-based device handled by this
driver.

The monitor interface is not enabled by default and will be registered
only if monitor_enable module parameter is set to 1.  When enabled it
will show up as a monX network device, which can be used by the
userspace programs for monitoring network traffic.

It is intended as an exploratory/debugging tool for rtl8188eu driver.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 drivers/staging/rtl8188eu/Makefile             |   1 +
 drivers/staging/rtl8188eu/core/rtw_recv.c      |  14 ++
 drivers/staging/rtl8188eu/core/rtw_xmit.c      |   4 +
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c |   4 +
 drivers/staging/rtl8188eu/include/drv_types.h  |   2 +
 drivers/staging/rtl8188eu/include/mon.h        |  36 +++++
 drivers/staging/rtl8188eu/os_dep/mon.c         | 194 +++++++++++++++++++++++++
 drivers/staging/rtl8188eu/os_dep/os_intfs.c    |   5 +
 drivers/staging/rtl8188eu/os_dep/usb_intf.c    |  10 ++
 9 files changed, 270 insertions(+)
 create mode 100644 drivers/staging/rtl8188eu/include/mon.h
 create mode 100644 drivers/staging/rtl8188eu/os_dep/mon.c

diff --git a/drivers/staging/rtl8188eu/Makefile b/drivers/staging/rtl8188eu/Makefile
index 31ac159..ed72358 100644
--- a/drivers/staging/rtl8188eu/Makefile
+++ b/drivers/staging/rtl8188eu/Makefile
@@ -42,6 +42,7 @@ r8188eu-y :=				\
 		hal/usb_halinit.o	\
 		os_dep/ioctl_linux.o	\
 		os_dep/mlme_linux.o	\
+		os_dep/mon.o		\
 		os_dep/os_intfs.o	\
 		os_dep/osdep_service.o	\
 		os_dep/recv_linux.o	\
diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 44eeb03..cb90ad5 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -25,6 +25,7 @@
 #include <drv_types.h>
 #include <recv_osdep.h>
 #include <mlme_osdep.h>
+#include <mon.h>
 #include <wifi.h>
 #include <linux/vmalloc.h>
 
@@ -1329,6 +1330,19 @@ static int validate_recv_frame(struct adapter *adapter,
 		break;
 	}
 
+	/*
+	 * This is the last moment before management and control frames get
+	 * discarded. So we need to forward them to the monitor now or never.
+	 *
+	 * At the same time data frames can still be encrypted if software
+	 * decryption is in use. However, decryption can occur not until later
+	 * (see recv_func()).
+	 *
+	 * Hence forward the frame to the monitor anyway to preserve the order
+	 * in which frames were received.
+	 */
+	rtl88eu_mon_recv_hook(adapter->pmondev, precv_frame);
+
 exit:
 
 	return retval;
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 5dc0b90..cabb810 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -21,6 +21,7 @@
 
 #include <osdep_service.h>
 #include <drv_types.h>
+#include <mon.h>
 #include <wifi.h>
 #include <osdep_intf.h>
 #include <linux/vmalloc.h>
@@ -1100,6 +1101,9 @@ s32 rtw_xmitframe_coalesce(struct adapter *padapter, struct sk_buff *pkt, struct
 		memcpy(mem_start, pbuf_start + hw_hdr_offset, pattrib->hdrlen);
 	}
 
+	/* Frame is about to be encrypted. Forward it to the monitor first. */
+	rtl88eu_mon_xmit_hook(padapter->pmondev, pxmitframe, frg_len);
+
 	if (xmitframe_addmic(padapter, pxmitframe) == _FAIL) {
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_, ("xmitframe_addmic(padapter, pxmitframe) == _FAIL\n"));
 		DBG_88E("xmitframe_addmic(padapter, pxmitframe) == _FAIL\n");
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index 4433560..7c5086e 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -20,6 +20,7 @@
 #define _RTL8188E_XMIT_C_
 #include <osdep_service.h>
 #include <drv_types.h>
+#include <mon.h>
 #include <wifi.h>
 #include <osdep_intf.h>
 #include <usb_ops_linux.h>
@@ -684,6 +685,9 @@ enqueue:
 
 s32 rtl8188eu_mgnt_xmit(struct adapter *adapt, struct xmit_frame *pmgntframe)
 {
+	struct xmit_priv *xmitpriv = &adapt->xmitpriv;
+
+	rtl88eu_mon_xmit_hook(adapt->pmondev, pmgntframe, xmitpriv->frag_len);
 	return rtw_dump_xframe(adapt, pmgntframe);
 }
 
diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index bcc74dc..0729bd4 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -131,6 +131,7 @@ struct registry_priv {
 	u8	if2name[16];
 
 	u8	notch_filter;
+	bool	monitor_enable;
 };
 
 /* For registry parameters */
@@ -209,6 +210,7 @@ struct adapter {
 	void (*intf_start)(struct adapter *adapter);
 	void (*intf_stop)(struct adapter *adapter);
 	struct  net_device *pnetdev;
+	struct  net_device *pmondev;
 
 	/*  used by rtw_rereg_nd_name related function */
 	struct rereg_nd_name_data {
diff --git a/drivers/staging/rtl8188eu/include/mon.h b/drivers/staging/rtl8188eu/include/mon.h
new file mode 100644
index 0000000..f31fa68
--- /dev/null
+++ b/drivers/staging/rtl8188eu/include/mon.h
@@ -0,0 +1,36 @@
+/*
+ * RTL8188EU monitor interface
+ *
+ * Copyright (C) 2015 Jakub Sitnicki
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
+ * details.
+ */
+
+/*
+ * Monitor interface receives all transmitted and received IEEE 802.11
+ * frames, both Data and Management, and passes them up to userspace
+ * preserving the WLAN headers.
+ */
+
+#ifndef _MON_H_
+#define _MON_H_
+
+struct net_device;
+struct recv_frame;
+struct xmit_frame;
+
+struct net_device *rtl88eu_mon_init(void);
+void rtl88eu_mon_deinit(struct net_device *dev);
+
+void rtl88eu_mon_recv_hook(struct net_device *dev, struct recv_frame *frame);
+void rtl88eu_mon_xmit_hook(struct net_device *dev, struct xmit_frame *frame,
+			   uint frag_len);
+
+#endif /* _MON_H_ */
diff --git a/drivers/staging/rtl8188eu/os_dep/mon.c b/drivers/staging/rtl8188eu/os_dep/mon.c
new file mode 100644
index 0000000..3dd3dc0
--- /dev/null
+++ b/drivers/staging/rtl8188eu/os_dep/mon.c
@@ -0,0 +1,194 @@
+/*
+ * RTL8188EU monitor interface
+ *
+ * Copyright (C) 2015 Jakub Sitnicki
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
+ * details.
+ */
+
+#include <linux/ieee80211.h>
+#include <linux/netdevice.h>
+#include <net/cfg80211.h>
+
+#include <drv_types.h>
+#include <rtw_recv.h>
+#include <rtw_xmit.h>
+
+/**
+ * unprotect_frame() - unset Protected flag and strip off IV and ICV/MIC
+ */
+static void unprotect_frame(struct sk_buff *skb, int iv_len, int icv_len)
+{
+	struct ieee80211_hdr *hdr;
+	int hdr_len;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+
+	if (skb->len < hdr_len + iv_len + icv_len)
+		return;
+	if (!ieee80211_has_protected(hdr->frame_control))
+		return;
+
+	hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+
+	memmove(skb->data + iv_len, skb->data, hdr_len);
+	skb_pull(skb, iv_len);
+	skb_trim(skb, skb->len - icv_len);
+}
+
+static void mon_recv_decrypted(struct net_device *dev, const u8 *data,
+			       int data_len, int iv_len, int icv_len)
+{
+	struct sk_buff *skb;
+
+	skb = netdev_alloc_skb(dev, data_len);
+	if (!skb)
+		return;
+	memcpy(skb_put(skb, data_len), data, data_len);
+
+	/*
+	 * Frame data is not encrypted. Strip off protection so
+	 * userspace doesn't think that it is.
+	 */
+	unprotect_frame(skb, iv_len, icv_len);
+
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	skb->protocol = eth_type_trans(skb, dev);
+	netif_rx(skb);
+}
+
+static void mon_recv_encrypted(struct net_device *dev, const u8 *data,
+			       int data_len)
+{
+	if (net_ratelimit())
+		netdev_info(dev, "Encrypted packets are not supported");
+}
+
+/**
+ * rtl88eu_mon_recv_hook() - forward received frame to the monitor interface
+ *
+ * Assumes that the frame contains an IV and an ICV/MIC, and that
+ * encrypt field in frame->attrib have been set accordingly.
+ */
+void rtl88eu_mon_recv_hook(struct net_device *dev, struct recv_frame *frame)
+{
+	struct rx_pkt_attrib *attr;
+	int iv_len, icv_len;
+	int data_len;
+	u8 *data;
+
+	if (!dev || !frame)
+		return;
+	if (!netif_running(dev))
+		return;
+
+	attr = &frame->attrib;
+	data = frame->rx_data;
+	data_len = frame->len;
+
+	/* Broadcast and multicast frames don't have attr->{iv,icv}_len set */
+	SET_ICE_IV_LEN(iv_len, icv_len, attr->encrypt);
+
+	if (attr->bdecrypted)
+		mon_recv_decrypted(dev, data, data_len, iv_len, icv_len);
+	else
+		mon_recv_encrypted(dev, data, data_len);
+}
+
+/**
+ * rtl88eu_mon_xmit_hook() - forward trasmitted frame to the monitor interface
+ *
+ * Assumes that:
+ * - frame header contains an IV and frame->attrib.iv_len is set accordingly,
+ * - data is not encrypted and ICV/MIC has not been appended yet.
+ */
+void rtl88eu_mon_xmit_hook(struct net_device *dev, struct xmit_frame *frame,
+			   uint frag_len)
+{
+	struct pkt_attrib *attr;
+	u8 *data;
+	int i, offset;
+
+	if (!dev || !frame)
+		return;
+	if (!netif_running(dev))
+		return;
+
+	attr = &frame->attrib;
+
+	offset = TXDESC_SIZE + frame->pkt_offset * PACKET_OFFSET_SZ;
+	data = frame->buf_addr + offset;
+
+	for (i = 0; i < attr->nr_frags - 1; i++) {
+		mon_recv_decrypted(dev, data, frag_len, attr->iv_len, 0);
+		data += frag_len;
+		data = (u8 *)round_up((size_t)data, 4);
+	}
+	/* Last fragment has different length */
+	mon_recv_decrypted(dev, data, attr->last_txcmdsz, attr->iv_len, 0);
+}
+
+static netdev_tx_t mon_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops mon_netdev_ops = {
+	.ndo_start_xmit		= mon_xmit,
+	.ndo_change_mtu		= eth_change_mtu,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
+static void mon_setup(struct net_device *dev)
+{
+	dev->netdev_ops = &mon_netdev_ops;
+	dev->destructor = free_netdev;
+	ether_setup(dev);
+	dev->tx_queue_len = 0;
+	dev->type = ARPHRD_IEEE80211;
+	/*
+	 * Use a locally administered address (IEEE 802)
+	 * XXX: Copied from mac80211_hwsim driver. Revisit.
+	 */
+	eth_zero_addr(dev->dev_addr);
+	dev->dev_addr[0] = 0x12;
+}
+
+struct net_device *rtl88eu_mon_init(void)
+{
+	struct net_device *dev;
+	int err;
+
+	dev = alloc_netdev(0, "mon%d", NET_NAME_UNKNOWN, mon_setup);
+	if (!dev)
+		goto fail;
+
+	err = register_netdev(dev);
+	if (err < 0)
+		goto fail_free_dev;
+
+	return dev;
+
+fail_free_dev:
+	free_netdev(dev);
+fail:
+	return NULL;
+}
+
+void rtl88eu_mon_deinit(struct net_device *dev)
+{
+	if (!dev)
+		return;
+
+	unregister_netdev(dev);
+}
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 2361bce..d85647c 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -185,6 +185,10 @@ MODULE_PARM_DESC(rtw_notch_filter, "0:Disable, 1:Enable, 2:Enable only for P2P")
 module_param_named(debug, rtw_debug, int, 0444);
 MODULE_PARM_DESC(debug, "Set debug level (1-9) (default 1)");
 
+static bool rtw_monitor_enable;
+module_param_named(monitor_enable, rtw_monitor_enable, bool, 0444);
+MODULE_PARM_DESC(monitor_enable, "Enable monitor inferface (default: false)");
+
 static int netdev_open(struct net_device *pnetdev);
 static int netdev_close(struct net_device *pnetdev);
 
@@ -604,6 +608,7 @@ static void loadparam(struct adapter *padapter, struct net_device *pnetdev)
 	snprintf(registry_par->ifname, 16, "%s", ifname);
 	snprintf(registry_par->if2name, 16, "%s", if2name);
 	registry_par->notch_filter = (u8)rtw_notch_filter;
+	registry_par->monitor_enable = rtw_monitor_enable;
 }
 
 static int rtw_net_set_mac_address(struct net_device *pnetdev, void *p)
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 33bfe05..82a7c27 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -26,6 +26,7 @@
 #include <hal_intf.h>
 #include <linux/usb.h>
 #include <linux/vmalloc.h>
+#include <mon.h>
 #include <osdep_intf.h>
 
 #include <usb_ops_linux.h>
@@ -348,6 +349,7 @@ static struct adapter *rtw_usb_if1_init(struct dvobj_priv *dvobj,
 {
 	struct adapter *padapter = NULL;
 	struct net_device *pnetdev = NULL;
+	struct net_device *pmondev;
 	int status = _FAIL;
 
 	padapter = (struct adapter *)vzalloc(sizeof(*padapter));
@@ -366,6 +368,13 @@ static struct adapter *rtw_usb_if1_init(struct dvobj_priv *dvobj,
 	SET_NETDEV_DEV(pnetdev, dvobj_to_dev(dvobj));
 	padapter = rtw_netdev_priv(pnetdev);
 
+	if (padapter->registrypriv.monitor_enable) {
+		pmondev = rtl88eu_mon_init();
+		if (pmondev == NULL)
+			netdev_warn(pnetdev, "Failed to initialize monitor interface");
+		padapter->pmondev = pmondev;
+	}
+
 	/* step 2. hook HalFunc, allocate HalData */
 	hal_set_hal_ops(padapter);
 
@@ -458,6 +467,7 @@ static void rtw_usb_if1_deinit(struct adapter *if1)
 		unregister_netdev(pnetdev);
 		rtw_proc_remove_one(pnetdev);
 	}
+	rtl88eu_mon_deinit(if1->pmondev);
 	rtw_cancel_all_timer(if1);
 
 	rtw_dev_unload(if1);
-- 
2.1.0

