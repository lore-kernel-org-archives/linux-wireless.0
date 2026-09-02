Received: from e226-11.smtp-out.us-east-2.amazonses.com (e226-11.smtp-out.us-east-2.amazonses.com [23.251.226.11])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592EA1FCFFC
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 00:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.226.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788310753; cv=none; b=ZaLTZmdjXdteltdcBL8Grib6o9ytrHPIWGTNAb5wPGznaT38VE80JvzN6pGqiNI0DEP5Z+zn5RU6lmqokwXLknIN+uAU0xLswO4mjmy0XWUmyQiO5qEAXZMxdZXx0XRx4iMf0m1ae/g9HxO9MYSMPd92rMkxPhBY4EjkiW30Hs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788310753; c=relaxed/simple;
	bh=0Vulr7xI1zDqRYUgsWzWA+XMP5YAZz0vAHKY4j7TLns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbnTyTDdLrTZZznE+0EaqNwIGTUSXJxQG6jMMQC+1evWsFWyYRzEPGEOpIXT14tNfPUvsvb9Zc6dUOCHPAIPE+VIz6aAIRNU22WpqA6hjM2ReXPzMwi6wBeKItgJFfeG4jx4/VPSeVsouCUnnGFH7yGRvjolUELvpXmzu6Ts7bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=venenga.com; spf=none smtp.mailfrom=ses-relay.venenga.com; dkim=pass (1024-bit key) header.d=venenga.com header.i=@venenga.com header.b=Or35jPkr; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=KwOjPspU; arc=none smtp.client-ip=23.251.226.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=venenga.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ses-relay.venenga.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=venenga.com header.i=@venenga.com header.b="Or35jPkr";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="KwOjPspU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=pcbcfjs7ujmqksael7fxa3wo7bayjouh; d=venenga.com; t=1788310750;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0Vulr7xI1zDqRYUgsWzWA+XMP5YAZz0vAHKY4j7TLns=;
	b=Or35jPkrSku8E6ov+t0mFbbdxfN/Avv+MoLCA+6pmc79YroEBWPwf/Qirrad22Zg
	7RR3SRHCTWJfdxu43ovH2nqDnzqBnU7ZsBIx9viF+VGHqKrnQO6Q9nkjhl4VrLcl6nm
	NF19iXN7xPgXZp5EyjYUAFC+aVoB3AeRKM0kFq3E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=kra23psoka5qyyh6gdejiiuof3nluwuz; d=amazonses.com; t=1788310750;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=0Vulr7xI1zDqRYUgsWzWA+XMP5YAZz0vAHKY4j7TLns=;
	b=KwOjPspU/o/lX6UbjawIbgkuHijvfDumpifOSHzXhCLWRg7+Ts9M9WG2sHBfvQXz
	Rq9f49WKKspxTeMSECiLsaert+K1UcWdv+ray3+BcBBCOLO/Ms0BAndsytIKaD3O93n
	nONN06p6lKAbZKSauLybGq5EBMoq2gGruWdr2wyw=
From: nick@venenga.com
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com, Nick Venenga <nick@venenga.com>
Subject: [PATCH v2 rtw-next] wifi: rtw89: 8922au: add ASUS BE93
Date: Wed, 2 Sep 2026 00:59:10 +0000
Message-ID: <010f01a05fa084ba-80349068-cd1f-4e4e-99f5-8cf6f4c03216-000000@us-east-2.amazonses.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829140823.2213829-1-nick@venenga.com>
References: <20260829140823.2213829-1-nick@venenga.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: ::1.us-east-2.Gp3Q+tRhOMwNNNSu6vJHeaJdVgiavF2vrJAUloPIlNg=:AmazonSES
X-SES-Outgoing: 2026.09.02-23.251.226.11

From: Nick Venenga <nick@venenga.com>

ASUS USB-BE93 Mini USB-C adapter
Originally added and tested here https://github.com/morrownr/rtw89/pull/121

Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Nick Venenga <nick@venenga.com>
---
Changes in v2:
- change subject to "wifi: rtw89: 8922au: add ASUS BE93" (Ping-Ke Shih)

 drivers/net/wireless/realtek/rtw89/rtw8922au.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922au.c b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
index 56c79b1ec865..7fba7b1511e4 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
@@ -52,6 +52,8 @@ static const struct usb_device_id rtw_8922au_id_table[] = {
 	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0b05, 0x1bd2, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0b05, 0x1d84, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0bda, 0x8912, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0db0, 0xda0e, 0xff, 0xff, 0xff),
-- 
2.55.0

