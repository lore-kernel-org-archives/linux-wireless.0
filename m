Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2275 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758898Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 68/83] staging: brcm80211: remove nvram related source
 files
Date: Wed, 1 Jun 2011 13:45:53 +0200
Message-ID: <1306928768-7501-68-git-send-email-rvossen@broadcom.com> (sfid-20110601_134800_953451_70B5B215)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

nvram.c is intended for devices with configuration stored in flash. This
is not required for the softmac driver nor the fullmac driver so it has
been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/Makefile        |    3 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |    8 +-
 drivers/staging/brcm80211/brcmsmac/bcmnvram.h      |  149 --------------
 drivers/staging/brcm80211/brcmsmac/bcmsrom.c       |  124 +-----------
 .../staging/brcm80211/brcmsmac/brcms_mac80211.c    |   19 --
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |    3 +-
 drivers/staging/brcm80211/brcmsmac/nvram.c         |  215 --------------------
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    3 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c   |    4 +-
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |   44 ++++-
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c       |    3 +-
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |    6 +-
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |    1 -
 16 files changed, 62 insertions(+), 523 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/bcmnvram.h
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/nvram.c

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index c6b5128..1b2afa9 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -50,8 +50,7 @@ BRCMSMAC_OFILES := \
 	bcmotp.o \
 	bcmsrom.o \
 	dma.o \
-	nicpci.o \
-	nvram.o
+	nicpci.o
 
 MODULEPFX := brcmsmac
 
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index b00cda9..bc1c52d 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -28,9 +28,10 @@
 
 /* ********** from siutils.c *********** */
 #include <nicpci.h>
-#include <bcmnvram.h>
 #include <bcmsrom.h>
 #include <wlc_pmu.h>
+#include <wlc_scb.h>
+#include <wlc_pub.h>
 
 /* slow_clk_ctl */
 #define SCC_SS_MASK		0x00000007	/* slow clock source mask */
@@ -985,9 +986,6 @@ static si_info_t *ai_doattach(si_info_t *sii, uint devid,
 		udelay(10);
 	}
 
-	/* Init nvram from flash if it exists */
-	nvram_init();
-
 	/* Init nvram from sprom/otp if they exist */
 	if (srom_var_init
 	    (&sii->pub, bustype, regs, vars, varsz)) {
@@ -1096,8 +1094,6 @@ void ai_detach(struct si_pub *sih)
 				sii->regs[idx] = NULL;
 			}
 
