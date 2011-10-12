Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4323 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab1JLSvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 18/22] brcm80211: moved function brcmu_parse_tlvs
Date: Wed, 12 Oct 2011 20:51:28 +0200
Message-ID: <1318445492-24207-19-git-send-email-arend@broadcom.com> (sfid-20111012_205152_941190_73280814)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Moved the brcmu_parse_tlvs function and brcmu_tlv structure into
the only file using them. Names were adjusted accordingly.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   39 +++++++++++++++++++-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   30 ---------------
 .../net/wireless/brcm80211/include/brcmu_utils.h   |   10 -----
 3 files changed, 37 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index db9176d..857b328 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -247,6 +247,13 @@ static const u32 __wl_cipher_suites[] = {
 	WLAN_CIPHER_SUITE_AES_CMAC,
 };
 
+/* tag_ID/length/value_buffer tuple */
+struct brcmf_tlv {
+	u8 id;
+	u8 len;
+	u8 data[1];
+};
+
 /* Quarter dBm units to mW
  * Table starts at QDBM_OFFSET, so the first entry is mW for qdBm=153
  * Table is offset so the last entry is largest mW value that fits in
@@ -2151,11 +2158,39 @@ static bool brcmf_is_ibssmode(struct brcmf_cfg80211_priv *cfg_priv)
 	return cfg_priv->conf->mode == WL_MODE_IBSS;
 }
 
+/*
+ * Traverse a string of 1-byte tag/1-byte length/variable-length value
+ * triples, returning a pointer to the substring whose first element
+ * matches tag
+ */
+static struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key)
+{
+	struct brcmf_tlv *elt;
+	int totlen;
+
+	elt = (struct brcmf_tlv *) buf;
+	totlen = buflen;
+
+	/* find tagged parameter */
+	while (totlen >= 2) {
+		int len = elt->len;
+
+		/* validate remaining totlen */
+		if ((elt->id == key) && (totlen >= (len + 2)))
+			return elt;
+
+		elt = (struct brcmf_tlv *) ((u8 *) elt + (len + 2));
+		totlen -= (len + 2);
+	}
+
+	return NULL;
+}
+
 static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct brcmf_bss_info *bi;
 	struct brcmf_ssid *ssid;
-	struct brcmu_tlv *tim;
+	struct brcmf_tlv *tim;
 	u16 beacon_interval;
 	u8 dtim_period;
 	size_t ie_len;
@@ -2185,7 +2220,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 	ie_len = le32_to_cpu(bi->ie_length);
 	beacon_interval = le16_to_cpu(bi->beacon_period);
 
-	tim = brcmu_parse_tlvs(ie, ie_len, WLAN_EID_TIM);
+	tim = brcmf_parse_tlvs(ie, ie_len, WLAN_EID_TIM);
 	if (tim)
 		dtim_period = tim->data[1];
 	else {
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index 28480e7..2d903ba 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -365,36 +365,6 @@ void brcmu_prpkt(const char *msg, struct sk_buff *p0)
 EXPORT_SYMBOL(brcmu_prpkt);
 #endif				/* defined(BCMDBG) */
 
-/*
- * Traverse a string of 1-byte tag/1-byte length/variable-length value
- * triples, returning a pointer to the substring whose first element
- * matches tag
- */
-struct brcmu_tlv *brcmu_parse_tlvs(void *buf, int buflen, uint key)
-{
-	struct brcmu_tlv *elt;
-	int totlen;
-
-	elt = (struct brcmu_tlv *) buf;
-	totlen = buflen;
-
-	/* find tagged parameter */
-	while (totlen >= 2) {
-		int len = elt->len;
-
-		/* validate remaining totlen */
-		if ((elt->id == key) && (totlen >= (len + 2)))
-			return elt;
-
-		elt = (struct brcmu_tlv *) ((u8 *) elt + (len + 2));
-		totlen -= (len + 2);
-	}
-
-	return NULL;
-}
-EXPORT_SYMBOL(brcmu_parse_tlvs);
-
-
 #if defined(BCMDBG)
 int
 brcmu_format_flags(const struct brcmu_bit_desc *bd, u32 flags, char *buf,
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index e53883c..c19490c 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -192,13 +192,6 @@ struct brcmu_bit_desc {
 	const char *name;
 };
 
-/* tag_ID/length/value_buffer tuple */
-struct brcmu_tlv {
-	u8 id;
-	u8 len;
-	u8 data[1];
-};
-
 /* externs */
 /* format/print */
 #if defined(BCMDBG)
@@ -207,9 +200,6 @@ extern int brcmu_format_flags(const struct brcmu_bit_desc *bd, u32 flags,
 extern int brcmu_format_hex(char *str, const void *bytes, int len);
 #endif
 
-extern struct brcmu_tlv *brcmu_parse_tlvs(void *buf, int buflen,
-					  uint key);
-
 extern uint brcmu_mkiovar(char *name, char *data, uint datalen,
 			  char *buf, uint len);
 
-- 
1.7.4.1


