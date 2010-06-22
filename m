Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55543 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab0FVPnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 11:43:49 -0400
Received: by pvh11 with SMTP id 11so434669pvh.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jun 2010 08:43:49 -0700 (PDT)
Message-ID: <4C20D884.3010501@lwfinger.net>
Date: Tue, 22 Jun 2010 10:36:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Recent results with BCM4312 on Netbook
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

I have some good news. The Netbook that came from John is suddenly
developing DMA errors for the BCM4312, even though it does not have a
Phoenix BIOS. I have no idea why it did not fail this way earlier, but at
least I have a machine to debug that failure.

My first discovery is that if PIO mode is to be used, it is not sufficient
to load the module with the "pio=1" option, but that both "qos=0" and
"nohwcrypt=1" options must also be used, at least for WPA/WPA2 networks.
No other combination works. In addition, the automatic failover to PIO
mode does not work unless those two options were used when the module was
loaded. Thus both of the following work:

modprobe b43 pio=1 qos=0 nohwcrypt=1
modprobe b43 qos=0 hwcrypt=1

The second example gets a fatal DMA error and resets the controller before
the network comes up. I tried setting the latter two options before the
controller reset call in the failover, but that did not work.

If you have suggestions on changes in the switch from DMA to PIO mode,
please send them to me. In the meantime, I will be looking at differences
in the MMIO traces between wl and b43 to try to fix the DMA problem at the
source of the trouble.

Larry
