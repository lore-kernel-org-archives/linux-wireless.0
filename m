Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6038C44E038
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543471; cv=none; b=HTPGfW6Q6VztYVmknJy66mr9RpD3DJE7XPzBBttenxGeDlGUh/ImEft+iwCLsjQcZtpYshwGHiZWESL+HXEQp9wpmHIDTRQ7FAb2DJiAZpGDDF668GzJhZJ6quaUBYZMU4JDTUEDpzF+MRsoh6lXOHgsvwFkeq2oPPp9aMX2KS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543471; c=relaxed/simple;
	bh=UNWg5VnxJVEABRsecDDSekhPRJQoM8Hz7f4YtHDxYRc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M9CZ5WQ7OyE30EYqwJziIQVqp/9jOu5N9p4YO+tnYTkhPo+THML2fp8kMojUvPfttXlVXcd67quqw6vS3P9eWiT5A6199xfLXGthorENj1Rl5rHNEwH7YbFEjfOC4qBixaDRvtbXvhhmw0DnBcwM7r+vap3zXt51162P5WKIjpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ClFesLRA; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ClFesLRA"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7NseY62168494, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543434; bh=e98IWI1wFh+Om8LXa3yydTMiaXdVSHNDjOwa53q5Ux4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=ClFesLRAxuR7PPP3drD9LyiQFEA6q22VIvrKSctQvrr2mUkciYeHujoDYS0tlvs+x
	 n/WQU+SHk5dKYZwSAHVgK2b7qjU6TYUgSCiguqby3dIzHIMo2UNo2v7Lkse8p7wtul
	 40/ApkIwG/oNnlxm0pHuEv1fjtwizjGyEYJE4gQcplajJvVYX9ymL43mm+XVphwwyl
	 ebaDYSFfGyvnruFp/y6Ho9DJUD/94AnXvBKEMJwrDH2kMUAl2tGWbW3ABiaPXLWNrZ
	 QBQz9sLB6pQsBod9CkYfvr9mrApV1beZon421fDHZkYorkIKxsHzLyclsK5oZAt7Ap
	 L68YFP+yZ51CQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7NseY62168494
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:23:54 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:53 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:23:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 08/15] wifi: rtw89: coex: split bt_profile into per-device fields in trx H2C
Date: Wed, 16 Sep 2026 15:22:31 +0800
Message-ID: <20260916072238.62574-9-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260916072238.62574-1-pkshih@realtek.com>
References: <20260916072238.62574-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

Rename bt_profile/rsvd2 to bt0_profile/bt1_profile in the DM trx_info
struct and all three trx H2C structs (v7/v9/v107) to match the firmware
interface for dual-BT devices.

Previously _update_bt_info() wrote all BT devices' profile maps into a
single bt_profile field, so the last device to report overwrote the
first. The firmware received bt1_profile as zero at all times because
rsvd2 was never updated.

Fix _update_bt_info() to assign bt0_profile when bid==BTC_BT_1ST and
bt1_profile otherwise, so the firmware H2C correctly reflects each BT
device's active profiles independently.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c |  7 ++++++-
 drivers/net/wireless/realtek/rtw89/core.h |  4 ++--
 drivers/net/wireless/realtek/rtw89/fw.c   | 12 ++++++------
 drivers/net/wireless/realtek/rtw89/fw.h   | 12 ++++++------
 4 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 2513af4d727c..b7b06b28009e 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -9129,7 +9129,12 @@ static void _update_bt_info(struct rtw89_dev *rtwdev, u8 bid, u8 *buf, u32 len)
 	a2dp->exist = btinfo.lb2.a2dp;
 	pan->exist = btinfo.lb2.pan;
 	_update_bt_link_cnt(rtwdev, bt, is_bt_56g);
