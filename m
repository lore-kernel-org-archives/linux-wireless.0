Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4846 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759581Ab1KWBWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:15 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 20/24] brcm80211: fmac: change function bus_txctl
 parameter
Date: Tue, 22 Nov 2011 17:21:55 -0800
Message-ID: <1322011319-24863-21-git-send-email-frankyl@broadcom.com> (sfid-20111123_022242_017294_D06F9453)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change paramter to device pointer for bus layer interface function
brcmf_sdbrcm_bus_txctl. This is part of the fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 ++++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 44f46d1..be20e7d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -43,7 +43,7 @@ extern int brcmf_sdbrcm_bus_txdata(struct brcmf_sdio *bus, struct sk_buff *txp);
  * Expects caller to enforce a single outstanding transaction.
  */
 extern int
-brcmf_sdbrcm_bus_txctl(struct brcmf_sdio *bus, unsigned char *msg, uint msglen);
+brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen);
 
 extern int
 brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 5ab8671..a527d5d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -116,7 +116,7 @@ static int brcmf_proto_cdc_msg(struct brcmf_pub *drvr)
 		len = CDC_MAX_MSG_SIZE;
 
 	/* Send request */
-	return brcmf_sdbrcm_bus_txctl(drvr->bus, (unsigned char *)&prot->msg,
+	return brcmf_sdbrcm_bus_txctl(drvr->dev, (unsigned char *)&prot->msg,
 				      len);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index e13c9e9..b62dc98 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2797,7 +2797,7 @@ static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 }
 
 int
-brcmf_sdbrcm_bus_txctl(struct brcmf_sdio *bus, unsigned char *msg, uint msglen)
+brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 {
 	u8 *frame;
 	u16 len;
@@ -2805,6 +2805,9 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_sdio *bus, unsigned char *msg, uint msglen)
 	uint retries = 0;
 	u8 doff = 0;
 	int ret = -1;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
+	struct brcmf_sdio *bus = sdiodev->bus;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-- 
1.7.5.4


