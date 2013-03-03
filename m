Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2016 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab3CCLpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:45:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/13] brcmfmac: increase required skbuff headroom for
 firmware signalling
Date: Sun, 3 Mar 2013 12:45:26 +0100
Message-ID: <1362311132-29561-8-git-send-email-arend@broadcom.com> (sfid-20130303_124615_166378_5CD05A59)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation of firmware signalling feature additional headroom is
needed to accommodate signalling protocol data between host and
firmware.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index a2354d9..81e1be7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -71,13 +71,26 @@ struct brcmf_proto_cdc_dcmd {
 	((hdr)->flags2 = (((hdr)->flags2 & ~BDC_FLAG2_IF_MASK) | \
 	((idx) << BDC_FLAG2_IF_SHIFT)))
 
+/**
+ * struct brcmf_proto_bdc_header - BDC header format
+ *
+ * @flags: flags contain protocol and checksum info.
+ * @priority: 802.1d priority and USB flow control info (bit 4:7).
+ * @flags2: additional flags containing dongle interface index.
+ * @data_offset: start of packet data. header is following by firmware signals.
+ */
 struct brcmf_proto_bdc_header {
 	u8 flags;
-	u8 priority;	/* 802.1d Priority, 4:7 flow control info for usb */
+	u8 priority;
 	u8 flags2;
 	u8 data_offset;
 };
 
+/*
+ * maximum length of firmware signal data between
+ * the BDC header and packet data in the tx path.
+ */
+#define BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES	12
 
 #define RETRIES 2 /* # of retries to retrieve matching dcmd response */
 #define BUS_HEADER_LEN	(16+64)		/* Must be atleast SDPCM_RESERVE
@@ -350,7 +363,7 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 	}
 
 	drvr->prot = cdc;
-	drvr->hdrlen += BDC_HEADER_LEN;
+	drvr->hdrlen += BDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
 	drvr->bus_if->maxctl = BRCMF_DCMD_MAXLEN +
 			sizeof(struct brcmf_proto_cdc_dcmd) + ROUND_UP_MARGIN;
 	return 0;
-- 
1.7.6


