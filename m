Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:13867 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965396AbaFQVs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:56 -0400
Message-ID: <63ed0fb1a4c098dd260f249546408de5.squirrel@www.infidigm.net> (sfid-20140618_003405_454840_FB968FA6)
Date: Tue, 17 Jun 2014 17:19:30 -0400
Subject: Re: QCA ar9375 in Ubuntu 14.04 beta 2 not working
From: drwho@infidigm.net
To: "Kalle Valo" <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi,
> replying to a mail from two months back:
> drwho@infidigm.net writes:
>> I just got a UB134C which has a QCA ar9375.  I tried it in Ubuntu 14.04
beta 2 kernel =
>> 3.13.0-22-generic #44-Ubuntu SMP Wed Apr 2 20:04:41 UTC 2014 i686 I'm
told the 9375 is an ath6kl, but it doesn't look like the ath6kl driver
>> supports it.  kernel output.....
>> new high-speed USB device number 4 using ehci-pci
>> [175257.129911] usb 1-2: New USB device found, idVendor=0cf3,
>> idProduct=9375
>> [175257.129923] usb 1-2: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
>> [175257.129931] usb 1-2: Product: USBWLAN
>> [175257.129939] usb 1-2: Manufacturer: Qualcomm Atheros.
>> [175257.129946] usb 1-2: SerialNumber: 12345678
> I just sent patches to add ar6004 hw3.0 support. If you can, please test
those and give feedback.

Ok, I rebuilt the Ubuntu kernel with your 6 patches,
sudo modprobe ath6kl_usb
insert ar9375
At first I was getting an error about not being able find the firmware
file, so I renamed your fw-5.bin to fw.ram.bin.  Now I get......

[  105.212065] usb 2-1: new high-speed USB device number 3 using ehci-pci
[  105.344939] usb 2-1: New USB device found, idVendor=0cf3,
idProduct=9375
[  105.344944] usb 2-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[  105.344948] usb 2-1: Product: USBWLAN
[  105.344951] usb 2-1: Manufacturer: Qualcomm Atheros.
[  105.344953] usb 2-1: SerialNumber: 12345678
[  140.212654] usb 2-1: Direct firmware load failed with error -2
[  140.212660] usb 2-1: Falling back to user helper
[  140.213580] usb 2-1: Direct firmware load failed with error -2
[  140.213584] usb 2-1: Falling back to user helper
[  140.215225] usb 2-1: Direct firmware load failed with error -2
[  140.215230] usb 2-1: Falling back to user helper
[  141.232254] ath6kl: Failed to submit usb control message: -110
[  141.232259] ath6kl: unable to send the bmi data to the device: -110 [ 
141.232263] ath6kl: Unable to write to the device: -110
[  141.232265] ath6kl: Failed to write firmware: -110
[  141.239999] ath6kl: Failed to start hardware: -110
[  141.240132] ath6kl: Failed to init ath6kl core: -110
[  141.240215] ath6kl_usb: probe of 2-1:1.0 failed with error -110 [ 
141.240251] usbcore: registered new interface driver ath6kl_usb

I then replaced your fw.ram.bin and bdata.bin with the firmware from
ATH6KL-LSDK-WLAN-AIO-OSR-5.0.0.110 and the device registers now....

[  264.596614] usb 2-1: USB disconnect, device number 6
[  295.384085] usb 2-1: new high-speed USB device number 7 using ehci-pci
[  295.517925] usb 2-1: New USB device found, idVendor=0cf3, idProduct=9375
[  295.517937] usb 2-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[  295.517946] usb 2-1: Product: USBWLAN
[  295.517954] usb 2-1: Manufacturer: Qualcomm Atheros.
[  295.517961] usb 2-1: SerialNumber: 12345678
[  295.521134] usb 2-1: Direct firmware load failed with error -2
[  295.521144] usb 2-1: Falling back to user helper
[  295.523720] usb 2-1: Direct firmware load failed with error -2
[  295.523729] usb 2-1: Falling back to user helper
[  295.527415] usb 2-1: Direct firmware load failed with error -2
[  295.527426] usb 2-1: Falling back to user helper
[  295.760488] ath6kl: ar6004 hw 3.0 usb fw 5.0.0.110 api 1
[  295.760502] ath6kl: firmware supports: 64bit-rates,ap-inactivity-mins
[  295.784446] systemd-udevd[2781]: renamed network interface wlan1 to wlan2
[  295.795658] IPv6: ADDRCONF(NETDEV_UP): wlan2: link is not ready
[  295.796058] IPv6: ADDRCONF(NETDEV_UP): wlan2: link is not ready
[  322.236793] IPv6: ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready

however it looks like it can not fully authenticate.  repeatedly doing "iw
wlan2 link" briefly shows a connection, then not connected. Network
manager repeatedly tries to connect.  I also put your patches into
backports and tried it on an arm with wpa_supplicant.  wpa_supplicant
keeps trying to re associate.  I can run wpa_supplicant with -dd if you
want?

Jon


