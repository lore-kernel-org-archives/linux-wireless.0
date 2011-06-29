Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1909 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758013Ab1F2Xsu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:50 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 060/119] staging: brcm80211: replaced more sdio related
 typedefs by structs
Date: Wed, 29 Jun 2011 16:47:24 -0700
Message-ID: <1309391303-22741-61-git-send-email-frankyl@broadcom.com> (sfid-20110630_015112_219554_A88C99C0)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    8 ++-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   54 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/sdiovar.h      |    4 +-
 3 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 4f7d32a..c814701 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -359,7 +359,7 @@ const struct brcmu_iovar sdioh_iovars[] = {
 								 size) */
 	{"sd_ints", IOV_USEINTS, 0, IOVT_BOOL, 0},
 	{"sd_numints", IOV_NUMINTS, 0, IOVT_UINT32, 0},
-	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(sdreg_t)}
+	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
 	,
 	{"sd_rxchain", IOV_RXCHAIN, 0, IOVT_BOOL, 0}
 	,
@@ -498,7 +498,8 @@ brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 
 	case IOV_GVAL(IOV_DEVREG):
 		{
-			sdreg_t *sd_ptr = (sdreg_t *) params;
+			struct brcmf_sdreg *sd_ptr =
+					(struct brcmf_sdreg *) params;
 			u8 data = 0;
 
 			if (brcmf_sdioh_cfg_read
@@ -514,7 +515,8 @@ brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 
 	case IOV_SVAL(IOV_DEVREG):
 		{
-			sdreg_t *sd_ptr = (sdreg_t *) params;
+			struct brcmf_sdreg *sd_ptr =
+					(struct brcmf_sdreg *) params;
 			u8 data = (u8) sd_ptr->value;
 
 			if (brcmf_sdioh_cfg_write
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index c00f0f2..e8cc8d5 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -95,7 +95,7 @@
 
 #define	TRAP_T_SIZE	80
 
-typedef struct _trap_struct {
+struct brcmf_trap {
 	u32 type;
 	u32 epc;
 	u32 cpsr;
@@ -116,20 +116,20 @@ typedef struct _trap_struct {
 	u32 r13;
 	u32 r14;
 	u32 pc;
-} trap_t;
+};
 
 #define CBUF_LEN	(128)
 
 #define LOG_BUF_LEN	1024
 
-typedef struct {
+struct rte_log {
 	u32 buf;		/* Can't be pointer on (64-bit) hosts */
 	uint buf_size;
 	uint idx;
 	char *_buf_compat;	/* Redundant pointer for backward compat. */
-} rte_log_t;
+};
 
-typedef struct {
+struct rte_console {
 	/* Virtual UART
 	 * When there is no UART (e.g. Quickturn),
 	 * the host should write a complete
@@ -148,7 +148,7 @@ typedef struct {
 	 * Output will be lost if the output wraps around faster than the host
 	 * polls.
 	 */
-	rte_log_t log;
+	struct rte_log log;
 
 	/* Console input line buffer
 	 * Characters are read one at a time into cbuf
@@ -158,7 +158,7 @@ typedef struct {
 	 */
 	uint cbuf_idx;
 	char cbuf[CBUF_LEN];
-} rte_cons_t;
+};
 
 #endif				/* DHD_DEBUG */
 #include <chipcommon.h>
@@ -418,14 +418,14 @@ DHD_SPINWAIT_SLEEP_INIT(sdioh_spinwait_sleep);
 
 #ifdef DHD_DEBUG
 /* Device console log buffer state */
-typedef struct dhd_console {
+struct dhd_console {
 	uint count;		/* Poll interval msec counter */
 	uint log_addr;		/* Log struct address (fixed) */
-	rte_log_t log;	/* Log struct (host copy) */
+	struct rte_log log;	/* Log struct (host copy) */
 	uint bufsize;		/* Size of log buffer */
 	u8 *buf;		/* Log buffer (host copy) */
 	uint last;		/* Last buffer read index */
-} dhd_console_t;
+};
 #endif				/* DHD_DEBUG */
 
 struct sdpcm_shared {
@@ -434,7 +434,7 @@ struct sdpcm_shared {
 	u32 assert_exp_addr;
 	u32 assert_file_addr;
 	u32 assert_line;
-	u32 console_addr;	/* Address of rte_cons_t */
+	u32 console_addr;	/* Address of struct rte_console */
 	u32 msgtrace_addr;
 	u8 tag[32];
 };
@@ -523,7 +523,7 @@ typedef struct dhd_bus {
 	uint pollcnt;		/* Count of active polls */
 
 #ifdef DHD_DEBUG
-	dhd_console_t console;	/* Console output polling support */
+	struct dhd_console console;	/* Console output polling support */
 	uint console_addr;	/* Console address from shared struct */
 #endif				/* DHD_DEBUG */
 
@@ -1755,9 +1755,9 @@ const struct brcmu_iovar dhdsdio_iovars[] = {
 	{"sdalign", IOV_SDALIGN, 0, IOVT_BOOL, 0},
 	{"devreset", IOV_DEVRESET, 0, IOVT_BOOL, 0},
 #ifdef DHD_DEBUG
-	{"sdreg", IOV_SDREG, 0, IOVT_BUFFER, sizeof(sdreg_t)}
+	{"sdreg", IOV_SDREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
 	,
-	{"sbreg", IOV_SBREG, 0, IOVT_BUFFER, sizeof(sdreg_t)}
+	{"sbreg", IOV_SBREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
 	,
 	{"sd_cis", IOV_SDCIS, 0, IOVT_BUFFER, DHD_IOCTL_MAXLEN}
 	,
@@ -2090,7 +2090,7 @@ static int brcmf_sdbrcm_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 	char *mbuffer = NULL;
 	uint maxstrlen = 256;
 	char *str = NULL;
-	trap_t tr;
+	struct brcmf_trap tr;
 	struct sdpcm_shared sdpcm_shared;
 	struct brcmu_strbuf strbuf;
 
@@ -2180,7 +2180,7 @@ static int brcmf_sdbrcm_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 		if (sdpcm_shared.flags & SDPCM_SHARED_TRAP) {
 			bcmerror = brcmf_sdbrcm_membytes(bus, false,
 					sdpcm_shared.trap_addr, (u8 *)&tr,
-					sizeof(trap_t));
+					sizeof(struct brcmf_trap));
 			if (bcmerror < 0)
 				goto done;
 
@@ -2263,7 +2263,7 @@ static int brcmf_sdbrcm_mem_dump(dhd_bus_t *bus)
 
 static int brcmf_sdbrcm_readconsole(dhd_bus_t *bus)
 {
-	dhd_console_t *c = &bus->console;
+	struct dhd_console *c = &bus->console;
 	u8 line[CONSOLE_LINE_MAX], ch;
 	u32 n, idx, addr;
 	int rv;
@@ -2273,7 +2273,7 @@ static int brcmf_sdbrcm_readconsole(dhd_bus_t *bus)
 		return 0;
 
 	/* Read console log struct */
-	addr = bus->console_addr + offsetof(rte_cons_t, log);
+	addr = bus->console_addr + offsetof(struct rte_console, log);
 	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *)&c->log,
 				sizeof(c->log));
 	if (rv < 0)
@@ -2608,10 +2608,10 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 #ifdef DHD_DEBUG
 	case IOV_GVAL(IOV_SDREG):
 		{
-			sdreg_t *sd_ptr;
+			struct brcmf_sdreg *sd_ptr;
 			u32 addr, size;
 
-			sd_ptr = (sdreg_t *) params;
+			sd_ptr = (struct brcmf_sdreg *) params;
 
 			addr = (unsigned long)bus->regs + sd_ptr->offset;
 			size = sd_ptr->func;
@@ -2625,10 +2625,10 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_SDREG):
 		{
-			sdreg_t *sd_ptr;
+			struct brcmf_sdreg *sd_ptr;
 			u32 addr, size;
 
-			sd_ptr = (sdreg_t *) params;
+			sd_ptr = (struct brcmf_sdreg *) params;
 
 			addr = (unsigned long)bus->regs + sd_ptr->offset;
 			size = sd_ptr->func;
@@ -2643,7 +2643,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 		 (not SDIO core) */
 	case IOV_GVAL(IOV_SBREG):
 		{
-			sdreg_t sdreg;
+			struct brcmf_sdreg sdreg;
 			u32 addr, size;
 
 			memcpy(&sdreg, params, sizeof(sdreg));
@@ -2660,7 +2660,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_SBREG):
 		{
-			sdreg_t sdreg;
+			struct brcmf_sdreg sdreg;
 			u32 addr, size;
 
 			memcpy(&sdreg, params, sizeof(sdreg));
@@ -5137,20 +5137,20 @@ extern int brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg,
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 	/* Zero cbuf_index */
-	addr = bus->console_addr + offsetof(rte_cons_t, cbuf_idx);
+	addr = bus->console_addr + offsetof(struct rte_console, cbuf_idx);
 	val = cpu_to_le32(0);
 	rv = brcmf_sdbrcm_membytes(bus, true, addr, (u8 *)&val, sizeof(val));
 	if (rv < 0)
 		goto done;
 
 	/* Write message into cbuf */
-	addr = bus->console_addr + offsetof(rte_cons_t, cbuf);
+	addr = bus->console_addr + offsetof(struct rte_console, cbuf);
 	rv = brcmf_sdbrcm_membytes(bus, true, addr, (u8 *)msg, msglen);
 	if (rv < 0)
 		goto done;
 
 	/* Write length into vcons_in */
-	addr = bus->console_addr + offsetof(rte_cons_t, vcons_in);
+	addr = bus->console_addr + offsetof(struct rte_console, vcons_in);
 	val = cpu_to_le32(msglen);
 	rv = brcmf_sdbrcm_membytes(bus, true, addr, (u8 *)&val, sizeof(val));
 	if (rv < 0)
diff --git a/drivers/staging/brcm80211/brcmfmac/sdiovar.h b/drivers/staging/brcm80211/brcmfmac/sdiovar.h
index d1cfa5f..35e913b 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdiovar.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdiovar.h
@@ -17,11 +17,11 @@
 #ifndef _sdiovar_h_
 #define _sdiovar_h_
 
-typedef struct sdreg {
+struct brcmf_sdreg {
 	int func;
 	int offset;
 	int value;
-} sdreg_t;
+};
 
 /* Common msglevel constants */
 #define SDH_ERROR_VAL		0x0001	/* Error */
-- 
1.7.1


