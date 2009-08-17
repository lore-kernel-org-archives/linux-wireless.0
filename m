Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38148 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799AbZHQLsE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 07:48:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFT] Threaded IRQ handlers for b43
Date: Mon, 17 Aug 2009 13:48:04 +0200
Cc: linux-wireless@vger.kernel.org
References: <200908161539.57917.mb@bu3sch.de>
In-Reply-To: <200908161539.57917.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908171348.04399.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 16 August 2009 15:39:57 Michael Buesch wrote:
> This request-for-test patch converts the b43 driver to use threaded
> interrupt handlers. This is needed to support b43 on SDIO. But it also
> simplifies the locking by removal of the wl->irq_lock spinlock.
> 
> http://bu3sch.de/patches/wireless-testing/20090816-1535/patches/002-b43-threaded-irq-handler.patch
> 
> A known regression is a new race between the interrupt handler and the
> beacon update handler. But as long as you don't run AP mode, it won't hurt.
> I'm working on a solution...
> 
> Please test this patch whether it creates other regressions (performance and crashes).
> 
> The patch also needs the following hack to the threaded IRQ code:
> http://bu3sch.de/patches/wireless-testing/20090816-1535/patches/001-hack-threaded-irqs.patch
> 

This is the correct fix for the threaded IRQ code. Apply this instead of the hack:
http://bu3sch.de/patches/wireless-testing/20090817-1347/patches/001-fix-irq-thread-wakeup.patch

-- 
Greetings, Michael.
