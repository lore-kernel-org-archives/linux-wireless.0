Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C349C524B1E
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 12:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790685848; cv=none; b=s/Rbhavl7m7WjtYEFtB1OOOh+AMtf3RAnXt8RyDqe24x2vwmU0qhP/l8HBCAAYCmHMYD5VALtaF0n09ZKSYNRL98xKnwWTtsseiD+fku/cGkKXydDM7S79Dil4+/XQfey3Vf5kzNt8l1r1qSHJa5hn5wUY3gbSDhEH8BVoIABSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790685848; c=relaxed/simple;
	bh=j06Ol8IPYxL2GWLy9zi4VaMa2xDFt7ySvCchcoxRVpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QslXZME/O7XwlBqro9gzsBf6w3KQb+xF88DQL/F8cF/Q0CSx7bbtobmwb+wQ0gXzuOq/wQYQ9mB7M3Zc1nThcROd7xO9Su0aGRQtJG4hguvihZQL/6RlMyuN6rXnR/93/lXKvkFkkTa5m7EJCDH7wHZaz/fHvbwYp9cHT5CHwwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e2rNCJ0d; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e2rNCJ0d"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e66390995so23288525e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 05:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790685845; x=1791290645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zx7HPL5INHSosIjFX/PO62kFSLqfe3KIXe6VSdyiW+w=;
        b=e2rNCJ0dZv5EN7+A9XSITKwXP3RWmBYiRq+UXdlyI0YLWnZ2RQocmgamLWl/nlE/Si
         4U17SdyD0lEg6cmjiwLb5xuwh2aom6r26ufKf2JwUxs/ch4bVUEG3hZXWW+FKZZj6l2l
         D8z91h+iVtVLlY3fA64awJEkRDYaleRAtQOZJx9Ge30p4VzC5ZOl0+QiaYptXpIWMAtR
         SW+o5oT8sewb1iWQZ3I1zbvKKtzrQYOfci2/r9vPeFvpvBcXn6gl8B1Fx53ybLRcX5nb
         huMNzkUq8N4LNoO/lNNcEM2Ay/D7VCiuiN6daSQzD8JCtH4x9Xy1mBSRQnchsK0jGaST
         LVWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790685845; x=1791290645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zx7HPL5INHSosIjFX/PO62kFSLqfe3KIXe6VSdyiW+w=;
        b=GONb5YLN6wcZp9G7BNRV1oGerfLzzlWOGPrlXeuhBmJPjW2MvSvKHlnhN5Vi5Y1IzC
         /aq4kRYtl1vky6K21TfXc3CbstZDrD2fX4rE7V3TJZu/vMl8ikwZn+B/O33/c+umG1w2
         5HWjfFjZ66lwKY9GJKMXwy7akdqmheO8VOBtsaaglqQQGh7nS1jpN8qfadn0jPoBsvuJ
         bhYMNp9XlqsSmuHjprhp4gd2wY2Dpwg2BsQht7CE6DzMza1eJspexCUWtB98Emz6y8Rs
         AEsh3YkTH62I6BN+P7VJn+zQ5n7iFGfb5BFQ4km3dHL/4o8MRSdCEZLQ8sBStGsIv5zL
         kdxA==
X-Forwarded-Encrypted: i=1; AKwUvBwaQIw9HoIbUbvmaayqSPJzwcD9vMNpqROgh8QcvFH9vWKdZwErIqS0VwGIuzI5isTIwBHGRbHf+/hIVBXXqg==@vger.kernel.org
X-Gm-Message-State: AFuF++mQBxsh8mEOTDUG3KLe6+oK4jEMZojpeaHFQaDw1XUTR0Fk29Zh
	fzZVVuBo8G9oYYYc1qklj1Xwdt1lHo71nzMHPl9IdBXBVYGl9ewlHFdytyqyRw==
X-Gm-Gg: AYBFou01dhiLz4Z/52XEMjDCfmdBg/mC3rcMlj/lXHn2Kzcvz3e0ROlfVUwOA5+X1OJ
	c4fo/4hOImijsAMPLFCxglxn8USjYkEP1tE762VsKgT040y51O42iFytqS89/lo5Qg037DoiC+K
	UBTh/f7PqZp2B1Vw67N83AOt6r9ugR356QI8I0Zq1DbktDj/U8gEp4IFyBqfvddPz2XDH5NGyx9
	CclH0RdBql3D89rKrPlASCsJjCmL84W3zmttXqlFn1Myg+J0Dd9DYQuQwfitSHJsQfqubK8VfvQ
	t2V4uJ7ZKKFST8jNzKbi8qyjEIxZ6j6gxKmzhT3YQWm7IOm2kXqowgrqgMbrN1enUy9VCOzgdUY
	ZX08JoCXhKp4pqgU8UDdxCpWFX0U7oisUi+19YVHwJ1FuwUnd7gh6nb+L/AiuulfgC0+YiOU3GP
	M+baVQ8DVqfVx842lJTCoxu5MqfBVB1XindXGSEvAM0MCyZpK8W4orJ6IM5QK39cquDlq2fTagL
	h9U
X-Received: by 2002:a05:600c:a30b:b0:49f:faa3:3ca2 with SMTP id 5b1f17b1804b1-49ffaa33f7amr124253555e9.13.1790685844806;
        Tue, 29 Sep 2026 05:44:04 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a012387337sm33002265e9.8.2026.09.29.05.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 05:44:03 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next 2/2] wifi: rtw88: support channel switch in AP mode
