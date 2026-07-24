Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618CB2F99B8
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901426; cv=none; b=X6MNAxQAfJ8g0grJNApIoAVtI5E5pbWKlROMnNph9SyCjZcUqFO4KhVeLiO9LEdU7w++l42jwNTT8gUtHmL3d4gVXrpL1e+r74oq7mdxkP0pxhbM2hx5bMIgIb9nh57mK9G19egbSVYzmRZ+frAW0Aaf3yuBYPpdGFLL/ykc1Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901426; c=relaxed/simple;
	bh=bW7TJGrR/6cQX4qoTZk/warzhj815OjkdlhyfqxQJ3s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CprHu64QUeQ781T8vdlnvv34CILvXVN7aHA/eoSPJOy/rdck/vdnKTdpANiBfR0EGR/9UjTZzEqcGopVowm36Kbvj9IhB9QFfF+NyFav1inEj5lgLq/7ly4+59qZzhaASePxQInBq3azahNdh2IyNceNAxdVyVuylnhqiVFCmn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=MwmaF0Y9; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="MwmaF0Y9"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODv2Bj91179702, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901422; bh=gXgg2l2NCOkDzt+aYpQuPaH1AiGj7kKi9qC+JBSSoLE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=MwmaF0Y9XTW5S60s48Mp7fNmHtwKaKZi+ddQ6GGJ/13RZlX/kxJF9wIY0yCCPiYMq
	 NaKcd3OuApaMDci0/isusb0PqNy7zI01iPX+SpLDjyp3eX4cbE+FVKLhFeu3Y3AQs0
	 TnLyPTdYee4i2U9LpbQ/MXQmoS3oWIWoW7zc/IheUT4cXJkPURBGiUpaWV8eKGsVBb
	 tSi+GGSURCgXzolzWokqCjD8s8Iv+vLxVAlaf6D+LOUMECwkbqYTBmkr/uIPj58U0m
	 J04IzOz+Orqa09l9UM5d9is1CgjUdNg8+6w4o3HsC9a+GOR9obdqMZTEzaFNYpXNXg
	 j7gbOMcNsNr8w==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODv2Bj91179702
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:57:02 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:02 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:01 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:57:01 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 04/14] wifi: rtw89: coex: Rearrange _ntfy_role_info info
Date: Fri, 24 Jul 2026 21:56:30 +0800
Message-ID: <20260724135640.3195044-5-pkshih@realtek.com>
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

