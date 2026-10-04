Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CBF3AA9EF
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085617; cv=none; b=Qy3OEIiL3stCiUQbkiNXwYTfp11MYvrcGSQHF1pRF9IR1S+8wjCbLYNZmPhHPryHFzvd2ezh4+1291BhcJPfAGrK0v63QJ3cLSgICn5URGC8VVjphb9LTac9zmXLyImeXqWJXx6yNb94tT3XNt5Eks6OHz61waR+QkwnClxBrDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085617; c=relaxed/simple;
	bh=PG/Y/fcR5hEZkmOXZEsyeUQiHgyJxBOBIOgQuJf0rgo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F4QsX0bgu1eBkqnhyngKPewdpN/puiVRLkIkYTzj1u7cWZdsLI7pFciJ2eF8EaL1+FK1u7Tit/a3aqUlSqYjcgEjf3LNg2L2vyGN6i4OxU7lLWCaPBTTLOc92+ALgjcY0U6K8m4oKnDTsGvFKMp4hNFwk2i5f8dhdrgWFIeQlD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=bholLb/g; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="bholLb/g"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943krEH3829592, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085613; bh=EY9lAoderUKAH4qOTSeaV1ydWg1Mzp9+BOqjMdAiS+s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=bholLb/gydHNuQwVMWiuVbK5ZoQXlxOyUvhyT+OvyUxBqvfEmeH5Ljjm5Mu6brObF
	 p6H9oGjRv2K1g7hpbSsW1traPOBacY40CVw9fCP1qkitlq7bri6DgsqwgTAZ8XMrd7
	 De0q6unjSmt785sCQ3oXylAiqojmo6Gs2iFtbLJ+GNAlqZnFHKUed/eb+0OkcJs4oG
	 VLSjIBRvbqKGWEc6n8ICgEFiZ4ykeGd5PznmgZoO/LT8JKWKjYdZ14qflp5xGxyrI8
	 rmqe/XPobhL56+0MYvhb7Qo53z91aTW+VR6Gae44eS0p+E44EdEfe3iO+5LrfL/9eO
	 72vs1WMw7Qthg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943krEH3829592
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:46:53 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:53 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:46:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 09/15] wifi: rtw89: coex: bind the RF band in use while WL is doing RFK
Date: Sun, 4 Oct 2026 11:45:14 +0800
Message-ID: <20261004034520.33695-10-pkshih@realtek.com>
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

The RF band that TDD and FDD bind to is picked by scoring each BT
link's weight against the WL/BT band-overlap map. That map is built
from connected WL links, so while WL is running RFK on a band it has
not associated on yet, neither band scores and the binding ends up
empty. Coexistence then treats the chip as having no WL/BT band
overlap at all and leaves RFK unprotected against a BT device already
transmitting on that same band, which can corrupt the calibration
result.

Force the score of the band being calibrated up to the binding
threshold when any BT is on an overlapping band, so the RFK band
binds for as long as the calibration runs.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 80c278aa96f0..ebc4b1b415c8 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -8610,6 +8610,26 @@ static void _set_bind_info(struct rtw89_btc *btc, u8 type)
 			b5g_score += link_weight[j][BTC_BT_B5G];
 	}
 
+	/*
+	 * Consider WL RFK band for coex (avoid missing RFK case)
+	 * If WL is doing RFK, check RFK band vs BT band overlap
+	 * Only add score when RFK band matches BT band
+	 */
+	if (wl->rfk_info.state != BTC_WRFK_STOP) {
+		if (wl->rfk_info.band == RTW89_BAND_2G) {
+			/* RFK on 2.4GHz, check if any BT is also on 2.4GHz */
+			if ((cx->bt0.rf_band_map & BIT(RTW89_BAND_2G)) ||
+			    (cx->bt1.rf_band_map & BIT(RTW89_BAND_2G)))
+				b2g_score = thres;
+		} else if (wl->rfk_info.band == RTW89_BAND_5G ||
+			   wl->rfk_info.band == RTW89_BAND_6G) {
+			/* RFK on 5/6GHz, check if any BT is also on 5GHz */
+			if ((cx->bt0.rf_band_map & BIT(RTW89_BAND_5G)) ||
+			    (cx->bt1.rf_band_map & BIT(RTW89_BAND_5G)))
+				b5g_score = thres;
+		}
+	}
+
 	/* rf-band bound by comparing link weight */
 	if (b2g_score == 0 && b5g_score == 0) /* no-rf-band overlap */
 		bd->rf_band = 0;
-- 
2.25.1

