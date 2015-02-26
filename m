Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.byterg.ru ([217.12.248.131]:50563 "EHLO mail.byterg.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbbBZLZy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 06:25:54 -0500
Received: from [192.168.10.51]
	 by mail.byterg.ru with esmtp  (envelope-from <brilliantov@byterg.ru>)
	 id 1YQvIZ-0005cq-0m
	for linux-wireless@vger.kernel.org; Thu, 26 Feb 2015 14:04:03 +0400
Message-ID: <54EEFD4D.3060009@byterg.ru> (sfid-20150226_122558_059872_73E90B5D)
Date: Thu, 26 Feb 2015 14:02:37 +0300
From: Brilliantov Kirill Vladimirovich <brilliantov@byterg.ru>
Reply-To: brilliantov@byterg.ru
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: RTL8192cu: not work on linux-2.6.35
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!
I work with board on FreeScale iMX287 CPU and use linux-2.6.35.
For use WiFi USB Trendnet TEW-648UBM I download driver 
(rtl8188C_8192C_usb_linux_v4.0.2_9000.20130911.tar.gz) from Realtek site 
and build it.

~ # insmod /lib/modules/2.6.35.3\+/kernel/drivers/net/wireless/8192cu.ko
rtl8192cu driver version=v4.0.2_9000.20130911
build time: Feb 22 2015 14:44:01
usbcore: registered new interface driver rtl8192cu

usb 1-1: new high speed USB device using fsl-ehci and address 2
usb 1-1: device v20f4 p648b is not supported

usb_endpoint_descriptor(0):
bLength=7
bDescriptorType=5
bEndpointAddress=81
wMaxPacketSize=200
bInterval=0
RT_usb_endpoint_is_bulk_in = 1

usb_endpoint_descriptor(1):
bLength=7
bDescriptorType=5
bEndpointAddress=2
wMaxPacketSize=200
bInterval=0
RT_usb_endpoint_is_bulk_out = 2

usb_endpoint_descriptor(2):
bLength=7
bDescriptorType=5
bEndpointAddress=3
wMaxPacketSize=200
bInterval=0
RT_usb_endpoint_is_bulk_out = 3

usb_endpoint_descriptor(3):
bLength=7
bDescriptorType=5
bEndpointAddress=84
wMaxPacketSize=40
bInterval=1
RT_usb_endpoint_is_int_in = 4, Interval = 1
nr_endpoint=4, in_num=2, out_num=2

USB_SPEED_HIGH
CHIP TYPE: RTL8188C_8192C
register rtw_netdev_ops to netdev_ops
Chip Version ID: VERSION_NORMAL_TSMC_CHIP_88C.
RF_Type is 3!!
EEPROM type is E-FUSE
====> ReadAdapterInfo8192C
Boot from EFUSE, Autoload OK !
EEPROMVID = 0x20f4
EEPROMPID = 0x648b
EEPROMCustomerID : 0x00
EEPROMSubCustomerID: 0x00
RT_CustomerID: 0x00
_ReadMACAddress MAC Address from EFUSE = d8:eb:97:1f:07:a2
EEPROMRegulatory = 0x0
_ReadBoardType(0)
BT Coexistance = disable
mlmepriv.ChannelPlan = 0x02
_ReadPSSetting...bHWPwrPindetect(0)-bHWPowerdown(0) ,bSupportRemoteWakeup(0)
### PS params=>  power_mgnt(1),usbss_enable(0) ###
### AntDivCfg(0)
readAdapterInfo_8192CU(): REPLACEMENT = 1
<==== ReadAdapterInfo8192C in 340 ms
rtw_macaddr_cfg MAC Address  = d8:eb:97:1f:07:a2
bDriverStopped:1, bSurpriseRemoved:0, bup:0, hw_init_completed:0
_rtw_drv_register_netdev, MAC Address (if1) = d8:eb:97:1f:07:a2

~ # ip link show wlan0
4: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop qlen 1000
     link/ether d8:eb:97:1f:07:a2 brd ff:ff:ff:ff:ff:ff

~ # ifconfig wlan0 up
+871x_drv - drv_open, bup=0
  ===> FirmwareDownload91C() fw:Rtl819XFwImageArray_TSMC
FirmwareDownload92C accquire FW from embedded image
fw_ver=v88, fw_subver=2, sig=0x88c0
fw download ok!
Set RF Chip ID to RF_6052 and RF type to 1T1R.
IQK:Start!!!
Path A IQK Success!!
Path A IQK Success!!
IQK: final_candidate is 0
IQK: RegE94=105 RegE9C=12 RegEA4=fd RegEAC=1 RegEB4=0 RegEBC=0 RegEC4=0 
RegECC=0
  Path A IQ Calibration Success !
pdmpriv->TxPowerTrackControl = 1
rtl8192cu_hal_init in 820ms
MAC Address = d8:eb:97:1f:07:a2
-871x_drv - drv_open, bup=1
~ # ###=> usb_read_port_complete => urb status(-71)
###=> usb_read_port_complete => urb status(-71)
==>rtw_ps_processor .fw_state(0)
==>ips_enter cnts:1
===> rtw_ips_pwr_down...................
====> rtw_ips_dev_unload...
usb_read_port_cancel
usb_read_port_complete()-1284: RX Warning! bDriverStopped(0) OR 
bSurpriseRemove)
usb_read_port_complete()-1284: RX Warning! bDriverStopped(0) OR 
bSurpriseRemove)
usb_read_port_complete()-1284: RX Warning! bDriverStopped(0) OR 
bSurpriseRemove)
usb_read_port_complete()-1284: RX Warning! bDriverStopped(0) OR 
bSurpriseRemove)
usb_write_port_cancel
==> rtl8192cu_hal_deinit
bkeepfwalive(0)
card disble without HWSM...........
reg 0x600, usb write 1 fail, status:-110 value=0x40, vendorreq_times:1
reg 0x600, usb write 1 fail, status:-110 value=0x40, vendorreq_times:2
reg 0x600, usb write 1 fail, status:-110 value=0x40, vendorreq_times:3
reg 0x600, usb write 1 fail, status:-110 value=0x40, vendorreq_times:4
reg 0x600, usb write 1 fail, status:-110 value=0x40, vendorreq_times:5
[dvobj:c7ca9000][ERROR] continual_urb_error:5 > 4
<=== rtw_ips_pwr_down..................... in 2600ms
rtw_cmd_thread: DriverStopped(0) SurpriseRemoved(1) break at line 482

Unfortunately wireless-tools can't work with interface wlan0:
~ # iwconfig --version
iwconfig  Wireless-Tools version 29
           Compatible with Wireless Extension v11 to v22.

Kernel    Currently compiled with Wireless Extension v22.
~ # iwconfig wlan0
wlan0     no wireless extensions.
~ # iwlist wlan0 scan
wlan0     Interface doesn't support scanning.

Yes, this chip supported in latest linux, unfortunately now I can't run 
new linux on board.

Can you help run rtl8192cu on linux-2.6.35?
Thank you and excuse me for my bad english.

-- 
Best regards,
Brilliantov Kirill Vladimirovich

