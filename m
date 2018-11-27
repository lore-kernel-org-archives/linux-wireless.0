Return-Path: <SRS0=Otg8=OG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C42C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 22:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EEBB2086B
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 22:21:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EEBB2086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbeK1JU5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 04:20:57 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46267 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbeK1JU5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 04:20:57 -0500
Received: by mail-wr1-f68.google.com with SMTP id l9so24312768wrt.13
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2018 14:21:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x8UKj3zKEna90EfBWJDMTE/PMbBTYoInNryE+FRnSWo=;
        b=pZLdWz1r9I/n6FVqN2WAuffR6tbN6HtQcQ3A91TDIJyDP8I1Xhx9Alr/GJYPoc1/Mx
         oTXZF29yjSrqyYiBwVr9XMsAzFP23qvduZBbB1LkMWciQOTN8WOrs+7G8DXnBOoiX+JT
         R5ShjWAVFUXEysCsXYdODYR+OfRXIifKpUgKd6zXLquO+cyOzhAZlSLpX7XKsYt8gYyS
         PQkkSJ8XlBgE5rEWKvWOrhm4WQgKXrNOseoEDhCEHn6Gr0EYLgJJ9b/MUPtcpB2Sm6j2
         OwSRK/MjOvBbtT/fUCmdN3YKGDMRrtR9B7A8qJwtgzrslttDtGA6v9JA5PpeI8Wfvhpg
         MgFw==
X-Gm-Message-State: AA+aEWYSpxTy6DMu5GyzkhkTnxuV3GpX1JrJrj+YPE9o3CkOUZOPOIki
        q0+ZV239KaQsUPq0SZVash6S+CLwuMA=
X-Google-Smtp-Source: AFSGD/VyKrGU16VBvRmteyhdN3BCwn9RpnAGVJR4obkC3Kofwwl/QjdzsbQiVjnX2xeJb5THTjVysw==
X-Received: by 2002:adf:a393:: with SMTP id l19mr29614116wrb.110.1543357293109;
        Tue, 27 Nov 2018 14:21:33 -0800 (PST)
Received: from localhost.lan ([151.21.135.68])
        by smtp.gmail.com with ESMTPSA id 142sm866245wmw.27.2018.11.27.14.21.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 14:21:32 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     nbd@nbd.name
Subject: [RFC 5/5] mt76: add XDP support
Date:   Tue, 27 Nov 2018 23:21:12 +0100
Message-Id: <2aeaeea1d3aa7d690c80000c0748d77f05552a9d.1543343124.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce XDP in mt76 driver. Add mt76_xdp and mt76x02_xdp_setup
routines in order to initialize xdp rx driver hook with the bpf
program received from mac80211.
Introduce the mt76_dma_rx_xdp routine in order to run the attached
bpf program and parse the action result. Currently supported actions
are:
- XDP_PASS
- XDP_ABORTED
- XDP_DROP

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c      | 46 ++++++++++
 drivers/net/wireless/mediatek/mt76/mac80211.c | 18 ++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  6 ++
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  3 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  3 +
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 90 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 10 ++-
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  1 +
 10 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index efa0eab7cf01..b735849799e3 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/dma-mapping.h>
+#include <linux/bpf_trace.h>
 #include "mt76.h"
 #include "dma.h"
 
@@ -421,6 +422,44 @@ mt76_add_fragment(struct mt76_dev *dev, struct mt76_queue *q, void *data,
 	dev->drv->rx_skb(dev, q - dev->q_rx, skb);
 }
 
