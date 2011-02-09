Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:23191 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab1BIOtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:49:09 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000019994.msg
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 16:48:33 +0200
Subject: Re: SSB AI support code ([RFC9/11] SSB modify irqflag treatment)
From: George Kashperko <george@znau.edu.ua>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297258590.17400.37.camel@dev.znau.edu.ua>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
Content-Type: text/plain
Date: Wed, 09 Feb 2011 16:41:40 +0200
Message-Id: <1297262500.18053.36.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Modify irqflag routine to reuse tpsflag value rather than
reading TPSFLAG register once again. Change default "not
supported" value from 0x3F to -1.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/driver_mipscore.c |    2 +-
 drivers/ssb/ssb_sb.c          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
--- linux-next-20110203.orig/drivers/ssb/driver_mipscore.c	2011-02-08 16:14:57.000000000 +0200
+++ linux-next-20110203/drivers/ssb/driver_mipscore.c	2011-02-08 16:15:24.000000000 +0200
@@ -75,7 +75,7 @@ unsigned int ssb_mips_irq(struct ssb_dev
 	unsigned int irq;
 
 	irqflag = ssb_irqflag(dev);
-	if (irqflag == 0x3f)
+	if (irqflag == -1)
 		return 6;
 	ipsflag = ssb_read32(bus->mipscore.dev, SSB_IPSFLAG);
 	for (irq = 1; irq <= 4; irq++) {
--- linux-next-20110203.orig/drivers/ssb/ssb_sb.c	2011-02-08 16:14:57.000000000 +0200
+++ linux-next-20110203/drivers/ssb/ssb_sb.c	2011-02-08 16:15:24.000000000 +0200
@@ -175,10 +175,10 @@ static u32 ssb_irqflag_sb(struct ssb_dev
 {
 	u32 tpsflag = ssb_read32(dev, SSB_TPSFLAG);
 	if (tpsflag)
-		return ssb_read32(dev, SSB_TPSFLAG) & SSB_TPSFLAG_BPFLAG;
+		return tpsflag & SSB_TPSFLAG_BPFLAG;
 	else
 		/* not irq supported */
-		return 0x3f;
+		return -1;
 }
 
 static void ssb_core_ctl_flags_sb(struct ssb_device *dev, u32 mask,



