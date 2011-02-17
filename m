Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:26797 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab1BQWXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:23:04 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022249.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:22:26 +0200
Subject: Re: [RFC] AI support (5/14 ssb core control and state helpers)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980093.13554.5.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 00:14:35 +0200
Message-Id: <1297980875.23381.13.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Introduce helpers for SB core control and state flags' management. SB-style
buses provide access to these flags at two high octets of TMSLOW and TMSHIGH
registers whereas AI-ones implement these flags in two low octets of IOCTRL
and IOSTAT registers.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/main.c      |   17 +++++++++++++++++
 include/linux/ssb/ssb.h |   10 ++++++++++
 2 files changed, 27 insertions(+)
--- linux-wireless-testing.orig/drivers/ssb/main.c	2011-02-17 14:05:12.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/main.c	2011-02-17 14:15:25.000000000 +0200
@@ -1360,12 +1360,29 @@ static u32 ssb_admatch_size_sb(struct ss
 	return size;
 }
 
+static u32 ssb_core_ctl_flags_sb(struct ssb_device *dev, u32 mask, u32 val)
+{
+	if (~mask || val) {
+		u32 tmp = (ssb_read32(dev, SSB_TMSLOW) & mask) | val;
+		ssb_write32(dev, SSB_TMSLOW, tmp);
+	}
+
+	return ssb_read32(dev, SSB_TMSLOW);
+}
+
+static u32 ssb_core_state_flags_sb(struct ssb_device *dev)
+{
+	return ssb_read32(dev, SSB_TMSHIGH);
+}
+
 const struct ssb_bus_helpers ssb_helpers_sb = {
 	.device_is_enabled	= ssb_device_is_enabled_sb,
 	.device_enable		= ssb_device_enable_sb,
 	.device_disable		= ssb_device_disable_sb,
 	.admatch_base		= ssb_admatch_base_sb,
 	.admatch_size		= ssb_admatch_size_sb,
+	.core_ctl_flags		= ssb_core_ctl_flags_sb,
+	.core_state_flags	= ssb_core_state_flags_sb,
 };
 
 static int __init ssb_modinit(void)
--- linux-wireless-testing.orig/include/linux/ssb/ssb.h	2011-02-17 14:05:12.000000000 +0200
+++ linux-wireless-testing/include/linux/ssb/ssb.h	2011-02-17 14:15:25.000000000 +0200
@@ -128,6 +128,8 @@ struct ssb_bus_helpers {
 	void (*device_disable)(struct ssb_device *dev, u32 core_specific_flags);
 	u32 (*admatch_base)(struct ssb_device *dev, u32 adm);
 	u32 (*admatch_size)(struct ssb_device *dev, u32 adm);
+	u32 (*core_ctl_flags)(struct ssb_device *dev, u32 mask, u32 val);
+	u32 (*core_state_flags)(struct ssb_device *dev);
 };
 
 
@@ -451,6 +453,14 @@ static inline u32 ssb_admatch_size(struc
 {
 	return dev->helpers->admatch_size(dev, adm);
 }
+static inline u32 ssb_core_ctl_flags(struct ssb_device *dev, u32 mask, u32 val)
+{
+	return dev->helpers->core_ctl_flags(dev, mask, val);
+}
+static inline u32 ssb_core_state_flags(struct ssb_device *dev)
+{
+	return dev->helpers->core_state_flags(dev);
+}
 
 
 /* Device MMIO register read/write functions. */



