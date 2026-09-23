Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FBD3E3D91
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147715; cv=none; b=Wqnj5zfzHqqVZvPJDYEw9/dIH8yhAyY0WrDblY7s4DIU/theVigM+1OK9XicpvgxLmL/qrSyk8mIkVSXXcWbjqCsm9EevwFS6PPKQffzUJRoYAFmhJKGuZjvKDGC13wOtkDoAkM06TNcWHzuqdTuxlutOI6LHezMYtCYrOqoPS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147715; c=relaxed/simple;
	bh=BGB3SRS948fNP9PgRVauzPEG78v27euUr/3NbYouzjI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OZJ6sTgdor+8h6i0WRWstcbX/69f9c5o2D1Jdrh1dBGlhJnLqghUQsSz0L+Qp0ACblrS7J8T9nj1BrarkfmiVrnbVHyA95bU70ltkseDrws4pTvw3DuuCNIy9DuCBccA7FZXraQHfZp6gZ60qEmR/CH0V29x3w+0CH/LptDKTFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=m5cp7Sdq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="m5cp7Sdq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7FApC4132904, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790147711; bh=ghGHxYnAY+qwDzg7fl33bEyQVairc7Veh91nQdUZSlM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=m5cp7SdqwkBmuNzwkgKK9dzRVec1DKeFXQXOAwG+xcJ+lmMgXFT3f/iNKNzfT1b3C
	 mBLrwMXmEBXKSEJlApPeDZuZS0rNxtL7WxQyp0K6U1J2W4xUR8/I4uL7yoVVPuEL6p
	 xeyap05Mzzp/0kNu+ySxFyQEWRKhPOK/UXmT6pqii8TOtHzdE/my9NBvZY53BGxbIZ
	 /FGEQ+FtD3NfW9TRfkAyc5QHW3GVQorSMRlVIxdr7JRCjzjjbnqVFDQgPN+XUh+/wH
	 6o8AE3CrmoBFg98raGls1VCBaPz5L/k/8om5T7dMtzj9gh9+x5j9nNCsjcxzms4fn7
	 QVcy97JysoozQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7FApC4132904
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:15:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:15:11 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 15:15:11 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 6/7] wifi: rtw89: coex: offload 8852C IO writes via firmware CMD pack region
Date: Wed, 23 Sep 2026 15:13:53 +0800
Message-ID: <20260923071354.50864-7-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260923071354.50864-1-pkshih@realtek.com>
References: <20260923071354.50864-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

On USB, 8852C is the only chip with .support_fw_cmd_ofld set, which
routes register writes through the FW command offload path via the
transparent io_ops indirection. The coex layer never entered an
rtw89_io_pack() region, so its register writes were always issued
individually instead of being batched to the firmware.

Wrap the RF LUT and GNT write sequences in rtw8852c_btc_init_cfg(),
rtw8852c_btc_wl_s1_standby() and rtw8852c_set_wl_lna2() with
rtw89_io_pack()/rtw89_io_unpack() so that on USB these writes are
enqueued and flushed as a single FW command batch. On PCIe the pack
region is a no-op and raw MMIO proceeds unchanged.

Only write_rf partial-mask, write-only sequences are offloaded, for
which the firmware performs the read-modify-write. Driver-side
same-register read-modify-write helpers and BB phy_write32 flows are
kept outside the pack region to avoid the offload full-dword
overwrite hazard.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8852c.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c.c b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
index c68959b63a01..7649706b67e6 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
@@ -2706,6 +2706,8 @@ static void rtw8852c_btc_init_cfg(struct rtw89_dev *rtwdev)
 	chip->ops->btc_set_wl_pri(rtwdev, BTC_PRI_MASK_TX_RESP, true);
 	chip->ops->btc_set_wl_pri(rtwdev, BTC_PRI_MASK_BEACON, true);
 
+	rtw89_io_pack(rtwdev);
+
 	/* set rf gnt debug off */
 	rtw89_write_rf(rtwdev, RF_PATH_A, RR_WLSEL, RFREG_MASK, 0x0);
 	rtw89_write_rf(rtwdev, RF_PATH_B, RR_WLSEL, RFREG_MASK, 0x0);
@@ -2733,6 +2735,8 @@ static void rtw8852c_btc_init_cfg(struct rtw89_dev *rtwdev)
 	rtw89_write32_set(rtwdev,
 			  R_AX_BT_CNT_CFG, B_AX_BT_CNT_EN |
 			  B_AX_BT_CNT_RST_V1);
+
+	rtw89_io_unpack(rtwdev);
 }
 
 static
@@ -2888,6 +2892,8 @@ void rtw8852c_btc_update_bt_cnt(struct rtw89_dev *rtwdev)
 static
 void rtw8852c_btc_wl_s1_standby(struct rtw89_dev *rtwdev, bool state)
 {
+	rtw89_io_pack(rtwdev);
+
 	rtw89_write_rf(rtwdev, RF_PATH_B, RR_LUTWE, RFREG_MASK, 0x80000);
 	rtw89_write_rf(rtwdev, RF_PATH_B, RR_LUTWA, RFREG_MASK, 0x1);
 	rtw89_write_rf(rtwdev, RF_PATH_B, RR_LUTWD1, RFREG_MASK, 0x620);
@@ -2901,6 +2907,8 @@ void rtw8852c_btc_wl_s1_standby(struct rtw89_dev *rtwdev, bool state)
 			       RFREG_MASK, 0x208);
 
 	rtw89_write_rf(rtwdev, RF_PATH_B, RR_LUTWE, RFREG_MASK, 0x0);
+
+	rtw89_io_unpack(rtwdev);
 }
 
 static void rtw8852c_set_wl_lna2(struct rtw89_dev *rtwdev, u8 level)
@@ -2910,6 +2918,8 @@ static void rtw8852c_set_wl_lna2(struct rtw89_dev *rtwdev, u8 level)
 	 * To improve BT ACI in co-rx
 	 */
 
+	rtw89_io_pack(rtwdev);
+
 	switch (level) {
 	case 0: /* default */
 		rtw89_write_rf(rtwdev, RF_PATH_B, RR_LUTWE, RFREG_MASK, 0x1000);
@@ -2936,6 +2946,8 @@ static void rtw8852c_set_wl_lna2(struct rtw89_dev *rtwdev, u8 level)
 		rtw89_write_rf(rtwdev, RF_PATH_B, RR_LUTWE, RFREG_MASK, 0x0);
 		break;
 	}
+
+	rtw89_io_unpack(rtwdev);
 }
 
 static void rtw8852c_btc_set_wl_rx_gain(struct rtw89_dev *rtwdev, u32 level)
-- 
2.25.1

