Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792534832;
	b=M4ZnQ4aTeLxnS9AAzRYsZ5CrCyOYI6676H26iNMEPUwBdpAmr7+3AygzItrKrJwDVwxj
	 wc1ct2NZkVe3fflPxx2qZUyji2mz3UxRoUndribb6cDnoZS/uD2CuyUfd13CpbPiLHd//
	 uL8LiV0cki1xDbBqw++8rC8E9Yxu0SpPo4CidE6O8VOYcWzpDvQZqAH55qSo0S7rMnUjn
	 JiHceRnxVVK/6p0L0YpkrGFHvYUkIBmlGiQZtIa95ldyoeamTU2wz7NN3lEkGL9Z+6uWT
	 Jg6rkILY+snVaAY2JfK4LsDLx2zAy2HC2Yq4CKZ+5575Pdg8DcTqUH3DIqj2naPCrKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792534832;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=dUWC87/jhHLbmRY666KtGVMmBic1vgA55Zik/UJX/kQ=;
	b=5nM32+rZWxPc7ncDbBvXV3tCnDG7docbo/eI1FrpjyVWMCJ4b45RvTKhlp2wuiRfEBCH
	 gSileEACP/3ZrgCccuWRrsEuiACQQgENG5HsCe/iHB8cCg2ZtERiCvBkKBZn/3Qeqk84h
	 VAgZzNSY1V3IHI1BXDfov+JciZmiQjgBRKoUiXDRmr2stGK8w+M8jDDEA59pHvbtsVVp/
	 1mNGyAT6dfuqu7LytSOrdrp2h+79Rh5E7LnoTWMvyh/l0O6U8fwVyWrzvf/MzGwird+FF
	 ml8YcWIizm6uAxaTf9HWWaGLzCr6GkiYB1Pc0CMdw/VihDrY05Y07bJkYroba+VsQfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wiC4I0ZD;
	arc=none smtp.remote-ip=95.215.58.139
Received: from mta1.migadu.com (out-139.mta1.migadu.com [95.215.58.139])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA2F606A319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 22:20:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EA2F606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wiC4I0ZD
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=j8+BNvBK+SJ7PMZ0DTdOmPC22DoPYLXd+f6kC7PYi24=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792534828; v=1; x=1793139628;
 b=wiC4I0ZDd6Kx5Ms3n95x39gcjsPT+Xsomvy/9rmzP3Z9Ryisx9UP8bDOaKUCY8UIiV42r4gc
 05ELK7YLuoQqdR3WI7m8yhevll/KPPg2T9+2pQIJWyg/TIFwxhOQ8zNTmLWuBATVm/yIOD48FDv
 wFT7ksEuXEx7BCRfQQCCNu8s=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1fbea39f3385a20b;
	Tue, 20 Oct 2026 22:20:12 +0000
X-Mizu-Trace-ID: 1fbea39f3385a20b
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next] wifi: rtw88: 8723b: always report a single spatial stream
Date: Tue, 20 Oct 2026 22:20:09 +0000
Message-ID: <20261020222009.9116-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RTL8723B only ever has one spatial stream. Set nss and ant_num to 1
directly instead of deriving them from rf_path_num, which just happens
to be 1 on this chip.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
index 8bb9c03d769c..89190dd4f5c7 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
@@ -2365,12 +2365,9 @@ static int rtw8723b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	if (efuse->power_track_type != 0)
 		rtw_warn(rtwdev, "unsupported power track type\n");
 
-	/*
-	 * No firmware hardware feature report exists, so fill the hardware
-	 * capability here; a zero stream count kills the HT MCS set.
-	 */
-	efuse->hw_cap.nss = max_t(u8, rtwdev->hal.rf_path_num, 1);
-	efuse->hw_cap.ant_num = efuse->hw_cap.nss;
+	/* No firmware hardware feature report exists, so fill it in here. */
+	efuse->hw_cap.nss = 1;
+	efuse->hw_cap.ant_num = 1;
 	efuse->hw_cap.bw = BIT(RTW_CHANNEL_WIDTH_20) |
 			   BIT(RTW_CHANNEL_WIDTH_40);
 
-- 
2.53.0

