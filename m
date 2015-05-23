Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:34882 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957AbbEWSD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2015 14:03:28 -0400
Date: Sat, 23 May 2015 20:01:30 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix EFUSE_ANA8M map value
Message-ID: <20150523200130.0fe2930d@wiggum> (sfid-20150523_200331_727245_99870FE1)
In-Reply-To: <20150523124038.17417873@wiggum>
References: <20150521214421.15983b0a@milhouse>
 <555E5433.7000904@lwfinger.net>
 <20150522070035.711c6195@wiggum>
 <555F8FDC.3040609@lwfinger.net>
 <20150522231300.200a2e00@wiggum>
 <55600CEB.5080703@lwfinger.net>
 <20150523124038.17417873@wiggum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7Cs4mHs9okwGbhheKT=ls/z"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/7Cs4mHs9okwGbhheKT=ls/z
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 23 May 2015 12:40:38 +0200
Michael B=C3=BCsch <m@bues.ch> wrote:

> I will also try your driver from your github repo soon and see if that ma=
kes it work.

Oh well. To put it mildly, this driver is awful.
It compiles with frightening array overrun warnings in rtl8192c_rf6052.c, o=
n load spews a ton of messages and then replies to a scan request with:

root@milhouse:~# ip link set up dev wlan4
root@milhouse:~# iwlist wlan4 scan
wlan4     Interface doesn't support scanning.

root@milhouse:~# iw dev wlan4 scan
command failed: No such device (-19)


Stand clear, here come the messages:

[ 3973.868312] rtl8192cu driver version=3Dv4.0.2_9000.20130911
[ 3973.868453] usbcore: registered new interface driver rtl8192cu
[ 4028.492113] usb 1-2: new high-speed USB device number 6 using ehci-pci
[ 4028.625897] usb 1-2: New USB device found, idVendor=3D7392, idProduct=3D=
7811
[ 4028.625912] usb 1-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[ 4028.625921] usb 1-2: Product: 802.11n WLAN Adapter
[ 4028.625930] usb 1-2: Manufacturer: Realtek
[ 4028.625938] usb 1-2: SerialNumber: xxx
[ 4028.626959]=20
               usb_endpoint_descriptor(0):
[ 4028.626976] bLength=3D7
[ 4028.626983] bDescriptorType=3D5
[ 4028.626991] bEndpointAddress=3D81
[ 4028.626998] wMaxPacketSize=3D200
[ 4028.627004] bInterval=3D0
[ 4028.627011] RT_usb_endpoint_is_bulk_in =3D 1
[ 4028.627017]=20
               usb_endpoint_descriptor(1):
[ 4028.627026] bLength=3D7
[ 4028.627032] bDescriptorType=3D5
[ 4028.627038] bEndpointAddress=3D2
[ 4028.627044] wMaxPacketSize=3D200
[ 4028.627050] bInterval=3D0
[ 4028.627056] RT_usb_endpoint_is_bulk_out =3D 2
[ 4028.627063]=20
               usb_endpoint_descriptor(2):
[ 4028.627073] bLength=3D7
[ 4028.627080] bDescriptorType=3D5
[ 4028.627087] bEndpointAddress=3D3
[ 4028.627095] wMaxPacketSize=3D200
[ 4028.627102] bInterval=3D0
[ 4028.627108] RT_usb_endpoint_is_bulk_out =3D 3
[ 4028.627115]=20
               usb_endpoint_descriptor(3):
[ 4028.627126] bLength=3D7
[ 4028.627133] bDescriptorType=3D5
[ 4028.627141] bEndpointAddress=3D84
[ 4028.627147] wMaxPacketSize=3D40
[ 4028.627154] bInterval=3D1
[ 4028.627162] RT_usb_endpoint_is_int_in =3D 4, Interval =3D 1
[ 4028.627171] nr_endpoint=3D4, in_num=3D2, out_num=3D2

