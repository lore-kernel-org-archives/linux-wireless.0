Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868EB4F68D4
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 09:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846335; cv=none; b=lb38rHVw30MeVmMm05VMl5YX29yL+CAhtkgnWK3LJa+XP+tEErk3Pl5stD8RxLDAH48KIJnspqaGik5+tcJrhmMAV0u1S8cF9iyakYP9FSTNXqP7RFRpIXdp7rfFuxCuqFunSEswqJj5JNm6RYtDMLHiv5jpUnE0UpXQ/yIaoGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846335; c=relaxed/simple;
	bh=Ca5BbrAJIBa3O09AXU0PUuW4/9AxSHHQmz5hoAQr6OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ov0MUeH4LkPtK5u2bu3ukx9Z7fOzg21DgJdyB+8iZ0A6e3zWCd3SKQW4Mmr4LNUTNnOMHicta1LL0UL+FjS6G4mcAhC1erKWYVn50gkzzX3oJ8TpVfli7EKCP+YTYI42TsA4I6iAfluZ1+eq5weIF0x6ln2fkXlH623XQgoSeOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pD3toJyc; arc=none smtp.client-ip=91.218.175.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pD3toJyc"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ca5BbrAJIBa3O09AXU0PUuW4/9AxSHHQmz5hoAQr6OY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790846331; v=1; x=1791451131;
 b=pD3toJycrwQLneIoumQnNNrFdrOzJkOFwT5HPaaTa82Qya5RyZd3xD12EjD8tmj3ZGjsqwgR
 4JcrUBlcdZ7i77mOgVWbKM/j3i/stx8JuwOyKb5M6yd5wEqcIo8N6Wzk/xffkZrbGakeTrhPDoy
 KEZ6JOBp3Bx3m13jpYhwaHRU=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4d85ab758835504e;
	Thu, 01 Oct 2026 09:18:51 +0000
X-Mizu-Trace-ID: 4d85ab758835504e
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v6 6/6] wifi: rtw88: 8723bs: enable building the RTL8723BS driver
Date: Thu,  1 Oct 2026 11:18:35 +0200
Message-ID: <20261001091835.67909-7-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001091835.67909-1-luka.gejak@linux.dev>
References: <20261001091835.67909-1-luka.gejak@linux.dev>
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

