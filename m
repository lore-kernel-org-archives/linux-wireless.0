Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3033 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/22] brcm80211: add endian annotation to packet filter
 structures
Date: Wed, 12 Oct 2011 20:51:16 +0200
Message-ID: <1318445492-24207-7-git-send-email-arend@broadcom.com> (sfid-20111012_205211_864218_B61D54F7)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The packet filter structures were byte copied and transferred over the
host bus to the device. As such they are little endian and have been
annotated accordingly.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   22 ++++++------
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   34 ++++++++++---------
 2 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index f58c0eb..951910e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -330,14 +330,14 @@ enum brcmf_bus_state {
  * start matching, the pattern to match, the size of the pattern, and a bitmask
  * that indicates which bits within the pattern should be matched.
  */
-struct brcmf_pkt_filter_pattern {
+struct brcmf_pkt_filter_pattern_le {
 	/*
 	 * Offset within received packet to start pattern matching.
 	 * Offset '0' is the first byte of the ethernet header.
 	 */
-	u32 offset;
+	__le32 offset;
 	/* Size of the pattern.  Bitmask must be the same size.*/
-	u32 size_bytes;
+	__le32 size_bytes;
 	/*
 	 * Variable length mask and pattern data. mask starts at offset 0.
 	 * Pattern immediately follows mask.
@@ -346,19 +346,19 @@ struct brcmf_pkt_filter_pattern {
 };
 
 /* IOVAR "pkt_filter_add" parameter. Used to install packet filters. */
-struct brcmf_pkt_filter {
-	u32 id;		/* Unique filter id, specified by app. */
-	u32 type;		/* Filter type (WL_PKT_FILTER_TYPE_xxx). */
-	u32 negate_match;	/* Negate the result of filter matches */
+struct brcmf_pkt_filter_le {
+	__le32 id;		/* Unique filter id, specified by app. */
+	__le32 type;		/* Filter type (WL_PKT_FILTER_TYPE_xxx). */
+	__le32 negate_match;	/* Negate the result of filter matches */
 	union {			/* Filter definitions */
-		struct brcmf_pkt_filter_pattern pattern; /* Filter pattern */
+		struct brcmf_pkt_filter_pattern_le pattern; /* Filter pattern */
 	} u;
 };
 
 /* IOVAR "pkt_filter_enable" parameter. */
-struct brcmf_pkt_filter_enable {
-	u32 id;		/* Unique filter id */
-	u32 enable;		/* Enable/disable bool */
+struct brcmf_pkt_filter_enable_le {
+	__le32 id;		/* Unique filter id */
+	__le32 enable;		/* Enable/disable bool */
 };
 
 /* BSS info structure
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 4075fd7..a43b3da 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -36,9 +36,9 @@ int brcmf_msg_level;
 
 #define MSGTRACE_VERSION	1
 
-#define BRCMF_PKT_FILTER_FIXED_LEN	offsetof(struct brcmf_pkt_filter, u)
+#define BRCMF_PKT_FILTER_FIXED_LEN	offsetof(struct brcmf_pkt_filter_le, u)
 #define BRCMF_PKT_FILTER_PATTERN_FIXED_LEN	\
-	offsetof(struct brcmf_pkt_filter_pattern, mask_and_pattern)
+	offsetof(struct brcmf_pkt_filter_pattern_le, mask_and_pattern)
 
 #ifdef BCMDBG
 static const char brcmf_version[] =
@@ -558,8 +558,9 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 	char *arg_save = NULL, *arg_org = NULL;
 	int rc;
 	char buf[128];
-	struct brcmf_pkt_filter_enable enable_parm;
-	struct brcmf_pkt_filter_enable *pkt_filterp;
+	struct brcmf_pkt_filter_enable_le enable_parm;
+	struct brcmf_pkt_filter_enable_le *pkt_filterp;
+	__le32 mmode_le;
 
 	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
 	if (!arg_save)
@@ -582,15 +583,15 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 	buf[str_len] = '\0';
 	buf_len = str_len + 1;
 
-	pkt_filterp = (struct brcmf_pkt_filter_enable *) (buf + str_len + 1);
+	pkt_filterp = (struct brcmf_pkt_filter_enable_le *) (buf + str_len + 1);
 
 	/* Parse packet filter id. */
 	enable_parm.id = 0;
 	if (!kstrtoul(argv[i], 0, &res))
-		enable_parm.id = (u32)res;
+		enable_parm.id = cpu_to_le32((u32)res);
 
 	/* Parse enable/disable value. */
-	enable_parm.enable = enable;
+	enable_parm.enable = cpu_to_le32(enable);
 
 	buf_len += sizeof(enable_parm);
 	memcpy((char *)pkt_filterp, &enable_parm, sizeof(enable_parm));
@@ -605,7 +606,8 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 		brcmf_dbg(TRACE, "successfully added pktfilter %s\n", arg);
 
 	/* Contorl the master mode */
-	brcmu_mkiovar("pkt_filter_mode", (char *)&master_mode, 4, buf,
+	mmode_le = cpu_to_le32(master_mode);
+	brcmu_mkiovar("pkt_filter_mode", (char *)&mmode_le, 4, buf,
 		    sizeof(buf));
 	rc = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, buf,
 				       sizeof(buf));
@@ -621,8 +623,8 @@ fail:
 void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 {
 	const char *str;
-	struct brcmf_pkt_filter pkt_filter;
-	struct brcmf_pkt_filter *pkt_filterp;
+	struct brcmf_pkt_filter_le pkt_filter;
+	struct brcmf_pkt_filter_le *pkt_filterp;
 	unsigned long res;
 	int buf_len;
 	int str_len;
@@ -658,12 +660,12 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	str_len = strlen(str);
 	buf_len = str_len + 1;
 
-	pkt_filterp = (struct brcmf_pkt_filter *) (buf + str_len + 1);
+	pkt_filterp = (struct brcmf_pkt_filter_le *) (buf + str_len + 1);
 
 	/* Parse packet filter id. */
 	pkt_filter.id = 0;
 	if (!kstrtoul(argv[i], 0, &res))
-		pkt_filter.id = (u32)res;
+		pkt_filter.id = cpu_to_le32((u32)res);
 
 	if (NULL == argv[++i]) {
 		brcmf_dbg(ERROR, "Polarity not provided\n");
@@ -673,7 +675,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	/* Parse filter polarity. */
 	pkt_filter.negate_match = 0;
 	if (!kstrtoul(argv[i], 0, &res))
-		pkt_filter.negate_match = (u32)res;
+		pkt_filter.negate_match = cpu_to_le32((u32)res);
 
 	if (NULL == argv[++i]) {
 		brcmf_dbg(ERROR, "Filter type not provided\n");
@@ -683,7 +685,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	/* Parse filter type. */
 	pkt_filter.type = 0;
 	if (!kstrtoul(argv[i], 0, &res))
-		pkt_filter.type = (u32)res;
+		pkt_filter.type = cpu_to_le32((u32)res);
 
 	if (NULL == argv[++i]) {
 		brcmf_dbg(ERROR, "Offset not provided\n");
@@ -693,7 +695,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	/* Parse pattern filter offset. */
 	pkt_filter.u.pattern.offset = 0;
 	if (!kstrtoul(argv[i], 0, &res))
-		pkt_filter.u.pattern.offset = (u32)res;
+		pkt_filter.u.pattern.offset = cpu_to_le32((u32)res);
 
 	if (NULL == argv[++i]) {
 		brcmf_dbg(ERROR, "Bitmask not provided\n");
@@ -721,7 +723,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 		goto fail;
 	}
 
-	pkt_filter.u.pattern.size_bytes = mask_size;
+	pkt_filter.u.pattern.size_bytes = cpu_to_le32(mask_size);
 	buf_len += BRCMF_PKT_FILTER_FIXED_LEN;
 	buf_len += (BRCMF_PKT_FILTER_PATTERN_FIXED_LEN + 2 * mask_size);
 
-- 
1.7.4.1