-	nvram_exit();	/* free up nvram buffers */
-
 	if (sih->bustype == PCI_BUS) {
 		if (sii->pch)
 			pcicore_deinit(sii->pch);
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmnvram.h b/drivers/staging/brcm80211/brcmsmac/bcmnvram.h
deleted file mode 100644
index bc62695..0000000
--- a/drivers/staging/brcm80211/brcmsmac/bcmnvram.h
+++ /dev/null
@@ -1,149 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef _bcmnvram_h_
-#define _bcmnvram_h_
-
-#include <bcmdefs.h>
-
-struct nvram_header {
-	u32 magic;
-	u32 len;
-	u32 crc_ver_init;	/* 0:7 crc, 8:15 ver, 16:31 sdram_init */
-	u32 config_refresh;	/* 0:15 sdram_config, 16:31 sdram_refresh */
-	u32 config_ncdl;	/* ncdl values for memc */
-};
-
-/*
- * Initialize NVRAM access. May be unnecessary or undefined on certain
- * platforms.
- */
-extern int nvram_init(void);
-
-/*
- * Append a chunk of nvram variables to the global list
- */
-extern int nvram_append(char *vars, uint varsz);
-
-/*
- * Check for reset button press for restoring factory defaults.
- */
-extern int nvram_reset(void);
-
-/*
- * Disable NVRAM access. May be unnecessary or undefined on certain
- * platforms.
- */
-extern void nvram_exit(void);
-
-/*
- * Get the value of an NVRAM variable. The pointer returned may be
- * invalid after a set.
- * @param	name	name of variable to get
- * @return	value of variable or NULL if undefined
- */
-extern char *nvram_get(const char *name);
-
-/*
- * Get the value of an NVRAM variable.
- * @param	name	name of variable to get
- * @return	value of variable or NUL if undefined
- */
-#define nvram_safe_get(name) (nvram_get(name) ? : "")
-
-/*
- * Match an NVRAM variable.
- * @param	name	name of variable to match
- * @param	match	value to compare against value of variable
- * @return	true if variable is defined and its value is string equal
- *		to match or false otherwise
- */
-static inline int nvram_match(char *name, char *match)
-{
-	const char *value = nvram_get(name);
-	return value && !strcmp(value, match);
-}
-
-/*
- * Inversely match an NVRAM variable.
- * @param	name	name of variable to match
- * @param	match	value to compare against value of variable
- * @return	true if variable is defined and its value is not string
- *		equal to invmatch or false otherwise
- */
-static inline int nvram_invmatch(char *name, char *invmatch)
-{
-	const char *value = nvram_get(name);
-	return value && strcmp(value, invmatch);
-}
-
-/*
- * Set the value of an NVRAM variable. The name and value strings are
- * copied into private storage. Pointers to previously set values
- * may become invalid. The new value may be immediately
- * retrieved but will not be permanently stored until a commit.
- * @param	name	name of variable to set
- * @param	value	value of variable
- * @return	0 on success and errno on failure
- */
-extern int nvram_set(const char *name, const char *value);
-
-/*
- * Unset an NVRAM variable. Pointers to previously set values
- * remain valid until a set.
- * @param	name	name of variable to unset
- * @return	0 on success and errno on failure
- * NOTE: use nvram_commit to commit this change to flash.
- */
-extern int nvram_unset(const char *name);
-
-/*
- * Commit NVRAM variables to permanent storage. All pointers to values
- * may be invalid after a commit.
- * NVRAM values are undefined after a commit.
- * @return	0 on success and errno on failure
- */
-extern int nvram_commit(void);
-
-/*
- * Get all NVRAM variables (format name=value\0 ... \0\0).
- * @param	buf	buffer to store variables
- * @param	count	size of buffer in bytes
- * @return	0 on success and errno on failure
- */
-extern int nvram_getall(char *nvram_buf, int count);
-
-/* variable access */
-extern char *getvar(char *vars, const char *name);
-extern int getintvar(char *vars, const char *name);
-
-/* The NVRAM version number stored as an NVRAM variable */
-#define NVRAM_SOFTWARE_VERSION	"1"
-
-#define NVRAM_MAGIC		0x48534C46	/* 'FLSH' */
-#define NVRAM_CLEAR_MAGIC	0x0
-#define NVRAM_INVALID_MAGIC	0xFFFFFFFF
-#define NVRAM_VERSION		1
-#define NVRAM_HEADER_SIZE	20
-#define NVRAM_SPACE		0x8000
-
-#define NVRAM_MAX_VALUE_LEN 255
-#define NVRAM_MAX_PARAM_LEN 64
-
-#define NVRAM_CRC_START_POSITION	9	/* magic, len, crc8 to be skipped */
-#define NVRAM_CRC_VER_MASK	0xffffff00	/* for crc_ver_init */
-
-#endif				/* _bcmnvram_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
index 70b7ab7..8b22add 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
@@ -28,8 +28,6 @@
 #include <nicpci.h>
 #include <aiutils.h>
 #include <bcmsrom.h>
-
-#include <bcmnvram.h>
 #include <bcmotp.h>
 
 #define SROM_OFFSET(sih) ((sih->ccrev > 31) ? \
@@ -780,12 +778,9 @@ static const sromvar_t perpath_pci_sromvars[] = {
 	{NULL, 0, 0, 0, 0}
 };
 
-static int initvars_srom_si(struct si_pub *sih, void *curmap, char **vars,
-			    uint *count);
 static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, varbuf_t *b);
 static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 			     uint *count);
