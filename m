Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028585;
	b=nwKFIx5B3ik/T3drPB2lWv9SUgD0MVoaIuB+dcBr5H3wkORZ20C1UzWpk8dCf6hcZ7Vs
	 SiXguPqC7KXVYmCL9B6Yv5el4OzQDA8aiAgqvCgEWMbnN6/L0R0ejctAENhbohtbdsmGO
	 aqzY4UKQYV9aNkOeP88+8p6YCJuXKLtq0doY+1jDvMYyehcQtjJH8Y5QGXF10JSRKdVDt
	 6DzMcDPHQcANLDp6sAi6asdB2l4yriPvk/PRJMP3KP0ZeOL9D4fkq1YXf80WhhuhvHNsm
	 BE1HBhye3RcLLD4yEJMzThZQwNZpeYokQwQD7J2uN+twTEEor6qHvMgDc44+Z/8RN8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028585;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gPJidK4e1M0Itom4Ks3lIKKWfsaHDaCgWVv/3BV1W7w=;
	b=ExIzezOkw21vrapeXZDlpUt2P7zApkhMeL5T766ClDYlsnT13iF++rKN/+ix3o6wyaFj
	 h8Xk3sR4R/5/Lyqv8jhpKw1h6xbsBnYhTK+5VcaL4eHq5IyFTTDO4KO43K08bWtmOmtwI
	 bvukyauk3tS+B17eyL7Z+LcByvgiJXPujST26Av0v7NE758Wi/AWyV1sslD38n/lgavpH
	 plElAeoRfLiJIECyji7TTnYdOL+JoYyIZK9a6dZcJC1FTNMjGB71HwJHZrXCdCVlJWIOm
	 g4cd8BBEQP8okA8GawjAiP8wV+z7WkO25xh/DhwU00mF/CSj01zDNwexWVG8uOUuuqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="fkOWB/Jn";
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B586606A335
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B586606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fkOWB/Jn
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso31874445e9.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 08:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793028584; x=1793633384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gPJidK4e1M0Itom4Ks3lIKKWfsaHDaCgWVv/3BV1W7w=;
        b=fkOWB/JnjtiHyT9UOowPR1JvIO4fh/u/aWdS5s/6JBs9rqWb2jzCNgOGDyDc3fLKHf
         /Bb/eZ5a6/9N+DCDqTo8S4XnzF3vL5uZFt7bXOxbpLfPUJ90Y9LTuhZiMyw54fnR8VRX
         0CZYtFtyWRF8EyTrO+E4CF+wPNpsmLwP2dmonWTCClybi0HS8BfxBklgBi6YMZ5JkRy4
         ClGPsLVJwXNCF2MCZYq54pnovPkuUW3kJjLM8OKZvQnyAxLnzja5yzKlfCDE7QLAWvLw
         K80sbahcxDExlQPmLsmqIzNPl0/6dLPTbHUm3uil1Gbx7NDDoFfbD6iFwsERUkOzmZLY
         EHLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793028584; x=1793633384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gPJidK4e1M0Itom4Ks3lIKKWfsaHDaCgWVv/3BV1W7w=;
        b=s53Zi1JZ9WYh8T3WrtUZRyFNFoDrs2m1TFwfFnhCh5c3rRmxnb+gmUzX8NZiYBI/yM
         abZZpSZvx/9F9VEtQ2fhiUyk2RO7jvItWT8M25aaxeSTfa4HxXU1GG/4e39HMxN6GbD5
         LfU1raOKGHgl7lwZqLmSDV+GeiqCp0b0BIXAEM7V+86DNUAhAQzPyTXqqhl44nSPSd6T
         bt/vp4aRsNMlVcu3ktO7xYmHo2TJfktOEdoHlcx/CXPSz8vPbFxnqoeUzKeAmhKpZaKr
         lCRvZ4TjqrKbm6zVIyWQFerBwaVVRQ3RNcqGSQLitPz8XJ2Hwf7DEUEIADlKomOBElVS
         c+Ag==
X-Forwarded-Encrypted: i=1; AKwUvBz2yJVwyKDvrb7+pw5L98liW1FDNwRftjvECObLq3++/q4ALFGZTsJw8B9vJpo6loE/GEYsrIQmLx9dufmP7Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYKVCeHX5gZUTVp91pv5vO8bNKRcgRsf41Uido/VUrPigUqST3QZ
	h1PHjEm//XL2dS20tLIaiZC4wbW7Jo/NnRZZbCk2GP+UcrIj5/rSJ+gS
