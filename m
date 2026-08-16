Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F6933E348
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 18:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786904437; cv=none; b=vBn8Sc1ek4RkuMgdoNs9hb9QXv2raRyDUS4+1StLBqW8lBgHbI2fr7IjKMXXPGl48GhgB8FjoVCtwxhkm+10LVhkr/PITq19zsytp98kNQhgabj4P9a0fv3lYgMfqHwV2if9VRrrYz4etyVbgwBESTuDPZ9PWcvQ3ZJYLLNz++g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786904437; c=relaxed/simple;
	bh=D/Ejqr4X6F2Fb4Ncev2q8F1j7UXlmpgHsy92rMgQdKs=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=uOniDKwegmS6Q5fErtRjAlux3XUbZwsJm6Pgfcj5CaCb/Lg9aLv8DWz0HlK+T2tR8bs8LUMDjF+wrfq3VKV8uMVcmFT5hTltOtQFxJ4LfEmvJhMeSnQMit44wTm1boSYvu+X91d9DCkuojdn0RkvMzDJKEIyePqZUCfugpU7yww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XqUH+Qse; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XqUH+Qse"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-495590dde14so33365345e9.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 11:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786904434; x=1787509234; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=f9i8i/JEhTR1lyzLIKOMzQ2G9aTyGEIIYhz7w/p9jhg=;
        b=XqUH+QsewE4mYAJOnqGwiywxC6n7DGcAqDhRpuk+LzN9Pp5UrAZPKTb0TLDwaM9k4d
         UQ7e6bkwS9GWMSc/pj9KalBHJWPkWFBd5SrBFOFLJ5X2v9MMZkexOAr7fhrY9PiWB0F9
         TCqIN26wvVA0WkAGDzdijcpZJ+r5BYLML2fqUUNw57H4PmKGKx88VUU4+rH1wnl9Wxsk
         sZHhBof7WGze1hHWS/yx9FsrWQtYLFabDIhcHCdH6gFbw9cVdnoCTSbQtbq5UKXjtfrD
         E5kNBgF1rNg9LaOWKSmGnnRcOPVu724GtKAbpxCbZ9CEAQ+TB30Vmjhmhd2ale0EXNQN
         Izgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786904434; x=1787509234;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f9i8i/JEhTR1lyzLIKOMzQ2G9aTyGEIIYhz7w/p9jhg=;
        b=cx0kPtKt8+4yU4d7W+PyKJLhGuf/CFChzWrXAt67RjFz7Ppf56ZgjIc8feTpno7e9e
         nX2MuHXEkPHamarNHOAiWUJRlxYB0TZxFClZkH8TAFX8TqCYc2h9fT0yI6XnjZ6ZTLyR
         CAcOFgncCypzJw5QSbIP4sjAZk03EO5pZh3HVBJKLzAYfNj33xnipuRDOvnR5A80GQ5c
         L2GLm9+4qxblSHuGoiXsdy9VZUncLfnLNIC32ph+tqBQ7k08oBbMpRpRxfQmR2jHUsxg
         qyMESoG7sHWPICwnBqoZqIaqssR1Ye9EjcP5PTDyvEXQCx9g3BrS4gAkmBH+ElCrNfMG
         Vz6Q==
X-Gm-Message-State: AOJu0YyDj9QqEOVc7KCLGI2gj4l3Y39Vn2pIk0+F5dmhYCLfMzH5kbgd
	2PF9ITSiZ7ZtczZ91mC7XuhMkwho4JrGoVCWDi49InYbSOR1lHJNghHUdIutxQ==
X-Gm-Gg: AR+sD10seI/cKianVx9S7alsiyuH2XIe3V+Gmnq23+5PGIXlp3y/m/jIWmTpjajgtYL
	3ZGFJscQUh4fIPJCofo+kxRDg9nl3pBHHCpyGDpP6TN+4Cr9AQ/P+wi+rqNnVDhkJp5VstUe9qd
	WOGCyv4pIcPS4/wmuVcF6D/29VwGGgY2lkQ4X4A12QU+nKbJcPeoaZztARZ8ol1oU4vPoAIWPwi
	oVuoLBbBG9SGP2GSUMzUkJnbIZSfcbvKsH89Q0fiW7Ju+642pZ8FudCTThS/KD8F6L9e8uwJLpH
	SyuYYH98sJ8dA00M1oyU5bMF5doO5ATg3FT0HuWceAXSZymyku2WdQ+JodJmCsEM4CqIrSmboba
	9qN620wsI9pFdsXmIhl5aYYQM/p3lS4LWn55jGVl0XXptXSAoyWqGIfLC+A5fWltCK1NgXr8Wn0
	B/ridjbOYT0Y3Lcb+rf36qhSVVoHn1q0DU5/90BW1aV5S1LuaL7hDX4K7AMKPI4TQ5fuY6tg==
X-Received: by 2002:a05:600c:c163:b0:499:8174:9f39 with SMTP id 5b1f17b1804b1-499878e02cdmr376009845e9.0.1786904433718;
        Sun, 16 Aug 2026 11:20:33 -0700 (PDT)
