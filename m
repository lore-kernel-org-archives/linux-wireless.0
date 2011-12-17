Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2345 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760932Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/30] brcm80211: fmac: change function brcmf_c_prec_enq
 parameter
Date: Fri, 16 Dec 2011 18:36:59 -0800
Message-ID: <1324089440-8957-10-git-send-email-frankyl@broadcom.com> (sfid-20111217_033742_592066_FDC8DC73)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change parameter to device pointer for bus layer interface function
brcmf_c_prec_enq. This is part of the fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    4 +++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index bfceba3..e403ad0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -708,7 +708,7 @@ extern void brcmf_detach(struct device *dev);
 /* Indication from bus module to change flow-control state */
 extern void brcmf_txflowcontrol(struct device *dev, int ifidx, bool on);
 
-extern bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
+extern bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 			 struct sk_buff *pkt, int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index e9f7d66..279ae76 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -83,12 +83,14 @@ brcmf_c_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
 	return len;
 }
 
-bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
+bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 		      struct sk_buff *pkt, int prec)
 {
 	struct sk_buff *p;
 	int eprec = -1;		/* precedence to evict from */
 	bool discard_oldest;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
 
 	/* Fast case, precedence queue is not full and we are also not
 	 * exceeding total queue length
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 16a05e9..5d392c9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2590,7 +2590,8 @@ int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 
 	/* Priority based enq */
 	spin_lock_bh(&bus->txqlock);
-	if (brcmf_c_prec_enq(bus->drvr, &bus->txq, pkt, prec) == false) {
+	if (brcmf_c_prec_enq(bus->sdiodev->dev, &bus->txq, pkt, prec) ==
+	    false) {
 		skb_pull(pkt, SDPCM_HDRLEN);
 		brcmf_txcomplete(bus->sdiodev->dev, pkt, false);
 		brcmu_pkt_buf_free_skb(pkt);
-- 
1.7.5.4


