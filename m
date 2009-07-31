Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:40607 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZGaNLg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 09:11:36 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MWrtV-0001l6-Az
	for linux-wireless@vger.kernel.org; Fri, 31 Jul 2009 13:11:33 +0000
Received: from dslb-084-058-206-191.pools.arcor-ip.net ([84.58.206.191])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 13:11:33 +0000
Received: from acid-burn by dslb-084-058-206-191.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 13:11:33 +0000
To: linux-wireless@vger.kernel.org
From: Mladen Horvat <acid-burn@opendreambox.org>
Subject: zd1211rw with MIPS architecture: mysterious behavior with zd1211b and AL2230/AL2230S RF Chip
Date: Fri, 31 Jul 2009 13:11:21 +0000 (UTC)
Message-ID: <loom.20090731T125828-710@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello again,

after some search i found another zd1211b usb stick this time with an AL2230
chipset and not an AL2230S as the ones i tested before.

whats really funny.. the stb boots with kernel 2.6.30 and with iwconfig i see
the wlan0 and wmaster0 interfaces.

kerneloutput till there:

[    0.944000] ohci_hcd 0000:00:14.2: OHCI 1.0, NO legacy support registers
[    0.944000] ohci_hcd 0000:00:14.2: control 0x083 HCFS=operational CBSR=3
[    0.944000] ohci_hcd 0000:00:14.2: cmdstatus 0x00000 SOC=0
[    0.944000] ohci_hcd 0000:00:14.2: intrstatus 0x00000044 RHSC SF
[    0.944000] ohci_hcd 0000:00:14.2: intrenable 0x8000000a MIE RD WDH
[    0.944000] ohci_hcd 0000:00:14.2: hcca frame #0003
[    0.944000] ohci_hcd 0000:00:14.2: roothub.a 01000202 POTPGT=1 NPS NDP=2(2)
[    0.944000] ohci_hcd 0000:00:14.2: roothub.b 00000000 PPCM=0000 DR=0000
[    0.944000] ohci_hcd 0000:00:14.2: roothub.status 00008000 DRWE
[    0.944000] ohci_hcd 0000:00:14.2: roothub.portstatus [0] 0x00010301 CSC 
LSDA PPS CCS
[    0.944000] ohci_hcd 0000:00:14.2: roothub.portstatus [1] 0x00000100 PPS
[    0.944000] usb usb1: default language 0x0409
[    0.944000] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    0.951000] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.958000] usb usb1: Product: OHCI Host Controller
[    0.963000] usb usb1: Manufacturer: Linux 2.6.30-dm7025 ohci_hcd
[    0.970000] usb usb1: SerialNumber: 0000:00:14.2
[    0.975000] usb usb1: uevent
[    0.975000] usb usb1: usb_probe_device
[    0.975000] usb usb1: configuration #1 chosen from 1 choice
[    0.981000] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    0.981000] usb 1-0:1.0: uevent
[    0.982000] hub 1-0:1.0: usb_probe_interface
[    0.982000] hub 1-0:1.0: usb_probe_interface - got id
[    0.982000] hub 1-0:1.0: USB hub found
[    0.986000] hub 1-0:1.0: 2 ports detected
[    0.990000] hub 1-0:1.0: standalone hub
[    0.990000] hub 1-0:1.0: no power switching (usb 1.0)
[    0.990000] hub 1-0:1.0: global over-current protection
[    0.990000] hub 1-0:1.0: power on to power good time: 2ms
[    0.991000] hub 1-0:1.0: local power source is good
[    0.991000] hub 1-0:1.0: no over-current condition exists
[    0.991000] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    0.992000] drivers/usb/core/inode.c: creating file '001'
[    0.994000] Initializing USB Mass Storage driver...
[    1.000000] usbcore: registered new interface driver usb-storage
[    1.006000] USB Mass Storage support registered.
[    1.012000] usbcore: registered new interface driver ums-alauda
[    1.019000] usbcore: registered new interface driver ums-cypress
[    1.026000] usbcore: registered new interface driver ums-datafab
[    1.033000] usbcore: registered new interface driver ums-freecom
[    1.040000] usbcore: registered new interface driver ums-isd200
[    1.046000] usbcore: registered new interface driver ums-jumpshot
[    1.053000] usbcore: registered new interface driver ums-karma
[    1.060000] usbcore: registered new interface driver ums-onetouch
[    1.067000] usbcore: registered new interface driver ums-sddr09
[    1.074000] usbcore: registered new interface driver ums-sddr55
[    1.081000] usbcore: registered new interface driver ums-usbat
[    1.087000] i2c /dev entries driver
[    1.091000] ohci_hcd 0000:00:14.2: GetStatus roothub.portstatus [0]
 = 0x00010301 CSC LSDA PPS CCS
