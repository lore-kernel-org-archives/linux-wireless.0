Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2352 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760958Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 27/30] brcm80211: fmac: move debug level macros to
 dhd_dbg.h
Date: Fri, 16 Dec 2011 18:37:17 -0800
Message-ID: <1324089440-8957-28-git-send-email-frankyl@broadcom.com> (sfid-20111217_035945_200162_5748A8F2)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Debug message level macros are used for debug purpose. It would be
more appropriate to place them at dhd_dbg.h.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h     |   15 ---------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 45b076e..a828d82 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -667,21 +667,6 @@ extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
 #define BRCMF_DCMD_MEDLEN	1536	/* "med" cmd buffer required */
 #define	BRCMF_DCMD_MAXLEN	8192	/* max length cmd buffer required */
 
-/* message levels */
-#define BRCMF_ERROR_VAL	0x0001
-#define BRCMF_TRACE_VAL	0x0002
-#define BRCMF_INFO_VAL	0x0004
-#define BRCMF_DATA_VAL	0x0008
-#define BRCMF_CTL_VAL	0x0010
-#define BRCMF_TIMER_VAL	0x0020
-#define BRCMF_HDRS_VAL	0x0040
-#define BRCMF_BYTES_VAL	0x0080
-#define BRCMF_INTR_VAL	0x0100
-#define BRCMF_GLOM_VAL	0x0400
-#define BRCMF_EVENT_VAL	0x0800
-#define BRCMF_BTA_VAL	0x1000
-#define BRCMF_ISCAN_VAL 0x2000
-
 /* Enter idle immediately (no timeout) */
 #define BRCMF_IDLE_IMMEDIATE	(-1)
 #define BRCMF_IDLE_ACTIVE	0	/* Do not request any SD clock change
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index 7467922..bb26ee3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -17,6 +17,21 @@
 #ifndef _BRCMF_DBG_H_
 #define _BRCMF_DBG_H_
 
+/* message levels */
+#define BRCMF_ERROR_VAL	0x0001
+#define BRCMF_TRACE_VAL	0x0002
+#define BRCMF_INFO_VAL	0x0004
+#define BRCMF_DATA_VAL	0x0008
+#define BRCMF_CTL_VAL	0x0010
+#define BRCMF_TIMER_VAL	0x0020
+#define BRCMF_HDRS_VAL	0x0040
+#define BRCMF_BYTES_VAL	0x0080
+#define BRCMF_INTR_VAL	0x0100
+#define BRCMF_GLOM_VAL	0x0400
+#define BRCMF_EVENT_VAL	0x0800
+#define BRCMF_BTA_VAL	0x1000
+#define BRCMF_ISCAN_VAL 0x2000
+
 #if defined(BCMDBG)
 
 #define brcmf_dbg(level, fmt, ...)					\
-- 
1.7.5.4


