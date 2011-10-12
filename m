Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3035 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/22] brcm80211: moved power conversion functions
Date: Wed, 12 Oct 2011 20:51:26 +0200
Message-ID: <1318445492-24207-17-git-send-email-arend@broadcom.com> (sfid-20111012_205207_378503_AB3D33D7)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Moved brcmu_mw_to_qdbm and brcmu_qdbm_to_mw functions into the only
file using them. Names were adjusted accordingly.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   88 +++++++++++++++++++-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   86 -------------------
 .../net/wireless/brcm80211/include/brcmu_utils.h   |    4 -
 3 files changed, 86 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 27a748e..db9176d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -247,6 +247,90 @@ static const u32 __wl_cipher_suites[] = {
 	WLAN_CIPHER_SUITE_AES_CMAC,
 };
 
+/* Quarter dBm units to mW
+ * Table starts at QDBM_OFFSET, so the first entry is mW for qdBm=153
+ * Table is offset so the last entry is largest mW value that fits in
+ * a u16.
+ */
+
+#define QDBM_OFFSET 153		/* Offset for first entry */
+#define QDBM_TABLE_LEN 40	/* Table size */
+
+/* Smallest mW value that will round up to the first table entry, QDBM_OFFSET.
+ * Value is ( mW(QDBM_OFFSET - 1) + mW(QDBM_OFFSET) ) / 2
+ */
+#define QDBM_TABLE_LOW_BOUND 6493	/* Low bound */
+
+/* Largest mW value that will round down to the last table entry,
+ * QDBM_OFFSET + QDBM_TABLE_LEN-1.
+ * Value is ( mW(QDBM_OFFSET + QDBM_TABLE_LEN - 1) +
+ * mW(QDBM_OFFSET + QDBM_TABLE_LEN) ) / 2.
+ */
+#define QDBM_TABLE_HIGH_BOUND 64938	/* High bound */
+
+static const u16 nqdBm_to_mW_map[QDBM_TABLE_LEN] = {
+/* qdBm:	+0	+1	+2	+3	+4	+5	+6	+7 */
+/* 153: */ 6683, 7079, 7499, 7943, 8414, 8913, 9441, 10000,
+/* 161: */ 10593, 11220, 11885, 12589, 13335, 14125, 14962, 15849,
+/* 169: */ 16788, 17783, 18836, 19953, 21135, 22387, 23714, 25119,
+/* 177: */ 26607, 28184, 29854, 31623, 33497, 35481, 37584, 39811,
+/* 185: */ 42170, 44668, 47315, 50119, 53088, 56234, 59566, 63096
+};
+
+static u16 brcmf_qdbm_to_mw(u8 qdbm)
+{
+	uint factor = 1;
+	int idx = qdbm - QDBM_OFFSET;
+
+	if (idx >= QDBM_TABLE_LEN)
+		/* clamp to max u16 mW value */
+		return 0xFFFF;
+
+	/* scale the qdBm index up to the range of the table 0-40
+	 * where an offset of 40 qdBm equals a factor of 10 mW.
+	 */
+	while (idx < 0) {
+		idx += 40;
+		factor *= 10;
+	}
+
+	/* return the mW value scaled down to the correct factor of 10,
+	 * adding in factor/2 to get proper rounding.
+	 */
+	return (nqdBm_to_mW_map[idx] + factor / 2) / factor;
+}
+
+static u8 brcmf_mw_to_qdbm(u16 mw)
+{
+	u8 qdbm;
+	int offset;
+	uint mw_uint = mw;
+	uint boundary;
+
+	/* handle boundary case */
+	if (mw_uint <= 1)
+		return 0;
+
+	offset = QDBM_OFFSET;
+
+	/* move mw into the range of the table */
+	while (mw_uint < QDBM_TABLE_LOW_BOUND) {
+		mw_uint *= 10;
+		offset -= 40;
+	}
+
+	for (qdbm = 0; qdbm < QDBM_TABLE_LEN - 1; qdbm++) {
+		boundary = nqdBm_to_mW_map[qdbm] + (nqdBm_to_mW_map[qdbm + 1] -
+						    nqdBm_to_mW_map[qdbm]) / 2;
+		if (mw_uint < boundary)
+			break;
+	}
+
+	qdbm += (u8) offset;
+
+	return qdbm;
+}
+
 /* function for reading/writing a single u32 from/to the dongle */
 static int
 brcmf_exec_dcmd_u32(struct net_device *ndev, u32 cmd, u32 *par)
@@ -1380,7 +1464,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 	else
 		txpwrmw = (u16) dbm;
 	err = brcmf_dev_intvar_set(ndev, "qtxpower",
-			(s32) (brcmu_mw_to_qdbm(txpwrmw)));
+			(s32) (brcmf_mw_to_qdbm(txpwrmw)));
 	if (err)
 		WL_ERR("qtxpower error (%d)\n", err);
 	cfg_priv->conf->tx_power = dbm;
