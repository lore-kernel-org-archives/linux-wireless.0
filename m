Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDCF39D6E5
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147710; cv=none; b=i7/lRz/0XfiRsQ04aZTL7zMHJtrmPAi7ji4vy3ke1CUs6qw2yrmhr9c+Y3aGVHTMUrvYgyUa8k6ZjhK62cQx943qHZZV8PRsDX/ulJU6RbwE0gR9Zs8zw/lsb4EY7sUtPaB82+lRi2O695Dg9aBq4172lDqWR4Mq8h6IrO2avDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147710; c=relaxed/simple;
	bh=g0rQGuLl0z64Pgt/PvtJItw0riDFxkM8xasqeQ3KMmg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ejg6JznaLiAxkOmI8hkfZYxV1mrxcyCshUF5yzaJN4ngGLW2YaIvs9iAmMNAPMt5u9ALgFDXVG5JSq5rIYPX1y11BOWcyXPPBDtHs5O3ewVVL2sARPoh+o8cqQMHY7EHee09jvxV18NdsJddM90LWPPssaVhWKvIi+fXxDSXkfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Bvld1xd8; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Bvld1xd8"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7F5beC132843, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790147705; bh=wguEtzLOGtGOw/JYqZlhTZYAZfkBQ4tlf6YswpHsY4c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Bvld1xd8LPU/d1zUgPEgWKBvT4crMAb58gB+Igai38gH7raHKTcEiI6DLqkJMy2oy
	 O4dRa8/M9l7tA9P+kIByMxgif6JEul/Z4D/mKSYP4r4zwqKfSLR2VxwadZOuCNsOFB
	 JOTTKooC9ZS6FtLfg0FHL2VWfZ84pbvFmiUKXJorPx+aVfwGmBV8Sitg948KdSWMEN
	 jXJenQEX3MrXe8E1CjjtazFjxaDMM3hZ1jHWZZge/qhGqWu2NqbFVHQHipSo41HLxZ
	 WKxCO5wypYW71JmmfEINKQJhLPFwGLAKWAhJvLvgTyfyIwRPNdaoIEGRMxG4IR1Waz
	 3DkfPTHw50AfA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7F5beC132843
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:15:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:15:05 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 15:15:05 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 5/7] wifi: rtw89: add instance of IO ops for (un)pack and [um]delay
Date: Wed, 23 Sep 2026 15:13:52 +0800
Message-ID: <20260923071354.50864-6-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260923071354.50864-1-pkshih@realtek.com>
References: <20260923071354.50864-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

To make IO wrappers of pack/unpack/udely/mdely can intuitively call
the loaded IO ops as others do, add corresponding instances for them.
And, expect all rtw89_io_ops initializers should assign all members.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h | 38 ++++++++++++++---------
 drivers/net/wireless/realtek/rtw89/fw.c   | 10 +++---
 2 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index fc51419a1782..128667fb95b0 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -8097,36 +8097,44 @@ struct rtw89_tx_skb_data *RTW89_TX_SKB_CB(struct sk_buff *skb)
 	return (struct rtw89_tx_skb_data *)info->driver_data;
 }
 
-static inline int rtw89_io_pack(struct rtw89_dev *rtwdev)
+static inline int rtw89_raw_io_pack(struct rtw89_dev *rtwdev)
 {
-	if (rtwdev->io->pack)
-		return rtwdev->io->pack(rtwdev);
+	return 0;
+}
 
+static inline int rtw89_raw_io_unpack(struct rtw89_dev *rtwdev)
+{
 	return 0;
 }
 
-static inline int rtw89_io_unpack(struct rtw89_dev *rtwdev)
+static inline void rtw89_raw_io_udelay(struct rtw89_dev *rtwdev, u32 us)
 {
-	if (rtwdev->io->unpack)
-		return rtwdev->io->unpack(rtwdev);
+	udelay(us);
+}
 
-	return 0;
+static inline void rtw89_raw_io_mdelay(struct rtw89_dev *rtwdev, u32 ms)
+{
+	mdelay(ms);
+}
+
+static inline int rtw89_io_pack(struct rtw89_dev *rtwdev)
+{
+	return rtwdev->io->pack(rtwdev);
+}
+
+static inline int rtw89_io_unpack(struct rtw89_dev *rtwdev)
+{
+	return rtwdev->io->unpack(rtwdev);
 }
 
 static inline void rtw89_io_udelay(struct rtw89_dev *rtwdev, u32 us)
 {
-	if (rtwdev->io->do_udelay)
-		rtwdev->io->do_udelay(rtwdev, us);
-	else
-		udelay(us);
+	rtwdev->io->do_udelay(rtwdev, us);
 }
 
 static inline void rtw89_io_mdelay(struct rtw89_dev *rtwdev, u32 ms)
 {
-	if (rtwdev->io->do_mdelay)
-		rtwdev->io->do_mdelay(rtwdev, ms);
-	else
-		mdelay(ms);
+	rtwdev->io->do_mdelay(rtwdev, ms);
 }
 
 static inline u8 rtw89_read8(struct rtw89_dev *rtwdev, u32 addr)
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 535cc2ad8611..7cf51e78ce98 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -12916,8 +12916,10 @@ static int rtw89_fw_cmd_ofld_enqueue(struct rtw89_dev *rtwdev,
 }
 
 static const struct rtw89_io_ops rtw89_raw_io = {
-	.pack = NULL,
-	.unpack = NULL,
+	.pack = rtw89_raw_io_pack,
+	.unpack = rtw89_raw_io_unpack,
+	.do_udelay = rtw89_raw_io_udelay,
+	.do_mdelay = rtw89_raw_io_mdelay,
 	.write8 = rtw89_raw_write8,
 	.write16 = rtw89_raw_write16,
 	.write32 = rtw89_raw_write32,
@@ -13096,7 +13098,7 @@ static void rtw89_fw_cmd_ofld_udelay(struct rtw89_dev *rtwdev, u32 us)
 
 	ret = rtw89_fw_cmd_ofld_enqueue(rtwdev, &cmd);
 	if (ret)
-		udelay(us);
+		rtw89_raw_io.do_udelay(rtwdev, us);
 }
 
 static void rtw89_fw_cmd_ofld_mdelay(struct rtw89_dev *rtwdev, u32 ms)
@@ -13110,7 +13112,7 @@ static void rtw89_fw_cmd_ofld_mdelay(struct rtw89_dev *rtwdev, u32 ms)
 
 	ret = rtw89_fw_cmd_ofld_enqueue(rtwdev, &cmd);
 	if (ret)
-		mdelay(ms);
+		rtw89_raw_io.do_mdelay(rtwdev, ms);
 }
 
 static const struct rtw89_io_ops rtw89_fw_cmd_ofld_io = {
-- 
2.25.1