-static int initvars_flash_si(struct si_pub *sih, char **vars, uint *count);
 static int sprom_read_pci(struct si_pub *sih, u16 *sprom,
 			  uint wordoff, u16 *buf, uint nwords, bool check_crc);
 #if defined(BCMNVRAMR)
@@ -796,8 +791,6 @@ static u16 srom_cc_cmd(struct si_pub *sih, void *ccregs, u32 cmd,
 
 static int initvars_table(char *start, char *end,
 			  char **vars, uint *count);
-static int initvars_flash(struct si_pub *sih, char **vp,
-			  uint len);
 
 /* Initialization of varbuf structure */
 static void varbuf_init(varbuf_t *b, char *buf, uint size)
@@ -877,20 +870,9 @@ int srom_var_init(struct si_pub *sih, uint bustype, void *curmap,
 	*vars = NULL;
 	*count = 0;
 
-	switch (bustype) {
-	case SI_BUS:
-	case JTAG_BUS:
-		return initvars_srom_si(sih, curmap, vars, count);
-
-	case PCI_BUS:
-		if (curmap == NULL)
-			return -1;
-
+	if (curmap != NULL && bustype == PCI_BUS)
 		return initvars_srom_pci(sih, curmap, vars, count);
 
-	default:
-		break;
-	}
 	return -1;
 }
 
@@ -1063,87 +1045,6 @@ static int initvars_table(char *start, char *end,
 	return 0;
 }
 
-/*
- * Find variables with <devpath> from flash. 'base' points to the beginning
- * of the table upon enter and to the end of the table upon exit when success.
- * Return 0 on success, nonzero on error.
- */
-static int initvars_flash(struct si_pub *sih, char **base, uint len)
-{
-	char *vp = *base;
-	char *flash;
-	int err;
-	char *s;
-	uint l, dl, copy_len;
-	char devpath[SI_DEVPATH_BUFSZ];
-
-	/* allocate memory and read in flash */
-	flash = kmalloc(NVRAM_SPACE, GFP_ATOMIC);
-	if (!flash)
-		return -ENOMEM;
-	err = nvram_getall(flash, NVRAM_SPACE);
-	if (err)
-		goto exit;
-
-	ai_devpath(sih, devpath, sizeof(devpath));
-
-	/* grab vars with the <devpath> prefix in name */
-	dl = strlen(devpath);
-	for (s = flash; s && *s; s += l + 1) {
-		l = strlen(s);
-
-		/* skip non-matching variable */
-		if (strncmp(s, devpath, dl))
-			continue;
-
-		/* is there enough room to copy? */
-		copy_len = l - dl + 1;
-		if (len < copy_len) {
-			err = -EOVERFLOW;
-			goto exit;
-		}
-
-		/* no prefix, just the name=value */
-		strncpy(vp, &s[dl], copy_len);
-		vp += copy_len;
-		len -= copy_len;
-	}
-
-	/* add null string as terminator */
-	if (len < 1) {
-		err = -EOVERFLOW;
-		goto exit;
-	}
-	*vp++ = '\0';
-
-	*base = vp;
-
- exit:	kfree(flash);
-	return err;
-}
-
-/*
- * Initialize nonvolatile variable table from flash.
- * Return 0 on success, nonzero on error.
- */
-static int initvars_flash_si(struct si_pub *sih, char **vars, uint *count)
-{
-	char *vp, *base;
-	int err;
-
-	base = vp = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
-	if (!vp)
-		return -ENOMEM;
-
-	err = initvars_flash(sih, &vp, MAXSZ_NVRAM_VARS);
-	if (err == 0)
-		err = initvars_table(base, vp, vars, count);
-
-	kfree(base);
-
-	return err;
-}
-
 /* Parse SROM and create name=value pairs. 'srom' points to
  * the SROM word array. 'off' specifies the offset of the
  * first word 'srom' points to, which should be either 0 or
@@ -1405,20 +1306,12 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 		goto errout;
 	}
 
-	base = vp = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
-	if (!vp) {
+	base = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
+	if (!base) {
 		err = -2;
 		goto errout;
 	}
 
-	/* read variables from flash */
-	if (flash) {
-		err = initvars_flash(sih, &vp, MAXSZ_NVRAM_VARS);
-		if (err)
-			goto errout;
-		goto varsdone;
-	}
-
 	varbuf_init(&b, base, MAXSZ_NVRAM_VARS);
 
 	/* parse SROM into name=value pairs. */
@@ -1428,8 +1321,7 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 	vp = b.buf;
 	*vp++ = '\0';
 
- varsdone:
-	err = initvars_table(base, vp, vars, count);
+ 	err = initvars_table(base, vp, vars, count);
 
  errout:
 	if (base)
@@ -1438,11 +1330,3 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 	kfree(srom);
 	return err;
 }
