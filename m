Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1682327C18
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391385; cv=none; b=I4Ej8ALpK2nc70LiX4iZuM9AOcnmyFRFR89C6ureIN7wNfJov4hcaHx//Z1oQy6Ln1uWob07G3UFwbaQA9xqsi87ivyuYsblJbpocUFdtbMqzrn5bH8pAL1u9vBuQDNobLZryznQelo2PXEk92tN0JENGUrQImUiFvb+zAGHhO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391385; c=relaxed/simple;
	bh=xUov0nakl/JEw1ntlgLHRYlSE2KYDnusCKJxdovti/o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EaUnSfmWK0P2lHxRW6YCjc3izJXtBDm5KRq5PGEgK8TBsGJt6mpXEUsOkpSqmBbhC9Rw1EAbemWdyo3bZSCgPUcpLa8g8GAhKssDGHMhBxEOiglZambKcNtZmispfFcDa2oOPLXozu5F427Ey9u9RW0RADLTAlVBz20hkCLdTkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=qKg48rK/; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="qKg48rK/"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U630srC985965, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785391380; bh=bB1uqIOmJHotSTBW3LYHf+1pnGUJj+HGOsYQ0JG6+zQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=qKg48rK/lKU8OXRctiPGk53TtZkQ10UP3LXPPAsG8BTEo5N+mLsYU7I3iDaiMjD79
	 j3eAJpSlYFZdyJpnSiU7ijL7DRLElgeXCuQgY1U482iLOHZYXTCgaqvk4cZ9j3UcT1
	 utx8WB6QBqZhdcMHa4CPKU+WcFC9+JLcj/qsp28Tgh2i0XogmHDrCkbFVCAyo6IYwR
	 m6/xZAn9TaAhQFAmdaNVBKpiEdqQGBllr/GsZ8XT104Z1CSG8BDrMQjmob81CNYqVp
	 0oK5QZxTxTY7wxyAX0Rki5IpTDIqwG1pCc1+yll7fxp6+Qs74fWkqxPoNFMql4fqy+
	 wwPcSacJijrSQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U630srC985965
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:03:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:03:01 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:03:00 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Jul 2026 14:03:00 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 7/7] wifi: rtw89: 8922d: enable Makefile and Kconfig for RTL8922DE
Date: Thu, 30 Jul 2026 14:02:20 +0800
Message-ID: <20260730060220.55844-8-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730060220.55844-1-pkshih@realtek.com>
References: <20260730060220.55844-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

RTL8922DE is a WiFi 7 chipset, supporting 2x2 2GHz/5GHz/6GHz 4096/1024-QAM
160MHz channels. As STA, AP and P2P modes work well, enable this chipset.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/Kconfig  | 15 +++++++++++++++
 drivers/net/wireless/realtek/rtw89/Makefile |  7 +++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/Kconfig b/drivers/net/wireless/realtek/rtw89/Kconfig
index 7200a944260f..7c678dd1f6b3 100644
--- a/drivers/net/wireless/realtek/rtw89/Kconfig
+++ b/drivers/net/wireless/realtek/rtw89/Kconfig
@@ -41,6 +41,9 @@ config RTW89_8852C
 config RTW89_8922A
 	tristate
 
+config RTW89_8922D
+	tristate
+
 config RTW89_8851BE
 	tristate "Realtek 8851BE PCI wireless network (Wi-Fi 6) adapter"
 	depends on PCI
@@ -169,6 +172,18 @@ config RTW89_8922AU
 	  802.11be USB wireless network (Wi-Fi 7) adapter
 	  supporting 2x2 2GHz/5GHz/6GHz 4096-QAM 160MHz channels.
 
+config RTW89_8922DE
+	tristate "Realtek 8922DE/8922DE-VS PCI wireless network (Wi-Fi 7) adapter"
+	depends on PCI
+	select RTW89_CORE
+	select RTW89_PCI
+	select RTW89_8922D
+	help
+	  Select this option will enable support for 8922DE/8922DE-VS chipset
+
+	  802.11be PCIe wireless network (Wi-Fi 7) adapter
+	  supporting 2x2 2GHz/5GHz/6GHz 4096/1024-QAM 160MHz channels.
+
 config RTW89_DEBUG
 	bool
 
diff --git a/drivers/net/wireless/realtek/rtw89/Makefile b/drivers/net/wireless/realtek/rtw89/Makefile
index 5536714e0268..a85b7785330c 100644
--- a/drivers/net/wireless/realtek/rtw89/Makefile
+++ b/drivers/net/wireless/realtek/rtw89/Makefile
@@ -91,6 +91,13 @@ rtw89_8922ae-objs := rtw8922ae.o
 obj-$(CONFIG_RTW89_8922AU) += rtw89_8922au.o
 rtw89_8922au-objs := rtw8922au.o
 
+obj-$(CONFIG_RTW89_8922D) += rtw89_8922d.o
+rtw89_8922d-objs := rtw8922d.o \
+		    rtw8922d_rfk.o
+
+obj-$(CONFIG_RTW89_8922DE) += rtw89_8922de.o
+rtw89_8922de-objs := rtw8922de.o
+
 rtw89_core-$(CONFIG_RTW89_DEBUG) += debug.o
 rtw89_core-$(CONFIG_RTW89_LEDS) += led.o
 rtw89_core-$(CONFIG_RTW89_LEDS_MC) += led_mc.o
-- 
2.25.1

