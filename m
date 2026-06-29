Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86906175A6B;
	Mon, 29 Jun 2026 09:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782726348; cv=none; b=pE0vJCwJMbXe9eVuS9N2ueqoxj0jTPajMCiGJBZCUzvo09KGavGv8QX2qgWnIrGymeKZfBBh1YM9XLog/537o4Bopi8ZU0XoRoJXUakhZ/4WxwCJaI1v8vlixhY0Orpdo9lW0856bm9O0wlOPOqlgs9aoYympQFV3yVQ6j4jiHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782726348; c=relaxed/simple;
	bh=xo2VemDLgp64qlZyV6fPLpHJQ+Mc374MaUBUAhp+oC8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ebmE1Rd+imciPTGGjUVnQeq7gxLctJuQnGVEM8meUIQai2oMkRUkHVeiWbzNhWRIZ5JeWgYkTmyiB6RT+BDidF88t4OIhh1p8nBs75bJkDAQ9EIoGQmyIzewng9yYcPXB5gfrwT8nXvWEXMT/d0jDgNzbbDJV/Oyv7PYpMe79jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=OY5cOjjJ; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="OY5cOjjJ"
Received: from ubuntu-jammy.. (unknown [89.39.121.185])
	by mail.ispras.ru (Postfix) with ESMTPSA id 55122406E9A6;
	Mon, 29 Jun 2026 09:45:36 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 55122406E9A6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1782726337;
	bh=snSmEVdEpjjoSye7qdbNv6B+G/Aljs4yuBk9aUGJTyU=;
	h=From:To:Cc:Subject:Date:From;
	b=OY5cOjjJGn0y2RFvFq8M5mk+WqwhZC7iIpWzjKZMNtP4XOXCfQyFCoaVXEWke3X41
	 L16VKncNzREOWZ4KC1gseW4vf3uNNd78ZEcBHBm5iKI+zju9s8emAtXX3Ck7ki1F2Q
	 lTFqeDj0aw/J8sQC92QdnAyhF17FsgWaCHdScpKQ=
From: Dmitry Morgun <d.morgun@ispras.ru>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Dmitry Morgun <d.morgun@ispras.ru>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH rtw-next v3] wifi: rtw89: check return values in rtw89_ops_start_ap()
Date: Mon, 29 Jun 2026 09:44:52 +0000
Message-Id: <20260629094452.8709-1-d.morgun@ispras.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several functions called in rtw89_ops_start_ap() may fail to allocate
skb or fail to send H2C command to firmware, returning -ENOMEM or an
error code. Their return values are ignored, so subsequent commands
are executed with incorrect state.

Check the return values and propagate errors.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a52e4f2ce0f5 ("wifi: rtw89: implement ieee80211_ops::start_ap and stop_ap")
Signed-off-by: Dmitry Morgun <d.morgun@ispras.ru>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c | 35 ++++++++++++++++---
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 501c3af1d..cd4076a17 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -811,11 +811,36 @@ static int rtw89_ops_start_ap(struct ieee80211_hw *hw,
 
 	ether_addr_copy(rtwvif_link->bssid, link_conf->bssid);
 	rtw89_cam_bssid_changed(rtwdev, rtwvif_link);
-	rtw89_mac_port_update(rtwdev, rtwvif_link);
-	rtw89_chip_h2c_assoc_cmac_tbl(rtwdev, rtwvif_link, NULL);
-	rtw89_fw_h2c_role_maintain(rtwdev, rtwvif_link, NULL, RTW89_ROLE_TYPE_CHANGE);
-	rtw89_fw_h2c_join_info(rtwdev, rtwvif_link, NULL, true);
-	rtw89_fw_h2c_cam(rtwdev, rtwvif_link, NULL, NULL, RTW89_ROLE_TYPE_CHANGE);
+	ret = rtw89_mac_port_update(rtwdev, rtwvif_link);
+	if (ret) {
+		rtw89_warn(rtwdev, "failed to update mac port\n");
+		return ret;
+	}
+
+	ret = rtw89_chip_h2c_assoc_cmac_tbl(rtwdev, rtwvif_link, NULL);
+	if (ret) {
+		rtw89_warn(rtwdev, "failed to send h2c cmac table\n");
+		return ret;
+	}
+
+	ret = rtw89_fw_h2c_role_maintain(rtwdev, rtwvif_link, NULL, RTW89_ROLE_TYPE_CHANGE);
+	if (ret) {
+		rtw89_warn(rtwdev, "failed to send h2c role info\n");
+		return ret;
+	}
+
+	ret = rtw89_fw_h2c_join_info(rtwdev, rtwvif_link, NULL, true);
+	if (ret) {
+		rtw89_warn(rtwdev, "failed to send h2c join info\n");
+		return ret;
+	}
+
+	ret = rtw89_fw_h2c_cam(rtwdev, rtwvif_link, NULL, NULL, RTW89_ROLE_TYPE_CHANGE);
+	if (ret) {
+		rtw89_warn(rtwdev, "failed to send h2c cam\n");
+		return ret;
+	}
+
 	rtw89_chip_rfk_channel(rtwdev, rtwvif_link);
 
 	if (RTW89_CHK_FW_FEATURE(NOTIFY_AP_INFO, &rtwdev->fw)) {
-- 
2.34.1

