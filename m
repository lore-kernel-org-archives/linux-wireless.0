Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernelconcepts.de ([188.40.83.200]:45603 "EHLO
        mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753148AbdBTOcU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 09:32:20 -0500
Received: from [87.182.109.56] (helo=vbox.localnet)
        by mail.kernelconcepts.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <hilberg@kernelconcepts.de>)
        id 1cfoNv-0002C7-VF
        for linux-wireless@vger.kernel.org; Mon, 20 Feb 2017 14:52:12 +0100
From: Christian Hilberg <hilberg@kernelconcepts.de>
To: linux-wireless@vger.kernel.org
Subject: [rtl8xxxu] rtl8192cu (0bda:8176) on linux-4.9.11 (arm) high sirq rate
Date: Mon, 20 Feb 2017 14:51:54 +0100
Message-ID: <1581189.s4o7FEpKoz@vbox> (sfid-20170220_153223_694913_3155B305)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

currently I'm testing rtl8xxxu on an ARM device (i.mx28, armv5te) under
linux-4.9.11 with a RealTek 8192cu (0bda:8176) wifi dongle. Since
I had to set CONFIG_RTL8XXXU_UNTESTED, I'm prepared to see some
rough edges here and there. :-)

The driver actually works and I'm getting a stable connection on
a WPA2 secured wifi network. As a firmware blob, the driver loads
the "rtl8192cufw_TMSC.bin", which I extracted from [0].

However, the sirg rate is rather high (between 20% to 50% in top),
as soon as the device is getting upped, that is, as soon as IFF_UP
gets written to the device via ioctl().

In the same setup, but with the rtlwifi driver, I'm not seeing a high
sirq rate, but that driver drops connection every now and then for me,
so I'd rather resort to rtl8xxxu.

I've prepped a kernel with ftrace functionality and got some logs,
which seem to point to the USB subsystem (many entries about URB
giveback, but I'm not clear whether this is an issue here).

In a private mail, Jes hinted that there might be something going on
with enabling interrupts on the chip or some debugging related
stuff (just I'm not seeing any on the console).

I'm a little lost here, any pointers on the matter are much welcome.
If needed, I can provide ftrace logs, just slip me a note.

Regards,

	Christian

PS.:	I've seen the same sirq rate back to rc-Versions of 4.9 on
	that arm device.


[0] http://ftp.de.debian.org/debian/pool/non-free/f/firmware-nonfree/firmware-realtek_20161130-2_all.deb

-- 
