Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1662 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab1ECJgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 18/61] staging: brcm80211: removed error string function
Date: Tue, 3 May 2011 11:35:18 +0200
Message-ID: <1304415361-7813-19-git-send-email-arend@broadcom.com> (sfid-20110503_113800_736396_AED2B5C9)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Only fullmac used this functionality, in which a broadcom specific error
code was converted to a human readable string. Since this  functionality
is not needed, a function and accompanying data structures have been
removed.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c    |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    2 +-
 drivers/staging/brcm80211/include/bcmutils.h    |   49 -----------------------
 drivers/staging/brcm80211/util/bcmutils.c       |   22 ----------
 4 files changed, 2 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index db8c027..456b5db 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -111,7 +111,7 @@ dhdcdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 	/* Respond "bcmerror" and "bcmerrorstr" with local cache */
 	if (cmd == WLC_GET_VAR && buf) {
 		if (!strcmp((char *)buf, "bcmerrorstr")) {
-			strncpy((char *)buf, bcmerrorstr(dhd->dongle_error),
+			strncpy((char *)buf, "bcm_error",
 				BCME_STRLEN);
 			goto done;
 		} else if (!strcmp((char *)buf, "bcmerror")) {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 9eca208..acdd985 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -225,7 +225,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 		break;
 
 	case IOV_GVAL(IOV_BCMERRORSTR):
-		strncpy((char *)arg, bcmerrorstr(dhd_pub->bcmerror),
+		strncpy((char *)arg, "bcm_error",
 			BCME_STRLEN);
 		((char *)arg)[BCME_STRLEN - 1] = 0x00;
 		break;
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 0bbc7b2..2c37dcd 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -280,53 +280,6 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 #define BCME_NONRESIDENT		42  /* access to nonresident overlay */
 #define BCME_LAST			BCME_NONRESIDENT
 
-/* These are collection of BCME Error strings */
-#define BCMERRSTRINGTABLE {		\
-	"OK",				\
-	"Undefined error",		\
-	"Bad Argument",			\
-	"Bad Option",			\
-	"Not up",			\
-	"Not down",			\
-	"Not AP",			\
-	"Not STA",			\
-	"Bad Key Index",		\
-	"Radio Off",			\
-	"Not band locked",		\
-	"No clock",			\
-	"Bad Rate valueset",		\
-	"Bad Band",			\
-	"Buffer too short",		\
-	"Buffer too long",		\
-	"Busy",				\
-	"Not Associated",		\
-	"Bad SSID len",			\
-	"Out of Range Channel",		\
-	"Bad Channel",			\
-	"Bad Address",			\
-	"Not Enough Resources",		\
-	"Unsupported",			\
-	"Bad length",			\
-	"Not Ready",			\
-	"Not Permitted",		\
-	"No Memory",			\
-	"Associated",			\
-	"Not In Range",			\
-	"Not Found",			\
-	"WME Not Enabled",		\
-	"TSPEC Not Found",		\
-	"ACM Not Supported",		\
-	"Not WME Association",		\
-	"SDIO Bus Error",		\
-	"Dongle Not Accessible",	\
-	"Incorrect version",		\
-	"TX Failure",			\
-	"RX Failure",			\
-	"Device Not Present",		\
-	"NMODE Disabled",		\
-	"Nonresident overlay access", \
-}
-
 #ifndef ABS
 #define	ABS(a)			(((a) < 0) ? -(a) : (a))
 #endif				/* ABS */
@@ -587,8 +540,6 @@ extern void osl_assert(char *exp, char *file, int line);
 
 	extern bcm_tlv_t *bcm_parse_tlvs(void *buf, int buflen,
 						    uint key);
-/* bcmerror */
-	extern const char *bcmerrorstr(int bcmerror);
 
 /* multi-bool data type: set of bools, mbool is true if any is set */
 	typedef u32 mbool;
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index e8aedde..0c40911 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -463,28 +463,6 @@ void prpkt(const char *msg, struct sk_buff *p0)
 }
 #endif				/* defined(BCMDBG) */
 
-static char bcm_undeferrstr[BCME_STRLEN];
-
-static const char *bcmerrorstrtable[] = BCMERRSTRINGTABLE;
-
-/* Convert the error codes into related error strings  */
-const char *bcmerrorstr(int bcmerror)
-{
-	/* check if someone added a bcmerror code but
-		 forgot to add errorstring */
-	ASSERT(ABS(-BCME_LAST) == (ARRAY_SIZE(bcmerrorstrtable) - 1));
-
-	if (bcmerror > 0 || bcmerror < -BCME_LAST) {
-		snprintf(bcm_undeferrstr, BCME_STRLEN, "Undefined error %d",
-			 bcmerror);
-		return bcm_undeferrstr;
-	}
-
-	ASSERT(strlen(bcmerrorstrtable[-bcmerror]) < BCME_STRLEN);
-
-	return bcmerrorstrtable[-bcmerror];
-}
-
 /* iovar table lookup */
 const bcm_iovar_t *bcm_iovar_lookup(const bcm_iovar_t *table, const char *name)
 {
-- 
1.7.4.1


