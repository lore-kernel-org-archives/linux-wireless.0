Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48158 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1AGKc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 05:32:26 -0500
Received: by qyj19 with SMTP id 19so313049qyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 02:32:24 -0800 (PST)
Received: by qwa26 with SMTP id 26so17646970qwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 02:32:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimYBb-hqWWtPpQVnVQ2ifemQbAvOBnKSUxM_jsJ@mail.gmail.com>
References: <AANLkTimekYjYh7uZ3enOQ+zX2_dpA25Zy0aATCDzw521@mail.gmail.com> <AANLkTimYBb-hqWWtPpQVnVQ2ifemQbAvOBnKSUxM_jsJ@mail.gmail.com>
From: Damian Minkov <damencho@sip-communicator.org>
Date: Fri, 7 Jan 2011 12:32:02 +0200
Message-ID: <AANLkTik8nfAFF=OhG1EqzJYkYMh+ds1igRgngLArVswC@mail.gmail.com>
Subject: Re: Question about ep-n8508
To: sedat.dilek@gmail.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Jan 7, 2011 at 11:11 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Fri, Jan 7, 2011 at 9:06 AM, Damian Minkov
> <damencho@sip-communicator.org> wrote:
>> Hi,
>>
>> I recently bought the device EDUP ep-n8508 but I have problems running
>> it under Ubuntu 10.10, kernel: 2.6.35-24-generic x86_64.
>> I tried with the drivers provided on the CD coming with the device
>> (rtl8192CU_linux_v2.0.939.20100726) have no problem compiling and
>> installing. But after loading the module no network device appears and
>> a lot of "usb write TimeOut!" in the messages.
>> Then I tried with latest driver edition from realtek website -
>> rtl8192CU_linux_v2.0.1212.20101208. Again with same result.
>> Here is all the output: http://pastebin.com/7xhkzYNC.
>> I saw there is a similar thread, with similar problems "Question about
>> Edimax 7811Un", but as I'm new to the list didn't manage to continue
>> that thread.
>>
>> Seems a problem with amd64 systems. Is there any workaround? Anything
>> I can further test to help figuring this out?
>>
>> Thanks in advance
>> damencho
>
> First of all, please do not refer to pastebin-URLs as they have a
> limited life-cycle.
> A full dmesg and an output of lspci is much more appreciated, so
> interested people can look at it.
>
> - Sedat -
>

sorry for the pastebin, here are lspci and dmesg prints:

# lspci
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory
Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile
GM965/GL960 Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile GM965/GL960
Integrated Graphics Controller (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #5 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio
Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 1 (rev 03)
00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 5 (rev 03)
00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 6 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface
Controller (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
IDE Controller (rev 03)
00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
SATA IDE Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
02:00.0 Network controller: Broadcom Corporation BCM4321 802.11a/b/g/n (rev 03)
03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8058
PCI-E Gigabit Ethernet Controller (rev 13)
04:03.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 61)

# dmesg
[27549.430107] usb 1-2: new high speed USB device using ehci_hcd and address 11
[27549.583701] register rtl8192_netdev_ops to netdev_ops
[27549.583718]
[27549.583720] 8712_usb_endpoint_descriptor(0):
[27549.583724] bLength=7
[27549.583728] bDescriptorType=5
[27549.583732] bEndpointAddress=81
[27549.583736] wMaxPacketSize=200
[27549.583740] bInterval=0
[27549.583744]
[27549.583745] 8712_usb_endpoint_descriptor(1):
[27549.583750] bLength=7
[27549.583753] bDescriptorType=5
[27549.583757] bEndpointAddress=2
[27549.583761] wMaxPacketSize=200
[27549.583765] bInterval=0
[27549.583768]
[27549.583770] 8712_usb_endpoint_descriptor(2):
[27549.583774] bLength=7
[27549.583778] bDescriptorType=5
[27549.583782] bEndpointAddress=3
[27549.583786] wMaxPacketSize=200
[27549.583789] bInterval=0
[27549.583793]
[27549.583795] 8712_usb_endpoint_descriptor(3):
[27549.583799] bLength=7
[27549.583802] bDescriptorType=5
[27549.583806] bEndpointAddress=84
[27549.583810] wMaxPacketSize=40
[27549.583814] bInterval=1
[27549.583819] nr_endpoint=4, in_num=2, out_num=2
[27549.583821]
[27549.583825] 8192cu: USB_SPEED_HIGH
[27549.584814] Chip Version ID: VERSION_NORMAL_TSMC_CHIP_88C.
[27549.585468] EEPROM type is E-FUSE
[27549.585473] ====> ReadAdapterInfo8192C
[27549.585573] Boot from EFUSE, Autoload Success !
[27549.592954] rtw_efuse_get_max_phy_size...eeprompriv.efuse_phy_max_size(504)
[27550.006456] EEPROMVID = 0x0bda
[27550.006463] EEPROMPID = 0x8176
[27550.006467] EEPROMCustomerID : 0x00
[27550.006471] EEPROMSubCustomerID: 0x00
[27550.006475] RT_CustomerID: 0x00
[27550.006481] RT_ChannelPlan: 0x02
[27550.006486] _ReadBoardType(0)
[27550.006489] ### AntDivCfg(0)
[27550.006494] BT Coexistance = disable
[27550.006500] _ReadHWPDSelection...bHWPwrPindetect(0) bSupportRemoteWakeup(0)
[27550.006505] <==== ReadAdapterInfo8192C
[27550.006512] MAC Address from efuse= 00:e0:4c:00:29:ba
[27550.044108] udev[23828]: renamed network interface wlan0 to wlan1
[27550.049479] +8192cu_drv - drv_open, bup=0
[27550.130596]  ===> FirmwareDownload91C() fw:Rtl819XFwImageArray_TSMC
[27550.130622] fw_ver=v60, fw_subver=0, sig=0x88c0
[27550.166083] fw download ok!
[27550.166089] Set RF Chip ID to RF_6052 and RF type to 1T1R.
[27550.166094] rf_chip=0x4, rf_type=0x3
[27550.174493] usb 1-2: USB disconnect, address 11
[27550.174704] +rtw_dev_remove
[27550.174717] reg 0x3, usb write TimeOut! status:-108 value=0x0
[27550.174723] usb_write8...error(-108)
[27550.174730] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174737] reg 0x4c8, usb write TimeOut! status:-19 value=0x0
[27550.174742] usb_write8...error(-19)
[27550.174748] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174755] reg 0xff, usb write TimeOut! status:-19 value=0x0
[27550.174760] usb_write8...error(-19)
[27550.174766] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174773] reg 0x4c9, usb write TimeOut! status:-19 value=0x0
[27550.174778] usb_write8...error(-19)
[27550.174784] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174791] reg 0x8, usb write TimeOut! status:-19 value=0x0
[27550.174796] usb_write8...error(-19)
[27550.174802] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174808] reg 0x4cc, usb write TimeOut! status:-19 value=0x0
[27550.174813] usb_write8...error(-19)
[27550.174819] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174825] reg 0xff, usb write TimeOut! status:-19 value=0x0
[27550.174830] usb_write8...error(-19)
[27550.174836] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174842] reg 0x4cd, usb write TimeOut! status:-19 value=0x0
[27550.174847] usb_write8...error(-19)
[27550.174853] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174860] reg 0xff, usb write TimeOut! status:-19 value=0x0
[27550.174865] usb_write8...error(-19)
[27550.174870] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174877] reg 0x4ce, usb write TimeOut! status:-19 value=0x0
[27550.174882] usb_write8...error(-19)
[27550.174887] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174894] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.174899] usb_write8...error(-19)
[27550.174905] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174912] reg 0x500, usb write TimeOut! status:-19 value=0x0
[27550.174916] usb_write8...error(-19)
[27550.174922] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174928] reg 0x26, usb write TimeOut! status:-19 value=0x0
[27550.174933] usb_write8...error(-19)
[27550.174939] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174946] reg 0x501, usb write TimeOut! status:-19 value=0x0
[27550.174951] usb_write8...error(-19)
[27550.174956] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174963] reg 0xa2, usb write TimeOut! status:-19 value=0x0
[27550.174968] usb_write8...error(-19)
[27550.174973] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174980] reg 0x502, usb write TimeOut! status:-19 value=0x0
[27550.174985] usb_write8...error(-19)
[27550.174991] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.174997] reg 0x2f, usb write TimeOut! status:-19 value=0x0
[27550.175002] usb_write8...error(-19)
[27550.175008] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.175014] reg 0x503, usb write TimeOut! status:-19 value=0x0
[27550.175019] usb_write8...error(-19)
[27550.175025] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.175032] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175036] usb_write8...error(-19)
[27550.175042] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.175053] reg 0x504, usb write TimeOut! status:-19 value=0x0
[27550.175058] usb_write8...error(-19)
[27550.175064] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.175071] reg 0x28, usb write TimeOut! status:-19 value=0x0
[27550.175075] usb_write8...error(-19)
[27550.175081] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.175088] reg 0x608, usb read TimeOut! status:-19 value=0x0
[27550.175093] usb_read32...error(-19)
[27550.175099] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.175105] reg 0x608, usb write TimeOut! status:-19 value=0x0
[27550.175113] reg 0x2, usb read TimeOut! status:-19 value=0x0
[27550.175118] usb_read16...error(-19)
[27550.175123] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.175130] reg 0x2, usb write TimeOut! status:-19 value=0x2003
[27550.175137] reg 0x28, usb write TimeOut! status:-19 value=0x83
[27550.175142] usb_write8...error(-19)
[27550.175148] reg 0xf0, usb read TimeOut! status:-19 value=0x83
[27550.175155] reg 0x29, usb write TimeOut! status:-19 value=0xdb
[27550.175159] usb_write8...error(-19)
[27550.175165] reg 0xf0, usb read TimeOut! status:-19 value=0xdb
[27550.175172] reg 0x1f, usb write TimeOut! status:-19 value=0x7
[27550.175177] usb_write8...error(-19)
[27550.175182] reg 0xf0, usb read TimeOut! status:-19 value=0x7
[27550.175189] reg 0x2, usb write TimeOut! status:-19 value=0x17
[27550.175194] usb_write8...error(-19)
[27550.175199] reg 0xf0, usb read TimeOut! status:-19 value=0x17
[27550.175206] reg 0x22, usb write TimeOut! status:-19 value=0xf
[27550.175211] usb_write8...error(-19)
[27550.175217] reg 0xf0, usb read TimeOut! status:-19 value=0xf
[27550.175223] reg 0x15, usb write TimeOut! status:-19 value=0xe9
[27550.175228] usb_write8...error(-19)
[27550.175234] reg 0xf0, usb read TimeOut! status:-19 value=0xe9
[27550.175240] reg 0x25, usb write TimeOut! status:-19 value=0x80
[27550.175245] usb_write8...error(-19)
[27550.175251] reg 0xf0, usb read TimeOut! status:-19 value=0x80
[27550.175259] reg 0x24, usb write TimeOut! status:-19 value=0x0
[27550.175267] reg 0x800d, usb write TimeOut! status:-19 value=0x0
[27550.175275] reg 0x28, usb write TimeOut! status:-19 value=0x0
[27550.175283] reg 0xdb83, usb write TimeOut! status:-19 value=0x0
[27550.175291] reg 0x800, usb write TimeOut! status:-19 value=0x0
[27550.175299] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175307] reg 0x804, usb write TimeOut! status:-19 value=0x0
[27550.175315] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.175323] reg 0x808, usb write TimeOut! status:-19 value=0x0
[27550.175331] reg 0xfc00, usb write TimeOut! status:-19 value=0x0
[27550.175339] reg 0x80c, usb write TimeOut! status:-19 value=0x0
[27550.175347] reg 0xa, usb write TimeOut! status:-19 value=0x0
[27550.175355] reg 0x810, usb write TimeOut! status:-19 value=0x0
[27550.175362] reg 0x5388, usb write TimeOut! status:-19 value=0x0
[27550.175370] reg 0x814, usb write TimeOut! status:-19 value=0x0
[27550.175378] reg 0x3d10, usb write TimeOut! status:-19 value=0x0
[27550.175386] reg 0x818, usb write TimeOut! status:-19 value=0x0
[27550.175394] reg 0x385, usb write TimeOut! status:-19 value=0x0
[27550.175402] reg 0x81c, usb write TimeOut! status:-19 value=0x0
[27550.175410] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175418] reg 0x820, usb write TimeOut! status:-19 value=0x0
[27550.175426] reg 0x100, usb write TimeOut! status:-19 value=0x0
[27550.175434] reg 0x824, usb write TimeOut! status:-19 value=0x0
[27550.175442] reg 0x4, usb write TimeOut! status:-19 value=0x0
[27550.175450] reg 0x828, usb write TimeOut! status:-19 value=0x0
[27550.175457] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175465] reg 0x82c, usb write TimeOut! status:-19 value=0x0
[27550.175474] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175482] reg 0x830, usb write TimeOut! status:-19 value=0x0
[27550.175490] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175497] reg 0x834, usb write TimeOut! status:-19 value=0x0
[27550.175505] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175513] reg 0x838, usb write TimeOut! status:-19 value=0x0
[27550.175521] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175529] reg 0x83c, usb write TimeOut! status:-19 value=0x0
[27550.175537] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175545] reg 0x840, usb write TimeOut! status:-19 value=0x0
[27550.175553] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175560] reg 0x844, usb write TimeOut! status:-19 value=0x0
[27550.175568] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175577] reg 0x848, usb write TimeOut! status:-19 value=0x0
[27550.175585] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175592] reg 0x84c, usb write TimeOut! status:-19 value=0x0
[27550.175600] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175608] reg 0x850, usb write TimeOut! status:-19 value=0x0
[27550.175616] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175624] reg 0x854, usb write TimeOut! status:-19 value=0x0
[27550.175632] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175640] reg 0x858, usb write TimeOut! status:-19 value=0x0
[27550.175648] reg 0x569a, usb write TimeOut! status:-19 value=0x0
[27550.175656] reg 0x85c, usb write TimeOut! status:-19 value=0x0
[27550.175664] reg 0x25a4, usb write TimeOut! status:-19 value=0x0
[27550.175671] reg 0x860, usb write TimeOut! status:-19 value=0x0
[27550.175679] reg 0x230, usb write TimeOut! status:-19 value=0x0
[27550.175687] reg 0x864, usb write TimeOut! status:-19 value=0x0
[27550.175695] reg 0x130, usb write TimeOut! status:-19 value=0x0
[27550.175703] reg 0x868, usb write TimeOut! status:-19 value=0x0
[27550.175711] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175719] reg 0x86c, usb write TimeOut! status:-19 value=0x0
[27550.175726] reg 0x3200, usb write TimeOut! status:-19 value=0x0
[27550.175735] reg 0x870, usb write TimeOut! status:-19 value=0x0
[27550.175742] reg 0x700, usb write TimeOut! status:-19 value=0x0
[27550.175750] reg 0x874, usb write TimeOut! status:-19 value=0x0
[27550.175758] reg 0x4000, usb write TimeOut! status:-19 value=0x0
[27550.175766] reg 0x878, usb write TimeOut! status:-19 value=0x0
[27550.175774] reg 0x808, usb write TimeOut! status:-19 value=0x0
[27550.175782] reg 0x87c, usb write TimeOut! status:-19 value=0x0
[27550.175790] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175798] reg 0x880, usb write TimeOut! status:-19 value=0x0
[27550.175806] reg 0x3070, usb write TimeOut! status:-19 value=0x0
[27550.175814] reg 0x884, usb write TimeOut! status:-19 value=0x0
[27550.175822] reg 0x4d5, usb write TimeOut! status:-19 value=0x0
[27550.175830] reg 0x888, usb write TimeOut! status:-19 value=0x0
[27550.175846] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175854] reg 0x88c, usb write TimeOut! status:-19 value=0x0
[27550.175862] reg 0xc0, usb write TimeOut! status:-19 value=0x0
[27550.175870] reg 0x890, usb write TimeOut! status:-19 value=0x0
[27550.175878] reg 0x800, usb write TimeOut! status:-19 value=0x0
[27550.175885] reg 0x894, usb write TimeOut! status:-19 value=0x0
[27550.175893] reg 0xfffe, usb write TimeOut! status:-19 value=0x0
[27550.175901] reg 0x898, usb write TimeOut! status:-19 value=0x0
[27550.175910] reg 0x2010, usb write TimeOut! status:-19 value=0x0
[27550.175917] reg 0x89c, usb write TimeOut! status:-19 value=0x0
[27550.175925] reg 0x6050, usb write TimeOut! status:-19 value=0x0
[27550.175933] reg 0x900, usb write TimeOut! status:-19 value=0x0
[27550.175941] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175949] reg 0x904, usb write TimeOut! status:-19 value=0x0
[27550.175957] reg 0x23, usb write TimeOut! status:-19 value=0x0
[27550.175965] reg 0x908, usb write TimeOut! status:-19 value=0x0
[27550.175973] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.175981] reg 0x90c, usb write TimeOut! status:-19 value=0x0
[27550.175989] reg 0x1111, usb write TimeOut! status:-19 value=0x0
[27550.175996] reg 0xa00, usb write TimeOut! status:-19 value=0x0
[27550.176004] reg 0x47c8, usb write TimeOut! status:-19 value=0x0
[27550.176012] reg 0xa04, usb write TimeOut! status:-19 value=0x0
[27550.176020] reg 0xc, usb write TimeOut! status:-19 value=0x0
[27550.176028] reg 0xa08, usb write TimeOut! status:-19 value=0x0
[27550.176036] reg 0x8300, usb write TimeOut! status:-19 value=0x0
[27550.176044] reg 0xa0c, usb write TimeOut! status:-19 value=0x0
[27550.176052] reg 0x120f, usb write TimeOut! status:-19 value=0x0
[27550.176059] reg 0xa10, usb write TimeOut! status:-19 value=0x0
[27550.176067] reg 0xbb78, usb write TimeOut! status:-19 value=0x0
[27550.176075] reg 0xa14, usb write TimeOut! status:-19 value=0x0
[27550.176083] reg 0x4028, usb write TimeOut! status:-19 value=0x0
[27550.176091] reg 0xa18, usb write TimeOut! status:-19 value=0x0
[27550.176099] reg 0x1117, usb write TimeOut! status:-19 value=0x0
[27550.176107] reg 0xa1c, usb write TimeOut! status:-19 value=0x0
[27550.176115] reg 0xf00, usb write TimeOut! status:-19 value=0x0
[27550.176122] reg 0xa20, usb write TimeOut! status:-19 value=0x0
[27550.176130] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.176147] reg 0xa24, usb write TimeOut! status:-19 value=0x0
[27550.176155] reg 0x1317, usb write TimeOut! status:-19 value=0x0
[27550.176163] reg 0xa28, usb write TimeOut! status:-19 value=0x0
[27550.176170] reg 0x204, usb write TimeOut! status:-19 value=0x0
[27550.176178] reg 0xa2c, usb write TimeOut! status:-19 value=0x0
[27550.176186] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.176194] reg 0xa70, usb write TimeOut! status:-19 value=0x0
[27550.176202] reg 0xbf00, usb write TimeOut! status:-19 value=0x0
[27550.176210] reg 0xa74, usb write TimeOut! status:-19 value=0x0
[27550.176218] reg 0x7, usb write TimeOut! status:-19 value=0x0
[27550.176225] reg 0xc00, usb write TimeOut! status:-19 value=0x0
[27550.176233] reg 0x1d40, usb write TimeOut! status:-19 value=0x0
[27550.176241] reg 0xc04, usb write TimeOut! status:-19 value=0x0
[27550.176249] reg 0x5611, usb write TimeOut! status:-19 value=0x0
[27550.176257] reg 0xc08, usb write TimeOut! status:-19 value=0x0
[27550.176265] reg 0xe4, usb write TimeOut! status:-19 value=0x0
[27550.176273] reg 0xc0c, usb write TimeOut! status:-19 value=0x0
[27550.176281] reg 0x6c6c, usb write TimeOut! status:-19 value=0x0
[27550.176289] reg 0xc10, usb write TimeOut! status:-19 value=0x0
[27550.176297] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.176304] reg 0xc14, usb write TimeOut! status:-19 value=0x0
[27550.176312] reg 0x100, usb write TimeOut! status:-19 value=0x0
[27550.176320] reg 0xc18, usb write TimeOut! status:-19 value=0x0
[27550.176328] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.176335] reg 0xc1c, usb write TimeOut! status:-19 value=0x0
[27550.176343] reg 0x100, usb write TimeOut! status:-19 value=0x0
[27550.176351] reg 0xc20, usb write TimeOut! status:-19 value=0x0
[27550.176359] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.176367] reg 0xc24, usb write TimeOut! status:-19 value=0x0
[27550.176374] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.176382] reg 0xc28, usb write TimeOut! status:-19 value=0x0
[27550.176390] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.176398] reg 0xc2c, usb write TimeOut! status:-19 value=0x0
[27550.176406] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.176414] reg 0xc30, usb write TimeOut! status:-19 value=0x0
[27550.176421] reg 0xac44, usb write TimeOut! status:-19 value=0x0
[27550.176430] reg 0xc34, usb write TimeOut! status:-19 value=0x0
[27550.176438] reg 0x52cf, usb write TimeOut! status:-19 value=0x0
[27550.176446] reg 0xc38, usb write TimeOut! status:-19 value=0x0
[27550.176454] reg 0x5994, usb write TimeOut! status:-19 value=0x0
[27550.176462] reg 0xc3c, usb write TimeOut! status:-19 value=0x0
[27550.176470] reg 0x971c, usb write TimeOut! status:-19 value=0x0
[27550.176477] reg 0xc40, usb write TimeOut! status:-19 value=0x0
[27550.176485] reg 0x403f, usb write TimeOut! status:-19 value=0x0
[27550.176493] reg 0xc44, usb write TimeOut! status:-19 value=0x0
[27550.176501] reg 0xb7, usb write TimeOut! status:-19 value=0x0
[27550.176509] reg 0xc48, usb write TimeOut! status:-19 value=0x0
[27550.176516] reg 0x107, usb write TimeOut! status:-19 value=0x0
[27550.176524] reg 0xc4c, usb write TimeOut! status:-19 value=0x0
[27550.176532] reg 0x37f, usb write TimeOut! status:-19 value=0x0
[27550.176540] reg 0xc50, usb write TimeOut! status:-19 value=0x0
[27550.176548] reg 0x341e, usb write TimeOut! status:-19 value=0x0
[27550.176556] reg 0xc54, usb write TimeOut! status:-19 value=0x0
[27550.176563] reg 0x94, usb write TimeOut! status:-19 value=0x0
[27550.176571] reg 0xc58, usb write TimeOut! status:-19 value=0x0
[27550.176579] reg 0x341e, usb write TimeOut! status:-19 value=0x0
[27550.176587] reg 0xc5c, usb write TimeOut! status:-19 value=0x0
[27550.176595] reg 0x94, usb write TimeOut! status:-19 value=0x0
[27550.176603] reg 0xc60, usb write TimeOut! status:-19 value=0x0
[27550.176610] reg 0x0, usb write TimeOut! status:-19 value=0x0
[27550.176618] reg 0xc64, usb write TimeOut! status:-19 value=0x0
[27550.176626] reg 0x848b, usb write TimeOut! status:-19 value=0x0
[27550.176634] reg 0xc68, usb write TimeOut! status:-19 value=0x0
[27550.176642] reg 0xbff, usb write TimeOut! status:-19 value=0x0
[27550.176649] reg 0xc6c, usb write TimeOut! status:-19 value=0x0
[27550.176657] reg 0x36, usb write TimeOut! status:-19 value=0x0
[27550.176665] reg 0xc70, usb write TimeOut! status:-19 value=0x0
[27550.176673] reg 0xd, usb write TimeOut! status:-19 value=0x0
[27550.176681] reg 0xc74, usb write TimeOut! status:-19 value=0x0
[27550.176689] reg 0x10db, usb write TimeOut! status:-19 value=0x0
[27550.176696] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176704] reg 0x1f, usb write TimeOut! status:-19 value=0x0
[27550.176712] reg 0xc7c, usb write TimeOut! status:-19 value=0x0
[27550.176720] reg 0x1612, usb write TimeOut! status:-19 value=0x0
[27550.176728] reg 0xc80, usb write TimeOut! status:-19 value=0x0
[27550.176736] reg 0x100, usb write TimeOut! status:-19 value=0x0
[27550.176743] reg 0xc84, usb write TimeOut! status:-19 value=0x0
[27550.176762] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176770] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176778] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176786] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176793] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176801] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176809] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176817] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176825] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176833] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176841] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176848] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176856] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176864] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176872] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176880] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176887] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176895] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176903] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176912] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176919] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176927] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176935] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176943] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176951] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176959] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176966] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176974] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176982] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.176990] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.176998] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177006] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177014] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177021] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177029] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177037] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177045] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177053] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177060] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177068] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177076] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177084] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177092] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177100] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177107] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177115] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177123] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177131] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177139] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177147] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177155] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177163] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177170] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177178] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177186] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177194] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177202] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177210] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177218] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177225] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177233] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177241] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177249] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177257] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177265] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177272] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177280] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177288] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177296] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177304] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177312] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177320] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177327] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177335] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177343] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177351] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177359] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177367] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177374] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177383] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177391] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177399] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177407] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177415] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177423] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177431] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177439] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177448] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177456] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177464] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177472] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177480] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177488] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177496] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177504] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177512] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177519] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177527] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177535] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177543] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177551] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177559] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177566] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177574] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177582] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177590] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177598] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177606] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177613] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177621] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177629] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177637] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177645] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177653] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177661] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177669] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177676] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177684] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177692] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177700] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177708] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177716] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177724] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177731] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177739] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177747] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177755] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177763] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177771] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177778] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177786] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177794] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177802] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177810] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177817] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177825] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177833] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177841] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177849] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177857] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177865] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177873] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177881] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177890] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177898] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177906] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177914] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177922] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177930] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177938] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177946] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177954] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177962] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177971] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177978] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.177986] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.177994] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.178002] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.178010] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[27550.178018] reg 0x1, usb write TimeOut! status:-19 value=0x0
[27550.178026] reg 0x824, usb read TimeOut! status:-19 value=0x0
[27550.178031] usb_read32...error(-19)
[27550.178036] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.178044] reg 0x870, usb read TimeOut! status:-19 value=0x0
[27550.178049] usb_read32...error(-19)
[27550.178054] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.178061] reg 0x860, usb read TimeOut! status:-19 value=0x0
[27550.178066] usb_read32...error(-19)
[27550.178071] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.178078] reg 0x860, usb write TimeOut! status:-19 value=0x100000
[27550.178086] reg 0x860, usb read TimeOut! status:-19 value=0x0
[27550.178091] usb_read32...error(-19)
[27550.178097] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.178104] reg 0x860, usb write TimeOut! status:-19 value=0x10
[27550.178111] reg 0x824, usb read TimeOut! status:-19 value=0x0
[27550.178116] usb_read32...error(-19)
[27550.178122] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.178128] reg 0x824, usb write TimeOut! status:-19 value=0x0
[27550.178136] reg 0x824, usb read TimeOut! status:-19 value=0x0
[27550.178141] usb_read32...error(-19)
[27550.178147] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.178154] reg 0x824, usb write TimeOut! status:-19 value=0x0
[27550.178163] reg 0x840, usb write TimeOut! status:-19 value=0x0
[27550.178171] reg 0x840, usb write TimeOut! status:-19 value=0x1900000
[27550.178179] reg 0x840, usb write TimeOut! status:-19 value=0x100000
[27550.178187] reg 0x840, usb write TimeOut! status:-19 value=0x400000
[27550.178195] reg 0x840, usb write TimeOut! status:-19 value=0x200000
[27550.178203] reg 0x840, usb write TimeOut! status:-19 value=0x0
[27550.178211] reg 0x840, usb write TimeOut! status:-19 value=0x300000
[27550.178219] reg 0x840, usb write TimeOut! status:-19 value=0x2300000
[27550.178228] reg 0x840, usb write TimeOut! status:-19 value=0x400000
[27550.178236] reg 0x840, usb write TimeOut! status:-19 value=0x2700000
[27550.178244] reg 0x840, usb write TimeOut! status:-19 value=0x900000
[27550.178252] reg 0x840, usb write TimeOut! status:-19 value=0xf00000
[27550.178260] reg 0x840, usb write TimeOut! status:-19 value=0xa00000
[27550.178268] reg 0x840, usb write TimeOut! status:-19 value=0x3100000
[27550.178277] reg 0x840, usb write TimeOut! status:-19 value=0xb00000
[27550.178285] reg 0x840, usb write TimeOut! status:-19 value=0x2700000
[27550.178293] reg 0x840, usb write TimeOut! status:-19 value=0xc00000
[27550.178301] reg 0x840, usb write TimeOut! status:-19 value=0x2e00000
[27550.178309] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[27550.178317] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[27550.178326] reg 0x840, usb write TimeOut! status:-19 value=0xe00000
[27550.178334] reg 0x840, usb write TimeOut! status:-19 value=0x2700000
[27550.178342] reg 0x840, usb write TimeOut! status:-19 value=0xf00000
[27550.178350] reg 0x840, usb write TimeOut! status:-19 value=0x1100000
[27550.178358] reg 0x840, usb write TimeOut! status:-19 value=0x1900000
[27550.178366] reg 0x840, usb write TimeOut! status:-19 value=0x0
[27550.178374] reg 0x840, usb write TimeOut! status:-19 value=0x1a00000
[27550.178382] reg 0x840, usb write TimeOut! status:-19 value=0x1500000
[27550.178391] reg 0x840, usb write TimeOut! status:-19 value=0x1b00000
[27550.178399] reg 0x840, usb write TimeOut! status:-19 value=0x0
[27550.178407] reg 0x840, usb write TimeOut! status:-19 value=0x1c00000
[27550.178415] reg 0x840, usb write TimeOut! status:-19 value=0x3800000
[27550.178423] reg 0x840, usb write TimeOut! status:-19 value=0x1d00000
[27550.178431] reg 0x840, usb write TimeOut! status:-19 value=0x1000000
[27550.178439] reg 0x840, usb write TimeOut! status:-19 value=0x1e00000
[27550.178448] reg 0x840, usb write TimeOut! status:-19 value=0x1f00000
[27550.178456] reg 0x840, usb write TimeOut! status:-19 value=0x1f00000
[27550.178464] reg 0x840, usb write TimeOut! status:-19 value=0x100000
[27550.178472] reg 0x840, usb write TimeOut! status:-19 value=0x2000000
[27550.178480] reg 0x840, usb write TimeOut! status:-19 value=0x1400000
[27550.178488] reg 0x840, usb write TimeOut! status:-19 value=0x2100000
[27550.178496] reg 0x840, usb write TimeOut! status:-19 value=0x0
[27550.178504] reg 0x840, usb write TimeOut! status:-19 value=0x2200000
[27550.178512] reg 0x840, usb write TimeOut! status:-19 value=0x0
[27550.178520] reg 0x840, usb write TimeOut! status:-19 value=0x2300000
[27550.178529] reg 0x840, usb write TimeOut! status:-19 value=0x1800000
[27550.178537] reg 0x840, usb write TimeOut! status:-19 value=0x2400000
[27550.178545] reg 0x840, usb write TimeOut! status:-19 value=0x2000000
[27550.178553] reg 0x840, usb write TimeOut! status:-19 value=0x2500000
[27550.178561] reg 0x840, usb write TimeOut! status:-19 value=0x300000
[27550.178569] reg 0x840, usb write TimeOut! status:-19 value=0x2600000
[27550.178577] reg 0x840, usb write TimeOut! status:-19 value=0x0
[27550.178585] reg 0x840, usb write TimeOut! status:-19 value=0x2700000
[27550.178594] reg 0x840, usb write TimeOut! status:-19 value=0x1900000
[27550.178602] reg 0x840, usb write TimeOut! status:-19 value=0x2800000
[27550.178610] reg 0x840, usb write TimeOut! status:-19 value=0x0
[27550.178618] reg 0x840, usb write TimeOut! status:-19 value=0x2900000
[27550.178626] reg 0x840, usb write TimeOut! status:-19 value=0x300000
[27550.178634] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[27550.178642] reg 0x840, usb write TimeOut! status:-19 value=0x100000
[27550.178651] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.178659] reg 0x840, usb write TimeOut! status:-19 value=0x3400000
[27550.178667] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[27550.178675] reg 0x840, usb write TimeOut! status:-19 value=0x0
[27550.178683] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.178691] reg 0x840, usb write TimeOut! status:-19 value=0x1400000
[27550.178699] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[27550.178707] reg 0x840, usb write TimeOut! status:-19 value=0x100000
[27550.178715] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.178724] reg 0x840, usb write TimeOut! status:-19 value=0x800000
[27550.178732] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.178740] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[27550.178748] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[27550.178756] reg 0x840, usb write TimeOut! status:-19 value=0xc00000
[27550.178765] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[27550.178773] reg 0x840, usb write TimeOut! status:-19 value=0x200000
[27550.178781] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.178789] reg 0x840, usb write TimeOut! status:-19 value=0x800000
[27550.178798] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.178806] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[27550.178814] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[27550.178822] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[27550.178830] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[27550.178839] reg 0x840, usb write TimeOut! status:-19 value=0x300000
[27550.178847] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.178855] reg 0x840, usb write TimeOut! status:-19 value=0x800000
[27550.178863] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.178872] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[27550.178880] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[27550.178888] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[27550.178900] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[27550.178908] reg 0x840, usb write TimeOut! status:-19 value=0x400000
[27550.178917] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.178925] reg 0x840, usb write TimeOut! status:-19 value=0x800000
[27550.178933] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.178941] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[27550.178949] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[27550.178958] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[27550.178966] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[27550.178974] reg 0x840, usb write TimeOut! status:-19 value=0x500000
[27550.178982] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.178990] reg 0x840, usb write TimeOut! status:-19 value=0x800000
[27550.178999] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.179007] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[27550.179015] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[27550.179023] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[27550.179032] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[27550.179040] reg 0x840, usb write TimeOut! status:-19 value=0x600000
[27550.179048] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.179056] reg 0x840, usb write TimeOut! status:-19 value=0x900000
[27550.179065] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.179073] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[27550.179081] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[27550.179089] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[27550.179098] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[27550.179106] reg 0x840, usb write TimeOut! status:-19 value=0x700000
[27550.179114] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.179122] reg 0x840, usb write TimeOut! status:-19 value=0x900000
[27550.179130] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.179139] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[27550.179147] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[27550.179155] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[27550.179163] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[27550.179171] reg 0x840, usb write TimeOut! status:-19 value=0x800000
[27550.179180] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.179188] reg 0x840, usb write TimeOut! status:-19 value=0xa00000
[27550.179196] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.179204] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[27550.179213] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[27550.179221] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[27550.179229] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[27550.179237] reg 0x840, usb write TimeOut! status:-19 value=0x900000
[27550.179246] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.179254] reg 0x840, usb write TimeOut! status:-19 value=0xa00000
[27550.179262] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.179270] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[27550.179279] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[27550.179287] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[27550.179295] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[27550.179303] reg 0x840, usb write TimeOut! status:-19 value=0xa00000
[27550.179311] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[27550.179319] reg 0x870, usb read TimeOut! status:-19 value=0x0
[27550.179324] usb_read32...error(-19)
[27550.179330] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.179337] reg 0x870, usb write TimeOut! status:-19 value=0x0
[27550.179344] reg 0x824, usb read TimeOut! status:-19 value=0x0
[27550.179348] usb_read32...error(-19)
[27550.179354] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.179361] reg 0x824, usb write TimeOut! status:-19 value=0x0
[27550.180339] reg 0x824, usb write TimeOut! status:-19 value=0x8c000000
[27550.182048] reg 0x824, usb write TimeOut! status:-19 value=0x80000000
[27550.183058] reg 0x820, usb read TimeOut! status:-19 value=0x0
[27550.183063] usb_read32...error(-19)
[27550.183069] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.183076] reg 0x8a0, usb read TimeOut! status:-19 value=0x0
[27550.183081] usb_read32...error(-19)
[27550.183087] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.183094] reg 0x824, usb read TimeOut! status:-19 value=0x0
[27550.183099] usb_read32...error(-19)
[27550.183104] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.183111] reg 0x82c, usb read TimeOut! status:-19 value=0x0
[27550.183116] usb_read32...error(-19)
[27550.183121] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.183128] reg 0x824, usb write TimeOut! status:-19 value=0x0
[27550.184136] reg 0x82c, usb write TimeOut! status:-19 value=0x8c000000
[27550.185143] reg 0x824, usb write TimeOut! status:-19 value=0x80000000
[27550.186150] reg 0x828, usb read TimeOut! status:-19 value=0x0
[27550.186155] usb_read32...error(-19)
[27550.186162] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.186169] reg 0x8a4, usb read TimeOut! status:-19 value=0x0
[27550.186175] usb_read32...error(-19)
[27550.186182] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.186189] reg 0x800, usb read TimeOut! status:-19 value=0x0
[27550.186195] usb_read32...error(-19)
[27550.186201] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.186209] reg 0x800, usb write TimeOut! status:-19 value=0x1000000
[27550.186217] reg 0x800, usb read TimeOut! status:-19 value=0x0
[27550.186222] usb_read32...error(-19)
[27550.186229] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.186237] reg 0x800, usb write TimeOut! status:-19 value=0x2000000
[27550.186245] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.186253] reg 0x670, usb write TimeOut! status:-19 value=0x80010000
[27550.186260] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.186268] reg 0x670, usb write TimeOut! status:-19 value=0x80010008
[27550.186276] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.186283] reg 0x670, usb write TimeOut! status:-19 value=0x80010010
[27550.186291] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.186299] reg 0x670, usb write TimeOut! status:-19 value=0x80010018
[27550.186307] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.186315] reg 0x670, usb write TimeOut! status:-19 value=0x80010020
[27550.186323] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.186330] reg 0x670, usb write TimeOut! status:-19 value=0x80010028
[27550.186338] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.186346] reg 0x670, usb write TimeOut! status:-19 value=0x80010030
[27550.186354] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.186361] reg 0x670, usb write TimeOut! status:-19 value=0x80010038
[27550.186369] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.186376] reg 0x670, usb write TimeOut! status:-19 value=0x80010040
[27550.186384] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.186392] reg 0x670, usb write TimeOut! status:-19 value=0x80010048
[27550.186399] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.186407] reg 0x670, usb write TimeOut! status:-19 value=0x80010050
[27550.186415] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.186422] reg 0x670, usb write TimeOut! status:-19 value=0x80010058
[27550.186430] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.186438] reg 0x670, usb write TimeOut! status:-19 value=0x80010060
[27550.186445] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.186453] reg 0x670, usb write TimeOut! status:-19 value=0x80010068
[27550.186460] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.186468] reg 0x670, usb write TimeOut! status:-19 value=0x80010070
[27550.186476] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.186483] reg 0x670, usb write TimeOut! status:-19 value=0x80010078
[27550.186491] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.186499] reg 0x670, usb write TimeOut! status:-19 value=0x80010080
[27550.186506] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.186514] reg 0x670, usb write TimeOut! status:-19 value=0x80010088
[27550.186522] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.186530] reg 0x670, usb write TimeOut! status:-19 value=0x80010090
[27550.186538] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.186545] reg 0x670, usb write TimeOut! status:-19 value=0x80010098
[27550.186553] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.186561] reg 0x670, usb write TimeOut! status:-19 value=0x800100a0
[27550.186568] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.186576] reg 0x670, usb write TimeOut! status:-19 value=0x800100a8
[27550.186584] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.186592] reg 0x670, usb write TimeOut! status:-19 value=0x800100b0
[27550.186600] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.186607] reg 0x670, usb write TimeOut! status:-19 value=0x800100b8
[27550.186615] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.186622] reg 0x670, usb write TimeOut! status:-19 value=0x800100c0
[27550.186630] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.186638] reg 0x670, usb write TimeOut! status:-19 value=0x800100c8
[27550.186645] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.186653] reg 0x670, usb write TimeOut! status:-19 value=0x800100d0
[27550.186660] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.186668] reg 0x670, usb write TimeOut! status:-19 value=0x800100d8
[27550.186676] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.186683] reg 0x670, usb write TimeOut! status:-19 value=0x800100e0
[27550.186691] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.186698] reg 0x670, usb write TimeOut! status:-19 value=0x800100e8
[27550.186706] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.186714] reg 0x670, usb write TimeOut! status:-19 value=0x800100f0
[27550.186721] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.186729] reg 0x670, usb write TimeOut! status:-19 value=0x800100f8
[27550.186737] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.186745] reg 0x670, usb write TimeOut! status:-19 value=0x80010000
[27550.186753] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186760] reg 0x670, usb write TimeOut! status:-19 value=0x80010001
[27550.186768] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186776] reg 0x670, usb write TimeOut! status:-19 value=0x80010002
[27550.186783] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186791] reg 0x670, usb write TimeOut! status:-19 value=0x80010003
[27550.186798] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186806] reg 0x670, usb write TimeOut! status:-19 value=0x80010004
[27550.186813] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186821] reg 0x670, usb write TimeOut! status:-19 value=0x80010005
[27550.186828] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186836] reg 0x670, usb write TimeOut! status:-19 value=0x80010006
[27550.186843] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186851] reg 0x670, usb write TimeOut! status:-19 value=0x80010007
[27550.186859] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.186866] reg 0x670, usb write TimeOut! status:-19 value=0x80010008
[27550.186874] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186881] reg 0x670, usb write TimeOut! status:-19 value=0x80010009
[27550.186889] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186896] reg 0x670, usb write TimeOut! status:-19 value=0x8001000a
[27550.186904] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186911] reg 0x670, usb write TimeOut! status:-19 value=0x8001000b
[27550.186919] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186927] reg 0x670, usb write TimeOut! status:-19 value=0x8001000c
[27550.186934] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186942] reg 0x670, usb write TimeOut! status:-19 value=0x8001000d
[27550.186949] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186957] reg 0x670, usb write TimeOut! status:-19 value=0x8001000e
[27550.186964] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.186972] reg 0x670, usb write TimeOut! status:-19 value=0x8001000f
[27550.186980] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.186988] reg 0x670, usb write TimeOut! status:-19 value=0x80010010
[27550.186995] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187003] reg 0x670, usb write TimeOut! status:-19 value=0x80010011
[27550.187010] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187018] reg 0x670, usb write TimeOut! status:-19 value=0x80010012
[27550.187026] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187034] reg 0x670, usb write TimeOut! status:-19 value=0x80010013
[27550.187042] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187049] reg 0x670, usb write TimeOut! status:-19 value=0x80010014
[27550.187057] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187064] reg 0x670, usb write TimeOut! status:-19 value=0x80010015
[27550.187072] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187079] reg 0x670, usb write TimeOut! status:-19 value=0x80010016
[27550.187087] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187095] reg 0x670, usb write TimeOut! status:-19 value=0x80010017
[27550.187103] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.187110] reg 0x670, usb write TimeOut! status:-19 value=0x80010018
[27550.187118] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187126] reg 0x670, usb write TimeOut! status:-19 value=0x80010019
[27550.187133] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187141] reg 0x670, usb write TimeOut! status:-19 value=0x8001001a
[27550.187148] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187156] reg 0x670, usb write TimeOut! status:-19 value=0x8001001b
[27550.187164] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187172] reg 0x670, usb write TimeOut! status:-19 value=0x8001001c
[27550.187179] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187187] reg 0x670, usb write TimeOut! status:-19 value=0x8001001d
[27550.187194] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187202] reg 0x670, usb write TimeOut! status:-19 value=0x8001001e
[27550.187209] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187217] reg 0x670, usb write TimeOut! status:-19 value=0x8001001f
[27550.187225] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.187232] reg 0x670, usb write TimeOut! status:-19 value=0x80010020
[27550.187240] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187247] reg 0x670, usb write TimeOut! status:-19 value=0x80010021
[27550.187254] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187262] reg 0x670, usb write TimeOut! status:-19 value=0x80010022
[27550.187270] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187278] reg 0x670, usb write TimeOut! status:-19 value=0x80010023
[27550.187285] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187293] reg 0x670, usb write TimeOut! status:-19 value=0x80010024
[27550.187300] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187308] reg 0x670, usb write TimeOut! status:-19 value=0x80010025
[27550.187316] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187324] reg 0x670, usb write TimeOut! status:-19 value=0x80010026
[27550.187331] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187339] reg 0x670, usb write TimeOut! status:-19 value=0x80010027
[27550.187347] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.187354] reg 0x670, usb write TimeOut! status:-19 value=0x80010028
[27550.187362] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187369] reg 0x670, usb write TimeOut! status:-19 value=0x80010029
[27550.187377] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187384] reg 0x670, usb write TimeOut! status:-19 value=0x8001002a
[27550.187392] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187399] reg 0x670, usb write TimeOut! status:-19 value=0x8001002b
[27550.187407] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187415] reg 0x670, usb write TimeOut! status:-19 value=0x8001002c
[27550.187422] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187430] reg 0x670, usb write TimeOut! status:-19 value=0x8001002d
[27550.187437] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187444] reg 0x670, usb write TimeOut! status:-19 value=0x8001002e
[27550.187452] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187460] reg 0x670, usb write TimeOut! status:-19 value=0x8001002f
[27550.187467] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.187475] reg 0x670, usb write TimeOut! status:-19 value=0x80010030
[27550.187482] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187490] reg 0x670, usb write TimeOut! status:-19 value=0x80010031
[27550.187498] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187505] reg 0x670, usb write TimeOut! status:-19 value=0x80010032
[27550.187513] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187521] reg 0x670, usb write TimeOut! status:-19 value=0x80010033
[27550.187528] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187536] reg 0x670, usb write TimeOut! status:-19 value=0x80010034
[27550.187543] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187551] reg 0x670, usb write TimeOut! status:-19 value=0x80010035
[27550.187558] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187566] reg 0x670, usb write TimeOut! status:-19 value=0x80010036
[27550.187573] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187581] reg 0x670, usb write TimeOut! status:-19 value=0x80010037
[27550.187589] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.187597] reg 0x670, usb write TimeOut! status:-19 value=0x80010038
[27550.187605] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187612] reg 0x670, usb write TimeOut! status:-19 value=0x80010039
[27550.187620] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187627] reg 0x670, usb write TimeOut! status:-19 value=0x8001003a
[27550.187635] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187643] reg 0x670, usb write TimeOut! status:-19 value=0x8001003b
[27550.187650] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187658] reg 0x670, usb write TimeOut! status:-19 value=0x8001003c
[27550.187665] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187673] reg 0x670, usb write TimeOut! status:-19 value=0x8001003d
[27550.187680] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187688] reg 0x670, usb write TimeOut! status:-19 value=0x8001003e
[27550.187696] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187704] reg 0x670, usb write TimeOut! status:-19 value=0x8001003f
[27550.187711] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.187719] reg 0x670, usb write TimeOut! status:-19 value=0x80010040
[27550.187727] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187735] reg 0x670, usb write TimeOut! status:-19 value=0x80010041
[27550.187742] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187750] reg 0x670, usb write TimeOut! status:-19 value=0x80010042
[27550.187757] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187765] reg 0x670, usb write TimeOut! status:-19 value=0x80010043
[27550.187773] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187780] reg 0x670, usb write TimeOut! status:-19 value=0x80010044
[27550.187788] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187796] reg 0x670, usb write TimeOut! status:-19 value=0x80010045
[27550.187803] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187811] reg 0x670, usb write TimeOut! status:-19 value=0x80010046
[27550.187818] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187826] reg 0x670, usb write TimeOut! status:-19 value=0x80010047
[27550.187834] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.187841] reg 0x670, usb write TimeOut! status:-19 value=0x80010048
[27550.187849] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187856] reg 0x670, usb write TimeOut! status:-19 value=0x80010049
[27550.187864] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187871] reg 0x670, usb write TimeOut! status:-19 value=0x8001004a
[27550.187879] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187887] reg 0x670, usb write TimeOut! status:-19 value=0x8001004b
[27550.187895] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187903] reg 0x670, usb write TimeOut! status:-19 value=0x8001004c
[27550.187910] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187918] reg 0x670, usb write TimeOut! status:-19 value=0x8001004d
[27550.187925] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187933] reg 0x670, usb write TimeOut! status:-19 value=0x8001004e
[27550.187940] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187948] reg 0x670, usb write TimeOut! status:-19 value=0x8001004f
[27550.187956] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.187963] reg 0x670, usb write TimeOut! status:-19 value=0x80010050
[27550.187971] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187978] reg 0x670, usb write TimeOut! status:-19 value=0x80010051
[27550.187986] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.187994] reg 0x670, usb write TimeOut! status:-19 value=0x80010052
[27550.188001] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188009] reg 0x670, usb write TimeOut! status:-19 value=0x80010053
[27550.188016] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188024] reg 0x670, usb write TimeOut! status:-19 value=0x80010054
[27550.188031] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188039] reg 0x670, usb write TimeOut! status:-19 value=0x80010055
[27550.188046] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188054] reg 0x670, usb write TimeOut! status:-19 value=0x80010056
[27550.188062] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188070] reg 0x670, usb write TimeOut! status:-19 value=0x80010057
[27550.188077] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.188085] reg 0x670, usb write TimeOut! status:-19 value=0x80010058
[27550.188092] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188099] reg 0x670, usb write TimeOut! status:-19 value=0x80010059
[27550.188106] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188113] reg 0x670, usb write TimeOut! status:-19 value=0x8001005a
[27550.188120] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188127] reg 0x670, usb write TimeOut! status:-19 value=0x8001005b
[27550.188134] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188141] reg 0x670, usb write TimeOut! status:-19 value=0x8001005c
[27550.188148] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188155] reg 0x670, usb write TimeOut! status:-19 value=0x8001005d
[27550.188162] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188168] reg 0x670, usb write TimeOut! status:-19 value=0x8001005e
[27550.188176] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188183] reg 0x670, usb write TimeOut! status:-19 value=0x8001005f
[27550.188190] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.188196] reg 0x670, usb write TimeOut! status:-19 value=0x80010060
[27550.188203] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188210] reg 0x670, usb write TimeOut! status:-19 value=0x80010061
[27550.188217] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188224] reg 0x670, usb write TimeOut! status:-19 value=0x80010062
[27550.188231] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188238] reg 0x670, usb write TimeOut! status:-19 value=0x80010063
[27550.188245] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188252] reg 0x670, usb write TimeOut! status:-19 value=0x80010064
[27550.188259] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188265] reg 0x670, usb write TimeOut! status:-19 value=0x80010065
[27550.188272] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188279] reg 0x670, usb write TimeOut! status:-19 value=0x80010066
[27550.188286] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188293] reg 0x670, usb write TimeOut! status:-19 value=0x80010067
[27550.188301] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.188308] reg 0x670, usb write TimeOut! status:-19 value=0x80010068
[27550.188315] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188322] reg 0x670, usb write TimeOut! status:-19 value=0x80010069
[27550.188329] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188336] reg 0x670, usb write TimeOut! status:-19 value=0x8001006a
[27550.188342] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188350] reg 0x670, usb write TimeOut! status:-19 value=0x8001006b
[27550.188356] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188363] reg 0x670, usb write TimeOut! status:-19 value=0x8001006c
[27550.188370] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188377] reg 0x670, usb write TimeOut! status:-19 value=0x8001006d
[27550.188384] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188391] reg 0x670, usb write TimeOut! status:-19 value=0x8001006e
[27550.188398] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188405] reg 0x670, usb write TimeOut! status:-19 value=0x8001006f
[27550.188412] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.188419] reg 0x670, usb write TimeOut! status:-19 value=0x80010070
[27550.188426] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188433] reg 0x670, usb write TimeOut! status:-19 value=0x80010071
[27550.188440] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188447] reg 0x670, usb write TimeOut! status:-19 value=0x80010072
[27550.188454] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188461] reg 0x670, usb write TimeOut! status:-19 value=0x80010073
[27550.188467] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188474] reg 0x670, usb write TimeOut! status:-19 value=0x80010074
[27550.188481] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188488] reg 0x670, usb write TimeOut! status:-19 value=0x80010075
[27550.188495] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188502] reg 0x670, usb write TimeOut! status:-19 value=0x80010076
[27550.188509] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188516] reg 0x670, usb write TimeOut! status:-19 value=0x80010077
[27550.188523] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.188530] reg 0x670, usb write TimeOut! status:-19 value=0x80010078
[27550.188537] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188544] reg 0x670, usb write TimeOut! status:-19 value=0x80010079
[27550.188551] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188558] reg 0x670, usb write TimeOut! status:-19 value=0x8001007a
[27550.188565] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188572] reg 0x670, usb write TimeOut! status:-19 value=0x8001007b
[27550.188579] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188586] reg 0x670, usb write TimeOut! status:-19 value=0x8001007c
[27550.188593] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188600] reg 0x670, usb write TimeOut! status:-19 value=0x8001007d
[27550.188607] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188614] reg 0x670, usb write TimeOut! status:-19 value=0x8001007e
[27550.188620] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188627] reg 0x670, usb write TimeOut! status:-19 value=0x8001007f
[27550.188635] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.188642] reg 0x670, usb write TimeOut! status:-19 value=0x80010080
[27550.188648] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188655] reg 0x670, usb write TimeOut! status:-19 value=0x80010081
[27550.188662] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188669] reg 0x670, usb write TimeOut! status:-19 value=0x80010082
[27550.188676] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188683] reg 0x670, usb write TimeOut! status:-19 value=0x80010083
[27550.188690] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188697] reg 0x670, usb write TimeOut! status:-19 value=0x80010084
[27550.188704] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188711] reg 0x670, usb write TimeOut! status:-19 value=0x80010085
[27550.188718] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188725] reg 0x670, usb write TimeOut! status:-19 value=0x80010086
[27550.188732] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188739] reg 0x670, usb write TimeOut! status:-19 value=0x80010087
[27550.188746] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.188753] reg 0x670, usb write TimeOut! status:-19 value=0x80010088
[27550.188760] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188767] reg 0x670, usb write TimeOut! status:-19 value=0x80010089
[27550.188774] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188781] reg 0x670, usb write TimeOut! status:-19 value=0x8001008a
[27550.188788] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188795] reg 0x670, usb write TimeOut! status:-19 value=0x8001008b
[27550.188801] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188808] reg 0x670, usb write TimeOut! status:-19 value=0x8001008c
[27550.188815] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188823] reg 0x670, usb write TimeOut! status:-19 value=0x8001008d
[27550.188829] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188836] reg 0x670, usb write TimeOut! status:-19 value=0x8001008e
[27550.188843] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188850] reg 0x670, usb write TimeOut! status:-19 value=0x8001008f
[27550.188858] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.188865] reg 0x670, usb write TimeOut! status:-19 value=0x80010090
[27550.188871] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188878] reg 0x670, usb write TimeOut! status:-19 value=0x80010091
[27550.188885] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188892] reg 0x670, usb write TimeOut! status:-19 value=0x80010092
[27550.188899] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188906] reg 0x670, usb write TimeOut! status:-19 value=0x80010093
[27550.188913] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188920] reg 0x670, usb write TimeOut! status:-19 value=0x80010094
[27550.188927] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188934] reg 0x670, usb write TimeOut! status:-19 value=0x80010095
[27550.188941] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188948] reg 0x670, usb write TimeOut! status:-19 value=0x80010096
[27550.188954] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188961] reg 0x670, usb write TimeOut! status:-19 value=0x80010097
[27550.188969] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.188976] reg 0x670, usb write TimeOut! status:-19 value=0x80010098
[27550.188982] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.188989] reg 0x670, usb write TimeOut! status:-19 value=0x80010099
[27550.188996] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189003] reg 0x670, usb write TimeOut! status:-19 value=0x8001009a
[27550.189010] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189017] reg 0x670, usb write TimeOut! status:-19 value=0x8001009b
[27550.189024] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189031] reg 0x670, usb write TimeOut! status:-19 value=0x8001009c
[27550.189037] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189044] reg 0x670, usb write TimeOut! status:-19 value=0x8001009d
[27550.189051] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189058] reg 0x670, usb write TimeOut! status:-19 value=0x8001009e
[27550.189065] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189072] reg 0x670, usb write TimeOut! status:-19 value=0x8001009f
[27550.189080] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.189087] reg 0x670, usb write TimeOut! status:-19 value=0x800100a0
[27550.189093] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189100] reg 0x670, usb write TimeOut! status:-19 value=0x800100a1
[27550.189107] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189114] reg 0x670, usb write TimeOut! status:-19 value=0x800100a2
[27550.189121] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189128] reg 0x670, usb write TimeOut! status:-19 value=0x800100a3
[27550.189135] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189142] reg 0x670, usb write TimeOut! status:-19 value=0x800100a4
[27550.189149] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189156] reg 0x670, usb write TimeOut! status:-19 value=0x800100a5
[27550.189162] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189169] reg 0x670, usb write TimeOut! status:-19 value=0x800100a6
[27550.189176] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189183] reg 0x670, usb write TimeOut! status:-19 value=0x800100a7
[27550.189190] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.189197] reg 0x670, usb write TimeOut! status:-19 value=0x800100a8
[27550.189204] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189211] reg 0x670, usb write TimeOut! status:-19 value=0x800100a9
[27550.189218] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189225] reg 0x670, usb write TimeOut! status:-19 value=0x800100aa
[27550.189232] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189239] reg 0x670, usb write TimeOut! status:-19 value=0x800100ab
[27550.189246] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189253] reg 0x670, usb write TimeOut! status:-19 value=0x800100ac
[27550.189260] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189267] reg 0x670, usb write TimeOut! status:-19 value=0x800100ad
[27550.189274] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189281] reg 0x670, usb write TimeOut! status:-19 value=0x800100ae
[27550.189288] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189295] reg 0x670, usb write TimeOut! status:-19 value=0x800100af
[27550.189302] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.189309] reg 0x670, usb write TimeOut! status:-19 value=0x800100b0
[27550.189315] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189323] reg 0x670, usb write TimeOut! status:-19 value=0x800100b1
[27550.189329] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189336] reg 0x670, usb write TimeOut! status:-19 value=0x800100b2
[27550.189343] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189350] reg 0x670, usb write TimeOut! status:-19 value=0x800100b3
[27550.189357] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189364] reg 0x670, usb write TimeOut! status:-19 value=0x800100b4
[27550.189371] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189378] reg 0x670, usb write TimeOut! status:-19 value=0x800100b5
[27550.189385] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189392] reg 0x670, usb write TimeOut! status:-19 value=0x800100b6
[27550.189398] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189405] reg 0x670, usb write TimeOut! status:-19 value=0x800100b7
[27550.189412] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.189420] reg 0x670, usb write TimeOut! status:-19 value=0x800100b8
[27550.189427] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189433] reg 0x670, usb write TimeOut! status:-19 value=0x800100b9
[27550.189440] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189447] reg 0x670, usb write TimeOut! status:-19 value=0x800100ba
[27550.189454] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189461] reg 0x670, usb write TimeOut! status:-19 value=0x800100bb
[27550.189468] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189475] reg 0x670, usb write TimeOut! status:-19 value=0x800100bc
[27550.189482] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189489] reg 0x670, usb write TimeOut! status:-19 value=0x800100bd
[27550.189496] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189503] reg 0x670, usb write TimeOut! status:-19 value=0x800100be
[27550.189510] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189517] reg 0x670, usb write TimeOut! status:-19 value=0x800100bf
[27550.189524] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.189531] reg 0x670, usb write TimeOut! status:-19 value=0x800100c0
[27550.189538] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189545] reg 0x670, usb write TimeOut! status:-19 value=0x800100c1
[27550.189552] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189559] reg 0x670, usb write TimeOut! status:-19 value=0x800100c2
[27550.189566] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189573] reg 0x670, usb write TimeOut! status:-19 value=0x800100c3
[27550.189579] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189586] reg 0x670, usb write TimeOut! status:-19 value=0x800100c4
[27550.189593] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189600] reg 0x670, usb write TimeOut! status:-19 value=0x800100c5
[27550.189607] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189614] reg 0x670, usb write TimeOut! status:-19 value=0x800100c6
[27550.189621] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189628] reg 0x670, usb write TimeOut! status:-19 value=0x800100c7
[27550.189635] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.189642] reg 0x670, usb write TimeOut! status:-19 value=0x800100c8
[27550.189649] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189656] reg 0x670, usb write TimeOut! status:-19 value=0x800100c9
[27550.189663] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189670] reg 0x670, usb write TimeOut! status:-19 value=0x800100ca
[27550.189677] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189684] reg 0x670, usb write TimeOut! status:-19 value=0x800100cb
[27550.189691] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189698] reg 0x670, usb write TimeOut! status:-19 value=0x800100cc
[27550.189705] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189712] reg 0x670, usb write TimeOut! status:-19 value=0x800100cd
[27550.189719] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189725] reg 0x670, usb write TimeOut! status:-19 value=0x800100ce
[27550.189733] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189739] reg 0x670, usb write TimeOut! status:-19 value=0x800100cf
[27550.189746] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.189753] reg 0x670, usb write TimeOut! status:-19 value=0x800100d0
[27550.189760] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189767] reg 0x670, usb write TimeOut! status:-19 value=0x800100d1
[27550.189774] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189781] reg 0x670, usb write TimeOut! status:-19 value=0x800100d2
[27550.189788] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189795] reg 0x670, usb write TimeOut! status:-19 value=0x800100d3
[27550.189802] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189809] reg 0x670, usb write TimeOut! status:-19 value=0x800100d4
[27550.189816] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189822] reg 0x670, usb write TimeOut! status:-19 value=0x800100d5
[27550.189829] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189836] reg 0x670, usb write TimeOut! status:-19 value=0x800100d6
[27550.189843] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189850] reg 0x670, usb write TimeOut! status:-19 value=0x800100d7
[27550.189857] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.189865] reg 0x670, usb write TimeOut! status:-19 value=0x800100d8
[27550.189872] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189878] reg 0x670, usb write TimeOut! status:-19 value=0x800100d9
[27550.189885] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189892] reg 0x670, usb write TimeOut! status:-19 value=0x800100da
[27550.189899] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189906] reg 0x670, usb write TimeOut! status:-19 value=0x800100db
[27550.189913] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189920] reg 0x670, usb write TimeOut! status:-19 value=0x800100dc
[27550.189927] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189933] reg 0x670, usb write TimeOut! status:-19 value=0x800100dd
[27550.189940] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189947] reg 0x670, usb write TimeOut! status:-19 value=0x800100de
[27550.189954] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189961] reg 0x670, usb write TimeOut! status:-19 value=0x800100df
[27550.189968] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[27550.189975] reg 0x670, usb write TimeOut! status:-19 value=0x800100e0
[27550.189982] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.189989] reg 0x670, usb write TimeOut! status:-19 value=0x800100e1
[27550.189997] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190004] reg 0x670, usb write TimeOut! status:-19 value=0x800100e2
[27550.190011] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190013] reg 0x670, usb write TimeOut! status:-19 value=0x800100e3
[27550.190013] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190013] reg 0x670, usb write TimeOut! status:-19 value=0x800100e4
[27550.190013] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190013] reg 0x670, usb write TimeOut! status:-19 value=0x800100e5
[27550.190013] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190013] reg 0x670, usb write TimeOut! status:-19 value=0x800100e6
[27550.190013] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190013] reg 0x670, usb write TimeOut! status:-19 value=0x800100e7
[27550.190052] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[27550.190059] reg 0x670, usb write TimeOut! status:-19 value=0x800100e8
[27550.190066] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190073] reg 0x670, usb write TimeOut! status:-19 value=0x800100e9
[27550.190080] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190087] reg 0x670, usb write TimeOut! status:-19 value=0x800100ea
[27550.190093] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190100] reg 0x670, usb write TimeOut! status:-19 value=0x800100eb
[27550.190107] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190114] reg 0x670, usb write TimeOut! status:-19 value=0x800100ec
[27550.190121] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190128] reg 0x670, usb write TimeOut! status:-19 value=0x800100ed
[27550.190135] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190142] reg 0x670, usb write TimeOut! status:-19 value=0x800100ee
[27550.190149] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190155] reg 0x670, usb write TimeOut! status:-19 value=0x800100ef
[27550.190163] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[27550.190170] reg 0x670, usb write TimeOut! status:-19 value=0x800100f0
[27550.190176] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190183] reg 0x670, usb write TimeOut! status:-19 value=0x800100f1
[27550.190190] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190197] reg 0x670, usb write TimeOut! status:-19 value=0x800100f2
[27550.190204] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190211] reg 0x670, usb write TimeOut! status:-19 value=0x800100f3
[27550.190222] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190224] reg 0x670, usb write TimeOut! status:-19 value=0x800100f4
[27550.190226] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190228] reg 0x670, usb write TimeOut! status:-19 value=0x800100f5
[27550.190231] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190233] reg 0x670, usb write TimeOut! status:-19 value=0x800100f6
[27550.190235] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190238] reg 0x670, usb write TimeOut! status:-19 value=0x800100f7
[27550.190240] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[27550.190242] reg 0x670, usb write TimeOut! status:-19 value=0x800100f8
[27550.190245] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190247] reg 0x670, usb write TimeOut! status:-19 value=0x800100f9
[27550.190249] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190252] reg 0x670, usb write TimeOut! status:-19 value=0x800100fa
[27550.190254] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190256] reg 0x670, usb write TimeOut! status:-19 value=0x800100fb
[27550.190259] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190261] reg 0x670, usb write TimeOut! status:-19 value=0x800100fc
[27550.190263] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190266] reg 0x670, usb write TimeOut! status:-19 value=0x800100fd
[27550.190268] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190270] reg 0x670, usb write TimeOut! status:-19 value=0x800100fe
[27550.190273] reg 0x674, usb write TimeOut! status:-19 value=0x0
[27550.190275] reg 0x670, usb write TimeOut! status:-19 value=0x800100ff
[27550.190278] reg 0x670, usb write TimeOut! status:-19 value=0xc0000000
[27550.190280] reg 0x423, usb write TimeOut! status:-19 value=0xff
[27550.190282] usb_write8...error(-19)
[27550.190283] reg 0xf0, usb read TimeOut! status:-19 value=0xff
[27550.190285] IQK:Start!!!
[27550.190287] reg 0x800, usb read TimeOut! status:-19 value=0x0
[27550.190289] usb_read32...error(-19)
[27550.190291] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190293] reg 0x85c, usb read TimeOut! status:-19 value=0x0
[27550.190295] usb_read32...error(-19)
[27550.190297] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190299] reg 0xe6c, usb read TimeOut! status:-19 value=0x0
[27550.190301] usb_read32...error(-19)
[27550.190303] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190305] reg 0xe70, usb read TimeOut! status:-19 value=0x0
[27550.190306] usb_read32...error(-19)
[27550.190308] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190310] reg 0xe74, usb read TimeOut! status:-19 value=0x0
[27550.190312] usb_read32...error(-19)
[27550.190314] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190316] reg 0xe78, usb read TimeOut! status:-19 value=0x0
[27550.190318] usb_read32...error(-19)
[27550.190320] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190322] reg 0xe7c, usb read TimeOut! status:-19 value=0x0
[27550.190323] usb_read32...error(-19)
[27550.190325] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190328] reg 0xe80, usb read TimeOut! status:-19 value=0x0
[27550.190329] usb_read32...error(-19)
[27550.190331] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190333] reg 0xe84, usb read TimeOut! status:-19 value=0x0
[27550.190335] usb_read32...error(-19)
[27550.190337] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190339] reg 0xe88, usb read TimeOut! status:-19 value=0x0
[27550.190340] usb_read32...error(-19)
[27550.190342] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190344] reg 0xe8c, usb read TimeOut! status:-19 value=0x0
[27550.190346] usb_read32...error(-19)
[27550.190348] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190350] reg 0xed0, usb read TimeOut! status:-19 value=0x0
[27550.190352] usb_read32...error(-19)
[27550.190354] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190356] reg 0xed4, usb read TimeOut! status:-19 value=0x0
[27550.190358] usb_read32...error(-19)
[27550.190360] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190362] reg 0xed8, usb read TimeOut! status:-19 value=0x0
[27550.190363] usb_read32...error(-19)
[27550.190365] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190367] reg 0xedc, usb read TimeOut! status:-19 value=0x0
[27550.190369] usb_read32...error(-19)
[27550.190371] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190373] reg 0xee0, usb read TimeOut! status:-19 value=0x0
[27550.190375] usb_read32...error(-19)
[27550.190376] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190379] reg 0xeec, usb read TimeOut! status:-19 value=0x0
[27550.190380] usb_read32...error(-19)
[27550.190382] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190384] reg 0x522, usb read TimeOut! status:-19 value=0x0
[27550.190386] reg 0x550, usb read TimeOut! status:-19 value=0x0
[27550.190389] reg 0x551, usb read TimeOut! status:-19 value=0x0
[27550.190391] reg 0x40, usb read TimeOut! status:-19 value=0x0
[27550.190392] usb_read32...error(-19)
[27550.190394] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190397] reg 0xc04, usb read TimeOut! status:-19 value=0x0
[27550.190398] usb_read32...error(-19)
[27550.190400] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190402] reg 0xc08, usb read TimeOut! status:-19 value=0x0
[27550.190404] usb_read32...error(-19)
[27550.190406] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190408] reg 0x874, usb read TimeOut! status:-19 value=0x0
[27550.190410] usb_read32...error(-19)
[27550.190412] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190414] reg 0xb68, usb read TimeOut! status:-19 value=0x0
[27550.190416] usb_read32...error(-19)
[27550.190418] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190420] reg 0xb6c, usb read TimeOut! status:-19 value=0x0
[27550.190422] usb_read32...error(-19)
[27550.190424] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190426] reg 0x870, usb read TimeOut! status:-19 value=0x0
[27550.190428] usb_read32...error(-19)
[27550.190430] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190432] reg 0x860, usb read TimeOut! status:-19 value=0x0
[27550.190434] usb_read32...error(-19)
[27550.190436] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190438] reg 0x864, usb read TimeOut! status:-19 value=0x0
[27550.190440] usb_read32...error(-19)
[27550.190442] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190444] reg 0x800, usb read TimeOut! status:-19 value=0x0
[27550.190446] usb_read32...error(-19)
[27550.190447] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190450] reg 0x85c, usb write TimeOut! status:-19 value=0xb1b25a0
[27550.190453] reg 0xe6c, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190455] reg 0xe70, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190457] reg 0xe74, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190460] reg 0xe78, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190462] reg 0xe7c, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190464] reg 0xe80, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190467] reg 0xe84, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190469] reg 0xe88, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190471] reg 0xe8c, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190474] reg 0xed0, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190476] reg 0xed4, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190478] reg 0xed8, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190481] reg 0xedc, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190483] reg 0xee0, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190485] reg 0xeec, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.190488] reg 0x820, usb read TimeOut! status:-19 value=0x0
[27550.190489] usb_read32...error(-19)
[27550.190491] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190494] reg 0x820, usb write TimeOut! status:-19 value=0x1000100
[27550.190496] reg 0x828, usb write TimeOut! status:-19 value=0x1000100
[27550.190498] reg 0x800, usb read TimeOut! status:-19 value=0x0
[27550.190500] usb_read32...error(-19)
[27550.190502] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190504] reg 0x800, usb write TimeOut! status:-19 value=0x0
[27550.190507] reg 0xc04, usb write TimeOut! status:-19 value=0x3a05600
[27550.190509] reg 0xc08, usb write TimeOut! status:-19 value=0x800e4
[27550.190511] reg 0x874, usb write TimeOut! status:-19 value=0x22204000
[27550.190513] reg 0x870, usb read TimeOut! status:-19 value=0x0
[27550.190515] usb_read32...error(-19)
[27550.190517] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190519] reg 0x870, usb write TimeOut! status:-19 value=0x400
[27550.190521] reg 0x870, usb read TimeOut! status:-19 value=0x0
[27550.190523] usb_read32...error(-19)
[27550.190525] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190527] reg 0x870, usb write TimeOut! status:-19 value=0x4000000
[27550.190530] reg 0x860, usb read TimeOut! status:-19 value=0x0
[27550.190531] usb_read32...error(-19)
[27550.190533] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190536] reg 0x860, usb write TimeOut! status:-19 value=0x0
[27550.190538] reg 0x864, usb read TimeOut! status:-19 value=0x0
[27550.190539] usb_read32...error(-19)
[27550.190541] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190544] reg 0x864, usb write TimeOut! status:-19 value=0x0
[27550.190546] reg 0x522, usb write TimeOut! status:-19 value=0x3f
[27550.190547] usb_write8...error(-19)
[27550.190549] reg 0xf0, usb read TimeOut! status:-19 value=0x3f
[27550.190552] reg 0x550, usb write TimeOut! status:-19 value=0x0
[27550.190553] usb_write8...error(-19)
[27550.190555] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190557] reg 0x551, usb write TimeOut! status:-19 value=0x0
[27550.190559] usb_write8...error(-19)
[27550.190561] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190563] reg 0x40, usb write TimeOut! status:-19 value=0x0
[27550.190565] usb_write8...error(-19)
[27550.190566] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.190569] reg 0xb68, usb write TimeOut! status:-19 value=0x80000
[27550.190571] reg 0xe28, usb write TimeOut! status:-19 value=0x80800000
[27550.190573] reg 0xe40, usb write TimeOut! status:-19 value=0x1007c00
[27550.190576] reg 0xe44, usb write TimeOut! status:-19 value=0x1004800
[27550.190578] reg 0xe30, usb write TimeOut! status:-19 value=0x10008c1f
[27550.190581] reg 0xe34, usb write TimeOut! status:-19 value=0x10008c1f
[27550.190583] reg 0xe38, usb write TimeOut! status:-19 value=0x82140102
[27550.190585] reg 0xe3c, usb write TimeOut! status:-19 value=0x28160502
[27550.190588] reg 0xe4c, usb write TimeOut! status:-19 value=0x1028d1
[27550.190590] reg 0xe48, usb write TimeOut! status:-19 value=0xf9000000
[27550.190592] reg 0xe48, usb write TimeOut! status:-19 value=0xf8000000
[27550.191594] reg 0xeac, usb read TimeOut! status:-19 value=0x0
[27550.191596] usb_read32...error(-19)
[27550.191598] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191601] reg 0xe94, usb read TimeOut! status:-19 value=0x0
[27550.191603] usb_read32...error(-19)
[27550.191605] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191607] reg 0xe9c, usb read TimeOut! status:-19 value=0x0
[27550.191609] usb_read32...error(-19)
[27550.191611] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191614] reg 0xea4, usb read TimeOut! status:-19 value=0x0
[27550.191616] usb_read32...error(-19)
[27550.191618] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191620] Path A IQK Success!!
[27550.191622] reg 0xe94, usb read TimeOut! status:-19 value=0x0
[27550.191624] usb_read32...error(-19)
[27550.191626] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191629] reg 0xe9c, usb read TimeOut! status:-19 value=0x0
[27550.191630] usb_read32...error(-19)
[27550.191633] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191635] reg 0xea4, usb read TimeOut! status:-19 value=0x0
[27550.191637] usb_read32...error(-19)
[27550.191639] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191641] reg 0xeac, usb read TimeOut! status:-19 value=0x0
[27550.191643] usb_read32...error(-19)
[27550.191645] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191648] reg 0xe28, usb write TimeOut! status:-19 value=0x0
[27550.191651] reg 0x85c, usb write TimeOut! status:-19 value=0xb1b25a0
[27550.191653] reg 0xe6c, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191656] reg 0xe70, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191659] reg 0xe74, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191661] reg 0xe78, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191664] reg 0xe7c, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191666] reg 0xe80, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191669] reg 0xe84, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191671] reg 0xe88, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191674] reg 0xe8c, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191677] reg 0xed0, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191679] reg 0xed4, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191682] reg 0xed8, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191684] reg 0xedc, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191687] reg 0xee0, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191689] reg 0xeec, usb write TimeOut! status:-19 value=0xbdb25a0
[27550.191692] reg 0x820, usb write TimeOut! status:-19 value=0x1000100
[27550.191695] reg 0x828, usb write TimeOut! status:-19 value=0x1000100
[27550.191697] reg 0x800, usb read TimeOut! status:-19 value=0x0
[27550.191699] usb_read32...error(-19)
[27550.191701] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191704] reg 0x800, usb write TimeOut! status:-19 value=0x0
[27550.191706] reg 0xc04, usb write TimeOut! status:-19 value=0x3a05600
[27550.191709] reg 0xc08, usb write TimeOut! status:-19 value=0x800e4
[27550.191711] reg 0x874, usb write TimeOut! status:-19 value=0x22204000
[27550.191714] reg 0x870, usb read TimeOut! status:-19 value=0x0
[27550.191716] usb_read32...error(-19)
[27550.191718] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191720] reg 0x870, usb write TimeOut! status:-19 value=0x400
[27550.191723] reg 0x870, usb read TimeOut! status:-19 value=0x0
[27550.191725] usb_read32...error(-19)
[27550.191727] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191730] reg 0x870, usb write TimeOut! status:-19 value=0x4000000
[27550.191732] reg 0x860, usb read TimeOut! status:-19 value=0x0
[27550.191734] usb_read32...error(-19)
[27550.191736] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191739] reg 0x860, usb write TimeOut! status:-19 value=0x0
[27550.191741] reg 0x864, usb read TimeOut! status:-19 value=0x0
[27550.191743] usb_read32...error(-19)
[27550.191745] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191747] reg 0x864, usb write TimeOut! status:-19 value=0x0
[27550.191750] reg 0x522, usb write TimeOut! status:-19 value=0x3f
[27550.191751] usb_write8...error(-19)
[27550.191753] reg 0xf0, usb read TimeOut! status:-19 value=0x3f
[27550.191755] reg 0x550, usb write TimeOut! status:-19 value=0x0
[27550.191757] usb_write8...error(-19)
[27550.191759] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191761] reg 0x551, usb write TimeOut! status:-19 value=0x0
[27550.191763] usb_write8...error(-19)
[27550.191764] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191767] reg 0x40, usb write TimeOut! status:-19 value=0x0
[27550.191768] usb_write8...error(-19)
[27550.191770] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.191773] reg 0xb68, usb write TimeOut! status:-19 value=0x80000
[27550.191775] reg 0xe28, usb write TimeOut! status:-19 value=0x80800000
[27550.191777] reg 0xe40, usb write TimeOut! status:-19 value=0x1007c00
[27550.191780] reg 0xe44, usb write TimeOut! status:-19 value=0x1004800
[27550.191782] reg 0xe30, usb write TimeOut! status:-19 value=0x10008c1f
[27550.191784] reg 0xe34, usb write TimeOut! status:-19 value=0x10008c1f
[27550.191787] reg 0xe38, usb write TimeOut! status:-19 value=0x82140102
[27550.191789] reg 0xe3c, usb write TimeOut! status:-19 value=0x28160502
[27550.191791] reg 0xe4c, usb write TimeOut! status:-19 value=0x1028d1
[27550.191794] reg 0xe48, usb write TimeOut! status:-19 value=0xf9000000
[27550.191796] reg 0xe48, usb write TimeOut! status:-19 value=0xf8000000
[27550.192798] reg 0xeac, usb read TimeOut! status:-19 value=0x0
[27550.192800] usb_read32...error(-19)
[27550.192802] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192804] reg 0xe94, usb read TimeOut! status:-19 value=0x0
[27550.192805] usb_read32...error(-19)
[27550.192807] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192809] reg 0xe9c, usb read TimeOut! status:-19 value=0x0
[27550.192811] usb_read32...error(-19)
[27550.192813] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192815] reg 0xea4, usb read TimeOut! status:-19 value=0x0
[27550.192817] usb_read32...error(-19)
[27550.192819] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192820] Path A IQK Success!!
[27550.192822] reg 0xe94, usb read TimeOut! status:-19 value=0x0
[27550.192824] usb_read32...error(-19)
[27550.192826] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192828] reg 0xe9c, usb read TimeOut! status:-19 value=0x0
[27550.192830] usb_read32...error(-19)
[27550.192832] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192834] reg 0xea4, usb read TimeOut! status:-19 value=0x0
[27550.192835] usb_read32...error(-19)
[27550.192837] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192839] reg 0xeac, usb read TimeOut! status:-19 value=0x0
[27550.192841] usb_read32...error(-19)
[27550.192843] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192845] reg 0xe28, usb write TimeOut! status:-19 value=0x0
[27550.192848] reg 0x820, usb write TimeOut! status:-19 value=0x1000000
[27550.192850] reg 0x828, usb write TimeOut! status:-19 value=0x1000000
[27550.192852] reg 0x85c, usb write TimeOut! status:-19 value=0x0
[27550.192854] reg 0xe6c, usb write TimeOut! status:-19 value=0x0
[27550.192857] reg 0xe70, usb write TimeOut! status:-19 value=0x0
[27550.192859] reg 0xe74, usb write TimeOut! status:-19 value=0x0
[27550.192861] reg 0xe78, usb write TimeOut! status:-19 value=0x0
[27550.192863] reg 0xe7c, usb write TimeOut! status:-19 value=0x0
[27550.192865] reg 0xe80, usb write TimeOut! status:-19 value=0x0
[27550.192868] reg 0xe84, usb write TimeOut! status:-19 value=0x0
[27550.192870] reg 0xe88, usb write TimeOut! status:-19 value=0x0
[27550.192872] reg 0xe8c, usb write TimeOut! status:-19 value=0x0
[27550.192874] reg 0xed0, usb write TimeOut! status:-19 value=0x0
[27550.192877] reg 0xed4, usb write TimeOut! status:-19 value=0x0
[27550.192879] reg 0xed8, usb write TimeOut! status:-19 value=0x0
[27550.192881] reg 0xedc, usb write TimeOut! status:-19 value=0x0
[27550.192883] reg 0xee0, usb write TimeOut! status:-19 value=0x0
[27550.192885] reg 0xeec, usb write TimeOut! status:-19 value=0x0
[27550.192888] reg 0x522, usb write TimeOut! status:-19 value=0x0
[27550.192889] usb_write8...error(-19)
[27550.192891] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192893] reg 0x550, usb write TimeOut! status:-19 value=0x0
[27550.192895] usb_write8...error(-19)
[27550.192897] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192899] reg 0x551, usb write TimeOut! status:-19 value=0x0
[27550.192901] usb_write8...error(-19)
[27550.192903] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192905] reg 0x40, usb write TimeOut! status:-19 value=0x0
[27550.192907] reg 0xc04, usb write TimeOut! status:-19 value=0x0
[27550.192909] reg 0xc08, usb write TimeOut! status:-19 value=0x0
[27550.192912] reg 0x874, usb write TimeOut! status:-19 value=0x0
[27550.192914] reg 0xb68, usb write TimeOut! status:-19 value=0x0
[27550.192916] reg 0xb6c, usb write TimeOut! status:-19 value=0x0
[27550.192918] reg 0x870, usb write TimeOut! status:-19 value=0x0
[27550.192921] reg 0x860, usb write TimeOut! status:-19 value=0x0
[27550.192923] reg 0x864, usb write TimeOut! status:-19 value=0x0
[27550.192925] reg 0x800, usb write TimeOut! status:-19 value=0x0
[27550.192927] reg 0x840, usb write TimeOut! status:-19 value=0x32ed3
[27550.192930] reg 0xe30, usb write TimeOut! status:-19 value=0x1008c00
[27550.192932] reg 0xe34, usb write TimeOut! status:-19 value=0x1008c00
[27550.192934] IQK: final_candidate is 0
[27550.192936] IQK: RegE94=0 RegE9C=0 RegEA4=0 RegEAC=0 RegEB4=0
RegEBC=0 RegEC4=0 RegECC=0
[27550.192937]  reg 0xc14, usb read TimeOut! status:-19 value=0x0
[27550.192940] usb_read32...error(-19)
[27550.192942] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192944] reg 0xc1c, usb read TimeOut! status:-19 value=0x0
[27550.192946] usb_read32...error(-19)
[27550.192948] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192950] reg 0xc4c, usb read TimeOut! status:-19 value=0x0
[27550.192952] usb_read32...error(-19)
[27550.192954] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192956] reg 0xc78, usb read TimeOut! status:-19 value=0x0
[27550.192957] usb_read32...error(-19)
[27550.192959] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192962] reg 0xc80, usb read TimeOut! status:-19 value=0x0
[27550.192963] usb_read32...error(-19)
[27550.192965] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192967] reg 0xc88, usb read TimeOut! status:-19 value=0x0
[27550.192969] usb_read32...error(-19)
[27550.192971] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192973] reg 0xc90, usb read TimeOut! status:-19 value=0x0
[27550.192975] usb_read32...error(-19)
[27550.192976] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192979] reg 0xc94, usb read TimeOut! status:-19 value=0x0
[27550.192980] usb_read32...error(-19)
[27550.192982] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192984] reg 0xc9c, usb read TimeOut! status:-19 value=0x0
[27550.192986] usb_read32...error(-19)
[27550.192988] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192990] reg 0xca0, usb read TimeOut! status:-19 value=0x0
[27550.192991] usb_read32...error(-19)
[27550.192993] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.192996] reg 0xd03, usb read TimeOut! status:-19 value=0x0
[27550.192998] usb_read32...error(-19)
[27550.193000] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.193002] reg 0x522, usb write TimeOut! status:-19 value=0xff
[27550.193004] usb_write8...error(-19)
[27550.193005] reg 0xf0, usb read TimeOut! status:-19 value=0xff
[27550.193008] reg 0x824, usb read TimeOut! status:-19 value=0x0
[27550.193009] usb_read32...error(-19)
[27550.193011] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.193013] reg 0x824, usb write TimeOut! status:-19 value=0x0
[27550.194015] reg 0x824, usb write TimeOut! status:-19 value=0x8c000000
[27550.195017] reg 0x824, usb write TimeOut! status:-19 value=0x80000000
[27550.196019] reg 0x820, usb read TimeOut! status:-19 value=0x0
[27550.196021] usb_read32...error(-19)
[27550.196023] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.196025] reg 0x8a0, usb read TimeOut! status:-19 value=0x0
[27550.196027] usb_read32...error(-19)
[27550.196029] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.196031] reg 0x824, usb read TimeOut! status:-19 value=0x0
[27550.196033] usb_read32...error(-19)
[27550.196034] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.196037] reg 0x824, usb write TimeOut! status:-19 value=0x0
[27550.197039] reg 0x824, usb write TimeOut! status:-19 value=0x8c000000
[27550.198102] reg 0x824, usb write TimeOut! status:-19 value=0x80000000
[27550.199105] reg 0x820, usb read TimeOut! status:-19 value=0x0
[27550.199106] usb_read32...error(-19)
[27550.199108] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.199110] reg 0x8a0, usb read TimeOut! status:-19 value=0x0
[27550.199112] usb_read32...error(-19)
[27550.199114] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.199117] reg 0x840, usb write TimeOut! status:-19 value=0x1808000
[27550.298320] reg 0x522, usb write TimeOut! status:-19 value=0x0
[27550.298320] usb_write8...error(-19)
[27550.298320] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.298320] reg 0x550, usb read TimeOut! status:-19 value=0x0
[27550.298320] reg 0x522, usb read TimeOut! status:-19 value=0x0
[27550.298320] reg 0x422, usb read TimeOut! status:-19 value=0x0
[27550.298320] reg 0x542, usb read TimeOut! status:-19 value=0x0
[27550.298320] reg 0xfe40, usb write TimeOut! status:-19 value=0xe0
[27550.298320] usb_write8...error(-19)
[27550.298320] reg 0xf0, usb read TimeOut! status:-19 value=0xe0
[27550.298320] reg 0xfe41, usb write TimeOut! status:-19 value=0x8d
[27550.298320] usb_write8...error(-19)
[27550.298320] reg 0xf0, usb read TimeOut! status:-19 value=0x8d
[27550.298320] reg 0xfe42, usb write TimeOut! status:-19 value=0x80
[27550.298320] usb_write8...error(-19)
[27550.298320] reg 0xf0, usb read TimeOut! status:-19 value=0x80
[27550.298321] reg 0x20c, usb write TimeOut! status:-19 value=0xfd0320
[27550.298323] reg 0x610, usb read TimeOut! status:-19 value=0x0
[27550.298325] reg 0x611, usb read TimeOut! status:-19 value=0x0
[27550.298327] reg 0x612, usb read TimeOut! status:-19 value=0x0
[27550.298329] reg 0x613, usb read TimeOut! status:-19 value=0x0
[27550.298332] reg 0x614, usb read TimeOut! status:-19 value=0x0
[27550.298334] reg 0x615, usb read TimeOut! status:-19 value=0x0
[27550.298336] MAC Address from REG = 0-0-0-0-0-0
[27550.298338] reg 0x31, usb write TimeOut! status:-19 value=0xfa
[27550.298340] usb_write8...error(-19)
[27550.298342] reg 0xf0, usb read TimeOut! status:-19 value=0xfa
[27550.298344] reg 0x32, usb read TimeOut! status:-19 value=0x0
[27550.298346] reg 0x32, usb write TimeOut! status:-19 value=0x1
[27550.298348] usb_write8...error(-19)
[27550.298350] reg 0xf0, usb read TimeOut! status:-19 value=0x1
[27550.298352] reg 0x30, usb read TimeOut! status:-19 value=0x0
[27550.298353] usb_read32...error(-19)
[27550.298355] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.298358] reg 0x30, usb write TimeOut! status:-19 value=0x0
[27550.298360] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298362] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298364] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298366] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298368] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298370] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298373] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298375] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298377] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298379] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298381] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298383] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298385] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298387] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298389] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298392] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298394] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298396] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298398] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298400] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298402] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298404] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298406] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298409] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298411] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298413] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298415] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298417] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298419] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298421] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298423] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298426] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298428] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298430] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298432] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298434] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298436] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298438] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298441] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298443] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298445] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298447] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298449] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298452] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298454] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298456] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298458] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298460] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298463] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298465] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298467] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298469] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298471] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298473] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298475] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298477] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298479] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298482] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298484] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298486] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298488] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298490] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298492] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298494] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298496] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298498] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298501] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298503] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298505] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298507] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298509] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298511] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298513] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298515] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298517] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298520] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298522] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298524] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298526] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298528] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298530] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298532] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298535] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298537] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298539] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298541] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298543] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298545] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298547] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298549] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298551] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298554] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298556] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298558] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298560] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298562] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298564] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298566] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298569] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298571] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298573] reg 0x33, usb read TimeOut! status:-19 value=0x0
[27550.298576] pdmpriv->TxPowerTrackControl = 1
[27550.298578] reg 0x40, usb read TimeOut! status:-19 value=0x0
[27550.298580] reg 0x40, usb write TimeOut! status:-19 value=0x0
[27550.298582] usb_write8...error(-19)
[27550.298584] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[27550.298586] reg 0x15, usb write TimeOut! status:-19 value=0xe9
[27550.298588] usb_write8...error(-19)
[27550.298590] reg 0xf0, usb read TimeOut! status:-19 value=0xe9
[27550.298593] MAC Address = 0-e0-4c-0-29-ba
[27550.298624] -871x_drv - drv_open, bup=1
[27550.299091] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[27550.320074] (2)8192cu_drv - drv_close, bup=1, hw_init_completed=1
[27550.320091] -871x_drv - drv_close, bup=1
[27550.320117] ###> rtw_cmd_thread break.................
[27550.630171] +rtw_dev_unload
[27550.630191] reg 0x522, usb write TimeOut! status:-19 value=0xff
[27550.630197] usb_write8...error(-19)
[27550.630204] reg 0xf0, usb read TimeOut! status:-19 value=0xff
[27550.630210] usb_read_port_cancel
[27550.630215] usb_read_port_cancel
[27550.630219] -rtw_dev_unload
[27550.630224] +r871xu_dev_remove, hw_init_completed=1
[27550.630307] free_recv_skb_queue not empty, 8
[27550.630337] -r871xu_dev_remove, done

Thanks
damencho
