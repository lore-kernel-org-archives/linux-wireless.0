Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E897C37BE6F
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 15:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791561551; cv=none; b=ZDFGiG7ZWeXFAegItoUvLvSlnP8VoLsU6A7WPXI9NPVCKXkecmV+DZnrGITTSYW0b01rWpwn5MVmBHWL/e1OUNzqcJ0AomoL1jbmje4zvj1XcQq/On7yQVCsuQhq05uN/2iK6U+wJDFb4mny7kCT2425r1pCiHJrY5w8Rn9s+iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791561551; c=relaxed/simple;
	bh=QstwVMvvN2Sr9J+5bjADIAjk9mfPBAQCxBPM+7Yh5UY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QKppTtYWmOtLQ6WpQNwP6BhS/4unOtUB7j0OPO1FraxqysZH4EGucQmeKv9taZpzfrv2v3cpBoNDGHlOgzZku05xer4J5xgztUs4hVIu4OgBYoWNJpvG9+W2sM2DthhAxqJIfkxspQ0MO60izyYOcMSQ7sxQPmvALQRK6Uln6UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lbl6Gzi+; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lbl6Gzi+"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=QstwVMvvN2Sr9J+5bjADIAjk9mfPBAQCxBPM+7Yh5UY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791561546; v=1; x=1792166346;
 b=Lbl6Gzi+5gP+Ux1+UZXttHiRmhFHlcyFkeINS2/8U/JcAArdDFgi2AjZIKNzri/MgEBiz5mo
 ZpnLMeNddjqETA3DUCtr6h/qpnEo4fovqvb/B8kZ4c/PhXqY8Mlow9db785fmjciZSbD+nfkgqX
 TLrKoBXFWCXivgsrphodU5MA=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b30625e831a10d4c;
	Fri, 09 Oct 2026 15:59:06 +0000
X-Mizu-Trace-ID: b30625e831a10d4c
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next] wifi: rtw88: 8723b: don't set channel_invalid in query_phy_status()
Date: Fri,  9 Oct 2026 17:58:38 +0200
Message-ID: <20261009155838.169058-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rtw8723b_query_phy_status() sets pkt_stat->channel_invalid, which makes
rtw_update_rx_freq_for_invalid() call rtw_update_rx_freq_from_ie() and
overwrite rx_status->freq with rtwdev->hal.current_channel.
rtw_update_channel() keeps the center channel in that field, not the
primary one, so on a 40 MHz connection mac80211 is handed a frequency it
rejects in ieee80211_rx_beacon_freq_valid() and reports beacon loss for
beacons the driver did receive. Only beacons go through that check, so
data traffic is unaffected.

Remove it now, so that the non-SDIO members of the 8723B family do not
report beacon loss once they are supported. SDIO is unaffected, because
rtw_sdio_rx_skb() copies the status into the skb before the update runs.

Reported-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
index 8bb9c03d769c..0c37e981ec84 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
@@ -1303,13 +1303,6 @@ static void rtw8723b_query_phy_status_ofdm(struct rtw_dev *rtwdev, void *phy_raw
 static void rtw8723b_query_phy_status(struct rtw_dev *rtwdev, u8 *phy_status,
 				      struct rtw_rx_pkt_stat *pkt_stat)
 {
-	/*
-	 * The 8723B PHY status does not report the channel, so we must
-	 * mark it invalid to allow mac80211/rtw88 to parse it from the IE
-	 * during scanning.
-	 */
-	pkt_stat->channel_invalid = true;
-
 	if (pkt_stat->rate <= DESC_RATE11M)
 		rtw8723b_query_phy_status_cck(rtwdev, phy_status, pkt_stat);
 	else
-- 
2.55.0

