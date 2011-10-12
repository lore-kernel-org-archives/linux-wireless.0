Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4993 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/22] brcm80211: moved function brcmu_chipname
Date: Wed, 12 Oct 2011 20:51:27 +0200
Message-ID: <1318445492-24207-18-git-send-email-arend@broadcom.com> (sfid-20111012_205202_048014_C21B390A)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Moved the brcmu_chipname function into the only file using it.
The function name was adjusted accordingly.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   11 ++++++++++-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   10 ----------
 .../net/wireless/brcm80211/include/brcmu_utils.h   |    2 --
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index bd9db48..313b8bf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3992,6 +3992,15 @@ static const struct sdiod_drive_str sdiod_drive_strength_tab3[] = {
 
 #define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
 
+static char *brcmf_chipname(uint chipid, char *buf, uint len)
+{
+	const char *fmt;
+
+	fmt = ((chipid > 0xa000) || (chipid < 0x4000)) ? "%d" : "%x";
+	snprintf(buf, len, fmt, chipid);
+	return buf;
+}
+
 static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
 						   u32 drivestrength) {
 	struct sdiod_drive_str *str_tab = NULL;
@@ -4021,7 +4030,7 @@ static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
 		break;
 	default:
 		brcmf_dbg(ERROR, "No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
-			  brcmu_chipname(bus->ci->chip, chn, 8),
+			  brcmf_chipname(bus->ci->chip, chn, 8),
 			  bus->ci->chiprev, bus->ci->pmurev);
 		break;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index 7f53a70..28480e7 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -470,16 +470,6 @@ int brcmu_format_hex(char *str, const void *bytes, int len)
 EXPORT_SYMBOL(brcmu_format_hex);
 #endif				/* defined(BCMDBG) */
 
-char *brcmu_chipname(uint chipid, char *buf, uint len)
-{
-	const char *fmt;
-
-	fmt = ((chipid > 0xa000) || (chipid < 0x4000)) ? "%d" : "%x";
-	snprintf(buf, len, fmt, chipid);
-	return buf;
-}
-EXPORT_SYMBOL(brcmu_chipname);
-
 uint brcmu_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
 {
 	uint len;
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index d716cd2..e53883c 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -207,8 +207,6 @@ extern int brcmu_format_flags(const struct brcmu_bit_desc *bd, u32 flags,
 extern int brcmu_format_hex(char *str, const void *bytes, int len);
 #endif
 
-extern char *brcmu_chipname(uint chipid, char *buf, uint len);
-
 extern struct brcmu_tlv *brcmu_parse_tlvs(void *buf, int buflen,
 					  uint key);
 
-- 
1.7.4.1


