Received: from e226-7.smtp-out.us-east-2.amazonses.com (e226-7.smtp-out.us-east-2.amazonses.com [23.251.226.7])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335EF632
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 14:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.226.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788015206; cv=none; b=cY1b45FLtpSKSRUow2yD09LL49AGkbBerLtVpkrEWNykFNlXAVJTfF+lpv6HsfZ2TtHw/qxHIHaby5budF5gYnWvKMKqu4ELXyaAo1i4jwctIpK2qDlVqfyZ+98AJn5YDZdCliTVUaKgXyEg/ABLtFEmSIPy2IPMq58blJBY6xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788015206; c=relaxed/simple;
	bh=wa7TBonB6ebdisHElNZuObmDCgRuydhEAFKQch+fA5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZvHfpSmSjj+8acX6erkSyMCo7FtJk0DAX7gr/KUMQSE4EuOz2PFquZG3BuLtU5n6XawgWxKiRXrq+Z0Ua8A4XnKLzpcOeeVWFzjoXKunzYC5rH5rRPEs8pL92+JjSt0QwKTfi51N1oLGToVs0bos39DUnnJPiQAPWEGz2hOSvh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=venenga.com; spf=none smtp.mailfrom=ses-relay.venenga.com; dkim=pass (1024-bit key) header.d=venenga.com header.i=@venenga.com header.b=Cn0u9kxp; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=Jfk5BCVO; arc=none smtp.client-ip=23.251.226.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=venenga.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ses-relay.venenga.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=venenga.com header.i=@venenga.com header.b="Cn0u9kxp";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Jfk5BCVO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=pcbcfjs7ujmqksael7fxa3wo7bayjouh; d=venenga.com; t=1788015204;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=wa7TBonB6ebdisHElNZuObmDCgRuydhEAFKQch+fA5Y=;
	b=Cn0u9kxplnJ3IbHXNejrso9SXojUb2t5MpIvekyDqPEv0bgomwykWq8OdG2Vx+Pj
	u5xA5gDiK6GrpEqjuSPJbg/TvVx+gJniyZVTxrIabU7pTab4FnHjCOInZbMo9X2JSVu
	iCkh8tDPdXg4hKxQYfTBjlntvBPaO0+8haRQh3yg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=kra23psoka5qyyh6gdejiiuof3nluwuz; d=amazonses.com; t=1788015204;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=wa7TBonB6ebdisHElNZuObmDCgRuydhEAFKQch+fA5Y=;
	b=Jfk5BCVOYV7027NHHmSzeTVL0GuLkwfa9zPUL7myXqWgntlLowujJlm9Ngd+t7X4
	rL0TcOiZHsJ5APX02QYNkX9N6i8A1o4CE/4c28cQ+7HKy1oiomMraaDkgBixoc8SZbe
	jTaPkNI1JVJ7ml3crRQlhArCVA4Uo6nHsvN2iOYU=
From: nick@venenga.com
To: linux-wireless@vger.kernel.org, pkshih@realtek.com
Cc: tyrelpark@gmail.com, Nick Venenga <nick@venenga.com>
Subject: [PATCH rtw-next] wifi: rtw89: 8922au: Add support for TP-Link TBE400U
Date: Sat, 29 Aug 2026 14:53:24 +0000
Message-ID: <010f01a04e02d70c-a52abf35-2e60-47a5-99f5-b064b344ac19-000000@us-east-2.amazonses.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: ::1.us-east-2.Gp3Q+tRhOMwNNNSu6vJHeaJdVgiavF2vrJAUloPIlNg=:AmazonSES
X-SES-Outgoing: 2026.08.29-23.251.226.7

From: Nick Venenga <nick@venenga.com>

idVendor=37ad, idProduct=0104 TP-Link TBE400U (USB-C, no external
antenna)
idVendor=37ad, idProduct=0106 TP-Link Archer TBE400U Plus (USB-A,
antenna)

https://github.com/morrownr/rtw89/pull/123
https://github.com/morrownr/rtw89/commit/c98e6ff31c331be35383b5a500cfaf76620e2d0c

Signed-off-by: Nick Venenga <nick@venenga.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8922au.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922au.c b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
index 56c79b1ec865..808e43d476b7 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
@@ -64,6 +64,10 @@ static const struct usb_device_id rtw_8922au_id_table[] = {
 	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x37ad, 0x0101, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x37ad, 0x0104, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x37ad, 0x0106, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0x3822, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0x4822, 0xff, 0xff, 0xff),
-- 
2.55.0

