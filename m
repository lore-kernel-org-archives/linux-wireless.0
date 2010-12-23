Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64065 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab0LWRem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 12:34:42 -0500
Received: by fxm20 with SMTP id 20so7306535fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Dec 2010 09:34:41 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 23 Dec 2010 12:34:40 -0500
Message-ID: <AANLkTimDPcxSthO=TAqPx4fyrU0U_WPkwMHLGGiCSMKw@mail.gmail.com>
Subject: carl9170 and debian squeeze
From: Der Engel <engelster@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a ubiquiti sr71-usb wireless adapter, 'lsusb' shows it as:
'Atheros Communications, Inc. AR9170 802.11n', the adapter works with
the ar9170.fw firmware but I'm trying to make it work with the
carl9170.fw, until now I have tried the following:

I have put the carl9170.fw in /lib/firmware (debian default for
firmware files) without the ar9170.fw, dmesg shows that the system its
looking for a firmware with the exact name as 'ar9170.fw' or if it
doesn't find that one it tries to finds the legacy ones(ar9170-1.fw &
ar9170-2.fw), so it ignores carl9170.fw because is not named
ar9170.fw, changing the name of carl9170.fw to ar9170.fw shows the
following:

dmesg | grep 9170
[    2.329719] usb 2-2: New USB device found, idVendor=0cf3, idProduct=9170
[    8.817173] usb 2-2: firmware: requesting ar9170.fw
[    9.862192] ar9170usb: probe of 2-2:1.0 failed with error -110
[    9.862227] usbcore: registered new interface driver ar9170usb

The kernel is debian stock one:Linux laptop 2.6.32-5-686 #1 SMP Fri
Dec 10 16:12:40 UTC 2010 i686 GNU/Linux

Any ideas how can I make carl9170.fw work in debian squeeze?

Thanks,
Der
