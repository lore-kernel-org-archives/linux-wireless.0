Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81CE3A63FB
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791308251; cv=none; b=Wdo1/AYcM+OSt5I3bOoKp5saRXkirCxA+9KfudiaHhfDj+QVOIrKCbV9GcJrMwJvdovIJM9NilkwQ3CfmMyRHxiVLSYWjFr90qDkKc+usUKfySrvUz1hsXlxNC72DQL+IOHWPEWwpDdnFLMiA8A3+9p6n7OPZfVoy0Er0ekSuFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791308251; c=relaxed/simple;
	bh=0ebOJUmNDojLq4UZigX+Ct/JXaXsABkT6lxncgtl28k=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Tfu2hddzQeDmfvur3XNmXt8t6yNag8SD+0NC9R5lNEVNd5p7HVFpKKn03WpdsZWoxLDl3qbJlpDoFIwivRuSS1BsS08mpczgBNZ8s9hySZy+NzI1oGIvyVP0wlrBBi5VwoofZics8Jq1rkayu1F50yiK1ThM5G3+m8a1SAFUs/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ldP0Gu9c; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ldP0Gu9c"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48b042c0759so844296f8f.2
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 10:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791308248; x=1791913048; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zk839aWaTKcocqIv3KupLsgi1STfa+JQtgE6jf4fHQ0=;
        b=ldP0Gu9cZv2va0VxeK7iMO8QHdfK/L1v5ME9AEdK8HqegzS+Zcz/XwdV28qlTnlzq3
         jIW45Ufdz996Y2Dttit7ijiToSS+VfHvbyCIow2EL88tHKByqaijylbbjNqDVEJLw3M3
         Ep9WyzMDavAlM9Drqnrvi99Xd1Cgl8NhMHDet/VbPPP5rO59pEwLMq7e5bH3AXEe82cH
         dlGgjS7Bla5h8QiQIvOOerNEmxN4uqxl1somunevkEm004s0zyvMUrsOoki0/vX+QkoI
         UxDkuTWbEuIAei4YmiEsPIxY/yjeAnQL52ViSZVbb7PsQ7/HVOIx/1hVRooGZpu+UmMJ
         +8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791308248; x=1791913048;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zk839aWaTKcocqIv3KupLsgi1STfa+JQtgE6jf4fHQ0=;
        b=EcDTLjet2DpoIHZWSQmBzAQ/v5NzOtyVlzZdUe8lWmtk27XeQAS7qs+qaMqO91l25k
         B3ltAm/4YkdL5ZmTJnFzBNlE0j1kA/dUkp+buMsPpGvDZ2BrvwNDJAH+QOcrZ9FTKrMu
         EUoWTKGFwuDz8n10an5zLotus5r8rkALeKlJjMfZVWAEtQxAIT4E/xZuFyh7c2VJHfk6
         cFUeMmpmUDfAok2D3NIo9bGw4kfo+ChOSGAeQ9m/LlDkvFq4itAODQG/TPy2fjt+6C5R
         8cD1wXlLNSqeezHmz0M/d1rpDb+aestP5dF6GBf/JTqZ9XlXv1tANbn2aFM2oZTMenrQ
         /+xg==
X-Gm-Message-State: AFq9FYKNBAiCxvYZQq4LA0DX1cEWolYHnkEgBhgvKaQKcFPlmsf5ZHGD
	Go8I/WH5Zc0OXgcvpGZ4v1rjq7SJ13LgKttgBkNdCO1WGttTZM+hQptmuLYHvQ==
X-Gm-Gg: AYBFou1N91eAQXH9bT9yI50V8xhBymDUv7VoPM5CCa6JOhdY0lAfT19yPh/qowvaYDx
	tVgudzCJmVZ2VLMKR41DDauQbJif8E7rrPASPxvJH3vIPEpzMSZsAlA83zsMBxIKpREMdK8Y24I
	3958tdAL4mx4RMhANF4HCznAkBZF/2/8cx5cEfqYmiFGdEZOE9ncOR3ufQZjA2dXVx5trNH+TET
	FdoibSGxTBd/FAOfgAYe71Pru4XNRd4wmWKh9A5lhci+/i48VZJB/9hEw3JRPelYH/q86bS0OEq
	+7UYHbddIxNHzlwH9v+5PolfPUaAqTkTcu2VoIojZ/jNnxdy8YJiy76s1PN7cru2qQ2qepHGnZE
	pq6L0ST9b1L8QRJuAXmZ1wN31wkOcH40OuIYIDzw8vMNHySQvxQGcUi6CNDp3LvILLWu8xJoSkO
	V4bekdonEpQVEvf2gu3/z0DQ3Fd/xGRkRQ3xmayACdL12NQPj/YPsGuN6wBrWOmLm03cEWLup5Q
	vryhw==
X-Received: by 2002:a05:6000:46da:b0:48c:5306:c11a with SMTP id ffacd0b85a97d-48c7276ecebmr220454f8f.24.1791308247840;
        Tue, 06 Oct 2026 10:37:27 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71d3d3eesm817796f8f.53.2026.10.06.10.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2026 10:37:27 -0700 (PDT)
