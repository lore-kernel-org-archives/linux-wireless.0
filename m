Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:21441 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab1BIOmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:42:14 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000019980.msg
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 16:41:38 +0200
Subject: Re: SSB AI support code ([RFC4/11] SSB core control and state
	device ops)
From: George Kashperko <george@znau.edu.ua>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297258590.17400.37.camel@dev.znau.edu.ua>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
Content-Type: text/plain
Date: Wed, 09 Feb 2011 16:34:49 +0200
Message-Id: <1297262089.18053.24.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Introduce handlers for SB core control and state flags' management. SB-style
buses provide access to these flags at two high octets of TMSLOW and TMSHIGH
registers whereas AI-ones implement these flags in two low octets of IOCTRL
and IOSTAT registers.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/main.c      |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/ssb/ssb.h |   14 +++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)
--- linux-next-20110203.orig/drivers/ssb/main.c	2011-02-07 16:58:50.000000000 +0200
+++ linux-next-20110203/drivers/ssb/main.c	2011-02-07 17:07:11.000000000 +0200
@@ -1350,6 +1350,40 @@ static u32 ssb_admatch_size_sb(struct ss
 	return size;
 }
 
+static void ssb_core_ctl_flags_sb(struct ssb_device *dev, u32 mask,
+				  u32 val, u32 *res)
+{
+	u32 tmp;
+
+	if (mask || val) {
+		tmp = (ssb_read32(dev, SSB_TMSLOW) & ~mask) | val;
+		ssb_write32(dev, SSB_TMSLOW, tmp);
+	}
+
+	/* readback */
+	tmp = ssb_read32(dev, SSB_TMSLOW);
+	udelay(1);
+
+	if (res)
+		*res = tmp;
+}
+
+static u32 ssb_core_state_flags_sb(struct ssb_device *dev, u32 mask, u32 val)
+{
+	u32 tmp;
+
+	if (mask || val) {
+		tmp = (ssb_read32(dev, SSB_TMSHIGH) & ~mask) | val;
+		ssb_write32(dev, SSB_TMSHIGH, tmp);
+	}
+
+	/* readback */
+	tmp = ssb_read32(dev, SSB_TMSHIGH);
+	udelay(1);
+
+	return tmp;
+}
+
 /* Ops for the plain SSB bus without a host-device (no PCI or PCMCIA). */
 static const struct ssb_bus_ops ssb_ssb_ops = {
 	.read8			= ssb_ssb_read8,
@@ -1368,6 +1402,8 @@ static const struct ssb_bus_ops ssb_ssb_
 	.admatch_base		= ssb_admatch_base_sb,
 	.admatch_size		= ssb_admatch_size_sb,
 	.irqflag		= ssb_irqflag_sb,
+	.core_ctl_flags		= ssb_core_ctl_flags_sb,
+	.core_state_flags	= ssb_core_state_flags_sb,
 };
 
 static int __init ssb_modinit(void)
--- linux-next-20110203.orig/include/linux/ssb/ssb.h	2011-02-07 16:58:50.000000000 +0200
+++ linux-next-20110203/include/linux/ssb/ssb.h	2011-02-07 17:02:09.000000000 +0200
@@ -125,6 +125,9 @@ struct ssb_bus_ops {
 	u32 (*admatch_base)(struct ssb_device *dev, u32 adm);
 	u32 (*admatch_size)(struct ssb_device *dev, u32 adm);
 	u32 (*irqflag)(struct ssb_device *dev);
+	void (*core_ctl_flags)(struct ssb_device *dev, u32 mask,
+			       u32 val, u32 *res);
+	u32 (*core_state_flags)(struct ssb_device *dev, u32 mask, u32 val);
 };
 
 
@@ -490,7 +493,16 @@ static inline u32 ssb_irqflag(struct ssb
 {
 	return dev->ops->irqflag(dev);
 }
-
+static inline void ssb_core_ctl_flags(struct ssb_device *dev, u32 mask,
+				      u32 val, u32 *res)
+{
+	return dev->ops->core_ctl_flags(dev, mask, val, res);
+}
+static inline u32 ssb_core_state_flags(struct ssb_device *dev, u32 mask,
+				       u32 val)
+{
+	return dev->ops->core_state_flags(dev, mask, val);
+}
 
 /* The SSB DMA API. Use this API for any DMA operation on the device.
  * This API basically is a wrapper that calls the correct DMA API for



