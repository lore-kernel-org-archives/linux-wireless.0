Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:26748 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1BQWSy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:18:54 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022245.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:18:16 +0200
Subject: Re: [RFC] AI support (3/14 ssb irqflag mips core op)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980093.13554.5.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 00:10:27 +0200
Message-Id: <1297980627.23381.7.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

SB- and AI-style buses read irq flags from different locations.
SB-ones read them from TPSFLAG whereas AI-ones from core oob register.
In order to support both SB- and AI-style buses transparently
irq flag accessor is implemented as ssb mips core op.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/driver_mipscore.c       |    6 ++++++
 include/linux/ssb/ssb_driver_mips.h |    3 +++
 2 files changed, 9 insertions(+)
--- linux-wireless-testing.orig/drivers/ssb/driver_mipscore.c	2011-02-08 00:22:45.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/driver_mipscore.c	2011-02-17 14:05:27.000000000 +0200
@@ -49,6 +49,11 @@ static const u32 ipsflag_irq_shift[] = {
 
 static inline u32 ssb_irqflag(struct ssb_device *dev)
 {
+	return dev->bus->mipscore.irqflag(dev);
+}
+
+static u32 ssb_irqflag_sb(struct ssb_device *dev)
+{
 	u32 tpsflag = ssb_read32(dev, SSB_TPSFLAG);
 	if (tpsflag)
 		return ssb_read32(dev, SSB_TPSFLAG) & SSB_TPSFLAG_BPFLAG;
@@ -241,6 +246,7 @@ void ssb_mipscore_init(struct ssb_mipsco
 	ssb_dprintk(KERN_INFO PFX "Initializing MIPS core...\n");
 
 	bus = mcore->dev->bus;
+	bus->mipscore.irqflag = ssb_irqflag_sb;
 	hz = ssb_clockspeed(bus);
 	if (!hz)
 		hz = 100000000;
--- linux-wireless-testing.orig/include/linux/ssb/ssb_driver_mips.h	2011-02-08 00:22:50.000000000 +0200
+++ linux-wireless-testing/include/linux/ssb/ssb_driver_mips.h	2011-02-17 14:05:27.000000000 +0200
@@ -23,6 +23,9 @@ struct ssb_mipscore {
 	u8 flash_buswidth;
 	u32 flash_window;
 	u32 flash_window_size;
+
+	/* mips core implementation-specific irq flag helper */
+	u32 (*irqflag)(struct ssb_device *dev);
 };
 
 extern void ssb_mipscore_init(struct ssb_mipscore *mcore);



