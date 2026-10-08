Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD593C3F70
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 06:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440504; cv=none; b=YfpC7reMx60+oW/7nUq4/5JqXIpZ46VzVlOY3h0Fpq0uWctpF2xT0YmiyNOFzk4ebzDGWSSwvlt91jt9K8qajVz9MwC1VLRgk14ATUgGAu2jdxQSAcDW7jkp5valoI1DYrfMY0usG/BfEd/guTOgAGFEqfMQdDq2Ul06o1OR3fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440504; c=relaxed/simple;
	bh=YGw1svKFwue0FWMYxanhavBgvVFAVYIZzILy2UrW3Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ircl0C5C+c4arnR/gsnwCyOHOA80fVy3IeaxrsePob2J+EevzBp4egzX4TKGzumdw07nbg8T+nrozL2jPKQNncsWLronlLNrmMiM1fui6iUHaVGEX3k/APAkfKLskdjWoUNpPIpItFaO1ZxQRiZKJuyhJ9SE2F5EFMIVTkp6OHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ik4o2BnO; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ik4o2BnO"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a166199820so1747825e9.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 23:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791440493; x=1792045293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1ppRDdUqsRWIIj/zSrXTINKlIyhIsh0J2cDhvQY1CdU=;
        b=Ik4o2BnOarXzeYikSgEA5q+oSumteHm/fiTmgrPOIed3rd1Ic5w/qeYHJrRxeT5KtG
         cs3Y+WiNXdUGZscS7TI0D3H9gnQlhrlawoPA9U3gQmbhJQmguuDLApTgk556GjNjQB18
         QM1t9juljUySZK6RVzl18DST7zV52Vld7gq7UsB/1myIcdtgalO32NxyqpdhLyunNH/5
         gQ6XvB//0LGmrvSPIDcjewcUcFvWMqHFH9GrL1Z6FYcFC8x29j8N3TO0F4AmmB9dDo5n
         AiUmDEMiCVW8NLP5Q4UVeGyyTZKouuSIjTmgbSK4FWsSxD5n4EAuB+cc1KomHDIsKDyk
         8hfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791440493; x=1792045293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1ppRDdUqsRWIIj/zSrXTINKlIyhIsh0J2cDhvQY1CdU=;
        b=FTxbkjUhEWyDi3e3ZeUNPWLpY4Pk48WSWV4dgj46YgSzCv6BLe/Dgiet+a234Duw4y
         5Orzi5pi04erNDEL67BVC5H+FWRDTt4DYlLilTZCSkOytJDscSlenGeTf21D6SUf/tWC
         JCMiRUF5mA0I+n9RsKdqj8v8+YYDhQljYVdvRdgK9ptqIslxdrKGh0suqZuxFl0GrW6z
         qsXSFxLfsPagDxD0lhxvS1+IiYUeuQddW5exXIaTooEer1P8I50iqaX57tSLFClgF8io
         mc8F4ZM2AGmOk+WJkQB0O4MKF8qGvnycyzf/x4iFoPGoQRr+X79mYRQwIu2JJb7xTmfw
         YPpQ==
X-Forwarded-Encrypted: i=1; AKwUvBzsUZuXEB5773ZsygfM9KpzVgHv+jnDgrzI38htEu3a09IMWeZ8mYAonSttZu3Ld+12j8yvwkMrZ45DIw6M+Q==@vger.kernel.org
X-Gm-Message-State: AFuF++nWhws38JFGqQma7jOYo/xRzgbM6j/I7T3JDjPAkXdgkjSafoDj
	cy5WSbG6Yb0mCf/BsGe/aq7afRbnhcu6fjCP0yCqQT7KvB7Be0gD6h24
X-Gm-Gg: AYBFou3ihbqvNGCtzuR+WNJI0vPkRG5wdTuKf+SUTTHo5asXSDLUaDa1oi7Q7nWPvMy
	JODIZfQWKAz9a5oiik28IPXFp15vIYqwDOmv+ynp5U7IS9+SP8dNpmfmx7pFO6q98v/IN/mAaOs
	b5f2SHUJ42kX+u8l86LrkSqRP52cdFQeq4D4x5mGwF+lpCovGclB8VO0Y9kpRzhouwuabzELLSZ
	0Ix3rK3o/KR1PEPNvksYwax1D5HIUNgtaPfehypdJLaoQINuFSo9pzamfCX06DdV2rDyBx2gE8X
	wTopO63SEAs560lgM/oTSyGvjR2Nq1C14gt6vv77qFb7o0VBWDa87Cdy1TVmd3WGiMY4hH6/7uN
	v/FNxl8/87O3NPcZIFEez1nCERaxEpAk9BH/kLWgpKDj7SYhOepkgfplQ074MYw+Hii8YKEUaZn
	OCLggNYDEJw0nA0SaXEsVeWD0NxZ1grTRXBZtfYHGABfhHaRhvQBwDPATxM5gxJLhx3BXEFUQzw
	4Zwlw==
