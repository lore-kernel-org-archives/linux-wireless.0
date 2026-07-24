Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAE425782D
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901457; cv=none; b=GXEYfoIHjE2YlEAgl7niwKo6DwH7Xe2ZOF2NZegJvSMXlFE+/TGsHhDEk0YeYQbw/kpxS9XzycI2Z6oym9UakMI1WVOKwkl2yHGrVY2XiuI3Fy6t2V2Z/NkhGo7GGTfRo6DHz9qXzAIFQ9nduAgoJ+0jqFPbKICD6TrmtrEcjbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901457; c=relaxed/simple;
	bh=RjW1NE+yBHX5h0tLUngKE9XoBlZyDN5UkzKH5GcV5jU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sNdQIMWAi4uu95YD+iltTvuquCsJUT81yy1MXE8oL98YbAsTqfDzTr0mAuJq9dkTgNUQFIpczEoTL9CeG6C61dw3lkVnpo3EPZnzIQO5TYUNOMKd+gkupTW6gwMDUKT3nd91fREpn0Ui6rlbgR5GvGeNEneq4gAnFUK2GxlvXsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=dyTSxlY9; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="dyTSxlY9"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODvXgL51179787, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901453; bh=hhA54ykTlB1Vm6y5ZOodfZkz93jlhSjqsnBMlMPZ1mo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=dyTSxlY9l6x0J+SMz/Bb/eDbtWs1Ock64+VMErVP/PFsmLMIkgqCmriZ6VheBi97A
	 QK21325q9UK7bln+pcVmQn0/P+OPnBrfMyON8f5NYScezSTpQZUcIoC2XBLU21qN9J
	 TtPrOOEUCKs+y+5EPQ619QuMUZTxr0aadDOZQM48nuZkLCuq3wMp+dhrQ1njnu+1tp
	 PINkkcO0l/5JtFBw7/qTwv8TZM8Q7yg/1NTT/fAaJzlBWoMn1Z3rL7RDp+qNc7ilBQ
	 +9P++LhbIjBURUIl44RnvYE4RX+VDkbbrFR2x7RxGO86BGeWe0duvQyjOfHAV1DHxt
	 y4WdKL/UVNwNw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODvXgL51179787
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:57:33 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:33 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:57:33 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 10/14] wifi: rtw89: coex: Add BTC report version 8 support for BT sub-reports
Date: Fri, 24 Jul 2026 21:56:36 +0800
Message-ID: <20260724135640.3195044-11-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260724135640.3195044-1-pkshih@realtek.com>
References: <20260724135640.3195044-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

RTL8922A (FW >= 0.35.111) and RTL8922D (FW >= 0.35.94) set fcxbtver,
fcxbtscan and fcxbtafh to 8, but the handler in _chk_btc_report only
had branches for version 1 and 7.  When version 8 arrived pfinfo was
left NULL and pcinfo->req_len was left at zero, so the length check at
validation stage rejected the report and bt->ver_info.fw was never
written, causing BT_FW:0x0 in the BTC dump.

BT-scan and BT-afh version 8 hit the goto err path for the same reason,
making all BT sub-reports silently broken on these chips.

The structural change in version 8 is that the previously reserved
second byte in each struct is now bt_id (0 = BT0, 1 = BT1), allowing
firmware to send separate reports for each Bluetooth device. All three
structs are otherwise layout-compatible with version 7.

