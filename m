Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF79A456DED
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784918018; cv=none; b=Q9Ih/c23pu+5SeLMhXd2uKTjTL+mZtqYYQpJmWZTe6n9/dJ3XwwwZbE2CMdqPy8DIwLinckBwIXM3U7sqmHjSATPIZvI41Hc6P5FXiWygKtFS7lk4OtwmjM75gaTza79x/iG24G1QYH7qFdLTYQ0iSCOYp+p8JnFudZwiS0EYCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784918018; c=relaxed/simple;
	bh=XIjEqjYsFzv1BfLPUGcPDq4LDTJCkMnJ/x9faf4M1eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEkFhC6J7EjJ5METV4E0ZMzUp9tj5Z+whOITKTNpvClEr57eh9gm4sayGTsEi02oiG5iOzg268jS/wLdNEm6BnzYTpekiuFE0hYcm6Zv7GQpYkTAp1bRI/91VvVNl8Gg5ZRPuwPGwyiQqAEUiMOOecy8sUItrKsmWimqG/XojnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZgFg+BnB; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZgFg+BnB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784918014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EZ4W8YmbbHXJX5xALG4eAUvHHKHbZ2bhMEB/KL7QMLs=;
	b=ZgFg+BnBFEpbS1WfzAqleQ368i60lLgVFiV745JiSmBrmpnjgzsDLborTjyinm2Gs0YPCV
	UY5mE0hJUVEBfuAHLpwBPa58bPMbj03NY1AXhjUlx/AJ4DPDu0J8EQs5ovNUnRuNOmFOFw
	QlQSoDQ9bjuujkgySpGEQDefPDdgweg=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 19/19] wifi: rtw88: advertise the correct receive capabilities on RTL8723BS
Date: Fri, 24 Jul 2026 20:33:30 +0200
Message-ID: <20260724183330.197283-1-luka.gejak@linux.dev>
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

This chip has neither a firmware feature report nor an efuse hardware
capability parser, so the capability struct is left at zero. A zero
stream count builds an HT capability with no usable RX MCS rates, and
APs drop the station immediately after an otherwise successful
association. Fill in the stream and antenna counts from the RF path
count, and advertise the 20 and 40 MHz support the chip has.

RTL8723BS also leaves BIT_APP_FCS clear, so received frames do not carry
the FCS. Advertising RX_INCLUDES_FCS would make mac80211 trim four bytes
of real frame data and corrupt the trailing element of beacons and probe
responses, so leave it unset for this chip.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/main.c | 61 +++++++++++++++--------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 63d1fb4bc87e..e2f0fd367beb 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -126,6 +126,25 @@ static void rtw_power_on_8723bs_sdio_rfk(struct rtw_dev *rtwdev)
 	rtwdev->initial_rfk_done = true;
 }
 
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
 static struct ieee80211_channel rtw_channeltable_2g[] = {
 	{.center_freq = 2412, .hw_value = 1,},
 	{.center_freq = 2417, .hw_value = 2,},
@@ -304,25 +323,6 @@ static void rtw_sw_beacon_loss_check(struct rtw_dev *rtwdev,
 /* process TX/RX statistics periodically for hardware,
  * the information helps hardware to enhance performance
  */
-static bool rtw8723bs_station_media_status(struct rtw_dev *rtwdev,
-					   struct ieee80211_sta *sta,
-					   struct ieee80211_vif *vif)
-{
-	return rtw_is_8723bs(rtwdev) &&
-	       vif->type == NL80211_IFTYPE_STATION && !sta->tdls;
-}
-
-/* 8723BS SDIO: defer the connect MEDIA_STATUS_RPT until the STA is actually
- * associated (the vendor firmware sends it at assoc completion, not sta-add).
- */
-static bool rtw8723bs_defer_sta_media_status(struct rtw_dev *rtwdev,
-					     struct ieee80211_sta *sta,
-					     struct ieee80211_vif *vif)
-{
-	return rtw8723bs_station_media_status(rtwdev, sta, vif) &&
-	       !vif->cfg.assoc;
-}
-
 static void rtw_watch_dog_work(struct work_struct *work)
 {
 	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
@@ -401,6 +401,7 @@ static void rtw_watch_dog_work(struct work_struct *work)
 	 * get that vif and check if device is having traffic more than the
 	 * threshold.
 	 */
+
 	/* On 8723BS SDIO the firmware's per-packet wake latency out of LPS
 	 * throttles bursty traffic hard. The stock check enters LPS after a
 	 * single quiet 2s window, which a normal bursty session hits
@@ -2122,8 +2123,21 @@ static int rtw_dump_hw_feature(struct rtw_dev *rtwdev)
 	u8 bw;
 	int i;
 
-	if (!rtwdev->chip->hw_feature_report)
+	if (!rtwdev->chip->hw_feature_report) {
+		/* 8723BS has neither a firmware feature report nor an efuse hw_cap
+		 * parser, so hw_cap is otherwise left at zero. A zero stream count
+		 * produces an HT capability with no usable RX MCS rates, which makes
+		 * APs drop the station immediately after a successful association.
+		 * Other report-less chips fill hw_cap in when parsing the efuse.
+		 */
+		if (rtw_is_8723bs(rtwdev)) {
+			efuse->hw_cap.nss = rtwdev->hal.rf_path_num ? : 1;
+			efuse->hw_cap.ant_num = rtwdev->hal.rf_path_num ? : 1;
+			efuse->hw_cap.bw = BIT(RTW_CHANNEL_WIDTH_20) |
+					   BIT(RTW_CHANNEL_WIDTH_40);
+		}
 		return 0;
+	}
 
 	id = rtw_read8(rtwdev, REG_C2HEVT);
 	if (id != C2H_HW_FEATURE_REPORT) {
@@ -2429,7 +2443,12 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
 	hw->vif_data_size = sizeof(struct rtw_vif);
 
 	ieee80211_hw_set(hw, SIGNAL_DBM);
-	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	/* RTL8723BS keeps BIT_APP_FCS clear, so received frames do not contain
+	 * the FCS. Advertising RX_INCLUDES_FCS would make mac80211 trim four
+	 * bytes of frame data and corrupt the tail IE in beacons/probe responses.
+	 */
+	if (!rtw_is_8723bs(rtwdev))
+		ieee80211_hw_set(hw, RX_INCLUDES_FCS);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(hw, MFP_CAPABLE);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
-- 
2.55.0

