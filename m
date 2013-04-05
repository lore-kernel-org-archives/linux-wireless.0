Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1664 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161614Ab3DEI6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:09 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/16] brcmfmac: read firmware console without trap
 indication
Date: Fri, 5 Apr 2013 10:57:42 +0200
Message-ID: <1365152274-4252-5-git-send-email-arend@broadcom.com> (sfid-20130405_105835_867892_193F1CD3)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

Firmware console output can be read also when there was
no trap indication.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   30 +++++++++-----------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index d2a9d78..ac9f650 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2804,21 +2804,18 @@ static int brcmf_sdio_trap_info(struct brcmf_sdio *bus, struct sdpcm_shared *sh,
 	int error, res;
 	char buf[350];
 	struct brcmf_trap_info tr;
-	int nbytes;
 	loff_t pos = 0;
 
-	if ((sh->flags & SDPCM_SHARED_TRAP) == 0)
+	if ((sh->flags & SDPCM_SHARED_TRAP) == 0) {
+		brcmf_dbg(INFO, "no trap in firmware\n");
 		return 0;
+	}
 
 	error = brcmf_sdbrcm_membytes(bus, false, sh->trap_addr, (u8 *)&tr,
 				      sizeof(struct brcmf_trap_info));
 	if (error < 0)
 		return error;
 
-	nbytes = brcmf_sdio_dump_console(bus, sh, data, count);
-	if (nbytes < 0)
-		return nbytes;
-
 	res = scnprintf(buf, sizeof(buf),
 			"dongle trap info: type 0x%x @ epc 0x%08x\n"
 			"  cpsr 0x%08x spsr 0x%08x sp 0x%08x\n"
@@ -2834,12 +2831,7 @@ static int brcmf_sdio_trap_info(struct brcmf_sdio *bus, struct sdpcm_shared *sh,
 			le32_to_cpu(tr.r4), le32_to_cpu(tr.r5),
 			le32_to_cpu(tr.r6), le32_to_cpu(tr.r7));
 
-	error = simple_read_from_buffer(data+nbytes, count, &pos, buf, res);
-	if (error < 0)
-		return error;
-
-	nbytes += error;
-	return nbytes;
+	return simple_read_from_buffer(data, count, &pos, buf, res);
 }
 
 static int brcmf_sdio_assert_info(struct brcmf_sdio *bus,
@@ -2921,14 +2913,20 @@ static int brcmf_sdbrcm_died_dump(struct brcmf_sdio *bus, char __user *data,
 	error = brcmf_sdio_assert_info(bus, &sh, data, count);
 	if (error < 0)
 		goto done;
-
 	nbytes = error;
-	error = brcmf_sdio_trap_info(bus, &sh, data, count);
+
+	error = brcmf_sdio_trap_info(bus, &sh, data+nbytes, count);
 	if (error < 0)
 		goto done;
+	nbytes += error;
+
+	error = brcmf_sdio_dump_console(bus, &sh, data+nbytes, count);
+	if (error < 0)
+		goto done;
+	nbytes += error;
 
-	error += nbytes;
-	*ppos += error;
+	error = nbytes;
+	*ppos += nbytes;
 done:
 	return error;
 }
-- 
1.7.10.4


