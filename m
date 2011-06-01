Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailhub-lb3.unibe.ch ([130.92.0.84]:47593 "EHLO
	mailhub-lb3.unibe.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab1FAMdG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 08:33:06 -0400
Received: from localhost (scanhub-lb2.unibe.ch [130.92.0.75])
	by mailhub-lb3.unibe.ch (Postfix) with ESMTP id 388A980A81
	for <linux-wireless@vger.kernel.org>; Wed,  1 Jun 2011 14:25:40 +0200 (CEST)
Received: from mailhub-lb3.unibe.ch ([130.92.0.84])
	by localhost (scanhub-lb2.unibe.ch [130.92.0.75]) (amavisd-new, port 10024)
	with LMTP id rVYN-Njo+YTI for <linux-wireless@vger.kernel.org>;
	Wed,  1 Jun 2011 14:25:38 +0200 (CEST)
Received: from mail.iam.unibe.ch (asterix.unibe.ch [130.92.64.4])
	by mailhub-lb3.unibe.ch (Postfix) with ESMTP id 2C1AC8109C
	for <linux-wireless@vger.kernel.org>; Wed,  1 Jun 2011 14:25:38 +0200 (CEST)
Received: from [130.92.65.69] (apu [130.92.65.69])
	by mail.iam.unibe.ch (8.13.8+Sun/8.13.8) with ESMTP id p51CPbf2028250
	for <linux-wireless@vger.kernel.org>; Wed, 1 Jun 2011 14:25:38 +0200 (MEST)
Message-ID: <4DE62FC1.9010500@iam.unibe.ch> (sfid-20110601_143313_134896_685B8544)
Date: Wed, 01 Jun 2011 14:25:37 +0200
From: =?ISO-8859-15?Q?Ulrich_B=FCrgi?= <buergi@iam.unibe.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Failed to find firmware
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,

I cross-compiled a Kernel (2.6.37.2) to run on an ARM device (Gumstix 
Overo).

Now I would like to use two Wifi devices: the on-board Marvell 88W8686 
based chip as well as an Atheros based TP-LINK USB stick. The problem 
is, however, that every time I load the libertas and the atheros 
modules, it fails with the errors
'libertas: failed to find firmware (-2)' and
'ath9k_htc: Firmware - ar9271.fw not found', respectively. I've attached 
all related log messages at the bottom of this mail.

As you can see, the firmware files are present in /lib/firmware:

root@lba09:~ # ls -lR /lib/firmware/
/lib/firmware/:
-rw-r--r--    1 root  root      51312 May 31  2011 ar9271.fw
-rw-r--r--    1 root  root      51272 May 31  2011 htc_9271.fw
drwxr-xr-x    2 root  root       0 Jan  1 01:01 libertas

/lib/firmware/libertas:
-rw-r--r--    1 root  root      96716 May 31  2011 sd8385.bin
-rw-r--r--    1 root  root    2140 May 31  2011 sd8385_helper.bin
-rw-r--r--    1 root  root     155648 May 31  2011 sd8682.bin
-rw-r--r--    1 root  root    2616 May 31  2011 sd8682_helper.bin
-rw-r--r--    1 root  root     122800 May 31  2011 sd8686_v8.bin
-rw-r--r--    1 root  root    2464 May 31  2011 sd8686_v8_helper.bin
-rw-r--r--    1 root  root     124188 May 31  2011 sd8686_v9.bin
-rw-r--r--    1 root  root    2516 May 31  2011 sd8686_v9_helper.bin
-rw-r--r--    1 root  root     259172 May 31  2011 sd8688.bin
-rw-r--r--    1 root  root    2616 May 31  2011 sd8688_helper.bin

These files are from 
ftp://ftp.kernel.org/pub/linux/kernel/people/dwmw2/firmware/linux-firmware-20110518.tar.gz

Do the modules look for firmware in other places besides /lib/firmware? 
I also tried copying them to /var/lib/firmware without success.

Or does anybody have another idea what could be wrong?

Thank you,
Ulrich

--

root@lba09:~ # modprobe -v libertas_sdio
insmod /lib/modules/2.6.37.2/kernel/drivers/base/firmware_class.ko.gz
insmod /lib/modules/2.6.37.2/kernel/net/wireless/cfg80211.ko.gz
insmod 
/lib/modules/2.6.37.2/kernel/drivers/net/wireless/libertas/libertas.ko.gz
insmod 
/lib/modules/2.6.37.2/kernel/drivers/net/wireless/libertas/libertas_sdio.ko.gz

Jan  1 01:06:43 lba09 user.debug kernel: device class 'firmware': 
registering
Jan  1 01:06:43 lba09 user.debug kernel: device class 'ieee80211': 
registering
Jan  1 01:06:43 lba09 user.debug kernel: Registering platform device 
'regulatory.0'. Parent at platform
Jan  1 01:06:43 lba09 user.debug kernel: device: 'regulatory.0': device_add
Jan  1 01:06:43 lba09 user.debug kernel: bus: 'platform': add device 
regulatory.0
Jan  1 01:06:43 lba09 user.debug kernel: PM: Adding info for 
platform:regulatory.0
Jan  1 01:06:43 lba09 user.info kernel: cfg80211: Calling CRDA to update 
world regulatory domain
Jan  1 01:06:44 lba09 user.info kernel: libertas_sdio: Libertas SDIO driver
Jan  1 01:06:44 lba09 user.info kernel: libertas_sdio: Copyright Pierre 
Ossman
Jan  1 01:06:44 lba09 user.debug kernel: bus: 'sdio': add driver 
libertas_sdio
Jan  1 01:06:44 lba09 user.debug kernel: bus: 'sdio': 
driver_probe_device: matched device mmc1:0001:1 with driver libertas_sdio
Jan  1 01:06:44 lba09 user.debug kernel: bus: 'sdio': really_probe: 
probing driver libertas_sdio with device mmc1:0001:1
Jan  1 01:06:44 lba09 user.debug kernel: libertas_sdio mmc1:0001:1: 
firmware: requesting libertas/sd8686_v9_helper.bin
Jan  1 01:06:44 lba09 user.debug kernel: device: 'mmc1:0001:1': device_add
Jan  1 01:06:44 lba09 user.debug kernel: PM: Adding info for No 
Bus:mmc1:0001:1
Jan  1 01:07:45 lba09 user.debug kernel: device: 'mmc1:0001:1': 
device_unregister
Jan  1 01:07:45 lba09 user.debug kernel: PM: Removing info for No 
Bus:mmc1:0001:1
Jan  1 01:07:45 lba09 user.debug kernel: libertas_sdio mmc1:0001:1: 
firmware: requesting libertas/sd8686_v8_helper.bin
Jan  1 01:07:45 lba09 user.debug kernel: device: 'mmc1:0001:1': device_add
Jan  1 01:07:45 lba09 user.debug kernel: PM: Adding info for No 
Bus:mmc1:0001:1
Jan  1 01:08:46 lba09 user.debug kernel: device: 'mmc1:0001:1': 
device_unregister
Jan  1 01:08:46 lba09 user.debug kernel: PM: Removing info for No 
Bus:mmc1:0001:1
Jan  1 01:08:46 lba09 user.debug kernel: libertas_sdio mmc1:0001:1: 
firmware: requesting sd8686_helper.bin
Jan  1 01:08:46 lba09 user.debug kernel: device: 'mmc1:0001:1': device_add
Jan  1 01:08:46 lba09 user.debug kernel: PM: Adding info for No 
Bus:mmc1:0001:1
Jan  1 01:09:47 lba09 user.debug kernel: device: 'mmc1:0001:1': 
device_unregister
Jan  1 01:09:47 lba09 user.debug kernel: PM: Removing info for No 
Bus:mmc1:0001:1
Jan  1 01:09:47 lba09 user.err kernel: libertas: failed to find firmware 
(-2)
Jan  1 01:09:47 lba09 user.warn kernel: libertas_sdio: probe of 
mmc1:0001:1 failed with error -2

--

root@lba09:~ # modprobe -v ath9k_htc
insmod /lib/modules/2.6.37.2/kernel/drivers/net/wireless/ath/ath.ko.gz
insmod 
/lib/modules/2.6.37.2/kernel/drivers/net/wireless/ath/ath9k/ath9k_hw.ko.gz
insmod 
/lib/modules/2.6.37.2/kernel/drivers/net/wireless/ath/ath9k/ath9k_common.ko.gz 

insmod /lib/modules/2.6.37.2/kernel/net/mac80211/mac80211.ko.gz
insmod 
/lib/modules/2.6.37.2/kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko.gz

Jan  1 01:12:25 lba09 user.debug kernel: usb usb1: usb wakeup-resume
Jan  1 01:12:25 lba09 user.debug kernel: usb usb1: rpm_resume flags 0x4
Jan  1 01:12:25 lba09 user.debug kernel: usb usb1: usb auto-resume
Jan  1 01:12:25 lba09 user.debug kernel: ehci-omap ehci-omap.0: resume 
root hub
Jan  1 01:12:25 lba09 user.debug kernel: hub 1-0:1.0: hub_resume
Jan  1 01:12:25 lba09 user.debug kernel: ehci-omap ehci-omap.0: 
GetStatus port:2 status 001803 0  ACK POWER sig=j CSC CONNECT
Jan  1 01:12:25 lba09 user.debug kernel: hub 1-0:1.0: port 2: status 
0501 change 0001
Jan  1 01:12:26 lba09 user.debug kernel: usb usb1: rpm_resume returns 0
Jan  1 01:12:26 lba09 user.debug kernel: hub 1-0:1.0: state 7 ports 3 
chg 0004 evt 0000
Jan  1 01:12:26 lba09 user.debug kernel: hub 1-0:1.0: rpm_resume flags 0x4
Jan  1 01:12:26 lba09 user.debug kernel: usb usb1: rpm_resume flags 0x0
Jan  1 01:12:26 lba09 user.debug kernel: usb usb1: rpm_resume returns 1
Jan  1 01:12:26 lba09 user.debug kernel: hub 1-0:1.0: rpm_resume returns 0
Jan  1 01:12:26 lba09 user.debug kernel: hub 1-0:1.0: port 2, status 
0501, change 0000, 480 Mb/s
Jan  1 01:12:26 lba09 user.debug kernel: ehci-omap ehci-omap.0: port 2 
high speed
Jan  1 01:12:26 lba09 user.debug kernel: ehci-omap ehci-omap.0: 
GetStatus port:2 status 001005 0  ACK POWER sig=se0 PE CONNECT
Jan  1 01:12:26 lba09 user.info kernel: usb 1-2: new high speed USB 
device using ehci-omap and address 2
Jan  1 01:12:26 lba09 user.debug kernel: ehci-omap ehci-omap.0: port 2 
high speed
Jan  1 01:12:26 lba09 user.debug kernel: ehci-omap ehci-omap.0: 
GetStatus port:2 status 001005 0  ACK POWER sig=se0 PE CONNECT
Jan  1 01:12:26 lba09 user.debug kernel: usb 1-2: rpm_resume flags 0x0
Jan  1 01:12:26 lba09 user.debug kernel: usb 1-2: rpm_resume returns -11
Jan  1 01:12:26 lba09 user.debug kernel: usb 1-2: default language 0x0409
Jan  1 01:12:26 lba09 user.debug kernel: usb 1-2: udev 2, busnum 1, 
minor = 1
Jan  1 01:12:26 lba09 user.info kernel: usb 1-2: New USB device found, 
idVendor=0cf3, idProduct=9271
Jan  1 01:12:26 lba09 user.info kernel: usb 1-2: New USB device strings: 
Mfr=16, Product=32, SerialNumber=48
Jan  1 01:12:26 lba09 user.info kernel: usb 1-2: Product: USB2.0 WLAN
Jan  1 01:12:26 lba09 user.info kernel: usb 1-2: Manufacturer: ATHEROS
Jan  1 01:12:26 lba09 user.info kernel: usb 1-2: SerialNumber: 12345
Jan  1 01:12:26 lba09 user.debug kernel: device: '1-2': device_add
Jan  1 01:12:26 lba09 user.debug kernel: bus: 'usb': add device 1-2
Jan  1 01:12:38 lba09 user.debug kernel: bus: 'usb': add driver 
ath9k_hif_usb
Jan  1 01:12:38 lba09 user.debug kernel: bus: 'usb': 
driver_probe_device: matched device 1-2:1.0 with driver ath9k_hif_usb
Jan  1 01:12:38 lba09 user.debug kernel: bus: 'usb': really_probe: 
probing driver ath9k_hif_usb with device 1-2:1.0
Jan  1 01:12:38 lba09 user.debug kernel: ath9k_hif_usb 1-2:1.0: 
usb_probe_interface
Jan  1 01:12:38 lba09 user.debug kernel: ath9k_hif_usb 1-2:1.0: 
usb_probe_interface - got id
Jan  1 01:12:38 lba09 user.debug kernel: usb 1-2: rpm_resume flags 0x4
Jan  1 01:12:38 lba09 user.debug kernel: usb 1-2: rpm_resume returns 1
Jan  1 01:12:38 lba09 user.debug kernel: usb 1-2: firmware: requesting 
ar9271.fw
Jan  1 01:12:38 lba09 user.debug kernel: device: '1-2': device_add
Jan  1 01:12:38 lba09 user.debug kernel: PM: Adding info for No Bus:1-2
Jan  1 01:13:39 lba09 user.debug kernel: device: '1-2': device_unregister
Jan  1 01:13:39 lba09 user.debug kernel: PM: Removing info for No Bus:1-2
Jan  1 01:13:39 lba09 user.err kernel: usb 1-2: ath9k_htc: Firmware - 
ar9271.fw not found
Jan  1 01:13:39 lba09 user.warn kernel: ath9k_hif_usb: probe of 1-2:1.0 
failed with error -22
Jan  1 01:13:39 lba09 user.info kernel: usbcore: registered new 
interface driver ath9k_hif_usb

