Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26EF492E38
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937278; cv=none; b=B2QhQKLIkHHbFP6cGi6GN6HPxZeL0YFqakgOpXbtoEFLRMi5jiy838seYq2JeF2U4jfKmGxmSrBah3VbkWQEH3NSoZ3IA3TlaXvxdOu0qVcE0cCY2XJM8LDQHPtIXC1r4ot2560xHvvmeoJ5G8GpLjxYCZ4bcEaynfZZy71NnoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937278; c=relaxed/simple;
	bh=wqC3h71XKRcklMVgdb4Gjk8sbTf4nX0HGXGr6EKvk9I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PbUaK0G9YjUPg3u4ikNTxC/qOd471XJ2jXTv2j8cSgZp7yTFi/0oDANSX07ieNHtkKKA+Lf1z2A3ftpqxhV6ltoWecKr4IOM09VqP0fDmJRtcJ5PvN4xKRZYKd73HFJz9bDJjSftZNvj4GoWQQq3SGVYE5CBy8pZJTMwldSGTcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=bHWmbtVs; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="bHWmbtVs"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68971E3s8356835, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937274; bh=9R28g3W8gLQ5TtUTV/ObEnUptAsggX9SOSEDM37qa8g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=bHWmbtVsLRoGAsZLVrJF1Nx1ekoBbOAFC4hAm+j4Zpb2DK81I7LZXypQl61S5ipUJ
	 +sgfUp0Loyea8x8P0EdCf3umvTPvwceS9SS4GVoJcwuQT9n0sawJCunqMDEkFb7o9x
	 qwox8/2ahrYRBlrJQiKMTGyL156DOj3GziVyXHJVrD5pyVcIG3Cp9bhcbCAE4+0bqT
	 /kY/RFNOOTawn3/wQmnSgOu0Au6N0Uf4oBqjLaLqGTbKagGY7MgRR3tukYTutBr3jE
	 Fmw3QUDszNyBDRx6GornUQ18t9LbFxCsxTjPqlhvCVvSw/supUFcj2hx+DOeFbNTrG
	 j0gsFfQyiM9Wg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68971E3s8356835
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:01:14 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:14 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:14 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:01:13 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 07/15] wifi: rtw89: fw: cmd_ofld_flush always reset counter
Date: Wed, 9 Sep 2026 14:59:56 +0800
Message-ID: <20260909070004.35353-8-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260909070004.35353-1-pkshih@realtek.com>
References: <20260909070004.35353-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

Callers expect cmd offload counter is reset after flushing, and then
use counter++ with array index. Previously, it might cause OOB since
cmd_ofld_flush gets an error, e.g out of memory, and does not reset
the cmd offload counter. Fix cmd_ofld_flush to always reset it.

Resolve OVERRUN (Out-of-bounds write) reported by Coverity.
Pass info to cmd_ofld_flush to make Coverity aware the changes on
cmd offload counter.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index a16127b2c317..dcbdf4b5e4b2 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -12643,9 +12643,9 @@ static int rtw89_fw_cmd_ofld_pack(struct rtw89_dev *rtwdev)
 	return 0;
 }
 
-static void rtw89_fw_cmd_ofld_flush(struct rtw89_dev *rtwdev)
+static void rtw89_fw_cmd_ofld_flush(struct rtw89_dev *rtwdev,
+				    struct rtw89_fw_cmd_ofld_info *info)
 {
-	struct rtw89_fw_cmd_ofld_info *info = rtwdev->fw_cmd_ofld_info;
 	struct sk_buff *skb;
 	int ret;
 	u32 len;
@@ -12654,7 +12654,7 @@ static void rtw89_fw_cmd_ofld_flush(struct rtw89_dev *rtwdev)
 	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
 	if (!skb) {
 		rtw89_err(rtwdev, "alloc skb fail\n");
-		return;
+		goto out;
 	}
 
 	skb_put_data(skb, info->cmds, len);
@@ -12669,12 +12669,13 @@ static void rtw89_fw_cmd_ofld_flush(struct rtw89_dev *rtwdev)
 	if (ret) {
 		rtw89_err(rtwdev, "failed to send cmd ofld\n");
 		dev_kfree_skb_any(skb);
-		return;
+		goto out;
 	}
 
 	if (info->accu_delay)
 		fsleep(info->accu_delay);
 
+out:
 	info->cnt = 0;
 	info->accu_delay = 0;
 }
@@ -12694,7 +12695,7 @@ static int rtw89_fw_cmd_ofld_unpack(struct rtw89_dev *rtwdev)
 	if (info->cnt == 0)
 		return 0;
 
-	rtw89_fw_cmd_ofld_flush(rtwdev);
+	rtw89_fw_cmd_ofld_flush(rtwdev, info);
 
 	return 0;
 }
@@ -12721,7 +12722,7 @@ static int rtw89_fw_cmd_ofld_enqueue(struct rtw89_dev *rtwdev,
 		return -EFAULT;
 
 	if (info->cnt >= ARRAY_SIZE(info->cmds))
-		rtw89_fw_cmd_ofld_flush(rtwdev);
+		rtw89_fw_cmd_ofld_flush(rtwdev, info);
 
 	h2c = &info->cmds[info->cnt++];
 
-- 
2.25.1

