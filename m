Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1800 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152Ab3BFRlL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:41:11 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/12] brcmfmac: Track pending 8021x frames per ifp.
Date: Wed, 6 Feb 2013 18:40:39 +0100
Message-ID: <1360172447-2424-5-git-send-email-arend@broadcom.com> (sfid-20130206_184120_905498_7AC7D8AF)
In-Reply-To: <1360172447-2424-1-git-send-email-arend@broadcom.com>
References: <1360172447-2424-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Pending 8021x frames were tracked per dongle. This should be
done per ifp.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    7 +++---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   25 ++++++++++----------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index a2f32fb..f0e81a8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -489,9 +489,6 @@ struct brcmf_pub {
 	struct mutex proto_block;
 	unsigned char proto_buf[BRCMF_DCMD_MAXLEN];
 
-	atomic_t pend_8021x_cnt;
-	wait_queue_head_t pend_8021x_wait;
-
 	struct brcmf_fweh_info fweh;
 #ifdef DEBUG
 	struct dentry *dbgfs_dir;
@@ -518,6 +515,8 @@ struct brcmf_cfg80211_vif;
  * @idx: interface index in device firmware.
  * @bssidx: index of bss associated with this interface.
  * @mac_addr: assigned mac address.
+ * @pend_8021x_cnt: tracks outstanding number of 802.1x frames.
+ * @pend_8021x_wait: used for signalling change in count.
  */
 struct brcmf_if {
 	struct brcmf_pub *drvr;
@@ -529,6 +528,8 @@ struct brcmf_if {
 	int idx;
 	s32 bssidx;
 	u8 mac_addr[ETH_ALEN];
+	atomic_t pend_8021x_cnt;
+	wait_queue_head_t pend_8021x_wait;
 };
 
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 7554125..9a4494a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -217,7 +217,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	if (is_multicast_ether_addr(eh->h_dest))
 		drvr->tx_multicast++;
 	if (ntohs(eh->h_proto) == ETH_P_PAE)
-		atomic_inc(&drvr->pend_8021x_cnt);
+		atomic_inc(&ifp->pend_8021x_cnt);
 
 	/* If the protocol uses a data header, apply it */
 	brcmf_proto_hdrpush(drvr, ifp->idx, skb);
@@ -348,6 +348,7 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 	u16 type;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
+	struct brcmf_if *ifp;
 
 	brcmf_proto_hdrpull(drvr, &ifidx, txp);
 
@@ -355,9 +356,10 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 	type = ntohs(eh->h_proto);
 
 	if (type == ETH_P_PAE) {
-		atomic_dec(&drvr->pend_8021x_cnt);
-		if (waitqueue_active(&drvr->pend_8021x_wait))
-			wake_up(&drvr->pend_8021x_wait);
+		ifp = drvr->iflist[ifidx];
+		atomic_dec(&ifp->pend_8021x_cnt);
+		if (waitqueue_active(&ifp->pend_8021x_wait))
+			wake_up(&ifp->pend_8021x_wait);
 	}
 }
 
@@ -565,7 +567,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 		return -EAGAIN;
 	}
 
-	atomic_set(&drvr->pend_8021x_cnt, 0);
+	atomic_set(&ifp->pend_8021x_cnt, 0);
 
 	/* Get current TOE mode from dongle */
 	if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
@@ -686,6 +688,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 	INIT_WORK(&ifp->setmacaddr_work, _brcmf_set_mac_address);
 	INIT_WORK(&ifp->multicast_work, _brcmf_set_multicast_list);
 
+	init_waitqueue_head(&ifp->pend_8021x_wait);
+
 	if (addr_mask != NULL)
 		for (i = 0; i < ETH_ALEN; i++)
 			ifp->mac_addr[i] = drvr->mac[i] ^ addr_mask[i];
@@ -763,8 +767,6 @@ int brcmf_attach(uint bus_hdrlen, struct device *dev)
 
 	INIT_LIST_HEAD(&drvr->bus_if->dcmd_list);
 
-	init_waitqueue_head(&drvr->pend_8021x_wait);
-
 	return ret;
 
 fail:
@@ -879,19 +881,18 @@ void brcmf_detach(struct device *dev)
 	kfree(drvr);
 }
 
-static int brcmf_get_pend_8021x_cnt(struct brcmf_pub *drvr)
+static int brcmf_get_pend_8021x_cnt(struct brcmf_if *ifp)
 {
-	return atomic_read(&drvr->pend_8021x_cnt);
+	return atomic_read(&ifp->pend_8021x_cnt);
 }
 
 int brcmf_netdev_wait_pend8021x(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_pub *drvr = ifp->drvr;
 	int err;
 
-	err = wait_event_timeout(drvr->pend_8021x_wait,
-				 !brcmf_get_pend_8021x_cnt(drvr),
+	err = wait_event_timeout(ifp->pend_8021x_wait,
+				 !brcmf_get_pend_8021x_cnt(ifp),
 				 msecs_to_jiffies(MAX_WAIT_FOR_8021X_TX));
 
 	WARN_ON(!err);
-- 
1.7.10.4


