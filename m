Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51703 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbYLKIo2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 03:44:28 -0500
Date: Wed, 10 Dec 2008 16:44:43 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Stephen J. Gowdy" <sgowdy+usb.ids@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	Dakota Lee <Dakota.Lee@Atheros.com>,
	Sayuri Nakamura <Sayuri.Nakamura@Atheros.com>,
	David Allen <David.Allen@Atheros.com>,
	"Wood, Greg" <Greg.Wood@ar-edelman.com>,
	Andy Davidson <Andy.Davidson@Atheros.com>,
	Stephen Chen <Stephen.Chen@Atheros.com>,
	Paul Lin <Paul_Lin@ralinktech.com.tw>,
	Jett Chen <jett_chen@ralinktech.com.tw>
Subject: [PATCH] usb.ids: Update/Fix Atheros USB IDs for 802.11 devices
Message-ID: <20081211004443.GB6287@tesla> (sfid-20081211_094435_666357_5944FB0A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch has a few fixes and updates to the Linux USB IDs file
for Atheros USB IDs.

* USB vendor ID 14b2 belongs to Ralink, not Atheros, this corrects this
  and also adds a few new Ralink WLAN devices to the usb.ids list such as the
  802.11n rt2870
* Add/update all 802.11b zd1201 devices and identify them consistently
* Add/update all 802.11bg zd1211rw devices and identify them consistently
* Add/update all our new 802.11abgn and 802.11bgn ar9170 devices which
  can be used with the mac80211 ar9170 driver available at:

git://git.kernel.org/pub/scm/linux/kernel/git/jberg/ar9170.git

The firmware can be found in the linux-firmware git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git

For more info see:

http://wireless.kernel.org/en/users/Drivers/ar9170

In cases where I am not sure if the device is single band or dual band
I simply identify it as 802.11n capable. As users actually get these
devices please update it (802.11abgn for dual band, 802.11bgn for single
band).

The only one I didn't go through was the really old Atheros 802.11b
(non-zd1201) but since there is no driver for that one upstream (or
close) I haven't cared to look yet.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

--- usb.ids.orig	2008-12-10 14:51:48.000000000 -0800
+++ usb.ids	2008-12-10 16:26:02.000000000 -0800
@@ -21,8 +21,12 @@
 0002  Ingram
 0003  Club Mac
 0004  Nebraska Furniture Mart
+0053  Planex
+	5301  GW-US54ZGL 802.11bg (zd1211rw)
 0079  DragonRise Inc.
 	0006  Generic USB Joystick
+0105  Unknown
+	145f  802.11bg (zd1211rw)
 0145  Unknown
 	0112  Card Reader
 0204  Chipsbank Microelectronics Co., Ltd
@@ -845,7 +849,7 @@
 	00cb  WLI-U2-G300N 802.11n Adapter
 	00d8  WLI-U2-SG54HP
 	00d9  WLI-U2-G54HP
-	00da  WLI-U2-KG54L
+	00da  WLI-U2-KG54L 802.11bg (zd1211rw)
 0412  Award Software International
 0413  Leadtek Research, Inc.
 	1310  WinFast TV - NTSC + FM
@@ -2128,8 +2132,8 @@
 	1230  Wireless Adapter 11g
 	1232  SNU6500 Wireless Adapter
 	1233  Wireless Adapter Bootloader Download
-	1236  SNU5600
-	1237  TalkTalk SNU5630NS/05 Wireless Adapter
+	1236  SNU5600 802.11bg (zd1211rw)
+	1237  TalkTalk SNU5630NS/05 802.11bg (zd1211rw)
 	1552  ISP 1581 Hi-Speed USB MPEG2 Encoder Reference Kit
 	1801  Diva MP3 player
 	200a  Wireless Network Adapter
@@ -3162,6 +3166,7 @@
 	0930  ETG-US2
 	0937  WN-WAG/USL Wireless LAN Adapter
 	0938  WN-G54/USL Wireless LAN Adapter
+	093f  WNGDNUS2 802.11n (ar9170)
 	0a03  Serial USB-RSAQ1
 	0a07  USB2-iCN Adapter
 	0a08  USB2-iCN Adapter
@@ -3992,12 +3997,12 @@
 	3201  F1DF102U/F1DG102U Flip KVM
 	4050  ZD1211B
 	5055  F5D5055
-	6051  11Mbps Wireless Network Adapter
+	6051  802.11b (zd1201)
 	7050  F5D7050 ver 1000 WiFi
 	7051  F5D7051 54g USB Network Adapter
 	705a  F5D7050A Wireless Adapter
 	705b  Wireless G Adapter
-	705c  F5D7050 v4000 Wireless Adapter
+	705c  802.11bg (zd1211rw)
 	905b  F5D9050 ver 3 Wireless Adapter
 	905c  Wireless G Plus MIMO Network Adapter
 050e  Neon Technology, Inc.
@@ -4771,16 +4776,17 @@
 	3304  LAN Modem
 	330a  ADSL Modem Interface
 	330e  USB Broadband ADSL Modem Rev 1.10
-	3400  ZyAIR B-220 IEEE 802.11b Adapter
-	3401  ZyAIR G-220
-	3402  (ZD1211)IEEE 802.11b+g Adapter
-	3407  G-200 v2
-	3409  AG-225H
-	340a  M-202
-	340f  G-220 v2
+	3400  802.11b (zd1201)
+	3401  ZyAIR G-220 802.11bg (zd1211rw)
+	3402  ZyAIR G-220F 802.11bg (zd1211rw)
+	3407  G-200 v2 802.11bg (zd1211rw)
+	3409  AG-225H 802.11bg (zd1211rw)
+	3410  ZyAIR G-202 802.11bg (zd1211rw)
+	340a  M-202 802.11bg (zd1211rw)
+	340f  G-220 v2 802.11bg (zd1211rw)
 	3410  Wi-Fi Wireless LAN Adapter
-	3412  Wi-Fi Wireless LAN Adapter
-	3413  AG-225H v2 802.11a/g Wi-Fi Finder & Adapter
+	3412  802.11bg (zd1211rw)
+	3413  ZyAIR AG-225H v2 802.11bg (zd1211rw)
 	3415  G-210H 802.11g Wireless Adapter
 0587  America Kotobuki Electronics Industries, Inc.
 0588  Sapien Design
@@ -6667,11 +6673,11 @@
 	0001  Braille Voyager
 079b  Sagem
 	0027  USB-Serial Controller
-	004a  XG-760A
+	004a  XG-760A 802.11bg (zd1211rw)
 	004b  Wi-Fi 11g adapter
 	0056  Agfa AP1100 Photo Printer
 	005d  my401C mobile phone
-	0062  XG-76NA
+	0062  XG-76NA 802.11bg (zd1211rw)
 079d  Alfadata Computer Corp.
 	0201  GamePort Adapter
 07a1  Digicom S.p.A.
@@ -6789,7 +6795,8 @@
 	4102  USB 1.1 10/100M Fast Ethernet Adapter
 	4104  XX9
 	420a  UF200 Ethernet
-	6001  WL54
+	6001  802.11bg (zd1211rw)
+	5301  GW-US54ZGL 802.11bg (zd1211rw)
 	a001  Wireless Network Adapter
 	abc1  DU-E10 Ethernet [pegasus]
 	b000  BWU613
@@ -6981,6 +6988,7 @@
 	3b01  AirPlus G DWL-G122 Wireless Adapter
 	3b10  RangeBooster N Adapter
 	3b11  Wireless N Adapter DWA-130
+	3c10  DWA 160A 802.11n (ar9170)
 	3c03  DWL-G122 802.11g Adapter [ralink rt73]
 	3c04  WUA-1340
 	3c05  EH103 Wireless G Adapter
@@ -7024,6 +7032,7 @@
 07fa  Draytek
 	0778  miniVigor 128 ISDN TA
 	1012  BeWAN ADSL USB ST (grey)
+	1196  BWIFI-USB54AR 802.11bg (zd1211rw)
 	a904  BeWAN ADSL
 	a905  BeWAN ADSL ST
 07fd  Mark of the Unicorn
@@ -7151,7 +7160,7 @@
 	3502  WN3501D Wireless Adapter
 	3503  T-Sinus 111 Wireless Adapter
 	4501  T-Sinus 154data
-	4505  SMCWUSB-G
+	4505  SMCWUSB-G 802.11bg (zd1211rw)
 	5046  SpeedStream 10/100 Ethernet [pegasus]
 	5501  Wireless Adapter 11g
 	6500  Cable Modem
@@ -7165,8 +7174,10 @@
 	c501  Zoom Wireless-G
 	c561  802.11a/g Wireless Adapter
 	e501  ZD1211B
+	e506  WUS-201 802.11bg (zd1211rw)
 	f501  802.11g Wireless Adapter
 	f502  802.11g Wireless Adapter
+	f522  Arcadyan WN7512 802.11n (ar9170)
 083f  Global Village
 	b100  TelePort V.90 Fax/Modem
 0840  Argosy Research, Inc.
@@ -7191,8 +7202,8 @@
 	6a00  WG111v2 54 Mbps Wireless [RealTek RTL8187L] 
 	7100  WN121T RangeMax Next Wireless-N [Marvell TopDog]
 	9000  WN111(v1) RangeMax Next Wireless [Marvell TopDog]
-	9001  WN111(v2) RangeMax Next Wireless [Atheros AR9001U-(2)NG]
-	9010  WNDA3100 RangeMax Dual Band Wireless-N [Atheros AR9001U-2NX] 
+	9001  WN111 v2 802.11n (ar9170)
+	9010  WNDA3100 802.11n (ar9170)
 	a001  PA101 10 Mbps HPNA Home Phoneline RJ-1
 084d  Minton Optic Industry Co., Inc.
 	0001  Jenoptik JD800i
@@ -8255,10 +8266,14 @@
 0acd  ID Tech
 	0401  ID TECH Spectrum III Hybrid Smartcard Reader
 0ace  ZyDAS
-	1201  802.11b WiFi
-	1211  802.11b/g USB2 WiFi
-	1215  WLA-54L WiFi
+	1201  802.11b (zd1201)
+	1211  802.11bg (zd1211rw)
+	1215  WLA-54L 802.11bg (zd1211rw)
+	1221  ZD1221 802.11n (ar9170)
 	1608  ONMI FAXMODEM 56K UNO (ZyXEL)
+	b215  802.11bg (zd1211rw)
+	2011  Virtual media for 802.11bg (zd1211rw)
+	20ff  Virtual media for 802.11bg (zd1211rw)
 0acf  Intoto, Inc.
 0ad0  Intellix Corp.
 0ad1  Remotec Technology, Ltd
@@ -8316,12 +8331,12 @@
 	1707  WL-167g Wireless Adapter
 	1708  Mass Storage Device
 	170b  Mass Storage Device
-	170c  WL-159g
+	170c  WL-159g 802.11bg (zd1211rw)
 	170d  802.11b/g Wireless Network Adapter
 	1712  BT-183 Bluetooth 2.0+EDR adapter
 	1715  2045 Bluetooth 2.0 Device with trace filter
 	1716  Bluetooth Device
-	171b  A9T wireless
+	171b  A9T wireless 802.11bg (zd1211rw)
 	171c  802.11b/g Wireless Network Adapter
 	1723  WL-167G v2 802.11g Adapter [ralink]
 	1724  RT2573
@@ -8369,8 +8384,8 @@
 	1612  AIR.Mate 2@net 802.11b Adapter
 	1613  802.11b Wireless LAN Adapter
 	1620  Allnet USB 2.0 Wireless Network Adapter
-	1630  QuickWLAN
-	5630  ZD1211
+	1630  QuickWLAN 802.11bg (zd1211rw)
+	5630  802.11bg (zd1211rw)
 	6630  ZD1211
 0b3c  Olivetti Techcenter
 	a010  Simple_Way Printer/Scanner/Copier
@@ -8478,7 +8493,7 @@
 	00fb  SureConnect ADSL Ethernet/USB Router
 	0118  U5 802.11g Adapter
 	011b  Wireless MAXg Adapter
-	0121  USR5423 WLAN
+	0121  USR5423 802.11bg (zd1211rw)
 	6112  FaxModem Model 5633
 0bb0  Concord Camera Corp.
 	0100  Sound Vision Stream
@@ -9103,10 +9118,12 @@
 	0015  Zoom Wireless-G
 	0016  NB 802.11g Wireless LAN Adapter(3887A)
 	0018  NB 802.11a/b/g Wireless LAN Adapter(3887A)
-	001a  ZD1211B
+	001a  802.11bg (zd1211rw)
 	001c  802.11b/g Wireless Network Adapter
 	0020  Wi-Fi Wireless LAN Adapter
 	0022  802.11b/g/n Wireless Network Adapter
+	0023  UB81 802.11bgn (ar9170)
+	0026  UB82 802.11abgn (ar9170)
 0ce9  pico Technology
 	1001  PicoScope3204
 0cf1  e-Conn Electronic Co., Ltd
@@ -9118,6 +9135,8 @@
 	0004  AR5523 (no firmware)
 	0005  AR5523
 	0006  AR5523 (no firmware)
+	9170  AR9170 802.11n
+	1001  TG121N (ar9170)
 0cf4  Fomtex Corp.
 0cf5  Cellink Co., Ltd
 0cf6  Compucable Corp.
@@ -9381,7 +9400,7 @@
 	5513  MP3 Player
 	5515  MP3 Player
 	5516  MP3 Player
-	6823  UB11B/MS-6823 802.11b Wi-Fi adapter
+	6823  802.11b (zd1201)
 	6826  IEEE 802.11g Wireless Network Adapter
 	6855  Bluetooth Device
 	6861  MSI-6861 802.11g WiFi adapter
@@ -9499,8 +9518,8 @@
 	2200  Sitecom bluetooth2.0 class 2 dongle CN-512
 	2208  Sitecom bluetooth2.0 class 2 dongle CN-520
 	2209  Sitecom bluetooth2.0 class 1 dongle CN-521
-	9071  zd1211 802.11g Adapter
-	9075  ZD1211B
+	9071  802.11bg (zd1211rw)
+	9075  802.11bg (zd1211rw)
 	90ac  WL-172
 	9712  WL-113 rev 2
 0df7  Mobile Action Technology, Inc.
@@ -9921,7 +9940,7 @@
 	8002  GN-BR402W
 	8003  GN-WLBM101
 	8004  GN-WLBZ101 802.11b Adapter
-	8005  GN-WLBZ201 802.11b Adapter
+	8005  802.11b (zd1201)
 	8006  GN-WBZB-M 802.11b Adapter
 	8007  GN-WBKG
 	8008  GN-WB01GS
@@ -10313,7 +10332,7 @@
 126f  TwinMOS
 	1325  Mobile Disk
 	2168  Mobile Disk III
-	a006  G240
+	a006  G240 802.11bg (zd1211rw)
 1275  Xaxero Marine Software Engineering, Ltd.
 	0002  WeatherFax 2000 Demodulator
 	0080  SkyEye Weather Satellite Receiver
@@ -10326,7 +10345,8 @@
 	2101  104-key keyboard
 1294  RISO KAGAKU CORP.
 129b  CyberTAN Technology
-	1666  TG54USB
+	1666  TG54USB 802.11bg (zd1211rw)
+	1667  802.11bg (zd1211rw)
 12a7  Trendchip Technologies Corp.
 12ab  Honey Bee Electronic International Ltd.
 12ba  Licensed by Sony Computer Entertainment America
@@ -10415,9 +10435,10 @@
 	0011  WUSB54GP v4.0 802.11g Adapter
 	0018  USB200M 10/100 Ethernet Adapter
 	001a  HU200TS Wireless Adapter
+	001e  WUSBF54G 802.11bg (zd1211rw)
 	0020  WUSB54GC 802.11g Adapter [ralink rt73]
 	0023  WUSB54GR
-	0024  WUSBF54G v1.1 802.11g Adapter w/ Wi-Fi Finder
+	0024  WUSBF54G v1.1 802.11bg (zd1211rw)
 13b3  Nippon Dics Co., Ltd.
 13ba  Unknown
 	0017  PS/2 Keyboard+Mouse Adapter
@@ -10494,7 +10515,7 @@
 1430  RedOctane
 1431  Pertech Resources, Inc.
 1435  Wistron NeWeb
-	0711  UR055G
+	0711  UR055G 802.11bg (zd1211rw)
 	0826  AR5523
 	0827  AR5523 (no firmware)
 	0828  AR5523
@@ -10554,10 +10575,11 @@
 14ae  Printronix Inc.
 14af  ATP Electronics Inc.
 14b0  StarTech.com Ltd.
-14b2  Atheros Communications Inc
+14b2  Ralink Technology, Corp.
 	3a93  USB WLAN Device
-	3c02  C54RU WLAN
-	3c22  C54RU
+	3c02  rt2500 802.11g WLAN
+	3c22  rt73 802.11g WLAN
+	3c27  rt2870 802.11n WLAN
 14c0  Rockwell Automation, Inc.
 14c2  Gemlight Computer, Ltd
 	0250  Storage Adapter V2
@@ -10570,7 +10592,7 @@
 14ea  Planex Communications
 	ab10  GW-US54GZ
 	ab11  GU-1000T
-	ab13  GW-US54Mini
+	ab13  GW-US54Mini 802.11bg (zd1211rw)
 14ed  Shure Inc.
 1500  Ellisys
 1501  Pine-Tum Enterprise Co., Ltd.
@@ -10618,14 +10640,14 @@
 157e  TRENDnet
 	3006  TEW-444UB EU
 	3007  TEW-444UB EU (no firmware)
-	300a  TEW-429UB 802.11g Adapter with HotSpot Detector
-	300b  TEW-429UB
-	300d  TEW-429UB C1
-	3204  ALL0298 v2
+	300a  TEW-429UB 802.11bg (zd1211rw)
+	300b  TEW-429UB 802.11bg (zd1211rw)
+	300d  TEW-429UB C1 802.11bg (zd1211rw)
+	3204  ALL0298 v2 802.11bg (zd1211rw)
 	3205  AR5523
 	3206  AR5523 (no firmware)
 1582  Fiberline
-	6003  WL-430U
+	6003  WL-430U 802.11bg (zd1211rw)
 1587  SMA Technologie AG
 158d  Oakley Inc.
 1598  Kunshan Guoji Electronics Co., Ltd.
@@ -10904,7 +10926,7 @@
 1737  Linksys
 	0039  USB1000
 1740  Senao
-	2000  NUB-8301
+	2000  NUB-8301 802.11bg (zd1211rw)
 1743  General Atomics
 174c  ASMedia Technology Inc.
 174f  Syntek
@@ -11323,7 +11345,8 @@
 	f118  Formosa 4
 2019  PLANEX
 	3220  GW-US11S WLAN
-	5303  GW-US54GXS
+	5303  GW-US54GXS 802.11bg (zd1211rw)
+	5304  GWUS300 802.11n (ar9170)
 	ab01  GW-US54HP
 	ab50  GW-US54Mini2
 	c002  GW-US54SG
@@ -11769,7 +11792,7 @@
 	2667  JCOP BlueZ Smartcard reader
 	8804  WiseGroup SuperJoy Box 5
 6891  3Com
-	a727  3CRUSB10075
+	a727  3CRUSB10075 802.11bg (zd1211rw)
 6993  Freshtel
 	b001  FT-102 VoIP USB Phone
 6a75  Shanghai Jujo Electronics Co., Ltd