+static bool
+mt76_dma_rx_xdp(struct mt76_dev *dev, unsigned char *data,
+		int *len)
+{
+	struct page *page = virt_to_head_page(data);
+	struct xdp_buff xdp;
+	u32 action;
+
+	if (!dev->drv->xdp_rxq_info_lookup ||
+	    dev->drv->xdp_rxq_info_lookup(dev, data, &xdp) < 0)
+		return false;
+
+	xdp.data_hard_start = page_address(page);
+	xdp.data = (void *)data;
+	xdp_set_data_meta_invalid(&xdp);
+	xdp.data_end = xdp.data + *len;
+
+	action = bpf_prog_run_xdp(dev->xdp_prog, &xdp);
+	/* bpf program chan modify the original frame */
+	*len = xdp.data_end - xdp.data;
+	data = xdp.data;
+
+	switch (action) {
+	case XDP_PASS:
+		return false;
+	default:
+		bpf_warn_invalid_xdp_action(action);
+		/* fall through */
+	case XDP_ABORTED:
+		trace_xdp_exception(xdp.rxq->dev, dev->xdp_prog, action);
+		/* fall through */
+	case XDP_DROP:
+		/* XXX: we can reuse the buffer here */
+		skb_free_frag(data);
+		return true;
+	}
+}
+
 static int
 mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 {
@@ -437,6 +476,13 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 		if (!data)
 			break;
 
+		/* xdp does not support fragmentes frames */
+		if (dev->xdp_prog && !more &&
+		    mt76_dma_rx_xdp(dev, data, &len)) {
+			done++;
+			continue;
+		}
+
 		if (q->rx_head) {
 			mt76_add_fragment(dev, q, data, len, more);
 			continue;
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index b33074cf7e00..387c6bba80ca 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -707,3 +707,21 @@ int mt76_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76_sta_state);
+
+int mt76_xdp(struct ieee80211_hw *hw, struct netdev_bpf *xdp)
+{
+	struct mt76_dev *dev = hw->priv;
+
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		if (!dev->drv->xdp_setup)
+			return -ENOTSUPP;
+		return dev->drv->xdp_setup(dev, xdp->prog);
+	case XDP_QUERY_PROG:
+		xdp->prog_id = dev->xdp_prog ? dev->xdp_prog->aux->id : 0;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL_GPL(mt76_xdp);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 70924792d870..b46e162dbb80 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -295,6 +295,9 @@ struct mt76_driver_ops {
 
 	void (*sta_remove)(struct mt76_dev *dev, struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta);
+	int (*xdp_setup)(struct mt76_dev *dev, struct bpf_prog *prog);
+	int (*xdp_rxq_info_lookup)(struct mt76_dev *dev, unsigned char *data,
+				   struct xdp_buff *xdp);
 };
 
 struct mt76_channel_state {
@@ -461,6 +464,8 @@ struct mt76_dev {
 		struct mt76_mmio mmio;
 		struct mt76_usb usb;
 	};
+
+	struct bpf_prog *xdp_prog;
 };
 
 enum mt76_phy_type {
@@ -737,5 +742,6 @@ void mt76u_queues_deinit(struct mt76_dev *dev);
 void mt76u_mcu_complete_urb(struct urb *urb);
 int mt76u_mcu_init_rx(struct mt76_dev *dev);
 void mt76u_mcu_deinit(struct mt76_dev *dev);
+int mt76_xdp(struct ieee80211_hw *hw, struct netdev_bpf *xdp);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index d895b6f3dc44..38272593f839 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -105,6 +105,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.release_buffered_frames = mt76_release_buffered_frames,
 	.set_coverage_class = mt76x02_set_coverage_class,
 	.set_rts_threshold = mt76x02_set_rts_threshold,
+	.xdp = mt76_xdp,
 };
 
 static int mt76x0e_register_device(struct mt76x02_dev *dev)
@@ -163,6 +164,8 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		.sta_ps = mt76x02_sta_ps,
 		.sta_add = mt76x02_sta_add,
 		.sta_remove = mt76x02_sta_remove,
+		.xdp_setup = mt76x02_xdp_setup,
+		.xdp_rxq_info_lookup = mt76x02_xdp_rxq_info_lookup,
 	};
 	struct mt76x02_dev *dev;
 	int ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 3922854ffa06..c32185f226c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -170,6 +170,9 @@ extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_init_beacon_config(struct mt76x02_dev *dev);
 void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set);
 void mt76x02_mac_start(struct mt76x02_dev *dev);
