Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DBA3E2777
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085585; cv=none; b=ICDB9FsVCdt24wDkp1dASVNnu2oy4tOrFTQ4JJv/sOnETXdHUILdeglyktmSPDMJ71nr29+vMxW1irrtUsJK9QX0aN6JTyP4IUmQeNYnxy9yfzfT34GKMBvNUr2zlW4FkC7h+u8pMgZeSx1Jx90Q27MEXVUVjctu9BIv9S/0qZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085585; c=relaxed/simple;
	bh=cylChr19G7CvOnnfStH7zy5pwYwfAi4CGXbUnUP2p2U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SKWfwY0/FKphULlPJkMjbASDKaQFomT2xE1+NJrP5zJMw3rAbOfnu+I2K+GsVxOnAxX71XsmblobbRAVG4r0os68CokB+zGV+59tn51+eZRygprQoKakxxPcDKVOBFCl9ON0lPTdGT/BgZk+cGPKB/leVLqiC36VuG1JK7e01Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=c7RTlLkO; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="c7RTlLkO"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943kLd65829288, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085581; bh=UR3CGmh6hzgOoTX203WpOH7HIDBKr6GqH6e8GDmItk0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=c7RTlLkOSeXh3gXsatgq6U5+WV4nuDBnnPxoyg6r+Yp4RWKcRCJI+Ceps3+MAlcne
	 ngjUjv9E73KPlaaRQuuCxEgcVFpctWTddtNKw2AeA/88qnPXUifeUGZzVlujnSa7QB
	 bZsrVgoZImRYTaoN/WPfEC9D5aICwRR855x5fJOlxa6ubQ6pZn5P4iaerLDxRfTgfl
	 bAFZ6/WWd/6jn7APMyvA+XpGfMUM9aVqh2qpzRqvNRBORl/F0kHzPSNZaNhE2KtpV1
	 7aTdVEHASeyBMKyzZsHmjEQchiD2Mkh0i8JFNxnW0GJirgaHpSi66bxDPbBCXF6Xlj
	 DS3W40X7lseCw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943kLd65829288
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:46:21 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:21 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:21 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:46:21 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 03/15] wifi: rtw89: coex: show per-HW-band MLO state in WL status dump
Date: Sun, 4 Oct 2026 11:45:08 +0800
Message-ID: <20261004034520.33695-4-pkshih@realtek.com>
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

The WL status debug dump only printed role, channel and link-mode
state for HW-band 0, even on chips where MLO support means both
bands carry an independent connection. Add an [MLO] line that
prints the operating mode, channel type, RF band and P2P-exist
state for each HW-band side by side, gated on the chip actually
supporting MLO so single-band chips keep the shorter dump.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 8412c082ddc8..556c35e84043 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -10292,6 +10292,7 @@ static int _show_wl_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 	struct rtw89_btc_cx *cx = &btc->cx;
 	struct rtw89_btc_wl_info *wl = &cx->wl;
 	struct rtw89_btc_wl_role_info *wl_rinfo = &wl->role_info;
+	struct rtw89_btc_wl_mlo_info *wl_minfo = &wl->mlo_info;
 	char *p = buf, *end = buf + bufsz;
 	u8 mode;
 
@@ -10319,6 +10320,25 @@ static int _show_wl_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		       wl->status.map._4way ? "Y" : "N",
 		       wl->status.map.init_ok ? "Y" : "N");
 
+	if (rtwdev->chip->para_ver & BTC_FEAT_MLO_SUPPORT) {
+		p += scnprintf(p, end - p,
+			       " %-15s : type:%d/rf_comb:%d/dbcc_en:%d, ",
+			       "[MLO]", wl_minfo->wtype, wl_minfo->rf_combination,
+			       wl_rinfo->dbcc_en);
+		p += scnprintf(p, end - p,
+			       "HWB0(wmode:%d/ch:%d/rf_band:%d/p2p:%d), ",
+			       wl_minfo->wmode[RTW89_MAC_0],
+			       wl_minfo->ch_type[RTW89_MAC_0],
+			       wl_minfo->hwb_rf_band[RTW89_MAC_0],
+			       wl_rinfo->p2p_exist[RTW89_MAC_0]);
+		p += scnprintf(p, end - p,
+			       "HWB1(wmode:%d/ch:%d/rf_band:%d/p2p:%d)\n",
+			       wl_minfo->wmode[RTW89_MAC_1],
+			       wl_minfo->ch_type[RTW89_MAC_1],
+			       wl_minfo->hwb_rf_band[RTW89_MAC_1],
+			       wl_rinfo->p2p_exist[RTW89_MAC_1]);
+	}
+
 	p += _show_wl_role_info(rtwdev, p, end - p);
 
 	return p - buf;
-- 
2.25.1