@@ -1409,7 +1493,7 @@ static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 	}
 
 	result = (u8) (txpwrdbm & ~WL_TXPWR_OVERRIDE);
-	*dbm = (s32) brcmu_qdbm_to_mw(result);
+	*dbm = (s32) brcmf_qdbm_to_mw(result);
 
 done:
 	WL_TRACE("Exit\n");
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index 990cb2e..7f53a70 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -499,89 +499,3 @@ uint brcmu_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
 }
 EXPORT_SYMBOL(brcmu_mkiovar);
 
-/* Quarter dBm units to mW
- * Table starts at QDBM_OFFSET, so the first entry is mW for qdBm=153
- * Table is offset so the last entry is largest mW value that fits in
- * a u16.
- */
-
-#define QDBM_OFFSET 153		/* Offset for first entry */
-#define QDBM_TABLE_LEN 40	/* Table size */
-
-/* Smallest mW value that will round up to the first table entry, QDBM_OFFSET.
- * Value is ( mW(QDBM_OFFSET - 1) + mW(QDBM_OFFSET) ) / 2
- */
-#define QDBM_TABLE_LOW_BOUND 6493	/* Low bound */
-
-/* Largest mW value that will round down to the last table entry,
- * QDBM_OFFSET + QDBM_TABLE_LEN-1.
- * Value is ( mW(QDBM_OFFSET + QDBM_TABLE_LEN - 1) +
- * mW(QDBM_OFFSET + QDBM_TABLE_LEN) ) / 2.
- */
-#define QDBM_TABLE_HIGH_BOUND 64938	/* High bound */
-
-static const u16 nqdBm_to_mW_map[QDBM_TABLE_LEN] = {
-/* qdBm:	+0	+1	+2	+3	+4	+5	+6	+7 */
-/* 153: */ 6683, 7079, 7499, 7943, 8414, 8913, 9441, 10000,
-/* 161: */ 10593, 11220, 11885, 12589, 13335, 14125, 14962, 15849,
-/* 169: */ 16788, 17783, 18836, 19953, 21135, 22387, 23714, 25119,
-/* 177: */ 26607, 28184, 29854, 31623, 33497, 35481, 37584, 39811,
-/* 185: */ 42170, 44668, 47315, 50119, 53088, 56234, 59566, 63096
-};
-
-u16 brcmu_qdbm_to_mw(u8 qdbm)
-{
-	uint factor = 1;
-	int idx = qdbm - QDBM_OFFSET;
-
-	if (idx >= QDBM_TABLE_LEN)
-		/* clamp to max u16 mW value */
-		return 0xFFFF;
-
-	/* scale the qdBm index up to the range of the table 0-40
-	 * where an offset of 40 qdBm equals a factor of 10 mW.
-	 */
-	while (idx < 0) {
-		idx += 40;
-		factor *= 10;
-	}
-
-	/* return the mW value scaled down to the correct factor of 10,
-	 * adding in factor/2 to get proper rounding.
-	 */
-	return (nqdBm_to_mW_map[idx] + factor / 2) / factor;
-}
-EXPORT_SYMBOL(brcmu_qdbm_to_mw);
-
-u8 brcmu_mw_to_qdbm(u16 mw)
-{
-	u8 qdbm;
-	int offset;
-	uint mw_uint = mw;
-	uint boundary;
-
-	/* handle boundary case */
-	if (mw_uint <= 1)
-		return 0;
-
-	offset = QDBM_OFFSET;
-
-	/* move mw into the range of the table */
-	while (mw_uint < QDBM_TABLE_LOW_BOUND) {
-		mw_uint *= 10;
-		offset -= 40;
-	}
-
-	for (qdbm = 0; qdbm < QDBM_TABLE_LEN - 1; qdbm++) {
-		boundary = nqdBm_to_mW_map[qdbm] + (nqdBm_to_mW_map[qdbm + 1] -
-						    nqdBm_to_mW_map[qdbm]) / 2;
-		if (mw_uint < boundary)
-			break;
-	}
-
-	qdbm += (u8) offset;
-
-	return qdbm;
-}
-EXPORT_SYMBOL(brcmu_mw_to_qdbm);
-
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index 96f05d7..d716cd2 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -212,10 +212,6 @@ extern char *brcmu_chipname(uint chipid, char *buf, uint len);
 extern struct brcmu_tlv *brcmu_parse_tlvs(void *buf, int buflen,
 					  uint key);
 
-/* power conversion */
-extern u16 brcmu_qdbm_to_mw(u8 qdbm);
-extern u8 brcmu_mw_to_qdbm(u16 mw);
-
 extern uint brcmu_mkiovar(char *name, char *data, uint datalen,
 			  char *buf, uint len);
 
-- 
1.7.4.1


