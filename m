Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61E9456DE4
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784918013; cv=none; b=awpwZpG/nh38FsQwET0s3QAorxxBzXWkVRTb/vu/9P9MBgraSVrTNU5QJqeKyUeUv8Fg0Zz11RBu6OH614LddNtP9975Y5KH4sHXboKhUzTQRyfCS2DWEKHElx7o7xtDjH9yGxJim0BzzpenkDau3c48ClbI0nQYOSUJ4Oy3Jms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784918013; c=relaxed/simple;
	bh=DHu4e1+0OGkzi83AYEVjCsK6bQh/TsasKYNdVrt0Nrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOOFRfEyUKGmuiWoRczi70y42REBry7sG1vEcY0U7+sz36KlA3lgtNyX+tWNxeYVMAcrjmMt0GWPJDfbWIkzJKb3YQaR11/3ZOsRLdt1frPJ19Dxwc3GqDGjms7CeCzj4x3ZiaCYL84jVg55vWTjH1iMc9ImR020y4Z4Pb8OzOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q8ZdJpZx; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q8ZdJpZx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784918009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zan9jSxxBQNdc7F8Pl4HXdQhdIt1LzmgAA4mJ9KDaxs=;
	b=q8ZdJpZxcP9DjvZo2pOQ3Ece27q1JMLulzSfmlhdmNZtLWBIVGd743cA4a0DtfT5lEWPOk
	EANSuD9T9B0SVMEXD0/kZKRF58yvm1Lht7cuXBuscoulysu3hgSv2InUkPil8e7/ffGvvs
	cQCkiuCUBy8yeAdd2wS/g1Bz9rCFbrg=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 18/19] wifi: rtw88: match the RTL8723BS firmware connect and power save behaviour
Date: Fri, 24 Jul 2026 20:33:14 +0200
Message-ID: <20260724183314.197195-1-luka.gejak@linux.dev>
In-Reply-To: <20260724181858.192903-1-luka.gejak@linux.dev>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

The vendor firmware expects the connect media status report at
association completion rather than when the station is added, so defer
it until the station is actually associated and track whether it was
sent, so the disconnect report is only sent to undo one that was.

Leaving LPS also costs enough per-packet latency on this chip to
throttle bursty traffic badly, and the stock check enters LPS after a
single quiet two second window that an ordinary session hits
constantly. Gate LPS on the smoothed throughput for this chip so it
only sleeps after sustained idle. Other chips keep the existing
behaviour.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/main.c | 47 ++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index a2ef4479f408..63d1fb4bc87e 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -304,6 +304,25 @@ static void rtw_sw_beacon_loss_check(struct rtw_dev *rtwdev,
 /* process TX/RX statistics periodically for hardware,
  * the information helps hardware to enhance performance
  */
+static bool rtw8723bs_station_media_status(struct rtw_dev *rtwdev,
+					   struct ieee80211_sta *sta,
+					   struct ieee80211_vif *vif)
+{
+	return rtw_is_8723bs(rtwdev) &&
+	       vif->type == NL80211_IFTYPE_STATION && !sta->tdls;
+}
+
+/* 8723BS SDIO: defer the connect MEDIA_STATUS_RPT until the STA is actually
+ * associated (the vendor firmware sends it at assoc completion, not sta-add).
+ */
+static bool rtw8723bs_defer_sta_media_status(struct rtw_dev *rtwdev,
+					     struct ieee80211_sta *sta,
+					     struct ieee80211_vif *vif)
+{
+	return rtw8723bs_station_media_status(rtwdev, sta, vif) &&
+	       !vif->cfg.assoc;
+}
+
 static void rtw_watch_dog_work(struct work_struct *work)
 {
 	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
@@ -382,6 +401,17 @@ static void rtw_watch_dog_work(struct work_struct *work)
 	 * get that vif and check if device is having traffic more than the
 	 * threshold.
 	 */
+	/* On 8723BS SDIO the firmware's per-packet wake latency out of LPS
+	 * throttles bursty traffic hard. The stock check enters LPS after a
+	 * single quiet 2s window, which a normal bursty session hits
+	 * constantly. Gate LPS on the smoothed throughput instead so the chip
+	 * only sleeps after sustained idle and stays awake through an active
+	 * session. Other chips keep the normal behaviour.
+	 */
+	if (rtw_is_8723bs(rtwdev) &&
+	    (stats->tx_throughput || stats->rx_throughput))
+		ps_active = true;
+
 	if (rtwdev->ps_enabled && data.rtwvif && !ps_active &&
 	    !rtwdev->beacon_loss && !rtwdev->ap_active)
 		rtw_enter_lps(rtwdev, data.rtwvif->port);
@@ -450,7 +480,13 @@ int rtw_sta_add(struct rtw_dev *rtwdev, struct ieee80211_sta *sta,
 	INIT_WORK(&si->rc_work, rtw_sta_rc_work);
 
 	rtw_update_sta_info(rtwdev, si, true);
-	rtw_fw_media_status_report(rtwdev, si->mac_id, true);
+	if (rtw8723bs_defer_sta_media_status(rtwdev, sta, vif)) {
+		rtwvif->fw_media_connected = false;
+	} else {
+		rtw_fw_media_status_report(rtwdev, si->mac_id, true);
+		if (rtw8723bs_station_media_status(rtwdev, sta, vif))
+			rtwvif->fw_media_connected = true;
+	}
 
 	rtwdev->sta_cnt++;
 	rtwdev->beacon_loss = false;
@@ -465,14 +501,21 @@ void rtw_sta_remove(struct rtw_dev *rtwdev, struct ieee80211_sta *sta,
 {
 	struct rtw_sta_info *si = (struct rtw_sta_info *)sta->drv_priv;
 	struct ieee80211_vif *vif = si->vif;
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
 	int i;
 
 	cancel_work_sync(&si->rc_work);
 
 	if (vif->type != NL80211_IFTYPE_STATION || sta->tdls)
 		rtw_release_macid(rtwdev, si->mac_id);
-	if (fw_exist)
+	if (fw_exist && rtw8723bs_station_media_status(rtwdev, sta, vif) &&
+	    !rtwvif->fw_media_connected) {
+		/* connect status was deferred and never sent; nothing to undo */
+	} else if (fw_exist) {
 		rtw_fw_media_status_report(rtwdev, si->mac_id, false);
+		if (rtw8723bs_station_media_status(rtwdev, sta, vif))
+			rtwvif->fw_media_connected = false;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		rtw_txq_cleanup(rtwdev, sta->txq[i]);
-- 
2.55.0

