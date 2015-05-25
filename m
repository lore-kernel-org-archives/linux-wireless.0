Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34120 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbbEYQKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 12:10:14 -0400
Received: by oifu123 with SMTP id u123so20627726oif.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 May 2015 09:10:13 -0700 (PDT)
Message-ID: <55634962.2010601@lwfinger.net> (sfid-20150525_181020_896494_6C188EB5)
Date: Mon, 25 May 2015 11:10:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix EFUSE_ANA8M map value
References: <20150521214421.15983b0a@milhouse> <555E5433.7000904@lwfinger.net> <20150522070035.711c6195@wiggum> <555F8FDC.3040609@lwfinger.net> <20150522231300.200a2e00@wiggum> <55600CEB.5080703@lwfinger.net> <20150523124038.17417873@wiggum> <20150523200130.0fe2930d@wiggum>
In-Reply-To: <20150523200130.0fe2930d@wiggum>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2015 01:01 PM, Michael Büsch wrote:
> On Sat, 23 May 2015 12:40:38 +0200
> Michael Büsch <m@bues.ch> wrote:
>
>> I will also try your driver from your github repo soon and see if that makes it work.
>
> Oh well. To put it mildly, this driver is awful.
> It compiles with frightening array overrun warnings in rtl8192c_rf6052.c, on load spews a ton of messages and then replies to a scan request with:
>
> root@milhouse:~# ip link set up dev wlan4
> root@milhouse:~# iwlist wlan4 scan
> wlan4     Interface doesn't support scanning.
>
> root@milhouse:~# iw dev wlan4 scan
> command failed: No such device (-19)
>
>
> Stand clear, here come the messages:
>
> [ 3973.868312] rtl8192cu driver version=v4.0.2_9000.20130911
> [ 3973.868453] usbcore: registered new interface driver rtl8192cu
> [ 4028.492113] usb 1-2: new high-speed USB device number 6 using ehci-pci
> [ 4028.625897] usb 1-2: New USB device found, idVendor=7392, idProduct=7811
> [ 4028.625912] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [ 4028.625921] usb 1-2: Product: 802.11n WLAN Adapter
> [ 4028.625930] usb 1-2: Manufacturer: Realtek
> [ 4028.625938] usb 1-2: SerialNumber: xxx
> [ 4028.626959]
>                 usb_endpoint_descriptor(0):
> [ 4028.626976] bLength=7
> [ 4028.626983] bDescriptorType=5
> [ 4028.626991] bEndpointAddress=81
> [ 4028.626998] wMaxPacketSize=200
> [ 4028.627004] bInterval=0
> [ 4028.627011] RT_usb_endpoint_is_bulk_in = 1
> [ 4028.627017]
>                 usb_endpoint_descriptor(1):
> [ 4028.627026] bLength=7
> [ 4028.627032] bDescriptorType=5
> [ 4028.627038] bEndpointAddress=2
> [ 4028.627044] wMaxPacketSize=200
> [ 4028.627050] bInterval=0
> [ 4028.627056] RT_usb_endpoint_is_bulk_out = 2
> [ 4028.627063]
>                 usb_endpoint_descriptor(2):
> [ 4028.627073] bLength=7
> [ 4028.627080] bDescriptorType=5
> [ 4028.627087] bEndpointAddress=3
> [ 4028.627095] wMaxPacketSize=200
> [ 4028.627102] bInterval=0
> [ 4028.627108] RT_usb_endpoint_is_bulk_out = 3
> [ 4028.627115]
>                 usb_endpoint_descriptor(3):
> [ 4028.627126] bLength=7
> [ 4028.627133] bDescriptorType=5
> [ 4028.627141] bEndpointAddress=84
> [ 4028.627147] wMaxPacketSize=40
> [ 4028.627154] bInterval=1
> [ 4028.627162] RT_usb_endpoint_is_int_in = 4, Interval = 1
> [ 4028.627171] nr_endpoint=4, in_num=2, out_num=2
>
> [ 4028.627182] USB_SPEED_HIGH
> [ 4028.627240] CHIP TYPE: RTL8188C_8192C
> [ 4028.627274] register rtw_netdev_ops to netdev_ops
> [ 4028.627415] Chip Version ID: VERSION_NORMAL_TSMC_CHIP_88C.
> [ 4028.627428] RF_Type is 3!!
> [ 4028.627768] EEPROM type is E-FUSE
> [ 4028.627780] ====> ReadAdapterInfo8192C
> [ 4028.627898] Boot from EFUSE, Autoload OK !
> [ 4028.778757] EEPROMVID = 0x7392
> [ 4028.778765] EEPROMPID = 0x7811
> [ 4028.778769] EEPROMCustomerID : 0x00
> [ 4028.778773] EEPROMSubCustomerID: 0x00
> [ 4028.778777] RT_CustomerID: 0x00
> [ 4028.778784] _ReadMACAddress MAC Address from EFUSE = xxx
> [ 4028.778790] EEPROMRegulatory = 0x0
> [ 4028.778794] _ReadBoardType(0)
> [ 4028.778799] BT Coexistance = disable
> [ 4028.778804] mlmepriv.ChannelPlan = 0x02
> [ 4028.778809] _ReadPSSetting...bHWPwrPindetect(0)-bHWPowerdown(0) ,bSupportRemoteWakeup(0)
> [ 4028.778813] ### PS params=>  power_mgnt(1),usbss_enable(0) ###
> [ 4028.778817] ### AntDivCfg(0)
> [ 4028.778821] readAdapterInfo_8192CU(): REPLACEMENT = 1
> [ 4028.778826] <==== ReadAdapterInfo8192C in 152 ms
> [ 4028.779451] rtw_macaddr_cfg MAC Address  = xxx
> [ 4028.779461] bDriverStopped:1, bSurpriseRemoved:0, bup:0, hw_init_completed:0
> [ 4028.780924] _rtw_drv_register_netdev, MAC Address (if1) = xxx
> [ 4029.844223] rtl8192cu 1-2:1.0 wlan4: renamed from wlan1
> [ 4029.872791] systemd-udevd[30617]: renamed network interface wlan1 to wlan4
> [ 4032.495346] +871x_drv - drv_open, bup=0
> [ 4032.499722]  ===> FirmwareDownload91C() fw:Rtl819XFwImageArray_TSMC
> [ 4032.499737] FirmwareDownload92C accquire FW from embedded image
> [ 4032.499746] fw_ver=v88, fw_subver=2, sig=0x88c0
> [ 4032.532832] fw download ok!
> [ 4032.532841] Set RF Chip ID to RF_6052 and RF type to 1T1R.
> [ 4032.906818] IQK:Start!!!
> [ 4032.918190] Path A IQK Success!!
> [ 4032.926443] Path A IQK Success!!
> [ 4032.931584] IQK: final_candidate is 0
> [ 4032.931595] IQK: RegE94=106 RegE9C=13 RegEA4=fd RegEAC=3fd RegEB4=0 RegEBC=0 RegEC4=0 RegECC=0
>                  Path A IQ Calibration Success !
> [ 4033.043931] pdmpriv->TxPowerTrackControl = 1
> [ 4033.048684] rtl8192cu_hal_init in 556ms
> [ 4033.061576] MAC Address = xxx
> [ 4033.061789] -871x_drv - drv_open, bup=1
> [ 4033.062150] IPv6: ADDRCONF(NETDEV_UP): wlan4: link is not ready
> [ 4035.068534] ==>rtw_ps_processor .fw_state(0)
> [ 4035.068546] ==>ips_enter cnts:1
> [ 4035.068552] ===> rtw_ips_pwr_down...................
> [ 4035.068771] ====> rtw_ips_dev_unload...
> [ 4035.092200] usb_read_port_cancel
> [ 4035.092508] usb_read_port_complete()-1284: RX Warning! bDriverStopped(0) OR bSurpriseRemoved(0) bReadPortCancel(1)
> [ 4035.092761] usb_read_port_complete()-1284: RX Warning! bDriverStopped(0) OR bSurpriseRemoved(0) bReadPortCancel(1)
> [ 4035.092998] usb_read_port_complete()-1284: RX Warning! bDriverStopped(0) OR bSurpriseRemoved(0) bReadPortCancel(1)
> [ 4035.093247] usb_read_port_complete()-1284: RX Warning! bDriverStopped(0) OR bSurpriseRemoved(0) bReadPortCancel(1)
> [ 4035.093263] usb_write_port_cancel
> [ 4035.093315] ==> rtl8192cu_hal_deinit
> [ 4035.093319] bkeepfwalive(0)
> [ 4035.093323] card disble without HWSM...........
> [ 4035.098401] <=== rtw_ips_pwr_down..................... in 28ms
>
>
>
> If you want to have this device, I'll ship it to you for free.

I know about the log spamming. All the drivers for Realtek USB devices are 
released with full debugging mode enabled. I did not have time to fix that 
before I posted the driver on GitHub.

Sure, send me the device. That will give me a chance to try it as well as the 
other devices I have.

Larry




