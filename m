Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F09E372EE9
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368079; cv=none; b=ZsPkYwAHraB3iESi7KO0cswm5c59zl1wvHikXS11DlTUNYf3mg/AW0vcDSDXMNVwzOmFXWZy+bLP28q2DkR6VkvLjoFoL1zKlSeTqXvp77CjkrVTbLEZjGiQBzVKrQP9hi++ZZNIQPz2fT4B0+iPnQCVp/k8MH1OfcV0b8cDgLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368079; c=relaxed/simple;
	bh=4WcO3D1l38Rk2NbH282UvvmcyOfJMXbX2BCjvlW3m6Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MN5sk+qHt7ofzmfpIRr8G760K9Jr4WCZOGS3/PtGSgkoecug/7IVXg8jMkRfMAy76qzlHjo2o2liW9aF6CPm1brJC5xWV5UrbPS+cFtW5rPpZodUhR1H+c9wjePAT1ne0tFoLsk9+iTTgvg+kEdCBAepYTmQD9YtfwaM/47Jfs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=gbgkfZ/j; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="gbgkfZ/j"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788368077; x=1819904077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4WcO3D1l38Rk2NbH282UvvmcyOfJMXbX2BCjvlW3m6Y=;
  b=gbgkfZ/j4jANS/WmdhDQDZlN8/KC74F8ir7F0fdzU8ppt1m0SpaUPbLA
   PScYYeqkiWq6AKDiiKlQ2itZnt2AHKdOlP4mXBHwhu+fVLBJxBbf8RBxH
   2ijqitpWUfhyk8mTV8JYhXenyZNH06Dv2epNgYQyH8OJqe1AQhlobLCgz
   I=;
X-CSE-ConnectionGUID: +EqjdRjcTLeqiOMW7z+rMw==
X-CSE-MsgGUID: nU0waQFLQKyKPkA6Tk/Vdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="159196612"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="159196612"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE819.infineon.com) ([172.23.29.45])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:54:35 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE819.infineon.com
 (172.23.29.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:54:35 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:54:33 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 16/25] wifi: inffmac: add bus_proto.c/h
Date: Wed, 2 Sep 2026 16:50:47 +0000
Message-ID: <20260902165057.456447-17-gokulkumar.sivakumar@infineon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
References: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE808.infineon.com (172.23.29.34) To
 MUCSE827.infineon.com (172.23.29.20)

Provides the generic BUS protocol abstraction layer that is used for
the Control and Data communication with the Infineon's WLAN Device
over the SDIO BUS types.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 .../net/wireless/infineon/inffmac/bus_proto.c | 162 +++++++
 .../net/wireless/infineon/inffmac/bus_proto.h | 436 ++++++++++++++++++
 2 files changed, 598 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/bus_proto.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/bus_proto.h

