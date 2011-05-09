Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3425 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab1EIOdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/10] staging: brcm80211: use print_hex_dump_bytes
 kernel function
Date: Mon, 9 May 2011 16:33:26 +0200
Message-ID: <1304951609-2493-7-git-send-email-arend@broadcom.com> (sfid-20110509_163742_915779_CDA1F412)
In-Reply-To: <1304951609-2493-1-git-send-email-arend@broadcom.com>
References: <1304951609-2493-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The drivers had own implementation to dump buffer contents using
printk. This has been replaced by kernel function.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcoom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   91 +++++++++++++++++--------
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |    8 ++-
 drivers/staging/brcm80211/include/bcmutils.h  |    1 -
 drivers/staging/brcm80211/util/bcmutils.c     |   40 +----------
 4 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 49e73b2..9167ebc 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -15,9 +15,11 @@
  */
 
 #include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/pci_ids.h>
-#include <bcmdefs.h>
 #include <linux/netdevice.h>
+#include <bcmdefs.h>
 #include <bcmsdh.h>
 
 #ifdef BCMEMBEDIMAGE
@@ -1003,9 +1005,12 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	if (DHD_BYTES_ON() &&
 	    (((DHD_CTL_ON() && (chan == SDPCM_CONTROL_CHANNEL)) ||
 	      (DHD_DATA_ON() && (chan != SDPCM_CONTROL_CHANNEL))))) {
-		bcm_prhex("Tx Frame", frame, len);
+		printk(KERN_DEBUG "Tx Frame:\n");
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, frame, len);
 	} else if (DHD_HDRS_ON()) {
-		bcm_prhex("TxHdr", frame, min_t(u16, len, 16));
+		printk(KERN_DEBUG "TxHdr:\n");
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+				     frame, min_t(u16, len, 16));
 	}
 #endif
 
@@ -1333,10 +1338,15 @@ int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 
 	if (ret == -1) {
 #ifdef DHD_DEBUG
-		if (DHD_BYTES_ON() && DHD_CTL_ON())
-			bcm_prhex("Tx Frame", frame, len);
-		else if (DHD_HDRS_ON())
-			bcm_prhex("TxHdr", frame, min_t(u16, len, 16));
+		if (DHD_BYTES_ON() && DHD_CTL_ON()) {
+			printk(KERN_DEBUG "Tx Frame:\n");
+			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+					     frame, len);
+		} else if (DHD_HDRS_ON()) {
+			printk(KERN_DEBUG "TxHdr:\n");
+			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+					     frame, min_t(u16, len, 16));
+		}
 #endif
 
 		do {
@@ -3117,8 +3127,10 @@ dhdsdio_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 gotpkt:
 
 #ifdef DHD_DEBUG
-	if (DHD_BYTES_ON() && DHD_CTL_ON())
-		bcm_prhex("RxCtrl", bus->rxctl, len);
+	if (DHD_BYTES_ON() && DHD_CTL_ON()) {
+		printk(KERN_DEBUG "RxCtrl:\n");
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, bus->rxctl, len);
+	}
 #endif
 
 	/* Point to valid data and indicate its length */
@@ -3309,8 +3321,9 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 		}
 #ifdef DHD_DEBUG
 		if (DHD_GLOM_ON()) {
-			bcm_prhex("SUPERFRAME", pfirst->data,
-			      min_t(int, pfirst->len, 48));
+			printk(KERN_DEBUG "SUPERFRAME:\n");
+			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+				pfirst->data, min_t(int, pfirst->len, 48));
 		}
 #endif
 
@@ -3391,8 +3404,11 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
 			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
 #ifdef DHD_DEBUG
-			if (DHD_GLOM_ON())
-				bcm_prhex("subframe", dptr, 32);
+			if (DHD_GLOM_ON()) {
+				printk(KERN_DEBUG "subframe:\n");
+				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+						     dptr, 32);
+			}
 #endif
 
 			if ((u16)~(sublen ^ check)) {
@@ -3469,8 +3485,11 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 				rxseq = seq;
 			}
 #ifdef DHD_DEBUG
