Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3425 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab1EIOd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 6/9] staging: brcm80211: remove unused function
Date: Mon, 9 May 2011 16:33:07 +0200
Message-ID: <1304951590-2411-7-git-send-email-arend@broadcom.com> (sfid-20110509_163610_685062_7032AED0)
In-Reply-To: <1304951590-2411-1-git-send-email-arend@broadcom.com>
References: <1304951590-2411-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

The get_flash_nvram() function is unused, so remove it.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/util/nvram/nvram_ro.c |   29 -----------------------
 1 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/brcm80211/util/nvram/nvram_ro.c b/drivers/staging/brcm80211/util/nvram/nvram_ro.c
index ab31f2d..0e93a55 100644
--- a/drivers/staging/brcm80211/util/nvram/nvram_ro.c
+++ b/drivers/staging/brcm80211/util/nvram/nvram_ro.c
@@ -42,35 +42,6 @@ static vars_t *vars;
 
 static char *findvar(char *vars, char *lim, const char *name);
 
-#if defined(FLASH)
-/* copy flash to ram */
-static void get_flash_nvram(si_t *sih, struct nvram_header *nvh)
-{
-	uint nvs, bufsz;
-	vars_t *new;
-
-	nvs = R_REG(&nvh->len) - sizeof(struct nvram_header);
-	bufsz = nvs + VARS_T_OH;
-
-	new = kmalloc(bufsz, GFP_ATOMIC);
-	if (new == NULL) {
-		NVR_MSG(("Out of memory for flash vars\n"));
-		return;
-	}
-	new->vars = (char *)new + VARS_T_OH;
-
-	new->bufsz = bufsz;
-	new->size = nvs;
-	new->next = vars;
-	vars = new;
-
-	memcpy(new->vars, &nvh[1], nvs);
-
-	NVR_MSG(("%s: flash nvram @ %p, copied %d bytes to %p\n", __func__,
-		 nvh, nvs, new->vars));
-}
-#endif				/* FLASH */
-
 int nvram_init(void *si)
 {
 
-- 
1.7.4.1


