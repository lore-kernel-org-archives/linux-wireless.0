Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E3B3148BF;
	Mon,  3 Aug 2026 07:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785741238; cv=none; b=WrZpALRIIdd6JcxpfhS25YYQFjf+a51/hKhkmGwXuweNNRN9C/0DZqxDadMOKzv7J+li3iKRvv8znIQW72osAmu5szRlyYXrJmN47S6l9CtL3xpWYVD0E3Joca0CxjiQAeAHB7tf4glkYg+d3e4IGISUZSEflCien10Ze/HdVtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785741238; c=relaxed/simple;
	bh=VtYz2/wWJtyuhTKmzk9MZwCWte5RUm5uVvD/Uj68hCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQULHUx0tv1dLNulzwA6knLGOc2g/Vdc7ohLLjE1b6yG+h7TqpNh93e3Yi0VrYCoWgZlPUBJ1BIpBqnOAYMZJWMmxpP4580LG8QscfsgAuVy2mG96vGXvER2/y+UlZR993RwvmeWdYz8Ds/i0tC09nmqJbGu0YopC5wQ9c8b3mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: dd4483828f0a11f1aa26b74ffac11d73-20260803
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:650df18a-d8b5-4890-af3c-9f6e73ef8a28,IP:15,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-10
X-CID-INFO: VERSION:1.3.12,REQID:650df18a-d8b5-4890-af3c-9f6e73ef8a28,IP:15,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-10
X-CID-META: VersionHash:e7bac3a,CLOUDID:5cee82692b1d3a65dd68ad84ebe48001,BulkI
	D:260803151349XRF06XGL,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dd4483828f0a11f1aa26b74ffac11d73-20260803
X-User: pengcan@kylinos.cn
Received: from lenovo [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <pengcan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1015243463; Mon, 03 Aug 2026 15:13:44 +0800
From: Can Peng <pengcan@kylinos.cn>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Can Peng <pengcan@kylinos.cn>
Subject: [PATCH v2 1/2] wifi: brcmfmac: remove extra blank lines in msgbuf.c
Date: Mon,  3 Aug 2026 15:12:58 +0800
Message-ID: <20260803071259.546631-2-pengcan@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260803071259.546631-1-pengcan@kylinos.cn>
References: <20260803071259.546631-1-pengcan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

msgbuf.c uses two blank lines in many places, including between
top-level declarations and functions.

Keep a single blank line instead to match common kernel coding style.

Signed-off-by: Can Peng <pengcan@kylinos.cn>
---
 .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 40 -------------------
 1 file changed, 40 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index ba1ce1552e0f..9c41e4a35815 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -24,7 +24,6 @@
 #include "bus.h"
 #include "tracepoint.h"
 
-
 #define MSGBUF_IOCTL_RESP_TIMEOUT		msecs_to_jiffies(2000)
 
 #define MSGBUF_TYPE_GEN_STATUS			0x1
@@ -291,7 +290,6 @@ struct brcmf_msgbuf_pktids {
 
 static void brcmf_msgbuf_rxbuf_ioctlresp_post(struct brcmf_msgbuf *msgbuf);
 
-
 static struct brcmf_msgbuf_pktids *
 brcmf_msgbuf_init_pktids(u32 nr_array_entries,
 			 enum dma_data_direction direction)
@@ -314,7 +312,6 @@ brcmf_msgbuf_init_pktids(u32 nr_array_entries,
 	return pktids;
 }
 
-
 static int
 brcmf_msgbuf_alloc_pktid(struct device *dev,
 			 struct brcmf_msgbuf_pktids *pktids,
@@ -362,7 +359,6 @@ brcmf_msgbuf_alloc_pktid(struct device *dev,
 	return 0;
 }
 
-
 static struct sk_buff *
 brcmf_msgbuf_get_pktid(struct device *dev, struct brcmf_msgbuf_pktids *pktids,
 		       u32 idx)
@@ -390,7 +386,6 @@ brcmf_msgbuf_get_pktid(struct device *dev, struct brcmf_msgbuf_pktids *pktids,
 	return NULL;
 }
 
-
 static void
 brcmf_msgbuf_release_array(struct device *dev,
 			   struct brcmf_msgbuf_pktids *pktids)
@@ -416,7 +411,6 @@ brcmf_msgbuf_release_array(struct device *dev,
 	kfree(pktids);
 }
 
-
 static void brcmf_msgbuf_release_pktids(struct brcmf_msgbuf *msgbuf)
 {
 	if (msgbuf->rx_pktids)
@@ -427,7 +421,6 @@ static void brcmf_msgbuf_release_pktids(struct brcmf_msgbuf *msgbuf)
 					   msgbuf->tx_pktids);
 }
 
-
 static int brcmf_msgbuf_tx_ioctl(struct brcmf_pub *drvr, int ifidx,
 				 uint cmd, void *buf, uint len)
 {
@@ -473,7 +466,6 @@ static int brcmf_msgbuf_tx_ioctl(struct brcmf_pub *drvr, int ifidx,
 	return err;
 }
 
-
 static int brcmf_msgbuf_ioctl_resp_wait(struct brcmf_msgbuf *msgbuf)
 {
 	return wait_event_timeout(msgbuf->ioctl_resp_wait,
@@ -481,14 +473,12 @@ static int brcmf_msgbuf_ioctl_resp_wait(struct brcmf_msgbuf *msgbuf)
 				  MSGBUF_IOCTL_RESP_TIMEOUT);
 }
 
-
 static void brcmf_msgbuf_ioctl_resp_wake(struct brcmf_msgbuf *msgbuf)
 {
 	msgbuf->ctl_completed = true;
 	wake_up(&msgbuf->ioctl_resp_wait);
 }
 
-
 static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 				   uint cmd, void *buf, uint len, int *fwerr)
 {
@@ -526,14 +516,12 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 	return 0;
 }
 
-
 static int brcmf_msgbuf_set_dcmd(struct brcmf_pub *drvr, int ifidx,
 				 uint cmd, void *buf, uint len, int *fwerr)
 {
 	return brcmf_msgbuf_query_dcmd(drvr, ifidx, cmd, buf, len, fwerr);
 }
 
-
 static int brcmf_msgbuf_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 				struct sk_buff *skb, struct brcmf_if **ifp)
 {
@@ -560,7 +548,6 @@ brcmf_msgbuf_remove_flowring(struct brcmf_msgbuf *msgbuf, u16 flowid)
 	brcmf_flowring_delete(msgbuf->flow, flowid);
 }
 
-
 static struct brcmf_msgbuf_work_item *
 brcmf_msgbuf_dequeue_work(struct brcmf_msgbuf *msgbuf)
 {
@@ -578,7 +565,6 @@ brcmf_msgbuf_dequeue_work(struct brcmf_msgbuf *msgbuf)
 	return work;
 }
 
-
 static u32
 brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 				    struct brcmf_msgbuf_work_item *work)
