Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4582 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529Ab1F2Xs7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:59 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 066/119] staging: brcm80211: remove DHD_SCHED macro
 definition
Date: Wed, 29 Jun 2011 16:47:30 -0700
Message-ID: <1309391303-22741-67-git-send-email-frankyl@broadcom.com> (sfid-20110630_015137_514363_3519B68D)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The fullmac driver now always uses scheduler functionality.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile    |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    4 ----
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 0674a6a..1444fd4 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -19,7 +19,6 @@ ccflags-y :=			\
 	-DBCMSDIO		\
 	-DBRCM_FULLMAC		\
 	-DBRCMF_FIRSTREAD=64	\
-	-DDHD_SCHED		\
 	-DBRCMF_SDALIGN=64	\
 	-DEMBEDDED_PLATFORM	\
 	-DMAX_HDR_READ=64	\
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index c3a0e94..593d180 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1201,14 +1201,12 @@ static int brcmf_watchdog_thread(void *data)
 	/* This thread doesn't need any user-level access,
 	 * so get rid of all our resources
 	 */
-#ifdef DHD_SCHED
 	if (brcmf_watchdog_prio > 0) {
 		struct sched_param param;
 		param.sched_priority = (brcmf_watchdog_prio < MAX_RT_PRIO) ?
 		    brcmf_watchdog_prio : (MAX_RT_PRIO - 1);
 		sched_setscheduler(current, SCHED_FIFO, &param);
 	}
-#endif				/* DHD_SCHED */
 
 	allow_signal(SIGTERM);
 	/* Run until signal received */
@@ -1261,7 +1259,6 @@ static int brcmf_dpc_thread(void *data)
 	/* This thread doesn't need any user-level access,
 	 * so get rid of all our resources
 	 */
-#ifdef DHD_SCHED
 	if (brcmf_dpc_prio > 0) {
 		struct sched_param param;
 		param.sched_priority =
@@ -1269,7 +1266,6 @@ static int brcmf_dpc_thread(void *data)
 		     MAX_RT_PRIO) ? brcmf_dpc_prio : (MAX_RT_PRIO - 1);
 		sched_setscheduler(current, SCHED_FIFO, &param);
 	}
-#endif				/* DHD_SCHED */
 
 	allow_signal(SIGTERM);
 	/* Run until signal received */
-- 
1.7.1


