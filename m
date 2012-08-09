Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54904 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2HIWRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 18:17:50 -0400
Received: by wibhq12 with SMTP id hq12so704169wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 15:17:49 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Aug 2012 00:17:49 +0200
Message-ID: <CACRof1UCCB1v0a1Zscr5pjCoWz1m4aJXyeHvVnZ1SmOyFc+W3w@mail.gmail.com> (sfid-20120810_001753_104401_8388ECD6)
Subject: ath5k interrupt storm with linux 3.4.7 on IBM Thinkpad X31
From: Manuel Jander <manuel.jander@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Linux 3.4.7 ath5k driver is unusable on a Thinkpad X31, the machine
uses almost 100% CPU handling interrupts, barely responding to
anything. Using the old version of the function ath5k_hw_get_isr() in
drivers/net/wireless/ath/ath5k/dma.c of Linux 3.1.6 patched into Linux
3.4.7 works again. My guess: some interrupt flags (0x400 and 0x80) are
not cleared correctly or retriggered artificially by some unlucky
register manipulations.

Enabling interrupt debug (debug=0x4 if a recall correctly) shows that
the interrupt status is stuck to 0x480 with Linux 3.4.7.

Is this a known problem ? Is there any detailed behaviour
description/documentation availabe of this chip ?

Cheers,
Manuel
