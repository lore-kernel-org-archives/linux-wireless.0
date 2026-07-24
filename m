Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24E725782D
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901431; cv=none; b=RbxySFveH1ugdMSDxCdiCcBgydCYi722lZGraxBEKElyigwt9SXNTTJhQigTuWMDEDG3Znh5zBpsTqdf4uFSjRHNAzV7xU4muejXV0N+7ssguAuiC4l/djqWrII77FmsjsEnsdwilfmnM+wW9W8zRKFzAuAkSIvWdiMeYQc9sM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901431; c=relaxed/simple;
	bh=6bkS/UP0rKI6tpcjPBsUpG8mNKFoAAtJ+9mHpZdPQOI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9/b/dg2GGsHTaIHTirwW3+iPd6XkJpuO/l285K/MqRz2+mdxqS/xIOY9aAhvHGq4+Xnnx/oaECXkBUlke+HtkT3eNW2UKyDx2kReeox80zQNukb153JdQbaHxk2LZEw7J11IWY0ceTMQhhzwsEbdsbEaJaDGQpNOG3vU+RsrfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DD8FqdvT; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DD8FqdvT"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODv7DR11179716, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901427; bh=5hORugi7Yaq65gQ7IqtiLF8T6lNFvoQfH+uJJm65/xs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=DD8FqdvTHTym8W2Uv3Ge7VjFzSjXHJ+8DjgeKYfqKp9GT6vrkd2BhkuCuoglKN9dv
	 4Bf8QHLJuU7vgh2Ol0VRm+yREa7WpOFlaNbQvCnz8DbxS5bP5t0Pt4wb1QnFaGDkJm
	 Sdk7rLjV4RYn7xXjaV0Wb4dUBjuGZq6z1+4HnB0UK2Ur+bmL8KCRmz3y/4+TbINWEx
	 QHvLjGPcZ9PuT4qpcrnn2Wv7R/Kk5IIO54U+kELAcLpNbEuTTgEqk6DLuUoWWaGKdA
	 1A2VOSBcLp3Ql8JWURVEXFQbrl9vXhknb2eRqMcLnTrOZiQlN7nBzSgFdK1cTsWef9
	 K4NUmY+f5Qw7A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODv7DR11179716
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:57:07 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:07 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:07 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:57:07 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 05/14] wifi: rtw89: coex: Separate _ntfy_role_info into two function
Date: Fri, 24 Jul 2026 21:56:31 +0800
Message-ID: <20260724135640.3195044-6-pkshih@realtek.com>
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

To make logic more clearly, separate _ntfy_role_info into two function by
data collecting and using.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 109 ++++++++++++++++------
 1 file changed, 80 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 9da3b23b2d14..ae458917ecf7 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -7233,6 +7233,7 @@ static void _update_wl_non_mlo_info(struct rtw89_dev *rtwdev)
 		mode = _chk_dbcc(rtwdev, cid_ch, cid_phy, cid_role, cnt, notv10);
 		mode_v0 = wl_rinfo->link_mode_v0;
 	} else if (!b2g && b5g && notv10) {
+		mode = _get_role_link_mode(wl_rinfo, cid_role[0], notv10);
 		mode_v0 = BTC_WLINK_V0_5G;
 	} else if (b2g && b5g) {
 		mode = BTC_WLINK_DB_MCC;
@@ -7247,6 +7248,7 @@ static void _update_wl_non_mlo_info(struct rtw89_dev *rtwdev)
 		}
 	} else {
 		mode = _get_role_link_mode(wl_rinfo, cid_role[0], notv10);
+		mode_v0 = wl_rinfo->link_mode_v0;
 	}
 
 	wl_rinfo->link_mode = mode;
@@ -8667,6 +8669,78 @@ static void _update_bt_info(struct rtw89_dev *rtwdev, u8 *buf, u32 len)
 	_run_coex(rtwdev, BTC_RSN_UPDATE_BT_INFO);
 }
 
