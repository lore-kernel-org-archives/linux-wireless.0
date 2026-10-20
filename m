Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792529245;
	b=oDNvB0c8A+Vb+OoReyg2ESVzKwWlHG/Ll1gVOPxcCLIWFKprjoWZasdP9n1230hv7dgo
	 +WN7UeoyGrqsmoN3KKc5cg0OgAPFrcrtY5pz8nH/9/qdhw4wKbvWKP6si41m9kvRD6Bhw
	 EKBF4f0b61aWIGVkIlGqHqEioS5slkP6wbyVG7eGj9LO+SuRkemDW8TLcV5bQh5zLwb2S
	 HYlxVKaLXADvZAI9+9UEDA4FSqFiyO4tw0wz/ekj9o2Bx4FnFXmZmVTTTNKdBm6x2F8O2
	 Mm4gSK+/uDAri233qp9O+OkS2aytB8RnQ6SqQJjB4PnmRE44ycNmKSUitUTxybtVEXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792529245;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LY/dmHGx7MmoVX9PEfbiRrzvQfU4BP+AnOVPmeu35f4=;
	b=wyj5wgWyV6Zsf+Scn+67hbXJL29g73Pc4TnisrV3EjGmBLbXhnfRFXblBPqCbpE/hCD3
	 qy2Y7rW4D+cRsdw9IAmUj64mF8okk718nvPiH/rM12eZBb0oKaUcEjSk4HCimNQb2iYnH
	 IQQ/kKZ0xWtD2AGrfa/9xMBKColJX2ADya/sun4xb9gSL57yKnsbDIb4I9xieb4C845rH
	 fa8pKc0PDfugn31VLtkZeo4acGgCHcw9WgG0e+m59tOkzIH1VVvwKSMPKr3VeJae1ulUc
	 0t1Zq8MpjLd6F61S6v6H0KqRkvfKV/bjGFK6wH2F0egIflwhsNYX+kR5yF8Pqy0xRoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pnse09B+;
	arc=none smtp.remote-ip=209.85.219.52
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4107860A2603
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 20:47:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4107860A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pnse09B+
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-917a707f37eso1139886d6.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 13:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792529239; x=1793134039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LY/dmHGx7MmoVX9PEfbiRrzvQfU4BP+AnOVPmeu35f4=;
        b=pnse09B+aRrYYM54Ns5mPYQB7YHP4H6DWAEg9wfICNj/oLSEqlVMPr0+0Q+bftGDbR
         yxoeZBxwCfi03FNrslYW63/8JQY9fQb7PXxiALKFdMawbGYKHR0GLAh/eKusBFv6a6cN
         oAOGctK3C+Wb0HwvCvF0l+JtOVZ/nFLtAlz6V/yBZeE0cXy8w1RsC71KNwpXL20/r/Bi
         JknxKD6fvIcv9rly6bKWQAYbXpf5zNFhJZ0+v38m3dJ44Z4xw3hur9S1WMG8Y9Pys5tb
         JbefXLC4X6rEy1lQGnuSh3RUrY/NMOcsFDDo6025KyPmG8kiAbkTSw+LkrKxHikw/8xk
         p5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792529239; x=1793134039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LY/dmHGx7MmoVX9PEfbiRrzvQfU4BP+AnOVPmeu35f4=;
        b=WK9PW/Sq7tyVW2GF7l+UEbagIVPKzDF4nbx/pwGnrkNZPq83fZEPowbM53Lv6DGwjY
         gK/sPrrhU6aeHE2utTBRjry247NWxkc2imUrzz04cHnmP39/ToRgA85UA0Yy3tZH6udT
         H3rc8LByh5bDFe6WLpASvfAIkWt5th1lG45sFP51ftrIal0eUaunosJWk/h+ObnPel4J
         GPc0ca3vYEOb9sEwQxjJz+WSR6WsqaykZi5/Ur0AimCzpun2xrSnJP9P9bBZtai2H1R1
         wW7MjjTLPUNDPKdycpj5k0vBPj5Q6pXUwCTSI9XtcMWi+V9y4THzkIPrgV3hYbB9y3j3
         AQ7Q==