-
-
-static int initvars_srom_si(struct si_pub *sih, void *curmap, char **vars,
-			    uint *varsz)
-{
-	/* Search flash nvram section for srom variables */
-	return initvars_flash_si(sih, vars, varsz);
-}
diff --git a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
index 509cf2b..6449743 100644
--- a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
@@ -28,7 +28,6 @@
 #include <bcmdefs.h>
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
-#include <bcmnvram.h>
 #include <nicpci.h>
 #include "bcmdma.h"
 
@@ -1297,26 +1296,8 @@ static int __init brcms_module_init(void)
 #ifdef BCMDBG
 	if (msglevel != 0xdeadbeef)
 		brcm_msg_level = msglevel;
-	else {
-		char *var = getvar(NULL, "wl_msglevel");
-		if (var) {
-			unsigned long value;
-
-			(void)strict_strtoul(var, 0, &value);
-			brcm_msg_level = value;
-		}
-	}
 	if (phymsglevel != 0xdeadbeef)
 		phyhal_msg_level = phymsglevel;
-	else {
-		char *var = getvar(NULL, "phy_msglevel");
-		if (var) {
-			unsigned long value;
-
-			(void)strict_strtoul(var, 0, &value);
-			phyhal_msg_level = value;
-		}
-	}
 #endif				/* BCMDBG */
 
 	error = pci_register_driver(&brcms_pci_driver);
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 868fba2..6e61ca1 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -19,11 +19,12 @@
 #include <linux/pci.h>
 #include <bcmdefs.h>
 #include <brcmu_utils.h>
-#include <bcmnvram.h>
 #include <aiutils.h>
 #include <bcmsoc.h>
 #include <bcmdevs.h>
 #include <chipcommon.h>
+#include <wlc_scb.h>
+#include <wlc_pub.h>
 #include <nicpci.h>
 
 /* SPROM offsets */
