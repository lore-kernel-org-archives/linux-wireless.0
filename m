Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63995 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab3BEV25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 16:28:57 -0500
Received: by mail-wi0-f180.google.com with SMTP id hi8so844858wib.7
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 13:28:55 -0800 (PST)
Message-ID: <51117994.1060506@gmail.com> (sfid-20130205_222910_312588_298DB769)
Date: Tue, 05 Feb 2013 22:28:52 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Thomas Rosenkranz <tom.rosary@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
References: <51102B22.20702@gmail.com> <CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com> <511163BA.7060902@gmail.com> <51116A33.9070207@lwfinger.net>
In-Reply-To: <51116A33.9070207@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2013 09:23 PM, Larry Finger wrote:

> What difference does it make what chip it has? It is obviously some flavor of RTL8188CU/RTL8192CU that is different enough that it does not work with the kernel version of rtl8192cu. A few months ago,
> I ran across a new B-CUT RTL8188CE that took new programming for rtl8192ce, and I suspect this device also has the B-CUT chip.
> 
> The crash on unloading is a known fault of the vendor driver. It happens with devices that work OK with the standard rtl8192cu. I have no desire to find out what causes the crash.

We were trying to know, loading the
_realtek_ driver, the chip of the device.

*Because*, as Thomas said before, doing:
# echo "0bda 819a" > /sys/bus/usb/drivers/rtl8192cu/new_id
with the rtl8192cu _kernel driver_
He got a _panic of the system_ .

This is a severe bug in rtlwifi.


BTW, the device is RTL8188C/RF6052

>>     [  183.370905] Chip Version ID: VERSION_NORMAL_TSMC_CHIP_88C.

VERSION_NORMAL_TSMC_CHIP_88C = 0x0008

>>     [  183.608631] Set RF Chip ID to RF_6052 and RF type to 1T1R.

RF_6052 = 4



B-cut are these ones:
VERSION_NORMAL_UMC_CHIP_8723_1T1R_B_CUT =       0x1089
VERSION_NORMAL_UMC_CHIP_88C_B_CUT =             0x1088
VERSION_NORMAL_UMC_CHIP_92C_B_CUT =             0x10a8
VERSION_NORMAL_UMC_CHIP_92C_1T2R_B_CUT =        0x1090


thank you.
