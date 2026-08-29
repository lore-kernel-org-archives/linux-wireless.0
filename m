Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4CC2D592C
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 08:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787991691; cv=none; b=sMqvXc1YXdy35hYaTYBIbPHi2nvrUIAQQM1K8g8ZshNE6N5uHbPCmCnQYx868hOmhawJkdf6lJntXxSm4vDqJ+5bGTI8cHdvJUAxu/Jc3Ln/9KSLxbbODbZ+Ym22ZvKWwRlvQnbXva/BPC0xO4L+Ly9U7AvCCSSaTfOg4eKCrnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787991691; c=relaxed/simple;
	bh=uXY5AlXdrGtSinHKPua4DWeAbCQZr+J4T+ZuZAmAOT8=;
	h=Date:Mime-Version:References:Content-Type:To:From:Subject:
	 Message-Id:In-Reply-To:Cc; b=QOrQ5wEdrqLAzYj1LOgK8+I4noSx2sHFS24aU3KtfPhqBDbkDxufydNfftXLnJYqsu9H4gom12HsBpyfcHSnLeun/QqxG2pUQRpA/PDFBZDz/U/JLL2nYnUXZskNyHqq9OwOpqKN52Fw/kF4uvFpNzBOgvXtmw+nyl5MDOviqv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com; spf=none smtp.mailfrom=bedmex.com; dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b=RB/nU1uF; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bedmex.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b="RB/nU1uF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=bedmex-com.20200927.dkim.feishu.cn; t=1787991680;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=cfBiE4op+yi3OY1OOMMj6Kst8e74AZwvxzgda5Gfo9I=;
 b=RB/nU1uFJTEErHrM0TpK8rZwefoh5OtWP9uRDyBvnWRocoYVayeXEOjFJ15nowol05SX+S
 H1E1jOp9yy5Nc6R1FrJXnnvbVPG7xBFczwuUwHrIKsD7a0BuQBgUwXEb251A2Sv44izRe4
 s1zx+MJvgBUTYZ2ZnB6rbprxeaur0bm3oqeRxGevsAbm7cOC457sb7NtMgpGeSt5ja7g00
 VijCqwE+2uJwaIekoqpURzEZ+scjUKa19YnC4c3N5R5+ZeZzV1TWdbSNUB6OupUOUheis9
 ctOSOHBsnPXFj3fHqrlwsWe1LWuecaGzjdY6Xd3I6TFHSA1HUTNetn6IMpMGtQ==
Date: Sat, 29 Aug 2026 16:21:06 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1787903339.git.yanli.yang@bedmex.com> <cover.1787991457.git.yanli.yang@bedmex.com>
Content-Type: text/plain; charset=UTF-8
To: <linux-wireless@vger.kernel.org>
From: "Yanli Yang" <yanli.yang@bedmex.com>
Subject: [RFC PATCH wireless-next v4 4/4] wifi: aic: integrate AIC8800 driver
Message-Id: <174f59a7d3a8ff4e69117b4947f0ce65c7bb1807.1787991457.git.yanli.yang@bedmex.com>
X-Original-From: Yanli Yang <yanli.yang@bedmex.com>
Content-Transfer-Encoding: 7bit
Received: from bmxpxe-virtual-desktop.. ([36.141.79.164]) by smtp.feishu.cn with ESMTPS; Sat, 29 Aug 2026 16:21:17 +0800
In-Reply-To: <cover.1787991457.git.yanli.yang@bedmex.com>
Cc: "Zhirun Liu" <zhirunliu@aicsemi.com>, 
	"Johannes Berg" <johannes@sipsolutions.net>, 
	"Dijia Xu" <dijiaxu@aicsemi.com>, "Chunqiu Liu" <chunqiuliu@aicsemi.com>, 
	"Liheng Wei" <liheng.wei@bedmex.com>, 
	"Yanli Yang" <yanli.yang@bedmex.com>
X-Mailer: git-send-email 2.34.1
X-Lms-Return-Path: <lba+26a92967e+9511e2+vger.kernel.org+yanli.yang@bedmex.com>

From: Zhirun Liu <zhirunliu@aicsemi.com>

Connect the completed AIC vendor directory to the wireless build and add its
MAINTAINERS entry.  Keeping integration last prevents an earlier partial
source state from being selected by Kconfig.

Signed-off-by: Zhirun Liu <zhirunliu@aicsemi.com>
Signed-off-by: Yanli Yang <yanli.yang@bedmex.com>
---
 MAINTAINERS                   | 10 ++++++++++
 drivers/net/wireless/Kconfig  |  1 +
 drivers/net/wireless/Makefile |  1 +
 3 files changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2d420d40782e3..886a60e7c237e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -736,6 +736,16 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/aic7xxx/
 
+AIC8800 WIRELESS DRIVER
+M:	Zhirun Liu <zhirunliu@aicsemi.com>
+M:	Dijia Xu <dijiaxu@aicsemi.com>
+M:	Chunqiu Liu <chunqiuliu@aicsemi.com>
+M:	Liheng Wei <liheng.wei@bedmex.com>
+M:	Yanli Yang <yanli.yang@bedmex.com>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wireless/aic/
+
 AIMSLAB FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@kernel.org>
 L:	linux-media@vger.kernel.org
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index f4f969fdbc020..964e633898ca8 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -19,6 +19,7 @@ menuconfig WLAN
 if WLAN
 
 source "drivers/net/wireless/admtek/Kconfig"
+source "drivers/net/wireless/aic/Kconfig"
 source "drivers/net/wireless/ath/Kconfig"
 source "drivers/net/wireless/atmel/Kconfig"
 source "drivers/net/wireless/broadcom/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index fa3100ff3bf7b..47b999e8014ca 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -4,6 +4,7 @@
 #
 
 obj-$(CONFIG_WLAN_VENDOR_ADMTEK) += admtek/
+obj-$(CONFIG_WLAN_VENDOR_AIC) += aic/
 obj-$(CONFIG_WLAN_VENDOR_ATH) += ath/
 obj-$(CONFIG_WLAN_VENDOR_ATMEL) += atmel/
 obj-$(CONFIG_WLAN_VENDOR_BROADCOM) += broadcom/
-- 
2.34.1
