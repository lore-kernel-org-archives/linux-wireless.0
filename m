Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1C13C4554
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 06:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440501; cv=none; b=Kcuhddczz1w345Gt96fw/t0icVeO0WcX1Te978kGa1ZZWKdV2s8p9OMfRddry1hkeMYM23pH5f1uSXhyu7P0OMZ4LRRInUWNpiLIhV3qqVAGx9EAv6LXQ/5NLhVF9IwVbrO5FNf+ixlgrvoWcxttsbu0WDNhsJ2VPiLSpgm6gQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440501; c=relaxed/simple;
	bh=0YXuiS2uWAfEgDMmwsrway/CMkiXSViY/zsJHrIizE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxFhdPyMI7doH9cpFkCJpmCGswV+flyfpSGjCAg6XqapMMJ0UbjUS7nDsYSRB5Y+NVzwhW8JlC7m0ZtFzVU97cOQgXZZdoaK8YloKKk11/G2XD8u1teKIjwSu+nwyymhh6oUwdZlZ9TVJkVKeIF1hx6olc5efAju8l6AR5r27h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=popYrbX5; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="popYrbX5"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a02667ccebso20884125e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 23:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791440494; x=1792045294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JdLkzItkJAxQXZF+sDNei3qCrjcY9XFOPY/2G4NxGWU=;
        b=popYrbX5jZClTgh5R77pADuKSmU9oFtc/J6Ng0MKrXLRJLPiKQkfiTnRs2vu+MQwGN
         YB6jKy5hT8C1GM1TJtQui9VYNR1quhQTlZXekYU288hRAqcAJZk5QT8vH0bH+UFneyVC
         t/fRTNq5v1h4AG2eImjFKJT45tYWZbPVAFKCuag9gIVb8E0BKJOSFpbWuhtuJqdqs1t2
         IbQzme6EsnO2lAKnFHAWw3flGW0Asa17fKDIK+0VLfOgQ6yfcSZuiQ7iPBlit77krJmP
         p4ubEtcVsRLrCKtGVtuCjS2bska6pUgQfe7/p7Xoa0px9NZM0rSEfq8dwsVaCPd2oGNe
         /Q0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791440494; x=1792045294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JdLkzItkJAxQXZF+sDNei3qCrjcY9XFOPY/2G4NxGWU=;
        b=Vp+zX//Xah6f3TqhgzSFDJ6czl2vwQkI6Kk3TQyxi6GWbzxS5b7MfbUBST0qn1eC4A
         t+zjYbxWd2r8k+xzI7w9mjXFB2csu8YpiZUO8I1Dlaxj6J66HctvG+B9CbSSBs+i69r6
         I85YI6yqI2EjQOK/SJkVcrjzUUOo60vHMqYxWtuH1RfZWtVW4u63MsrOzJwSrWXHOyXY
         cT/VsBC3SYmHQi4FbXgkyW2iHAOSUANB86JTLhiBCi8eyg1/5OWYdn6cD/07RCrDoHYl
         KZ8JtRLkUipeTwfANV8aolU/Ms+ugLLOcZpZfboz1QbVplb3zi8EzdfFsUc52bXcQ5Eg
         4MQw==
X-Forwarded-Encrypted: i=1; AKwUvBxPemEXQLG73k5IdUbSgxIRjDkjwzexxtkRUlLeC0DdEAmVU24f9njsNEvRZuuO+KfnDbgcoWULfqlHVJHV0A==@vger.kernel.org
X-Gm-Message-State: AFuF++ljkV96bb/qNhRz8EBz7uWQcqKF2HoSII0rK/fOP0f//uQi/He0
	AqRPsrN5Ysz9Qc83IwvzeRZvpuk18DOWbrbwxFgu7fCO6NkVNiiRVtvJ
X-Gm-Gg: AYBFou3aiGr4MXQ1sLr1WgfuXfvxWvQINJr1Tyg7Fe7iYvUGjqhoEP4t3OUvUp/EJ8z
	YEmxerwTbbdbnHyT4V6uVXbyrnuDT89gJMzfi6MJlQXBcxm7EiJcGN4qB8vDOJc6ChUKjzca4dW
	TUgqqMWaglsubNpXVqDD47TlCE+a3YrrgMI7z9euxFEBgAmXi4qsl4VFla/qIN/HlJX1U7jseUU
	1XMF4iefGApUG3jGkG8XrnGn7/ss5Pj0JabGG2K7xLfGxzoY7bQi4U4rURZjMTtlxfGtHsjkhAu
	3Ph5w5yKLJT2u7JqmybtSM+QcGH7jM7DmaAckB1IEhB1O9OSCKnk3aBj3IcuLPtFpavYdPQhsmd
	YvlhQ4OJkWHP8CLGEsGYtRSYvr/qS9bR6o7/YeOLgiYRZcrnRWXZRUNPp4JSzMQPlOvxwk/R6yS
	SMzHVklNPeGRuhOjxxxkI1bqH1PGUVa27aACUtkSJPAz0Ib3yq2gzNk2E0J78QgAhBddBKHtZZA
	hfGHKsSFBXKeAQ=