Message-ID: <826c8df5-2ee2-4a6a-93d1-2ec4f16840e5@gmail.com>
Date: Tue, 6 Oct 2026 20:37:26 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
 PierluigiFrullani <pierluigi.frullani@frumar.it>
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next] wifi: rtw89: Override antenna number for
 RTL8852BE-VS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

RTL8852BE-VS (PCI ID 10ec:b85b, RFE type 41) has only one spatial stream
and likely one physical antenna, but the firmware reports two antennas.
This results in the driver configuring the wrong RF path, which leads to
very poor reception. Users complain that 5 GHz networks are not visible.

Hardcode the number of antennas for this RFE type to one, and the
correct RF path for the Bluetooth coexistence code. This is what the
vendor driver does.

Closes: https://lore.kernel.org/linux-wireless/10543730.tdPhlSkOF2@topolinux/
Closes: https://github.com/morrownr/rtw89/issues/128
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
 drivers/net/wireless/realtek/rtw89/core.h     |  1 +
 drivers/net/wireless/realtek/rtw89/mac.c      |  5 +++++
 drivers/net/wireless/realtek/rtw89/rtw8852b.c | 22 ++++++++++++++++++-
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 7e74b5c9ed49..71f00b07c77c 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6529,6 +6529,7 @@ enum rtw89_quirks {
 	RTW89_QUIRK_THERMAL_PROT_VCORE,
 	RTW89_QUIRK_HW_INFO_SYSFS,
 	RTW89_QUIRK_DISABLE_2GHZ,
+	RTW89_QUIRK_1ANT,
 
 	NUM_OF_RTW89_QUIRKS,
 };
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index ad849e4b4a50..098b2372e65b 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -3244,6 +3244,11 @@ static int rtw89_mac_setup_phycap_part0(struct rtw89_dev *rtwdev)
 	tx_ant = u32_get_bits(phycap->w3, RTW89_C2HREG_PHYCAP_W3_ANT_TX_NUM);
 	rx_ant = u32_get_bits(phycap->w3, RTW89_C2HREG_PHYCAP_W3_ANT_RX_NUM);
 
+	if (test_bit(RTW89_QUIRK_1ANT, rtwdev->quirks)) {
+		tx_ant = 1;
+		rx_ant = 1;
+	}
+
 	hal->tx_nss = tx_nss ? min_t(u8, tx_nss, chip->tx_nss) : chip->tx_nss;
 	hal->rx_nss = rx_nss ? min_t(u8, rx_nss, chip->rx_nss) : chip->rx_nss;
 
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
index c3c53a6b8119..9d834ea36c1a 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
@@ -353,6 +353,19 @@ static const struct rtw89_btc_fbtc_mreg rtw89_btc_8852b_mon_reg[] = {
 static const u8 rtw89_btc_8852b_wl_rssi_thres[BTC_WL_RSSI_THMAX] = {70, 60, 50, 40};
 static const u8 rtw89_btc_8852b_bt_rssi_thres[BTC_BT_RSSI_THMAX] = {50, 40, 30, 20};
 
+static int rtw8852b_read_efuse(struct rtw89_dev *rtwdev, u8 *log_map,
+			       enum rtw89_efuse_block block)
+{
+	int ret;
+
+	ret = rtw8852bx_read_efuse(rtwdev, log_map, block);
+
+	if (rtwdev->efuse.rfe_type == 41)
+		set_bit(RTW89_QUIRK_1ANT, rtwdev->quirks);
+
+	return ret;
+}
+
 static void rtw8852b_pwr_sps_ana(struct rtw89_dev *rtwdev)
 {
 	rtw89_write16(rtwdev, R_AX_SPS_ANA_ON_CTRL2, RTL8852B_DEFAULT_SPS_ANA);
@@ -768,6 +781,13 @@ static void rtw8852b_btc_set_rfe(struct rtw89_dev *rtwdev)
 	} else {
 		md->ant.type = BTC_ANT_SHARED;
 		md->bt0_pos = BTC_BT_BTG;
+
+		if (test_bit(RTW89_QUIRK_1ANT, rtwdev->quirks)) {
+			md->ant.num = 1;
+			md->ant.single_pos = RF_PATH_B;
+			md->ant.btg_pos = RF_PATH_B;
+			md->ant.stream_cnt = 1;
+		}
 	}
 	rtwdev->btc.btg_pos = md->ant.btg_pos;
 	rtwdev->btc.ant_type = md->ant.type;
@@ -851,7 +871,7 @@ static const struct rtw89_chip_ops rtw8852b_chip_ops = {
 	.write_rf		= rtw89_phy_write_rf_v1,
 	.set_channel		= rtw8852b_set_channel,
 	.set_channel_help	= rtw8852b_set_channel_help,
-	.read_efuse		= rtw8852bx_read_efuse,
+	.read_efuse		= rtw8852b_read_efuse,
 	.read_phycap		= rtw8852bx_read_phycap,
 	.fem_setup		= NULL,
 	.data_setup		= NULL,
-- 
2.55.0

