Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:6407 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaAFLk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:56 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/15] brcmfmac: Limit control message length from host to device.
Date: Mon, 6 Jan 2014 12:40:38 +0100
Message-ID: <1389008450-28529-4-git-send-email-arend@broadcom.com> (sfid-20140106_124100_696922_4612FB94)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

An control request or set message length is restricted to
ETH frame length for the buffer from host to device. This
is limitation is imposed by the firmware.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c |   10 +++++-----
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h  |    5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index 12c27d1..c229210 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -41,9 +41,6 @@ struct brcmf_proto_bcdc_dcmd {
 	__le32 status;	/* status code returned from the device */
 };
 
-/* Max valid buffer size that can be sent to the dongle */
-#define BCDC_MAX_MSG_SIZE	(ETH_FRAME_LEN+ETH_FCS_LEN)
-
 /* BCDC flag definitions */
 #define BCDC_DCMD_ERROR		0x01		/* 1=cmd failed */
 #define BCDC_DCMD_SET		0x02		/* 0=get, 1=set cmd */
@@ -133,9 +130,12 @@ brcmf_proto_bcdc_msg(struct brcmf_pub *drvr, int ifidx, uint cmd, void *buf,
 	if (buf)
 		memcpy(bcdc->buf, buf, len);
 
+	len += sizeof(*msg);
+	if (len > BRCMF_TX_IOCTL_MAX_MSG_SIZE)
+		len = BRCMF_TX_IOCTL_MAX_MSG_SIZE;
+
 	/* Send request */
-	return brcmf_bus_txctl(drvr->bus_if, (unsigned char *)&bcdc->msg,
-			       len + sizeof(struct brcmf_proto_bcdc_dcmd));
+	return brcmf_bus_txctl(drvr->bus_if, (unsigned char *)&bcdc->msg, len);
 }
 
 static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index e299657..939d6b1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -37,6 +37,11 @@
 #define BRCMF_DCMD_MEDLEN	1536
 #define BRCMF_DCMD_MAXLEN	8192
 
+/* IOCTL from host to device are limited in lenght. A device can only handle
+ * ethernet frame size. This limitation is to be applied by protocol layer.
+ */
+#define BRCMF_TX_IOCTL_MAX_MSG_SIZE	(ETH_FRAME_LEN+ETH_FCS_LEN)
+
 #define BRCMF_AMPDU_RX_REORDER_MAXFLOWS		256
 
 /* Length of firmware version string stored for
-- 
1.7.10.4

