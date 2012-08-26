Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7387 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab2HZCB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2012 22:01:59 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20537.33465.256314.716102@gargle.gargle.HOWL> (sfid-20120826_040242_537925_EFE99F19)
Date: Sun, 26 Aug 2012 07:28:17 +0530
To: Sherwin Soltani <sherwin@wybc.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k: AR9462 btcoex doesn't appear to work
In-Reply-To: <50394BE4.3000508@wybc.com>
References: <50394BE4.3000508@wybc.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sherwin Soltani wrote:
> I have an Acer Aspire V5-571 which contains the AR9462 chipset (PCI ID 
> 168c:0034), supported by the ath9k driver. This chipset claims to 
> support Bluetooth coexistence. However, after booting up, my kernel does 
> not register any Bluetooth devices.
> 
> I am using kernel version 3.6.0-999-generic (apw@gomeisa) (gcc version 
> 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)). I also tried 3.4 and 3.2 kernels 
> without success. Additionally, I can try to do
> 
> rmmod ath9k && modprobe ath9k btcoex_enable=1
> 
> In the message log, I can see this:
> 
> [ 1204.643120] ath9k: ath9k: Driver unloaded
> [ 1214.203099] ath: phy1: Disabling ASPM since BTCOEX is enabled
> [ 1214.203105] ath: EEPROM regdomain: 0x6a
> [ 1214.203106] ath: EEPROM indicates we should expect a direct regpair map
> [ 1214.203108] ath: Country alpha2 being used: 00
> [ 1214.203109] ath: Regpair used: 0x6a
> 
> However 'hcitool dev' shows no devices after this operation.

What does lsusb -v show ?

The correct firmware is required, you can find it in:
http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=summary

Copy the files in ar3k/ into /lib/firmware/ar3k (might be different depending
on your distro).

Reload ath3k and something like this should be seen:

root@linux-test ~# hciconfig hci1 up
root@linux-test ~# hcitool dev
Devices:
        hci1    00:03:7F:44:84:8A

> Looking back through the ath9k-devel list, I can see that there was some 
> discussion on this chipset, but it seems that Bluetooth functionality 
> wasn't tested with it. Is this a known problem? Is there any information 
> I can supply to help fix it?

Coexistence testing is ongoing and bugs are still being ironed out,
but basic support is mostly done.

> Aside from the Bluetooth problems, there are also problems with 
> frequently dropping signals (even when I am very close to the access 
> point), but right now that's a secondary concern to Bluetooth for me.

Can you try with the latest driver (using compat-wireless) and see if the
problem persists ? If it does, please post the kernel log with driver
debugging set to 0x8f49.

http://wireless.kernel.org/en/users/Drivers/ath9k/debug

Sujith