-			if (DHD_BYTES_ON() && DHD_DATA_ON())
-				bcm_prhex("Rx Subframe Data", dptr, dlen);
+			if (DHD_BYTES_ON() && DHD_DATA_ON()) {
+				printk(KERN_DEBUG "Rx Subframe Data:\n");
+				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+						     dptr, dlen);
+			}
 #endif
 
 			__skb_trim(pfirst, sublen);
@@ -3513,8 +3532,9 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 				__func__, num, pfirst, pfirst->data,
 				pfirst->len, pfirst->next,
 				pfirst->prev));
-				bcm_prhex("", (u8 *) pfirst->data,
-				      min_t(int, pfirst->len, 32));
+				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+						pfirst->data,
+						min_t(int, pfirst->len, 32));
 			}
 #endif				/* DHD_DEBUG */
 		}
@@ -3816,10 +3836,15 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			bus->tx_max = txmax;
 
 #ifdef DHD_DEBUG
-			if (DHD_BYTES_ON() && DHD_DATA_ON())
-				bcm_prhex("Rx Data", rxbuf, len);
-			else if (DHD_HDRS_ON())
-				bcm_prhex("RxHdr", bus->rxhdr, SDPCM_HDRLEN);
+			if (DHD_BYTES_ON() && DHD_DATA_ON()) {
+				printk(KERN_DEBUG "Rx Data:\n");
+				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+						     rxbuf, len);
+			} else if (DHD_HDRS_ON()) {
+				printk(KERN_DEBUG "RxHdr:\n");
+				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+						     bus->rxhdr, SDPCM_HDRLEN);
+			}
 #endif
 
 			if (chan == SDPCM_CONTROL_CHANNEL) {
@@ -3874,8 +3899,11 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			continue;
 		}
 #ifdef DHD_DEBUG
-		if (DHD_BYTES_ON() || DHD_HDRS_ON())
-			bcm_prhex("RxHdr", bus->rxhdr, SDPCM_HDRLEN);
+		if (DHD_BYTES_ON() || DHD_HDRS_ON()) {
+			printk(KERN_DEBUG "RxHdr:\n");
+			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+					     bus->rxhdr, SDPCM_HDRLEN);
+		}
 #endif
 
 		/* Extract hardware header fields */
@@ -4048,8 +4076,11 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		memcpy(pkt->data, bus->rxhdr, firstread);
 
 #ifdef DHD_DEBUG
-		if (DHD_BYTES_ON() && DHD_DATA_ON())
-			bcm_prhex("Rx Data", pkt->data, len);
+		if (DHD_BYTES_ON() && DHD_DATA_ON()) {
+			printk(KERN_DEBUG "Rx Data:\n");
+			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+					     pkt->data, len);
+		}
 #endif
 
 deliver:
@@ -4060,7 +4091,10 @@ deliver:
 					__func__, len));
 #ifdef DHD_DEBUG
 				if (DHD_GLOM_ON()) {
-					bcm_prhex("Glom Data", pkt->data, len);
+					printk(KERN_DEBUG "Glom Data:\n");
+					print_hex_dump_bytes("",
+							     DUMP_PREFIX_OFFSET,
+							     pkt->data, len);
 				}
 #endif
 				__skb_trim(pkt, len);
@@ -4621,8 +4655,9 @@ static void dhdsdio_pktgen(dhd_bus_t *bus)
 #ifdef DHD_DEBUG
 		if (DHD_BYTES_ON() && DHD_DATA_ON()) {
 			data = (u8 *) (pkt->data) + SDPCM_HDRLEN;
-			bcm_prhex("dhdsdio_pktgen: Tx Data", data,
-			      pkt->len - SDPCM_HDRLEN);
+			printk(KERN_DEBUG "dhdsdio_pktgen: Tx Data:\n");
+			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, data,
+					     pkt->len - SDPCM_HDRLEN);
 		}
 #endif
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index c1bd24f..2fed0eb 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -4681,8 +4681,9 @@ void wlc_print_txdesc(d11txh_t *txh)
 	char hexbuf[256];
 
 	/* add plcp header along with txh descriptor */
