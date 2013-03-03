Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1548 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab3CCLpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:45:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/13] brcmfmac: add parameter to brcmf_proto_hdrpush()
 for data offset
Date: Sun, 3 Mar 2013 12:45:32 +0100
Message-ID: <1362311132-29561-14-git-send-email-arend@broadcom.com> (sfid-20130303_124602_103690_13C8ECD5)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_proto_hdrpush() increases the header space and
fills in the protocol header fields. One field is the data offset
which is currently fixed to zero meaning the data follows right
after the header. The parameter is added to determine the actual
start of data. This will be used for firmware signalling.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    5 ++---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 8212d43..e224bcb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -272,7 +272,7 @@ static void pkt_set_sum_good(struct sk_buff *skb, bool x)
 	skb->ip_summed = (x ? CHECKSUM_UNNECESSARY : CHECKSUM_NONE);
 }
 
-void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
+void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx, u8 offset,
 			 struct sk_buff *pktbuf)
 {
 	struct brcmf_proto_bdc_header *h;
@@ -280,7 +280,6 @@ void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
 	brcmf_dbg(CDC, "Enter\n");
 
 	/* Push BDC header used to convey priority for buses that don't */
-
 	skb_push(pktbuf, BDC_HEADER_LEN);
 
 	h = (struct brcmf_proto_bdc_header *)(pktbuf->data);
@@ -291,7 +290,7 @@ void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
 
 	h->priority = (pktbuf->priority & BDC_PRIORITY_MASK);
 	h->flags2 = 0;
-	h->data_offset = 0;
+	h->data_offset = offset;
 	BDC_SET_IF_IDX(h, ifidx);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 2110eed..d5d401a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -231,7 +231,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		atomic_inc(&ifp->pend_8021x_cnt);
 
 	/* If the protocol uses a data header, apply it */
-	brcmf_proto_hdrpush(drvr, ifp->ifidx, skb);
+	brcmf_proto_hdrpush(drvr, ifp->ifidx, 0, skb);
 
 	/* Use bus module to send data frame */
 	ret =  brcmf_bus_txdata(drvr->bus_if, skb);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
index 48fa703..ef91798 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
@@ -33,7 +33,7 @@ extern void brcmf_proto_stop(struct brcmf_pub *drvr);
 /* Add any protocol-specific data header.
  * Caller must reserve prot_hdrlen prepend space.
  */
-extern void brcmf_proto_hdrpush(struct brcmf_pub *, int ifidx,
+extern void brcmf_proto_hdrpush(struct brcmf_pub *, int ifidx, u8 offset,
 				struct sk_buff *txp);
 
 /* Sets dongle media info (drv_version, mac address). */
-- 
1.7.6