@@ -647,7 +633,6 @@ brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 	return flowid;
 }
 
-
 static void brcmf_msgbuf_flowring_worker(struct work_struct *work)
 {
 	struct brcmf_msgbuf *msgbuf;
@@ -661,7 +646,6 @@ static void brcmf_msgbuf_flowring_worker(struct work_struct *work)
 	}
 }
 
-
 static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
 					struct sk_buff *skb)
 {
@@ -694,7 +678,6 @@ static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
 	return flowid;
 }
 
-
 static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 {
 	struct brcmf_flowring *flow = msgbuf->flow;
@@ -768,7 +751,6 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 	brcmf_commonring_unlock(commonring);
 }
 
-
 static void brcmf_msgbuf_txflow_worker(struct work_struct *worker)
 {
 	struct brcmf_msgbuf *msgbuf;
@@ -781,7 +763,6 @@ static void brcmf_msgbuf_txflow_worker(struct work_struct *worker)
 	}
 }
 
-
 static int brcmf_msgbuf_schedule_txdata(struct brcmf_msgbuf *msgbuf, u32 flowid,
 					bool force)
 {
@@ -796,7 +777,6 @@ static int brcmf_msgbuf_schedule_txdata(struct brcmf_msgbuf *msgbuf, u32 flowid,
 	return 0;
 }
 
-
 static int brcmf_msgbuf_tx_queue_data(struct brcmf_pub *drvr, int ifidx,
 				      struct sk_buff *skb)
 {
@@ -824,7 +804,6 @@ static int brcmf_msgbuf_tx_queue_data(struct brcmf_pub *drvr, int ifidx,
 	return 0;
 }
 
-
 static void
 brcmf_msgbuf_configure_addr_mode(struct brcmf_pub *drvr, int ifidx,
 				 enum proto_addr_mode addr_mode)
@@ -834,7 +813,6 @@ brcmf_msgbuf_configure_addr_mode(struct brcmf_pub *drvr, int ifidx,
 	brcmf_flowring_configure_addr_mode(msgbuf->flow, ifidx, addr_mode);
 }
 
-
 static void
 brcmf_msgbuf_delete_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
 {
@@ -843,7 +821,6 @@ brcmf_msgbuf_delete_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
 	brcmf_flowring_delete_peer(msgbuf->flow, ifidx, peer);
 }
 
-
 static void
 brcmf_msgbuf_add_tdls_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
 {
@@ -852,7 +829,6 @@ brcmf_msgbuf_add_tdls_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
 	brcmf_flowring_add_tdls_peer(msgbuf->flow, ifidx, peer);
 }
 
-
 static void
 brcmf_msgbuf_process_ioctl_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 {
@@ -872,7 +848,6 @@ brcmf_msgbuf_process_ioctl_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 	brcmf_msgbuf_rxbuf_ioctlresp_post(msgbuf);
 }
 
-
 static void
 brcmf_msgbuf_process_txstatus(struct brcmf_msgbuf *msgbuf, void *buf)
 {
@@ -899,7 +874,6 @@ brcmf_msgbuf_process_txstatus(struct brcmf_msgbuf *msgbuf, void *buf)
 			 skb, true);
 }
 
-
 static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 {
 	struct brcmf_pub *drvr = msgbuf->drvr;
@@ -977,7 +951,6 @@ static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 	return i;
 }
 
-
 static void
 brcmf_msgbuf_rxbuf_data_fill(struct brcmf_msgbuf *msgbuf)
 {
@@ -995,7 +968,6 @@ brcmf_msgbuf_rxbuf_data_fill(struct brcmf_msgbuf *msgbuf)
 	}
 }
 