-	bcm_prhex("Raw TxDesc + plcp header", (unsigned char *) txh,
-		sizeof(d11txh_t) + 48);
+	printk(KERN_DEBUG "Raw TxDesc + plcp header:\n");
+	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
+			     txh, sizeof(d11txh_t) + 48);
 
 	printk(KERN_DEBUG "TxCtlLow: %04x ", mtcl);
 	printk(KERN_DEBUG "TxCtlHigh: %04x ", mtch);
@@ -4753,7 +4754,8 @@ void wlc_print_rxh(d11rxhdr_t *rxh)
 		{0, NULL}
 	};
 
-	bcm_prhex("Raw RxDesc", (unsigned char *) rxh, sizeof(d11rxhdr_t));
+	printk(KERN_DEBUG "Raw RxDesc:\n");
+	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, rxh, sizeof(d11rxhdr_t));
 
 	bcm_format_flags(macstat_flags, macstatus1, flagstr, 64);
 
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 2a00741..aa00e83 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -476,7 +476,6 @@ extern u8 bcm_crc8(u8 *p, uint nbytes, u8 crc);
 	extern int bcm_format_hex(char *str, const void *bytes, int len);
 #endif
 	extern char *bcm_chipname(uint chipid, char *buf, uint len);
-	extern void bcm_prhex(const char *msg, unsigned char *buf, uint len);
 
 	extern bcm_tlv_t *bcm_parse_tlvs(void *buf, int buflen,
 						    uint key);
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index cca5b7d..e185e28 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -21,6 +21,7 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/sched.h>
+#include <linux/printk.h>
 #include <bcmdefs.h>
 #include <stdarg.h>
 #include <bcmutils.h>
@@ -386,7 +387,7 @@ void bcm_prpkt(const char *msg, struct sk_buff *p0)
 		printk(KERN_DEBUG "%s:\n", msg);
 
 	for (p = p0; p; p = p->next)
-		bcm_prhex(NULL, p->data, p->len);
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, p->data, p->len);
 }
 EXPORT_SYMBOL(bcm_prpkt);
 #endif				/* defined(BCMDBG) */
@@ -629,43 +630,6 @@ int bcm_format_hex(char *str, const void *bytes, int len)
 EXPORT_SYMBOL(bcm_format_hex);
 #endif				/* defined(BCMDBG) */
 
-/* pretty hex print a contiguous buffer */
-void bcm_prhex(const char *msg, unsigned char *buf, uint nbytes)
-{
-	char line[128], *p;
-	int len = sizeof(line);
-	int nchar;
-	uint i;
-
-	if (msg && (msg[0] != '\0'))
-		printk(KERN_DEBUG "%s:\n", msg);
-
-	p = line;
-	for (i = 0; i < nbytes; i++) {
-		if (i % 16 == 0) {
-			nchar = snprintf(p, len, "  %04d: ", i);	/* line prefix */
-			p += nchar;
-			len -= nchar;
-		}
-		if (len > 0) {
-			nchar = snprintf(p, len, "%02x ", buf[i]);
-			p += nchar;
-			len -= nchar;
-		}
-
-		if (i % 16 == 15) {
-			printk(KERN_DEBUG "%s\n", line);	/* flush line */
-			p = line;
-			len = sizeof(line);
-		}
-	}
-
-	/* flush last partial line */
-	if (p != line)
-		printk(KERN_DEBUG "%s\n", line);
-}
-EXPORT_SYMBOL(bcm_prhex);
-
 char *bcm_chipname(uint chipid, char *buf, uint len)
 {
 	const char *fmt;
-- 
1.7.4.1


