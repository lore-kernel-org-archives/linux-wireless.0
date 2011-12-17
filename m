Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2348 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760945Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 17/30] brcm80211: fmac: move packet realloc stats to
 struct brcmf_bus
Date: Fri, 16 Dec 2011 18:37:07 -0800
Message-ID: <1324089440-8957-18-git-send-email-frankyl@broadcom.com> (sfid-20111217_035946_426901_802415E2)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tx_realloc is used by both common layer and bus layer. This patch
moves it to interface structure brcmf_bus as part of the fullmac
bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    3 +--
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 86cb197..7461567 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -578,6 +578,7 @@ struct brcmf_bus {
 	enum brcmf_bus_state state;
 	uint maxctl;		/* Max size rxctl request from proto to bus */
 	bool drvr_up;		/* Status flag of driver up/down */
+	unsigned long tx_realloc;	/* Tx packets realloced for headroom */
 	struct dngl_stats dstats;	/* Stats for dongle-based data */
 };
 
@@ -615,8 +616,6 @@ struct brcmf_pub {
 	/* Number of times dpc scheduled by watchdog timer */
 	unsigned long wd_dpc_sched;
 
-	/* Number of tx packets we had to realloc for headroom */
-	unsigned long tx_realloc;
 	/* Number of flow control pkts recvd */
 	unsigned long fc_packets;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index e456099..1ce6322 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -324,7 +324,7 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 		brcmf_dbg(INFO, "%s: insufficient headroom\n",
 			  brcmf_ifname(drvr, ifp->idx));
-		drvr->tx_realloc++;
+		drvr->bus_if->tx_realloc++;
 		skb2 = skb_realloc_headroom(skb, drvr->hdrlen);
 		dev_kfree_skb(skb);
 		skb = skb2;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 4b0a87d..e0456e9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2130,7 +2130,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 		if (skb_headroom(pkt) < pad) {
 			brcmf_dbg(INFO, "insufficient headroom %d for %d pad\n",
 				  skb_headroom(pkt), pad);
-			bus->drvr->tx_realloc++;
+			bus->sdiodev->bus_if->tx_realloc++;
 			new = brcmu_pkt_buf_get_skb(pkt->len + BRCMF_SDALIGN);
 			if (!new) {
 				brcmf_dbg(ERROR, "couldn't allocate new %d-byte packet\n",
-- 
1.7.5.4


