Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792529439;
	b=FOf0/OTlTXEQ2sdVpFaJy4iUKhhZOcokKWjmAO0ZDDWGvG9BLdbSPOm0f9o5F/X/6mhl
	 DbtpT1bMNkYEPZWrCknZgDIJLOOzn9RhDOIlwQXs9CBe9ix1dhnYz7m5fMO9Jp7XsQvQC
	 u51l6jI9XSudYjIx9drwYTR8aUfJuD2lhXNwsB6LCKnJQIe0Mq+YDrTiktHL+HyHwdXPw
	 x7Mv+4t+aeA1bNs69tOpAJZUuo4c4eg0C4kPJA2ELdLgStuDewLAqzHBobTy17lcO19iu
	 hDAQRDEeO/h0buUNkej96Hnq8MK/ssKlEPxTc6UH2I8yQEl2045p/jUWG2Tnrpb+kuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792529439;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Content-Language:To:Cc:From:Subject:
	 Content-Type:Content-Transfer-Encoding;
	bh=NEQXWzX5Yve8YQKWu4j/zLTc+4cqToZ6mUJV+H8/3mM=;
	b=4atsjxr5GwP3i39Rqj1eLI3G+MNZfztg0gLiN2NnjXLL1dSG+EpZ7PFB3qducRVO35K4
	 Ng1X2KZJ6PIDtDDloA6qF23PKHJmiPii5NVMrQhQSOgKZy+xu2TGMFk6FBHpbeQIw/OmR
	 yVccxTjPB0F9wfhsmDCWbGZ7fqvBHZgFrwDTMlzrKwKkvl+vngRfKSBKnq2H1mhw9MV0q
	 NQPzt6HZkwPsQEKJgQK2FYUEIk+BjBSosmi4FwodFbtqEaFdOrYssHb+rbzbBO6+eDeci
	 FfyqeSNHw9E3uZzczKVlj4UuwA90XZ/bTRhRyBLBnk046yLeHjIMfaIOGhAD0WdyjZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=n2cP7RQH;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906A7606A31C
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 20:50:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 906A7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=n2cP7RQH
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48df4e9d2d4so17542f8f.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 13:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792529437; x=1793134237; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NEQXWzX5Yve8YQKWu4j/zLTc+4cqToZ6mUJV+H8/3mM=;
        b=n2cP7RQHV2ZDqy2BlJf3w2Bsarz0RwBZJ29zWyF2JPUVsXxsWH41WP3wWN+7teEzGE
         NH0itVkMgPsCY+iPwcIXu0IrwA0r0nQXhlkNNTQCLmlOgy6fucWwF5OFU/V1cr8SObYF
         Kvqk/B3CXoRmwH1NRJZ30Drpk1XUXVZ6/SBnQX4cfIvdTvwN/3QPcu+kM5Yaptps7deu
         x1AMWBWPWiJOf4yGh28bhAqP+u63qbcaaJA/guWeSTmkfnklo8wMm8UUE1qtxgE5Yos8
         1BeuzxySqYqoFbhEFgt5YluaA+gLrjPGjcg8p/v74sPqFD/i6dLF5SmjM+C74XTuw7PV
         vFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792529437; x=1793134237;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NEQXWzX5Yve8YQKWu4j/zLTc+4cqToZ6mUJV+H8/3mM=;
        b=KlM6IxijuRY16PkOH9f91Nm+0R42lNK12aBORjQmVR7yppEvCVWxhJwe/og1OgaZ49
         kTFf7ZaiovGd3iY0GP1c4xBRdX8iQpbRpfMyAoXPqr3ZVUR7RRxu1kN3/jGppBs6XFe1
         ZwfoMWlU7XpYYxBq/cR2UW+D738wzTW1b6RwaZt5RbBVaGK3oTv1G4cvv3Yy2yUKxjSY
         QUADW8D55ul3lCtKSK2o7E4hcLW5VWykBbGlkEFD4Jdcl9PrB7sQmSo+lrikRx7nzMQS
         Lol0uwOFAOf4RrdjQjU+Kq8AbmJC0AbboGl7vYhmRRX59ooF2R8WLRujtqUvKnIKE71i
         GZAg==
X-Gm-Message-State: AFq9FYK8RySlYzAytiUX4y8ge+t6d7GEccj6DLTIlpiQAyKkHqMSW37q
	lRQjk7psjmFFPe46sRxfrhtK3PlOYVYQ7TXH9ppUwiNTtzfXOGn2yefFkJ644A==