X-Received: by 2002:a05:600c:a00e:b0:4a0:1a18:b742 with SMTP id 5b1f17b1804b1-4a1800d3de4mr82390155e9.2.1791440493932;
        Wed, 07 Oct 2026 23:21:33 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843e3356sm40309455e9.14.2026.10.07.23.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 23:21:33 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v5 3/3] wifi: rtw88: support channel switch in AP mode
Date: Thu,  8 Oct 2026 08:21:29 +0200
Message-ID: <ab6a510713267fee446e511c87d5b162827353fb.1791362281.git.mehmet.fide@screeningeagle.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791362281.git.mehmet.fide@screeningeagle.com>
References: <cover.1791362281.git.mehmet.fide@screeningeagle.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

hostapd's CHAN_SWITCH is refused because the driver does not announce
channel switch support, so an AP on rtw88 can only change its channel
by being torn down and started again.

Declare WIPHY_FLAG_HAS_CHANNEL_SWITCH and implement
ieee80211_ops::channel_switch_beacon: the firmware repeats the beacon
held in the first reserved page, so while a switch is announced the
page is downloaded again every beacon interval to renew the countdown,
and ieee80211_csa_finish() is called once it completes. IBSS, which
the flag enables too, shares the page and the work.

The work is a wiphy delayed work of the device and csa_vif names the
interface it counts down for; the wiphy lock serializes the work with
the mac80211 state it reads and the driver mutex with the page build.
The countdown is cancelled when the AP stops, when the interface goes
away, on WoWLAN suspend and before a firmware recovery restarts the
hardware. The other page downloads that can run
during a countdown, the TIM update, the PG backup on set_key and the
one on association, are skipped then, since every beacon fetch
advances the countdown; the next countdown download, at most one
beacon interval later, carries their changes. A scan is refused while
a switch is announced, before the fallback to a software scan: it
would take the AP off the channel its stations count down to.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
Changes in v5:
- rtw_fw_csa_active/start/stop() assert the wiphy lock
- hw_scan() takes the mutex with guard()
- the ASSOC path says why it skips the download: the STA+AP combination
Changes in v4:
- the work and csa_vif live in rtw_dev; no lookup through the reserved page
- the countdown is stopped before a firmware recovery restarts the hardware
- a scan is refused while a switch is announced
- one beacon fetch per interval during the countdown

 drivers/net/wireless/realtek/rtw88/fw.c       | 65 ++++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/fw.h       |  4 ++
 drivers/net/wireless/realtek/rtw88/mac80211.c | 34 ++++++++--
 drivers/net/wireless/realtek/rtw88/main.c     |  9 ++-
 drivers/net/wireless/realtek/rtw88/main.h     |  2 +
 5 files changed, 107 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index e01d79a70e37..16319233c9cc 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1802,6 +1802,35 @@ int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev)
 	return ret;
 }
 
