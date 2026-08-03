Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6096D3B059D;
	Mon,  3 Aug 2026 08:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785744593; cv=none; b=fk3qV88KXpHExMlP6RHbgeeFjnqSgMkUJH2BTvFFUTl4uPFCWGrlDZ4JhxwfbWAQfiNBMRZkRoLYRaW15P/cPqVrrdkUX2o+lybB4iXciJp99JTS1jobyxrz5BKDgcBYp7Cv+TdQc8PZM3DRv6sblB7AgWIhy2nVbBRCMvfQBrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785744593; c=relaxed/simple;
	bh=K0NiYfT0DNu6P8FWO+fWYxtc7OydF5HBQjv7sH8S5kM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jYoU2Icf4hn5HB/OhPU16lblP6OGN01X5Dcw3Rk7nAokDizpHEfwKgiQK3uANKk1iGd1Rg2JmOvNSH9nqrgAHEYc6tpMA9PVrbSEeBvFdWoc51J3wdor9o3mOFCpW2LaEp9RANv+mlG9XbTIi47xu/qk3EbJY9zGY3VeiH1rmpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ace7753e8f1211f1aa26b74ffac11d73-20260803
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
X-CID-O-INFO: VERSION:1.3.12,REQID:65312941-a323-4203-90a4-a1cbdc11d116,IP:15,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-10
X-CID-INFO: VERSION:1.3.12,REQID:65312941-a323-4203-90a4-a1cbdc11d116,IP:15,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-10
X-CID-META: VersionHash:e7bac3a,CLOUDID:095352a46740245848b2ccf8f0a24d03,BulkI
	D:260803160944BO3E582B,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|865
	|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ace7753e8f1211f1aa26b74ffac11d73-20260803
X-User: pengcan@kylinos.cn
Received: from lenovo [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <pengcan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1003929354; Mon, 03 Aug 2026 16:09:39 +0800
From: Can Peng <pengcan@kylinos.cn>
To: johannes@sipsolutions.net,
	arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Can Peng <pengcan@kylinos.cn>
Subject: [PATCH v3] wifi: brcmfmac: remove extra blank lines in msgbuf.c
Date: Mon,  3 Aug 2026 16:09:12 +0800
Message-ID: <20260803080912.553948-1-pengcan@kylinos.cn>
X-Mailer: git-send-email 2.53.0
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

Reviewed-by: johannes@sipsolutions.net
Reviewed-by: arend.vanspriel@broadcom.com
Signed-off-by: Can Peng <pengcan@kylinos.cn>
---
Changes in v3:
- Prepare the cleanup patch on top of wireless-next.
- Link to v1:
  https://lore.kernel.org/all/20260723055618.550834-1-pengcan@kylinos.cn/
- Link to v2:
  https://lore.kernel.org/all/20260803071259.546631-1-pengcan@kylinos.cn/
---
 .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 40 -------------------
 1 file changed, 40 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 069ba7016654..a69196f27b2b 100644
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
@@ -315,7 +313,6 @@ brcmf_msgbuf_init_pktids(u32 nr_array_entries,
 	return pktids;
 }
 
-
 static int
 brcmf_msgbuf_alloc_pktid(struct device *dev,
 			 struct brcmf_msgbuf_pktids *pktids,
@@ -363,7 +360,6 @@ brcmf_msgbuf_alloc_pktid(struct device *dev,
 	return 0;
 }
 
-
 static struct sk_buff *
 brcmf_msgbuf_get_pktid(struct device *dev, struct brcmf_msgbuf_pktids *pktids,
 		       u32 idx)
@@ -391,7 +387,6 @@ brcmf_msgbuf_get_pktid(struct device *dev, struct brcmf_msgbuf_pktids *pktids,
 	return NULL;
 }
 
-
 static void
 brcmf_msgbuf_release_array(struct device *dev,
 			   struct brcmf_msgbuf_pktids *pktids)
@@ -417,7 +412,6 @@ brcmf_msgbuf_release_array(struct device *dev,
 	kfree(pktids);
 }
 
-
 static void brcmf_msgbuf_release_pktids(struct brcmf_msgbuf *msgbuf)
 {
 	if (msgbuf->rx_pktids)
@@ -428,7 +422,6 @@ static void brcmf_msgbuf_release_pktids(struct brcmf_msgbuf *msgbuf)
 					   msgbuf->tx_pktids);
 }
 
-
 static int brcmf_msgbuf_tx_ioctl(struct brcmf_pub *drvr, int ifidx,
 				 uint cmd, void *buf, uint len)
 {
@@ -474,7 +467,6 @@ static int brcmf_msgbuf_tx_ioctl(struct brcmf_pub *drvr, int ifidx,
 	return err;
 }
 
-
 static int brcmf_msgbuf_ioctl_resp_wait(struct brcmf_msgbuf *msgbuf)
 {
 	return wait_event_timeout(msgbuf->ioctl_resp_wait,
@@ -482,14 +474,12 @@ static int brcmf_msgbuf_ioctl_resp_wait(struct brcmf_msgbuf *msgbuf)
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
@@ -527,14 +517,12 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
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
@@ -583,7 +571,6 @@ static bool brcmf_msgbuf_get_flowid(struct brcmf_msgbuf *msgbuf,
 	return true;
 }
 
-
 static struct brcmf_msgbuf_work_item *
 brcmf_msgbuf_dequeue_work(struct brcmf_msgbuf *msgbuf)
 {
@@ -601,7 +588,6 @@ brcmf_msgbuf_dequeue_work(struct brcmf_msgbuf *msgbuf)
 	return work;
 }
 
-
 static u32
 brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 				    struct brcmf_msgbuf_work_item *work)
@@ -670,7 +656,6 @@ brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 	return flowid;
 }
 
-
 static void brcmf_msgbuf_flowring_worker(struct work_struct *work)
 {
 	struct brcmf_msgbuf *msgbuf;
@@ -684,7 +669,6 @@ static void brcmf_msgbuf_flowring_worker(struct work_struct *work)
 	}
 }
 
-
 static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
 					struct sk_buff *skb)
 {
@@ -717,7 +701,6 @@ static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
 	return flowid;
 }
 