-	btc->dm.trx_info.bt_profile = u32_get_bits(btinfo.val, BT_PROFILE_PROTOCOL_MASK);
+	if (bid == BTC_BT_1ST)
+		btc->dm.trx_info.bt0_profile =
+			u32_get_bits(btinfo.val, BT_PROFILE_PROTOCOL_MASK);
+	else
+		btc->dm.trx_info.bt1_profile =
+			u32_get_bits(btinfo.val, BT_PROFILE_PROTOCOL_MASK);
 
 	/* parse raw info low-Byte3 */
 	btinfo.val = raw_info[BTC_BTINFO_L3];
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index d1678a8b5872..7fee587a8162 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -3840,8 +3840,8 @@ struct rtw89_btc_trx_info {
 
 	u8 cn; /* condition_num */
 	s8 nhm;
-	u8 bt_profile;
-	u8 rsvd2;
+	u8 bt0_profile;
+	u8 bt1_profile;
 
 	u16 tx_rate;
 	u16 rx_rate;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 63dd918b0989..33eb09e56f95 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -7223,8 +7223,8 @@ int rtw89_fw_h2c_cxdrv_trx_v7(struct rtw89_dev *rtwdev, u8 type)
 	h2c->v7_u8.zb_rx_gain = trx->zb_rx_gain[BTC_BT_1ST];
 	h2c->v7_u8.cn = trx->cn;
 	h2c->v7_u8.nhm = trx->nhm;
-	h2c->v7_u8.bt_profile = trx->bt_profile;
-	h2c->v7_u8.rsvd2 = trx->rsvd2;
+	h2c->v7_u8.bt0_profile = trx->bt0_profile;
+	h2c->v7_u8.bt1_profile = trx->bt1_profile;
 	h2c->v7_le.tx_rate = cpu_to_le16(trx->tx_rate);
 	h2c->v7_le.rx_rate = cpu_to_le16(trx->rx_rate);
 	h2c->v7_le.tx_tp = cpu_to_le32(trx->tx_tp);
@@ -7290,8 +7290,8 @@ int rtw89_fw_h2c_cxdrv_trx_v9(struct rtw89_dev *rtwdev, u8 type)
 	}
 	h2c->v9_u8.cn = trx->cn;
 	h2c->v9_u8.nhm = trx->nhm;
-	h2c->v9_u8.bt_profile = trx->bt_profile;
-	h2c->v9_u8.rsvd2 = trx->rsvd2;
+	h2c->v9_u8.bt0_profile = trx->bt0_profile;
+	h2c->v9_u8.bt1_profile = trx->bt1_profile;
 	h2c->v9_le.tx_rate = cpu_to_le16(trx->tx_rate);
 	h2c->v9_le.rx_rate = cpu_to_le16(trx->rx_rate);
 	h2c->v9_le.tx_tp = cpu_to_le32(trx->tx_tp);
@@ -7348,8 +7348,8 @@ int rtw89_fw_h2c_cxdrv_trx_v107(struct rtw89_dev *rtwdev, u8 type)
 	h2c->v107_u8.bt_rx_gain = trx->bt_rx_gain[BTC_BT_1ST];
 	h2c->v107_u8.cn = trx->cn;
 	h2c->v107_u8.nhm = trx->nhm;
-	h2c->v107_u8.bt_profile = trx->bt_profile;
-	h2c->v107_u8.rsvd2 = trx->rsvd2;
+	h2c->v107_u8.bt0_profile = trx->bt0_profile;
+	h2c->v107_u8.bt1_profile = trx->bt1_profile;
 	h2c->v7_le.tx_rate = cpu_to_le16(trx->tx_rate);
 	h2c->v7_le.rx_rate = cpu_to_le16(trx->rx_rate);
 	h2c->v7_le.tx_tp = cpu_to_le32(trx->tx_tp);
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index a15a5967cabc..294399bf57b1 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2553,8 +2553,8 @@ struct rtw89_btc_trx_info_u8 {
 
 	u8 cn; /* condition_num */
 	s8 nhm;
-	u8 bt_profile;
-	u8 rsvd2;
+	u8 bt0_profile;
+	u8 bt1_profile;
 } __packed;
 
 struct rtw89_btc_trx_info_v7_u8 {
@@ -2572,8 +2572,8 @@ struct rtw89_btc_trx_info_v7_u8 {
 
 	u8 cn;
 	s8 nhm;
-	u8 bt_profile;
-	u8 rsvd2;
+	u8 bt0_profile;
+	u8 bt1_profile;
 } __packed;
 
 struct rtw89_btc_trx_info_v107_u8 {
@@ -2589,8 +2589,8 @@ struct rtw89_btc_trx_info_v107_u8 {
 
 	u8 cn;
 	s8 nhm;
-	u8 bt_profile;
-	u8 rsvd2;
+	u8 bt0_profile;
+	u8 bt1_profile;
 } __packed;
 
 struct rtw89_btc_trx_info_le {
-- 
2.25.1

