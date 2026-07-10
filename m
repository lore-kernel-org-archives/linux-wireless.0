Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9609D2D0C82
	for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2026 03:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783652465; cv=none; b=TIqlxNptQbSMfupS05ZZUoKmAkO4Fv50LjE7vrZ6swemSiDF0/GHQ8WySX7yu4duySmg1/jkfxDV160DI599FWRUFMsbwhmRiSBi28Z3JD2/5es2bSw/JTJi5ksrI9jnsP8AV0yrEs9UW7yhh8x7sDSCB1NJTtqRTuwNdnWjXbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783652465; c=relaxed/simple;
	bh=IvEjO9IZ/O0QfpZNF/4OZTFURIEb1x24OGcZo/YMsOQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZdzRpcBemKNCknoijFfQepIDbAj2Gq1EyrsYf/Md6s5oAjHN6c2OkRRtvZyiVloYZMwLNHCJVfKGZUlZVYD7n9pUQmirQ4k0wSoRjQVqTn0FzzSdWksXTipnIw7shlDtCiC1ZdmObDKdRHbXVfv+dUeJ1BenBsP8B62jO5SsO28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GihWpVV/; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GihWpVV/"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cc73e322dbso4253695ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2026 20:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783652464; x=1784257264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zv8omYlCd9ZTYlAI4MA9XWHTxkn1QtHYjYUUSoZMuN4=;
        b=GihWpVV/vQ56GZVzw2bMt5aa5VTJzJhuNmGyr3HTfdPZrregb2WGli0SSuUfg25feg
         PEpS119hUBvs7MrZpolo1/H8xuiTmmCnPA6qDSQ7NT4zlx3qY26PtRn0uWFKo7QmDbR7
         yV+vE+IIyKWvZE0/+LC0XMS1yrqsi4Z/z4X8BD3Sp6af2RE8bOhibA+RGTfKQmh7oc3h
         AHywKC3JMG2Zgip1bFD7pCBEhp1cmGM5QLAe0OU7GieoHR+rFwdfdYa6lvjyUyyCDor4
         FNG884Ce64Q+fqb7WfjE7oCd2llLiWcu8z9BngBzCnHTTbjY0HLCciFhOyHFTUoAiSNC
         sA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783652464; x=1784257264;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zv8omYlCd9ZTYlAI4MA9XWHTxkn1QtHYjYUUSoZMuN4=;
        b=I9LWicGH1+q5PjcTQkocDaROPJXkkyAfmqK02UcgheswTNypqDUQOHQxWROJZdrIj7
         LYjaFL60wIl1yQs2WnsQZpFZoFWhiNOMw+ycsopVUs0lfsyEf+u7rYLFHVMg4o/4Ifqp
         NVdUQlfCGzzWkWPxMr71suxlp+B/NeOSTvr28jCfYibkpN8uSQAIgQ753ZxHgOUVYue6
         TbSlHex71w6IMZuICsAeGA+D1VTUYzruYn1ta2DQFde1FyMOETr6NTYDTTS0yb459SMP
         yQlzgchpKfH7F1HejmlZI14brOT9MU1ZW1/7cqiCU52BSadHsaS2b4oyaVpP5TDWSU8j
         H/Pg==
X-Gm-Message-State: AOJu0YxLRzTc19hKC9GY3oIlq/u6Kj0+oxeZA1uHz8tXH3ePpQeqbJ3R
	rTBvZffqR+35ObWkoyWHwLq5D+/pMMv98RGYkzRKkgeZyFi2MvYKk3v3
X-Gm-Gg: AfdE7cnLY5RQeViNtDulZOgDypzJYy/7PSbnMg3klUyKEbH1GmbIncUzvBEPftZ55zR
	WWY14WFgGBMROKBy0HQ8uAKNbsG7Y+fCXlBouArWkHYaZXWwY2AkUhbzTBUteh6nJkswMhrHCDC
	2qclGLPiGudDWf1G7AebCthZd/gDGJksBQEtq7+FL1PRFAzQ3lSTK5XW3BOcRcLEZ15/RaNVF/B
	F389uv4oa90d4iTxZ68PYIdHUPOlQ7frwLS71NTO47AphvYkI+ROlQR/QDJUKw3phyYaFsWxCpR
	/ahxlpleY24uZFY3MUhZSlKboA8NtO/Uo3fsiXtrHrG5G0EvPVwEDZDjCup65X4t+FOtlD7gkMA
	Vt2dRKuNRon90QahylMCn3FvLH9IN0vB5aWqBJ1Liz08M1KgPD4SZfmkgvEuXA4ShdPIVcT9wq5
	XiUTaDP8kI4wpeE6V+7w==
X-Received: by 2002:a05:6a21:697:b0:3c0:9c19:659c with SMTP id adf61e73a8af0-3c0bd206a8fmr12006046637.68.1783652463800;
        Thu, 09 Jul 2026 20:01:03 -0700 (PDT)
Received: from embed-PC.. ([2406:b400:d4:326:ab07:2512:2621:e916])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm33641616eec.18.2026.07.09.20.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 20:01:02 -0700 (PDT)
From: Abhishek Tamboli <abhishektamboli9@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: rtw89: 8852au: Add support for Mercusys MA72XH
Date: Fri, 10 Jul 2026 08:30:55 +0530
Message-Id: <20260710030055.57438-1-abhishektamboli9@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the ID 2c4e:0124 to the rtw_8852au_id_table to
support the Mercusys MA72XH usb adapter.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221738

Signed-off-by: Abhishek Tamboli <abhishektamboli9@gmail.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8852au.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852au.c b/drivers/net/wireless/realtek/rtw89/rtw8852au.c
index 29b7f7769370..1f93b3c89039 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852au.c
@@ -64,6 +64,8 @@ static const struct usb_device_id rtw_8852au_id_table[] = {
 	  .driver_info = (kernel_ulong_t)&rtw89_8852au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0141, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8852au_info },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2c4e, 0x0124, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8852au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3625, 0x010d, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8852au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3625, 0x010f, 0xff, 0xff, 0xff),
--
2.34.1