-
 static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 {
 	struct brcmf_flowring *flow = msgbuf->flow;
@@ -791,7 +774,6 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 	brcmf_commonring_unlock(commonring);
 }
 
-
 static void brcmf_msgbuf_txflow_worker(struct work_struct *worker)
 {
 	struct brcmf_msgbuf *msgbuf;
@@ -804,7 +786,6 @@ static void brcmf_msgbuf_txflow_worker(struct work_struct *worker)
 	}
 }
 
-
 static int brcmf_msgbuf_schedule_txdata(struct brcmf_msgbuf *msgbuf, u32 flowid,
 					bool force)
 {
@@ -819,7 +800,6 @@ static int brcmf_msgbuf_schedule_txdata(struct brcmf_msgbuf *msgbuf, u32 flowid,
 	return 0;
 }
 
-
 static int brcmf_msgbuf_tx_queue_data(struct brcmf_pub *drvr, int ifidx,
 				      struct sk_buff *skb)
 {
@@ -847,7 +827,6 @@ static int brcmf_msgbuf_tx_queue_data(struct brcmf_pub *drvr, int ifidx,
 	return 0;
 }
 
-
 static void
 brcmf_msgbuf_configure_addr_mode(struct brcmf_pub *drvr, int ifidx,
 				 enum proto_addr_mode addr_mode)
@@ -857,7 +836,6 @@ brcmf_msgbuf_configure_addr_mode(struct brcmf_pub *drvr, int ifidx,
 	brcmf_flowring_configure_addr_mode(msgbuf->flow, ifidx, addr_mode);
 }
 
-
 static void
 brcmf_msgbuf_delete_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
 {
@@ -866,7 +844,6 @@ brcmf_msgbuf_delete_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
 	brcmf_flowring_delete_peer(msgbuf->flow, ifidx, peer);
 }
 
-
 static void
 brcmf_msgbuf_add_tdls_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
 {
@@ -875,7 +852,6 @@ brcmf_msgbuf_add_tdls_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
 	brcmf_flowring_add_tdls_peer(msgbuf->flow, ifidx, peer);
 }
 
-
 static void
 brcmf_msgbuf_process_ioctl_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 {
@@ -895,7 +871,6 @@ brcmf_msgbuf_process_ioctl_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 	brcmf_msgbuf_rxbuf_ioctlresp_post(msgbuf);
 }
 
-
 static void
 brcmf_msgbuf_process_txstatus(struct brcmf_msgbuf *msgbuf, void *buf)
 {
@@ -928,7 +903,6 @@ brcmf_msgbuf_process_txstatus(struct brcmf_msgbuf *msgbuf, void *buf)
 			 skb, true);
 }
 
-
 static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 {
 	struct brcmf_pub *drvr = msgbuf->drvr;
@@ -1006,7 +980,6 @@ static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 	return i;
 }
 
-
 static void
 brcmf_msgbuf_rxbuf_data_fill(struct brcmf_msgbuf *msgbuf)
 {
@@ -1024,7 +997,6 @@ brcmf_msgbuf_rxbuf_data_fill(struct brcmf_msgbuf *msgbuf)
 	}
 }
 