diff --git a/drivers/net/wireless/infineon/inffmac/bus_proto.c b/drivers/net/wireless/infineon/inffmac/bus_proto.c
new file mode 100644
index 000000000000..8ea899e2e037
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/bus_proto.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2013 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/netdevice.h>
+
+#include "main.h"
+#include "cfg80211.h"
+#include "debug.h"
+#include "bus_proto.h"
+#include "bcdc.h"
+#include "icdc.h"
+
+static void inff_core_bus_reset(struct work_struct *work)
+{
+	struct inff_pub *drvr = container_of(work, struct inff_pub,
+					     bus_reset);
+
+	/* WLAN REG TOGGLE */
+	inff_bus_wlan_regon_gpio_toggle(0);
+	msleep(100);
+	inff_bus_wlan_regon_gpio_toggle(1);
+
+	inff_bus_reset(drvr->bus_if);
+}
+
+static ssize_t
+inff_bus_reset_write(struct file *file, const char __user *user_buf,
+		     size_t count, loff_t *ppos)
+{
+	struct inff_pub *drvr = file->private_data;
+	u8 value;
+
+	if (kstrtou8_from_user(user_buf, count, 0, &value))
+		return -EINVAL;
+
+	if (value != 1)
+		return -EINVAL;
+
+	schedule_work(&drvr->bus_reset);
+
+	return count;
+}
+
+static const struct file_operations bus_reset_fops = {
+	.open	= simple_open,
+	.write	= inff_bus_reset_write,
+};
+
+void inff_bus_proto_debugfs_create(struct inff_pub *drvr)
+{
+	struct inff_bus *bus = drvr->bus_if;
+
+	debugfs_create_file("reset", 0600, inff_debugfs_get_devdir(drvr),
+			    drvr, &bus_reset_fops);
+
+	if (bus->ops->debugfs_create)
+		bus->ops->debugfs_create(bus->dev);
+
+	if (drvr->proto->debugfs_create)
+		drvr->proto->debugfs_create(drvr);
+}
+
+void inff_bus_change_state(struct inff_bus *bus, enum inff_bus_state state)
+{
+	struct inff_pub *drvr = bus->drvr;
+	struct net_device *ndev;
+	int ifidx;
+
+	inff_dbg(TRACE, "%d -> %d\n", bus->state, state);
+
+	if (!drvr) {
+		inff_dbg(INFO, "ignoring transition, bus not attached yet\n");
+		return;
+	}
+
+	bus->state = state;
+
+	if (state == INFF_BUS_UP) {
+		for (ifidx = 0; ifidx < INFF_MAX_IFS; ifidx++) {
+			if (drvr->iflist[ifidx] &&
+			    drvr->iflist[ifidx]->ndev) {
+				ndev = drvr->iflist[ifidx]->ndev;
+				if (netif_queue_stopped(ndev))
+					netif_wake_queue(ndev);
+			}
+		}
+	}
+}
+
+void inff_bus_add_txhdrlen(struct device *dev, uint len)
+{
+	struct inff_bus *bus_if = dev_get_drvdata(dev);
+	struct inff_pub *drvr = bus_if->drvr;
+
+	if (drvr)
+		drvr->hdrlen += len;
+}
+
+void inff_bus_wlan_regon_gpio_toggle(u8 gpio_on)
+{
+	/* WLAN REG ON/OFF Toggle code to be added */
+}
+
+int inff_bus_proto_attach(struct inff_pub *drvr)
+{
+	struct inff_proto *proto;
+
+	proto = kzalloc_obj(*proto, GFP_ATOMIC);
+	if (!proto)
+		goto fail;
+
+	drvr->proto = proto;
+
+	if (drvr->bus_if->proto_type == INFF_PROTO_ICDC) {
+		if (inff_proto_icdc_attach(drvr))
+			goto fail;
+	} else if (drvr->bus_if->proto_type == INFF_PROTO_BCDC) {
+		if (inff_proto_bcdc_attach(drvr))
+			goto fail;
+	} else {
+		iphy_err(drvr, "Unsupported proto type %d\n",
+			 drvr->bus_if->proto_type);
+		goto fail;
+	}
+	if (!proto->tx_queue_data ||
+	    !proto->query_fwcmd || !proto->set_fwcmd ||
+	    !proto->configure_addr_mode ||
+	    !proto->delete_peer ||
+	    !proto->debugfs_create) {
+		iphy_err(drvr, "Not all proto handlers have been installed\n");
+		goto fail;
+	}
+
+	INIT_WORK(&drvr->bus_reset, inff_core_bus_reset);
+
+	return 0;
+
+fail:
+	kfree(proto);
+	drvr->proto = NULL;
+	return -ENOMEM;
+}
+
+void inff_bus_proto_detach(struct inff_pub *drvr)
+{
+	if (drvr->proto) {
+		if (drvr->bus_if->proto_type == INFF_PROTO_ICDC)
+			inff_proto_icdc_detach(drvr);
+		else if (drvr->bus_if->proto_type == INFF_PROTO_BCDC)
+			inff_proto_bcdc_detach(drvr);
+
+		kfree(drvr->proto);
+		drvr->proto = NULL;
+	}
+}
diff --git a/drivers/net/wireless/infineon/inffmac/bus_proto.h b/drivers/net/wireless/infineon/inffmac/bus_proto.h
new file mode 100644
index 000000000000..fffcc4f2db25
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/bus_proto.h
@@ -0,0 +1,436 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2013 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_BUS_PROTO_H
+#define INFF_BUS_PROTO_H
+
+/* State of bus for communication with the dongle */
+enum inff_bus_state {
+	INFF_BUS_DOWN,		/* Not ready for frame transfers */
+	INFF_BUS_UP		/* Ready for frame transfers */
+};
+
+/* Protocol of bus communication with the dongle */
+enum inff_bus_protocol_type {
+	INFF_PROTO_ICDC,
+	INFF_PROTO_BCDC
+};
+
+struct inff_bus_dcmd {
+	char *name;
+	char *param;
+	int param_len;
+	struct list_head list;
+};
+
+/* Firmware blobs that may be available */
+enum inff_blob_type {
+	INFF_BLOB_CLM,
+};
+
+/**
+ * struct inff_bus_ops - bus callback operations.
+ *
+ * @preinit: execute bus/device specific dongle init commands (optional).
+ * @init: prepare for communication with dongle.
+ * @stop: clear pending frames, disable data flow.
+ * @txdata: send a data frame to the dongle. When the data
+ *	has been transferred, the common driver must be
+ *	notified using inff_txcomplete(). The common
+ *	driver calls this function with interrupts
+ *	disabled.
+ * @txctl: transmit a control request message to dongle.
+ * @rxctl: receive a control response message from dongle.
+ * @gettxq: obtain a reference of bus transmit queue (optional).
+ * @get_rambase: obtain base address of wifiss.
+ * @get_ramsize: obtain memory size of wifiss.
+ * @get_cpuss_rambase: obtain base address of cpuss.
+ * @get_cpuss_ramsize: obtain memory size of cpuss.
+ * @get_blob: obtain a firmware blob.
+ * @remove: initiate unbind of the device.
+ * @interrupt_enable: enable the interrupts from the device.
+ * @interrupt_disable: disable the interrupts from the device.
+ *
+ * This structure provides an abstract interface towards the
+ * bus specific driver. For control messages to common driver
+ * will assure there is only one active transaction. Unless
+ * indicated otherwise these callbacks are mandatory.
+ */
+struct inff_bus_ops {
+	int (*preinit)(struct device *dev);
+	void (*stop)(struct device *dev);
+	int (*txdata)(struct device *dev, struct sk_buff *skb);
+	int (*txctl)(struct device *dev, unsigned char *msg, uint len);
+	int (*rxctl)(struct device *dev, unsigned char *msg, uint len);
+	struct pktq * (*gettxq)(struct device *dev);
+	size_t (*get_rambase)(struct device *dev);
+	size_t (*get_ramsize)(struct device *dev);
+	size_t (*get_cpuss_rambase)(struct device *dev);
+	size_t (*get_cpuss_ramsize)(struct device *dev);
+	int (*get_blob)(struct device *dev, const struct firmware **fw,
+			enum inff_blob_type type);
+	void (*debugfs_create)(struct device *dev);
+	int (*reset)(struct device *dev);
+	void (*remove)(struct device *dev);
+	int (*set_fcmode)(struct device *dev);
+	int (*napi_poll)(struct napi_struct *napi, int budget);
+	void (*interrupt_enable)(struct device *dev);
+	void (*interrupt_disable)(struct device *dev);
+};
+
+/**
+ * struct inff_bus_stats - bus statistic counters.
+ *
+ * @pktcowed: packets cowed for extra headroom/unorphan.
+ * @pktcow_failed: packets dropped due to failed cow-ing.
+ */
+struct inff_bus_stats {
+	atomic_t pktcowed;
+	atomic_t pktcow_failed;
+};
+
+/**
+ * struct inff_bus - interface structure between common and bus layer
+ *
+ * @bus_priv: pointer to private bus device.
+ * @proto_type: protocol type, icdc or bcdc
+ * @dev: device pointer of bus device.
+ * @drvr: public driver information.
+ * @state: operational state of the bus interface.
+ * @stats: statistics shared between common and bus layer.
+ * @maxctl: maximum size for rxctl request message.
+ * @chip: device identifier of the dongle chip.
+ * @always_use_fws_queue: bus wants use queue also when fwsignal is inactive.
+ * @chiprev: revision of the dongle chip.
+ */
+struct inff_bus {
+	union {
+		struct inff_sdio_dev *sdio;
+	} bus_priv;
+	enum inff_bus_protocol_type proto_type;
+	struct device *dev;
+	struct inff_pub *drvr;
+	enum inff_bus_state state;
+	struct inff_bus_stats stats;
+	uint maxctl;
+	u32 chip;
+	u32 chiprev;
+	bool always_use_fws_queue;
+
+	const struct inff_bus_ops *ops;
+	struct inff_chip *chip_pub;
+};
+
+enum proto_addr_mode {
+	ADDR_INDIRECT	= 0,
+	ADDR_DIRECT
+};
+
+struct inff_skb_reorder_data {
+	u8 *reorder;
+};
+
+struct inff_proto {
+	int (*query_cpcmd)(struct inff_pub *drvr, int ifidx, uint cmd,
+			   void *buf, uint len, int *fwerr);
+	int (*set_cpcmd)(struct inff_pub *drvr, int ifidx, uint cmd, void *buf,
+			 uint len, int *fwerr);
+	int (*query_fwcmd)(struct inff_pub *drvr, int ifidx, uint cmd,
+			   void *buf, uint len, int *fwerr);
+	int (*set_fwcmd)(struct inff_pub *drvr, int ifidx, uint cmd, void *buf,
+			 uint len, int *fwerr);
+	int (*hdrpull)(struct inff_pub *drvr, bool do_fws,
+		       struct sk_buff *skb, struct inff_if **ifp);
+	int (*tx_queue_data)(struct inff_pub *drvr, int ifidx,
+			     struct sk_buff *skb);
+	int (*txdata)(struct inff_pub *drvr, int ifidx, u8 offset,
+		      struct sk_buff *skb);
+	void (*configure_addr_mode)(struct inff_pub *drvr, int ifidx,
+				    enum proto_addr_mode addr_mode);
+	void (*delete_peer)(struct inff_pub *drvr, int ifidx,
+			    u8 peer[ETH_ALEN]);
+	void (*rxreorder)(struct inff_if *ifp, struct sk_buff *skb, bool inirq);
+	void (*add_if)(struct inff_if *ifp);
+	void (*del_if)(struct inff_if *ifp);
+	void (*reset_if)(struct inff_if *ifp);
+	void (*cleanup_if)(struct inff_if *ifp);
+	int (*init_done)(struct inff_pub *drvr);
+	void (*debugfs_create)(struct inff_pub *drvr);
+	void *pd;
+};
+
+/*
+ * callback wrappers
+ */
+static inline int
+inff_bus_preinit(struct inff_bus *bus)
+{
+	if (!bus->ops->preinit)
+		return 0;
+	return bus->ops->preinit(bus->dev);
+}
+
+static inline void
+inff_bus_stop(struct inff_bus *bus)
+{
+	bus->ops->stop(bus->dev);
+}
+
+static inline int
+inff_bus_txdata(struct inff_bus *bus, struct sk_buff *skb)
+{
+	return bus->ops->txdata(bus->dev, skb);
+}
+
+static inline int
+inff_bus_txctl(struct inff_bus *bus, unsigned char *msg, uint len)
+{
+	return bus->ops->txctl(bus->dev, msg, len);
+}
+
+static inline int
+inff_bus_rxctl(struct inff_bus *bus, unsigned char *msg, uint len)
+{
+	return bus->ops->rxctl(bus->dev, msg, len);
+}
+
+static inline struct pktq *
+inff_bus_gettxq(struct inff_bus *bus)
+{
+	if (!bus->ops->gettxq)
+		return ERR_PTR(-ENOENT);
+
+	return bus->ops->gettxq(bus->dev);
+}
+
+static inline size_t
+inff_bus_get_rambase(struct inff_bus *bus)
+{
+	if (!bus->ops->get_rambase)
+		return 0;
+
+	return bus->ops->get_rambase(bus->dev);
+}
+
+static inline size_t
+inff_bus_get_ramsize(struct inff_bus *bus)
+{
+	if (!bus->ops->get_ramsize)
+		return 0;
+
+	return bus->ops->get_ramsize(bus->dev);
+}
+
+static inline size_t
+inff_bus_get_cpuss_rambase(struct inff_bus *bus)
+{
+	if (!bus->ops->get_cpuss_rambase)
+		return 0;
+
+	return bus->ops->get_cpuss_rambase(bus->dev);
+}
+
+static inline size_t
+inff_bus_get_cpuss_ramsize(struct inff_bus *bus)
+{
+	if (!bus->ops->get_cpuss_ramsize)
+		return 0;
+
+	return bus->ops->get_cpuss_ramsize(bus->dev);
+}
+
+static inline int
+inff_bus_get_blob(struct inff_bus *bus, const struct firmware **fw,
+		  enum inff_blob_type type)
+{
+	return bus->ops->get_blob(bus->dev, fw, type);
+}
+
+static inline int
+inff_bus_reset(struct inff_bus *bus)
+{
+	if (!bus->ops->reset)
+		return -EOPNOTSUPP;
+
+	return bus->ops->reset(bus->dev);
+}
+
+static inline void
+inff_bus_remove(struct inff_bus *bus)
+{
+	if (!bus->ops->remove) {
+		device_release_driver(bus->dev);
+		return;
+	}
+
+	bus->ops->remove(bus->dev);
+}
+
+static inline int
+inff_bus_set_fcmode(struct inff_bus *bus)
+{
+	if (!bus->ops->set_fcmode)
+		return -EOPNOTSUPP;
+
+	return bus->ops->set_fcmode(bus->dev);
+}
+
+static inline void
+inff_bus_interrupt_enable(struct inff_bus *bus)
+{
+	if (!bus->ops->interrupt_enable)
+		return;
+
+	bus->ops->interrupt_enable(bus->dev);
+}
+
+static inline void
+inff_bus_interrupt_disable(struct inff_bus *bus)
+{
+	if (!bus->ops->interrupt_disable)
+		return;
+
+	bus->ops->interrupt_disable(bus->dev);
+}
+
+static inline int
+inff_proto_query_cpcmd(struct inff_pub *drvr, int ifidx,
+		       uint cmd, void *buf, uint len,
+		       int *cperr)
+{
+	return drvr->proto->query_cpcmd(drvr, ifidx, cmd, buf, len, cperr);
+}
+
+static inline int
+inff_proto_set_cpcmd(struct inff_pub *drvr, int ifidx,
+		     uint cmd, void *buf, uint len, int *cperr)
+{
+	return drvr->proto->set_cpcmd(drvr, ifidx, cmd, buf, len, cperr);
+}
+
+static inline int
+inff_proto_query_fwcmd(struct inff_pub *drvr, int ifidx,
+		       uint cmd, void *buf, uint len,
+		       int *fwerr)
+{
+	return drvr->proto->query_fwcmd(drvr, ifidx, cmd, buf, len, fwerr);
+}
+
+static inline int
+inff_proto_set_fwcmd(struct inff_pub *drvr, int ifidx,
+		     uint cmd, void *buf, uint len, int *fwerr)
+{
+	return drvr->proto->set_fwcmd(drvr, ifidx, cmd, buf, len, fwerr);
+}
+
+static inline int
+inff_proto_hdrpull(struct inff_pub *drvr, bool do_fws,
+		   struct sk_buff *skb,
+		   struct inff_if **ifp)
+{
+	struct inff_if *tmp = NULL;
+
+	/* assure protocol is always called with
+	 * non-null initialized pointer.
+	 */
+	if (ifp)
+		*ifp = NULL;
+	else
+		ifp = &tmp;
+	return drvr->proto->hdrpull(drvr, do_fws, skb, ifp);
+}
+
+static inline int
+inff_proto_tx_queue_data(struct inff_pub *drvr, int ifidx,
+			 struct sk_buff *skb)
+{
+	return drvr->proto->tx_queue_data(drvr, ifidx, skb);
+}
+
+static inline int
+inff_proto_txdata(struct inff_pub *drvr, int ifidx,
+		  u8 offset, struct sk_buff *skb)
+{
+	return drvr->proto->txdata(drvr, ifidx, offset, skb);
+}
+
+static inline void
+inff_proto_configure_addr_mode(struct inff_pub *drvr, int ifidx,
+			       enum proto_addr_mode addr_mode)
+{
+	drvr->proto->configure_addr_mode(drvr, ifidx, addr_mode);
+}
+
+static inline void
+inff_proto_delete_peer(struct inff_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
+{
+	drvr->proto->delete_peer(drvr, ifidx, peer);
+}
+
+static inline bool inff_proto_is_reorder_skb(struct sk_buff *skb)
+{
+	struct inff_skb_reorder_data *rd;
+
+	rd = (struct inff_skb_reorder_data *)skb->cb;
+	return !!rd->reorder;
+}
+
+static inline void
+inff_proto_rxreorder(struct inff_if *ifp, struct sk_buff *skb, bool inirq)
+{
+	ifp->drvr->proto->rxreorder(ifp, skb, inirq);
+}
+
+static inline void
+inff_proto_add_if(struct inff_pub *drvr, struct inff_if *ifp)
+{
+	if (!drvr->proto->add_if)
+		return;
+	drvr->proto->add_if(ifp);
+}
+
+static inline void
+inff_proto_del_if(struct inff_pub *drvr, struct inff_if *ifp)
+{
+	if (!drvr->proto->del_if)
+		return;
+	drvr->proto->del_if(ifp);
+}
+
+static inline void
+inff_proto_reset_if(struct inff_pub *drvr, struct inff_if *ifp)
+{
+	if (!drvr->proto->reset_if)
+		return;
+	drvr->proto->reset_if(ifp);
+}
+
+static inline void
+inff_proto_cleanup_if(struct inff_pub *drvr, struct inff_if *ifp)
+{
+	if (!drvr->proto->cleanup_if)
+		return;
+	drvr->proto->cleanup_if(ifp);
+}
+
+static inline int
+inff_proto_init_done(struct inff_pub *drvr)
+{
+	if (!drvr->proto->init_done)
+		return 0;
+	return drvr->proto->init_done(drvr);
+}
+
+void inff_bus_proto_debugfs_create(struct inff_pub *drvr);
+void inff_bus_change_state(struct inff_bus *bus, enum inff_bus_state state);
+void inff_bus_add_txhdrlen(struct device *dev, uint len);
+void inff_bus_wlan_regon_gpio_toggle(u8 gpio_on);
+int inff_bus_proto_attach(struct inff_pub *drvr);
+void inff_bus_proto_detach(struct inff_pub *drvr);
+
+#endif /* INFF_BUS_PROTO_H */
-- 
2.43.0

