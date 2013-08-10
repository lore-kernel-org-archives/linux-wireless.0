Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1671 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968545Ab3HJK1q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:27:46 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/12] brcmfmac: use irq safe spinlock in
 brcmf_sdbrcm_txdata()
Date: Sat, 10 Aug 2013 12:27:19 +0200
Message-ID: <1376130450-29746-2-git-send-email-arend@broadcom.com> (sfid-20130810_122815_259876_FA85AB12)
In-Reply-To: <1376130450-29746-1-git-send-email-arend@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware-signalling needs transmit to firmware to be atomic and
uses a spinlock with irq disabled. Therefor, brcmf_sdbrcm_txdata()
should not use spin_unlock_bh() as it would enable the interrupts.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  | 6 +++++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 5 +++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 080395f..9249b6d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -36,7 +36,11 @@ struct brcmf_bus_dcmd {
  *
  * @init: prepare for communication with dongle.
  * @stop: clear pending frames, disable data flow.
- * @txdata: send a data frame to the dongle (callee disposes skb).
+ * @txdata: send a data frame to the dongle. When the data
+ *	has been transferred, the common driver must be
+ *	notified using brcmf_txcomplete(). The common
+ *	driver calls this function with interrupts
+ *	disabled.
  * @txctl: transmit a control request message to dongle.
  * @rxctl: receive a control response message from dongle.
  * @gettxq: obtain a reference of bus transmit queue (optional).
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 2641119..5cbce1d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2276,6 +2276,7 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	ulong flags;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2293,7 +2294,7 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	bus->sdcnt.fcqueued++;
 
 	/* Priority based enq */
-	spin_lock_bh(&bus->txqlock);
+	spin_lock_irqsave(&bus->txqlock, flags);
 	if (!brcmf_c_prec_enq(bus->sdiodev->dev, &bus->txq, pkt, prec)) {
 		skb_pull(pkt, SDPCM_HDRLEN);
 		brcmf_txcomplete(bus->sdiodev->dev, pkt, false);
@@ -2307,7 +2308,7 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 		bus->txoff = true;
 		brcmf_txflowblock(bus->sdiodev->dev, true);
 	}
-	spin_unlock_bh(&bus->txqlock);
+	spin_unlock_irqrestore(&bus->txqlock, flags);
 
 #ifdef DEBUG
 	if (pktq_plen(&bus->txq, prec) > qcount[prec])
-- 
1.8.1.3


