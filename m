Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1909 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab1F2Xsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:33 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 007/119] staging: brcm80211: remove empty sdrxqlock from
 fullmac
Date: Wed, 29 Jun 2011 16:46:31 -0700
Message-ID: <1309391303-22741-8-git-send-email-frankyl@broadcom.com> (sfid-20110630_014839_159937_12B5697E)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove empty lock functions for sdio rx queue

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h       |    2 -
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    8 ------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   28 ------------------------
 3 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 4d92d69..01bacdb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -974,8 +974,6 @@ extern void dhd_os_sdlock(dhd_pub_t *pub);
 extern void dhd_os_sdunlock(dhd_pub_t *pub);
 extern void dhd_os_sdlock_txq(dhd_pub_t *pub);
 extern void dhd_os_sdunlock_txq(dhd_pub_t *pub);
-extern void dhd_os_sdlock_rxq(dhd_pub_t *pub);
-extern void dhd_os_sdunlock_rxq(dhd_pub_t *pub);
 extern void dhd_os_sdlock_sndup_rxq(dhd_pub_t *pub);
 extern void dhd_customer_gpio_wlan_ctrl(int onoff);
 extern int dhd_custom_get_mac_address(unsigned char *buf);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index d7f7449..4811d7a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -2595,14 +2595,6 @@ void dhd_os_sdunlock_txq(dhd_pub_t *pub)
 	spin_unlock_bh(&dhd->txqlock);
 }
 
-void dhd_os_sdlock_rxq(dhd_pub_t *pub)
-{
-}
-
-void dhd_os_sdunlock_rxq(dhd_pub_t *pub)
-{
-}
-
 static int
 dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 		  wl_event_msg_t *event, void **data)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index a803848..dcfebac 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -796,10 +796,8 @@ static void dhdsdio_chip_detach(struct dhd_bus *bus);
  */
 static void dhdsdio_pktfree2(dhd_bus_t *bus, struct sk_buff *pkt)
 {
-	dhd_os_sdlock_rxq(bus->dhd);
 	if ((bus->bus != SPI_BUS) || bus->usebufpool)
 		brcmu_pkt_buf_free_skb(pkt);
-	dhd_os_sdunlock_rxq(bus->dhd);
 }
 
 static void dhd_dongle_setmemsize(struct dhd_bus *bus, int mem_size)
@@ -3379,8 +3377,6 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 
 	/* If there's a descriptor, generate the packet chain */
 	if (bus->glomd) {
-		dhd_os_sdlock_rxq(bus->dhd);
-
 		pfirst = plast = pnext = NULL;
 		dlen = (u16) (bus->glomd->len);
 		dptr = bus->glomd->data;
@@ -3464,8 +3460,6 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 		brcmu_pkt_buf_free_skb(bus->glomd);
 		bus->glomd = NULL;
 		bus->nextlen = 0;
-
-		dhd_os_sdunlock_rxq(bus->dhd);
 	}
 
 	/* Ok -- either we just generated a packet chain,
@@ -3525,9 +3519,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			} else {
 				bus->glomerr = 0;
 				dhdsdio_rxfail(bus, true, false);
-				dhd_os_sdlock_rxq(bus->dhd);
 				brcmu_pkt_buf_free_skb(bus->glom);
-				dhd_os_sdunlock_rxq(bus->dhd);
 				bus->rxglomfail++;
 				bus->glom = NULL;
 			}
@@ -3658,9 +3650,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			} else {
 				bus->glomerr = 0;
 				dhdsdio_rxfail(bus, true, false);
-				dhd_os_sdlock_rxq(bus->dhd);
 				brcmu_pkt_buf_free_skb(bus->glom);
-				dhd_os_sdunlock_rxq(bus->dhd);
 				bus->rxglomfail++;
 				bus->glom = NULL;
 			}
@@ -3673,7 +3663,6 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 		bus->glom = NULL;
 		plast = NULL;
 
-		dhd_os_sdlock_rxq(bus->dhd);
 		for (num = 0; pfirst; rxseq++, pfirst = pnext) {
 			pnext = pfirst->next;
 			pfirst->next = NULL;
@@ -3752,7 +3741,6 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			}
 #endif				/* DHD_DEBUG */
 		}