X-Forwarded-Encrypted: i=1; AKwUvBxDuqtGF254rkVxYCHTbb5Vg6SfwM7TAYk5JTQfeIuK6Sac/H46z+LdRo/MMvVugI3dA3QPP+eNieIn2GIXMw==@vger.kernel.org
X-Gm-Message-State: AFq9FYI+ATjxQ2DydW7DIEonKaNzdVaeI3pDvBijMTIk70mptJ3pcEes
	jRmpHRNHVr8V2+Gg83jVuoHd6dAd4xWB/1Y6IQBCuZU07ToIgQVWj8y0
X-Gm-Gg: AYBFou03VaymabdA8S5LZjuUHVhuvJQXbWbo2G10xUypRNKEvdsv/ry4Z7jaSxwa0cB
	WX30x7IgXou5tBJk/7or45kHnggQxXXdhD7ByLHmy1Zi5KbCJs+aVR+loLFmvUvicPvCKXc+ylc
	4qrjKWPc7Uv73TWaOW0Sn6cM5EdUr2alNj1ltlc50HtdZgmttLMHZSq9uBfQhaUUbeRvHQ4HQ3I
	RCuLowVed9VWSz21m99mn61MmMPWn66bA6pEzKUYkb9oyymIEIjKO2knRhT8vuvjKAUWN5zSBP6
	VPaHw1kZfDUkQlkPGtf7EH654ASeYrd0hv+/3Yto1jUgwQsALxeXZaLRdZGGIYMHTC10QRVEuqH
	z5KH6tDXWhZ7u6e6QQPVJS62e9I1WKktG4uDsXfXYFXlO4Cvo7N4MrAhiuQCQORyrITvFgn54e3
	teerBIyFiw31GXqf1fCvQaYc2kBP7ZPieDttD5l/T+DGOeAPRAPC0UyPYjbM0/ZwjiAcXPe1NwV
	x77
X-Received: by 2002:a05:620a:6887:b0:93e:9834:3863 with SMTP id af79cd13be357-93f57f6fea4mr75959485a.15.1792529239084;
        Tue, 20 Oct 2026 13:47:19 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56c6f16dsm79336785a.4.2026.10.20.13.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 13:47:18 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v7 2/3] wifi: rtw88: support channel switch in AP mode
Date: Tue, 20 Oct 2026 22:47:11 +0200
Message-ID: <20261020204712.3252023-3-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261020204712.3252023-1-mehmet.fide@gmail.com>
References: <20261020204712.3252023-1-mehmet.fide@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

hostapd's CHAN_SWITCH is refused because the driver does not announce
channel switch support, so an rtw88 AP can only change its channel by
being torn down and started again.

Declare WIPHY_FLAG_HAS_CHANNEL_SWITCH and implement
channel_switch_beacon: the firmware repeats the beacon held in the
first reserved page, so while a switch is announced the page is
downloaded again every beacon interval to advance the countdown, and
ieee80211_csa_finish() is called once it completes. IBSS shares the
page and the work.

The work is a delayed work of the device and csa_vif names the
interface, both under the driver mutex. The countdown is cancelled when
the AP stops, when the interface goes away, on WoWLAN suspend and in
rtw_core_stop(); the BSS_CHANGED_BEACON replay after a hardware restart
resumes it. The other page downloads during a countdown, the TIM update,
the PG backup and the one on association, are skipped until the beacon
after the switch, since every beacon fetch advances the countdown; the
next download carries their changes. A scan is refused: it would take
the AP off the channel its stations count down to.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---

