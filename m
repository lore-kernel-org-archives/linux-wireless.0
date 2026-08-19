Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA1F44063C
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 20:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787169976; cv=none; b=hlY9IEUQMLCPpUGLdsv8eB+68xj5TbtI2lpacaH02SzkmaUOG/BShRF/JvNnPSPzrgLYBPj2OksM4Fn4tZJAdpCW46LhmIltAVrTLvNsrjeUaRN/CApBL6PQPIqqZrmfXafoPK6neM2+KpThQgScaQzi41dZAaw4fIgnHw14XeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787169976; c=relaxed/simple;
	bh=4dLIEaIDijGcljaUF1vn+F4h+7ThVL6b/5s2j+aMNKw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=JLn2ENH2Lx0B3HdEYmM7JumTguUCv0B2ZhYzgNYuD0cnsxNq5m++O/w6IlE72rz+wR2hCBB5v905zCZL66h9xrzO4Ql9ozoOeDtsHYa0M3JGWSPyoMrvdZ2PG0E48oRDrlnI0ZM1Ub80qbHW52ZEHvcjAjtDhHWICvnkKPCnkho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L5LO0yC+; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L5LO0yC+"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so13437145e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787169972; x=1787774772; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:content-language:cc:to
         :subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8qvkf08pEyjpUfpH3wxxev6LNXrjPV6hczsBjA3JW2A=;
        b=L5LO0yC+gFvgX2jACf+cA1ZneBLxTC9G0x8e4POCkhPIZCEO5hfXVgR/mx/WqXDZBx
         CHbhwN7wUvDnby/SX4z2xfbhmVQ7eUklaaEjuLaBobjD8NvUCImyRMhbBOhSpT85odYN
         UDNBpoSIeoTJH3DuRQiFUdiqegmvnt+AvKTqlOplwSbzm40njn+kIUGmVsnfDnpvb/ao
         RRZ2TX47QiZ2Z6peoUhtvbLYE5JzQItHpvXxDboiAEQcemh7sytU5jGIV35hlIXf2Iyv
         RXQxKwC8G6Phkkv7gLalAK0yVjhIN21fI5Dgzu1oQTKkLcBCNT9fi0FBaAE0lY7bf7KA
         lfNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787169972; x=1787774772;
        h=content-transfer-encoding:content-type:content-language:cc:to
         :subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8qvkf08pEyjpUfpH3wxxev6LNXrjPV6hczsBjA3JW2A=;
        b=PHwAEkiJItfps4fo5iFdbTCTh3RCSgiXhR5N5MlIVVELOtFPy+3Knf66vZOgggaepF
         zCMMVrUBoACLjIu2jZE5FnsRofQLjmZlPva2lMXQHGqpDWIDzhyF10zw4sLKacJIBC7T
         P+xkEsrktR+j60nG9N+l+tl2OkqXtOckHr2V1BpduDSynw+LVpuGNyNQMQqu50b0apwl
         aPZpSqEsp+/iS4lsf1ECsi1xxQtBbkHoLOh3LCyCgC8Bf+mQPYXu3j7dqdkx4KK1yRN9
         g7Qd2FDCjw9LMxLa3/FN65z0fcKelEMmiUuAc4cNMEmJu13Dr84EXyE7H1RHAGSVyf11
         KNLQ==
X-Gm-Message-State: AOJu0Yzm3rLSpUcoa9zIaBVDNOKccabQ2JvKrvuv/d8xNGZSkHBYYFu+
	0Z5kP8b6GrHm3vcIE9GGCjD0xspR1CkuI9lq/VHo4s7rYr4oRckjQUdsDOFsqA==
X-Gm-Gg: AR+sD13oKiQuurK5pZlSlKR6hiVOcE6qS8V0YoxBx4rbol1KTU4DdlxKuEjRZ6fC8+2
	GPe1Ut+BfBVFA+Fgsf4n1TVeIUYM8PlixsGT9OFWuoRCRdwCtvU4tX4aHFeD0uYkcAla8nt4SMZ
	P8D7fA8kuJcxF+ddVI8hpuRvLyfeSaam2aSYmiIej8hOkwsRUwnaiHz7le3/cYuK6dVkJbcBXlA
	a/E9uHVV0pES3jXfZXc2UGdJ7PSrPL6A8xsHuPvogZ7QNZp13DnUXsDqKd79pYOKXsyEuipxZ68
	7mng1Mf31CtkhnQp9qaYAQhJurjZWLLbEZMqjHq8pO/QSmTuz6bd8v4plmZgJaMnt73FoE8kX37
	Vl7Vq9RfGn2Lj/mVNnXHPHm0dTCuwGwvmsBS0+QkzPO9YCPPi3kkKJ0IC77vbWimHPy1KDzlru3
	wEBk6t5kdSYGuDc3OyFxsw2jCUHifDGuvili5lK3Akq4EuCB2y6EcMxI9eT2x5968CUNGh7A==
X-Received: by 2002:a05:600c:5294:b0:492:4e09:9fc1 with SMTP id 5b1f17b1804b1-499aa1f5413mr145086285e9.15.1787169972200;
        Wed, 19 Aug 2026 13:06:12 -0700 (PDT)