-
 static void
 brcmf_msgbuf_update_rxbufpost_count(struct brcmf_msgbuf *msgbuf, u16 rxcnt)
 {
@@ -1034,7 +1006,6 @@ brcmf_msgbuf_update_rxbufpost_count(struct brcmf_msgbuf *msgbuf, u16 rxcnt)
 		brcmf_msgbuf_rxbuf_data_fill(msgbuf);
 }
 
-
 static u32
 brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 			     u32 count)
@@ -1108,7 +1079,6 @@ brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 	return i;
 }
 
-
 static void brcmf_msgbuf_rxbuf_ioctlresp_post(struct brcmf_msgbuf *msgbuf)
 {
 	u32 count;
@@ -1118,7 +1088,6 @@ static void brcmf_msgbuf_rxbuf_ioctlresp_post(struct brcmf_msgbuf *msgbuf)
 	msgbuf->cur_ioctlrespbuf += count;
 }
 
-
 static void brcmf_msgbuf_rxbuf_event_post(struct brcmf_msgbuf *msgbuf)
 {
 	u32 count;
@@ -1128,7 +1097,6 @@ static void brcmf_msgbuf_rxbuf_event_post(struct brcmf_msgbuf *msgbuf)
 	msgbuf->cur_eventbuf += count;
 }
 
-
 static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 {
 	struct brcmf_pub *drvr = msgbuf->drvr;
@@ -1171,7 +1139,6 @@ static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 	brcmu_pkt_buf_free_skb(skb);
 }
 
-
 static void
 brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 {
@@ -1289,7 +1256,6 @@ brcmf_msgbuf_process_flow_ring_create_response(struct brcmf_msgbuf *msgbuf,
 	brcmf_msgbuf_schedule_txdata(msgbuf, flowid, true);
 }
 
-
 static void
 brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 					       void *buf)
@@ -1319,7 +1285,6 @@ brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 	brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 }
 
-
 static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
 {
 	struct brcmf_pub *drvr = msgbuf->drvr;
@@ -1368,7 +1333,6 @@ static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
 	}
 }
 
-
 static void brcmf_msgbuf_process_rx(struct brcmf_msgbuf *msgbuf,
 				    struct brcmf_commonring *commonring)
 {
@@ -1400,7 +1364,6 @@ static void brcmf_msgbuf_process_rx(struct brcmf_msgbuf *msgbuf,
 		goto again;
 }
 
-
 int brcmf_proto_msgbuf_rx_trigger(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -1432,7 +1395,6 @@ int brcmf_proto_msgbuf_rx_trigger(struct device *dev)
 	return 0;
 }
 
-
 void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
@@ -1648,7 +1610,6 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	if (!msgbuf->flow)
 		goto fail;
 
-
 	brcmf_dbg(MSGBUF, "Feeding buffers, rx data %d, rx event %d, rx ioctl resp %d\n",
 		  msgbuf->max_rxbufpost, msgbuf->max_eventbuf,
 		  msgbuf->max_ioctlrespbuf);
@@ -1688,7 +1649,6 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	return -ENOMEM;
 }
 
-
 void brcmf_proto_msgbuf_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_msgbuf *msgbuf;
-- 
2.53.0

