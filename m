Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34265 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbZKAMvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 07:51:19 -0500
Received: by bwz27 with SMTP id 27so5248514bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2009 04:51:24 -0800 (PST)
MIME-Version: 1.0
From: Thomas Wiecki <thomas.wiecki@googlemail.com>
Date: Sun, 1 Nov 2009 13:51:04 +0100
Message-ID: <4888b8cb0911010451w3e824921ob5ee6b7aae5b728b@mail.gmail.com>
Subject: b43 with 14e4 gives DMA error
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

0c:00.0 Network controller [0280]: Broadcom Corporation BCM4312
802.11b/g [14e4:4315] (rev 01)
        Subsystem: Dell Device [1028:000c]
        Flags: bus master, fast devsel, latency 0, IRQ 17
        Memory at f1ffc000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: <access denied>
        Kernel driver in use: wl
        Kernel modules: wl, ssb

A variable delay after loading the most recent b43 driver I get a lot
of (I hope last nights patches would have fixed the problems, but they
didn't):
[ 6895.111946] b43-phy0 ERROR: Fatal DMA error: 0x00000800,
0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
[ 6895.111955] b43-phy0: Controller RESET (DMA error) ...
[ 6895.336490] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
[ 6900.841372] b43-phy0: Controller restarted

After installing the driver for the first time, I have a few minutes I
can use the wifi card, after that the DMA errors start to occur. Once
they occured after the first loading, they appear immediatly after
each loading.

Ubuntu 9.04 (most recent) with kernel 2.6.31-14-generic

Laptop is Dell E6500.