-		dhd_os_sdunlock_rxq(bus->dhd);
 		if (num) {
 			dhd_os_sdunlock(bus->dhd);
 			dhd_rx_frame(bus->dhd, ifidx, save_pfirst, num);
@@ -3860,7 +3848,6 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			 * or non-data frame.
 			 */
 			/* Allocate a packet buffer */
-			dhd_os_sdlock_rxq(bus->dhd);
 			pkt = brcmu_pkt_buf_get_skb(rdlen + DHD_SDALIGN);
 			if (!pkt) {
 				if (bus->bus == SPI_BUS) {
@@ -3894,7 +3881,6 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 							rdlen, sdret));
 						/* dhd.rx_ctlerrs is higher */
 						bus->rxc_errors++;
-						dhd_os_sdunlock_rxq(bus->dhd);
 						dhdsdio_rxfail(bus, true,
 						       (bus->bus ==
 							SPI_BUS) ? false
@@ -3910,9 +3896,6 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 						   " len %d rdlen %d expected"
 						   " rxseq %d\n", __func__,
 						   len, rdlen, rxseq));
-					/* Just go try again w/normal
-					header read */
-					dhd_os_sdunlock_rxq(bus->dhd);
 					continue;
 				}
 			} else {
@@ -3936,7 +3919,6 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 						__func__, rdlen, sdret));
 					brcmu_pkt_buf_free_skb(pkt);
 					bus->dhd->rx_errors++;
-					dhd_os_sdunlock_rxq(bus->dhd);
 					/* Force retry w/normal header read.
 					 * Don't attempt NAK for
 					 * gSPI
@@ -3948,7 +3930,6 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					continue;
 				}
 			}
-			dhd_os_sdunlock_rxq(bus->dhd);
 
 			/* Now check the header */
 			memcpy(bus->rxhdr, rxbuf, SDPCM_HDRLEN);
@@ -4246,18 +4227,15 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			continue;
 		}
 
-		dhd_os_sdlock_rxq(bus->dhd);
 		pkt = brcmu_pkt_buf_get_skb(rdlen + firstread + DHD_SDALIGN);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
 			DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed: rdlen %d"
 				   " chan %d\n", __func__, rdlen, chan));
 			bus->dhd->rx_dropped++;
-			dhd_os_sdunlock_rxq(bus->dhd);
 			dhdsdio_rxfail(bus, false, RETRYCHAN(chan));
 			continue;
 		}
-		dhd_os_sdunlock_rxq(bus->dhd);
 
 		ASSERT(!(pkt->prev));
 
@@ -4281,9 +4259,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					SDPCM_DATA_CHANNEL)
 				       ? "data" : "test")),
 				   sdret));
-			dhd_os_sdlock_rxq(bus->dhd);
 			brcmu_pkt_buf_free_skb(pkt);
-			dhd_os_sdunlock_rxq(bus->dhd);
 			bus->dhd->rx_errors++;
 			dhdsdio_rxfail(bus, true, RETRYCHAN(chan));
 			continue;
@@ -4340,15 +4316,11 @@ deliver:
 #endif				/* SDTEST */
 
 		if (pkt->len == 0) {
-			dhd_os_sdlock_rxq(bus->dhd);
 			brcmu_pkt_buf_free_skb(pkt);
-			dhd_os_sdunlock_rxq(bus->dhd);
 			continue;
 		} else if (dhd_prot_hdrpull(bus->dhd, &ifidx, pkt) != 0) {
 			DHD_ERROR(("%s: rx protocol error\n", __func__));
-			dhd_os_sdlock_rxq(bus->dhd);
 			brcmu_pkt_buf_free_skb(pkt);
-			dhd_os_sdunlock_rxq(bus->dhd);
 			bus->dhd->rx_errors++;
 			continue;
 		}
-- 
1.7.1


