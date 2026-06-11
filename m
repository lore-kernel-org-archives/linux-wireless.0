Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8CB376A11;
	Thu, 11 Jun 2026 08:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781166085; cv=none; b=tzLDE9eYQrecl9tI9KW8GPirF1AZaskoAW2hClOKLJxtmzWrdwFBFb+NzBzP4Ywady3K89rbwVz2RXDaPsmIM6mmSwnG3H2Z+pZ9nbj7x3CDMpt9tkR4Z1/Qvr31VkF12896fdaVlnEj/pWumo2wSZchlb5b3OgqbeKhU7PHctE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781166085; c=relaxed/simple;
	bh=dzZZPLoE4D73QgpapAJEMj3PtzEXIGzczvJsYJ0heWQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gveCD9XONKTlRJFPgDtRKNOc6C3JY7aFHIs7Py1n7O+pthuHqwj1q6IOr1MnHVI+Kz31pweihMFi2RIbPq53q2tjrAOTtyDYoM7SWbBT87yPIxXynGohnQGwmxDuFyLdPttHZQrugmjghADQjfiBKktZjQclQ+yv6eoDYy4tmlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=iIicZ0ld; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="iIicZ0ld"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781166067;
	bh=W4cRF6gpQ/RyW3B+7OPS/lw42KrrPLmWE6UFELr/q70=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=iIicZ0ldrXS1P9LZ2zPZXZJuhqa8Zpdr7Awvx/U76D/ONlP+CmFVQz+ngsMA9oFMk
	 crVaZ+xhabXjxFgjGdCOFpIXcjtbB6P7icwUn3i7Eu0029Go0t1so2BOQ5fNRcpGdx
	 lhfCSCSy+Yd0If+Yc7K5mQ4mGDSIvqEsOWBnYFTg=
X-QQ-mid: zesmtpsz6t1781166026t14533e60
X-QQ-Originating-IP: 2zpnon/zTLuGTYcCUKvjQ2o3s+xmfK5yMgZMwvBGSls=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 11 Jun 2026 16:20:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 293353262799888729
EX-QQ-RecipientCnt: 7
From: Wentao Guan <guanwentao@uniontech.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dian_syuan0116@realtek.com,
	zhanjun@uniontech.com,
	niecheng1@uniontech.com,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH] wifi: rtw89: fw: correct rtw89_fw_h2c_default_cmac_tbl_be()
Date: Thu, 11 Jun 2026 16:20:21 +0800
Message-Id: <20260611082021.46650-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NJT5C3zFSytJTEHN1cp8/oNaHb21NwlevNlUVrB7lCfMa9hwc65qrgWW
	swjGSqnjLlfSixYILwov48iGieHg2dkQWeQEdr0eab/LJpy3Hh3Om4frxXSf7lxuQSufnNN
	Dr/WASPAC7+9lsa3qrFLCXTqsOdaHXYhS+G1vfblWzYgd+K3eRXpxpkdRo2I8GMXk5iSI56
	cuA+B1QMyWNRu6TO/I67brWmyZD2t6qmIzR0u0ZR82LXXrb6WJ3XDdk4Za7yl5DjS2LnH4P
	ycm6FrCr/pg8Q0lb5CnqFTiVU5Hg6WZT9ySm+pDnJXKyVgX/oYz2gTvFEzktq7kbmpGaspd
	d/xAZsHbSZELKhi0yJQ6GRUpk2furJCYrzvvMLivFWjMuuQA/pjnabTocsDAHG7g60Euk19
	NfNAg6zLWYHOJV2HR+O1Ikl64N+M8j54Vje9HlR+QpijAe4r4rc2KY7sROE0OmsifN2NBAN
	kWRUlyRMm+lJvhrGkwlaXTFy/FCn7QPgwVNZjfAgXh1SEFYGGvwXnJPY9WY8a/aXQGtobfe
	04RlGdylk30ep0VsvcZKE8FX8lv8MJaUYLEg7jk+FTSuvr0xwoLoyBYhpFmHM2xT2EK0/4z
	CYacz9jf3aSXthZRS/5uI8g177cm+tiH3NuvLVLS5VbffLZ1VzzL279aF2cMBry1ZgVmyhk
	JXZjADj5UmQaUS+88shqzmpZg8R5qTVeXmzLedh87/VpjMH+rF0bzHbsBOqkkDrNXD6UK2m
	lrbJ/qQh9njqKzqVSyXJXDnC54jNXmpp0i9jq7wwUUgyluOnTRq9ZxB+Z1KDmcLIJxLSC3h
	mbDCFWOORJIqTsxWXhJpKZ31NLyZ0z+1k/WoVXJBg9pgc86k+/iOJnz4a69R1mVzwFq++ZK
	AlXLhISr9NzDe/ch968yunGEpUGgbRbJua1gVNVsExICUD/grwHTcM14UnACYnxpuhl3hhR
	irjZ8l7kMfNX3gv4x2QUnoTUQ8AXMuT9+N7YCzcOdLwY85kINgntsszsqkQm0i+Dirh4t87
	bh7hD8e3atDPDorYCKENFlWCTdMnmBVibcuw3qrt6GNyFepG9nf/wA6w+LBTSFM8rMqpF4a
	f9lVSqotI1E
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

BE_CCTL_INFO_W2_PRELOAD_ENABLE is for h2c->w2, not h2c->w1.
These will cause h2c->w1 wrong overlap by w2 and w2 not initialized.

Fixes: c73607b3a8ef ("wifi: rtw89: fw: add CMAC H2C command to initialize default value for RTL8922D")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 17704f054727a..af9bcdcef8fbb 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -3711,7 +3711,7 @@ int rtw89_fw_h2c_default_cmac_tbl_be(struct rtw89_dev *rtwdev,
 		  le32_encode_bits(4, BE_CCTL_INFO_W1_RTS_RTY_LOWEST_RATE);
 	h2c->m1 = cpu_to_le32(BE_CCTL_INFO_W1_ALL);
 
-	h2c->w1 = le32_encode_bits(preld, BE_CCTL_INFO_W2_PRELOAD_ENABLE);
+	h2c->w2 = le32_encode_bits(preld, BE_CCTL_INFO_W2_PRELOAD_ENABLE);
 	h2c->m2 = cpu_to_le32(BE_CCTL_INFO_W2_ALL);
 
 	h2c->m3 = cpu_to_le32(BE_CCTL_INFO_W3_ALL);
-- 
2.30.2

