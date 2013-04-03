Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3012 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760726Ab3DCKlZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/25] brcmfmac: allow stopping netif queue for
 different reasons
Date: Wed, 3 Apr 2013 12:40:34 +0200
Message-ID: <1364985650-11719-10-git-send-email-arend@broadcom.com> (sfid-20130403_124309_098733_D25F04FA)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the netif queue is only stopped when the bus interface is
giving a push back. This will change soon so prepare the driver by
adding a stop reason and stop/resume the queue accordingly.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   17 ++++++++++++
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   29 ++++++++++++++------
 2 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 64006ed..af307c1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -555,6 +555,19 @@ struct brcmf_cfg80211_vif;
 struct brcmf_fws_mac_descriptor;
 
 /**
+ * enum brcmf_netif_stop_reason - reason for stopping netif queue.
+ *
+ * @BRCMF_NETIF_STOP_REASON_FWS_FC:
+ *	netif stopped due to firmware signalling flow control.
+ * @BRCMF_NETIF_STOP_REASON_BLOCK_BUS:
+ *	netif stopped due to bus blocking.
+ */
+enum brcmf_netif_stop_reason {
+	BRCMF_NETIF_STOP_REASON_FWS_FC = 1,
+	BRCMF_NETIF_STOP_REASON_BLOCK_BUS = 2
+};
+
+/**
  * struct brcmf_if - interface control information.
  *
  * @drvr: points to device related information.
@@ -567,6 +580,7 @@ struct brcmf_fws_mac_descriptor;
  * @ifidx: interface index in device firmware.
  * @bssidx: index of bss associated with this interface.
  * @mac_addr: assigned mac address.
+ * @netif_stop: bitmap indicates reason why netif queues are stopped.
  * @pend_8021x_cnt: tracks outstanding number of 802.1x frames.
  * @pend_8021x_wait: used for signalling change in count.
  */
@@ -581,6 +595,7 @@ struct brcmf_if {
 	int ifidx;
 	s32 bssidx;
 	u8 mac_addr[ETH_ALEN];
+	u8 netif_stop;
 	atomic_t pend_8021x_cnt;
 	wait_queue_head_t pend_8021x_wait;
 };
@@ -605,6 +620,8 @@ extern int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
 extern struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx,
 				     s32 ifidx, char *name, u8 *mac_addr);
 extern void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx);
+void brcmf_txflowblock_if(struct brcmf_if *ifp,
+			  enum brcmf_netif_stop_reason reason, bool state);
 extern u32 brcmf_get_chip_info(struct brcmf_if *ifp);
 
 #endif				/* _BRCMF_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index a08db02..3ba9e104 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -248,9 +248,27 @@ done:
 	return NETDEV_TX_OK;
 }
 
+void brcmf_txflowblock_if(struct brcmf_if *ifp,
+			  enum brcmf_netif_stop_reason reason, bool state)
+{
+	if (!ifp)
+		return;
+
+	brcmf_dbg(TRACE, "enter: idx=%d stop=0x%X reason=%d state=%d\n",
+		  ifp->bssidx, ifp->netif_stop, reason, state);
+	if (state) {
+		if (!ifp->netif_stop)
+			netif_stop_queue(ifp->ndev);
+		ifp->netif_stop |= reason;
+	} else {
+		ifp->netif_stop &= ~reason;
+		if (!ifp->netif_stop)
+			netif_wake_queue(ifp->ndev);
+	}
+}
+
 void brcmf_txflowblock(struct device *dev, bool state)
 {
-	struct net_device *ndev;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 	int i;
@@ -258,13 +276,8 @@ void brcmf_txflowblock(struct device *dev, bool state)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	for (i = 0; i < BRCMF_MAX_IFS; i++)
-		if (drvr->iflist[i]) {
-			ndev = drvr->iflist[i]->ndev;
-			if (state)
-				netif_stop_queue(ndev);
-			else
-				netif_wake_queue(ndev);
-		}
+		brcmf_txflowblock_if(drvr->iflist[i],
+				     BRCMF_NETIF_STOP_REASON_BLOCK_BUS, state);
 }
 
 void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
-- 
1.7.10.4


