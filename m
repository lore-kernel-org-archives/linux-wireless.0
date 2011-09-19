Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4433 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab1ISV00 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/20] staging: brcm80211: sparse endianness warnings
 for struct sdpcm_shared
Date: Mon, 19 Sep 2011 14:25:52 -0700
Message-ID: <1316467568-27683-5-git-send-email-frankyl@broadcom.com> (sfid-20110919_232630_324498_08C59B07)
In-Reply-To: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Structure that is received from dongle has been annotated.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   31 +++++++++++++++++-------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 57001d4..9d4850d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -530,6 +530,17 @@ struct sdpcm_shared {
 	u8 tag[32];
 };
 
+struct sdpcm_shared_le {
+	__le32 flags;
+	__le32 trap_addr;
+	__le32 assert_exp_addr;
+	__le32 assert_file_addr;
+	__le32 assert_line;
+	__le32 console_addr;	/* Address of struct rte_console */
+	__le32 msgtrace_addr;
+	u8 tag[32];
+};
+
 
 /* misc chip info needed by some of the routines */
 struct chip_info {
@@ -2919,6 +2930,7 @@ brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *sh)
 	u32 addr;
 	__le32 addr_le;
 	int rv;
+	struct sdpcm_shared_le sh_le;
 
 	/* Read last word in memory to determine address of
 			 sdpcm_shared structure */
@@ -2942,19 +2954,20 @@ brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *sh)
 	}
 
 	/* Read rte_shared structure */
-	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *) sh,
-			      sizeof(struct sdpcm_shared));
+	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *) &sh_le,
+			      sizeof(struct sdpcm_shared_le));
 	if (rv < 0)
 		return rv;
 
 	/* Endianness */
-	sh->flags = le32_to_cpu(sh->flags);
-	sh->trap_addr = le32_to_cpu(sh->trap_addr);
-	sh->assert_exp_addr = le32_to_cpu(sh->assert_exp_addr);
-	sh->assert_file_addr = le32_to_cpu(sh->assert_file_addr);
-	sh->assert_line = le32_to_cpu(sh->assert_line);
-	sh->console_addr = le32_to_cpu(sh->console_addr);
-	sh->msgtrace_addr = le32_to_cpu(sh->msgtrace_addr);
+	sh->flags = le32_to_cpu(sh_le.flags);
+	sh->trap_addr = le32_to_cpu(sh_le.trap_addr);
+	sh->assert_exp_addr = le32_to_cpu(sh_le.assert_exp_addr);
+	sh->assert_file_addr = le32_to_cpu(sh_le.assert_file_addr);
+	sh->assert_line = le32_to_cpu(sh_le.assert_line);
+	sh->console_addr = le32_to_cpu(sh_le.console_addr);
+	sh->msgtrace_addr = le32_to_cpu(sh_le.msgtrace_addr);
+	memcpy(sh->tag, sh_le.tag, sizeof(sh->tag));
 
 	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) != SDPCM_SHARED_VERSION) {
 		brcmf_dbg(ERROR, "sdpcm_shared version %d in brcmf is different than sdpcm_shared version %d in dongle\n",
-- 
1.7.1


