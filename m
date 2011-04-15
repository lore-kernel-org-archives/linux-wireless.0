Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1850 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab1DOJ5h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 05:57:37 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] staging: brcm80211: made fullmac error codes more
 consistent
Date: Fri, 15 Apr 2011 11:57:24 +0200
Message-ID: <1302861444-27530-5-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1302861444-27530-1-git-send-email-rvossen@broadcom.com>
References: <1302861444-27530-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. The code contains several checks on the condition
SDIOH_API_SUCCESS(status). On failure, the error returned depended on the
check, instead of being consistent. This has been corrected.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 7ea19dd..282d711 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -127,7 +127,7 @@ int bcmsdh_intr_enable(void *sdh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_set(bcmsdh->sdioh, true);
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int bcmsdh_intr_disable(void *sdh)
@@ -137,7 +137,7 @@ int bcmsdh_intr_disable(void *sdh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_set(bcmsdh->sdioh, false);
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int bcmsdh_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
@@ -147,7 +147,7 @@ int bcmsdh_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_register(bcmsdh->sdioh, fn, argh);
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int bcmsdh_intr_dereg(void *sdh)
@@ -157,7 +157,7 @@ int bcmsdh_intr_dereg(void *sdh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_deregister(bcmsdh->sdioh);
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 #if defined(DHD_DEBUG)
@@ -330,7 +330,7 @@ int bcmsdh_cis_read(void *sdh, uint func, u8 * cis, uint length)
 		kfree(tmp_buf);
 	}
 
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 static int bcmsdhsdio_set_sbaddr_window(void *sdh, u32 address)
@@ -534,7 +534,7 @@ bcmsdh_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 				      SDIOH_WRITE, fn, addr, width, nbytes, buf,
 				      pkt);
 
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int bcmsdh_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
@@ -554,7 +554,7 @@ int bcmsdh_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 				 (rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
 				 addr, 4, nbytes, buf, NULL);
 
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int bcmsdh_abort(void *sdh, uint fn)
-- 
1.7.1


