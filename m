Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2334 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 21/61] staging: brcm80211: made fullmac error codes more
 consistent
Date: Tue, 3 May 2011 11:35:21 +0200
Message-ID: <1304415361-7813-22-git-send-email-arend@broadcom.com> (sfid-20110503_113858_022251_1431A2BB)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. The code contains several checks on the condition
SDIOH_API_SUCCESS(status). On failure, the error returned depended on the
check, instead of being consistent. This has been corrected.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 6ef8808..67a105e 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -126,7 +126,7 @@ int bcmsdh_intr_enable(void *sdh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_set(bcmsdh->sdioh, true);
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int bcmsdh_intr_disable(void *sdh)
@@ -136,7 +136,7 @@ int bcmsdh_intr_disable(void *sdh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_set(bcmsdh->sdioh, false);
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int bcmsdh_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
@@ -146,7 +146,7 @@ int bcmsdh_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_register(bcmsdh->sdioh, fn, argh);
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int bcmsdh_intr_dereg(void *sdh)
@@ -156,7 +156,7 @@ int bcmsdh_intr_dereg(void *sdh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_deregister(bcmsdh->sdioh);
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 #if defined(DHD_DEBUG)
@@ -329,7 +329,7 @@ int bcmsdh_cis_read(void *sdh, uint func, u8 * cis, uint length)
 		kfree(tmp_buf);
 	}
 
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 static int bcmsdhsdio_set_sbaddr_window(void *sdh, u32 address)
@@ -533,7 +533,7 @@ bcmsdh_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 				      SDIOH_WRITE, fn, addr, width, nbytes, buf,
 				      pkt);
 
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int bcmsdh_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
@@ -553,7 +553,7 @@ int bcmsdh_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 				 (rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
 				 addr, 4, nbytes, buf, NULL);
 
-	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int bcmsdh_abort(void *sdh, uint fn)
-- 
1.7.4.1


