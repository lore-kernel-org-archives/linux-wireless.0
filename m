Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53725 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab0E0QNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 12:13:21 -0400
Received: by pwi7 with SMTP id 7so101951pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 09:13:20 -0700 (PDT)
Message-ID: <4BFE9A22.5040005@lwfinger.net>
Date: Thu, 27 May 2010 11:13:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>, Greg KH <greg@kroah.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Conversion of driver for Realtek 8192SU
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am in the process of converting the driver contained in the file
RTL8192SU_usb_linux_v2.6.0006.20100511.zip obtained from the Realtek
site. This driver is used for the following USB IDs:

Realtek (0x0bda)  0x8171, 0x8172, 0x8173, 0x8174, 0x8712, 0x8713, 0xC512
Correga (0x07aa)  0x0047
D-Link (0x07d1)   0x3303, 0x3302, 0x3300
Skyworth (0x14b2) 0x3300, 0x3301, 0x3302
EnGenius (0x1740) 0x9603, 0x9605
Belkin (0x050d)   0x815F, 0x945A, 0x845A
Guillemot(0x06f8) 0xe031
Edimax (0x7392)   0x7611, 0x7612, 0x7622
Sitecom (0x0DF6)  0x0045
Hawking (0x0E66)  0x0015, 0x0016, 0x1786, 0x1791
Other (0x13D3)    0x3306, 0x3309, 0x3310, 0x3311, 0x3325
Other (0x083A)    0xC512

My initial plan is to modify this driver code for inclusion in
drivers/staging. The above list includes some, but not all, of the IDs
in the driver currently in drivers/staging/rtl8192su. I will likely put
this in as drivers/staging/rtl8712u, which is the name used in the code,
and remove the duplicate IDs from rtl8192su. Once this step is done, I
will then work at modifying it to use mac80211 so that it can go into
mainline.

My test device is a D-Link DWA-130 (14b2:3300). The Realtek driver
compiles cleanly and works as-is for this device on i386 architecture;
however, compilation spews hundreds of warnings when built on x86_64.
Most of these are due to wrong sized integers in pointer - integer
conversions and were easily fixed. The driver also oopsed due to an
illegal array index when getting the channel number from scan data. I
found this problem, and added a fixup and a log message to prevent the
oops. The driver now scans correctly, but cannot connect on x86_64,
which is my second reason for this message.

I know that the size of pointers changes from 32- to 54-bit
architecture, as does the size of longs. I have been through the code
many times, and I think those have been fixed. Are there any other types
of objects that change size? Does anyone have any suggestions on what to
look for?

Thanks,

Larry
