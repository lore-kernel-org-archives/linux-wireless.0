Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2353 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760939Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/30] brcm80211: fmac: move sdio used statistics to
 struct brcmf_sdio
Date: Fri, 16 Dec 2011 18:37:02 -0800
Message-ID: <1324089440-8957-13-git-send-email-frankyl@broadcom.com> (sfid-20111217_033744_561189_0FAF53E6)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some statistics only used by sdio modules. Move them to sdio layer
private structure brcmf_sdio. This is part of the fullmac bus
interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   11 ----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   21 +++++++++++++------
 2 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 027083e..bfd26e3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -614,21 +614,13 @@ struct brcmf_pub {
 	unsigned long tx_multicast;
 	/* Errors in sending data to dongle */
 	unsigned long tx_errors;
-	/* Control packets sent to dongle */
-	unsigned long tx_ctlpkts;
-	/* Errors sending control frames to dongle */
-	unsigned long tx_ctlerrs;
 	/* Packets sent up the network interface */
 	unsigned long rx_packets;
 	/* Multicast packets sent up the network interface */
 	unsigned long rx_multicast;
 	/* Errors processing rx data packets */
 	unsigned long rx_errors;
-	/* Control frames processed from dongle */
-	unsigned long rx_ctlpkts;
 
-	/* Errors in processing rx control frames */
-	unsigned long rx_ctlerrs;
 	/* Packets dropped locally (no memory) */
 	unsigned long rx_dropped;
 	/* Packets flushed due to unscheduled sendup thread */
@@ -636,8 +628,6 @@ struct brcmf_pub {
 	/* Number of times dpc scheduled by watchdog timer */
 	unsigned long wd_dpc_sched;
 
-	/* Number of packets where header read-ahead was used. */
-	unsigned long rx_readahead_cnt;
 	/* Number of tx packets we had to realloc for headroom */
 	unsigned long tx_realloc;
 	/* Number of flow control pkts recvd */
@@ -645,7 +635,6 @@ struct brcmf_pub {
 
 	/* Last error return */
 	int bcmerror;
-	uint tickcnt;
 
 	/* Last error from dongle */
 	int dongle_error;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a54abaf..5fb0d90 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -546,6 +546,13 @@ struct brcmf_sdio {
 	uint f2rxdata;		/* Number of frame data reads */
 	uint f2txdata;		/* Number of f2 frame writes */
 	uint f1regdata;		/* Number of f1 register accesses */
+	uint tickcnt;		/* Number of watchdog been schedule */
+	unsigned long tx_ctlerrs;	/* Err of sending ctrl frames */
+	unsigned long tx_ctlpkts;	/* Ctrl frames sent to dongle */
+	unsigned long rx_ctlerrs;	/* Err of processing rx ctrl frames */
+	unsigned long rx_ctlpkts;	/* Ctrl frames processed from dongle */
+	unsigned long rx_readahead_cnt;	/* Number of packets where header
+					 * read-ahead was used. */
 
 	u8 *ctrl_frame_buf;
 	u32 ctrl_frame_len;
@@ -1774,7 +1781,7 @@ brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 				bus->nextlen = 0;
 			}
 
-			bus->drvr->rx_readahead_cnt++;
+			bus->rx_readahead_cnt++;
 
 			/* Handle Flow Control */
 			fcbits = SDPCM_FCMASK_VALUE(
@@ -2912,9 +2919,9 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	up(&bus->sdsem);
 
 	if (ret)
-		bus->drvr->tx_ctlerrs++;
+		bus->tx_ctlerrs++;
 	else
-		bus->drvr->tx_ctlpkts++;
+		bus->tx_ctlpkts++;
 
 	return ret ? -EIO : 0;
 }
@@ -2953,9 +2960,9 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 	}
 
 	if (rxlen)
-		bus->drvr->rx_ctlpkts++;
+		bus->rx_ctlpkts++;
 	else
-		bus->drvr->rx_ctlerrs++;
+		bus->rx_ctlerrs++;
 
 	return rxlen ? (int)rxlen : -ETIMEDOUT;
 }
@@ -3436,7 +3443,7 @@ int brcmf_sdbrcm_bus_init(struct device *dev)
 		return 0;
 
 	/* Start the watchdog timer */
-	bus->drvr->tickcnt = 0;
+	bus->tickcnt = 0;
 	brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 
 	down(&bus->sdsem);
@@ -3821,7 +3828,7 @@ brcmf_sdbrcm_watchdog_thread(void *data)
 		if (!wait_for_completion_interruptible(&bus->watchdog_wait)) {
 			brcmf_sdbrcm_bus_watchdog(bus);
 			/* Count the tick for reference */
-			bus->drvr->tickcnt++;
+			bus->tickcnt++;
 		} else
 			break;
 	}
-- 
1.7.5.4


