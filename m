Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34480 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3BEWhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 17:37:34 -0500
Received: by mail-wi0-f179.google.com with SMTP id ez12so911095wid.6
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 14:37:32 -0800 (PST)
Message-ID: <511189A9.8060609@gmail.com> (sfid-20130205_233738_335553_207A87C9)
Date: Tue, 05 Feb 2013 23:37:29 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Thomas Rosenkranz <tom.rosary@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
References: <51102B22.20702@gmail.com> <CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com> <511163BA.7060902@gmail.com> <51116A33.9070207@lwfinger.net> <51117994.1060506@gmail.com> <51117F98.3040900@lwfinger.net>
In-Reply-To: <51117F98.3040900@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2013 10:54 PM, Larry Finger wrote:

> Yes, but not a bug for the devices that it is supposed to support! No one ever says that their driver will support *future* devices! As I said earlier, there are newer versions of the RTL8188C chip
> that requires different programming, which may be the cause of the problem. On the other hand, the chip change did not cause a crash in rtl8192ce. I just didn't work very well. As I have no such
> device, I cannot test any changes; therefore, I will not make them. If you want to write patches that let that device work with the kernel driver, I will be happy to review them.

Then, remove the "new_id" facility of the driver.

*Or* fix the driver. rt2x00 handles correctly any
kind of unknown device.

usb 2-1.5: new high-speed USB device number 5 using ehci_hcd
usb 2-1.5: New USB device found, idVendor=0bda, idProduct=8176
usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1.5: Product: 802.11n WLAN Adapter
usb 2-1.5: Manufacturer: *Realtek*
usb 2-1.5: SerialNumber: 00e04c000001

# echo "0bda 8176"  > /sys/bus/usb/drivers/rt2800usb/new_id

phy2 -> rt2800_init_eeprom: Error - Invalid RT chipset 0x0000 detected.
phy2 -> rt2x00lib_probe_dev: Error - Failed to allocate device.

and it doesn't panic. The system works flawlessly after that, see:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/net/wireless/rt2x00/rt2800lib.c;h=197b4466a5d2a44378f998fdefa2c221ae6124c6;hb=HEAD#l4798


rtlwifi also can do the same, -ENODEV in rtl8192cu/mac.c
rtl92c_read_chip_version() at switch(rtlhal->version) default:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/net/wireless/rtlwifi/rtl8192cu/mac.c;h=32ff959a0251bdf36cb69122b55a6fc438e3bdd0;hb=HEAD#l127
