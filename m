Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1658833C182
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 02:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784772813; cv=none; b=ne3TZzn4BVUA3Gt8CqX0nYh9GUHiWLnUxiHqBOhByjDw/C0XBi6ywoJ+VyQp/EAOCYFkP03tcXtCClMSm2lDjNDZVyEo4snzR9qvwvAAMNHxnhzWep1Zkvo2Xr9/8h0ojkE4iTM80//0oBtoxs+ZvyEN9+mLSjRdGeZUHXuqquE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784772813; c=relaxed/simple;
	bh=Wv3hi7RvX8hyZ/R5ZDobpK3KDI3vNDjeyQBWaxlX4Oc=;
	h=Message-Id:Cc:Subject:From:Date:To:Mime-Version:In-Reply-To:
	 Content-Type:References; b=iv8Fq99UMYbXiQUcwqIkPpVFZZx8pD3gUg1Cg9zKF+Bdt2fCXitSQHRZi5pO1cRsFch+vnc2UvTZHrwpvfQAPO/9WdX0ZWmXb5eum3hpZb3dmx5WkODCTSyF2L3Hr1fEbIEUR8lrkb0yPYbdA0EkTky4faPQs+Lq5uLd0Hk3dTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com; spf=none smtp.mailfrom=bedmex.com; dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b=vubSrS4S; arc=none smtp.client-ip=209.127.231.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bedmex.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b="vubSrS4S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=bedmex-com.20200927.dkim.feishu.cn; t=1784772807;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=YoKuTJMb7kYuknJ7K1V5DzHWfWrsiEKRFgGtEE8S1F4=;
 b=vubSrS4SVfqc6QqgGHjOzs3z6u3mev3QaTXnX6fDKt8IgLipCSMKMZr2tgWGIofoaG+1QW
 Dh2Xh6Mps9NRjLN8ApSjqk3iW+jCHhlME2FHPbkbAwZqQGwdDUzY/FaGPLp3eeFqE/e9n8
 VjQtjI7GCsMIwlYBVfCi6l0x9AKJ8KeCU0K9QlYVPEfpr8jzEX8TrsNnSlseW6Y1AumxA1
 oWd6fpsG7TffVTv3i2IPZaIJ3sNGl3W+j5WLtG7HqWt2wr8cVpxjo6+ddytJFnnIVmWtS7
 ssMUx39oP/7ijWbYJGiCi8gnIRkAWkK50RjMpfU628ysyDIvWNvWK3e49AUxWA==
Message-Id: <81d6b6d4e36c35a61913ca30234fd7ec587f5fd1.1784724170.git.yanli.yang@bedmex.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>, 
	"Zhirun Liu" <zhirunliu@aicsemi.com>, "Dijia Xu" <dijiaxu@aicsemi.com>, 
	"Chunqiu Liu" <chunqiuliu@aicsemi.com>, 
	"Liheng Wei" <liheng.wei@bedmex.com>
Subject: [RFC PATCH wireless-next v2 4/4] wifi: aic: integrate AIC8800 driver
X-Lms-Return-Path: <lba+26a6178c5+f69ed3+vger.kernel.org+yanli.yang@bedmex.com>
From: "Yanli Yang" <yanli.yang@bedmex.com>
Date: Thu, 23 Jul 2026 10:13:12 +0800
Received: from bmxpxe-virtual-desktop.. ([36.141.79.164]) by smtp.feishu.cn with ESMTPS; Thu, 23 Jul 2026 10:13:25 +0800
To: <linux-wireless@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <cover.1784724170.git.yanli.yang@bedmex.com>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
References: <cover.1784724170.git.yanli.yang@bedmex.com>
X-Original-From: Yanli Yang <yanli.yang@bedmex.com>

From: Zhirun Liu <zhirunliu@aicsemi.com>

Connect the completed AIC vendor directory to the wireless build
and add its MAINTAINERS entry. Keeping integration last prevents an earlier
partial source state from being selected by Kconfig.

Signed-off-by: Zhirun Liu <zhirunliu@aicsemi.com>
Signed-off-by: Yanli Yang <yanli.yang@bedmex.com>
---
 MAINTAINERS                   | 10 ++++++++++
 drivers/net/wireless/Kconfig  |  1 +
 drivers/net/wireless/Makefile |  1 +
 3 files changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 52f1a55eca99b..a64bd3b8e0aa1 100644
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
index c6599594dc995..65ab62d073693 100644
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
index e1c4141c60044..bb0c29cb3e82f 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -4,6 +4,7 @@
 #
 
 obj-$(CONFIG_WLAN_VENDOR_ADMTEK) += admtek/
+obj-$(CONFIG_WLAN_VENDOR_AIC) += aic/
 obj-$(CONFIG_WLAN_VENDOR_ATH) += ath/
 obj-$(CONFIG_WLAN_VENDOR_ATMEL) += atmel/
 obj-$(CONFIG_WLAN_VENDOR_BROADCOM) += broadcom/