Add rtw89_btc_fbtc_btver_v8, rtw89_btc_fbtc_btscan_v8 and
rtw89_btc_fbtc_btafh_v8 structs with the bt_id field, extend the
corresponding unions, add version 8 branches to _chk_btc_report, and
update _update_bt_report to route each report to BT0 or BT1 according
to BT ID.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 52 ++++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw89/core.h | 34 +++++++++++++++
 2 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 5aa06ef430c8..96bb68f09a01 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1529,7 +1529,14 @@ static void _update_bt_report(struct rtw89_dev *rtwdev, u8 rpt_type, u8 *pfinfo)
 
 	switch (rpt_type) {
 	case BTC_RPT_TYPE_BT_VER:
-		if (ver->fcxbtver == 7) {
+		if (ver->fcxbtver == 8) {
+			pver->v8 = *(struct rtw89_btc_fbtc_btver_v8 *)pfinfo;
+			bt = pver->v8.bt_id ? &btc->cx.bt1 : &btc->cx.bt0;
+			bt->ver_info.fw = le32_to_cpu(pver->v8.fw_ver);
+			bt->ver_info.fw_coex = le32_get_bits(pver->v8.coex_ver,
+							     GENMASK(7, 0));
+			bt->feature = le32_to_cpu(pver->v8.feature);
+		} else if (ver->fcxbtver == 7) {
 			pver->v7 = *(struct rtw89_btc_fbtc_btver_v7 *)pfinfo;
 			bt->ver_info.fw = le32_to_cpu(pver->v7.fw_ver);
 			bt->ver_info.fw_coex = le32_get_bits(pver->v7.coex_ver,
@@ -1570,6 +1577,19 @@ static void _update_bt_report(struct rtw89_dev *rtwdev, u8 rpt_type, u8 *pfinfo)
 				    pscan_v7->para[i].intvl == 0)
 					scan_update = false;
 			}
+		} else if (ver->fcxbtscan == 8) {
+			struct rtw89_btc_fbtc_btscan_v8 *pscan_v8 =
+				(struct rtw89_btc_fbtc_btscan_v8 *)pfinfo;
+			struct rtw89_btc_bt_info *tbt =
+				pscan_v8->bt_id ? &btc->cx.bt1 : &btc->cx.bt0;
+
+			for (i = 0; i < CXSCAN_MAX; i++) {
+				tbt->scan_info_v2[i] = pscan_v8->para[i];
+				if ((pscan_v8->type & BIT(i)) &&
+				    pscan_v8->para[i].win == 0 &&
+				    pscan_v8->para[i].intvl == 0)
+					scan_update = false;
+			}
 		}
 		if (scan_update)
 			bt->scan_info_update = 1;
@@ -1597,6 +1617,22 @@ static void _update_bt_report(struct rtw89_dev *rtwdev, u8 rpt_type, u8 *pfinfo)
 				memcpy(&bt_linfo->afh_map_le[0], pafh_v7->afh_le_a, 4);
 				memcpy(&bt_linfo->afh_map_le[4], pafh_v7->afh_le_b, 1);
 			}
+		} else if (ver->fcxbtafh == 8) {
+			struct rtw89_btc_fbtc_btafh_v8 *pafh_v8 =
+				(struct rtw89_btc_fbtc_btafh_v8 *)pfinfo;
+			struct rtw89_btc_bt_info *tbt =
+				pafh_v8->bt_id ? &btc->cx.bt1 : &btc->cx.bt0;
+			struct rtw89_btc_bt_link_info *tbt_linfo = &tbt->link_info;
+
+			if (pafh_v8->map_type & RPT_BT_AFH_SEQ_LEGACY) {
+				memcpy(&tbt_linfo->afh_map[0], pafh_v8->afh_l, 4);
+				memcpy(&tbt_linfo->afh_map[4], pafh_v8->afh_m, 4);
+				memcpy(&tbt_linfo->afh_map[8], pafh_v8->afh_h, 2);
+			}
+			if (pafh_v8->map_type & RPT_BT_AFH_SEQ_LE) {
+				memcpy(&tbt_linfo->afh_map_le[0], pafh_v8->afh_le_a, 4);
+				memcpy(&tbt_linfo->afh_map_le[4], pafh_v8->afh_le_b, 1);
+			}
 		} else if (ver->fcxbtafh == 1) {
 			pafh_v1 = (struct rtw89_btc_fbtc_btafh *)pfinfo;
 			memcpy(&bt_linfo->afh_map[0], pafh_v1->afh_l, 4);
@@ -1882,6 +1918,12 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			pfinfo = &pfwinfo->rpt_fbtc_btver.finfo.v7;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_btver.finfo.v7);
 			fwsubver->fcxbtver = pfwinfo->rpt_fbtc_btver.finfo.v7.fver;
+		} else if (ver->fcxbtver == 8) {
+			pfinfo = &pfwinfo->rpt_fbtc_btver.finfo.v8;
+			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_btver.finfo.v8);
+			fwsubver->fcxbtver = pfwinfo->rpt_fbtc_btver.finfo.v8.fver;
+		} else {
+			goto err;
 		}
 		pcinfo->req_fver = ver->fcxbtver;
 		break;
@@ -1899,6 +1941,10 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			pfinfo = &pfwinfo->rpt_fbtc_btscan.finfo.v7;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_btscan.finfo.v7);
 			fwsubver->fcxbtscan = pfwinfo->rpt_fbtc_btscan.finfo.v7.fver;