X-Received: by 2002:a05:600c:3111:b0:4a0:ec5:46d9 with SMTP id 5b1f17b1804b1-4a185160ba8mr28749355e9.0.1791440493046;
        Wed, 07 Oct 2026 23:21:33 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843e3356sm40309455e9.14.2026.10.07.23.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 23:21:32 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v5 2/3] wifi: rtw88: update the beacon from a wiphy work
Date: Thu,  8 Oct 2026 08:21:28 +0200
Message-ID: <1d68c868609a8d63dc884c155023c2e100dca886.1791362281.git.mehmet.fide@screeningeagle.com>
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

set_tim() queues update_beacon_work to rebuild the reserved page with
the new TIM. Make it a wiphy work so that it runs under the wiphy lock
like the other beacon downloads and can look at mac80211 state; the
next patch needs that to tell whether a channel switch is being
announced.

rtw_core_stop() runs without the wiphy lock on the IPS path and can no
longer cancel the work, so the work checks RTW_FLAG_RUNNING under the
driver mutex instead, as the watchdog and the C2H work do.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
New in v5.

 drivers/net/wireless/realtek/rtw88/fw.c       | 10 +++++++++-
 drivers/net/wireless/realtek/rtw88/fw.h       |  2 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c |  2 +-
 drivers/net/wireless/realtek/rtw88/main.c     |  4 ++--
 drivers/net/wireless/realtek/rtw88/main.h     |  2 +-
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 3cd17a3bb494..e01d79a70e37 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1802,14 +1802,22 @@ int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev)
 	return ret;
 }
 
-void rtw_fw_update_beacon_work(struct work_struct *work)
+void rtw_fw_update_beacon_work(struct wiphy *wiphy, struct wiphy_work *work)
 {
 	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
 					      update_beacon_work);
 
+	lockdep_assert_wiphy(wiphy);
+
 	mutex_lock(&rtwdev->mutex);
+
+	if (!test_bit(RTW_FLAG_RUNNING, rtwdev->flags))
+		goto out;
+
 	rtw_fw_download_rsvd_page(rtwdev);
 	rtw_send_rsvd_page_h2c(rtwdev);
+
+out:
 	mutex_unlock(&rtwdev->mutex);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 48ad9ceab6ea..d433f454094d 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -863,7 +863,7 @@ void rtw_add_rsvd_page_pno(struct rtw_dev *rtwdev,
 void rtw_add_rsvd_page_sta(struct rtw_dev *rtwdev,
 			   struct rtw_vif *rtwvif);
 int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev);
-void rtw_fw_update_beacon_work(struct work_struct *work);
+void rtw_fw_update_beacon_work(struct wiphy *wiphy, struct wiphy_work *work);
 void rtw_send_rsvd_page_h2c(struct rtw_dev *rtwdev);
 int rtw_dump_drv_rsvd_page(struct rtw_dev *rtwdev,
 			   u32 offset, u32 size, u32 *buf);
diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 2a9b09fa76e7..7fcf91bfe761 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -551,7 +551,7 @@ static int rtw_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 {
 	struct rtw_dev *rtwdev = hw->priv;
 
-	ieee80211_queue_work(hw, &rtwdev->update_beacon_work);
+	wiphy_work_queue(hw->wiphy, &rtwdev->update_beacon_work);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 0f23498b5c96..647393af9fd9 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1554,7 +1554,6 @@ void rtw_core_stop(struct rtw_dev *rtwdev)
 	mutex_unlock(&rtwdev->mutex);
 
 	cancel_work_sync(&rtwdev->c2h_work);
-	cancel_work_sync(&rtwdev->update_beacon_work);
 	cancel_delayed_work_sync(&rtwdev->watch_dog_work);
 	cancel_delayed_work_sync(&coex->bt_relink_work);
 	cancel_delayed_work_sync(&coex->bt_reenable_work);
@@ -2169,7 +2168,8 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	INIT_WORK(&rtwdev->c2h_work, rtw_c2h_work);
 	INIT_WORK(&rtwdev->ips_work, rtw_ips_work);
 	INIT_WORK(&rtwdev->fw_recovery_work, rtw_fw_recovery_work);
-	INIT_WORK(&rtwdev->update_beacon_work, rtw_fw_update_beacon_work);
+	wiphy_work_init(&rtwdev->update_beacon_work,
+			rtw_fw_update_beacon_work);
 	INIT_WORK(&rtwdev->ba_work, rtw_txq_ba_work);
 	skb_queue_head_init(&rtwdev->c2h_queue);
 	skb_queue_head_init(&rtwdev->coex.queue);
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index d59f6e323adf..bb48529759c3 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -2093,7 +2093,7 @@ struct rtw_dev {
 	struct work_struct c2h_work;
 	struct work_struct ips_work;
 	struct work_struct fw_recovery_work;
-	struct work_struct update_beacon_work;
+	struct wiphy_work update_beacon_work;
 
 	/* used to protect txqs list */
 	spinlock_t txq_lock;
-- 
2.55.0