[    1.091000] hub 1-0:1.0: port 1: status 0301 change 0001
[   12.281000] usb 1-1: default language 0x0409
[   12.288000] usb 1-1: New USB device found, idVendor=050d, idProduct=705c
[   12.294000] usb 1-1: New USB device strings: Mfr=16, Product=32, 
SerialNumber=0
[   12.302000] usb 1-1: Product: USB2.0 WLAN
[   12.306000] usb 1-1: Manufacturer: Belkin
[   12.310000] usb 1-1: uevent
[   14.465000] usb 1-1: usb_probe_device
[   14.465000] usb 1-1: configuration #1 chosen from 1 choice
[   14.506000] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[   14.506000] usb 1-1:1.0: uevent
[   14.550000] drivers/usb/core/inode.c: creating file '003'
[   14.554000] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[   16.347000] cfg80211: Calling CRDA to update world regulatory domain
[   16.963000] read DCA...<7>zd1211rw usb_init()
[   17.183000] zd1211rw 1-1:1.0: usb_probe_interface
[   17.183000] zd1211rw 1-1:1.0: usb_probe_interface - got id
[   17.183000] usb 1-1: print_id() 050d:705c v4810 full
[   17.196000] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[   17.204000] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[   17.252000] ohci_hcd 0000:00:14.2: GetStatus roothub.portstatus [0] =
0x00100103 PRSC PPS PES CCS
[   17.303000] usb 1-1: reset full speed USB device using ohci_hcd and
 address 3
[   17.377000] ohci_hcd 0000:00:14.2: GetStatus roothub.portstatus [0] =
0x00100103 PRSC PPS PES CCS
[   17.449000] zd1211rw 1-1:1.0: zd_chip_read_mac_addr_fw()
[   17.509000] ok
[   18.549000] phy0: Selected rate control algorithm 'minstrel'
[   18.550000] zd1211rw 1-1:1.0: probe() successful
[   18.550000] zd1211rw 1-1:1.0: phy0
[   18.554000] usbcore: registered new interface driver zd1211rw
[   18.560000] zd1211rw initialized
[   19.420000] usb usb1: uevent
[   19.420000] usb 1-0:1.0: uevent
[   19.421000] usb 1-1: uevent
[   19.421000] usb 1-1:1.0: uevent

iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:""
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
          Tx-Power=0 dBm
          Retry min limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


until this everything looks like its running .
after issuing an ifconfig wlan0 up :
ifconfig wlan0 up
ifconfig: SIOCSIFFLAGS: Connection timed out

and following kernel messages:
[  294.473000] zd1211rw 1-1:1.0: zd_usb_init_hw()
[  294.473000] usb 1-1: request_fw_file() fw name zd1211/zd1211b_ub
[  294.473000] usb 1-1: firmware: requesting zd1211/zd1211b_ub
[  294.536000] usb 1-1: upload_firmware() firmware device id 0x4810 is equal to
the actual device id
[  294.536000] usb 1-1: request_fw_file() fw name zd1211/zd1211b_uphr
[  294.536000] usb 1-1: firmware: requesting zd1211/zd1211b_uphr
[  294.609000] usb 1-1: upload_code() transfer size 4018
[  294.624000] usb 1-1: upload_code() firmware confirm return value 0x01
[  295.331000] zd1211rw 1-1:1.0: zd_usb_enable_int()
[  295.331000] zd1211rw 1-1:1.0: zd_usb_enable_int() submit urb 843e1180
[  295.331000] zd1211rw 1-1:1.0: zd_chip_init_hw()
[  296.333000] zd1211rw 1-1:1.0: zd_usb_ioread16v() read timed out
[  296.333000] zd1211rw 1-1:1.0: zd_ioread32v_locked() error:
zd_ioread16v_locked. Error number -145
[  296.333000] zd1211rw 1-1:1.0: dump_cr() error reading CR_AFTER_PNP. Error
number -145
[  296.333000] zd1211rw 1-1:1.0: zd_usb_disable_int() urb 843e1180 killed
[  296.334000] zd1211rw 1-1:1.0: zd_usb_init_hw() couldn't initialize mac. Error
number -145


the same stick runs flawless on a x86 pc with kernel 2.6.30.
as i said, also on the same machine with kernel 2.6.12 and the vendor driver
this stick works without problems.

perhaps someone has an idea ?

regards

Mladen







