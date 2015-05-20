Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:44109 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbbETMJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 08:09:55 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/6] brcmfmac: Improve throughput by scheduling msbug flow worker.
Date: Wed, 20 May 2015 14:09:48 +0200
Message-ID: <1432123792-4155-3-git-send-email-arend@broadcom.com> (sfid-20150520_141013_093737_ED591FD8)
In-Reply-To: <1432123792-4155-1-git-send-email-arend@broadcom.com>
References: <1432123792-4155-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The tx flow worker in msgbuf gets scheduled at tx till a certain
threshold has been reached. Then the tx completes will take over
the scheduling. When amsdu and ampdu is used the frames are
transferred wireless in a very bulky fashion, in combination
with this scheduling algorithm and buffer limiters in the stack
this can result in limited throughput. This change causes the
flow worker to be scheduled more frequently from tx.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c | 5 +++--
 drivers/net/wireless/brcm80211/brcmfmac/flowring.h | 4 ++--
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   | 9 ++++++---
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
index eb13253..5944063 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -249,8 +249,8 @@ void brcmf_flowring_delete(struct brcmf_flowring *flow, u8 flowid)
 }
 
 
-void brcmf_flowring_enqueue(struct brcmf_flowring *flow, u8 flowid,
-			    struct sk_buff *skb)
+u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u8 flowid,
+			   struct sk_buff *skb)
 {
 	struct brcmf_flowring_ring *ring;
 
@@ -271,6 +271,7 @@ void brcmf_flowring_enqueue(struct brcmf_flowring *flow, u8 flowid,
 		if (skb_queue_len(&ring->skblist) < BRCMF_FLOWRING_LOW)
 			brcmf_flowring_block(flow, flowid, false);
 	}
+	return skb_queue_len(&ring->skblist);
 }
 
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
index a34cd39..5551861 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
@@ -64,8 +64,8 @@ u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 void brcmf_flowring_delete(struct brcmf_flowring *flow, u8 flowid);
 void brcmf_flowring_open(struct brcmf_flowring *flow, u8 flowid);
 u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u8 flowid);
-void brcmf_flowring_enqueue(struct brcmf_flowring *flow, u8 flowid,
-			    struct sk_buff *skb);
+u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u8 flowid,
+			   struct sk_buff *skb);
 struct sk_buff *brcmf_flowring_dequeue(struct brcmf_flowring *flow, u8 flowid);
 void brcmf_flowring_reinsert(struct brcmf_flowring *flow, u8 flowid,
 			     struct sk_buff *skb);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 4ec9811..b182f53 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -73,7 +73,7 @@
 #define BRCMF_MSGBUF_TX_FLUSH_CNT1		32
 #define BRCMF_MSGBUF_TX_FLUSH_CNT2		96
 
-#define BRCMF_MSGBUF_DELAY_TXWORKER_THRS	64
+#define BRCMF_MSGBUF_DELAY_TXWORKER_THRS	96
 #define BRCMF_MSGBUF_TRICKLE_TXWORKER_THRS	32
 
 struct msgbuf_common_hdr {
@@ -797,6 +797,8 @@ static int brcmf_msgbuf_txdata(struct brcmf_pub *drvr, int ifidx,
 	struct brcmf_flowring *flow = msgbuf->flow;
 	struct ethhdr *eh = (struct ethhdr *)(skb->data);
 	u32 flowid;
+	u32 queue_count;
+	bool force;
 
 	flowid = brcmf_flowring_lookup(flow, eh->h_dest, skb->priority, ifidx);
 	if (flowid == BRCMF_FLOWRING_INVALID_ID) {
@@ -804,8 +806,9 @@ static int brcmf_msgbuf_txdata(struct brcmf_pub *drvr, int ifidx,
 		if (flowid == BRCMF_FLOWRING_INVALID_ID)
 			return -ENOMEM;
 	}
-	brcmf_flowring_enqueue(flow, flowid, skb);
-	brcmf_msgbuf_schedule_txdata(msgbuf, flowid, false);
+	queue_count = brcmf_flowring_enqueue(flow, flowid, skb);
+	force = ((queue_count % BRCMF_MSGBUF_TRICKLE_TXWORKER_THRS) == 0);
+	brcmf_msgbuf_schedule_txdata(msgbuf, flowid, force);
 
 	return 0;
 }
-- 
1.9.1

