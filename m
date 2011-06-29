Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4628 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757866Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 088/119] staging: brcm80211: remove unused macro
 definitions from dhd.h
Date: Wed, 29 Jun 2011 16:47:52 -0700
Message-ID: <1309391303-22741-89-git-send-email-frankyl@broadcom.com> (sfid-20110630_014942_122441_7D453AB4)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Several unused macro definitions have been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 9b1a7f4..77b381c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -624,13 +624,8 @@ extern atomic_t brcmf_mmc_suspend;
 		} \
 	}	while (0)
 #define BRCMF_PM_RESUME_WAIT(a)	_BRCMF_PM_RESUME_WAIT(a, 30)
-#define DHD_PM_RESUME_WAIT_FOREVER(a)	_BRCMF_PM_RESUME_WAIT(a, ~0)
 #define BRCMF_PM_RESUME_RETURN_ERROR(a)	\
 	do { if (atomic_read(&brcmf_mmc_suspend)) return a; } while (0)
-#define DHD_PM_RESUME_RETURN	do { \
-	if (atomic_read(&brcmf_mmc_suspend)) \
-		return; \
-	} while (0)
 
 #define BRCMF_SPINWAIT_SLEEP_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
 #define BRCMF_SPINWAIT_SLEEP(a, exp, us) do { \
@@ -645,9 +640,7 @@ extern atomic_t brcmf_mmc_suspend;
 
 #define BRCMF_PM_RESUME_WAIT_INIT(a)
 #define BRCMF_PM_RESUME_WAIT(a)
-#define DHD_PM_RESUME_WAIT_FOREVER(a)
 #define BRCMF_PM_RESUME_RETURN_ERROR(a)
-#define DHD_PM_RESUME_RETURN
 
 #define BRCMF_SPINWAIT_SLEEP_INIT(a)
 #define BRCMF_SPINWAIT_SLEEP(a, exp, us)  do { \
@@ -865,9 +858,7 @@ typedef struct dhd_ioctl {
 
 /* bump this number if you change the ioctl interface */
 #define BRCMF_IOCTL_VERSION	1
-
 #define	BRCMF_IOCTL_MAXLEN	8192	/* max length ioctl buffer required */
-#define	DHD_IOCTL_SMLEN	256	/* "small" length ioctl buffer required */
 
 /* common ioctl definitions */
 #define BRCMF_GET_MAGIC				0
@@ -885,7 +876,6 @@ typedef struct dhd_ioctl {
 #define BRCMF_HDRS_VAL	0x0040
 #define BRCMF_BYTES_VAL	0x0080
 #define BRCMF_INTR_VAL	0x0100
-#define DHD_LOG_VAL	0x0200
 #define BRCMF_GLOM_VAL	0x0400
 #define BRCMF_EVENT_VAL	0x0800
 #define BRCMF_BTA_VAL	0x1000
@@ -926,7 +916,5 @@ typedef struct brcmf_pktgen {
 	 when idle */
 #define BRCMF_IDLE_ACTIVE	0	/* Do not request any SD clock change
 				 when idle */
-#define DHD_IDLE_STOP   (-1)	/* Request SD clock be stopped
-				 (and use SD1 mode) */
 
 #endif				/* _dhd_h_ */
-- 
1.7.1