Notes:
    Changes in v7:
    - csa_vif is kept until the beacon after the switch: a TIM update
      before it fetched one beacon past count 1 and hit the WARN in
      ieee80211_beacon_update_cntdwn()
    - rebased on rtw-next
    
    Changes in v6:
    - the countdown work is an ieee80211 delayed work under the driver
      mutex, csa_vif is driver state under the mutex; no wiphy lock in
      rtw88 (Ping-Ke)
    - rtw_core_stop() cancels the work and clears csa_vif, which covers the
      IPS path and the firmware recovery (Ping-Ke)
    - the downloads are paced from the first one with an absolute due time:
      queued after each download, the countdown drifted by about 10 ms per
      beacon interval on the ordered mac80211 workqueue, and a station
      switched ahead of the AP on a count of 50
    - the BSS_CHANGED_BEACON path says why it starts the countdown (the
      replay after a hardware restart) and stops it when the beacon comes
      back without a switch announced (Ping-Ke)
    
    Changes in v5:
    - rtw_fw_csa_active/start/stop() assert the wiphy lock
    - hw_scan() takes the mutex with guard()
    - the ASSOC path says why it skips the download: the STA+AP combination
    
    Changes in v4:
    - the work and csa_vif live in rtw_dev; no lookup through the reserved page
    - the countdown is stopped before a firmware recovery restarts the hardware
    - a scan is refused while a switch is announced
    - one beacon fetch per interval during the countdown

 drivers/net/wireless/realtek/rtw88/fw.c       | 80 ++++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/fw.h       |  4 +
 drivers/net/wireless/realtek/rtw88/mac80211.c | 39 +++++++--
 drivers/net/wireless/realtek/rtw88/main.c     |  6 +-
 drivers/net/wireless/realtek/rtw88/main.h     |  3 +
 5 files changed, 124 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 3cd17a3bb494..2d81aaeed0d7 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1802,14 +1802,90 @@ int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev)
 	return ret;
 }
 