+		} else if (ver->fcxbtscan == 8) {
+			pfinfo = &pfwinfo->rpt_fbtc_btscan.finfo.v8;
+			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_btscan.finfo.v8);
+			fwsubver->fcxbtscan = pfwinfo->rpt_fbtc_btscan.finfo.v8.fver;
 		} else {
 			goto err;
 		}
@@ -1918,6 +1964,10 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			pfinfo = &pfwinfo->rpt_fbtc_btafh.finfo.v7;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_btafh.finfo.v7);
 			fwsubver->fcxbtafh = pfwinfo->rpt_fbtc_btafh.finfo.v7.fver;
+		} else if (ver->fcxbtafh == 8) {
+			pfinfo = &pfwinfo->rpt_fbtc_btafh.finfo.v8;
+			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_btafh.finfo.v8);
+			fwsubver->fcxbtafh = pfwinfo->rpt_fbtc_btafh.finfo.v8.fver;
 		} else {
 			goto err;
 		}
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index ba3a9b0d4aa2..aaed155ea423 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -2647,10 +2647,19 @@ struct rtw89_btc_fbtc_btscan_v7 {
 	struct rtw89_btc_bt_scan_info_v2 para[CXSCAN_MAX];
 } __packed;
 
+struct rtw89_btc_fbtc_btscan_v8 {
+	u8 fver; /* btc_ver::fcxbtscan */
+	u8 type;
+	u8 bt_id; /* 0:BT0, 1:BT1 */
+	u8 rsvd1;
+	struct rtw89_btc_bt_scan_info_v2 para[CXSCAN_MAX];
+} __packed;
+
 union rtw89_btc_fbtc_btscan {
 	struct rtw89_btc_fbtc_btscan_v1 v1;
 	struct rtw89_btc_fbtc_btscan_v2 v2;
 	struct rtw89_btc_fbtc_btscan_v7 v7;
+	struct rtw89_btc_fbtc_btscan_v8 v8;
 };
 
 struct rtw89_btc_bt_info {
@@ -3683,9 +3692,21 @@ struct rtw89_btc_fbtc_btver_v7 {
 	__le32 feature;
 } __packed;
 
+struct rtw89_btc_fbtc_btver_v8 {
+	u8 fver;
+	u8 bt_id; /* 0:BT0, 1:BT1 */
+	u8 rsvd1;
+	u8 rsvd2;
+
+	__le32 coex_ver; /*bit[15:8]->shared, bit[7:0]->non-shared */
+	__le32 fw_ver;
+	__le32 feature;
+} __packed;
+
 union rtw89_btc_fbtc_btver {
 	struct rtw89_btc_fbtc_btver_v1 v1;
 	struct rtw89_btc_fbtc_btver_v7 v7;
+	struct rtw89_btc_fbtc_btver_v8 v8;
 } __packed;
 
 struct rtw89_btc_fbtc_btafh {
@@ -3721,6 +3742,18 @@ struct rtw89_btc_fbtc_btafh_v7 {
 	u8 afh_le_b[4];
 } __packed;
 
+struct rtw89_btc_fbtc_btafh_v8 {
+	u8 fver;
+	u8 map_type;
+	u8 bt_id; /* 0:BT0, 1:BT1 */
+	u8 rsvd1;
+	u8 afh_l[4]; /*bit0:2402, bit1:2403.... bit31:2433 */
+	u8 afh_m[4]; /*bit0:2434, bit1:2435.... bit31:2465 */
+	u8 afh_h[4]; /*bit0:2466, bit1:2467.....bit14:2480 */
+	u8 afh_le_a[4];
+	u8 afh_le_b[4];
+} __packed;
+
 struct rtw89_btc_fbtc_btdevinfo {
 	u8 fver; /* btc_ver::fcxbtdevinfo */
 	u8 rsvd;
@@ -4194,6 +4227,7 @@ union rtw89_btc_fbtc_btafh_info {
 	struct rtw89_btc_fbtc_btafh v1;
 	struct rtw89_btc_fbtc_btafh_v2 v2;
 	struct rtw89_btc_fbtc_btafh_v7 v7;
+	struct rtw89_btc_fbtc_btafh_v8 v8;
 };
 
 struct rtw89_btc_report_ctrl_state {
-- 
2.25.1