rtw89_btc_wl_link_info is duplicated declaring in the function, remove one
of them. We need MAC Address only when Wi-Fi role is station, included the
copy operation into if statement.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 79 +++++++++++++++--------
 1 file changed, 53 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index d873b9482e49..9da3b23b2d14 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -8675,13 +8675,14 @@ void rtw89_btc_ntfy_role_info(struct rtw89_dev *rtwdev,
 	const struct rtw89_chan *chan = rtw89_chan_get(rtwdev,
 						       rtwvif_link->chanctx_idx);
 	struct ieee80211_vif *vif = rtwvif_link_to_vif(rtwvif_link);
+	struct ieee80211_p2p_noa_attr *noa_attr;
+	struct ieee80211_p2p_noa_desc *noa_desc;
 	struct ieee80211_bss_conf *bss_conf;
 	struct ieee80211_link_sta *link_sta;
 	struct rtw89_btc *btc = &rtwdev->btc;
 	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
 	struct rtw89_btc_wl_link_info r = {0};
-	struct rtw89_btc_wl_link_info *wlinfo = NULL;
-	u8 mode = 0;
+	u8 i, mode = 0;
 
 	rcu_read_lock();
 
@@ -8729,34 +8730,60 @@ void rtw89_btc_ntfy_role_info(struct rtw89_dev *rtwdev,
 	rtw89_debug(rtwdev, RTW89_DBG_BTC,
 		    "[BTC], wifi_role=%d\n", rtwvif_link->wifi_role);
 
-	wlinfo = &wl->rlink_info[rtwvif_link->port][rtwvif_link->phy_idx];
-
-	wlinfo->mode = mode;
-	wlinfo->role = rtwvif_link->wifi_role;
-	wlinfo->phy = rtwvif_link->phy_idx;
-	wlinfo->pid = rtwvif_link->port;
-	wlinfo->active = true;
-	wlinfo->connected = MLME_LINKED;
-	wlinfo->bcn_period = bss_conf->beacon_int;
-	wlinfo->dtim_period = bss_conf->dtim_period;
-	wlinfo->band = chan->band_type;
-	wlinfo->ch = chan->channel;
-	wlinfo->bw = chan->band_width;
-	wlinfo->chdef.band = chan->band_type;
-	wlinfo->chdef.center_ch = chan->channel;
-	wlinfo->chdef.bw = chan->band_width;
-	wlinfo->chdef.chan = chan->primary_channel;
-	ether_addr_copy(r.mac_addr, rtwvif_link->mac_addr);
+	if (vif->type == NL80211_IFTYPE_P2P_GO ||
+	    vif->type == NL80211_IFTYPE_P2P_CLIENT) {
+		noa_attr = &bss_conf->p2p_noa_attr;
 
-	rcu_read_unlock();
+		for (i = 0; i < RTW89_P2P_MAX_NOA_NUM; i++) {
+			noa_desc = &noa_attr->desc[i];
+			if (noa_desc->count != 0) {
+				r.noa = 1;
+				r.noa_duration = le32_to_cpu(noa_desc->duration);
+				break;
+			}
+		}
+	}
+
+	r.mode = mode;
+	r.role = rtwvif_link->wifi_role;
+	r.phy = rtwvif_link->phy_idx;
+	r.pid = rtwvif_link->port;
+	r.active = true;
+	if (vif->active_links) {
+		if (rtwvif_link->link_id < 16)
+			r.active = !!(vif->active_links & BIT(rtwvif_link->link_id));
+	}
+	r.bcn_period = bss_conf->beacon_int;
+	r.dtim_period = bss_conf->dtim_period;
+	r.band = chan->band_type;
+	r.ch = chan->channel;
+	r.bw = chan->band_width;
+	r.chdef.band = chan->band_type;
+	r.chdef.center_ch = chan->channel;
+	r.chdef.bw = chan->band_width;
+	r.chdef.chan = chan->primary_channel;
+
+	if (rtwsta_link && vif->type == NL80211_IFTYPE_STATION) {
+		r.mac_id = rtwsta_link->mac_id;
+		ether_addr_copy(r.mac_addr, rtwvif_link->mac_addr);
+	}
+
+	switch (state) {
+	case BTC_ROLE_MSTS_STA_CONN_END:
+	case BTC_ROLE_MSTS_AP_START:
+		r.connected = MLME_LINKED;
+		break;
+	default:
+		r.connected = MLME_NO_LINK;
+		break;
+	}
 
-	if (rtwsta_link && vif->type == NL80211_IFTYPE_STATION)
-		wlinfo->mac_id = rtwsta_link->mac_id;
+	rcu_read_unlock();
 
 	btc->dm.cnt_notify[BTC_NCNT_ROLE_INFO]++;
 
-	if (wlinfo->role == RTW89_WIFI_ROLE_STATION &&
-	    wlinfo->connected == MLME_NO_LINK)
+	if (r.role == RTW89_WIFI_ROLE_STATION &&
+	    r.connected == MLME_NO_LINK)
 		btc->dm.leak_ap = 0;
 
 	if (state == BTC_ROLE_MSTS_STA_CONN_START) {
@@ -8774,7 +8801,7 @@ void rtw89_btc_ntfy_role_info(struct rtw89_dev *rtwdev,
 	    state == BTC_ROLE_MSTS_STA_CONN_END)
 		wl->status.map._4way = false;
 
-	_update_wl_info(rtwdev, wlinfo);
+	_update_wl_info(rtwdev, &r);
 
 	_run_coex(rtwdev, BTC_RSN_NTFY_ROLE_INFO);
 }
-- 
2.25.1

