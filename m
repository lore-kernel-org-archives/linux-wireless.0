Received: from va-2-59.ptr.blmpb.com (va-2-59.ptr.blmpb.com [209.127.231.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A15F44A411
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 12:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787919126; cv=none; b=BvVJBwn21A5Bk30ne7Nzka1Kp4XBbkSCb5JeqymPtcOaTku2MaafIkvxvWbfi20yz6Cug7cSN+5nt7xlhIY7vrUVdvRd9W3ByIvH1tmXtkLhgPeZYGSVlTvoLLEp9/vJv/KRTF/jBFLIK10IWT5aIKCKxYfPlRc8mYHi8sIm4Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787919126; c=relaxed/simple;
	bh=1VN9V41leQEJl/bwey0wXsOE4R7ss5cMqqzPxcqgtj8=;
	h=Mime-Version:In-Reply-To:To:Subject:From:Message-Id:References:
	 Content-Type:Cc:Date; b=KvCBwciGnbnbXyw+TpZTCnw8t46h/zcxqklnV2puJSe367pzimhLxQbfdN5Gvwivb4B0Gi1U/em5X/nG7Fje34vCd3Cw4iu1SnuoJZMTeQnFvr/kiNIiduDN9CoWeIOHP3ztlhd3I6rraRvUFsvbJa8Xj6zXgx3B+r5C/ucLmi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com; spf=none smtp.mailfrom=bedmex.com; dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b=DjubJOCq; arc=none smtp.client-ip=209.127.231.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bedmex.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b="DjubJOCq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=bedmex-com.20200927.dkim.feishu.cn; t=1787919108;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Hh5IzrOpEXJobqiS7UxmjF8SSzgX8QzBYIKjEElofk4=;
 b=DjubJOCqk1SLqJVpbjO+jyMQU+mHWm2rPoVmhBCqgnF+7HNcciwdJTULQ8fQukCtkU+mKh
 mhsNvNyHisaIUjwlTj7zGILsJlh4YkmCncDqgu1MauMnwQlMhf3r7JWsbESqBIrzzy8MNx
 QrP8Rybw0ptTnnKdI9CqeQs+fEtgNPSfGhxxcuxaALjNmxakyMX+1kJUtmUi9GqLnSReS/
 7l4HHcWvnHn05g1TcdtvNwyyo5iIhPuUWh/2zC8c+5W/v2Fgx3lGAg1BgExNbtYmQMNwEq
 7A5NdiMDMB/jE1TMiCq/bxo9J5mXZ3tB7lZxqIAUKtEaFbB7MscI1fnSCusQyg==
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1787903339.git.yanli.yang@bedmex.com>
Content-Transfer-Encoding: 7bit
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: [RFC PATCH wireless-next v3 4/4] wifi: aic: integrate AIC8800 driver
Received: from bmxpxe-virtual-desktop.. ([36.141.79.164]) by smtp.feishu.cn with ESMTPS; Fri, 28 Aug 2026 20:11:45 +0800
From: "Yanli Yang" <yanli.yang@bedmex.com>
Message-Id: <65cb9fcad939f5874c8172c1ed4b91001bd8f144.1787903339.git.yanli.yang@bedmex.com>
References: <cover.1784724170.git.yanli.yang@bedmex.com> <ef855527f564086a498e95d31a35935762fa60e1.camel@sipsolutions.net> <007a0362a36d2318ea7a50c6feb8ad2ce1361c0d.camel@sipsolutions.net> <cover.1787903339.git.yanli.yang@bedmex.com>
X-Original-From: Yanli Yang <yanli.yang@bedmex.com>
X-Lms-Return-Path: <lba+26a917b02+084bf9+vger.kernel.org+yanli.yang@bedmex.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-wireless@vger.kernel.org>, "Zhirun Liu" <zhirunliu@aicsemi.com>, 
	"Dijia Xu" <dijiaxu@aicsemi.com>, "Chunqiu Liu" <chunqiuliu@aicsemi.com>, 
	"Liheng Wei" <liheng.wei@bedmex.com>
Date: Fri, 28 Aug 2026 20:11:33 +0800

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
-- 
2.34.1