X-Gm-Gg: AYBFou1KYkxoP+u2Sn386FAS0HOnlGOx2JItIifza81d3DJtvIP7JK6uh0O49l6DLvt
	kZe8VoGOBUM41tZimnsTAbvhW+qwNAYOBihkycFNPC4C7lwYz2303Yhduae2FyRVAY3gn+gbOac
	AdbNbvMLoIEsRBW/2K7SXVzsVQ5YKlWz7fEX+BE0jGQ7RGjXNWCKEQsLIF5x7pQSa4ljfl7zDyF
	8AV75ANrpeTorhbGDFwENOnBi3c1zTfsYXrScR1l68OtBsri4C1qza+gP45m/vKVIMspgyCJzLO
	ek0lLdnCbWWeCb4Ecz8ZWTx/HpyHQNI/agHJ0ygYPWchVEcgv7UHcDb96RmVs+wNrZ7rTOVMHcz
	/pWtFDD6C6TaI7yhPq6xQ92NeQR79N5Z2cxrC0JA+lneikHwyfRmtfy895ktzA4JUkm9ToTUgrV
	9Gq1huYWJQGh7bhboVoH4wZS5XxsZqcDVPJVPczRNT7/bYpCqPPl3VQlWvdwTb4/lyJDzt9DaoN
	NUfCg==
X-Received: by 2002:adf:f842:0:b0:48d:f324:4621 with SMTP id ffacd0b85a97d-48e07fb5f3fmr17405267f8f.52.1792529436778;
        Tue, 20 Oct 2026 13:50:36 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2581eed3sm916320f8f.12.2026.10.20.13.50.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 13:50:36 -0700 (PDT)
Message-ID: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
Date: Tue, 20 Oct 2026 23:50:34 +0300
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>, Luka Gejak <luka.gejak@linux.dev>
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next v2 1/3] wifi: rtw88: Pass the physical map to the
 read_efuse chip op
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

rtw8723b_read_efuse() will need to read a byte from the physical efuse
map, so pass the map to the read_efuse chip op.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
v2:
 - Patch is new in v2.
---
 drivers/net/wireless/realtek/rtw88/efuse.c    | 2 +-
 drivers/net/wireless/realtek/rtw88/main.h     | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8703b.c | 4 ++--
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 4 ++--
 drivers/net/wireless/realtek/rtw88/rtw8723x.c | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8723x.h | 7 ++++---
 drivers/net/wireless/realtek/rtw88/rtw8814a.c | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h | 2 +-
 12 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/efuse.c b/drivers/net/wireless/realtek/rtw88/efuse.c
index b85075cd68d0..15c57203545b 100644
--- a/drivers/net/wireless/realtek/rtw88/efuse.c
+++ b/drivers/net/wireless/realtek/rtw88/efuse.c
@@ -173,7 +173,7 @@ int rtw_parse_efuse_map(struct rtw_dev *rtwdev)
 		goto out_free;
 	}
 
-	ret = chip->ops->read_efuse(rtwdev, log_map);
+	ret = chip->ops->read_efuse(rtwdev, log_map, phy_map);
 	if (ret) {
 		rtw_err(rtwdev, "failed to read efuse map\n");
 		goto out_free;
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index d59f6e323adf..6ecbeb4ffe4b 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -868,7 +868,7 @@ struct rtw_chip_ops {
 	int (*mac_postinit)(struct rtw_dev *rtwdev);
 	int (*dump_fw_crash)(struct rtw_dev *rtwdev);
 	void (*shutdown)(struct rtw_dev *rtwdev);
-	int (*read_efuse)(struct rtw_dev *rtwdev, u8 *map);
+	int (*read_efuse)(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map);
 	void (*phy_set_param)(struct rtw_dev *rtwdev);
 	void (*set_channel)(struct rtw_dev *rtwdev, u8 channel,
 			    u8 bandwidth, u8 primary_chan_idx);
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8703b.c b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
index 25456f0367b2..8ad30a37096d 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8703b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
@@ -563,12 +563,12 @@ static void try_mac_from_devicetree(struct rtw_dev *rtwdev)
 	}
 }
 
-static int rtw8703b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
+static int rtw8703b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
 	int ret;
 
-	ret = rtw8723x_read_efuse(rtwdev, log_map);
+	ret = rtw8723x_read_efuse(rtwdev, log_map, phy_map);
 	if (ret != 0)
 		return ret;
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
index 8bb9c03d769c..0179f09140ef 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
@@ -2349,12 +2349,12 @@ static void rtw8723b_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 	fill_txdesc_checksum_common(txdesc, 16);
 }
 
