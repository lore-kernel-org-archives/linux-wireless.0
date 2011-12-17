Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2355 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760961Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 28/30] brcm80211: fmac: move idle macros to dhd_sdio.c
Date: Fri, 16 Dec 2011 18:37:18 -0800
Message-ID: <1324089440-8957-29-git-send-email-frankyl@broadcom.com> (sfid-20111217_035946_098583_78A4DEE8)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The idle macros are only used by dhd_sdio.c. It's more appropriate
to place them in dhd_sdio.c instead of dhd.h.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    6 ------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index a828d82..e58ea40 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -667,10 +667,4 @@ extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
 #define BRCMF_DCMD_MEDLEN	1536	/* "med" cmd buffer required */
 #define	BRCMF_DCMD_MAXLEN	8192	/* max length cmd buffer required */
 
-/* Enter idle immediately (no timeout) */
-#define BRCMF_IDLE_IMMEDIATE	(-1)
-#define BRCMF_IDLE_ACTIVE	0	/* Do not request any SD clock change
-				 when idle */
-#define BRCMF_IDLE_INTERVAL	1
-
 #endif				/* _BRCMF_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 800007f..a8e7ca5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -314,6 +314,12 @@ struct rte_console {
 MODULE_FIRMWARE(BRCMFMAC_FW_NAME);
 MODULE_FIRMWARE(BRCMFMAC_NV_NAME);
 
+#define BRCMF_IDLE_IMMEDIATE	(-1)	/* Enter idle immediately */
+#define BRCMF_IDLE_ACTIVE	0	/* Do not request any SD clock change
+					 * when idle
+					 */
+#define BRCMF_IDLE_INTERVAL	1
+
 /*
  * Conversion of 802.1D priority to precedence level
  */
-- 
1.7.5.4


