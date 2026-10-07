Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194B43F4118
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 10:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791367343; cv=none; b=qTLzHS3bEEx6+ZVpKu4q4HUgcp624TG4sbaXz+agnpb+VUab6WLqdUr2q803wmIxKt03X9J4NST3+yUPIv5P8TPDU5k/ILtbsKpPrGbXFV/2EvdXSdpS6Rpu5apKVuxYm2ej80ERnAEDoDaqDk7CmMjdz30L2keevon1cjn+k8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791367343; c=relaxed/simple;
	bh=q95tS899oxHeywPGute/d0PwOzJxDSZxfCI9mtYsUU0=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=nShzjEMiPxp0QKByamJj0cCl4gHKG7/A+wL3p/iAJTqNv8jYU89Alg+xdLvU5ZQUUl5tdPBO20cjO1MLvqTaNCfsSWxWOhBaxVWlpO4fkBqff45PuV3gpVfffXiTLoQcTLY93Rt6XyX9p2H0YVYTxPfV3tADURtlRQQ5CScFZ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BpCE275B; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BpCE275B"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48b0584ad71so1187666f8f.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 03:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791367331; x=1791972131; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1e9bTlIt2Bl3/bxohUK9Ia7vblQxEgaMpDuVkDTjHeo=;
        b=BpCE275BgsnZwtIS6tydaIb+jLxTOAc68iTB1PG9ezz4ecTUVqWSYHSuodeb6Bxse9
         XERECe7doAaVRh1fG9zV/ClVCWWqlHwPZnbt3u+h7L5yF9lxd5cHcnZBjaeSd+YzfzQU
         GU3CUVqITlU6bhp9QPtFCpXzNS6R/w1y+d2Q2OT5RTyG0e1DBZ6XHXutko/6bsI/JqsZ
         Yp6QmY1em5buUdBnJ8I2OUfb9mwdnw9jak9DEijlf6ChE7R6Q1rHjBWwoOXeVSNlE6ZX
         6DOYPB2ltiJQgnIH4JgB/9puEYx1u7msg1Y01OScZz8axElB46NKj3o71x6A09qQp4r+
         7mDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791367331; x=1791972131;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1e9bTlIt2Bl3/bxohUK9Ia7vblQxEgaMpDuVkDTjHeo=;
        b=SJe2/vF6raNXRRHXQHFElKiKZx/HssgYlfFP2AtybuJaZJ/cWhmOV2/6sJFUBkF7P6
         ez2zmfFc+RK2mfFMAV7A/cmJyjqYK4aJ1qyOthv0J/HaW8fyHO5p2kP45KUKYfYABT56
         qJiegLLX6KqqJz0V/4t1m4VZhXDxz+A3q9C43o8sI6Tznts+ZVrij8QeK6FMoiyfc8+o
         4POUo1IEEeMOpy3Hx9pp1JBL9Ne6208z+zfSrKjwaohrbtihBVUtUKeA74Fqmi8afxkH
         5BN8I65BO0p+uRIp52y8PIIAJi5RfMTVUbmFNx+pV4xU/OK2P7Fzit/twvBMEx6/fUFS
         CKYA==
X-Gm-Message-State: AFq9FYI7dwXFGarm0NwhfVuDqrgDxVL2+G93X26YTn1+EQWzQwzHwrdo
	GleZhSyt6NcDmhI6t6x7cHvy10TNVNT404QjuHT/aq+Wr2L2nk+BQWZtXg9new==
X-Gm-Gg: AYBFou0dATlvFp9VNYMYrW3nZIGq23C885z6uazJQ/jBNMWbC4/sDpJYeRYJknlO51P
	TUcYInhPsSYV6IrvklXom49hU5itO99yDkqkKK6dW1ITQxC9YcN4FS0DEUr7wo16wcGiSD+hyH7
	71DCje93wW7ss6smltS54mwABPMtLsVHPFpSctvXlwcoiwt0sh8Q+E5cR2uLCYuIPGndDqJ82mm
	r7c16WvOupiTYxicX61cIh2/wEIPDhKxlnHuZjA02g8/aL6ZvGH9PL2ExaTPGRBrK6C0RFHxOgK
	cH+rrVv66hjkx+vAvJEvVbCULxjX+806z+gIgL9RWCNwF8qL34bdYYOWJoS7F4a+1IjGIyiKjx4
	xLO5dsxwsin9FadgCeMHTyXPjJ3v/zukKLJP3Cm2uuBi2oJu5SfyZahFxa24OT6BB6byr9Zku4W
	ic94T8/aaPqi8S+HVQQwEMx5+jxBoQaCABB5+o/jRDcQRrnlbF6c/6LXnNbSl2H4LwyO+iLMlv+
	xjj/Mc=
X-Received: by 2002:a05:6000:258a:b0:48b:3f2:2ec7 with SMTP id ffacd0b85a97d-48c7278a257mr3064266f8f.31.1791367330851;
        Wed, 07 Oct 2026 03:02:10 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71d1f8fbsm4207801f8f.33.2026.10.07.03.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 03:02:10 -0700 (PDT)
Message-ID: <c6f85442-dd1e-4971-943a-31bfb54eb0ed@gmail.com>
Date: Wed, 7 Oct 2026 13:02:08 +0300
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
Subject: [PATCH rtw-next v2] wifi: rtw89: Override antenna number for
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
v2:
 - Return immediately when rtw8852bx_read_efuse() returns an error.
 - Rebase on top of the latest rtw-next.
---
 drivers/net/wireless/realtek/rtw89/core.h     |  1 +
 drivers/net/wireless/realtek/rtw89/mac.c      |  5 ++++
 drivers/net/wireless/realtek/rtw89/rtw8852b.c | 24 ++++++++++++++++++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index a1e899576582..4749cf08ee34 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6572,6 +6572,7 @@ enum rtw89_quirks {
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
index 060c99532936..d19388b86aca 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
@@ -353,6 +353,21 @@ static const struct rtw89_btc_fbtc_mreg rtw89_btc_8852b_mon_reg[] = {
 static const u8 rtw89_btc_8852b_wl_rssi_thres[BTC_WL_RSSI_THMAX] = {70, 60, 50, 40};
 static const u8 rtw89_btc_8852b_bt_rssi_thres[BTC_BT_RSSI_THMAX] = {50, 40, 30, 20};
 
+static int rtw8852b_read_efuse(struct rtw89_dev *rtwdev, u8 *log_map,
+			       enum rtw89_efuse_block block)
+{
+	int ret;
+
+	ret = rtw8852bx_read_efuse(rtwdev, log_map, block);
+	if (ret)
+		return ret;
+
+	if (rtwdev->efuse.rfe_type == 41)
+		set_bit(RTW89_QUIRK_1ANT, rtwdev->quirks);
+
+	return 0;
+}
+
 static void rtw8852b_pwr_sps_ana(struct rtw89_dev *rtwdev)
 {
 	rtw89_write16(rtwdev, R_AX_SPS_ANA_ON_CTRL2, RTL8852B_DEFAULT_SPS_ANA);
@@ -773,6 +788,13 @@ static void rtw8852b_btc_set_rfe(struct rtw89_dev *rtwdev)
 		md->bt0_pos = BTC_BT_BTG;
 		/* the only BT shares the BTG antenna with WL path B */
 		dm->ant_xmap[BTC_RF_S1][BTC_BT_1ST] = 1;
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
@@ -856,7 +878,7 @@ static const struct rtw89_chip_ops rtw8852b_chip_ops = {
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

