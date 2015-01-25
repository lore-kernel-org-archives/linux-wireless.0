Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34025 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759948AbbAYTbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:50 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/14] brcmutil: use define for boardrev string function
Date: Sun, 25 Jan 2015 20:31:38 +0100
Message-ID: <1422214303-7816-10-git-send-email-arend@broadcom.com> (sfid-20150125_203227_587813_C5B6D7FB)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introducing a define that the caller of brcmu_boardrev_str() can
use to allocate enough room for buffer passed to the function.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/debug.c      | 2 +-
 drivers/net/wireless/brcm80211/brcmutil/utils.c      | 5 +++--
 drivers/net/wireless/brcm80211/include/brcmu_utils.h | 2 ++
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.c b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
index c9a8b93..7a1fbb2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/debug.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
@@ -78,7 +78,7 @@ int brcms_debugfs_hardware_read(struct seq_file *s, void *data)
 	struct brcms_hardware *hw = drvr->wlc->hw;
 	struct bcma_device *core = hw->d11core;
 	struct bcma_bus *bus = core->bus;
-	char boardrev[10];
+	char boardrev[BRCMU_BOARDREV_LEN];
 
 	seq_printf(s, "chipnum 0x%x\n"
 		   "chiprev 0x%x\n"
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index 906e89d..34937d8 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -267,10 +267,11 @@ char *brcmu_boardrev_str(u32 brev, char *buf)
 	char c;
 
 	if (brev < 0x100) {
-		snprintf(buf, 8, "%d.%d", (brev & 0xf0) >> 4, brev & 0xf);
+		snprintf(buf, BRCMU_BOARDREV_LEN, "%d.%d",
+			 (brev & 0xf0) >> 4, brev & 0xf);
 	} else {
 		c = (brev & 0xf000) == 0x1000 ? 'P' : 'A';
-		snprintf(buf, 8, "%c%03x", c, brev & 0xfff);
+		snprintf(buf, BRCMU_BOARDREV_LEN, "%c%03x", c, brev & 0xfff);
 	}
 	return buf;
 }
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index a043e29..197317b 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -218,6 +218,8 @@ void brcmu_dbg_hex_dump(const void *data, size_t size, const char *fmt, ...)
 }
 #endif
 
+#define BRCMU_BOARDREV_LEN	8
+
 char *brcmu_boardrev_str(u32 brev, char *buf);
 
 #endif				/* _BRCMU_UTILS_H_ */
-- 
1.9.1