diff --git a/drivers/staging/brcm80211/brcmsmac/nvram.c b/drivers/staging/brcm80211/brcmsmac/nvram.c
deleted file mode 100644
index 3509469..0000000
--- a/drivers/staging/brcm80211/brcmsmac/nvram.c
+++ /dev/null
@@ -1,215 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <bcmdefs.h>
-#include <brcmu_utils.h>
-#include <bcmnvram.h>
-#include <chipcommon.h>
-#include <bcmdevs.h>
-#include <bcmsoc.h>
-
-#define NVR_MSG(x)
-
-typedef struct _vars {
-	struct _vars *next;
-	int bufsz;		/* allocated size */
-	int size;		/* actual vars size */
-	char *vars;
-} vars_t;
-
-#define	VARS_T_OH	sizeof(vars_t)
-
-static vars_t *vars;
-
-#define NVRAM_FILE	1
-
-static char *findvar(char *vars, char *lim, const char *name);
-
-int nvram_init(void)
-{
-
-	/* Make sure we read nvram in flash just once before freeing the memory */
-	if (vars != NULL) {
-		NVR_MSG(("nvram_init: called again without calling nvram_exit()\n"));
-		return 0;
-	}
-	return 0;
-}
-
-int nvram_append(char *varlst, uint varsz)
-{
-	uint bufsz = VARS_T_OH;
-	vars_t *new;
-
-	new = kmalloc(bufsz, GFP_ATOMIC);
-	if (new == NULL)
-		return -ENOMEM;
-
-	new->vars = varlst;
-	new->bufsz = bufsz;
-	new->size = varsz;
-	new->next = vars;
-	vars = new;
-
-	return 0;
-}
-
-void nvram_exit(void)
-{
-	vars_t *this, *next;
-
-	this = vars;
-	if (this)
-		kfree(this->vars);
-
-	while (this) {
-		next = this->next;
-		kfree(this);
-		this = next;
-	}
-	vars = NULL;
-}
-
-static char *findvar(char *vars, char *lim, const char *name)
-{
-	char *s;
-	int len;
-
-	len = strlen(name);
-
-	for (s = vars; (s < lim) && *s;) {
-		if ((memcmp(s, name, len) == 0) && (s[len] == '='))
-			return &s[len + 1];
-
-		while (*s++)
-			;
-	}
-
-	return NULL;
-}
-
-/*
- * Search the name=value vars for a specific one and return its value.
- * Returns NULL if not found.
- */
-char *getvar(char *vars, const char *name)
-{
-	char *s;
-	int len;
-
-	if (!name)
-		return NULL;
-
-	len = strlen(name);
-	if (len == 0)
-		return NULL;
-
-	/* first look in vars[] */
-	for (s = vars; s && *s;) {
-		if ((memcmp(s, name, len) == 0) && (s[len] == '='))
-			return &s[len + 1];
-
-		while (*s++)
-			;
-	}
-	/* then query nvram */
-	return nvram_get(name);
-}
-
-/*
- * Search the vars for a specific one and return its value as
- * an integer. Returns 0 if not found.
- */
-int getintvar(char *vars, const char *name)
-{
-	char *val;
-
-	val = getvar(vars, name);
-	if (val == NULL)
-		return 0;
-
-	return simple_strtoul(val, NULL, 0);
-}
-
-char *nvram_get(const char *name)
-{
-	char *v = NULL;
-	vars_t *cur;
-
-	for (cur = vars; cur; cur = cur->next) {
-		v = findvar(cur->vars, cur->vars + cur->size, name);
-		if (v)
-			break;
-	}
-
-	return v;
-}
-
-int nvram_set(const char *name, const char *value)
-{
-	return 0;
-}
-
-int nvram_unset(const char *name)
-{
-	return 0;
-}
-
-int nvram_reset(void)
-{
-	return 0;
-}
-
-int nvram_commit(void)
-{
-	return 0;
-}
-
-int nvram_getall(char *buf, int count)
-{
-	int len, resid = count;
-	vars_t *this;
-
-	this = vars;
-	while (this) {
-		char *from, *lim, *to;
-		int acc;
-
-		from = this->vars;
-		lim = (char *)(this->vars + this->size);
-		to = buf;
-		acc = 0;
-		while ((from < lim) && (*from)) {
-			len = strlen(from) + 1;
-			if (resid < (acc + len))
-				return -EOVERFLOW;
-			memcpy(to, from, len);
-			acc += len;
-			from += len;
-			to += len;
-		}
-
-		resid -= acc;
-		buf += acc;
-		this = this->next;
-	}
-	if (resid < 1)
-		return -EOVERFLOW;
-	*buf = '\0';
-	return 0;
-}
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 8045c39..b2866de 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -24,7 +24,6 @@
 #include <linux/pci.h>
 
 #include <bcmdefs.h>
-#include <bcmnvram.h>
 #include <chipcommon.h>
 #include <bcmdevs.h>
 #include "bcmdma.h"
@@ -173,7 +172,7 @@ char *phy_getvar(phy_info_t *pi, const char *name)
 			;
 	}
 
-	return nvram_get(name);
+	return NULL;
 }
 
 int phy_getintvar(phy_info_t *pi, const char *name)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
index 1011ca5..a3655ca 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
@@ -20,9 +20,11 @@
 #include <linux/delay.h>
 #include <wlc_cfg.h>
 #include <linux/pci.h>
+#include <brcmu_utils.h>
 #include <aiutils.h>
 #include <wlc_pmu.h>