+int mt76x02_xdp_setup(struct mt76_dev *mdev, struct bpf_prog *prog);
+int mt76x02_xdp_rxq_info_lookup(struct mt76_dev *mdev, unsigned char *data,
+				struct xdp_buff *xdp);
 
 void mt76x02_init_debugfs(struct mt76x02_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 4e597004c445..176625d23fb6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -38,6 +38,7 @@ struct mt76x02_tx_status {
 
 struct mt76x02_vif {
 	struct mt76_wcid group_wcid; /* must be first */
+	struct xdp_rxq_info xdp_rxq;
 	u8 idx;
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 66315410aebe..76fbf136d415 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -27,6 +27,12 @@ struct beacon_bc_data {
 	struct sk_buff *tail[8];
 };
 
+struct xdp_iter_data {
+	struct ieee80211_hdr *hdr;
+	struct mt76x02_dev *dev;
+	struct xdp_rxq_info **rxq_info;
+};
+
 static void
 mt76x02_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
@@ -384,3 +390,87 @@ void mt76x02_mac_start(struct mt76x02_dev *dev)
 			   MT_INT_TX_STAT);
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_start);
+
+int mt76x02_xdp_setup(struct mt76_dev *mdev, struct bpf_prog *prog)
+{
+	struct bpf_prog *old_prog;
+	struct mt76x02_dev *dev;
+	bool reset;
+
+	if (prog) {
+		prog = bpf_prog_add(prog, 1);
+		if (IS_ERR(prog))
+			return -EINVAL;
+	}
+
+	mutex_lock(&mdev->mutex);
+
+	reset = (!!mdev->xdp_prog ^ !!prog);
+	dev = container_of(mdev, struct mt76x02_dev, mt76);
+
+	if (reset) {
+		mt76_clear(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_RX);
+		napi_disable(&mdev->napi[MT_RXQ_MAIN]);
+		mt76_queue_init_rx_reset(dev, MT_RXQ_MAIN);
+	}
+
+	/* attach BPF program */
+	old_prog = xchg(&mdev->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	if (reset) {
+		struct mt76_queue *q = &mdev->q_rx[MT_RXQ_MAIN];
+
+		if (mdev->xdp_prog)
+			q->buf_size = PAGE_SIZE + XDP_PACKET_HEADROOM +
+				SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+		else
+			q->buf_size = MT_RX_BUF_SIZE;
+
+		mt76_queue_complete_rx_reset(dev, MT_RXQ_MAIN);
+		napi_enable(&mdev->napi[MT_RXQ_MAIN]);
+		mt76_set(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_RX);
+	}
+
+	mutex_unlock(&mdev->mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_xdp_setup);
+
+static void
+mt76x02_xdp_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct xdp_iter_data *data = (struct xdp_iter_data *)priv;
+
+	if (ether_addr_equal(mac, data->hdr->addr1) ||
+	    (!data->rxq_info && is_multicast_ether_addr(data->hdr->addr1))) {
+		struct mt76x02_vif *mvif;
+
+		mvif = (struct mt76x02_vif *)vif->drv_priv;
+		*data->rxq_info = &mvif->xdp_rxq;
+	}
+}
+
+int mt76x02_xdp_rxq_info_lookup(struct mt76_dev *mdev, unsigned char *data,
+				struct xdp_buff *xdp)
+{
+	struct xdp_iter_data xdp_data = {};
+	struct ieee80211_hdr *hdr;
+	struct mt76x02_dev *dev;
+
+	hdr = (struct ieee80211_hdr *)(data + sizeof(struct mt76x02_rxwi));
+	dev = container_of(mdev, struct mt76x02_dev, mt76);
+
+	xdp_data.rxq_info = &xdp->rxq;
+	xdp_data.dev = dev;
+	xdp_data.hdr = hdr;
+
+	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
+			IEEE80211_IFACE_ITER_RESUME_ALL,
+			mt76x02_xdp_iter, &xdp_data);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_xdp_rxq_info_lookup);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 87195076cf62..0270f7ef3002 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -211,6 +211,7 @@ int mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
 		     unsigned int idx)
 {
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
+	struct net_device *ndev = ieee80211_vif_to_netdev(vif);
 	struct mt76_txq *mtxq;
 
 	mvif->idx = idx;
@@ -221,7 +222,7 @@ int mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
 
 	mt76_txq_init(&dev->mt76, vif->txq);
 
-	return 0;
+	return ndev ? xdp_rxq_info_reg(&mvif->xdp_rxq, ndev, 0) : 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_vif_init);
 
@@ -257,9 +258,16 @@ EXPORT_SYMBOL_GPL(mt76x02_add_interface);
 void mt76x02_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif)
 {
+	struct net_device *ndev = ieee80211_vif_to_netdev(vif);
 	struct mt76x02_dev *dev = hw->priv;
 
 	mt76_txq_remove(&dev->mt76, vif->txq);
+	if (ndev) {
+		struct mt76x02_vif *mvif;
+
+		mvif = (struct mt76x02_vif *)vif->drv_priv;
+		xdp_rxq_info_unreg(&mvif->xdp_rxq);
+	}
 }
 EXPORT_SYMBOL_GPL(mt76x02_remove_interface);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 6eaab156387a..c6a60d6809f0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -325,6 +325,8 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 		.sta_ps = mt76x02_sta_ps,
 		.sta_add = mt76x02_sta_add,
 		.sta_remove = mt76x02_sta_remove,
+		.xdp_setup = mt76x02_xdp_setup,
+		.xdp_rxq_info_lookup = mt76x02_xdp_rxq_info_lookup,
 	};
 	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index b54a32397486..6898f134e3fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -199,5 +199,6 @@ const struct ieee80211_ops mt76x2_ops = {
 	.set_antenna = mt76x2_set_antenna,
 	.get_antenna = mt76x2_get_antenna,
 	.set_rts_threshold = mt76x02_set_rts_threshold,
+	.xdp = mt76_xdp,
 };
 
-- 
2.19.1