-static int rtw8723b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
+static int rtw8723b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
 	int ret;
 
-	ret = rtw8723x_read_efuse(rtwdev, log_map);
+	ret = rtw8723x_read_efuse(rtwdev, log_map, phy_map);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723x.c b/drivers/net/wireless/realtek/rtw88/rtw8723x.c
index 97e6f6a62c0d..5dd306cb058e 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723x.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723x.c
@@ -250,7 +250,7 @@ static const u8 rtw8723x_txpwr_idx_table[] = {
 	0x2D, 0x2D, 0x2D, 0x2D, 0x2D, 0x02
 };
 
-static int __rtw8723x_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
+static int __rtw8723x_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
 	u8 *pwr = (u8 *)efuse->txpwr_idx_table;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723x.h b/drivers/net/wireless/realtek/rtw88/rtw8723x.h
index e07b6ca99b3d..a8d42ea9a4f1 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723x.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723x.h
@@ -135,7 +135,7 @@ struct rtw8723x_common {
 
 	/* common functions */
 	void (*lck)(struct rtw_dev *rtwdev);
-	int (*read_efuse)(struct rtw_dev *rtwdev, u8 *log_map);
+	int (*read_efuse)(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map);
 	int (*mac_init)(struct rtw_dev *rtwdev);
 	int (*mac_postinit)(struct rtw_dev *rtwdev);
 	void (*cfg_ldo25)(struct rtw_dev *rtwdev, bool enable);
@@ -434,9 +434,10 @@ static inline void rtw8723x_lck(struct rtw_dev *rtwdev)
 	rtw8723x_common.lck(rtwdev);
 }
 
-static inline int rtw8723x_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
+static inline
+int rtw8723x_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 {
-	return rtw8723x_common.read_efuse(rtwdev, log_map);
+	return rtw8723x_common.read_efuse(rtwdev, log_map, phy_map);
 }
 
 static inline int rtw8723x_mac_init(struct rtw_dev *rtwdev)
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8814a.c b/drivers/net/wireless/realtek/rtw88/rtw8814a.c
index fa02aa299b5e..b6916d3dc6d3 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8814a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8814a.c
@@ -126,7 +126,7 @@ static void rtw8814a_init_hwcap(struct rtw_dev *rtwdev)
 		efuse->hw_cap.ant_num, efuse->hw_cap.nss);
 }
 
-static int rtw8814a_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
+static int rtw8814a_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
 	struct rtw8814a_efuse *map;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index ee689fa3d87f..83ac6b732e80 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -45,7 +45,7 @@ enum rtw8821ce_rf_set {
 	SWITCH_TO_BT,
 };
 
-static int rtw8821c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
+static int rtw8821c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 {
 	struct rtw_hal *hal = &rtwdev->hal;
 	struct rtw_efuse *efuse = &rtwdev->efuse;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index a56c8befa077..8ecf047a7ee2 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -38,7 +38,7 @@ static void rtw8822bs_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->s.mac_addr);
 }
 
-static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
+static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
 	struct rtw8822b_efuse *map;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 32d9709f2c24..09315d23e2c4 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -41,7 +41,7 @@ static void rtw8822cs_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->s.mac_addr);
 }
 
-static int rtw8822c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
+static int rtw8822c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
 	struct rtw8822c_efuse *map;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
index c298fa0fb2a6..5ffa29d18168 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
@@ -197,7 +197,7 @@ static void rtw88xxa_read_usb_type(struct rtw_dev *rtwdev)
 		efuse->hw_cap.ant_num, efuse->hw_cap.nss);
 }
 
-int rtw88xxa_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
+int rtw88xxa_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct rtw_efuse *efuse = &rtwdev->efuse;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
index d9c8db58909c..6597ca0dfc5d 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
@@ -140,7 +140,7 @@ struct rtw_jaguar_phy_status_rpt {
 #define RF18_BW_MASK		(BIT(11) | BIT(10))
 
 void rtw88xxa_efuse_grant(struct rtw_dev *rtwdev, bool on);
-int rtw88xxa_read_efuse(struct rtw_dev *rtwdev, u8 *log_map);
+int rtw88xxa_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map);
 void rtw88xxa_power_off(struct rtw_dev *rtwdev,
 			const struct rtw_pwr_seq_cmd *const *enter_lps_flow);
 int rtw88xxa_power_on(struct rtw_dev *rtwdev);
-- 
2.55.0