-#include <bcmnvram.h>
+#include <wlc_scb.h>
+#include <wlc_pub.h>
 
 #include <bcmdevs.h>
 #include "bcmdma.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index 10b9b79..275369a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -22,7 +22,6 @@
 
 #include <bcmdefs.h>
 #include <brcmu_utils.h>
-#include <bcmnvram.h>
 #include <aiutils.h>
 #include <bcmdevs.h>
 #include "bcmdma.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index d23dd11..06d03b6 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -28,7 +28,6 @@
 #include <bcmsrom.h>
 #include <bcmotp.h>
 #include <brcmu_utils.h>
-#include <bcmnvram.h>
 #include <chipcommon.h>
 #include <nicpci.h>
 #include <bcmdma.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index c4fcb44..9897123 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -21,7 +21,6 @@
 
 #include <bcmdefs.h>
 #include <brcmu_utils.h>
-#include <bcmnvram.h>
 #include <aiutils.h>
 #include "bcmdma.h"
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 752f0d1..7c86abc 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -23,7 +23,6 @@
 #include <bcmdevs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
-#include <bcmnvram.h>
 #include <aiutils.h>
 #include <bcmsrom.h>
 #include "bcmdma.h"
@@ -5993,3 +5992,46 @@ int wlc_get_par(struct wlc_info *wlc, enum wlc_par_id par_id, int *ret_int_ptr)
 	}
 	return err;
 }
+
+/*
+ * Search the name=value vars for a specific one and return its value.
+ * Returns NULL if not found.
+ */
+char *getvar(char *vars, const char *name)
+{
+	char *s;
+	int len;
+
+	if (!name)
+		return NULL;
+
+	len = strlen(name);
+	if (len == 0)
+		return NULL;
+
+	/* first look in vars[] */
+	for (s = vars; s && *s;) {
+		if ((memcmp(s, name, len) == 0) && (s[len] == '='))
+			return &s[len + 1];
+
+		while (*s++)
+			;
+	}
+	/* nothing found */
+	return NULL;
+}
+
+/*
+ * Search the vars for a specific one and return its value as
+ * an integer. Returns 0 if not found.
+ */
+int getintvar(char *vars, const char *name)
+{
+	char *val;
+
+	val = getvar(vars, name);
+	if (val == NULL)
+		return 0;
+
+	return simple_strtoul(val, NULL, 0);
+}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index 9a99186..f10a137 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -21,7 +21,8 @@
 #include <bcmdevs.h>
 #include <chipcommon.h>
 #include <brcmu_utils.h>
-#include <bcmnvram.h>
+#include "wlc_scb.h"
+#include "wlc_pub.h"
 #include "wlc_pmu.h"
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 8536efe..a4b2bb9 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -634,8 +634,10 @@ extern void wlc_default_rateset(struct wlc_info *wlc, wlc_rateset_t *rs);
 struct ieee80211_sta;
 extern void wlc_ampdu_flush(struct wlc_info *wlc, struct ieee80211_sta *sta,
 			    u16 tid);
-int wlc_set_par(struct wlc_info *wlc, enum wlc_par_id par_id, int val);
-int wlc_get_par(struct wlc_info *wlc, enum wlc_par_id par_id, int *ret_int_ptr);
+extern int wlc_set_par(struct wlc_info *wlc, enum wlc_par_id par_id, int val);
+extern int wlc_get_par(struct wlc_info *wlc, enum wlc_par_id par_id, int *ret_int_ptr);
+extern char *getvar(char *vars, const char *name);
+extern int getintvar(char *vars, const char *name);
 
 /* wlc_phy.c helper functions */
 extern void wlc_set_ps_ctrl(struct wlc_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index 41c1f96..697da28 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -21,7 +21,6 @@
 #include <brcmu_utils.h>
 #include <aiutils.h>
 #include <brcmu_wifi.h>
-#include <bcmnvram.h>
 #include "bcmdma.h"
 
 #include "wlc_types.h"
-- 
1.7.4.1


