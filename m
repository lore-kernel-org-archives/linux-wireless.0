Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F33858B6D4
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789654752; cv=none; b=svE2eG89Nk5psz0QOwZFFORWI1WVFgerjGJtr6UFjayEzvPX645+fnyJo6kEUOU4Uw6Y0sAO0G9gy670/dmAg6pu7WU+4d5RvgbFzWjdK3XGlnTUXUP9Zzk0VXcOWYLEAGKPKCSyb0UbogEX/bug1hPDxrktXkzZTIWxet6/+tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789654752; c=relaxed/simple;
	bh=IxZyFnXliePRWCcIjxvmQV7E1mil2sax5/JRYLkSQRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jdWJUq4YeAmWsvbNtOONqjHkc6auCz6N/Ia4PGwKIAWDPup6Mxh3wYsZPetCG56/IRJIri2Cc+g7xfPUmSz+VyJEVTTVUYSlWC2XDgBTeI6KOISr2Lv70Zp5GrYPN50wMm7+zM6wSZBHx6zlVe65lHBKq5mLkrObgw6Nq5akbHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sq4kpmY2; arc=none smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sq4kpmY2"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c264788fd58so144462666b.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 07:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789654748; x=1790259548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WyqQtjAVff76GSnCqr88eQwTvGpuf0/qYf/L0/lVgGg=;
        b=Sq4kpmY2mK+lVyFWenkKYXnzc8/0pMWn2btoxaShD+2P1JXo1N2pTYcLko8SA4HIFI
         yH5UvEVxmy1BRyMHdxZOF7ADqJTAKII5B/W2vBbPlraN/Sm6dUnD0P35EOENi8a+uNJg
         lGCM26/jXX3f30jE6aEQpX5s2P4p6H07W+uE59fA0sc8ur65AlQaby1nkmBbkHMeeGg8
         D/KThZYv/zqz9K2C0zItaK5c5iiuGrmgaKM13/mBblJwXdxQQJh+HmvKESDPZKj3iqvr
         hwqbVkByQrqMEWCegLIW4295Gerrl2JbBH7ySS3UVwRLpWD2Q5nXxeiPgwFhjzNyVKnU
         chIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789654748; x=1790259548;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WyqQtjAVff76GSnCqr88eQwTvGpuf0/qYf/L0/lVgGg=;
        b=a7BW3mBV2n5SNOTfblXptRaUWL8kc71oNXpMO3SETk2EOPnWp0WCpwdV4NxUQ+o4RY
         xzV0B9mTWKg+oKZOL30UgYgm8lQRPps2THraD/cKsVjaCgQRUrPbTHWRsYTmyJj2Ncqo
         qdArG387KQfGqeKYMGvD+owUFzxfbZuXhN7z/8Pp4Dq5X7xkWt/BFTPjeLZTP3Osbo/E
         Uz58A4HLV/Z3cp2oh6vFMWe7UZa3/Ix8bPvYrcjGTMpSm0z0cgHEXAvyZJZNnw3AaAmh
         C9z29yDpTztRlsAwUPxpLVi07fa05l2m5S46HojR+9v85WAIC7KhM91ZQTP7iQnWfiWu
         a2bg==
X-Forwarded-Encrypted: i=1; AKwUvBx6TqRaCxhqk4UQqcz0J1aW58qVyaEX+WAxh/XZr3v4331cXSNaV1nivwurzX4+3pQN3sSDWlJblkPtac9Opw==@vger.kernel.org
X-Gm-Message-State: AFuF++k/RMxgI0QkjhmaMKT1ubju+H6MGlAmeifYfRw4LW9y5JXBmC5E
	ALe50ee8ergBFfifWwAIBqsCfGCpyJlwQ0MuZqnTMRINry1VfIKUu0um
X-Gm-Gg: AYBFou2x2a3NJSY9Ub1jpjfBbjpU7mjQxcTYt1dnwmp7zXuTp8GQHedJ8ACQmu+Pwgu
	3U5x10ReZFfltORXxT7Crzauw4/dP/1Q947MsZF5j2R1WrjW6XeKFdV6OCKbMkJoVwsrqBOLjg5
	x8ddrELw+YnHN6muk6PWFLoqpvGme5vu5fov5o49E61NUIxZUbSjQbViLKK5SnshcaiLnXnS2Z8
	z964q6XbbuRRGa9ckCOrxL0AbDzspAlFqqAujsiB1Q4gZHtGtO4onNBfHXhNXi64+DISWVglo3f
	HuIKe91Islwi01UXNm22qn2d6qmwghMsKyCDOZhmLA4xeOSOnKMHlqenPNhNIdsq8VD7T1iBobB
	g14tWlY9Xc2pjjkoyJO18YNwOLrBqtpZZf2e3fji0z+E2C7vnaLjycmmnTCpfSJnRE7o5+bSzfk
	WdROf/s63Z4zCj6URIYKKOoXw6qzrZ0iV3kaOUwp5KiGvfCE7wigRaKqSEzaj1xSpf5RbNkSyfT
	Ywu
X-Received: by 2002:a17:907:1c01:b0:c29:555e:bf9 with SMTP id a640c23a62f3a-c29e5207acdmr502901166b.18.1789654747961;
        Thu, 17 Sep 2026 07:19:07 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29de63a7c8sm299898466b.51.2026.09.17.07.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 07:19:07 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next] wifi: rtw88: honour the transmit power mac80211 asks for
Date: Thu, 17 Sep 2026 16:19:06 +0200
Message-ID: <20260917141906.1361197-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

