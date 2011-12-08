Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1485 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab1LHXHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:07 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/23] brcm80211: fmac: fix firmware shared structures
 version
Date: Thu, 8 Dec 2011 15:06:38 -0800
Message-ID: <1323385619-7454-3-git-send-email-frankyl@broadcom.com> (sfid-20111209_000712_530474_10F9D18A)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some shared structures in fullmac have a wrong combination of
version number and declarations. This patch fixes it by upgrading
them to the latest version. This allows brcmfmac to support new
firmwares with new features.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h     |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index b68d136..ed60f4d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -87,7 +87,7 @@
 #define TOE_TX_CSUM_OL		0x00000001
 #define TOE_RX_CSUM_OL		0x00000002
 
-#define	BRCMF_BSS_INFO_VERSION	108 /* curr ver of brcmf_bss_info_le struct */
+#define	BRCMF_BSS_INFO_VERSION	109 /* curr ver of brcmf_bss_info_le struct */
 
 /* size of brcmf_scan_params not including variable length array */
 #define BRCMF_SCAN_PARAMS_FIXED_SIZE 64
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index a527d5d..ebd53aa 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -58,7 +58,7 @@ struct brcmf_proto_cdc_dcmd {
  * Used on data packets to convey priority across USB.
  */
 #define	BDC_HEADER_LEN		4
-#define BDC_PROTO_VER		1	/* Protocol version */
+#define BDC_PROTO_VER		2	/* Protocol version */
 #define BDC_FLAG_VER_MASK	0xf0	/* Protocol version mask */
 #define BDC_FLAG_VER_SHIFT	4	/* Protocol version shift */
 #define BDC_FLAG_SUM_GOOD	0x04	/* Good RX checksums */
@@ -77,7 +77,7 @@ struct brcmf_proto_bdc_header {
 	u8 flags;
 	u8 priority;	/* 802.1d Priority, 4:7 flow control info for usb */
 	u8 flags2;
-	u8 rssi;
+	u8 data_offset;
 };
 
 
@@ -372,7 +372,7 @@ void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
 
 	h->priority = (pktbuf->priority & BDC_PRIORITY_MASK);
 	h->flags2 = 0;
-	h->rssi = 0;
+	h->data_offset = 0;
 	BDC_SET_IF_IDX(h, ifidx);
 }
 
-- 
1.7.5.4


