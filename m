Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38583 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbZHPNkZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 09:40:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: [RFT] Threaded IRQ handlers for b43
Date: Sun, 16 Aug 2009 15:39:57 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200908161539.57917.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This request-for-test patch converts the b43 driver to use threaded
interrupt handlers. This is needed to support b43 on SDIO. But it also
simplifies the locking by removal of the wl->irq_lock spinlock.

http://bu3sch.de/patches/wireless-testing/20090816-1535/patches/002-b43-threaded-irq-handler.patch

A known regression is a new race between the interrupt handler and the
beacon update handler. But as long as you don't run AP mode, it won't hurt.
I'm working on a solution...

Please test this patch whether it creates other regressions (performance and crashes).

The patch also needs the following hack to the threaded IRQ code:
http://bu3sch.de/patches/wireless-testing/20090816-1535/patches/001-hack-threaded-irqs.patch

-- 
Greetings, Michael.
