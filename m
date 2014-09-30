Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:62135 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaI3IXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 04:23:24 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/6] brcmfmac: Avoid usage of GFP_ATOMIC.
Date: Tue, 30 Sep 2014 10:23:15 +0200
Message-ID: <1412065398-14316-4-git-send-email-arend@broadcom.com> (sfid-20140930_102342_384807_C10EB977)
In-Reply-To: <1412065398-14316-1-git-send-email-arend@broadcom.com>
References: <1412065398-14316-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Msgbuf is using GFP_ATOMIC where GFP_KERNEL is also sufficient. On
some platforms the coherent DMA memory is very limited when using
GFP_ATOMIC. This patch changes usage of GFP_ATOMIC to GFP_KERNEL and
uses worker to make this possible for creation of flowring.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c |   4 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   | 128 +++++++++++++++++----
 2 files changed, 108 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
index a1016b8..1faa929 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -354,7 +354,7 @@ struct brcmf_flowring *brcmf_flowring_attach(struct device *dev, u16 nrofrings)
 	struct brcmf_flowring *flow;
 	u32 i;
 
-	flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
+	flow = kzalloc(sizeof(*flow), GFP_KERNEL);
 	if (flow) {
 		flow->dev = dev;
 		flow->nrofrings = nrofrings;
@@ -364,7 +364,7 @@ struct brcmf_flowring *brcmf_flowring_attach(struct device *dev, u16 nrofrings)
 		for (i = 0; i < ARRAY_SIZE(flow->hash); i++)
 			flow->hash[i].ifidx = BRCMF_FLOWRING_INVALID_IFIDX;
 		flow->rings = kcalloc(nrofrings, sizeof(*flow->rings),
-				      GFP_ATOMIC);
+				      GFP_KERNEL);
 		if (!flow->rings) {
 			kfree(flow);
 			flow = NULL;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 106e6bf..11cc051 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -208,6 +208,14 @@ struct msgbuf_flowring_flush_resp {
 	__le32				rsvd0[3];
 };
 
+struct brcmf_msgbuf_work_item {
+	struct list_head queue;
+	u32 flowid;
+	int ifidx;
+	u8 sa[ETH_ALEN];
+	u8 da[ETH_ALEN];
+};
+
 struct brcmf_msgbuf {
 	struct brcmf_pub *drvr;
 
@@ -248,6 +256,10 @@ struct brcmf_msgbuf {
 	struct work_struct txflow_work;
 	unsigned long *flow_map;
 	unsigned long *txstatus_done_map;
+
+	struct work_struct flowring_work;
+	spinlock_t flowring_work_lock;
+	struct list_head work_queue;
 };
 
 struct brcmf_msgbuf_pktid {
@@ -284,11 +296,11 @@ brcmf_msgbuf_init_pktids(u32 nr_array_entries,
 	struct brcmf_msgbuf_pktid *array;
 	struct brcmf_msgbuf_pktids *pktids;
 
-	array = kcalloc(nr_array_entries, sizeof(*array), GFP_ATOMIC);
+	array = kcalloc(nr_array_entries, sizeof(*array), GFP_KERNEL);
 	if (!array)
 		return NULL;
 
-	pktids = kzalloc(sizeof(*pktids), GFP_ATOMIC);
+	pktids = kzalloc(sizeof(*pktids), GFP_KERNEL);
 	if (!pktids) {
 		kfree(array);
 		return NULL;
@@ -544,11 +556,29 @@ brcmf_msgbuf_remove_flowring(struct brcmf_msgbuf *msgbuf, u16 flowid)
 }
 
 
-static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
-					struct sk_buff *skb)
+static struct brcmf_msgbuf_work_item *
+brcmf_msgbuf_dequeue_work(struct brcmf_msgbuf *msgbuf)
+{
+	struct brcmf_msgbuf_work_item *work = NULL;
+	ulong flags;
+
+	spin_lock_irqsave(&msgbuf->flowring_work_lock, flags);
+	if (!list_empty(&msgbuf->work_queue)) {
+		work = list_first_entry(&msgbuf->work_queue,
+					struct brcmf_msgbuf_work_item, queue);
+		list_del(&work->queue);
+	}
+	spin_unlock_irqrestore(&msgbuf->flowring_work_lock, flags);
+
+	return work;
+}
+
+
+static u32
+brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
+				    struct brcmf_msgbuf_work_item *work)
 {
 	struct msgbuf_tx_flowring_create_req *create;
-	struct ethhdr *eh = (struct ethhdr *)(skb->data);
 	struct brcmf_commonring *commonring;
 	void *ret_ptr;
 	u32 flowid;
@@ -557,16 +587,11 @@ static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
 	long long address;
 	int err;
 
-	flowid = brcmf_flowring_create(msgbuf->flow, eh->h_dest,
-				       skb->priority, ifidx);
-	if (flowid == BRCMF_FLOWRING_INVALID_ID)
-		return flowid;
-
+	flowid = work->flowid;
 	dma_sz = BRCMF_H2D_TXFLOWRING_MAX_ITEM * BRCMF_H2D_TXFLOWRING_ITEMSIZE;
-
 	dma_buf = dma_alloc_coherent(msgbuf->drvr->bus_if->dev, dma_sz,
 				     &msgbuf->flowring_dma_handle[flowid],
-				     GFP_ATOMIC);
+				     GFP_KERNEL);
 	if (!dma_buf) {
 		brcmf_err("dma_alloc_coherent failed\n");
 		brcmf_flowring_delete(msgbuf->flow, flowid);
@@ -589,13 +614,13 @@ static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
 
 	create = (struct msgbuf_tx_flowring_create_req *)ret_ptr;
 	create->msg.msgtype = MSGBUF_TYPE_FLOW_RING_CREATE;
-	create->msg.ifidx = ifidx;
+	create->msg.ifidx = work->ifidx;
 	create->msg.request_id = 0;
 	create->tid = brcmf_flowring_tid(msgbuf->flow, flowid);
 	create->flow_ring_id = cpu_to_le16(flowid +
 					   BRCMF_NROF_H2D_COMMON_MSGRINGS);
-	memcpy(create->sa, eh->h_source, ETH_ALEN);
-	memcpy(create->da, eh->h_dest, ETH_ALEN);
+	memcpy(create->sa, work->sa, ETH_ALEN);
+	memcpy(create->da, work->da, ETH_ALEN);
 	address = (long long)(long)msgbuf->flowring_dma_handle[flowid];
 	create->flow_ring_addr.high_addr = cpu_to_le32(address >> 32);
 	create->flow_ring_addr.low_addr = cpu_to_le32(address & 0xffffffff);
@@ -603,7 +628,7 @@ static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
 	create->len_item = cpu_to_le16(BRCMF_H2D_TXFLOWRING_ITEMSIZE);
 
 	brcmf_dbg(MSGBUF, "Send Flow Create Req flow ID %d for peer %pM prio %d ifindex %d\n",
-		  flowid, eh->h_dest, create->tid, ifidx);
+		  flowid, work->da, create->tid, work->ifidx);
 
 	err = brcmf_commonring_write_complete(commonring);
 	brcmf_commonring_unlock(commonring);
@@ -617,6 +642,53 @@ static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
 }
 
 
+static void brcmf_msgbuf_flowring_worker(struct work_struct *work)
+{
+	struct brcmf_msgbuf *msgbuf;
+	struct brcmf_msgbuf_work_item *create;
+
+	msgbuf = container_of(work, struct brcmf_msgbuf, flowring_work);
+
+	while ((create = brcmf_msgbuf_dequeue_work(msgbuf))) {
+		brcmf_msgbuf_flowring_create_worker(msgbuf, create);
+		kfree(create);
+	}
+}
+
+
+static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
+					struct sk_buff *skb)
+{
+	struct brcmf_msgbuf_work_item *create;
+	struct ethhdr *eh = (struct ethhdr *)(skb->data);
+	u32 flowid;
+	ulong flags;
+
+	create = kzalloc(sizeof(*create), GFP_ATOMIC);
+	if (create == NULL)
+		return BRCMF_FLOWRING_INVALID_ID;
+
+	flowid = brcmf_flowring_create(msgbuf->flow, eh->h_dest,
+				       skb->priority, ifidx);
+	if (flowid == BRCMF_FLOWRING_INVALID_ID) {
+		kfree(create);
+		return flowid;
+	}
+
+	create->flowid = flowid;
+	create->ifidx = ifidx;
+	memcpy(create->sa, eh->h_source, ETH_ALEN);
+	memcpy(create->da, eh->h_dest, ETH_ALEN);
+
+	spin_lock_irqsave(&msgbuf->flowring_work_lock, flags);
+	list_add_tail(&create->queue, &msgbuf->work_queue);
+	spin_unlock_irqrestore(&msgbuf->flowring_work_lock, flags);
+	schedule_work(&msgbuf->flowring_work);
+
+	return flowid;
+}
+
+
 static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u8 flowid)
 {
 	struct brcmf_flowring *flow = msgbuf->flow;
@@ -1272,7 +1344,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	u32 count;
 
 	if_msgbuf = drvr->bus_if->msgbuf;
-	msgbuf = kzalloc(sizeof(*msgbuf), GFP_ATOMIC);
+	msgbuf = kzalloc(sizeof(*msgbuf), GFP_KERNEL);
 	if (!msgbuf)
 		goto fail;
 
@@ -1283,11 +1355,11 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	}
 	INIT_WORK(&msgbuf->txflow_work, brcmf_msgbuf_txflow_worker);
 	count = BITS_TO_LONGS(if_msgbuf->nrof_flowrings);
