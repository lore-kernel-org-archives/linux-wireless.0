Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A5945039
	for <linux-wireless@vger.kernel.org>; Wed, 27 May 2026 04:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779856834; cv=none; b=dmO4YHXPCV0Ey6jVzki1jiYn5I7FZOLqpXpteYK06IzexG6JqhhcXwMimDWR1oEFI8rVZCB70y6SUSoGn0NxSpukQIINiSxt8SHC0l/60JrNbfOVMmWG+aaA0m7QYkN5AoVH4w2TUEEEVhDKe2RKUkMY4LX80obNCfl/GgOK8I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779856834; c=relaxed/simple;
	bh=bZJhT7bKvckU9j9RXL7n5XWQh2J6Vnuiu8O/omsRNZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8k/4sdaUn+69XaPZnwnocglo9diGws2Gi438nJixfeueXgqlwGjITIDQoFSv1pfMIHDycEPanSVq+EE3NESQ64lrBMk1OwmSQOzXWPg/kF4toef1Ru1PxkEZfFa/ss9G7vhYPkCGCNT1Cyx7d0iaQUSo6Au4T790rE0c9YRty8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QMig/92p; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMig/92p"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-838d0b7c950so7987914b3a.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2026 21:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779856832; x=1780461632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=20ceWw6KfOJC0vlDSsZWr19qDj2I//vAqM6HrE79m/U=;
        b=QMig/92pR71fzBZjPIB/ayz+NZXeVbrdEiXlIK2Mo1wizljO1Taj4O705uVuU7vl2I
         EtCvVVpCnHwv8XDiWJaU96dx7q7HMFSN9unI0IF9zerqqxApn57VoPqoJoxBGLgBLhTt
         W0iRz5CVzwfSMll0t/g8h5NH/dXhvRprk49VlCfrBNBJlXbPFVun4iObpTT/yI7hm32M
         DxdeBPB+o1pyz6sKFJ8aFTiDO4Go9p9X75TJpxnh7YGH3Q4P3oh6ZNJknYnJoOcfjNY4
         gmJF94AkDSmatcQaExijhtqsONxNR1VR8t1KPHMmPu+3FY9vEEN5mh5uW+sis/Io3X1o
         Dsww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779856832; x=1780461632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=20ceWw6KfOJC0vlDSsZWr19qDj2I//vAqM6HrE79m/U=;
        b=iht/RjcQGVlAytB75OWf59hm8YE3u90lsUev5VlsMr24/hUF1Joewsd99qu1nJvQnl
         RuxldKK/M68fNaOJBpFo1iSP8OVtup3lt8mp/v/q/GYW1vd0GWT8bpUfVyiauw8K6uxc
         ecZTIWDRvw2l3wC9L5m1z4IHtSgpbaACdYfM1ux4RY+a7JsNc3+yaphvn984AqJ+t3lN
         Z4YVxQ44wjktV4VFuuVFHj2llrQBLSby6tzUmfMVJ8L/3dhdjXfMYQ8yW8ECqsrvsR2K
         368387BkZOKrg1NmA3g4CrqKAdPrcxUEL3AZt7vQ1zNkds3PqFzTXxdDnB5zjQSbdfl/
         dMmw==
X-Gm-Message-State: AOJu0YwEPyI64wfykt3JjMnOobylOSrfHwAbewDUfTIpVlpADwVPoT0T
	BCzG0q0vC5IsHnlNfZ/zD3Ye0Jx5kBp50sF7+fOOiMBQPTFJkF63vk51meGBZggh
X-Gm-Gg: Acq92OHFtz/222MOAOOziIrVy+/R+JzdXUk7hfbT96nEC4qIzN63vE/iTzfBzfQHqBo
	zh0J+MLbHrsIM8qIv+ZjvHtuZKLRcdub1PGWFQcR6FRCuS0ftF3BTw0l2b4g5lMajMFkLkyHkGa
	2f97htLbWSnKOMzazQpF7Qbd3h609dt7rPG+uJVA1+FgI5U9XBH+6MPce/tcRcyxwhH8qk+nXUu
	JxLuupk3JpnUwJpHUb2n3OfZRIXHJo1qrBtscnOTlnlUzHVu2fT2gELIAeO0GKFz8WA+4HBJbJy
	AkHh6vY+lUQz8c2ZXoUpMA5UFJhT3f7BhLLBeVeQdKXIi2MC0ISeRjVhTzINn8iU53IrHeclU9p
	nm2CHcUfSY5cqFMzcUfLu3QMlAUZXRw7znt60S19lmx6n490T+1Xn5c9BhdrhN9sr8ddNUzPT8u
	UeOeUtvFovLkBvIZLlv74WArWGLz+8Kmep5N8a7Sii2qtr67ud0SpDFY4=
X-Received: by 2002:a05:6a00:1944:b0:82c:21a9:872c with SMTP id d2e1a72fcca58-8415f0e85c4mr21526217b3a.7.1779856832355;
        Tue, 26 May 2026 21:40:32 -0700 (PDT)
Received: from BM5220 (123-194-40-181.dynamic.kbronet.com.tw. [123.194.40.181])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-841d6e806c7sm907522b3a.1.2026.05.26.21.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 21:40:31 -0700 (PDT)
From: Zenm Chen <zenmchen@gmail.com>
To: linux-wireless@vger.kernel.org,
	pkshih@realtek.com,
	rtl8821cerfe2@gmail.com
Cc: zenmchen@gmail.com
Subject: [PATCH rtw-next 2/5] wifi: rtw89: 8832au: Support two additional devices
Date: Wed, 27 May 2026 12:40:16 +0800
Message-ID: <20260527044019.9192-2-zenmchen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527044019.9192-1-zenmchen@gmail.com>
References: <20260527044019.9192-1-zenmchen@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add two new ids into the device table to support the following 8832au-based
adapters:
 - Mercusys MA72XH (2c4e:0124)
 - TP-Link Archer TX23U (37ad:0102)

Compile tested only.

Link: https://github.com/morrownr/rtw89/commit/82b789a0f1f41e3148ecf302b4dd8f11d2d68713
Link: https://github.com/morrownr/rtw89/commit/f2e2a70eef253b4d3fc8906c99311dbc4d9f6aab
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8852au.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852au.c b/drivers/net/wireless/realtek/rtw89/rtw8852au.c
index 4cced4619..b3f2690cd 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852au.c
@@ -63,10 +63,14 @@ static const struct usb_device_id rtw_8852au_id_table[] = {
 	  .driver_info = (kernel_ulong_t)&rtw89_8852au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0141, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8852au_info },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2c4e, 0x0124, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8852au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3625, 0x010d, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8852au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3625, 0x010f, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8852au_info },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x37ad, 0x0102, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8852au_info },
 	{},
 };
 MODULE_DEVICE_TABLE(usb, rtw_8852au_id_table);
-- 
2.53.0

