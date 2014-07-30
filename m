Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:24722 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaG3LUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 07:20:12 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 7/8] brcmfmac: Fix msgbuf flow control.
Date: Wed, 30 Jul 2014 13:20:06 +0200
Message-ID: <1406719207-5126-8-git-send-email-arend@broadcom.com> (sfid-20140730_132019_218305_2D2B36B0)
In-Reply-To: <1406719207-5126-1-git-send-email-arend@broadcom.com>
References: <1406719207-5126-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Msgbuf flow control was using a function to flow off and on which
was not supported without proptx enabled. Also flow control needs
to be handled per ifidx.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |  6 +--
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c | 61 ++++++++++++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/flowring.h |  3 +-
 3 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 1825f73..5e4317d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -121,12 +121,12 @@ struct brcmf_fws_mac_descriptor;
  *
  * @BRCMF_NETIF_STOP_REASON_FWS_FC:
  *	netif stopped due to firmware signalling flow control.
- * @BRCMF_NETIF_STOP_REASON_BLOCK_BUS:
- *	netif stopped due to bus blocking.
+ * @BRCMF_NETIF_STOP_REASON_FLOW:
+ *	netif stopped due to flowring full.
  */
 enum brcmf_netif_stop_reason {
 	BRCMF_NETIF_STOP_REASON_FWS_FC = 1,
-	BRCMF_NETIF_STOP_REASON_BLOCK_BUS = 2
+	BRCMF_NETIF_STOP_REASON_FLOW = 2
 };
 
 /**
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
index 31c4c9f..4d55c21 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -158,6 +158,51 @@ u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u8 flowid)
 }
 
 
+static void brcmf_flowring_block(struct brcmf_flowring *flow, u8 flowid,
+				 bool blocked)
+{
+	struct brcmf_flowring_ring *ring;
+	struct brcmf_bus *bus_if;
+	struct brcmf_pub *drvr;
+	struct brcmf_if *ifp;
+	bool currently_blocked;
+	int i;
+	u8 ifidx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&flow->block_lock, flags);
+
+	ring = flow->rings[flowid];
+	ifidx = brcmf_flowring_ifidx_get(flow, flowid);
+
+	currently_blocked = false;
+	for (i = 0; i < flow->nrofrings; i++) {
+		if (flow->rings[i]) {
+			ring = flow->rings[i];
+			if ((ring->status == RING_OPEN) &&
+			    (brcmf_flowring_ifidx_get(flow, i) == ifidx)) {
+				if (ring->blocked) {
+					currently_blocked = true;
+					break;
+				}
+			}
+		}
+	}
+	ring->blocked = blocked;
+	if (currently_blocked == blocked) {
+		spin_unlock_irqrestore(&flow->block_lock, flags);
+		return;
+	}
+
+	bus_if = dev_get_drvdata(flow->dev);
+	drvr = bus_if->drvr;
+	ifp = drvr->iflist[ifidx];
+	brcmf_txflowblock_if(ifp, BRCMF_NETIF_STOP_REASON_FLOW, blocked);
+
+	spin_unlock_irqrestore(&flow->block_lock, flags);
+}
+
+
 void brcmf_flowring_delete(struct brcmf_flowring *flow, u8 flowid)
 {
 	struct brcmf_flowring_ring *ring;
@@ -167,6 +212,7 @@ void brcmf_flowring_delete(struct brcmf_flowring *flow, u8 flowid)
 	ring = flow->rings[flowid];
 	if (!ring)
 		return;
+	brcmf_flowring_block(flow, flowid, false);
 	hash_idx = ring->hash_id;
 	flow->hash[hash_idx].ifidx = BRCMF_FLOWRING_INVALID_IFIDX;
 	memset(flow->hash[hash_idx].mac, 0, ETH_ALEN);
@@ -193,9 +239,16 @@ void brcmf_flowring_enqueue(struct brcmf_flowring *flow, u8 flowid,
 
 	if (!ring->blocked &&
 	    (skb_queue_len(&ring->skblist) > BRCMF_FLOWRING_HIGH)) {
-		brcmf_txflowblock(flow->dev, true);
+		brcmf_flowring_block(flow, flowid, true);
 		brcmf_dbg(MSGBUF, "Flowcontrol: BLOCK for ring %d\n", flowid);
-		ring->blocked = 1;
+		/* To prevent (work around) possible race condition, check
+		 * queue len again. It is also possible to use locking to
+		 * protect, but that is undesirable for every enqueue and
+		 * dequeue. This simple check will solve a possible race
+		 * condition if it occurs.
+		 */
+		if (skb_queue_len(&ring->skblist) < BRCMF_FLOWRING_LOW)
+			brcmf_flowring_block(flow, flowid, false);
 	}
 }
 
@@ -213,9 +266,8 @@ struct sk_buff *brcmf_flowring_dequeue(struct brcmf_flowring *flow, u8 flowid)
 
 	if (ring->blocked &&
 	    (skb_queue_len(&ring->skblist) < BRCMF_FLOWRING_LOW)) {
-		brcmf_txflowblock(flow->dev, false);
+		brcmf_flowring_block(flow, flowid, false);
 		brcmf_dbg(MSGBUF, "Flowcontrol: OPEN for ring %d\n", flowid);
-		ring->blocked = 0;
 	}
 
 	return skb;
@@ -283,6 +335,7 @@ struct brcmf_flowring *brcmf_flowring_attach(struct device *dev, u16 nrofrings)
 	if (flow) {
 		flow->dev = dev;
 		flow->nrofrings = nrofrings;
+		spin_lock_init(&flow->block_lock);
 		for (i = 0; i < ARRAY_SIZE(flow->addr_mode); i++)
 			flow->addr_mode[i] = ADDR_INDIRECT;
 		for (i = 0; i < ARRAY_SIZE(flow->hash); i++)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
index 677f4b8..cb9644c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
@@ -35,7 +35,7 @@ enum ring_status {
 
 struct brcmf_flowring_ring {
 	u8 hash_id;
-	u8 blocked;
+	bool blocked;
 	enum ring_status status;
 	struct sk_buff_head skblist;
 };
@@ -44,6 +44,7 @@ struct brcmf_flowring {
 	struct device *dev;
 	struct brcmf_flowring_hash hash[BRCMF_FLOWRING_HASHSIZE];
 	struct brcmf_flowring_ring **rings;
+	spinlock_t block_lock;
 	enum proto_addr_mode addr_mode[BRCMF_MAX_IFS];
 	u16 nrofrings;
 };
-- 
1.9.1

