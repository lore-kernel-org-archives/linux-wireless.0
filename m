Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F322F99B8
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901446; cv=none; b=V0+M8B19eDeoqxqajcMvx65yZvnjGgqJsISfLAO0x8wzPf0wTPD+mPTAfWxQKgPa7B4te98sziQQDeBFLAVJpGlsOxvblB12M99yJF454ZYSQ3scpp8ZtTxakKE5xvLh20ETBhW2T4Qx8CZP00mo9zN9DcNjyMEMC/KAW2IHV3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901446; c=relaxed/simple;
	bh=ctVZpHmz2YQdOLpyCvNlChZO6E6kvwB+p3KNhfDBsq4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jyMatj9vGTAHfdNNemPSOCNaiQi7FGFW/Rr9N+Zad98XzMmmIjOuJHodWdW1rBvUytxxo4Qxre9KErYJz0Hk/dTh0YcdJHX2OX4QgnZj2+9ZSdN4WU26xMLi7qxK9lCMBnZbmg0RMtQWUoBHBdeVnMvpao74n8voI+wEMh8ubyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=WGGzQSLN; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="WGGzQSLN"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODvMwfD1179760, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901442; bh=JBtid0A5Kb2LFyWburMxKwaZpRwYUv/yWln+2xoD8W8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=WGGzQSLNM9RsCQODwN5nrTVDdLcjmrkAW+dcNL/5tT3p5hgIigjdOwkH2pSqex/HS
	 5CV5n3S1qHDIFzp2x6q/C3vF986Yq9lJu8Ya4SvRVBa7Q+ZDnC4fXxU59iYKXOLd8Y
	 xBTeOH1H0mkYPSolOFJbLrk9E4hyLYbZNZbrAYCB45nQesVqYtxw7Nblawt8RJpa4g
	 XkZ2f7zgzTF0/n1+InFP02vwx1yvuxsYFxS7p1R55EdgeTEFQdKpZmhVeGmUrX/Ihm
	 X8nYo2IXysmZCIJGTrMfOCBi6sVKtRR/2qbDiv6VIXqxc1kL2r526BaG6R8Brqk3oU
	 EPV4j2NxR50Nw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODvMwfD1179760
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:57:22 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:22 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:57:22 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 08/14] wifi: rtw89: coex: Refine RF calibration notify flow
Date: Fri, 24 Jul 2026 21:56:34 +0800
Message-ID: <20260724135640.3195044-9-pkshih@realtek.com>
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

BT-coexistence only needs to record RF calibration is doing or not, don't
need to record the status of the calibration steps.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 96ec5fa20422..187e7e70e86d 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -9144,14 +9144,13 @@ static bool _ntfy_wl_rfk(struct rtw89_dev *rtwdev, u8 phy_path,
 		wl->rfk_info.state = BTC_WRFK_START;
 
 		btc->cx.wl.wcnt[BTC_WCNT_RFK_REQ]++;
-		btc->cx.wl.wcnt[BTC_WCNT_RFK_GO]++;
 		btc->dm.cnt_notify[BTC_NCNT_WL_RFK]++;
 
 		_write_scbd(rtwdev, BTC_ALL_BT, BTC_WSCB_WLRFK, true);
 		break;
 	case BTC_WRFK_ONESHOT_START:
 	case BTC_WRFK_ONESHOT_STOP:
-		wl->rfk_info.state = state;
+		btc->cx.wl.wcnt[BTC_WCNT_RFK_GO]++;
 		if (type != BTC_WRFKT_RXDCK)
 			return BTC_WRFK_ALLOW;
 		break;
@@ -9165,7 +9164,7 @@ static bool _ntfy_wl_rfk(struct rtw89_dev *rtwdev, u8 phy_path,
 	default:
 		rtw89_debug(rtwdev, RTW89_DBG_BTC,
 			    "[BTC], %s() warning state=%d\n", __func__, state);
-		break;
+		return result;
 	}
 
 	if (result == BTC_WRFK_ALLOW) {
-- 
2.25.1

