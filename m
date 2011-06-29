Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4699 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162Ab1F2XtM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:12 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 050/119] staging: brcm80211: get rid of
 PKT[TO/FROM]NATIVE macros
Date: Wed, 29 Jun 2011 16:47:14 -0700
Message-ID: <1309391303-22741-51-git-send-email-frankyl@broadcom.com> (sfid-20110630_015153_139699_AE285C27)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

These macros are not needed in a linux-only driver and have been
removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   42 +++--------------------
 1 files changed, 6 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 006b642..a3b60da 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -990,26 +990,9 @@ int brcmf_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 	return ret;
 }
 
-static inline void *
-osl_pkt_frmnative(struct sk_buff *skb)
-{
-	return (void *)skb;
-}
-#define PKTFRMNATIVE(osh, skb)	\
-	osl_pkt_frmnative((struct sk_buff *)(skb))
-
-static inline struct sk_buff *
-osl_pkt_tonative(void *pkt)
-{
-	return (struct sk_buff *)pkt;
-}
-#define PKTTONATIVE(osh, pkt)	\
-	osl_pkt_tonative((pkt))
-
 static int dhd_start_xmit(struct sk_buff *skb, struct net_device *net)
 {
 	int ret;
-	void *pktbuf;
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
 	int ifidx;
 
@@ -1048,17 +1031,7 @@ static int dhd_start_xmit(struct sk_buff *skb, struct net_device *net)
 		}
 	}
 
-	/* Convert to packet */
-	pktbuf = PKTFRMNATIVE(dhd->pub.osh, skb);
-	if (!pktbuf) {
-		DHD_ERROR(("%s: PKTFRMNATIVE failed\n",
-			   brcmf_ifname(&dhd->pub, ifidx)));
-		dev_kfree_skb_any(skb);
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	ret = brcmf_sendpkt(&dhd->pub, ifidx, pktbuf);
+	ret = brcmf_sendpkt(&dhd->pub, ifidx, skb);
 
 done:
 	if (ret)
@@ -1086,11 +1059,10 @@ void brcmf_txflowcontrol(dhd_pub_t *dhdp, int ifidx, bool state)
 		netif_wake_queue(net);
 }
 
-void brcmf_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf,
+void brcmf_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *skb,
 		  int numpkt)
 {
 	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
-	struct sk_buff *skb;
 	unsigned char *eth;
 	uint len;
 	void *data;
@@ -1101,14 +1073,12 @@ void brcmf_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf,
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	save_pktbuf = pktbuf;
-
-	for (i = 0; pktbuf && i < numpkt; i++, pktbuf = pnext) {
+	save_pktbuf = skb;
 
-		pnext = pktbuf->next;
-		pktbuf->next = NULL;
+	for (i = 0; skb && i < numpkt; i++, skb = pnext) {
 
-		skb = PKTTONATIVE(dhdp->osh, pktbuf);
+		pnext = skb->next;
+		skb->next = NULL;
 
 		/* Get the protocol, maintain skb around eth_type_trans()
 		 * The main reason for this hack is for the limitation of
-- 
1.7.1