-	msgbuf->flow_map = kzalloc(count, GFP_ATOMIC);
+	msgbuf->flow_map = kzalloc(count, GFP_KERNEL);
 	if (!msgbuf->flow_map)
 		goto fail;
 
-	msgbuf->txstatus_done_map = kzalloc(count, GFP_ATOMIC);
+	msgbuf->txstatus_done_map = kzalloc(count, GFP_KERNEL);
 	if (!msgbuf->txstatus_done_map)
 		goto fail;
 
@@ -1295,7 +1367,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	msgbuf->ioctbuf = dma_alloc_coherent(drvr->bus_if->dev,
 					     BRCMF_TX_IOCTL_MAX_MSG_SIZE,
 					     &msgbuf->ioctbuf_handle,
-					     GFP_ATOMIC);
+					     GFP_KERNEL);
 	if (!msgbuf->ioctbuf)
 		goto fail;
 	address = (long long)(long)msgbuf->ioctbuf_handle;
@@ -1318,7 +1390,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	msgbuf->flowrings = (struct brcmf_commonring **)if_msgbuf->flowrings;
 	msgbuf->nrof_flowrings = if_msgbuf->nrof_flowrings;
 	msgbuf->flowring_dma_handle = kzalloc(msgbuf->nrof_flowrings *
-		sizeof(*msgbuf->flowring_dma_handle), GFP_ATOMIC);
+		sizeof(*msgbuf->flowring_dma_handle), GFP_KERNEL);
 	if (!msgbuf->flowring_dma_handle)
 		goto fail;
 
@@ -1358,6 +1430,10 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	brcmf_msgbuf_rxbuf_event_post(msgbuf);
 	brcmf_msgbuf_rxbuf_ioctlresp_post(msgbuf);
 
+	INIT_WORK(&msgbuf->flowring_work, brcmf_msgbuf_flowring_worker);
+	spin_lock_init(&msgbuf->flowring_work_lock);
+	INIT_LIST_HEAD(&msgbuf->work_queue);
+
 	return 0;
 
 fail:
@@ -1380,11 +1456,19 @@ fail:
 void brcmf_proto_msgbuf_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_msgbuf *msgbuf;
+	struct brcmf_msgbuf_work_item *work;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	if (drvr->proto->pd) {
 		msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
-
+		cancel_work_sync(&msgbuf->flowring_work);
+		while (!list_empty(&msgbuf->work_queue)) {
+			work = list_first_entry(&msgbuf->work_queue,
+						struct brcmf_msgbuf_work_item,
+						queue);
+			list_del(&work->queue);
+			kfree(work);
+		}
 		kfree(msgbuf->flow_map);
 		kfree(msgbuf->txstatus_done_map);
 		if (msgbuf->txflow_wq)
-- 
1.9.1

