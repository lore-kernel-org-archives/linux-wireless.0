Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1910 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1F2Xsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:33 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 006/119] staging: brcm80211: remove unused sdtxlock from
 fullmac
Date: Wed, 29 Jun 2011 16:46:30 -0700
Message-ID: <1309391303-22741-7-git-send-email-frankyl@broadcom.com> (sfid-20110630_014837_429595_406D0D96)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unused sdtx lock functions are removed from dhd_linux.c

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h       |    2 --
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   10 ----------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 1fc5202..4d92d69 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -988,8 +988,6 @@ extern int write_to_file(dhd_pub_t *dhd, u8 *buf, int size);
 #if defined(OOB_INTR_ONLY)
 extern int dhd_customer_oob_irq_map(unsigned long *irq_flags_ptr);
 #endif				/* defined(OOB_INTR_ONLY) */
-extern void dhd_os_sdtxlock(dhd_pub_t *pub);
-extern void dhd_os_sdtxunlock(dhd_pub_t *pub);
 
 int setScheduler(struct task_struct *p, int policy, struct sched_param *param);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 9c9b8ba..d7f7449 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -2603,16 +2603,6 @@ void dhd_os_sdunlock_rxq(dhd_pub_t *pub)
 {
 }
 
-void dhd_os_sdtxlock(dhd_pub_t *pub)
-{
-	dhd_os_sdlock(pub);
-}
-
-void dhd_os_sdtxunlock(dhd_pub_t *pub)
-{
-	dhd_os_sdunlock(pub);
-}
-
 static int
 dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 		  wl_event_msg_t *event, void **data)
-- 
1.7.1