The per-rate power index is the by-rate value capped by the regulatory
limit and the SAR limit; the level mac80211 hands over in conf.power_level
is never looked at, so "iw phy <phy> set txpower fixed <mBm>" is accepted
and silently ignored. Devices that share a small enclosure with their
client, or that must back off for coexistence, have no way to run below
the regulatory maximum.

Treat the requested level like the SAR limit: convert the dBm value to
the by-rate offset domain with the chip's gain index granularity and use
it as one more ceiling on the offset, then program the indices again
whenever the level changes. The level is the total the device may
radiate, so with two, three or four transmit paths each path gets 3, 5
or 6 dB less, the way ath9k and the vendor driver share it. mac80211
hands over the minimum of the regulatory maximum and the user's request,
so a channel's maximum is respected as well; before the first
configuration there is no request and nothing is capped, which keeps the
behaviour of a driver that does not honour the level at all.

Tested on RTL8822BU (2T) and RTL8821CU (1T) in AP mode: "fixed 1000"
moves every rate that sat above 10 dBm down to the 10 dBm index, less
the 3 dB path share on the 8822BU, while the rates already below stay,
"auto" restores the tables and the client stays associated through the
changes; a second radio saw the beacons drop by the requested amount.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c |  3 +++
 drivers/net/wireless/realtek/rtw88/phy.c      | 26 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/phy.h      |  1 +
 3 files changed, 30 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 2a9b09fa76e7..e0462e934438 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -3,6 +3,7 @@
  */
 
 #include "main.h"
+#include "phy.h"
 #include "sec.h"
 #include "tx.h"
 #include "fw.h"
@@ -94,6 +95,8 @@ static int rtw_ops_config(struct ieee80211_hw *hw, int radio_idx, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
 		rtw_set_channel(rtwdev);
+	else if (changed & IEEE80211_CONF_CHANGE_POWER)
+		rtw_phy_set_tx_power_level(rtwdev, rtwdev->hal.current_channel);
 
 	if ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
 	    (hw->conf.flags & IEEE80211_CONF_IDLE) &&
diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index e2ac5c6fd500..0dfcd0739423 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -2236,6 +2236,29 @@ static s8 rtw_phy_get_tx_power_sar(struct rtw_dev *rtwdev, u8 sar_band,
 	return (s8)rtwdev->chip->max_power_index;
 }
 
+static s8 rtw_phy_get_tx_power_user(struct rtw_dev *rtwdev, u8 band, u8 path,
+				    u8 rate)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	static const u8 path_share_dbm[] = { 0, 0, 3, 5, 6 };
+	int power_level = rtwdev->hw->conf.power_level;
+	u8 rs = rtw_phy_rate_to_rate_section(rate);
+	u8 paths = clamp_t(u8, hweight8(hal->antenna_tx), 1, 4);
+	s32 idx;
+	s8 base;
+
+	if (power_level <= 0 || rs == RTW_RATE_SECTION_NUM)
+		return (s8)chip->max_power_index;
+
+	idx = (power_level - path_share_dbm[paths]) << chip->txgi_factor;
+	base = band == PHY_BAND_2G ? hal->tx_pwr_by_rate_base_2g[path][rs] :
+				     hal->tx_pwr_by_rate_base_5g[path][rs];
+
+	return (s8)clamp_t(s32, idx, -chip->max_power_index - 1,
+			   chip->max_power_index) - base;
+}
+
 void rtw_get_tx_power_params(struct rtw_dev *rtwdev, u8 path, u8 rate, u8 bw,
 			     u8 ch, u8 regd, struct rtw_power_params *pwr_param)
 {
@@ -2248,6 +2271,7 @@ void rtw_get_tx_power_params(struct rtw_dev *rtwdev, u8 path, u8 rate, u8 bw,
 	s8 *limit = &pwr_param->pwr_limit;
 	s8 *remnant = &pwr_param->pwr_remnant;
 	s8 *sar = &pwr_param->pwr_sar;
+	s8 *user = &pwr_param->pwr_user;
 
 	pwr_idx = &rtwdev->efuse.txpwr_idx_table[path];
 	group = rtw_get_channel_group(ch, rate);
@@ -2272,6 +2296,7 @@ void rtw_get_tx_power_params(struct rtw_dev *rtwdev, u8 path, u8 rate, u8 bw,
 	*remnant = rate <= DESC_RATE11M ? dm_info->txagc_remnant_cck :
 					  dm_info->txagc_remnant_ofdm[path];
 	*sar = rtw_phy_get_tx_power_sar(rtwdev, hal->sar_band, path, rate);
+	*user = rtw_phy_get_tx_power_user(rtwdev, band, path, rate);
 }
 
 u8
@@ -2289,6 +2314,7 @@ rtw_phy_get_tx_power_index(struct rtw_dev *rtwdev, u8 rf_path, u8 rate,
 	offset = min3(pwr_param.pwr_offset,
 		      pwr_param.pwr_limit,
 		      pwr_param.pwr_sar);
+	offset = min(offset, pwr_param.pwr_user);
 
 	if (rtwdev->chip->en_dis_dpd)
 		offset += rtw_phy_get_dis_dpd_by_rate_diff(rtwdev, rate);
diff --git a/drivers/net/wireless/realtek/rtw88/phy.h b/drivers/net/wireless/realtek/rtw88/phy.h
index 8449936497bb..c26f18348709 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.h
+++ b/drivers/net/wireless/realtek/rtw88/phy.h
@@ -155,6 +155,7 @@ struct rtw_power_params {
 	s8 pwr_limit;
 	s8 pwr_remnant;
 	s8 pwr_sar;
+	s8 pwr_user;
 };
 
 void
-- 
2.55.0