+bool rtw_fw_csa_active(struct rtw_dev *rtwdev)
+{
+	lockdep_assert_wiphy(rtwdev->hw->wiphy);
+
+	return rtwdev->csa_vif && rtwdev->csa_vif->bss_conf.csa_active;
+}
+
+void rtw_fw_csa_start(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
+{
+	u32 interval = ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
+
+	lockdep_assert_wiphy(rtwdev->hw->wiphy);
+
+	rtwdev->csa_vif = vif;
+	wiphy_delayed_work_queue(rtwdev->hw->wiphy, &rtwdev->csa_beacon_work,
+				 usecs_to_jiffies(interval));
+}
+
+void rtw_fw_csa_stop(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
+{
+	lockdep_assert_wiphy(rtwdev->hw->wiphy);
+
+	if (!vif || rtwdev->csa_vif != vif)
+		return;
+
+	wiphy_delayed_work_cancel(rtwdev->hw->wiphy, &rtwdev->csa_beacon_work);
+	rtwdev->csa_vif = NULL;
+}
+
 void rtw_fw_update_beacon_work(struct wiphy *wiphy, struct wiphy_work *work)
 {
 	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
@@ -1811,7 +1840,8 @@ void rtw_fw_update_beacon_work(struct wiphy *wiphy, struct wiphy_work *work)
 
 	mutex_lock(&rtwdev->mutex);
 
-	if (!test_bit(RTW_FLAG_RUNNING, rtwdev->flags))
+	if (!test_bit(RTW_FLAG_RUNNING, rtwdev->flags) ||
+	    rtw_fw_csa_active(rtwdev))
 		goto out;
 
 	rtw_fw_download_rsvd_page(rtwdev);
@@ -1821,6 +1851,39 @@ void rtw_fw_update_beacon_work(struct wiphy *wiphy, struct wiphy_work *work)
 	mutex_unlock(&rtwdev->mutex);
 }
 
+void rtw_fw_csa_beacon_work(struct wiphy *wiphy, struct wiphy_work *work)
+{
+	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
+					      csa_beacon_work.work);
+	struct ieee80211_vif *vif = rtwdev->csa_vif;
+	unsigned int delay;
+
+	lockdep_assert_wiphy(wiphy);
+
+	mutex_lock(&rtwdev->mutex);
+
+	if (!vif->bss_conf.csa_active) {
+		rtwdev->csa_vif = NULL;
+		goto out;
+	}
+
+	delay = ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
+
+	if (!ieee80211_beacon_cntdwn_is_complete(vif, 0)) {
+		rtw_fw_download_rsvd_page(rtwdev);
+		rtw_send_rsvd_page_h2c(rtwdev);
+
+		wiphy_delayed_work_queue(wiphy, &rtwdev->csa_beacon_work,
+					 usecs_to_jiffies(delay));
+	} else {
+		rtwdev->csa_vif = NULL;
+		ieee80211_csa_finish(vif, 0);
+	}
+
+out:
+	mutex_unlock(&rtwdev->mutex);
+}
+
 static void rtw_fw_read_fifo_page(struct rtw_dev *rtwdev, u32 offset, u32 size,
 				  u32 *buf, u32 residue, u16 start_pg)
 {
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index d433f454094d..7277af739d9e 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -863,7 +863,11 @@ void rtw_add_rsvd_page_pno(struct rtw_dev *rtwdev,
 void rtw_add_rsvd_page_sta(struct rtw_dev *rtwdev,
 			   struct rtw_vif *rtwvif);
 int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev);
+bool rtw_fw_csa_active(struct rtw_dev *rtwdev);
+void rtw_fw_csa_start(struct rtw_dev *rtwdev, struct ieee80211_vif *vif);
+void rtw_fw_csa_stop(struct rtw_dev *rtwdev, struct ieee80211_vif *vif);
 void rtw_fw_update_beacon_work(struct wiphy *wiphy, struct wiphy_work *work);
+void rtw_fw_csa_beacon_work(struct wiphy *wiphy, struct wiphy_work *work);
 void rtw_send_rsvd_page_h2c(struct rtw_dev *rtwdev);
 int rtw_dump_drv_rsvd_page(struct rtw_dev *rtwdev,
 			   u32 offset, u32 size, u32 *buf);
diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 7fcf91bfe761..d99564353a0b 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -235,6 +235,8 @@ static void rtw_ops_remove_interface(struct ieee80211_hw *hw,
 	rtw_dbg(rtwdev, RTW_DBG_STATE, "stop vif %pM mac_id %d on port %d\n",
 		vif->addr, rtwvif->mac_id, rtwvif->port);
 
+	rtw_fw_csa_stop(rtwdev, vif);
+
 	mutex_lock(&rtwdev->mutex);
 
 	rtw_leave_lps_deep(rtwdev);
@@ -395,8 +397,11 @@ static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
 		if (vif->cfg.assoc) {
 			rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_FINISH);
 
-			rtw_fw_download_rsvd_page(rtwdev);
-			rtw_send_rsvd_page_h2c(rtwdev);
+			/* a station of the STA+AP combination: keep the AP's countdown */
+			if (!rtw_fw_csa_active(rtwdev)) {
+				rtw_fw_download_rsvd_page(rtwdev);
+				rtw_send_rsvd_page_h2c(rtwdev);
+			}
 			rtw_fw_default_port(rtwdev, rtwvif);
 			rtw_coex_media_status_notify(rtwdev, vif->cfg.assoc);
 			if (rtw_bf_support)
@@ -438,6 +443,8 @@ static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
 		rtw_set_dtim_period(rtwdev, conf->dtim_period);
 		rtw_fw_download_rsvd_page(rtwdev);
 		rtw_send_rsvd_page_h2c(rtwdev);
+		if (conf->csa_active)
+			rtw_fw_csa_start(rtwdev, vif);
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
@@ -489,6 +496,8 @@ static void rtw_ops_stop_ap(struct ieee80211_hw *hw,
 {
 	struct rtw_dev *rtwdev = hw->priv;
 
+	rtw_fw_csa_stop(rtwdev, vif);
+
 	mutex_lock(&rtwdev->mutex);
 	rtw_write32_clr(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
 	rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_DEFAULT);
@@ -556,6 +565,15 @@ static int rtw_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 	return 0;
 }
 
+static void rtw_ops_channel_switch_beacon(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  struct cfg80211_chan_def *chandef)
+{
+	struct rtw_dev *rtwdev = hw->priv;
+
+	rtw_fw_csa_start(rtwdev, vif);
+}
+
 static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 			   struct ieee80211_key_conf *key)
@@ -626,7 +644,8 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	}
 
 	/* download new cam settings for PG to backup */
-	if (rtw_get_lps_deep_mode(rtwdev) == LPS_DEEP_MODE_PG)
+	if (rtw_get_lps_deep_mode(rtwdev) == LPS_DEEP_MODE_PG &&
+	    !rtw_fw_csa_active(rtwdev))
 		rtw_fw_download_rsvd_page(rtwdev);
 
 out:
@@ -846,6 +865,7 @@ static int rtw_ops_suspend(struct ieee80211_hw *hw,
 	int ret;
 
 	mutex_lock(&rtwdev->mutex);
+	rtw_fw_csa_stop(rtwdev, rtwdev->csa_vif);
 	ret = rtw_wow_suspend(rtwdev, wowlan);
 	if (ret)
 		rtw_err(rtwdev, "failed to suspend for wow %d\n", ret);
@@ -893,20 +913,23 @@ static int rtw_ops_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct rtw_dev *rtwdev = hw->priv;
 	int ret;
 
+	guard(mutex)(&rtwdev->mutex);
+
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
@@ -973,6 +996,7 @@ const struct ieee80211_ops rtw_ops = {
 	.sta_add		= rtw_ops_sta_add,
 	.sta_remove		= rtw_ops_sta_remove,
 	.set_tim		= rtw_ops_set_tim,
+	.channel_switch_beacon	= rtw_ops_channel_switch_beacon,
 	.set_key		= rtw_ops_set_key,
 	.ampdu_action		= rtw_ops_ampdu_action,
 	.can_aggregate_in_amsdu	= rtw_ops_can_aggregate_in_amsdu,
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 647393af9fd9..e3bbfbc9d976 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -676,6 +676,10 @@ static void rtw_fw_recovery_work(struct work_struct *work)
 	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
 					      fw_recovery_work);
 
+	wiphy_lock(rtwdev->hw->wiphy);
+	rtw_fw_csa_stop(rtwdev, rtwdev->csa_vif);
+	wiphy_unlock(rtwdev->hw->wiphy);
+
 	mutex_lock(&rtwdev->mutex);
 	__fw_recovery_work(rtwdev);
 	mutex_unlock(&rtwdev->mutex);
@@ -2170,6 +2174,8 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	INIT_WORK(&rtwdev->fw_recovery_work, rtw_fw_recovery_work);
 	wiphy_work_init(&rtwdev->update_beacon_work,
 			rtw_fw_update_beacon_work);
+	wiphy_delayed_work_init(&rtwdev->csa_beacon_work,
+				rtw_fw_csa_beacon_work);
 	INIT_WORK(&rtwdev->ba_work, rtw_txq_ba_work);
 	skb_queue_head_init(&rtwdev->c2h_queue);
 	skb_queue_head_init(&rtwdev->coex.queue);
@@ -2293,7 +2299,8 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
 	hw->wiphy->available_antennas_rx = hal->antenna_rx;
 
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
-			    WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
+			    WIPHY_FLAG_TDLS_EXTERNAL_SETUP |
+			    WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
 	hw->wiphy->features |= NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 	hw->wiphy->max_scan_ssids = RTW_SCAN_MAX_SSIDS;
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index bb48529759c3..a39416272cff 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -2094,6 +2094,8 @@ struct rtw_dev {
 	struct work_struct ips_work;
 	struct work_struct fw_recovery_work;
 	struct wiphy_work update_beacon_work;
+	struct wiphy_delayed_work csa_beacon_work;
+	struct ieee80211_vif *csa_vif;
 
 	/* used to protect txqs list */
 	spinlock_t txq_lock;
-- 
2.55.0