+bool rtw_fw_csa_active(struct rtw_dev *rtwdev)
+{
+	lockdep_assert_held(&rtwdev->mutex);
+
+	return !!rtwdev->csa_vif;
+}
+
+/* paced from the first download: a late one does not delay the next */
+static void rtw_fw_csa_queue(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
+{
+	u32 interval = ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
+	s64 delay;
+
+	rtwdev->csa_due = ktime_add_us(rtwdev->csa_due, interval);
+	delay = ktime_us_delta(rtwdev->csa_due, ktime_get());
+	ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->csa_beacon_work,
+				     usecs_to_jiffies(max(delay, 0)));
+}
+
+void rtw_fw_csa_start(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
+{
+	lockdep_assert_held(&rtwdev->mutex);
+
+	if (rtwdev->csa_vif == vif)
+		return;
+
+	rtwdev->csa_vif = vif;
+	rtwdev->csa_due = ktime_get();
+	rtw_fw_csa_queue(rtwdev, vif);
+}
+
+void rtw_fw_csa_stop(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
+{
+	lockdep_assert_held(&rtwdev->mutex);
+
+	if (!vif || rtwdev->csa_vif != vif)
+		return;
+
+	rtwdev->csa_vif = NULL;
+	cancel_delayed_work(&rtwdev->csa_beacon_work);
+}
+
 void rtw_fw_update_beacon_work(struct work_struct *work)
 {
 	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
 					      update_beacon_work);
 
 	mutex_lock(&rtwdev->mutex);
-	rtw_fw_download_rsvd_page(rtwdev);
-	rtw_send_rsvd_page_h2c(rtwdev);
+
+	/* a fetch advances the countdown, the next download carries the TIM */
+	if (!rtw_fw_csa_active(rtwdev)) {
+		rtw_fw_download_rsvd_page(rtwdev);
+		rtw_send_rsvd_page_h2c(rtwdev);
+	}
+
+	mutex_unlock(&rtwdev->mutex);
+}
+
+void rtw_fw_csa_beacon_work(struct work_struct *work)
+{
+	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
+					      csa_beacon_work.work);
+	struct ieee80211_vif *vif;
+
+	mutex_lock(&rtwdev->mutex);
+
+	vif = rtwdev->csa_vif;
+	if (!vif)
+		goto out;
+
+	if (!vif->bss_conf.csa_active) {
+		rtwdev->csa_vif = NULL;
+		goto out;
+	}
+
+	if (!ieee80211_beacon_cntdwn_is_complete(vif, 0)) {
+		rtw_fw_download_rsvd_page(rtwdev);
+		rtw_send_rsvd_page_h2c(rtwdev);
+		rtw_fw_csa_queue(rtwdev, vif);
+	} else {
+		ieee80211_csa_finish(vif, 0);
+	}
+
+out:
 	mutex_unlock(&rtwdev->mutex);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 48ad9ceab6ea..d8e58e4ed836 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -863,7 +863,11 @@ void rtw_add_rsvd_page_pno(struct rtw_dev *rtwdev,
 void rtw_add_rsvd_page_sta(struct rtw_dev *rtwdev,
 			   struct rtw_vif *rtwvif);
 int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev);
+bool rtw_fw_csa_active(struct rtw_dev *rtwdev);
+void rtw_fw_csa_start(struct rtw_dev *rtwdev, struct ieee80211_vif *vif);
+void rtw_fw_csa_stop(struct rtw_dev *rtwdev, struct ieee80211_vif *vif);
 void rtw_fw_update_beacon_work(struct work_struct *work);
+void rtw_fw_csa_beacon_work(struct work_struct *work);
 void rtw_send_rsvd_page_h2c(struct rtw_dev *rtwdev);
 int rtw_dump_drv_rsvd_page(struct rtw_dev *rtwdev,
 			   u32 offset, u32 size, u32 *buf);
diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 2a9b09fa76e7..182aecc76820 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -237,6 +237,8 @@ static void rtw_ops_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 
+	rtw_fw_csa_stop(rtwdev, vif);
+
 	rtw_leave_lps_deep(rtwdev);
 
 	rtw_txq_cleanup(rtwdev, vif->txq);
@@ -395,8 +397,11 @@ static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
 		if (vif->cfg.assoc) {
 			rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_FINISH);
 
-			rtw_fw_download_rsvd_page(rtwdev);
-			rtw_send_rsvd_page_h2c(rtwdev);
+			/* a station associating while the AP counts down */
+			if (!rtw_fw_csa_active(rtwdev)) {
+				rtw_fw_download_rsvd_page(rtwdev);
+				rtw_send_rsvd_page_h2c(rtwdev);
+			}
 			rtw_fw_default_port(rtwdev, rtwvif);
 			rtw_coex_media_status_notify(rtwdev, vif->cfg.assoc);
 			if (rtw_bf_support)
@@ -438,6 +443,11 @@ static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
 		rtw_set_dtim_period(rtwdev, conf->dtim_period);
 		rtw_fw_download_rsvd_page(rtwdev);
 		rtw_send_rsvd_page_h2c(rtwdev);
+		/* restart replay resumes it, a beacon without CSA ends it */
+		if (conf->csa_active)
+			rtw_fw_csa_start(rtwdev, vif);
+		else
+			rtw_fw_csa_stop(rtwdev, vif);
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
@@ -490,6 +500,7 @@ static void rtw_ops_stop_ap(struct ieee80211_hw *hw,
 	struct rtw_dev *rtwdev = hw->priv;
 
 	mutex_lock(&rtwdev->mutex);
+	rtw_fw_csa_stop(rtwdev, vif);
 	rtw_write32_clr(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
 	rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_DEFAULT);
 	rtwdev->ap_active = false;
@@ -556,6 +567,17 @@ static int rtw_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 	return 0;
 }
 
+static void rtw_ops_channel_switch_beacon(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  struct cfg80211_chan_def *chandef)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+
+	mutex_lock(&rtwdev->mutex);
+	rtw_fw_csa_start(rtwdev, vif);
+	mutex_unlock(&rtwdev->mutex);
+}
+
 static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 			   struct ieee80211_key_conf *key)
@@ -626,7 +648,8 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	}
 
 	/* download new cam settings for PG to backup */
-	if (rtw_get_lps_deep_mode(rtwdev) == LPS_DEEP_MODE_PG)
+	if (rtw_get_lps_deep_mode(rtwdev) == LPS_DEEP_MODE_PG &&
+	    !rtw_fw_csa_active(rtwdev))
 		rtw_fw_download_rsvd_page(rtwdev);
 
 out:
