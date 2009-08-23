Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35278 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933485AbZHWMtf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2009 08:49:35 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: [RFT] b43: Get rid of spinlocks (version 2)
Date: Sun, 23 Aug 2009 14:48:16 +0200
Cc: linux-wireless@vger.kernel.org,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200908231448.16550.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset removes all spinlocks (except the LEDs lock for now) from b43.
There are no known races or bugs added by this patchset.
Please test it a lot, so we can ensure there are no regressions.

It sometimes crashes for me in the lockdep code on module unload, but I'm not
really sure whether that is a b43 or lockdep bug.
Please test test test. :)

Apply the patchset in this order to wireless-testing.git:
http://bu3sch.de/patches/wireless-testing/20090823-1442/patches/001-fix-irq-thread-wakeup.patch
http://bu3sch.de/patches/wireless-testing/20090823-1442/patches/002-b43-threaded-irq-handler.patch
http://bu3sch.de/patches/wireless-testing/20090823-1442/patches/003-b43-remove-tx-lock.patch
http://bu3sch.de/patches/wireless-testing/20090823-1442/patches/004-b43-remove-queue-locks.patch
http://bu3sch.de/patches/wireless-testing/20090823-1442/patches/005-b43-remove-pio-rx-work.patch
http://bu3sch.de/patches/wireless-testing/20090823-1442/patches/006-b43-remove-shm-lock.patch


-- 
Greetings, Michael.
