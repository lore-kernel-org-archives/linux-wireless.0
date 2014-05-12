Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:31551 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbaELIro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:44 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/14] brcmfmac: Move handling 802.1x frames to dhd_linux.
Date: Mon, 12 May 2014 10:47:29 +0200
Message-ID: <1399884459-5048-5-git-send-email-arend@broadcom.com> (sfid-20140512_105149_349625_FBAFF00C)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Tracking and handling of 802.1x frames is done in two modules, it
is more logical and clear to move this to dhd_linux module.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    5 ++++-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   15 +++++----------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 6056efd..4cacc3d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -190,7 +190,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	int ret;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
-	struct ethhdr *eh;
+	struct ethhdr *eh = (struct ethhdr *)(skb->data);
 
 	brcmf_dbg(DATA, "Enter, idx=%d\n", ifp->bssidx);
 
@@ -236,6 +236,9 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		goto done;
 	}
 
+	if (eh->h_proto == htons(ETH_P_PAE))
+		atomic_inc(&ifp->pend_8021x_cnt);
+
 	ret = brcmf_fws_process_skb(ifp, skb);
 
 done:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index bfe7c9a..b58a97a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1863,7 +1863,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	struct ethhdr *eh = (struct ethhdr *)(skb->data);
 	int fifo = BRCMF_FWS_FIFO_BCMC;
 	bool multicast = is_multicast_ether_addr(eh->h_dest);
-	bool pae = eh->h_proto == htons(ETH_P_PAE);
+	int rc = 0;
 
 	brcmf_dbg(DATA, "tx proto=0x%X\n", ntohs(eh->h_proto));
 	/* determine the priority */
@@ -1871,8 +1871,6 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		skb->priority = cfg80211_classify8021d(skb, NULL);
 
 	drvr->tx_multicast += !!multicast;
-	if (pae)
-		atomic_inc(&ifp->pend_8021x_cnt);
 
 	/* set control buffer information */
 	skcb->if_flags = 0;
@@ -1894,15 +1892,12 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		brcmf_fws_schedule_deq(fws);
 	} else {
 		brcmf_err("drop skb: no hanger slot\n");
-		if (pae) {
-			atomic_dec(&ifp->pend_8021x_cnt);
-			if (waitqueue_active(&ifp->pend_8021x_wait))
-				wake_up(&ifp->pend_8021x_wait);
-		}
-		brcmu_pkt_buf_free_skb(skb);
+		brcmf_txfinalize(drvr, skb, ifp->ifidx, false);
+		rc = -ENOMEM;
 	}
 	brcmf_fws_unlock(fws);
-	return 0;
+
+	return rc;
 }
 
 void brcmf_fws_reset_interface(struct brcmf_if *ifp)
-- 
1.7.9.5

