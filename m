Received: from e226-12.smtp-out.us-east-2.amazonses.com (e226-12.smtp-out.us-east-2.amazonses.com [23.251.226.12])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C657B332615
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 14:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.226.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788012559; cv=none; b=RD3ral9lCK+JLUZUzgiwLuiDXqMmQ08jiUm1hotAgdjvlmx12SflHD3bhg/AvPchWeHPnAH6clR1BD3zpclSViD6RM5yEGnhgO2aZaOYL4CLdKW1NjT52q+DW5gT6lkO51nB/JIZ/uWKC6ApSGYGdshWSZMptlaxyIPE5SkMbrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788012559; c=relaxed/simple;
	bh=PmTWUAfUcUA8kFEqNxvgJ/kU8+uM749YDgXzUnXApM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VGNzh3U0HR/1MKKYYOEmV3jfDYK3f9RAWdyJScUQhrxZHuBAKRlGWzy/stQRqVhLe9uocbiJJAwsYPs3tv90b8pppXWzK6+oIE5CcI5xUP/9TT4GEmVOWRrwNAoTM6bi5b/8/K284t6iVgM/E91uJfVPSyeJLGt7MBGSdYpRSlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=venenga.com; spf=none smtp.mailfrom=ses-relay.venenga.com; dkim=pass (1024-bit key) header.d=venenga.com header.i=@venenga.com header.b=yBWMlOR+; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=KrEYRuz/; arc=none smtp.client-ip=23.251.226.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=venenga.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ses-relay.venenga.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=venenga.com header.i=@venenga.com header.b="yBWMlOR+";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="KrEYRuz/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=pcbcfjs7ujmqksael7fxa3wo7bayjouh; d=venenga.com; t=1788012556;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=PmTWUAfUcUA8kFEqNxvgJ/kU8+uM749YDgXzUnXApM0=;
	b=yBWMlOR+vG10fLicek9kh0e7MmTP594Dpqf6yV+Q7nrunKPfdi8qFCK3IfCwxMdn
	DNeyBdFn4xmL1mPW8hw9IDTOauwN4QdzsSFxk3VJ0zV3KWCvVJsZl80Fqv2xE48Avxa
	vtyIAssKYhYVZGPbLRF4S/JLaESwnodsXSkXOfok=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=kra23psoka5qyyh6gdejiiuof3nluwuz; d=amazonses.com; t=1788012556;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=PmTWUAfUcUA8kFEqNxvgJ/kU8+uM749YDgXzUnXApM0=;
	b=KrEYRuz/FIhRJcR8lpPVx6iN2T3eVz5oEv5t1XUgngnfYvaNSn2dkw+JTgp8gEuA
	SsZAG05RULaOuQteeQelLVX3lzvqmC+QS1qwL1oehADKY6TsEP5zmVCMqDMO6ndKBbg
	peH9N6wTNf6tJVD3iP+PpA9vk0sI9y/v+/nCkWyM=
From: nick@venenga.com
To: linux-wireless@vger.kernel.org, pkshih@realtek.com
Cc: Nick Venenga <nick@venenga.com>
Subject: [PATCH rtw-next] wifi: rtw89: add ASUS BE93
Date: Sat, 29 Aug 2026 14:09:16 +0000
Message-ID: <010f01a04dda7149-4e2628cf-4fc0-40f1-bd49-1c94cceccdfb-000000@us-east-2.amazonses.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: ::1.us-east-2.Gp3Q+tRhOMwNNNSu6vJHeaJdVgiavF2vrJAUloPIlNg=:AmazonSES
X-SES-Outgoing: 2026.08.29-23.251.226.12

From: Nick Venenga <nick@venenga.com>

ASUS USB-BE93 Mini USB-C adapter
Originally added and tested here https://github.com/morrownr/rtw89/pull/121

Signed-off-by: Nick Venenga <nick@venenga.com>
---
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