Received: from [192.168.1.50] ([79.119.240.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999610ecf4sm58651215e9.7.2026.08.16.11.20.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 11:20:33 -0700 (PDT)
Message-ID: <eb6870f7-79f0-4fa8-9148-5e48366d6672@gmail.com>
Date: Sun, 16 Aug 2026 21:20:31 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next] wifi: rtw89: usb: Avoid crash with dynamically added
 device ID
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Adding a device ID via sysfs causes a crash when the device is plugged
in, because the driver_info pointer is null.

Add a wrapper around rtw89_usb_probe() in each driver to check if
driver_info is null and provide a reasonable default value for it.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
The PCI side has the same problem, but new device IDs are a lot less
likely there.
---
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c | 15 ++++++++++++++-
 drivers/net/wireless/realtek/rtw89/rtw8852au.c | 15 ++++++++++++++-
 drivers/net/wireless/realtek/rtw89/rtw8852bu.c | 15 ++++++++++++++-
 drivers/net/wireless/realtek/rtw89/rtw8852cu.c | 15 ++++++++++++++-
 drivers/net/wireless/realtek/rtw89/rtw8922au.c | 15 ++++++++++++++-
 drivers/net/wireless/realtek/rtw89/usb.c       |  5 +----
 drivers/net/wireless/realtek/rtw89/usb.h       |  2 +-
 7 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
index 1e827205f254..432d216de874 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
@@ -59,10 +59,23 @@ static const struct usb_device_id rtw_8851bu_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8851bu_id_table);
 
+static int rtw8851bu_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	const struct rtw89_driver_info *info;
+
+	if (id->driver_info)
+		info = (const struct rtw89_driver_info *)id->driver_info;
+	else
+		info = &rtw89_8851bu_info;
+
+	return rtw89_usb_probe(intf, info);
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
index 065f4e5b17af..a37b60b584f2 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852au.c
@@ -73,10 +73,23 @@ static const struct usb_device_id rtw_8852au_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8852au_id_table);
 
+static int rtw8852au_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	const struct rtw89_driver_info *info;
+
+	if (id->driver_info)
+		info = (const struct rtw89_driver_info *)id->driver_info;
+	else
+		info = &rtw89_8852au_info;
+
+	return rtw89_usb_probe(intf, info);
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
index de79a19a2824..81b6156a8d27 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
@@ -73,10 +73,23 @@ static const struct usb_device_id rtw_8852bu_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8852bu_id_table);
 
+static int rtw8852bu_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	const struct rtw89_driver_info *info;
+
+	if (id->driver_info)
+		info = (const struct rtw89_driver_info *)id->driver_info;
+	else
+		info = &rtw89_8852bu_info;
+
+	return rtw89_usb_probe(intf, info);
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
index 2dec9b845481..067c6bb007b3 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
@@ -133,10 +133,23 @@ static const struct usb_device_id rtw_8852cu_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8852cu_id_table);
 
+static int rtw8852cu_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	const struct rtw89_driver_info *info;
+
+	if (id->driver_info)
+		info = (const struct rtw89_driver_info *)id->driver_info;
+	else
+		info = &rtw89_8852cu_info;
+
+	return rtw89_usb_probe(intf, info);
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
index 56c79b1ec865..2f60021704e0 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
@@ -74,10 +74,23 @@ static const struct usb_device_id rtw_8922au_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8922au_id_table);
 
+static int rtw8922au_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	const struct rtw89_driver_info *info;
+
+	if (id->driver_info)
+		info = (const struct rtw89_driver_info *)id->driver_info;
+	else
+		info = &rtw89_8922au_info;
+
+	return rtw89_usb_probe(intf, info);
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
index 6f19d0eb3417..1cdf5b812ed4 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.c
+++ b/drivers/net/wireless/realtek/rtw89/usb.c
@@ -1207,15 +1207,12 @@ static const struct attribute_group rtw89_usb_group = {
 __ATTRIBUTE_GROUPS(rtw89_usb);
 
 int rtw89_usb_probe(struct usb_interface *intf,
-		    const struct usb_device_id *id)
+		    const struct rtw89_driver_info *info)
 {
-	const struct rtw89_driver_info *info;
 	struct rtw89_dev *rtwdev;
 	struct rtw89_usb *rtwusb;
 	int ret;
 
-	info = (const struct rtw89_driver_info *)id->driver_info;
-
 	rtwdev = rtw89_alloc_ieee80211_hw(&intf->dev,
 					  sizeof(struct rtw89_usb), info);
 	if (!rtwdev) {
diff --git a/drivers/net/wireless/realtek/rtw89/usb.h b/drivers/net/wireless/realtek/rtw89/usb.h
index bdf312559743..372620d0851e 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.h
+++ b/drivers/net/wireless/realtek/rtw89/usb.h
@@ -95,7 +95,7 @@ static inline struct rtw89_usb *rtw89_usb_priv(struct rtw89_dev *rtwdev)
 }
 
 int rtw89_usb_probe(struct usb_interface *intf,
-		    const struct usb_device_id *id);
+		    const struct rtw89_driver_info *info);
 void rtw89_usb_disconnect(struct usb_interface *intf);
 
 #endif
-- 
2.55.0

