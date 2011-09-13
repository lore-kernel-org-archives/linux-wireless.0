Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2859 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab1IMHuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:22 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/17] staging: brcm80211: remove devpath related nvram
 variable lookup
Date: Tue, 13 Sep 2011 09:49:50 +0200
Message-ID: <1315900197-7260-11-git-send-email-rvossen@broadcom.com> (sfid-20110913_095041_395206_0E89D801)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The lookup function used for the devpath related functions did
not provide a variable table so the lookup would always fail. As
this makes the functions pretty useless these have been removed.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |   62 +-------------------------
 drivers/staging/brcm80211/brcmsmac/aiutils.h |    5 --
 2 files changed, 2 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 9510d83..b7b0bdf 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1018,17 +1018,9 @@ static __used void ai_nvram_process(struct si_info *sii, char *pvars)
 
 	/* do a pci config read to get subsystem id and subvendor id */
 	pci_read_config_dword(sii->pbus, PCI_SUBSYSTEM_VENDOR_ID, &w);
-	/* Let nvram variables override subsystem Vend/ID */
-	sii->pub.boardvendor = (u16)ai_getdevpathintvar(&sii->pub,
-							"boardvendor");
-	if (sii->pub.boardvendor == 0)
-		sii->pub.boardvendor = w & 0xffff;
-
-	sii->pub.boardtype = (u16)ai_getdevpathintvar(&sii->pub,
-		"boardtype");
-	if (sii->pub.boardtype == 0)
-		sii->pub.boardtype = (w >> 16) & 0xffff;
 
+	sii->pub.boardvendor = w & 0xffff;
+	sii->pub.boardtype = (w >> 16) & 0xffff;
 	sii->pub.boardflags = getintvar(pvars, "boardflags");
 }
 
@@ -1864,56 +1856,6 @@ int ai_devpath(struct si_pub *sih, char *path, int size)
 	return 0;
 }
 
-/* Concatenate the dev path with a varname into the given 'var' buffer
- * and return the 'var' pointer. Nothing is done to the arguments if
- * len == 0 or var is NULL, var is still returned. On overflow, the
- * first char will be set to '\0'.
- */
-static char *ai_devpathvar(struct si_pub *sih, char *var, int len,
-			   const char *name)
-{
-	uint path_len;
-
-	if (!var || len <= 0)
-		return var;
-
-	if (ai_devpath(sih, var, len) == 0) {
-		path_len = strlen(var);
-
-		if (strlen(name) + 1 > (uint) (len - path_len))
-			var[0] = '\0';
-		else
-			strncpy(var + path_len, name, len - path_len - 1);
-	}
-
-	return var;
-}
-
-/* Get a variable, but only if it has a devpath prefix */
-char *ai_getdevpathvar(struct si_pub *sih, const char *name)
-{
-	char varname[SI_DEVPATH_BUFSZ + 32];
-
-	ai_devpathvar(sih, varname, sizeof(varname), name);
-
-	return getvar(NULL, varname);
-}
-
-/* Get a variable, but only if it has a devpath prefix */
-int ai_getdevpathintvar(struct si_pub *sih, const char *name)
-{
-	char varname[SI_DEVPATH_BUFSZ + 32];
-
-	ai_devpathvar(sih, varname, sizeof(varname), name);
-
-	return getintvar(NULL, varname);
-}
-
-char *ai_getnvramflvar(struct si_pub *sih, const char *name)
-{
-	return getvar(NULL, name);
-}
-
 bool ai_pci_war16165(struct si_pub *sih)
 {
 	struct si_info *sii;
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 0d4fa85..a776945 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -369,9 +369,6 @@ extern bool ai_is_sprom_available(struct si_pub *sih);
  * Return 0 on success, nonzero otherwise.
  */
 extern int ai_devpath(struct si_pub *sih, char *path, int size);
-/* Read variable with prepending the devpath to the name */
-extern char *ai_getdevpathvar(struct si_pub *sih, const char *name);
-extern int ai_getdevpathintvar(struct si_pub *sih, const char *name);
 
 extern void ai_pci_sleep(struct si_pub *sih);
 extern void ai_pci_down(struct si_pub *sih);
@@ -382,6 +379,4 @@ extern void ai_chipcontrl_epa4331(struct si_pub *sih, bool on);
 /* Enable Ex-PA for 4313 */
 extern void ai_epa_4313war(struct si_pub *sih);
 
-char *ai_getnvramflvar(struct si_pub *sih, const char *name);
-
 #endif				/* _BRCM_AIUTILS_H_ */
-- 
1.7.4.1


