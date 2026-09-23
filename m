Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14940476041
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 21:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790199375; cv=none; b=Txx1l/cZI+F/If7Kl5nl+h9WRuX9ti27D2s9pSQQAmazsusC4LIQwAgmoJ+Qjzlr8LaLcNXiZpEkg4cnAg+C+HvFyRZX/WYh5fGnxmEYVGNVaEBPK5QBz5l/QwmeIqoaYbH74z7CGWhcR5krf1i//h9SYLzesmXUnGL3mhOOLSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790199375; c=relaxed/simple;
	bh=Ca5BbrAJIBa3O09AXU0PUuW4/9AxSHHQmz5hoAQr6OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/STah9EHFNL02oU8GfqEUezpqFczRRUW8SNPPG5ZgVeoZQ6GgwrrjUj+e/wz017Dn41Tco8bis5VQo6jEFrVe8t5tfkrk1XHhDZqWKdR9f+1yuxawsCzQo14gUf2te660pvtvV1M9uz1EADZ1iG1VEXYfS+Uus2bfmzR4LYWN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fAktFKbn; arc=none smtp.client-ip=91.218.175.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fAktFKbn"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ca5BbrAJIBa3O09AXU0PUuW4/9AxSHHQmz5hoAQr6OY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790199371; v=1; x=1790804171;
 b=fAktFKbnQX44oBbXq/AiOR2P9auuTjZBUWLiZk24IUD+yRmDKgZwcGC2VazBZQwEe4Eiq587
 El0qq+pmNtmaBQlZVK0NWu0BY8fmJuOhKRxdNaHKQJbHk34DGa/wE6ssy35CWg1qyYYXFJpbRno
 RoOKtVIaJO2ZeR1fJks9Hth8=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a4c98a9833c222a9;
	Wed, 23 Sep 2026 21:36:11 +0000
X-Mizu-Trace-ID: a4c98a9833c222a9
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v4 5/6] wifi: rtw88: 8723bs: enable building the RTL8723BS driver
Date: Wed, 23 Sep 2026 23:35:56 +0200
Message-ID: <20260923213557.186205-6-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923213557.186205-1-luka.gejak@linux.dev>
References: <20260923213557.186205-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the chip support, firmware interface, coexistence, power
management and the SDIO transfer and association paths are all in place,
add the Kconfig symbols and Makefile rules that build the RTL8723B chip
module and the RTL8723BS SDIO front end.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/Kconfig  | 18 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/Makefile |  6 ++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
index 3736f290bd42..e1f40d6785e6 100644
--- a/drivers/net/wireless/realtek/rtw88/Kconfig
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -36,6 +36,10 @@ config RTW88_8703B
 	tristate
 	select RTW88_8723X
 
+config RTW88_8723B
+	tristate
+	select RTW88_8723X
+
 config RTW88_8723D
 	tristate
 	select RTW88_8723X
@@ -159,6 +163,20 @@ config RTW88_8723CS
 
 	  If you choose to build a module, it'll be called rtw88_8723cs.
 
+config RTW88_8723BS
+	tristate "Realtek 8723BS SDIO wireless network adapter"
+	depends on MMC
+	select RTW88_CORE
+	select RTW88_SDIO
+	select RTW88_8723B
+	help
+	  Select this option to enable support for 8723BS chipset
+
+	  This module adds support for the 8723BS 802.11n SDIO
+	  wireless network adapter.
+
+	  If you choose to build a module, it'll be called rtw88_8723bs.
+
 config RTW88_8723DU
 	tristate "Realtek 8723DU USB wireless network adapter"
 	depends on USB
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index 0b3da05a2938..6889b3796449 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -55,6 +55,12 @@ rtw88_8703b-objs		:= rtw8703b.o rtw8703b_tables.o
 obj-$(CONFIG_RTW88_8723CS)	+= rtw88_8723cs.o
 rtw88_8723cs-objs		:= rtw8723cs.o
 
+obj-$(CONFIG_RTW88_8723B)	+= rtw88_8723b.o
+rtw88_8723b-objs		:= rtw8723b.o rtw8723b_table.o
+
+obj-$(CONFIG_RTW88_8723BS)	+= rtw88_8723bs.o
+rtw88_8723bs-objs		:= rtw8723bs.o
+
 obj-$(CONFIG_RTW88_8723D)	+= rtw88_8723d.o
 rtw88_8723d-objs		:= rtw8723d.o rtw8723d_table.o
 
-- 
2.55.0