X-Gm-Gg: AYBFou2nC3opWSZ+/uSTxcz7LIllqNpRUJgKqELCwhALcedEirsNeV+to3FH4jcmlGI
	nQSN/jMWPDUfX3ZPyGp08yV+mhh1qy9DMtOYG+twZB5WHZruE2HEWMIfQrThv9j0FKSuGJqRjz2
	dJ9k+g0ok0cpkQRQVlWOHUHgmEM8tMhvAjlu3mQdPNzcAwGDMyKPi3nEkq/8ILR9RotsgwyGbfN
	TgJgCj2TUn9DNZQ9miyvIUFI4DRRZf3Pwg/NLFgHw5qq7QbEzZxMkZeRqCjSW6trNsTLz+0cegV
	4ZPDBV6b6T8B2JSpxwSXERv3lJl5nlWUwGXhIE+jR8TaZSvGvyTOjZ9ORj+sJKX0EIla0S+fFb5
	CBg4qiKdFVRUJxTrtwzaQ8GeyeO04iM/R2dAnAHxJ0dNymYmNnJ1USJwn7nXSFvS+g4J5ptyVkM
	7bbA6mzTwCe45GWSoE2w4IYGcliceKMaKibPfHBPQ8FuL2B17DqoANWjAu/n4BlxGJNBVgPuq4q
	Og4T7bS+C44ipZBOEDmokG82A4PaidRLL394ZefMW3c11UZi/PjcZ/3pfHHvw==
X-Received: by 2002:a05:600c:1391:b0:4a2:74f:46c1 with SMTP id 5b1f17b1804b1-4a35acafef9mr137242705e9.8.1793028583596;
        Mon, 26 Oct 2026 08:29:43 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd4ba7sm17255244f8f.33.2026.10.26.08.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:29:43 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v9 2/3] wifi: rtw88: support channel switch in AP mode
Date: Mon, 26 Oct 2026 16:29:39 +0100
Message-ID: <20261026152940.1274382-3-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261026152940.1274382-1-mehmet.fide@gmail.com>
References: <20261026152940.1274382-1-mehmet.fide@gmail.com>
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
resumes it, and so does the driver after a WoWLAN resume, which mac80211
follows with no replay. The other page downloads during a countdown, the
TIM update, the PG backup and the one on association, are skipped until
the beacon after the switch, since every beacon fetch advances the
countdown; the next download carries their changes. A scan is refused:
it would take the AP off the channel its stations count down to.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---

Notes:
    Changes in v9:
    - the countdown starts again after a WoWLAN resume that worked, which
      mac80211 follows with no replay (Luka)
    - Acked-by from Ping-Ke dropped for the new code
    
    Changes in v8:
    - Acked-by from Ping-Ke
    
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
 drivers/net/wireless/realtek/rtw88/mac80211.c | 50 ++++++++++--
 drivers/net/wireless/realtek/rtw88/main.c     |  6 +-
 drivers/net/wireless/realtek/rtw88/main.h     |  3 +
 5 files changed, 135 insertions(+), 8 deletions(-)

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
index 2a9b09fa76e7..87d9855fa62d 100644
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
@@ -854,6 +878,15 @@ static int rtw_ops_suspend(struct ieee80211_hw *hw,
 	return ret ? 1 : 0;
 }
 
+static void rtw_ops_csa_resume_iter(void *data, struct ieee80211_vif *vif)
+{
+	struct rtw_dev *rtwdev = data;
+
+	if ((vif->type == NL80211_IFTYPE_AP ||
+	     vif->type == NL80211_IFTYPE_ADHOC) && vif->bss_conf.csa_active)
+		rtw_fw_csa_start(rtwdev, vif);
+}
+
 static int rtw_ops_resume(struct ieee80211_hw *hw)
 {
 	struct rtw_dev *rtwdev = hw->priv;
@@ -863,6 +896,8 @@ static int rtw_ops_resume(struct ieee80211_hw *hw)
 	ret = rtw_wow_resume(rtwdev);
 	if (ret)
 		rtw_err(rtwdev, "failed to resume for wow %d\n", ret);
+	else
+		rtw_iterate_vifs(rtwdev, rtw_ops_csa_resume_iter, rtwdev);
 	mutex_unlock(&rtwdev->mutex);
 
 	return ret ? 1 : 0;
@@ -893,20 +928,24 @@ static int rtw_ops_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
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
@@ -973,6 +1012,7 @@ const struct ieee80211_ops rtw_ops = {
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