Received: from [192.168.1.50] ([79.119.240.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa1111b2sm113893495e9.5.2026.08.19.13.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 13:06:11 -0700 (PDT)
Message-ID: <7a537b2e-67d2-40fb-8ef2-fcbc7bbc93af@gmail.com>
Date: Wed, 19 Aug 2026 23:06:10 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next v2] wifi: rtw89: usb: Avoid crash with dynamically
 added device ID
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Adding a device ID via sysfs causes a crash when the device is plugged
in, because the driver_info pointer is null.

Check for null driver_info in rtw89_usb_probe() and add a wrapper in
each driver to pass it a reasonable default value.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
v2:
 - Simplify the wrappers, move the null check into rtw89_usb_probe().
---
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/rtw8852au.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/rtw8852bu.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/rtw8852cu.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/rtw8922au.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/usb.c       | 5 ++++-
 drivers/net/wireless/realtek/rtw89/usb.h       | 3 ++-
 7 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
index 1e827205f254..6672ebe68f17 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
@@ -59,10 +59,16 @@ static const struct usb_device_id rtw_8851bu_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8851bu_id_table);
 
+static int rtw8851bu_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtw89_usb_probe(intf, id, &rtw89_8851bu_info);
+}
+
 static struct usb_driver rtw_8851bu_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtw_8851bu_id_table,
-	.probe = rtw89_usb_probe,
+	.probe = rtw8851bu_probe,
 	.disconnect = rtw89_usb_disconnect,
 };
 module_usb_driver(rtw_8851bu_driver);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852au.c b/drivers/net/wireless/realtek/rtw89/rtw8852au.c
index 065f4e5b17af..1a2e5dfbaab3 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852au.c
@@ -73,10 +73,16 @@ static const struct usb_device_id rtw_8852au_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8852au_id_table);
 
+static int rtw8852au_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtw89_usb_probe(intf, id, &rtw89_8852au_info);
+}
+
 static struct usb_driver rtw_8852au_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtw_8852au_id_table,
-	.probe = rtw89_usb_probe,
+	.probe = rtw8852au_probe,
 	.disconnect = rtw89_usb_disconnect,
 };
 module_usb_driver(rtw_8852au_driver);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
index de79a19a2824..550fc4ac7a21 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
@@ -73,10 +73,16 @@ static const struct usb_device_id rtw_8852bu_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8852bu_id_table);
 
+static int rtw8852bu_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtw89_usb_probe(intf, id, &rtw89_8852bu_info);
+}
+
 static struct usb_driver rtw_8852bu_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtw_8852bu_id_table,
-	.probe = rtw89_usb_probe,
+	.probe = rtw8852bu_probe,
 	.disconnect = rtw89_usb_disconnect,
 };
 module_usb_driver(rtw_8852bu_driver);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852cu.c b/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
index 2dec9b845481..6f852f4a713e 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
@@ -133,10 +133,16 @@ static const struct usb_device_id rtw_8852cu_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8852cu_id_table);
 
+static int rtw8852cu_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtw89_usb_probe(intf, id, &rtw89_8852cu_info);
+}
+
 static struct usb_driver rtw_8852cu_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtw_8852cu_id_table,
-	.probe = rtw89_usb_probe,
+	.probe = rtw8852cu_probe,
 	.disconnect = rtw89_usb_disconnect,
 };
 module_usb_driver(rtw_8852cu_driver);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922au.c b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
index 56c79b1ec865..2cd2b76d19ac 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
@@ -74,10 +74,16 @@ static const struct usb_device_id rtw_8922au_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8922au_id_table);
 
+static int rtw8922au_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtw89_usb_probe(intf, id, &rtw89_8922au_info);
+}
+
 static struct usb_driver rtw_8922au_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtw_8922au_id_table,
-	.probe = rtw89_usb_probe,
+	.probe = rtw8922au_probe,
 	.disconnect = rtw89_usb_disconnect,
 };
 module_usb_driver(rtw_8922au_driver);
diff --git a/drivers/net/wireless/realtek/rtw89/usb.c b/drivers/net/wireless/realtek/rtw89/usb.c
index 6f19d0eb3417..129a8838f50f 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.c
+++ b/drivers/net/wireless/realtek/rtw89/usb.c
@@ -1207,7 +1207,8 @@ static const struct attribute_group rtw89_usb_group = {
 __ATTRIBUTE_GROUPS(rtw89_usb);
 
 int rtw89_usb_probe(struct usb_interface *intf,
-		    const struct usb_device_id *id)
+		    const struct usb_device_id *id,
+		    const struct rtw89_driver_info *default_info)
 {
 	const struct rtw89_driver_info *info;
 	struct rtw89_dev *rtwdev;
@@ -1215,6 +1216,8 @@ int rtw89_usb_probe(struct usb_interface *intf,
 	int ret;
 
 	info = (const struct rtw89_driver_info *)id->driver_info;
+	if (!info)
+		info = default_info;
 
 	rtwdev = rtw89_alloc_ieee80211_hw(&intf->dev,
 					  sizeof(struct rtw89_usb), info);
diff --git a/drivers/net/wireless/realtek/rtw89/usb.h b/drivers/net/wireless/realtek/rtw89/usb.h
index bdf312559743..d2af29d068f1 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.h
+++ b/drivers/net/wireless/realtek/rtw89/usb.h
@@ -95,7 +95,8 @@ static inline struct rtw89_usb *rtw89_usb_priv(struct rtw89_dev *rtwdev)
 }
 
 int rtw89_usb_probe(struct usb_interface *intf,
-		    const struct usb_device_id *id);
+		    const struct usb_device_id *id,
+		    const struct rtw89_driver_info *default_info);
 void rtw89_usb_disconnect(struct usb_interface *intf);
 
 #endif
-- 
2.55.0