-
 static void
 brcmf_msgbuf_update_rxbufpost_count(struct brcmf_msgbuf *msgbuf, u16 rxcnt)
 {
@@ -1005,7 +977,6 @@ brcmf_msgbuf_update_rxbufpost_count(struct brcmf_msgbuf *msgbuf, u16 rxcnt)
 		brcmf_msgbuf_rxbuf_data_fill(msgbuf);
 }
 
-
 static u32
 brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 			     u32 count)
@@ -1079,7 +1050,6 @@ brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 	return i;
 }
 
-
 static void brcmf_msgbuf_rxbuf_ioctlresp_post(struct brcmf_msgbuf *msgbuf)
 {
 	u32 count;
@@ -1089,7 +1059,6 @@ static void brcmf_msgbuf_rxbuf_ioctlresp_post(struct brcmf_msgbuf *msgbuf)
 	msgbuf->cur_ioctlrespbuf += count;
 }
 
-
 static void brcmf_msgbuf_rxbuf_event_post(struct brcmf_msgbuf *msgbuf)
 {
 	u32 count;
@@ -1099,7 +1068,6 @@ static void brcmf_msgbuf_rxbuf_event_post(struct brcmf_msgbuf *msgbuf)
 	msgbuf->cur_eventbuf += count;
 }
 
-
 static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 {
 	struct brcmf_pub *drvr = msgbuf->drvr;
@@ -1142,7 +1110,6 @@ static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 	brcmu_pkt_buf_free_skb(skb);
 }
 
-
 static void
 brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 {
@@ -1257,7 +1224,6 @@ brcmf_msgbuf_process_flow_ring_create_response(struct brcmf_msgbuf *msgbuf,
 	brcmf_msgbuf_schedule_txdata(msgbuf, flowid, true);
 }
 
-
 static void
 brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 					       void *buf)
@@ -1284,7 +1250,6 @@ brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 	brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 }
 
-
 static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
 {
 	struct brcmf_pub *drvr = msgbuf->drvr;
@@ -1333,7 +1298,6 @@ static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
 	}
 }
 
-
 static void brcmf_msgbuf_process_rx(struct brcmf_msgbuf *msgbuf,
 				    struct brcmf_commonring *commonring)
 {
@@ -1365,7 +1329,6 @@ static void brcmf_msgbuf_process_rx(struct brcmf_msgbuf *msgbuf,
 		goto again;
 }
 
-
 int brcmf_proto_msgbuf_rx_trigger(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -1397,7 +1360,6 @@ int brcmf_proto_msgbuf_rx_trigger(struct device *dev)
 	return 0;
 }
 
-
 void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
@@ -1613,7 +1575,6 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	if (!msgbuf->flow)
 		goto fail;
 
-
 	brcmf_dbg(MSGBUF, "Feeding buffers, rx data %d, rx event %d, rx ioctl resp %d\n",
 		  msgbuf->max_rxbufpost, msgbuf->max_eventbuf,
 		  msgbuf->max_ioctlrespbuf);
@@ -1653,7 +1614,6 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	return -ENOMEM;
 }
 
-
 void brcmf_proto_msgbuf_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_msgbuf *msgbuf;
-- 
2.53.0
