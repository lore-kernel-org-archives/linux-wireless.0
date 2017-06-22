Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:41334 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752937AbdFVKBJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 06:01:09 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>
Subject: [PATCH 3/4] brcmfmac: rework headroom check in .start_xmit()
Date: Thu, 22 Jun 2017 11:01:03 +0100
Message-Id: <1498125664-25980-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170622_120127_936039_DE28AB44)
In-Reply-To: <1498125664-25980-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1498125664-25980-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit 9cc4b7cb86cb ("brcmfmac: Make skb header writable
before use") the headroom usage has been fixed. However, the
driver was keeping statistics that got lost. So reworking the
code so we get those driver statistics back for debugging.

Cc: James Hughes <james.hughes@raspberrypi.org>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h | 15 ++++++++++++--
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 23 +++++++++++++++-------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 13 +++++++-----
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index e1a4d9e..163ddc4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -113,6 +113,17 @@ struct brcmf_bus_msgbuf {
 
 
 /**
+ * struct brcmf_bus_stats - bus statistic counters.
+ *
+ * @pktcowed: packets cowed for extra headroom/unorphan.
+ * @pktcow_failed: packets dropped due to failed cow-ing.
+ */
+struct brcmf_bus_stats {
+	atomic_t pktcowed;
+	atomic_t pktcow_failed;
+};
+
+/**
  * struct brcmf_bus - interface structure between common and bus layer
  *
  * @bus_priv: pointer to private bus device.
@@ -120,8 +131,8 @@ struct brcmf_bus_msgbuf {
  * @dev: device pointer of bus device.
  * @drvr: public driver information.
  * @state: operational state of the bus interface.
+ * @stats: statistics shared between common and bus layer.
  * @maxctl: maximum size for rxctl request message.
- * @tx_realloc: number of tx packets realloced for headroom.
  * @chip: device identifier of the dongle chip.
  * @always_use_fws_queue: bus wants use queue also when fwsignal is inactive.
  * @wowl_supported: is wowl supported by bus driver.
@@ -137,8 +148,8 @@ struct brcmf_bus {
 	struct device *dev;
 	struct brcmf_pub *drvr;
 	enum brcmf_bus_state state;
+	struct brcmf_bus_stats stats;
 	uint maxctl;
-	atomic_t tx_realloc;
 	u32 chip;
 	u32 chiprev;
 	bool always_use_fws_queue;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index a88da5a..790151b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -199,6 +199,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct ethhdr *eh;
+	int head_delta;
 
 	brcmf_dbg(DATA, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
 
@@ -211,13 +212,21 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		goto done;
 	}
 
-	/* Make sure there's enough writable headroom*/
-	ret = skb_cow_head(skb, drvr->hdrlen);
-	if (ret < 0) {
-		brcmf_err("%s: skb_cow_head failed\n",
-			  brcmf_ifname(ifp));
-		dev_kfree_skb(skb);
-		goto done;
+	/* Make sure there's enough writeable headroom */
+	if (skb_headroom(skb) < drvr->hdrlen || skb_header_cloned(skb)) {
+		head_delta = drvr->hdrlen - skb_headroom(skb);
+
+		brcmf_dbg(INFO, "%s: insufficient headroom (%d)\n",
+			  brcmf_ifname(ifp), head_delta);
+		atomic_inc(&drvr->bus_if->stats.pktcowed);
+		ret = pskb_expand_head(skb, ALIGN(head_delta, NET_SKB_PAD), 0,
+				       GFP_ATOMIC);
+		if (ret < 0) {
+			brcmf_err("%s: failed to expand headroom\n",
+				  brcmf_ifname(ifp));
+			atomic_inc(&drvr->bus_if->stats.pktcow_failed);
+			goto done;
+		}
 	}
 
 	/* validate length for ether packet */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index a280536..e745bc1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2037,6 +2037,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 static int brcmf_sdio_txpkt_hdalign(struct brcmf_sdio *bus, struct sk_buff *pkt)
 {
+	struct brcmf_bus_stats *stats;
 	u16 head_pad;
 	u8 *dat_buf;
 
@@ -2046,16 +2047,18 @@ static int brcmf_sdio_txpkt_hdalign(struct brcmf_sdio *bus, struct sk_buff *pkt)
 	head_pad = ((unsigned long)dat_buf % bus->head_align);
 	if (head_pad) {
 		if (skb_headroom(pkt) < head_pad) {
-			atomic_inc(&bus->sdiodev->bus_if->tx_realloc);
-			head_pad = 0;
-			if (skb_cow(pkt, head_pad))
+			stats = &bus->sdiodev->bus_if->stats;
+			atomic_inc(&stats->pktcowed);
+			if (skb_cow_head(pkt, head_pad)) {
+				atomic_inc(&stats->pktcow_failed);
 				return -ENOMEM;
+			}
 		}
 		skb_push(pkt, head_pad);
 		dat_buf = (u8 *)(pkt->data);
-		memset(dat_buf, 0, head_pad + bus->tx_hdrlen);
 	}
-	return head_pad;
+	memset(dat_buf, 0, head_pad + bus->tx_hdrlen);
+	return 0;
 }
 
 /**
-- 
1.9.1
