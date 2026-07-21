Received: from va-2-59.ptr.blmpb.com (va-2-59.ptr.blmpb.com [209.127.231.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E724B466B4E
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 10:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784629357; cv=none; b=MIW8jOkMf5CJZPTQw3u0ReiUiemKK1db0i4aqXBf06g+4kziqy7/O3XfNcixAEE1fEcqjSsc2jyOn+vwXWojoNeBwF6nzjqwMRPsYo9JQ5GeJb+MLaIxMPmygT6nGInR1VZ65t3J+Roy9dVRTslwPnf+DCTc7bXlf6kj/NdrdFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784629357; c=relaxed/simple;
	bh=S53CdNyJeUSWfaxMnl0FIOvXs24fC4eDaIPyBrGIBO8=;
	h=Content-Type:Subject:Message-Id:Cc:In-Reply-To:References:From:
	 Mime-Version:To:Date; b=spfKMxmReFY+QSIaIUMDuyMHTECfcryFpP+It/vak/HjPN1tKlDavEUe/9KwGOshAUQqldUEhaMvzbXFC2UCnMuiqnT/wuUjYa2jr3+6R297NMiJXW3mgJFRRIn9U3OUuK1f+TqAJLrZJyDLD8gyHkvISrHXJSso7j1PKhbd/aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com; spf=none smtp.mailfrom=bedmex.com; dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b=OdhFFenh; arc=none smtp.client-ip=209.127.231.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bedmex.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b="OdhFFenh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=bedmex-com.20200927.dkim.feishu.cn; t=1784629345;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=iSWk+9Ofk+K6ldzatxj3a33OhfIqY0j6HGuixEcBXZY=;
 b=OdhFFenhbkJKUeVwZdlFOG1rCk1t+tkU74GsaHKM8OZp3BaGqTsOWNC0rLWARoKJZY/f0a
 Yu7olH6xBWQC4YBaTmx+DPWLMbhoFoimHF1o/CMRUnpRqKIZiq6axbCTb8psdg0p2TuSgG
 QT7Zz5T/m2VolEEK8nNZbECOn2UAiTeCqHBxWp3kHJR52ofaUSo56M0PtWhLEc3Bosrf4/
 XWD0+Dtp0tHfskk6fT3Ipc1pUWMfaUt2z3fahOnlSRXv+FZh/LmXlfUWl5PBeiOxW5r0ez
 s868vEIQo9Sdsmcg8SHxJ5LWregm7zWrG/Ll3tDOydk1WeqelbVzL4H3KrjfJw==
Content-Type: text/plain; charset=UTF-8
Subject: [RFC PATCH wireless-next 4/4] wifi: aic: integrate AIC8800 driver
Message-Id: <5dd82fa4a0e1e23b21995d1a1153d93c7633860e.1784544076.git.yanli.yang@bedmex.com>
Content-Transfer-Encoding: 7bit
Cc: "Johannes Berg" <johannes@sipsolutions.net>, 
	"Zhirun Liu" <zhirunliu@aicsemi.com>, <dijiaxu@aicsemi.com>, 
	<chunqiuliu@aicsemi.com>, <liheng.wei@bedmex.com>
X-Mailer: git-send-email 2.34.1
Received: from bmxpxe-virtual-desktop.. ([36.141.79.164]) by smtp.feishu.cn with ESMTPS; Tue, 21 Jul 2026 18:22:23 +0800
In-Reply-To: <cover.1784544076.git.yanli.yang@bedmex.com>
References: <cover.1784544076.git.yanli.yang@bedmex.com>
From: "Yanli Yang" <yanli.yang@bedmex.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a5f485f+b0c039+vger.kernel.org+yanli.yang@bedmex.com>
To: <linux-wireless@vger.kernel.org>
Date: Tue, 21 Jul 2026 18:21:03 +0800
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
index 52f1a55eca99b..bead7f483fba8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -736,6 +736,16 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/aic7xxx/
 
+AIC8800 WIRELESS DRIVER
+M:	zhirun.liu <zhirunliu@aicsemi.com>
+M:	dijia.xu <dijiaxu@aicsemi.com>
+M:	chunqiu.liu <chunqiuliu@aicsemi.com>
+M:	liheng.wei <liheng.wei@bedmex.com>
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
