Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:18963 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYI3WjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 18:39:04 -0400
Date: Wed, 1 Oct 2008 00:27:23 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andreamrl@tiscali.it>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: NETGEAR WG111v2 (USB RTL8187): freezes whole system when setup
Message-ID: <20080930222723.GA28369@steel.home> (sfid-20081001_003921_655613_F3DA8CFD)
Reply-To: Alex Riesen <raa.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an USB wireless card: Netgear WG111v2. It is reported in
syslog as:

    usb 4-2: Product: NETGEAR WG111v2
    usb 4-2: Manufacturer: NETGEAR WG111v2
    usb 4-2: SerialNumber: 000FB5D51ECA
    phy1: Selected rate control algorithm 'pid'
    phy1: hwaddr 00:0f:b5:d5:1e:ca, RTL8187vB (default) V1 + rtl8225
    usbcore: registered new interface driver rtl8187

On ifconfig up, the card always locks up two very different systems: a
relatively modern P4 desktop and P-MMX laptop with UHCI (ancient Compaq
Armada 1592DT) which has an OHCI.

The connection is not stable and sometimes the card just stops
talking to anything outside: the connection is not dropped, but
nothing works (no ping replies). Up/down interface does not help.

Aside from that there were no ill effects noticed.

I tried 2.6.27-rc7 and -rc8 with no difference.

Reported to bugzilla as

    http://bugzilla.kernel.org/show_bug.cgi?id=11678

