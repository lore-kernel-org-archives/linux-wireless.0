Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3038 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 21/22] brcm80211: moved function brcmu_format_flags
Date: Wed, 12 Oct 2011 20:51:31 +0200
Message-ID: <1318445492-24207-22-git-send-email-arend@broadcom.com> (sfid-20111012_205214_356011_E2F95F17)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Moved the brcmu_format_flags function and brcmu_bit_desc structure
into smac. Names were adjusted accordingly.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   66 +++++++++++++++++++-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   55 ----------------
 .../net/wireless/brcm80211/include/brcmu_utils.h   |    8 ---
 3 files changed, 64 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index cce6228..510e9bb 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -325,6 +325,12 @@ static u16 frametype(u32 rspec, u8 mimoframe)
  */
 #define SSID_FMT_BUF_LEN	((4 * IEEE80211_MAX_SSID_LEN) + 1)
 
+/* brcmu_format_flags() bit description structure */
+struct brcms_c_bit_desc {
+	u32 bit;
+	const char *name;
+};
+
 /*
  * The following table lists the buffer memory allocated to xmt fifos in HW.
  * the size is in units of 256bytes(one block), total size is HW dependent
@@ -6152,6 +6158,62 @@ void brcms_c_print_txdesc(struct d11txh *txh)
 #endif				/* defined(BCMDBG) */
 
 #if defined(BCMDBG)
+int
+brcms_c_format_flags(const struct brcms_c_bit_desc *bd, u32 flags, char *buf,
+		   int len)
+{
+	int i;
+	char *p = buf;
+	char hexstr[16];
+	int slen = 0, nlen = 0;
+	u32 bit;
+	const char *name;
+
+	if (len < 2 || !buf)
+		return 0;
+
+	buf[0] = '\0';
+
+	for (i = 0; flags != 0; i++) {
+		bit = bd[i].bit;
+		name = bd[i].name;
+		if (bit == 0 && flags != 0) {
+			/* print any unnamed bits */
+			snprintf(hexstr, 16, "0x%X", flags);
+			name = hexstr;
+			flags = 0;	/* exit loop */
+		} else if ((flags & bit) == 0)
+			continue;
+		flags &= ~bit;
+		nlen = strlen(name);
+		slen += nlen;
+		/* count btwn flag space */
+		if (flags != 0)
+			slen += 1;
+		/* need NULL char as well */
+		if (len <= slen)
+			break;
+		/* copy NULL char but don't count it */
+		strncpy(p, name, nlen + 1);
+		p += nlen;
+		/* copy btwn flag space and NULL char */
+		if (flags != 0)
+			p += snprintf(p, 2, " ");
+		len -= slen;
+	}
+
+	/* indicate the str was too short */
+	if (flags != 0) {
+		if (len < 2)
+			p -= 2 - len;	/* overwrite last char */
+		p += snprintf(p, 2, ">");
+	}
+
+	return (int)(p - buf);
+}
+#endif				/* defined(BCMDBG) */
+
+#if defined(BCMDBG)
 void brcms_c_print_rxh(struct d11rxhdr *rxh)
 {
 	u16 len = rxh->RxFrameSize;
@@ -6163,7 +6225,7 @@ void brcms_c_print_rxh(struct d11rxhdr *rxh)
 	u16 macstatus2 = rxh->RxStatus2;
 	char flagstr[64];
 	char lenbuf[20];
-	static const struct brcmu_bit_desc macstat_flags[] = {
+	static const struct brcms_c_bit_desc macstat_flags[] = {
 		{RXS_FCSERR, "FCSErr"},
 		{RXS_RESPFRAMETX, "Reply"},
 		{RXS_PBPRES, "PADDING"},
@@ -6177,7 +6239,7 @@ void brcms_c_print_rxh(struct d11rxhdr *rxh)
 	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, rxh,
 			     sizeof(struct d11rxhdr));
 
-	brcmu_format_flags(macstat_flags, macstatus1, flagstr, 64);
+	brcms_c_format_flags(macstat_flags, macstatus1, flagstr, 64);
 
 	snprintf(lenbuf, sizeof(lenbuf), "0x%x", len);
 
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index d55595a..f27c489 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -366,61 +366,6 @@ EXPORT_SYMBOL(brcmu_prpkt);
 #endif				/* defined(BCMDBG) */
 
 #if defined(BCMDBG)
-int
-brcmu_format_flags(const struct brcmu_bit_desc *bd, u32 flags, char *buf,
-		   int len)
-{
-	int i;
-	char *p = buf;
-	char hexstr[16];
-	int slen = 0, nlen = 0;
-	u32 bit;
-	const char *name;
-
-	if (len < 2 || !buf)
-		return 0;
-
-	buf[0] = '\0';
-
-	for (i = 0; flags != 0; i++) {
-		bit = bd[i].bit;
-		name = bd[i].name;
-		if (bit == 0 && flags != 0) {
-			/* print any unnamed bits */
-			snprintf(hexstr, 16, "0x%X", flags);
-			name = hexstr;
-			flags = 0;	/* exit loop */
-		} else if ((flags & bit) == 0)
-			continue;
-		flags &= ~bit;
-		nlen = strlen(name);
-		slen += nlen;
-		/* count btwn flag space */
-		if (flags != 0)
-			slen += 1;
-		/* need NULL char as well */
-		if (len <= slen)
-			break;
-		/* copy NULL char but don't count it */
-		strncpy(p, name, nlen + 1);
-		p += nlen;
-		/* copy btwn flag space and NULL char */
-		if (flags != 0)
-			p += snprintf(p, 2, " ");
-		len -= slen;
-	}
-
-	/* indicate the str was too short */
-	if (flags != 0) {
-		if (len < 2)
-			p -= 2 - len;	/* overwrite last char */
-		p += snprintf(p, 2, ">");
-	}
-
-	return (int)(p - buf);
-}
-EXPORT_SYMBOL(brcmu_format_flags);
-
 /*
  * print bytes formatted as hex to a string. return the resulting
  * string length
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index f8664b2..7d0f46e 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -186,17 +186,9 @@ extern void brcmu_prpkt(const char *msg, struct sk_buff *p0);
 #define brcmu_prpkt(a, b)
 #endif				/* BCMDBG */
 
-/* brcmu_format_flags() bit description structure */
-struct brcmu_bit_desc {
-	u32 bit;
-	const char *name;
-};
-
 /* externs */
 /* format/print */
 #if defined(BCMDBG)
-extern int brcmu_format_flags(const struct brcmu_bit_desc *bd, u32 flags,
-			      char *buf, int len);
 extern int brcmu_format_hex(char *str, const void *bytes, int len);
 #endif
 
-- 
1.7.4.1