[ 4028.627182] USB_SPEED_HIGH
[ 4028.627240] CHIP TYPE: RTL8188C_8192C
[ 4028.627274] register rtw_netdev_ops to netdev_ops
[ 4028.627415] Chip Version ID: VERSION_NORMAL_TSMC_CHIP_88C.
[ 4028.627428] RF_Type is 3!!
[ 4028.627768] EEPROM type is E-FUSE
[ 4028.627780] =3D=3D=3D=3D> ReadAdapterInfo8192C
[ 4028.627898] Boot from EFUSE, Autoload OK !
[ 4028.778757] EEPROMVID =3D 0x7392
[ 4028.778765] EEPROMPID =3D 0x7811
[ 4028.778769] EEPROMCustomerID : 0x00
[ 4028.778773] EEPROMSubCustomerID: 0x00
[ 4028.778777] RT_CustomerID: 0x00
[ 4028.778784] _ReadMACAddress MAC Address from EFUSE =3D xxx
[ 4028.778790] EEPROMRegulatory =3D 0x0
[ 4028.778794] _ReadBoardType(0)
[ 4028.778799] BT Coexistance =3D disable
[ 4028.778804] mlmepriv.ChannelPlan =3D 0x02
[ 4028.778809] _ReadPSSetting...bHWPwrPindetect(0)-bHWPowerdown(0) ,bSuppor=
tRemoteWakeup(0)
[ 4028.778813] ### PS params=3D>  power_mgnt(1),usbss_enable(0) ###
[ 4028.778817] ### AntDivCfg(0)
[ 4028.778821] readAdapterInfo_8192CU(): REPLACEMENT =3D 1
[ 4028.778826] <=3D=3D=3D=3D ReadAdapterInfo8192C in 152 ms
[ 4028.779451] rtw_macaddr_cfg MAC Address  =3D xxx
[ 4028.779461] bDriverStopped:1, bSurpriseRemoved:0, bup:0, hw_init_complet=
ed:0
[ 4028.780924] _rtw_drv_register_netdev, MAC Address (if1) =3D xxx
[ 4029.844223] rtl8192cu 1-2:1.0 wlan4: renamed from wlan1
[ 4029.872791] systemd-udevd[30617]: renamed network interface wlan1 to wla=
n4
[ 4032.495346] +871x_drv - drv_open, bup=3D0
[ 4032.499722]  =3D=3D=3D> FirmwareDownload91C() fw:Rtl819XFwImageArray_TSMC
[ 4032.499737] FirmwareDownload92C accquire FW from embedded image
[ 4032.499746] fw_ver=3Dv88, fw_subver=3D2, sig=3D0x88c0
[ 4032.532832] fw download ok!
[ 4032.532841] Set RF Chip ID to RF_6052 and RF type to 1T1R.
[ 4032.906818] IQK:Start!!!
[ 4032.918190] Path A IQK Success!!
[ 4032.926443] Path A IQK Success!!
[ 4032.931584] IQK: final_candidate is 0
[ 4032.931595] IQK: RegE94=3D106 RegE9C=3D13 RegEA4=3Dfd RegEAC=3D3fd RegEB=
4=3D0 RegEBC=3D0 RegEC4=3D0 RegECC=3D0
                Path A IQ Calibration Success !
[ 4033.043931] pdmpriv->TxPowerTrackControl =3D 1
[ 4033.048684] rtl8192cu_hal_init in 556ms
[ 4033.061576] MAC Address =3D xxx
[ 4033.061789] -871x_drv - drv_open, bup=3D1
[ 4033.062150] IPv6: ADDRCONF(NETDEV_UP): wlan4: link is not ready
[ 4035.068534] =3D=3D>rtw_ps_processor .fw_state(0)
[ 4035.068546] =3D=3D>ips_enter cnts:1
[ 4035.068552] =3D=3D=3D> rtw_ips_pwr_down...................
[ 4035.068771] =3D=3D=3D=3D> rtw_ips_dev_unload...
[ 4035.092200] usb_read_port_cancel
[ 4035.092508] usb_read_port_complete()-1284: RX Warning! bDriverStopped(0)=
 OR bSurpriseRemoved(0) bReadPortCancel(1)
[ 4035.092761] usb_read_port_complete()-1284: RX Warning! bDriverStopped(0)=
 OR bSurpriseRemoved(0) bReadPortCancel(1)
[ 4035.092998] usb_read_port_complete()-1284: RX Warning! bDriverStopped(0)=
 OR bSurpriseRemoved(0) bReadPortCancel(1)
[ 4035.093247] usb_read_port_complete()-1284: RX Warning! bDriverStopped(0)=
 OR bSurpriseRemoved(0) bReadPortCancel(1)
[ 4035.093263] usb_write_port_cancel=20
[ 4035.093315] =3D=3D> rtl8192cu_hal_deinit=20
[ 4035.093319] bkeepfwalive(0)
[ 4035.093323] card disble without HWSM...........
[ 4035.098401] <=3D=3D=3D rtw_ips_pwr_down..................... in 28ms



If you want to have this device, I'll ship it to you for free.

--=20
Michael

--Sig_/7Cs4mHs9okwGbhheKT=ls/z
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVYMB+AAoJEPUyvh2QjYsOoeYQAODVnwocoggf5w27zzkmCYfx
AvglhI7Q7EM6/3qfiwArVNwF4daPfDb0sokjCp9OE0GcQqM88ViM/2Agf6oGvawm
5l9xQUPn1yEJbaKlWE+i0nLpvEtGSIWG9CE5IuHaPWeedCisBgDr5pk4uAOz8sPu
RqoWlUaE33/U2RWk0LUSvW+cBizMk6gOOZyliisMc5RYwhOFmtJYp8DEBMMbv13u
GNVhFtZaK27Jz51Y84RxhquwW5zollTzJ9MHrEONsaBpFa7FOJ0cprXfRkZU1Jmf
ExqLPZhSdfbSQzNkUXhMM4Nj5f04QDP6KkYjMrqAD75X6GazGChEFB3sIPVJZmut
i0Q3RABrN3aSAJB47YFnZIkEF5cUA4BcSHPghAYKVCfjEXNQJH4jT8uFPflHJN72
t/r+3t6qGHyj+L/2YFjp/p3/t8zbl/xthbxK681jmgt+10RJRr4xfjg4AhvPHmz3
4JUHGfugV7y4sJLL2ZCHkh4SxMqHX2Bb/gax6wzF8xF/SlIjVAIKhmMAumrc3eUq
GtCxBNyajSdmcrcKglm1D7hkwcMePlJQNbUsSa1uiCduPfx5AkiJu1gtYdd4zEkJ
n9eexZFXHREE6GsZgj4wVmDnpN63LzBlqDdC8zaYVr4raCWjeJ0/tNKZk8ANzNN+
a+noNGlWCewuK6eA2uts
=nlMw
-----END PGP SIGNATURE-----

--Sig_/7Cs4mHs9okwGbhheKT=ls/z--
