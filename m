Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3758 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab1ILKPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:23 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/20] staging: brcm80211: removed fullmac function
 brcmf_sdcard_iovar_op()
Date: Mon, 12 Sep 2011 12:14:51 +0200
Message-ID: <1315822504-24210-8-git-send-email-rvossen@broadcom.com> (sfid-20110912_121545_255028_47C1CAEC)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_sdcard_iovar_op was only called with iovar "sd_rxchain", and
always returns 'false' as the queried value. Thus, the entire
function, related iovar tables and related functions could be
removed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c     |  115 -----------------------
 drivers/staging/brcm80211/brcmfmac/dhd.h        |    6 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |   14 +--
 drivers/staging/brcm80211/brcmfmac/sdio_host.h  |    5 -
 drivers/staging/brcm80211/brcmsmac/types.h      |   10 ++-
 drivers/staging/brcm80211/brcmutil/utils.c      |   67 -------------
 drivers/staging/brcm80211/include/brcmu_utils.h |   45 ---------
 7 files changed, 12 insertions(+), 250 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 4e8fe4d..26919f1 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -41,121 +41,6 @@
 
 module_param(sd_f2_blocksize, int, 0);
 
-/* IOVar table */
-enum {
-	IOV_MSGLEVEL = 1,
-	IOV_DEVREG,
-	IOV_HCIREGS,
-	IOV_RXCHAIN
-};
-
-static const struct brcmu_iovar sdioh_iovars[] = {
-	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
-	,
-	{"sd_rxchain", IOV_RXCHAIN, 0, IOVT_BOOL, 0}
-	,
-	{NULL, 0, 0, 0, 0}
-};
-
-int
-brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev, const char *name,
-		void *params, int plen, void *arg, int len, bool set)
-{
-	const struct brcmu_iovar *vi = NULL;
-	int bcmerror = 0;
-	int val_size;
-	s32 int_val = 0;
-	bool bool_val;
-	u32 actionid;
-
-	if (name == NULL || len < 0)
-		return -EINVAL;
-
-	/* Set does not take qualifiers */
-	if (set && (params || plen))
-		return -EINVAL;
-
-	/* Get must have return space;*/
-	if (!set && !(arg && len))
-		return -EINVAL;
-
-	brcmf_dbg(TRACE, "Enter (%s %s)\n", set ? "set" : "get", name);
-
-	vi = brcmu_iovar_lookup(sdioh_iovars, name);
-	if (vi == NULL) {
-		bcmerror = -ENOTSUPP;
-		goto exit;
-	}
-
-	bcmerror = brcmu_iovar_lencheck(vi, arg, len, set);
-	if (bcmerror != 0)
-		goto exit;
-
-	/* Set up params so get and set can share the convenience variables */
-	if (params == NULL) {
-		params = arg;
-		plen = len;
-	}
-
-	if (vi->type == IOVT_VOID)
-		val_size = 0;
-	else if (vi->type == IOVT_BUFFER)
-		val_size = len;
-	else
-		val_size = sizeof(int);
-
-	if (plen >= (int)sizeof(int_val))
-		memcpy(&int_val, params, sizeof(int_val));
-
-	bool_val = (int_val != 0) ? true : false;
-
-	actionid = set ? IOV_SVAL(vi->varid) : IOV_GVAL(vi->varid);
-	switch (actionid) {
-	case IOV_GVAL(IOV_RXCHAIN):
-		int_val = false;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_GVAL(IOV_DEVREG):
-		{
-			struct brcmf_sdreg *sd_ptr =
-					(struct brcmf_sdreg *) params;
-			u8 data = 0;
-
-			if (brcmf_sdioh_request_byte(sdiodev, SDIOH_READ,
-					sd_ptr->func, sd_ptr->offset, &data)) {
-				bcmerror = -EIO;
-				break;
-			}
-
-			int_val = (int)data;
-			memcpy(arg, &int_val, sizeof(int_val));
-			break;
-		}
-
-	case IOV_SVAL(IOV_DEVREG):
-		{
-			struct brcmf_sdreg *sd_ptr =
-					(struct brcmf_sdreg *) params;
-			u8 data = (u8) sd_ptr->value;
-
-			if (brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE,
-					sd_ptr->func, sd_ptr->offset, &data)) {
-				bcmerror = -EIO;
-				break;
-			}
-			break;
-		}
-
-	default:
-		bcmerror = -ENOTSUPP;
-		break;
-	}
-exit:
-
-	return bcmerror;
-}
-
 static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 {
 	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index add29c3..b0cfe51 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -88,9 +88,6 @@
 #define TOE_TX_CSUM_OL		0x00000001
 #define TOE_RX_CSUM_OL		0x00000002
 
-/* maximum channels returned by the get valid channels iovar */
-#define WL_NUMCHANNELS		64
-
 #define	BRCMF_BSS_INFO_VERSION	108 /* current ver of brcmf_bss_info struct */
 
 /* size of brcmf_scan_params not including variable length array */
@@ -810,9 +807,6 @@ struct brcmf_c_ioctl {
 
 /* Enter idle immediately (no timeout) */
 #define BRCMF_IDLE_IMMEDIATE	(-1)
-
-/* Values for idleclock iovar: other values are the sd_divisor to use
-	 when idle */
 #define BRCMF_IDLE_ACTIVE	0	/* Do not request any SD clock change
 				 when idle */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 3435124..efff099 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -4196,17 +4196,9 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
 	bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
 	bus->roundup = min(max_roundup, bus->blocksize);
 
-	/* Query if bus module supports packet chaining,
-		 default to use if supported */
-	if (brcmf_sdcard_iovar_op(bus->sdiodev, "sd_rxchain", NULL, 0,
-			    &bus->sd_rxchain, sizeof(s32),
-			    false) != 0)
-		bus->sd_rxchain = false;
-	else
-		brcmf_dbg(INFO, "bus module (through sdiocard API) %s chaining\n",
-			  bus->sd_rxchain ? "supports" : "does not support");
-
-	bus->use_rxchain = (bool) bus->sd_rxchain;
+	/* bus module does not support packet chaining */
+	bus->use_rxchain = false;
+	bus->sd_rxchain = false;
 
 	return true;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index aa177ed..c67e1c8 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -205,11 +205,6 @@ extern int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw,
 /* Issue an abort to the specified function */
 extern int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
 
-/* Miscellaneous knob tweaker. */
-extern int brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev,
-				 const char *name, void *params, int plen,
-				 void *arg, int len, bool set);
-
 /* platform specific/high level functions */
 extern int brcmf_sdio_function_init(void);
 extern int brcmf_sdio_register(void);
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index a3af57c..ed2870b 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -351,7 +351,6 @@ struct brcms_info;
 struct brcms_c_info;
 struct brcms_hardware;
 struct brcms_c_if;
-struct brcmu_iovar;
 struct brcmu_strbuf;
 struct brcms_txq_info;
 struct brcms_band;
@@ -362,6 +361,15 @@ struct d11rxhdr;
 struct brcms_d11rxhdr;
 struct txpwr_limits;
 
+/* iovar structure */
+struct brcmu_iovar {
+	const char *name;	/* name for lookup and display */
+	u16 varid;	/* id for switch */
+	u16 flags;	/* driver-specific flag bits */
+	u16 type;	/* base type of argument */
+	u16 minlen;	/* min length for buffer vars */
+};
+
 /* brcm_msg_level is a bit vector with defs in defs.h */
 extern u32 brcm_msg_level;
 
diff --git a/drivers/staging/brcm80211/brcmutil/utils.c b/drivers/staging/brcm80211/brcmutil/utils.c
index 6280ec1..1fe47fe 100644
--- a/drivers/staging/brcm80211/brcmutil/utils.c
+++ b/drivers/staging/brcm80211/brcmutil/utils.c
@@ -364,73 +364,6 @@ void brcmu_prpkt(const char *msg, struct sk_buff *p0)
 EXPORT_SYMBOL(brcmu_prpkt);
 #endif				/* defined(BCMDBG) */
 
-/* iovar table lookup */
-const struct brcmu_iovar *brcmu_iovar_lookup(const struct brcmu_iovar *table,
-					const char *name)
-{
-	const struct brcmu_iovar *vi;
-	const char *lookup_name;
-
-	/* skip any ':' delimited option prefixes */
-	lookup_name = strrchr(name, ':');
-	if (lookup_name != NULL)
-		lookup_name++;
-	else
-		lookup_name = name;
-
-	for (vi = table; vi->name; vi++) {
-		if (!strcmp(vi->name, lookup_name))
-			return vi;
-	}
-	/* ran to end of table */
-
-	return NULL;		/* var name not found */
-}
-EXPORT_SYMBOL(brcmu_iovar_lookup);
-
-int brcmu_iovar_lencheck(const struct brcmu_iovar *vi, void *arg, int len,
-			 bool set)
-{
-	int bcmerror = 0;
-
-	/* length check on io buf */
-	switch (vi->type) {
-	case IOVT_BOOL:
-	case IOVT_INT8:
-	case IOVT_INT16:
-	case IOVT_INT32:
-	case IOVT_UINT8:
-	case IOVT_UINT16:
-	case IOVT_UINT32:
-		/* all integers are s32 sized args at the ioctl interface */
-		if (len < (int)sizeof(int))
-			bcmerror = -EOVERFLOW;
-		break;
-
-	case IOVT_BUFFER:
-		/* buffer must meet minimum length requirement */
-		if (len < vi->minlen)
-			bcmerror = -EOVERFLOW;
-		break;
-
-	case IOVT_VOID:
-		if (!set)
-			/* Cannot return nil... */
-			bcmerror = -ENOTSUPP;
-		else if (len)
-			/* Set is an action w/o parameters */
-			bcmerror = -ENOBUFS;
-		break;
-
-	default:
-		/* unknown type for length check in iovar info */
-		bcmerror = -ENOTSUPP;
-	}
-
-	return bcmerror;
-}
-EXPORT_SYMBOL(brcmu_iovar_lencheck);
-
 /*
  * Traverse a string of 1-byte tag/1-byte length/variable-length value
  * triples, returning a pointer to the substring whose first element
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index 6339721..cf34bd3 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -198,51 +198,6 @@ extern void brcmu_prpkt(const char *msg, struct sk_buff *p0);
 #define brcmu_prpkt(a, b)
 #endif				/* BCMDBG */
 
-/* Support for sharing code across in-driver iovar implementations.
- * The intent is that a driver use this structure to map iovar names
- * to its (private) iovar identifiers, and the lookup function to
- * find the entry.  Macros are provided to map ids and get/set actions
- * into a single number space for a switch statement.
- */
-
-/* iovar structure */
-struct brcmu_iovar {
-	const char *name;	/* name for lookup and display */
-	u16 varid;	/* id for switch */
-	u16 flags;	/* driver-specific flag bits */
-	u16 type;	/* base type of argument */
-	u16 minlen;	/* min length for buffer vars */
-};
-
-/* varid definitions are per-driver, may use these get/set bits */
-
-/* IOVar action bits for id mapping */
-#define IOV_GET 0		/* Get an iovar */
-#define IOV_SET 1		/* Set an iovar */
-
-/* Varid to actionid mapping */
-#define IOV_GVAL(id)		((id)*2)
-#define IOV_SVAL(id)		(((id)*2)+IOV_SET)
-#define IOV_ISSET(actionid)	((actionid & IOV_SET) == IOV_SET)
-#define IOV_ID(actionid)	(actionid >> 1)
-
-extern const struct
-brcmu_iovar *brcmu_iovar_lookup(const struct brcmu_iovar *table,
-				const char *name);
-extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
-				int len, bool set);
-
-/* Base type definitions */
-#define IOVT_VOID	0	/* no value (implictly set only) */
-#define IOVT_BOOL	1	/* any value ok (zero/nonzero) */
-#define IOVT_INT8	2	/* integer values are range-checked */
-#define IOVT_UINT8	3	/* unsigned int 8 bits */
-#define IOVT_INT16	4	/* int 16 bits */
-#define IOVT_UINT16	5	/* unsigned int 16 bits */
-#define IOVT_INT32	6	/* int 32 bits */
-#define IOVT_UINT32	7	/* unsigned int 32 bits */
-#define IOVT_BUFFER	8	/* buffer is size-checked as per minlen */
-
 /* brcmu_format_flags() bit description structure */
 struct brcmu_bit_desc {
 	u32 bit;
-- 
1.7.4.1


