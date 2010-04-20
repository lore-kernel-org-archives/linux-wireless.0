Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:64089 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab0DTSEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 14:04:10 -0400
Received: by ewy20 with SMTP id 20so2134220ewy.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Apr 2010 11:04:09 -0700 (PDT)
Message-ID: <4BCDEC94.2080202@lwfinger.net>
Date: Tue, 20 Apr 2010 13:04:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: "Bernhard M. Wiedemann" <bernhardout@lsmod.de>
Subject: Problem with AR5001 on eeepc900A after disable with RFKILL switch
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This problem is reported at
https://bugzilla.novell.com/show_bug.cgi?id=595586.

Although not mentioned in the bug report, the kernel is 2.6.33.

The initial part of the report is as follows:

======================================================================

After disabling WLAN on Asus eeepc 900A using rfkill button (Fn+F2) it
does not get back into a working state without a reboot.

Reproducible: Always

Steps to Reproduce:
1. boot up eeepc900A with WLAN enabled
2. press Fn+F2 (rfkill button) to disable WLAN
3. press Fn+F2 again to enable WLAN
Actual Results:

-----
1. lspci before rfkill
01:00.0 Ethernet controller: Atheros Communications AR8121/AR8113/AR8114
Gigabit or Fast Ethernet (rev b0)
02:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless
Network Adapter (rev 01)
-----
2. lspci after rfkill
01:00.0 Ethernet controller: Attansic Technology Corp. Atheros
AR8121/AR8113/AR8114 PCI-E Ethernet Controller (rev b0)
02:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless
Network Adapter (rev ff)

======================================================================

The curious thing is that the lspci output is different for both the
wired and wireless cards.

Any ideas on why setting rfkill should change data in this way?

Thanks,

Larry




