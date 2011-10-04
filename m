Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34677 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab1JDM3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 08:29:07 -0400
Received: by wwf22 with SMTP id 22so715496wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 05:29:06 -0700 (PDT)
Message-ID: <4E8AFBCB.8070100@gmail.com> (sfid-20111004_142911_886173_9EBDB2E3)
Date: Tue, 04 Oct 2011 14:27:55 +0200
From: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: RTL8192SE blank EFUSE readout after suspend resume cycle
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I recently discussed this with Larry Finger and Chaomin Li, but every
once in a while, after having resumed from suspending to RAM, my NIC
(10ec:8172) doesn't work anymore, even after reloading the module. Even
worse, after reloading the module, my NIC's name gets changed (because
of udev rules) as a result of the MAC address changing, which means I
have to temporarily reconfigure whatever I'm using to make a connection
(wicd in my case).

Now, as a byproduct of the other discussion I had (RTL8192SE and 802.11n
problems), I've patched the driver to dump the EFUSE when appropriate
hardware is detected, and this time, I got the following:

rtl8192se 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
rtl8192se 0000:06:00.0: setting latency timer to 64
rtl8192se: In process "modprobe" (pid 17913):MAP
FF FF FF FF  FF FF FF FF  FF FF FF FF  FF FF FF FF
FF FF FF FF  FF FF FF FF  FF FF FF FF  FF FF FF FF
FF FF FF FF  FF FF FF FF  FF FF FF FF  FF FF FF FF
FF FF FF FF  FF FF FF FF  FF FF FF FF  FF FF FF FF
FF FF FF FF  FF FF FF FF  FF FF FF FF  FF FF FF FF
FF FF FF FF  FF FF FF FF  FF FF FF FF  FF FF FF FF
FF FF FF FF  FF FF FF FF  FF FF FF FF  FF FF FF FF
FF FF FF FF  FF FF FF FF  FF FF FF FF  FF FF FF FF

rtl8192se: Driver for Realtek RTL8192SE/RTL8191SE
Loading firmware rtlwifi/rtl8192sefw.bin
ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
udevd[17907]: renamed network interface wlan0 to wlan26

As you can see, the EFUSE is completely messed up. To fix this problem,
I have to reboot my laptop. I'm not quite sure what could be causing
this, and I was hoping someone here might.

Greetings,
Stefan Zwanenburg
