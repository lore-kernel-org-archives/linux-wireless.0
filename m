Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AA1372662
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 02:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789697512; cv=none; b=sCj2V13C8knvGoCeYP9vFuqXaRQTiNgFpE/pf+BdN9ZumLkcHlzVmA3ODkGpt0p+BhT1Yorb81MWa4Dvs8o02wTaTkm9LU2AZPSh/odP4UDH0j230/qkfxLD/VzM1KryXt4BybFvNa9xXkkAhmKWN+jZpfl5rVV3mturdrM21zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789697512; c=relaxed/simple;
	bh=cWx33h403Lja87u81+l5+2ACWlytFdyD0wTJsqqSPfc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kHBbP7I5bdN2dgwBwYqD/9BQCSYPO7u9SHCJJxqN5KuqDzdZc6y2NDOVFaaRQ5mkYt2rFmiw//DSY+d8PlN17QFJASk7QGterhcpPfpAbzTF4e/FX5SPDWYJc9vyabrwli9seY7KLpjLkdDIY4WljqCKHpSBVZKYrGLC9Zud7R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=nyar/09o; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="nyar/09o"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68I2BiJyA3822722, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789697505; bh=/0xOY6wZOYaKJbx0xDGiaLlmkg8q3TgxzjGyIXy1Za8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=nyar/09oTNghJudkjnq4dEghUfhYayrvn57Rxg2F8ovcuDd2xz9OrQTPzcM6wmK3M
	 DKAcQVLxGeAfDr3omDZqNPxF1d7XhISc60umrGeNKAwW6X74lF9CGfl2XM+1xxh3Le
	 aiyANJ2Qn/8xZ+X/1I6ZKr5HE8nB4KPHspk83JlzVu6uWpweC1sirST7yaDa4GPTZI
	 qnLcQOVz/VQHbFxiZQeTxfJwpmlfTg4i3C1RlKUHWDBB3BgUBh+m2h1oFBmXATo/8s
	 hDdKHbIkcGJ2Dp1WNqYmSS+gEcga7EIujb08oc4tfM8PX/5ohWoBiINfChjGkHux3h
	 r3E8hjRknnfRA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68I2BiJyA3822722
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 18 Sep 2026 10:11:45 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 18 Sep 2026 10:11:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 18 Sep 2026 10:11:44 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Fri, 18 Sep 2026 10:11:44 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <lkp@intel.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next] wifi: rtw89: correct dependency of the multicolor LED
Date: Fri, 18 Sep 2026 10:11:13 +0800
Message-ID: <20260918021113.25481-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The rtw89 depends on multicolor LED module, but for the case multicolor
LED is module and rtw89 is built-in driver, like

  CONFIG_LEDS_CLASS_MULTICOLOR=m
  CONFIG_RTW89=y
  CONFIG_RTW89_LEDS_MC=y

The linker reports error:

  ld.lld: error: undefined symbol: led_classdev_multicolor_register_ext

Avoid this case, and summerize the supported combination as below

  CONFIG_LEDS_CLASS_MULTICOLOR  y      m    m
  CONFIG_RTW89                  y/m    m    y
  support                       O      O    X

Fixes: 721d90c8509a ("wifi: rtw89: add multicolor LED support for RTL8852CU valve board")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609172315.ZYoKvKBS-lkp@intel.com/
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/Kconfig b/drivers/net/wireless/realtek/rtw89/Kconfig
index 7c678dd1f6b3..9c6c16af7f35 100644
--- a/drivers/net/wireless/realtek/rtw89/Kconfig
+++ b/drivers/net/wireless/realtek/rtw89/Kconfig
@@ -215,7 +215,7 @@ config RTW89_LEDS
 config RTW89_LEDS_MC
 	bool
 	depends on RTW89_LEDS
-	depends on LEDS_CLASS_MULTICOLOR
+	depends on LEDS_CLASS_MULTICOLOR=y || LEDS_CLASS_MULTICOLOR=RTW89_CORE
 	imply LEDS_TRIGGER_TIMER
 	default y
 

base-commit: 73e3b1c94c7d5b4a113e7cbb42665dc2fe3b9d78
-- 
2.25.1

