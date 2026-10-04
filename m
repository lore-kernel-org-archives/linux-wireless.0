Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92CF3E63AE
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085648; cv=none; b=NOc2DdntPPhi63MU7pbxuGxDsadzAud5quEMc45vaJw/b6ctf1sMhhs8HaxtWquwDNNNcjazWvX7XOMEe9YMv+loGOIXL9GTCh1Hz+dNcZ1+pxwAW2wG0yQiQ+y0vd8fjYZOoya2er5b4m8bESZbJEumWPNarVoecM+OT4X2i5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085648; c=relaxed/simple;
	bh=0JigPmOyQzZH2FEQV1b81e6xPAMQ+eCKEFckV03TxcQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jWls6bfwOHhWiWKjUQdz1xzLdCzsEOLmtOt67JA7By/V9avR5rsw5MDru3gWrGHlYjZqgJwdqENnVHOoo4vDZQ+djc6y/5kSY9ConHvwZiWp079kraKlhmXVfKfJJS0UyzbsV5y2+T5vbeDjH1aNyO1rUv642qZQR6Vb/IumTS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=NFT29q8B; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="NFT29q8B"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943lOueD829689, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085644; bh=U7GfxwyOMvsWimhj2nj56rYwKo2E0PE0aeUYHzqGV0k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=NFT29q8BSVaocP9zXSriwzKyrmhtF+OSOqUcV1tgh/ORp0geVZKWO5xwwAoCr9swy
	 yaXQYAAvZXV8rpOIlVGVrgk2TVAa8Fe0HLru4v5inzFhaoNCzL2f6rNf+mEJpAUoYW
	 y8JFiMRmshq0D/xwQAxgZHjiObSgzmWLHu0WX1iEIj+Zj/1wqddnpaQxIOItOuHOQ9
	 0g7cLpTR+J3Z0TvAsBWe3nnoaAh+594Q+VR9bHL5HlkSyGQBpDRGs1ktz9fMcoT+k5
	 mc+u0JJ4eZcvuYrWDrAcvimP2HCzzEXgxcmg3rSjO/8l+EOP3yQfd2SwuqAq2wjeMa
	 4eWDr9YgD0WHw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943lOueD829689
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:47:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:47:24 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:47:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 15/15] wifi: rtw89: coex: set rf_combination in _update_wl_mlo_info()
Date: Sun, 4 Oct 2026 11:45:20 +0800
Message-ID: <20261004034520.33695-16-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261004034520.33695-1-pkshih@realtek.com>
References: <20261004034520.33695-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

_update_wl_mlo_info() derives path_rf_band, link_mode, dbcc_en and
other per-RF-path fields from the current MLO link_status, but never
wrote mlo_info->rf_combination in any of the three link_status cases.
The field stayed at its zero-initialized value, which aliases
BTC_MLO_RF_2_PLUS_0.

_set_bind_info() and _set_coex_binding() both branch on
rf_combination to decide how to bind WL RF-paths to BT devices for
1+1, 2+2, 2+0 and 0+2 MLO combinations. With the field always zero,
those branches silently treated every MLO combination as 2+0,
producing an incorrect WL/BT binding whenever the real combination
was 1+1, 2+2 or 0+2.

Set rf_combination to the matching BTC_MLO_RF_* value in each of the
2+0, 0+2 and 1+1/2+2 branches so the binding logic sees the actual
RF combination.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 9107a6c8c6fc..e81581e6da5a 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -7806,6 +7806,7 @@ static void _update_wl_mlo_info(struct rtw89_dev *rtwdev, u8 hw_band)
 		rf_band = wl->rf_band_map[RTW89_PHY_0];
 		mlo_info->path_rf_band[BTC_RF_S0] = rf_band;
 		mlo_info->path_rf_band[BTC_RF_S1] = rf_band;
+		mlo_info->rf_combination = BTC_MLO_RF_2_PLUS_0;
 		break;
 	case MLO_0_PLUS_2_1RF: /* 0+2 */
 	case MLO_0_PLUS_2_2RF:
@@ -7818,6 +7819,7 @@ static void _update_wl_mlo_info(struct rtw89_dev *rtwdev, u8 hw_band)
 		rf_band = wl->rf_band_map[RTW89_PHY_1];
 		mlo_info->path_rf_band[BTC_RF_S0] = rf_band;
 		mlo_info->path_rf_band[BTC_RF_S1] = rf_band;
+		mlo_info->rf_combination = BTC_MLO_RF_0_PLUS_2;
 		break;
 	case MLO_1_PLUS_1_1RF: /* 1+1 */
 	case MLO_1_PLUS_1_2RF: /* 1+1 */
@@ -7853,6 +7855,11 @@ static void _update_wl_mlo_info(struct rtw89_dev *rtwdev, u8 hw_band)
 		}
 
 		wl_rinfo->dbcc_en = 1; /* two HW-band both active */
+
+		if (mlo_info->link_status == MLO_2_PLUS_2_2RF)
+			mlo_info->rf_combination = BTC_MLO_RF_2_PLUS_2;
+		else
+			mlo_info->rf_combination = BTC_MLO_RF_1_PLUS_1;
 		break;
 	}
 
-- 
2.25.1