+static void _ntfy_role_info(struct rtw89_dev *rtwdev, u8 rid,
+			    struct rtw89_btc_wl_link_info *info,
+			    enum btc_role_state reason)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_wl_link_info *wlinfo = NULL;
+	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
+	const struct rtw89_btc_ver *ver = btc->ver;
+	u8 rlink_id = info->phy; /* 1 role_id has 2 rlink_id(by HW_Band0/1) */
+	bool refresh_role = false;
+
+	rtw89_debug(rtwdev, RTW89_DBG_BTC,
+		    "[BTC], %s(), role_id=%d, reason=%d\n",
+		    __func__, rid, reason);
+
+	if (rid >= ver->max_role_num || rlink_id >= RTW89_PHY_NUM)
+		return;
+
+	btc->dm.cnt_notify[BTC_NCNT_ROLE_INFO]++;
+
+	wlinfo = &wl->rlink_info[rid][rlink_id];
+	memcpy(wlinfo, info, sizeof(struct rtw89_btc_wl_link_info));
+
+	switch (reason) {
+	case BTC_ROLE_START:
+		wlinfo->active = true;
+		return;
+	case BTC_ROLE_STOP:
+		wlinfo->active = false;
+		return;
+	case BTC_ROLE_MSTS_STA_CONN_START:
+		wl->status.map.transacting = 1;
+		wiphy_delayed_work_cancel(rtwdev->hw->wiphy,
+					  &rtwdev->coex_act1_work);
+		wiphy_delayed_work_queue(rtwdev->hw->wiphy,
+					 &rtwdev->coex_act1_work,
+					 RTW89_COEX_ACT1_WORK_PERIOD);
+		break;
+	case BTC_ROLE_MSTS_STA_CONN_END:
+		wl->status.map.transacting = 0;
+		refresh_role = true;
+		break;
+	case BTC_ROLE_MSTS_STA_DIS_CONN:
+		wl->status.map.transacting = 1;
+		refresh_role = false;
+		wiphy_delayed_work_cancel(rtwdev->hw->wiphy,
+					  &rtwdev->coex_act1_work);
+		wiphy_delayed_work_queue(rtwdev->hw->wiphy,
+					 &rtwdev->coex_act1_work,
+					 RTW89_COEX_ACT1_WORK_PERIOD);
+		break;
+	case BTC_ROLE_MSTS_AP_START:
+	case BTC_ROLE_MSTS_AP_STOP:
+		refresh_role = true;
+		break;
+	case BTC_ROLE_STATE_UNKNOWN:
+		rtw89_debug(rtwdev, RTW89_DBG_BTC,
+			    "[BTC], %s(), role_id=%d, Unknown reason return!\n",
+			    __func__, rid);
+		return;
+	default:
+		return;
+	}
+
+	if (refresh_role) {
+		_update_wl_info(rtwdev, wlinfo);
+		_fw_set_drv_info(rtwdev, CXDRVINFO_ROLE);
+	}
+
+	_run_coex(rtwdev, BTC_RSN_NTFY_ROLE_INFO);
+}
+
 void rtw89_btc_ntfy_role_info(struct rtw89_dev *rtwdev,
 			      struct rtw89_vif_link *rtwvif_link,
 			      struct rtw89_sta_link *rtwsta_link,
@@ -8679,20 +8753,20 @@ void rtw89_btc_ntfy_role_info(struct rtw89_dev *rtwdev,
 	struct ieee80211_p2p_noa_desc *noa_desc;
 	struct ieee80211_bss_conf *bss_conf;
 	struct ieee80211_link_sta *link_sta;
-	struct rtw89_btc *btc = &rtwdev->btc;
-	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
 	struct rtw89_btc_wl_link_info r = {0};
-	u8 i, mode = 0;
+	u8 i, role_id, mode = 0;
 
 	rcu_read_lock();
 
 	bss_conf = rtw89_vif_rcu_dereference_link(rtwvif_link, false);
 
+	role_id = rtwvif_link->port;
+
 	rtw89_debug(rtwdev, RTW89_DBG_BTC, "[BTC], state=%d\n", state);
 	rtw89_debug(rtwdev, RTW89_DBG_BTC,
 		    "[BTC], role is STA=%d\n",
 		    vif->type == NL80211_IFTYPE_STATION);
-	rtw89_debug(rtwdev, RTW89_DBG_BTC, "[BTC], port=%d\n", rtwvif_link->port);
+	rtw89_debug(rtwdev, RTW89_DBG_BTC, "[BTC], port=%d\n", role_id);
 	rtw89_debug(rtwdev, RTW89_DBG_BTC, "[BTC], band=%d ch=%d bw=%d\n",
 		    chan->band_type, chan->channel, chan->band_width);
 	rtw89_debug(rtwdev, RTW89_DBG_BTC, "[BTC], associated=%d\n",
@@ -8747,7 +8821,7 @@ void rtw89_btc_ntfy_role_info(struct rtw89_dev *rtwdev,
 	r.mode = mode;
 	r.role = rtwvif_link->wifi_role;
 	r.phy = rtwvif_link->phy_idx;
-	r.pid = rtwvif_link->port;
+	r.pid = role_id;
 	r.active = true;
 	if (vif->active_links) {
 		if (rtwvif_link->link_id < 16)
@@ -8780,30 +8854,7 @@ void rtw89_btc_ntfy_role_info(struct rtw89_dev *rtwdev,
 
 	rcu_read_unlock();
 
-	btc->dm.cnt_notify[BTC_NCNT_ROLE_INFO]++;
-
-	if (r.role == RTW89_WIFI_ROLE_STATION &&
-	    r.connected == MLME_NO_LINK)
-		btc->dm.leak_ap = 0;
-
-	if (state == BTC_ROLE_MSTS_STA_CONN_START) {
-		wl->status.map.transacting = 1;
-		wiphy_delayed_work_cancel(rtwdev->hw->wiphy, &rtwdev->coex_act1_work);
-		wiphy_delayed_work_queue(rtwdev->hw->wiphy,
-					 &rtwdev->coex_act1_work,
-					 RTW89_COEX_ACT1_WORK_PERIOD);
-	} else {
-		wiphy_delayed_work_cancel(rtwdev->hw->wiphy, &rtwdev->coex_act1_work);
-		wl->status.map.transacting = 0;
-	}
-
-	if (state == BTC_ROLE_MSTS_STA_DIS_CONN ||
-	    state == BTC_ROLE_MSTS_STA_CONN_END)
-		wl->status.map._4way = false;
-
-	_update_wl_info(rtwdev, &r);
-
-	_run_coex(rtwdev, BTC_RSN_NTFY_ROLE_INFO);
+	_ntfy_role_info(rtwdev, role_id, &r, state);
 }
 
 void rtw89_btc_ntfy_radio_state(struct rtw89_dev *rtwdev, enum btc_rfctrl rf_state)
-- 
2.25.1

