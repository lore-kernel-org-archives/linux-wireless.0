Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A8E3E1D07
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 06:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790923912; cv=none; b=kVdhHM6PI0t82+p19twFNR6H3YjcVitNrnuSs9mAFDsxW/4fmx4fx60He/F1loS6EN7skHFHIGV8pkBzfic0sIA8WUvXPZAZIvI0/V4jKUek2g4EHWDCSZB9soOfXRr4GB2vg/AuthneeJv8de0AqSeAFGVtSvc3aeaiSICtwSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790923912; c=relaxed/simple;
	bh=ttz08Elmk9xgs4+PFWDRTyIHbJmNDb27Cin+3zfXb7E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DRn3twZioY868hQqYc0AAN67DcO/72//zhjmEC4GnlafOUCa0KEz44AIClmHSgJLfdt1/bqoFuxyBzw8vZDfj/VbBrhjcKAmI9iYOcZYxn4RGNHJUyLBmJtah9CQvCzqs+QWX5ALIBfejjXdMggsRZPN7Mr+QKcK3XCQ5xvcMOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=AbCoDged; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="AbCoDged"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6926pfliF3629355, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790923901; bh=WBRXK/JKuhohrUoDSoKuafVaSIoNSi+tl5XIKCysS7w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=AbCoDgedYLYkW+dkfkp/e0uZmt7/DYYR4mWi1vnGbCAqzNvg84Ut1J9Mw4nWcFvU3
	 Vn8bGQ1Y2xRrOgmFfIUT6cWZB5pu/bjMwWrMzIoOvNDz9R1mHVKxyCVXPYoJnxRmIb
	 QQ3tqraeWyDuwND2ZF1XxqSWJI4ulgFsjNmfvZZTJ6Ghqcy3TbqzW1UHCGxa9tDmN6
	 YaSXBzElMxOdcuJf7pdfWgw+i/sVFdijWixmg2mw4Wt4ProYg9kr6m859BEnxMTkXs
	 am6may4hRlCaX2s4cGIkQvo1lvNdSvVsTwSIS63AD2Si+gpdCM3yvhvz39jkY9RrHA
	 h01a+09wcvZEQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6926pfliF3629355
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 2 Oct 2026 14:51:41 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 2 Oct 2026 14:51:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 2 Oct 2026 14:51:41 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Fri, 2 Oct 2026 14:51:41 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <arnd@arndb.de>
Subject: [PATCH rtw-next] wifi: rtw89: remove discouraged imply from Kconfig LED
Date: Fri, 2 Oct 2026 14:50:58 +0800
Message-ID: <20261002065058.13535-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The 'imply' in Kconfig to weakly and implicitly select dependencies is
discouraged. Remove them to simply logic.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Closes: https://lore.kernel.org/linux-wireless/7cdc36a9-aadd-4636-8a29-847d89638c8d@app.fastmail.com/T/#t
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/Kconfig b/drivers/net/wireless/realtek/rtw89/Kconfig
index 9c6c16af7f35..0899f0c25612 100644
--- a/drivers/net/wireless/realtek/rtw89/Kconfig
+++ b/drivers/net/wireless/realtek/rtw89/Kconfig
@@ -209,14 +209,12 @@ config RTW89_LEDS
 	bool
 	depends on RTW89_CORE
 	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
-	imply MAC80211_LEDS
 	default y
 
 config RTW89_LEDS_MC
 	bool
 	depends on RTW89_LEDS
 	depends on LEDS_CLASS_MULTICOLOR=y || LEDS_CLASS_MULTICOLOR=RTW89_CORE
-	imply LEDS_TRIGGER_TIMER
 	default y
 
 endif

base-commit: 7cde94dab0e74434ccc0a387d7ad373fb3becda0
-- 
2.25.1