@@ -846,6 +869,7 @@ static int rtw_ops_suspend(struct ieee80211_hw *hw,
 	int ret;
 
 	mutex_lock(&rtwdev->mutex);
+	rtw_fw_csa_stop(rtwdev, rtwdev->csa_vif);
 	ret = rtw_wow_suspend(rtwdev, wowlan);
 	if (ret)
 		rtw_err(rtwdev, "failed to suspend for wow %d\n", ret);
@@ -893,20 +917,24 @@ static int rtw_ops_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct rtw_dev *rtwdev = hw->priv;
 	int ret;
 
+	guard(mutex)(&rtwdev->mutex);
+
+	/* a scan takes the AP off the channel its stations count down to */
+	if (rtw_fw_csa_active(rtwdev))
+		return -EBUSY;
+
 	if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_SCAN_OFFLOAD))
 		return 1;
 
 	if (test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
 		return -EBUSY;
 
-	mutex_lock(&rtwdev->mutex);
 	rtw_hw_scan_start(rtwdev, vif, req);
 	ret = rtw_hw_scan_offload(rtwdev, vif, true);
 	if (ret) {
 		rtw_hw_scan_abort(rtwdev);
 		rtw_err(rtwdev, "HW scan failed with status: %d\n", ret);
 	}
-	mutex_unlock(&rtwdev->mutex);
 
 	return ret;
 }
@@ -973,6 +1001,7 @@ const struct ieee80211_ops rtw_ops = {
 	.sta_add		= rtw_ops_sta_add,
 	.sta_remove		= rtw_ops_sta_remove,
 	.set_tim		= rtw_ops_set_tim,
+	.channel_switch_beacon	= rtw_ops_channel_switch_beacon,
 	.set_key		= rtw_ops_set_key,
 	.ampdu_action		= rtw_ops_ampdu_action,
 	.can_aggregate_in_amsdu	= rtw_ops_can_aggregate_in_amsdu,
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 0f23498b5c96..48e8cad221b9 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1550,11 +1550,13 @@ void rtw_core_stop(struct rtw_dev *rtwdev)
 
 	clear_bit(RTW_FLAG_RUNNING, rtwdev->flags);
 	clear_bit(RTW_FLAG_FW_RUNNING, rtwdev->flags);
+	rtwdev->csa_vif = NULL;
 
 	mutex_unlock(&rtwdev->mutex);
 
 	cancel_work_sync(&rtwdev->c2h_work);
 	cancel_work_sync(&rtwdev->update_beacon_work);
+	cancel_delayed_work_sync(&rtwdev->csa_beacon_work);
 	cancel_delayed_work_sync(&rtwdev->watch_dog_work);
 	cancel_delayed_work_sync(&coex->bt_relink_work);
 	cancel_delayed_work_sync(&coex->bt_reenable_work);
@@ -2170,6 +2172,7 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	INIT_WORK(&rtwdev->ips_work, rtw_ips_work);
 	INIT_WORK(&rtwdev->fw_recovery_work, rtw_fw_recovery_work);
 	INIT_WORK(&rtwdev->update_beacon_work, rtw_fw_update_beacon_work);
+	INIT_DELAYED_WORK(&rtwdev->csa_beacon_work, rtw_fw_csa_beacon_work);
 	INIT_WORK(&rtwdev->ba_work, rtw_txq_ba_work);
 	skb_queue_head_init(&rtwdev->c2h_queue);
 	skb_queue_head_init(&rtwdev->coex.queue);
@@ -2293,7 +2296,8 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
 	hw->wiphy->available_antennas_rx = hal->antenna_rx;
 
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
-			    WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
+			    WIPHY_FLAG_TDLS_EXTERNAL_SETUP |
+			    WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
 	hw->wiphy->features |= NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 	hw->wiphy->max_scan_ssids = RTW_SCAN_MAX_SSIDS;
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index d59f6e323adf..bc3ebfec11ae 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -2094,6 +2094,9 @@ struct rtw_dev {
 	struct work_struct ips_work;
 	struct work_struct fw_recovery_work;
 	struct work_struct update_beacon_work;
+	struct delayed_work csa_beacon_work;
+	struct ieee80211_vif *csa_vif;
+	ktime_t csa_due;
 
 	/* used to protect txqs list */
 	spinlock_t txq_lock;
-- 
2.55.0

