Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:26772 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab1BQWVJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:21:09 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022247.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:20:31 +0200
Subject: Re: [RFC] AI support (4/14 ssb mips core irqflag treatment)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980093.13554.5.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 00:12:40 +0200
Message-Id: <1297980760.23381.11.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Modify irqflag routine to reuse tpsflag value rather than
reading TPSFLAG register once again. Change default "not
supported" value from 0x3F to -1.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/driver_mipscore.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)
--- linux-wireless-testing.orig/drivers/ssb/driver_mipscore.c	2011-02-17 14:07:23.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/driver_mipscore.c	2011-02-17 14:11:09.000000000 +0200
@@ -54,12 +54,12 @@ static inline u32 ssb_irqflag(struct ssb
 
 static u32 ssb_irqflag_sb(struct ssb_device *dev)
 {
-	u32 tpsflag = ssb_read32(dev, SSB_TPSFLAG);
-	if (tpsflag)
-		return ssb_read32(dev, SSB_TPSFLAG) & SSB_TPSFLAG_BPFLAG;
+	u32 tpsflag = ssb_read32(dev, SSB_TPSFLAG) & SSB_TPSFLAG_BPFLAG;
+	if (tpsflag && tpsflag != SSB_TPSFLAG_BPFLAG)
+		return tpsflag;
 	else
 		/* not irq supported */
-		return 0x3f;
+		return -1;
 }
 
 static struct ssb_device *find_device(struct ssb_device *rdev, int irqflag)
@@ -90,7 +90,7 @@ unsigned int ssb_mips_irq(struct ssb_dev
 	unsigned int irq;
 
 	irqflag = ssb_irqflag(dev);
-	if (irqflag == 0x3f)
+	if (irqflag == -1)
 		return 6;
 	ipsflag = ssb_read32(bus->mipscore.dev, SSB_IPSFLAG);
 	for (irq = 1; irq <= 4; irq++) {