Date: Tue, 29 Sep 2026 14:44:00 +0200
Message-ID: <20260929124400.3856049-3-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929124400.3856049-1-mehmet.fide@gmail.com>
References: <20260929124400.3856049-1-mehmet.fide@gmail.com>
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
ieee80211_ops::channel_switch_beacon the way rtw89 does: the firmware
repeats the beacon held in the reserved page, so while a switch is
announced the beacon is downloaded again every beacon interval to renew
the countdown, and ieee80211_csa_finish() is called once it completes.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
 drivers/net/wireless/realtek/rtw88/fw.c       | 29 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/fw.h       |  1 +
 drivers/net/wireless/realtek/rtw88/mac80211.c | 14 +++++++++
 drivers/net/wireless/realtek/rtw88/main.c     |  3 +-
 drivers/net/wireless/realtek/rtw88/main.h     |  2 ++
 5 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index a4400ff51372..20f24086dd8c 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1812,6 +1812,35 @@ void rtw_fw_update_beacon_work(struct work_struct *work)
 	mutex_unlock(&rtwdev->mutex);
 }
 
+void rtw_fw_csa_beacon_work(struct work_struct *work)
+{
+	struct rtw_vif *rtwvif = container_of(work, struct rtw_vif,
+					      csa_beacon_work.work);
+	struct ieee80211_vif *vif = rtwvif_to_vif(rtwvif);
+	struct rtw_dev *rtwdev = rtwvif->rtwdev;
+	unsigned int delay;
+
+	mutex_lock(&rtwdev->mutex);
+
+	if (rtwvif->net_type != RTW_NET_AP_MODE || !vif->bss_conf.csa_active)
+		goto out;
+
+	delay = ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
+
+	if (!ieee80211_beacon_cntdwn_is_complete(vif, 0)) {
+		rtw_fw_download_rsvd_page(rtwdev);
+		rtw_send_rsvd_page_h2c(rtwdev);
+
+		ieee80211_queue_delayed_work(rtwdev->hw, &rtwvif->csa_beacon_work,
+					     usecs_to_jiffies(delay));
+	} else {
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
index 48ad9ceab6ea..0aaac8458ccd 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -864,6 +864,7 @@ void rtw_add_rsvd_page_sta(struct rtw_dev *rtwdev,
 			   struct rtw_vif *rtwvif);
 int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev);
 void rtw_fw_update_beacon_work(struct work_struct *work);
+void rtw_fw_csa_beacon_work(struct work_struct *work);
 void rtw_send_rsvd_page_h2c(struct rtw_dev *rtwdev);
 int rtw_dump_drv_rsvd_page(struct rtw_dev *rtwdev,
 			   u32 offset, u32 size, u32 *buf);
diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 2a9b09fa76e7..915e810470aa 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -164,6 +164,8 @@ static int rtw_ops_add_interface(struct ieee80211_hw *hw,
 	memset(&rtwvif->bfee, 0, sizeof(struct rtw_bfee));
 	rtw_txq_init(rtwdev, vif->txq);
 	INIT_LIST_HEAD(&rtwvif->rsvd_page_list);
+	rtwvif->rtwdev = rtwdev;
+	INIT_DELAYED_WORK(&rtwvif->csa_beacon_work, rtw_fw_csa_beacon_work);
 
 	mutex_lock(&rtwdev->mutex);
 
@@ -235,6 +237,8 @@ static void rtw_ops_remove_interface(struct ieee80211_hw *hw,
 	rtw_dbg(rtwdev, RTW_DBG_STATE, "stop vif %pM mac_id %d on port %d\n",
 		vif->addr, rtwvif->mac_id, rtwvif->port);
 
+	cancel_delayed_work_sync(&rtwvif->csa_beacon_work);
+
 	mutex_lock(&rtwdev->mutex);
 
 	rtw_leave_lps_deep(rtwdev);
@@ -556,6 +560,15 @@ static int rtw_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 	return 0;
 }
 
+static void rtw_ops_channel_switch_beacon(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  struct cfg80211_chan_def *chandef)
+{
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
+
+	ieee80211_queue_delayed_work(hw, &rtwvif->csa_beacon_work, 0);
+}
+
 static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 			   struct ieee80211_key_conf *key)
@@ -973,6 +986,7 @@ const struct ieee80211_ops rtw_ops = {
 	.sta_add		= rtw_ops_sta_add,
 	.sta_remove		= rtw_ops_sta_remove,
 	.set_tim		= rtw_ops_set_tim,
+	.channel_switch_beacon	= rtw_ops_channel_switch_beacon,
 	.set_key		= rtw_ops_set_key,
 	.ampdu_action		= rtw_ops_ampdu_action,
 	.can_aggregate_in_amsdu	= rtw_ops_can_aggregate_in_amsdu,
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 0f23498b5c96..9f3da59b208f 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2293,7 +2293,8 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
 	hw->wiphy->available_antennas_rx = hal->antenna_rx;
 
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
-			    WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
+			    WIPHY_FLAG_TDLS_EXTERNAL_SETUP |
+			    WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
 	hw->wiphy->features |= NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 	hw->wiphy->max_scan_ssids = RTW_SCAN_MAX_SSIDS;
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index d59f6e323adf..a1974effa3d1 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -823,6 +823,7 @@ struct rtw_bf_info {
 };
 
 struct rtw_vif {
+	struct rtw_dev *rtwdev;
 	enum rtw_net_type net_type;
 	u16 aid;
 	u8 mac_id;
@@ -835,6 +836,7 @@ struct rtw_vif {
 	const struct rtw_vif_port *conf;
 	struct cfg80211_scan_request *scan_req;
 	struct ieee80211_scan_ies *scan_ies;
+	struct delayed_work csa_beacon_work;
 
 	struct rtw_traffic_stats stats;
 
-- 
2.55.0

