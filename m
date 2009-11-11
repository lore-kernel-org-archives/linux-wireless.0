Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50613 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbZKKBZ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 20:25:56 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1N81yD-00082O-8h
	for linux-wireless@vger.kernel.org; Wed, 11 Nov 2009 02:26:01 +0100
Received: from 76-10-155-41.dsl.teksavvy.com ([76.10.155.41])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2009 02:26:01 +0100
Received: from monnier by 76-10-155-41.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2009 02:26:01 +0100
To: linux-wireless@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: rtl8187se locks up when switching network
Date: Tue, 10 Nov 2009 20:25:37 -0500
Message-ID: <jwvljidrhm3.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: monnier@iro.umontreal.ca
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been using the rtl8187se driver in the vanilla liunx kernel since
2.6.29 for my MSI Wind and in general it seems to work just fine for my
use (connecting as a client to different access points, some of which
use WPA and others public, all under the control of wicd).

The only problem is that while connecting/disconnecting from networks
appears to work, the system often (almost always) hangs when connecting
to a different network than the last one.

I've just dine a few more tests, and switching network works just fine
if I "modprobe -r rtl8187se" and then "modprobe rth8187se" between the
disconnect and the reconnect, but otherwise the system almost always
hangs during the connection to the other network.  The way it hangs is
always the same: everything just freezes and 2 of the status
leds blink.  The exact moment at which the freeze takes place seems to
vary: sometimes it's while getting the IP address, other times its
earlier.

I've seen it with the 2.6.29 and 2.6.30 Debian kernels and have just
tried it with a freshly cloned wireless-testing kernel (2.6.32-rc6-wl).

IIUC this driver is not under active development, but maybe someone
knows it enough to try and fix it, or maybe there's some alternative
driver for this card that I should try?


        Stefan


PS: I see nothing in the system logs around the time of the system hang.
Here's the dmesg output when inserting the module, in case it's helpful.

[ 1398.353690] Linux kernel driver for RTL8180 / RTL8185 based WLAN cards
[ 1398.353706] Copyright (c) 2004-2005, Andrea Merello
[ 1398.353716] r8180: Initializing module
[ 1398.353728] r8180: Wireless extensions version 22
[ 1398.353739] r8180: Initializing proc filesystem
[ 1398.353834] r8180: Configuring chip resources
[ 1398.353885] r8180 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 1398.353911] r8180 0000:02:00.0: setting latency timer to 64
[ 1398.356863] r8180: Channel plan is 2
[ 1398.356869] 
[ 1398.356881] Dot11d_Init()
[ 1398.356895] r8180: MAC controller is a RTL8187SE b/g
[ 1398.356903] r8180: This is a PCI NIC
[ 1398.359377] r8180: usValue is 0x100
[ 1398.359385] 
[ 1398.414271] r8180: EEPROM version 104
[ 1398.419068] r8180: WW:**PLEASE** REPORT SUCCESSFUL/UNSUCCESSFUL TO Realtek!
[ 1398.420127] r8180: IRQ 17
[ 1398.424538] r8180: Driver probe completed

