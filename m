Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:39830
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752363Ab1H2OAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 10:00:05 -0400
Message-ID: <4E5B9B44.6080508@compulab.co.il> (sfid-20110829_160014_262865_8F8F0C36)
Date: Mon, 29 Aug 2011 16:59:32 +0300
From: Ilya Ledvich <ilya@compulab.co.il>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-wireless@vger.kernel.org,
	Igor Grinberg <grinberg@compulab.co.il>
Subject: Problem with wl1271
Content-Type: multipart/mixed;
 boundary="------------090201010609000707090808"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090201010609000707090808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I'm trying to evaluate the TI WL1271 WiFi/Bluetooth chip using the RFM's
DR-WLS1271-EV evaluation kit on our CM-T35 board.
Below is the SW and HW configuration I use:
  - Linux kernel version - 3.0.3
  - firmware and NVS are obtained from the David Woodhouse's tree (as 
recommended
    in the "wl12xx" article at the Linux Wireless wiki:
    http://linuxwireless.org/en/users/Drivers/wl12xx).
    According to the attached log file, the driver loads the module with
/ti-connectivity/wl1271-fw-2.bin/ firmware (Rev 6.1.5.50.74). The NVS 
file used
    is /ti-connectivity/wl1271-nvs.bin/
  - the evaluation kit is connected to the MMC-1 interface using the 
MMC/SD/SDIO
    slot on our SB-T35 base board
  - the /arch/arm/mach-omap2/board-cm-t35.c/ file is modified as 
referenced in the
/arch/arm/mach-omap2/board-zoom-peripherals.c/. The reference clock in the
*wl12xx_platform_data* struct is set to the 
*WL12XX_REFCLOCK_38*(38.4MHz) value
  - the *wl12xx_debug_level* is set to the following value:
*DEBUG_IRQ | DEBUG_BOOT | DEBUG_EVENT | DEBUG_SCAN | DEBUG_PSM
    | DEBUG_CMD | DEBUG_ACX | DEBUG_MASTER | DEBUG_MAILBOX*

I load the wl12xx_sdio module and then set the interface up; no obvious 
error
is seen. When I run any other command (e.g. interface down/up, iwlist scan).
I have "/wl1271: ERROR ELP wakeup timeout!/" error. Then the driver 
tries to
recover the chip; this eventually leads to the
"/wl1271: ERROR sdio read failed (-110)/" error. The log file for
ifconfig wlan0 up - down - up sequence is attached.

Additionally, I've tried to perform the calibration as described in the 
"wl12xx
Calibrator" article at
http://linuxwireless.org/en/users/Drivers/wl12xx/calibrator
The /TQS_S_2.6.ini/ file was used in order to create reference NVS file. 
The calibration
procedure has been failed. The log file is attached. I read through 
"WL12XX firmware"
thread here http://www.spinics.net/lists/linux-wireless/msg52687.html.
I noticed, that usually an ERROR ELP wakeup time out means that the firmware
has crashed. Additionally, I found that the wl1271 sdio needs a special SDIO
command to wakeup the firmware properly from ELP. I'm not sure it's 
completely
clear to me.

Can you please advice something?

Thank you in advance.
Best regards,
Ilya.


--------------090201010609000707090808
Content-Type: text/x-log;
 name="wl12xx_if_up_down_up.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wl12xx_if_up_down_up.log"

root@cm-debian:~# modprobe wl12xx_sdio
[   79.971343] cfg80211: Calling CRDA to update world regulatory domain
[   86.769622] wl1271: loaded
[   86.777832] wl1271: initialized
root@cm-debian:~# ifconfig wlan0 up
[  109.576660] wl1271: chip id 0x4030111 (1271 PG20)
[  109.581665] wl1271: booting firmware ti-connectivity/wl1271-fw-2.bin
[  109.863403] wl1271: pause1 0xf03
[  109.874511] wl1271: DRPW_SCRATCH_START 0031002c
[  109.879425] wl1271: clk2 0x0
[  109.885772] wl1271: soft reset bootdata 0x0
[  109.894927] wl1271: nvs burst write 0x30546c: 0xbeef0000
[  109.902496] wl1271: nvs burst write 0x305470: 0xdead
[  109.909820] wl1271: ACX_EEPROMLESS_IND_REG
[  109.915466] wl1271: chip id 0x4030111
[  109.920471] wl1271: firmware chunks to be uploaded: 6
[  109.925811] wl1271: chunk 5 addr 0x0 len 196100
[  109.930725] wl1271: starting firmware upload
[  109.935333] wl1271: fw_data_len 196100 chunk_size 512
[  109.942901] wl1271: uploading fw chunk 0xd156000c to 0x0
[  109.948669] wl1271: uploading fw chunk 0xd156020c to 0x200
[  109.958770] wl1271: uploading fw chunk 0xd156040c to 0x400
[  109.964752] wl1271: uploading fw chunk 0xd156060c to 0x600
[  109.972534] wl1271: uploading fw chunk 0xd156080c to 0x800
[  109.979583] wl1271: uploading fw chunk 0xd1560a0c to 0xa00
[  109.986602] wl1271: uploading fw chunk 0xd1560c0c to 0xc00
[  109.993621] wl1271: uploading fw chunk 0xd1560e0c to 0xe00
[  110.000640] wl1271: uploading fw chunk 0xd156100c to 0x1000
[  110.008209] wl1271: uploading fw chunk 0xd156120c to 0x1200
[  110.015441] wl1271: uploading fw chunk 0xd156140c to 0x1400
[  110.022613] wl1271: uploading fw chunk 0xd156160c to 0x1600
[  110.029724] wl1271: uploading fw chunk 0xd156180c to 0x1800
[  110.035797] wl1271: uploading fw chunk 0xd1561a0c to 0x1a00
[  110.043670] wl1271: uploading fw chunk 0xd1561c0c to 0x1c00
[  110.050811] wl1271: uploading fw chunk 0xd1561e0c to 0x1e00
[  110.057922] wl1271: uploading fw chunk 0xd156200c to 0x2000
[  110.065032] wl1271: uploading fw chunk 0xd156220c to 0x2200
[  110.072143] wl1271: uploading fw chunk 0xd156240c to 0x2400
[  110.079254] wl1271: uploading fw chunk 0xd156260c to 0x2600
[  110.086395] wl1271: uploading fw chunk 0xd156280c to 0x2800
[  110.093566] wl1271: uploading fw chunk 0xd1562a0c to 0x2a00
[  110.100982] wl1271: uploading fw chunk 0xd1562c0c to 0x2c00
[  110.108154] wl1271: uploading fw chunk 0xd1562e0c to 0x2e00
[  110.114196] wl1271: uploading fw chunk 0xd156300c to 0x3000
[  110.122161] wl1271: uploading fw chunk 0xd156320c to 0x3200
[  110.129333] wl1271: uploading fw chunk 0xd156340c to 0x3400
[  110.136444] wl1271: uploading fw chunk 0xd156360c to 0x3600
[  110.143585] wl1271: uploading fw chunk 0xd156380c to 0x3800
[  110.150695] wl1271: uploading fw chunk 0xd1563a0c to 0x3a00
[  110.157806] wl1271: uploading fw chunk 0xd1563c0c to 0x3c00
[  110.164947] wl1271: uploading fw chunk 0xd1563e0c to 0x3e00
[  110.172058] wl1271: uploading fw chunk 0xd156400c to 0x4000
[  110.179321] wl1271: uploading fw chunk 0xd156420c to 0x4200
[  110.186492] wl1271: uploading fw chunk 0xd156440c to 0x4400
[  110.192535] wl1271: uploading fw chunk 0xd156460c to 0x4600
[  110.200653] wl1271: uploading fw chunk 0xd156480c to 0x4800
[  110.206726] wl1271: uploading fw chunk 0xd1564a0c to 0x4a00
[  110.214599] wl1271: uploading fw chunk 0xd1564c0c to 0x4c00
[  110.221710] wl1271: uploading fw chunk 0xd1564e0c to 0x4e00
[  110.228820] wl1271: uploading fw chunk 0xd156500c to 0x5000
[  110.236022] wl1271: uploading fw chunk 0xd156520c to 0x5200
[  110.243164] wl1271: uploading fw chunk 0xd156540c to 0x5400
[  110.250274] wl1271: uploading fw chunk 0xd156560c to 0x5600
[  110.257415] wl1271: uploading fw chunk 0xd156580c to 0x5800
[  110.264526] wl1271: uploading fw chunk 0xd1565a0c to 0x5a00
[  110.270568] wl1271: uploading fw chunk 0xd1565c0c to 0x5c00
[  110.278442] wl1271: uploading fw chunk 0xd1565e0c to 0x5e00
[  110.285552] wl1271: uploading fw chunk 0xd156600c to 0x6000
[  110.292663] wl1271: uploading fw chunk 0xd156620c to 0x6200
[  110.299774] wl1271: uploading fw chunk 0xd156640c to 0x6400
[  110.306884] wl1271: uploading fw chunk 0xd156660c to 0x6600
[  110.313995] wl1271: uploading fw chunk 0xd156680c to 0x6800
[  110.321105] wl1271: uploading fw chunk 0xd1566a0c to 0x6a00
[  110.328216] wl1271: uploading fw chunk 0xd1566c0c to 0x6c00
[  110.335327] wl1271: uploading fw chunk 0xd1566e0c to 0x6e00
[  110.342437] wl1271: uploading fw chunk 0xd156700c to 0x7000
[  110.348510] wl1271: uploading fw chunk 0xd156720c to 0x7200
[  110.356353] wl1271: uploading fw chunk 0xd156740c to 0x7400
[  110.363464] wl1271: uploading fw chunk 0xd156760c to 0x7600
[  110.370574] wl1271: uploading fw chunk 0xd156780c to 0x7800
[  110.377929] wl1271: uploading fw chunk 0xd1567a0c to 0x7a00
[  110.385101] wl1271: uploading fw chunk 0xd1567c0c to 0x7c00
[  110.392303] wl1271: uploading fw chunk 0xd1567e0c to 0x7e00
[  110.399414] wl1271: uploading fw chunk 0xd156800c to 0x8000
[  110.406555] wl1271: uploading fw chunk 0xd156820c to 0x8200
[  110.413665] wl1271: uploading fw chunk 0xd156840c to 0x8400
[  110.420867] wl1271: uploading fw chunk 0xd156860c to 0x8600
[  110.426910] wl1271: uploading fw chunk 0xd156880c to 0x8800
[  110.434783] wl1271: uploading fw chunk 0xd1568a0c to 0x8a00
[  110.441925] wl1271: uploading fw chunk 0xd1568c0c to 0x8c00
[  110.449035] wl1271: uploading fw chunk 0xd1568e0c to 0x8e00
[  110.456115] wl1271: uploading fw chunk 0xd156900c to 0x9000
[  110.463226] wl1271: uploading fw chunk 0xd156920c to 0x9200
[  110.470367] wl1271: uploading fw chunk 0xd156940c to 0x9400
[  110.477478] wl1271: uploading fw chunk 0xd156960c to 0x9600
[  110.484588] wl1271: uploading fw chunk 0xd156980c to 0x9800
[  110.491699] wl1271: uploading fw chunk 0xd1569a0c to 0x9a00
[  110.498809] wl1271: uploading fw chunk 0xd1569c0c to 0x9c00
[  110.504882] wl1271: uploading fw chunk 0xd1569e0c to 0x9e00
[  110.513366] wl1271: uploading fw chunk 0xd156a00c to 0xa000
[  110.519439] wl1271: uploading fw chunk 0xd156a20c to 0xa200
[  110.527343] wl1271: uploading fw chunk 0xd156a40c to 0xa400
[  110.534576] wl1271: uploading fw chunk 0xd156a60c to 0xa600
[  110.541717] wl1271: uploading fw chunk 0xd156a80c to 0xa800
[  110.548828] wl1271: uploading fw chunk 0xd156aa0c to 0xaa00
[  110.555969] wl1271: uploading fw chunk 0xd156ac0c to 0xac00
[  110.563079] wl1271: uploading fw chunk 0xd156ae0c to 0xae00
[  110.570190] wl1271: uploading fw chunk 0xd156b00c to 0xb000
[  110.577301] wl1271: uploading fw chunk 0xd156b20c to 0xb200
[  110.584411] wl1271: uploading fw chunk 0xd156b40c to 0xb400
[  110.590454] wl1271: uploading fw chunk 0xd156b60c to 0xb600
[  110.598327] wl1271: uploading fw chunk 0xd156b80c to 0xb800
[  110.605438] wl1271: uploading fw chunk 0xd156ba0c to 0xba00
[  110.612548] wl1271: uploading fw chunk 0xd156bc0c to 0xbc00
[  110.619873] wl1271: uploading fw chunk 0xd156be0c to 0xbe00
[  110.627044] wl1271: uploading fw chunk 0xd156c00c to 0xc000
[  110.634735] wl1271: uploading fw chunk 0xd156c20c to 0xc200
[  110.641906] wl1271: uploading fw chunk 0xd156c40c to 0xc400
[  110.649047] wl1271: uploading fw chunk 0xd156c60c to 0xc600
[  110.656188] wl1271: uploading fw chunk 0xd156c80c to 0xc800
[  110.663299] wl1271: uploading fw chunk 0xd156ca0c to 0xca00
[  110.670410] wl1271: uploading fw chunk 0xd156cc0c to 0xcc00
[  110.676483] wl1271: uploading fw chunk 0xd156ce0c to 0xce00
[  110.684356] wl1271: uploading fw chunk 0xd156d00c to 0xd000
[  110.691558] wl1271: uploading fw chunk 0xd156d20c to 0xd200
[  110.699066] wl1271: uploading fw chunk 0xd156d40c to 0xd400
[  110.706207] wl1271: uploading fw chunk 0xd156d60c to 0xd600
[  110.713348] wl1271: uploading fw chunk 0xd156d80c to 0xd800
[  110.720581] wl1271: uploading fw chunk 0xd156da0c to 0xda00
[  110.727722] wl1271: uploading fw chunk 0xd156dc0c to 0xdc00
[  110.734832] wl1271: uploading fw chunk 0xd156de0c to 0xde00
[  110.741943] wl1271: uploading fw chunk 0xd156e00c to 0xe000
[  110.749053] wl1271: uploading fw chunk 0xd156e20c to 0xe200
[  110.756164] wl1271: uploading fw chunk 0xd156e40c to 0xe400
[  110.762237] wl1271: uploading fw chunk 0xd156e60c to 0xe600
[  110.770111] wl1271: uploading fw chunk 0xd156e80c to 0xe800
[  110.777252] wl1271: uploading fw chunk 0xd156ea0c to 0xea00
[  110.784362] wl1271: uploading fw chunk 0xd156ec0c to 0xec00
[  110.791473] wl1271: uploading fw chunk 0xd156ee0c to 0xee00
[  110.798583] wl1271: uploading fw chunk 0xd156f00c to 0xf000
[  110.805694] wl1271: uploading fw chunk 0xd156f20c to 0xf200
[  110.812835] wl1271: uploading fw chunk 0xd156f40c to 0xf400
[  110.819946] wl1271: uploading fw chunk 0xd156f60c to 0xf600
[  110.827056] wl1271: uploading fw chunk 0xd156f80c to 0xf800
[  110.833099] wl1271: uploading fw chunk 0xd156fa0c to 0xfa00
[  110.841156] wl1271: uploading fw chunk 0xd156fc0c to 0xfc00
[  110.847198] wl1271: uploading fw chunk 0xd156fe0c to 0xfe00
[  110.855102] wl1271: uploading fw chunk 0xd157000c to 0x10000
[  110.862304] wl1271: uploading fw chunk 0xd157020c to 0x10200
[  110.869537] wl1271: uploading fw chunk 0xd157040c to 0x10400
[  110.876739] wl1271: uploading fw chunk 0xd157060c to 0x10600
[  110.884521] wl1271: uploading fw chunk 0xd157080c to 0x10800
[  110.891784] wl1271: uploading fw chunk 0xd1570a0c to 0x10a00
[  110.899017] wl1271: uploading fw chunk 0xd1570c0c to 0x10c00
[  110.906249] wl1271: uploading fw chunk 0xd1570e0c to 0x10e00
[  110.913452] wl1271: uploading fw chunk 0xd157100c to 0x11000
[  110.920684] wl1271: uploading fw chunk 0xd157120c to 0x11200
[  110.926818] wl1271: uploading fw chunk 0xd157140c to 0x11400
[  110.934783] wl1271: uploading fw chunk 0xd157160c to 0x11600
[  110.942016] wl1271: uploading fw chunk 0xd157180c to 0x11800
[  110.949218] wl1271: uploading fw chunk 0xd1571a0c to 0x11a00
[  110.956420] wl1271: uploading fw chunk 0xd1571c0c to 0x11c00
[  110.963623] wl1271: uploading fw chunk 0xd1571e0c to 0x11e00
[  110.970825] wl1271: uploading fw chunk 0xd157200c to 0x12000
[  110.978027] wl1271: uploading fw chunk 0xd157220c to 0x12200
[  110.985229] wl1271: uploading fw chunk 0xd157240c to 0x12400
[  110.992523] wl1271: uploading fw chunk 0xd157260c to 0x12600
[  110.999725] wl1271: uploading fw chunk 0xd157280c to 0x12800
[  111.007232] wl1271: uploading fw chunk 0xd1572a0c to 0x12a00
[  111.014495] wl1271: uploading fw chunk 0xd1572c0c to 0x12c00
[  111.020629] wl1271: uploading fw chunk 0xd1572e0c to 0x12e00
[  111.028839] wl1271: uploading fw chunk 0xd157300c to 0x13000
[  111.034973] wl1271: uploading fw chunk 0xd157320c to 0x13200
[  111.042968] wl1271: uploading fw chunk 0xd157340c to 0x13400
[  111.050170] wl1271: uploading fw chunk 0xd157360c to 0x13600
[  111.057403] wl1271: uploading fw chunk 0xd157380c to 0x13800
[  111.064605] wl1271: uploading fw chunk 0xd1573a0c to 0x13a00
[  111.071838] wl1271: uploading fw chunk 0xd1573c0c to 0x13c00
[  111.079040] wl1271: uploading fw chunk 0xd1573e0c to 0x13e00
[  111.086181] wl1271: uploading fw chunk 0xd157400c to 0x14000
[  111.093383] wl1271: uploading fw chunk 0xd157420c to 0x14200
[  111.100585] wl1271: uploading fw chunk 0xd157440c to 0x14400
[  111.107788] wl1271: uploading fw chunk 0xd157460c to 0x14600
[  111.113952] wl1271: uploading fw chunk 0xd157480c to 0x14800
[  111.121917] wl1271: uploading fw chunk 0xd1574a0c to 0x14a00
[  111.129119] wl1271: uploading fw chunk 0xd1574c0c to 0x14c00
[  111.136657] wl1271: uploading fw chunk 0xd1574e0c to 0x14e00
[  111.143920] wl1271: uploading fw chunk 0xd157500c to 0x15000
[  111.151153] wl1271: uploading fw chunk 0xd157520c to 0x15200
[  111.158386] wl1271: uploading fw chunk 0xd157540c to 0x15400
[  111.165588] wl1271: uploading fw chunk 0xd157560c to 0x15600
[  111.172790] wl1271: uploading fw chunk 0xd157580c to 0x15800
[  111.180847] wl1271: uploading fw chunk 0xd1575a0c to 0x15a00
[  111.188110] wl1271: uploading fw chunk 0xd1575c0c to 0x15c00
[  111.195465] wl1271: uploading fw chunk 0xd1575e0c to 0x15e00
[  111.202697] wl1271: uploading fw chunk 0xd157600c to 0x16000
[  111.209930] wl1271: uploading fw chunk 0xd157620c to 0x16200
[  111.217132] wl1271: uploading fw chunk 0xd157640c to 0x16400
[  111.223266] wl1271: uploading fw chunk 0xd157660c to 0x16600
[  111.231262] wl1271: uploading fw chunk 0xd157680c to 0x16800
[  111.238464] wl1271: uploading fw chunk 0xd1576a0c to 0x16a00
[  111.245697] wl1271: uploading fw chunk 0xd1576c0c to 0x16c00
[  111.252899] wl1271: uploading fw chunk 0xd1576e0c to 0x16e00
[  111.260345] wl1271: uploading fw chunk 0xd157700c to 0x17000
[  111.267578] wl1271: uploading fw chunk 0xd157720c to 0x17200
[  111.275726] wl1271: uploading fw chunk 0xd157740c to 0x17400
[  111.282958] wl1271: uploading fw chunk 0xd157760c to 0x17600
[  111.290191] wl1271: uploading fw chunk 0xd157780c to 0x17800
[  111.297515] wl1271: uploading fw chunk 0xd1577a0c to 0x17a00
[  111.304748] wl1271: uploading fw chunk 0xd1577c0c to 0x17c00
[  111.311981] wl1271: uploading fw chunk 0xd1577e0c to 0x17e00
[  111.319183] wl1271: uploading fw chunk 0xd157800c to 0x18000
[  111.325347] wl1271: uploading fw chunk 0xd157820c to 0x18200
[  111.333496] wl1271: uploading fw chunk 0xd157840c to 0x18400
[  111.339660] wl1271: uploading fw chunk 0xd157860c to 0x18600
[  111.347625] wl1271: uploading fw chunk 0xd157880c to 0x18800
[  111.354858] wl1271: uploading fw chunk 0xd1578a0c to 0x18a00
[  111.362274] wl1271: uploading fw chunk 0xd1578c0c to 0x18c00
[  111.369506] wl1271: uploading fw chunk 0xd1578e0c to 0x18e00
[  111.376770] wl1271: uploading fw chunk 0xd157900c to 0x19000
[  111.384185] wl1271: uploading fw chunk 0xd157920c to 0x19200
[  111.391418] wl1271: uploading fw chunk 0xd157940c to 0x19400
[  111.398651] wl1271: uploading fw chunk 0xd157960c to 0x19600
[  111.405883] wl1271: uploading fw chunk 0xd157980c to 0x19800
[  111.413085] wl1271: uploading fw chunk 0xd1579a0c to 0x19a00
[  111.420288] wl1271: uploading fw chunk 0xd1579c0c to 0x19c00
[  111.426422] wl1271: uploading fw chunk 0xd1579e0c to 0x19e00
[  111.434417] wl1271: uploading fw chunk 0xd157a00c to 0x1a000
[  111.441711] wl1271: uploading fw chunk 0xd157a20c to 0x1a200
[  111.448944] wl1271: uploading fw chunk 0xd157a40c to 0x1a400
[  111.456146] wl1271: uploading fw chunk 0xd157a60c to 0x1a600
[  111.463378] wl1271: uploading fw chunk 0xd157a80c to 0x1a800
[  111.470581] wl1271: uploading fw chunk 0xd157aa0c to 0x1aa00
[  111.477783] wl1271: uploading fw chunk 0xd157ac0c to 0x1ac00
[  111.485015] wl1271: uploading fw chunk 0xd157ae0c to 0x1ae00
[  111.492218] wl1271: uploading fw chunk 0xd157b00c to 0x1b000
[  111.499420] wl1271: uploading fw chunk 0xd157b20c to 0x1b200
[  111.506988] wl1271: uploading fw chunk 0xd157b40c to 0x1b400
[  111.514251] wl1271: uploading fw chunk 0xd157b60c to 0x1b600
[  111.520416] wl1271: uploading fw chunk 0xd157b80c to 0x1b800
[  111.528411] wl1271: uploading fw chunk 0xd157ba0c to 0x1ba00
[  111.535614] wl1271: uploading fw chunk 0xd157bc0c to 0x1bc00
[  111.542846] wl1271: uploading fw chunk 0xd157be0c to 0x1be00
[  111.550048] wl1271: uploading fw chunk 0xd157c00c to 0x1c000
[  111.557250] wl1271: uploading fw chunk 0xd157c20c to 0x1c200
[  111.564697] wl1271: uploading fw chunk 0xd157c40c to 0x1c400
[  111.571929] wl1271: uploading fw chunk 0xd157c60c to 0x1c600
[  111.579162] wl1271: uploading fw chunk 0xd157c80c to 0x1c800
[  111.586395] wl1271: uploading fw chunk 0xd157ca0c to 0x1ca00
[  111.593811] wl1271: uploading fw chunk 0xd157cc0c to 0x1cc00
[  111.601104] wl1271: uploading fw chunk 0xd157ce0c to 0x1ce00
[  111.608337] wl1271: uploading fw chunk 0xd157d00c to 0x1d000
[  111.615570] wl1271: uploading fw chunk 0xd157d20c to 0x1d200
[  111.621704] wl1271: uploading fw chunk 0xd157d40c to 0x1d400
[  111.629974] wl1271: uploading fw chunk 0xd157d60c to 0x1d600
[  111.637237] wl1271: uploading fw chunk 0xd157d80c to 0x1d800
[  111.644439] wl1271: uploading fw chunk 0xd157da0c to 0x1da00
[  111.651672] wl1271: uploading fw chunk 0xd157dc0c to 0x1dc00
[  111.658905] wl1271: uploading fw chunk 0xd157de0c to 0x1de00
[  111.666107] wl1271: uploading fw chunk 0xd157e00c to 0x1e000
[  111.673339] wl1271: uploading fw chunk 0xd157e20c to 0x1e200
[  111.680541] wl1271: uploading fw chunk 0xd157e40c to 0x1e400
[  111.687744] wl1271: uploading fw chunk 0xd157e60c to 0x1e600
[  111.695098] wl1271: uploading fw chunk 0xd157e80c to 0x1e800
[  111.702331] wl1271: uploading fw chunk 0xd157ea0c to 0x1ea00
[  111.709564] wl1271: uploading fw chunk 0xd157ec0c to 0x1ec00
[  111.715698] wl1271: uploading fw chunk 0xd157ee0c to 0x1ee00
[  111.723693] wl1271: uploading fw chunk 0xd157f00c to 0x1f000
[  111.730895] wl1271: uploading fw chunk 0xd157f20c to 0x1f200
[  111.738189] wl1271: uploading fw chunk 0xd157f40c to 0x1f400
[  111.745422] wl1271: uploading fw chunk 0xd157f60c to 0x1f600
[  111.752655] wl1271: uploading fw chunk 0xd157f80c to 0x1f800
[  111.760009] wl1271: uploading fw chunk 0xd157fa0c to 0x1fa00
[  111.767242] wl1271: uploading fw chunk 0xd157fc0c to 0x1fc00
[  111.774475] wl1271: uploading fw chunk 0xd157fe0c to 0x1fe00
[  111.781707] wl1271: uploading fw chunk 0xd158000c to 0x20000
[  111.788909] wl1271: uploading fw chunk 0xd158020c to 0x20200
[  111.796112] wl1271: uploading fw chunk 0xd158040c to 0x20400
[  111.803344] wl1271: uploading fw chunk 0xd158060c to 0x20600
[  111.809478] wl1271: uploading fw chunk 0xd158080c to 0x20800
[  111.817443] wl1271: uploading fw chunk 0xd1580a0c to 0x20a00
[  111.824645] wl1271: uploading fw chunk 0xd1580c0c to 0x20c00
[  111.831878] wl1271: uploading fw chunk 0xd1580e0c to 0x20e00
[  111.839050] wl1271: uploading fw chunk 0xd158100c to 0x21000
[  111.846282] wl1271: uploading fw chunk 0xd158120c to 0x21200
[  111.853485] wl1271: uploading fw chunk 0xd158140c to 0x21400
[  111.860687] wl1271: uploading fw chunk 0xd158160c to 0x21600
[  111.867889] wl1271: uploading fw chunk 0xd158180c to 0x21800
[  111.875091] wl1271: uploading fw chunk 0xd1581a0c to 0x21a00
[  111.882476] wl1271: uploading fw chunk 0xd1581c0c to 0x21c00
[  111.889709] wl1271: uploading fw chunk 0xd1581e0c to 0x21e00
[  111.896942] wl1271: uploading fw chunk 0xd158200c to 0x22000
[  111.903106] wl1271: uploading fw chunk 0xd158220c to 0x22200
[  111.911163] wl1271: uploading fw chunk 0xd158240c to 0x22400
[  111.918395] wl1271: uploading fw chunk 0xd158260c to 0x22600
[  111.925689] wl1271: uploading fw chunk 0xd158280c to 0x22800
[  111.932922] wl1271: uploading fw chunk 0xd1582a0c to 0x22a00
[  111.940155] wl1271: uploading fw chunk 0xd1582c0c to 0x22c00
[  111.947357] wl1271: uploading fw chunk 0xd1582e0c to 0x22e00
[  111.954559] wl1271: uploading fw chunk 0xd158300c to 0x23000
[  111.961791] wl1271: uploading fw chunk 0xd158320c to 0x23200
[  111.968994] wl1271: uploading fw chunk 0xd158340c to 0x23400
[  111.976196] wl1271: uploading fw chunk 0xd158360c to 0x23600
[  111.983398] wl1271: uploading fw chunk 0xd158380c to 0x23800
[  111.990631] wl1271: uploading fw chunk 0xd1583a0c to 0x23a00
[  111.996765] wl1271: uploading fw chunk 0xd1583c0c to 0x23c00
[  112.004730] wl1271: uploading fw chunk 0xd1583e0c to 0x23e00
[  112.012298] wl1271: uploading fw chunk 0xd158400c to 0x24000
[  112.020080] wl1271: uploading fw chunk 0xd158420c to 0x24200
[  112.027435] wl1271: uploading fw chunk 0xd158440c to 0x24400
[  112.034698] wl1271: uploading fw chunk 0xd158460c to 0x24600
[  112.041992] wl1271: uploading fw chunk 0xd158480c to 0x24800
[  112.049255] wl1271: uploading fw chunk 0xd1584a0c to 0x24a00
[  112.056457] wl1271: uploading fw chunk 0xd1584c0c to 0x24c00
[  112.063690] wl1271: uploading fw chunk 0xd1584e0c to 0x24e00
[  112.070892] wl1271: uploading fw chunk 0xd158500c to 0x25000
[  112.078124] wl1271: uploading fw chunk 0xd158520c to 0x25200
[  112.085327] wl1271: uploading fw chunk 0xd158540c to 0x25400
[  112.092529] wl1271: uploading fw chunk 0xd158560c to 0x25600
[  112.098663] wl1271: uploading fw chunk 0xd158580c to 0x25800
[  112.106628] wl1271: uploading fw chunk 0xd1585a0c to 0x25a00
[  112.113861] wl1271: uploading fw chunk 0xd1585c0c to 0x25c00
[  112.121063] wl1271: uploading fw chunk 0xd1585e0c to 0x25e00
[  112.128265] wl1271: uploading fw chunk 0xd158600c to 0x26000
[  112.135986] wl1271: uploading fw chunk 0xd158620c to 0x26200
[  112.143280] wl1271: uploading fw chunk 0xd158640c to 0x26400
[  112.150512] wl1271: uploading fw chunk 0xd158660c to 0x26600
[  112.157714] wl1271: uploading fw chunk 0xd158680c to 0x26800
[  112.164947] wl1271: uploading fw chunk 0xd1586a0c to 0x26a00
[  112.172149] wl1271: uploading fw chunk 0xd1586c0c to 0x26c00
[  112.179473] wl1271: uploading fw chunk 0xd1586e0c to 0x26e00
[  112.186737] wl1271: uploading fw chunk 0xd158700c to 0x27000
[  112.194061] wl1271: uploading fw chunk 0xd158720c to 0x27200
[  112.200225] wl1271: uploading fw chunk 0xd158740c to 0x27400
[  112.208404] wl1271: uploading fw chunk 0xd158760c to 0x27600
[  112.214569] wl1271: uploading fw chunk 0xd158780c to 0x27800
[  112.222564] wl1271: uploading fw chunk 0xd1587a0c to 0x27a00
[  112.229858] wl1271: uploading fw chunk 0xd1587c0c to 0x27c00
[  112.237091] wl1271: uploading fw chunk 0xd1587e0c to 0x27e00
[  112.244293] wl1271: uploading fw chunk 0xd158800c to 0x28000
[  112.251525] wl1271: uploading fw chunk 0xd158820c to 0x28200
[  112.258941] wl1271: uploading fw chunk 0xd158840c to 0x28400
[  112.266174] wl1271: uploading fw chunk 0xd158860c to 0x28600
[  112.273406] wl1271: uploading fw chunk 0xd158880c to 0x28800
[  112.280609] wl1271: uploading fw chunk 0xd1588a0c to 0x28a00
[  112.287811] wl1271: uploading fw chunk 0xd1588c0c to 0x28c00
[  112.293975] wl1271: uploading fw chunk 0xd1588e0c to 0x28e00
[  112.301940] wl1271: uploading fw chunk 0xd158900c to 0x29000
[  112.309143] wl1271: uploading fw chunk 0xd158920c to 0x29200
[  112.316375] wl1271: uploading fw chunk 0xd158940c to 0x29400
[  112.323577] wl1271: uploading fw chunk 0xd158960c to 0x29600
[  112.330444] wl1271: uploading fw chunk 0xd158980c to 0x29800
[  112.338775] wl1271: uploading fw chunk 0xd1589a0c to 0x29a00
[  112.346160] wl1271: uploading fw chunk 0xd1589c0c to 0x29c00
[  112.353424] wl1271: uploading fw chunk 0xd1589e0c to 0x29e00
[  112.360656] wl1271: uploading fw chunk 0xd158a00c to 0x2a000
[  112.367889] wl1271: uploading fw chunk 0xd158a20c to 0x2a200
[  112.375335] wl1271: uploading fw chunk 0xd158a40c to 0x2a400
[  112.382720] wl1271: uploading fw chunk 0xd158a60c to 0x2a600
[  112.389984] wl1271: uploading fw chunk 0xd158a80c to 0x2a800
[  112.397216] wl1271: uploading fw chunk 0xd158aa0c to 0x2aa00
[  112.403381] wl1271: uploading fw chunk 0xd158ac0c to 0x2ac00
[  112.411346] wl1271: uploading fw chunk 0xd158ae0c to 0x2ae00
[  112.418579] wl1271: uploading fw chunk 0xd158b00c to 0x2b000
[  112.425781] wl1271: uploading fw chunk 0xd158b20c to 0x2b200
[  112.432983] wl1271: uploading fw chunk 0xd158b40c to 0x2b400
[  112.440216] wl1271: uploading fw chunk 0xd158b60c to 0x2b600
[  112.447418] wl1271: uploading fw chunk 0xd158b80c to 0x2b800
[  112.454620] wl1271: uploading fw chunk 0xd158ba0c to 0x2ba00
[  112.461822] wl1271: uploading fw chunk 0xd158bc0c to 0x2bc00
[  112.469024] wl1271: uploading fw chunk 0xd158be0c to 0x2be00
[  112.476226] wl1271: uploading fw chunk 0xd158c00c to 0x2c000
[  112.483459] wl1271: uploading fw chunk 0xd158c20c to 0x2c200
[  112.490661] wl1271: uploading fw chunk 0xd158c40c to 0x2c400
[  112.496795] wl1271: uploading fw chunk 0xd158c60c to 0x2c600
[  112.504852] wl1271: uploading fw chunk 0xd158c80c to 0x2c800
[  112.512481] wl1271: uploading fw chunk 0xd158ca0c to 0x2ca00
[  112.519744] wl1271: uploading fw chunk 0xd158cc0c to 0x2cc00
[  112.526977] wl1271: uploading fw chunk 0xd158ce0c to 0x2ce00
[  112.534301] wl1271: uploading fw chunk 0xd158d00c to 0x2d000
[  112.541534] wl1271: uploading fw chunk 0xd158d20c to 0x2d200
[  112.548736] wl1271: uploading fw chunk 0xd158d40c to 0x2d400
[  112.555969] wl1271: uploading fw chunk 0xd158d60c to 0x2d600
[  112.563171] wl1271: uploading fw chunk 0xd158d80c to 0x2d800
[  112.570404] wl1271: uploading fw chunk 0xd158da0c to 0x2da00
[  112.577606] wl1271: uploading fw chunk 0xd158dc0c to 0x2dc00
[  112.584808] wl1271: uploading fw chunk 0xd158de0c to 0x2de00
[  112.592224] wl1271: uploading fw chunk 0xd158e00c to 0x2e000
[  112.598388] wl1271: uploading fw chunk 0xd158e20c to 0x2e200
[  112.606384] wl1271: uploading fw chunk 0xd158e40c to 0x2e400
[  112.613586] wl1271: uploading fw chunk 0xd158e60c to 0x2e600
[  112.621551] wl1271: uploading fw chunk 0xd158e80c to 0x2e800
[  112.628753] wl1271: uploading fw chunk 0xd158ea0c to 0x2ea00
[  112.636169] wl1271: uploading fw chunk 0xd158ec0c to 0x2ec00
[  112.643402] wl1271: uploading fw chunk 0xd158ee0c to 0x2ee00
[  112.650726] wl1271: uploading fw chunk 0xd158f00c to 0x2f000
[  112.657989] wl1271: uploading fw chunk 0xd158f20c to 0x2f200
[  112.665222] wl1271: uploading fw chunk 0xd158f40c to 0x2f400
[  112.672454] wl1271: uploading fw chunk 0xd158f60c to 0x2f600
[  112.679656] wl1271: uploading fw chunk 0xd158f80c to 0x2f800
[  112.686889] wl1271: uploading fw chunk 0xd158fa0c to 0x2fa00
[  112.694091] wl1271: uploading fw chunk 0xd158fc0c to 0x2fc00
[  112.700225] wl1271: uploading fw last chunk (4 B) 0xd158fe0c to 0x2fe00
[  112.709320] wl1271: chunk 4 addr 0x20000000 len 48972
[  112.714691] wl1271: starting firmware upload
[  112.719299] wl1271: fw_data_len 48972 chunk_size 512
[  112.727325] wl1271: uploading fw chunk 0xd158fe18 to 0x20000000
[  112.736938] wl1271: uploading fw chunk 0xd1590018 to 0x20000200
[  112.745178] wl1271: uploading fw chunk 0xd1590218 to 0x20000400
[  112.753387] wl1271: uploading fw chunk 0xd1590418 to 0x20000600
[  112.761596] wl1271: uploading fw chunk 0xd1590618 to 0x20000800
[  112.769836] wl1271: uploading fw chunk 0xd1590818 to 0x20000a00
[  112.778045] wl1271: uploading fw chunk 0xd1590a18 to 0x20000c00
[  112.786254] wl1271: uploading fw chunk 0xd1590c18 to 0x20000e00
[  112.794555] wl1271: uploading fw chunk 0xd1590e18 to 0x20001000
[  112.801727] wl1271: uploading fw chunk 0xd1591018 to 0x20001200
[  112.810821] wl1271: uploading fw chunk 0xd1591218 to 0x20001400
[  112.819183] wl1271: uploading fw chunk 0xd1591418 to 0x20001600
[  112.827423] wl1271: uploading fw chunk 0xd1591618 to 0x20001800
[  112.835632] wl1271: uploading fw chunk 0xd1591818 to 0x20001a00
[  112.843872] wl1271: uploading fw chunk 0xd1591a18 to 0x20001c00
[  112.852172] wl1271: uploading fw chunk 0xd1591c18 to 0x20001e00
[  112.860412] wl1271: uploading fw chunk 0xd1591e18 to 0x20002000
[  112.868804] wl1271: uploading fw chunk 0xd1592018 to 0x20002200
[  112.885711] wl1271: uploading fw chunk 0xd1592218 to 0x20002400
[  112.894317] wl1271: uploading fw chunk 0xd1592418 to 0x20002600
[  112.902770] wl1271: uploading fw chunk 0xd1592618 to 0x20002800
[  112.911071] wl1271: uploading fw chunk 0xd1592818 to 0x20002a00
[  112.919464] wl1271: uploading fw chunk 0xd1592a18 to 0x20002c00
[  112.926605] wl1271: uploading fw chunk 0xd1592c18 to 0x20002e00
[  112.936157] wl1271: uploading fw chunk 0xd1592e18 to 0x20003000
[  112.944458] wl1271: uploading fw chunk 0xd1593018 to 0x20003200
[  112.952728] wl1271: uploading fw chunk 0xd1593218 to 0x20003400
[  112.960937] wl1271: uploading fw chunk 0xd1593418 to 0x20003600
[  112.969146] wl1271: uploading fw chunk 0xd1593618 to 0x20003800
[  112.977355] wl1271: uploading fw chunk 0xd1593818 to 0x20003a00
[  112.985656] wl1271: uploading fw chunk 0xd1593a18 to 0x20003c00
[  112.993896] wl1271: uploading fw chunk 0xd1593c18 to 0x20003e00
[  113.002105] wl1271: uploading fw chunk 0xd1593e18 to 0x20004000
[  113.010620] wl1271: uploading fw chunk 0xd1594018 to 0x20004200
[  113.018859] wl1271: uploading fw chunk 0xd1594218 to 0x20004400
[  113.027099] wl1271: uploading fw chunk 0xd1594418 to 0x20004600
[  113.035308] wl1271: uploading fw chunk 0xd1594618 to 0x20004800
[  113.043518] wl1271: uploading fw chunk 0xd1594818 to 0x20004a00
[  113.051727] wl1271: uploading fw chunk 0xd1594a18 to 0x20004c00
[  113.059997] wl1271: uploading fw chunk 0xd1594c18 to 0x20004e00
[  113.067138] wl1271: uploading fw chunk 0xd1594e18 to 0x20005000
[  113.076202] wl1271: uploading fw chunk 0xd1595018 to 0x20005200
[  113.084381] wl1271: uploading fw chunk 0xd1595218 to 0x20005400
[  113.092590] wl1271: uploading fw chunk 0xd1595418 to 0x20005600
[  113.100799] wl1271: uploading fw chunk 0xd1595618 to 0x20005800
[  113.109008] wl1271: uploading fw chunk 0xd1595818 to 0x20005a00
[  113.117187] wl1271: uploading fw chunk 0xd1595a18 to 0x20005c00
[  113.130645] wl1271: uploading fw chunk 0xd1595c18 to 0x20005e00
[  113.137817] wl1271: uploading fw chunk 0xd1595e18 to 0x20006000
[  113.147216] wl1271: uploading fw chunk 0xd1596018 to 0x20006200
[  113.155487] wl1271: uploading fw chunk 0xd1596218 to 0x20006400
[  113.164306] wl1271: uploading fw chunk 0xd1596418 to 0x20006600
[  113.172607] wl1271: uploading fw chunk 0xd1596618 to 0x20006800
[  113.181365] wl1271: uploading fw chunk 0xd1596818 to 0x20006a00
[  113.189636] wl1271: uploading fw chunk 0xd1596a18 to 0x20006c00
[  113.198059] wl1271: uploading fw chunk 0xd1596c18 to 0x20006e00
[  113.206298] wl1271: uploading fw chunk 0xd1596e18 to 0x20007000
[  113.214538] wl1271: uploading fw chunk 0xd1597018 to 0x20007200
[  113.222747] wl1271: uploading fw chunk 0xd1597218 to 0x20007400
[  113.230957] wl1271: uploading fw chunk 0xd1597418 to 0x20007600
[  113.239166] wl1271: uploading fw chunk 0xd1597618 to 0x20007800
[  113.247436] wl1271: uploading fw chunk 0xd1597818 to 0x20007a00
[  113.254608] wl1271: uploading fw chunk 0xd1597a18 to 0x20007c00
[  113.263824] wl1271: uploading fw chunk 0xd1597c18 to 0x20007e00
[  113.272064] wl1271: uploading fw chunk 0xd1597e18 to 0x20008000
[  113.280303] wl1271: uploading fw chunk 0xd1598018 to 0x20008200
[  113.288513] wl1271: uploading fw chunk 0xd1598218 to 0x20008400
[  113.296722] wl1271: uploading fw chunk 0xd1598418 to 0x20008600
[  113.304931] wl1271: uploading fw chunk 0xd1598618 to 0x20008800
[  113.313812] wl1271: uploading fw chunk 0xd1598818 to 0x20008a00
[  113.322692] wl1271: uploading fw chunk 0xd1598a18 to 0x20008c00
[  113.335296] wl1271: uploading fw chunk 0xd1598c18 to 0x20008e00
[  113.343811] wl1271: uploading fw chunk 0xd1598e18 to 0x20009000
[  113.352142] wl1271: uploading fw chunk 0xd1599018 to 0x20009200
[  113.360443] wl1271: uploading fw chunk 0xd1599218 to 0x20009400
[  113.368652] wl1271: uploading fw chunk 0xd1599418 to 0x20009600
[  113.376892] wl1271: uploading fw chunk 0xd1599618 to 0x20009800
[  113.385253] wl1271: uploading fw chunk 0xd1599818 to 0x20009a00
[  113.393493] wl1271: uploading fw chunk 0xd1599a18 to 0x20009c00
[  113.401702] wl1271: uploading fw chunk 0xd1599c18 to 0x20009e00
[  113.409942] wl1271: uploading fw chunk 0xd1599e18 to 0x2000a000
[  113.418151] wl1271: uploading fw chunk 0xd159a018 to 0x2000a200
[  113.426330] wl1271: uploading fw chunk 0xd159a218 to 0x2000a400
[  113.434539] wl1271: uploading fw chunk 0xd159a418 to 0x2000a600
[  113.442810] wl1271: uploading fw chunk 0xd159a618 to 0x2000a800
[  113.449951] wl1271: uploading fw chunk 0xd159a818 to 0x2000aa00
[  113.460052] wl1271: uploading fw chunk 0xd159aa18 to 0x2000ac00
[  113.471771] wl1271: uploading fw chunk 0xd159ac18 to 0x2000ae00
[  113.480285] wl1271: uploading fw chunk 0xd159ae18 to 0x2000b000
[  113.488647] wl1271: uploading fw chunk 0xd159b018 to 0x2000b200
[  113.496917] wl1271: uploading fw chunk 0xd159b218 to 0x2000b400
[  113.505523] wl1271: uploading fw chunk 0xd159b418 to 0x2000b600
[  113.512664] wl1271: uploading fw chunk 0xd159b618 to 0x2000b800
[  113.521942] wl1271: uploading fw chunk 0xd159b818 to 0x2000ba00
[  113.530242] wl1271: uploading fw chunk 0xd159ba18 to 0x2000bc00
[  113.537750] wl1271: uploading fw last chunk (332 B) 0xd159bc18 to 0x2000be00
[  113.546539] wl1271: chunk 3 addr 0x40000 len 448
[  113.551422] wl1271: starting firmware upload
[  113.556060] wl1271: fw_data_len 448 chunk_size 512
[  113.563171] wl1271: uploading fw last chunk (448 B) 0xd159bd6c to 0x40000
[  113.572906] wl1271: chunk 2 addr 0x40be0 len 16432
[  113.578094] wl1271: starting firmware upload
[  113.582611] wl1271: fw_data_len 16432 chunk_size 512
[  113.591003] wl1271: uploading fw chunk 0xd159bf34 to 0x40be0
[  113.599548] wl1271: uploading fw chunk 0xd159c134 to 0x40de0
[  113.611755] wl1271: uploading fw chunk 0xd159c334 to 0x40fe0
[  113.619812] wl1271: uploading fw chunk 0xd159c534 to 0x411e0
[  113.627807] wl1271: uploading fw chunk 0xd159c734 to 0x413e0
[  113.636260] wl1271: uploading fw chunk 0xd159c934 to 0x415e0
[  113.644287] wl1271: uploading fw chunk 0xd159cb34 to 0x417e0
[  113.652252] wl1271: uploading fw chunk 0xd159cd34 to 0x419e0
[  113.660186] wl1271: uploading fw chunk 0xd159cf34 to 0x41be0
[  113.668182] wl1271: uploading fw chunk 0xd159d134 to 0x41de0
[  113.676147] wl1271: uploading fw chunk 0xd159d334 to 0x41fe0
[  113.684082] wl1271: uploading fw chunk 0xd159d534 to 0x421e0
[  113.692016] wl1271: uploading fw chunk 0xd159d734 to 0x423e0
[  113.699951] wl1271: uploading fw chunk 0xd159d934 to 0x425e0
[  113.707885] wl1271: uploading fw chunk 0xd159db34 to 0x427e0
[  113.715820] wl1271: uploading fw chunk 0xd159dd34 to 0x429e0
[  113.723724] wl1271: uploading fw chunk 0xd159df34 to 0x42be0
[  113.731658] wl1271: uploading fw chunk 0xd159e134 to 0x42de0
[  113.739990] wl1271: uploading fw chunk 0xd159e334 to 0x42fe0
[  113.751281] wl1271: uploading fw chunk 0xd159e534 to 0x431e0
[  113.759582] wl1271: uploading fw chunk 0xd159e734 to 0x433e0
[  113.767608] wl1271: uploading fw chunk 0xd159e934 to 0x435e0
[  113.775573] wl1271: uploading fw chunk 0xd159eb34 to 0x437e0
[  113.783538] wl1271: uploading fw chunk 0xd159ed34 to 0x439e0
[  113.791473] wl1271: uploading fw chunk 0xd159ef34 to 0x43be0
[  113.799407] wl1271: uploading fw chunk 0xd159f134 to 0x43de0
[  113.807342] wl1271: uploading fw chunk 0xd159f334 to 0x43fe0
[  113.815246] wl1271: uploading fw chunk 0xd159f534 to 0x441e0
[  113.823150] wl1271: uploading fw chunk 0xd159f734 to 0x443e0
[  113.831085] wl1271: uploading fw chunk 0xd159f934 to 0x445e0
[  113.838989] wl1271: uploading fw chunk 0xd159fb34 to 0x447e0
[  113.851226] wl1271: uploading fw chunk 0xd159fd34 to 0x449e0
[  113.858703] wl1271: uploading fw last chunk (48 B) 0xd159ff34 to 0x44be0
[  113.867340] wl1271: chunk 1 addr 0x312000 len 8092
[  113.872558] wl1271: starting firmware upload
[  113.877075] wl1271: fw_data_len 8092 chunk_size 512
[  113.885162] wl1271: uploading fw chunk 0xd159ff6c to 0x312000
[  113.894805] wl1271: uploading fw chunk 0xd15a016c to 0x312200
[  113.902893] wl1271: uploading fw chunk 0xd15a036c to 0x312400
[  113.910919] wl1271: uploading fw chunk 0xd15a056c to 0x312600
[  113.918945] wl1271: uploading fw chunk 0xd15a076c to 0x312800
[  113.926971] wl1271: uploading fw chunk 0xd15a096c to 0x312a00
[  113.935058] wl1271: uploading fw chunk 0xd15a0b6c to 0x312c00
[  113.946441] wl1271: uploading fw chunk 0xd15a0d6c to 0x312e00
[  113.954650] wl1271: uploading fw chunk 0xd15a0f6c to 0x313000
[  113.962738] wl1271: uploading fw chunk 0xd15a116c to 0x313200
[  113.971038] wl1271: uploading fw chunk 0xd15a136c to 0x313400
[  113.979095] wl1271: uploading fw chunk 0xd15a156c to 0x313600
[  113.987121] wl1271: uploading fw chunk 0xd15a176c to 0x313800
[  113.995147] wl1271: uploading fw chunk 0xd15a196c to 0x313a00
[  114.003173] wl1271: uploading fw chunk 0xd15a1b6c to 0x313c00
[  114.011413] wl1271: uploading fw last chunk (412 B) 0xd15a1d6c to 0x313e00
[  114.020294] wl1271: chunk 0 addr 0x316000 len 3784
[  114.025512] wl1271: starting firmware upload
[  114.030120] wl1271: fw_data_len 3784 chunk_size 512
[  114.038146] wl1271: uploading fw chunk 0xd15a1f10 to 0x316000
[  114.051025] wl1271: uploading fw chunk 0xd15a2110 to 0x316200
[  114.059234] wl1271: uploading fw chunk 0xd15a2310 to 0x316400
[  114.067321] wl1271: uploading fw chunk 0xd15a2510 to 0x316600
[  114.075408] wl1271: uploading fw chunk 0xd15a2710 to 0x316800
[  114.083648] wl1271: uploading fw chunk 0xd15a2910 to 0x316a00
[  114.090606] wl1271: uploading fw chunk 0xd15a2b10 to 0x316c00
[  114.098724] wl1271: uploading fw last chunk (200 B) 0xd15a2d10 to 0x316e00
[  114.107696] wl1271: chip id after firmware boot: 0x4030111
[  114.127716] wl1271: cmd_box_addr 0x407b4 event_box_addr 0x4ce58
[  114.135314] wl1271: acx event mbox mask
[  114.139495] wl1271: cmd configure
[  114.144683] wl1271: MBOX ptrs: 0x4ce58 0x4ceac
[  114.152191] wl1271: MBOX ptrs: 0x4ce58 0x4ceac
[  114.157135] wl1271: cmd test
[  114.161895] wl1271: FEM autodetect: manual, manufacturer: 1
[  114.161926] 
[  114.169830] wl1271: cmd test
[  114.182983] wl1271: cmd test
[  114.193603] wl1271: acx config ps
[  114.197143] wl1271: cmd configure
[  114.211547] wl1271: cmd template_set 2
[  114.217132] wl1271: cmd template_set 3
[  114.221679] wl1271: cmd template_set 0
[  114.228179] wl1271: cmd template_set 6
[  114.233734] wl1271: cmd template_set 5
[  114.238250] wl1271: cmd template_set 4
[  114.244506] wl1271: cmd template_set 1
[  114.250244] wl1271: cmd template_set 13
[  114.254852] wl1271: cmd template_set 7
[  114.261322] wl1271: cmd template_set 7
[  114.266876] wl1271: cmd template_set 7
[  114.272430] wl1271: cmd template_set 7
[  114.276947] wl1271: acx group address tbl
[  114.281311] wl1271: cmd configure
[  114.286560] wl1271: acx connection monitor parameters: disabled
[  114.292816] wl1271: cmd configure
[  114.300079] wl1271: acx beacon filter opt
[  114.304443] wl1271: cmd configure
[  114.309478] wl1271: acx beacon filter table
[  114.313995] wl1271: cmd configure
[  114.319854] wl1271: acx fm coex setting
[  114.324218] wl1271: cmd configure
[  114.333923] wl1271: acx bcn dtim options
[  114.338073] wl1271: cmd configure
[  114.344024] wl1271: acx sleep auth
[  114.347656] wl1271: cmd configure
[  114.353546] wl1271: acx rssi snr avg weights
[  114.358215] wl1271: cmd configure
[  114.363403] wl1271: acx rate policies
[  114.367401] wl1271: basic_rate: 0x3, full_rate: 0x3
[  114.372619] wl1271: cmd configure
[  114.380584] wl1271: wl1271 mem cfg
[  114.384185] wl1271: cmd configure
[  114.390106] wl1271: acx sg sta cfg
[  114.393707] wl1271: cmd configure
[  114.401733] wl1271: acx sg enable
[  114.405364] wl1271: cmd configure
[  114.410522] wl1271: acx mem map
[  114.413940] wl1271: cmd interrogate
[  114.420104] wl1271: acx rx msdu life time
[  114.424377] wl1271: cmd configure
[  114.430999] wl1271: acx rx config
[  114.434509] wl1271: cmd configure
[  114.440338] wl1271: acx data pd threshold
[  114.444702] wl1271: cmd configure
[  114.453155] wl1271: acx slot
[  114.456207] wl1271: cmd configure
[  114.463287] wl1271: acx service period timeout
[  114.468109] wl1271: cmd configure
[  114.473358] wl1271: acx rts threshold: 2353
[  114.477905] wl1271: cmd configure
[  114.483856] wl1271: acx dco itrim parameters
[  114.488403] wl1271: cmd configure
[  114.495056] wl1271: acx tx config options
[  114.499420] wl1271: cmd configure
[  114.504638] wl1271: wl1271 rx interrupt config
[  114.509765] wl1271: cmd configure
[  114.516540] wl1271: acx cca threshold
[  114.520446] wl1271: cmd configure
[  114.526336] wl1271: acx frag threshold: 2352
[  114.530944] wl1271: cmd configure
[  114.536132] wl1271: acx ac cfg 0 cw_ming 15 cw_max 63 aifs 3 txop 0
[  114.542846] wl1271: cmd configure
[  114.549560] wl1271: acx tid config
[  114.553253] wl1271: cmd configure
[  114.558410] wl1271: acx ac cfg 1 cw_ming 15 cw_max 63 aifs 7 txop 0
[  114.565155] wl1271: cmd configure
[  114.571838] wl1271: acx tid config
[  114.575531] wl1271: cmd configure
[  114.580688] wl1271: acx ac cfg 2 cw_ming 15 cw_max 63 aifs 1 txop 3008
[  114.587829] wl1271: cmd configure
[  114.594635] wl1271: acx tid config
[  114.598236] wl1271: cmd configure
[  114.607696] wl1271: acx ac cfg 3 cw_ming 15 cw_max 63 aifs 1 txop 1504
[  114.614746] wl1271: cmd configure
[  114.620239] wl1271: acx tid config
[  114.623962] wl1271: cmd configure
[  114.628936] wl1271: cmd data path
[  114.635955] wl1271: rx start cmd channel 1
[  114.642028] wl1271: tx start cmd channel 1
[  114.646453] wl1271: acx feature cfg
[  114.650146] wl1271: cmd configure
[  114.655578] wl1271: acx pm config
[  114.659118] wl1271: cmd configure
[  114.666381] wl1271: cmd set_default_wep_key 0
[  114.672698] wl1271: acx keep alive config
[  114.676971] wl1271: cmd configure
[  114.682861] wl1271: acx keep alive config
[  114.687194] wl1271: cmd configure
[  114.692352] wl1271: acx keep alive config
[  114.696716] wl1271: cmd configure
[  114.706695] wl1271: acx keep alive config
[  114.711120] wl1271: cmd configure
[  114.716461] wl1271: acx keep alive mode: 0
[  114.720794] wl1271: cmd configure
[  114.727478] wl1271: acx ba session setting
[  114.731933] wl1271: cmd configure
[  114.737121] wl1271: acx ba session setting
[  114.741546] wl1271: cmd configure
[  114.748138] wl1271: acx ba session setting
[  114.752471] wl1271: cmd configure
[  114.758575] wl1271: acx ba session setting
[  114.762908] wl1271: cmd configure
[  114.769104] wl1271: acx ba session setting
[  114.773590] wl1271: cmd configure
[  114.778839] wl1271: acx ba session setting
[  114.783203] wl1271: cmd configure
[  114.789825] wl1271: acx ba session setting
[  114.794281] wl1271: cmd configure
[  114.799530] wl1271: acx ba session setting
[  114.803955] wl1271: cmd configure
[  114.809753] wl1271: firmware booted (Rev 6.1.5.50.74)
[  114.815734] wl1271: acx slot
[  114.818908] wl1271: cmd configure
[  114.826690] wl1271: acx_set_preamble
[  114.830474] wl1271: cmd configure
[  114.836395] wl1271: acx_set_ctsprotect
[  114.840698] wl1271: cmd configure
[  114.849853] wl1271: acx rate policies
[  114.853759] wl1271: basic_rate: 0x1, full_rate: 0x3
[  114.859039] wl1271: cmd configure
[  114.867828] wl1271: acx rate policies
[  114.871734] wl1271: basic_rate: 0x1, full_rate: 0x1
[  114.877014] wl1271: cmd configure
[  114.882781] wl1271: acx keep alive config
[  114.887054] wl1271: cmd configure
[  114.894653] wl1271: acx dot11_cur_tx_pwr
[  114.898925] wl1271: cmd configure
[  114.904235] wl1271: acx ac cfg 3 cw_ming 7 cw_max 15 aifs 2 txop 3264
[  114.911041] wl1271: cmd configure
[  114.917816] wl1271: acx tid config
[  114.921539] wl1271: cmd configure
[  114.926727] wl1271: acx ac cfg 2 cw_ming 15 cw_max 31 aifs 2 txop 6016
[  114.933746] wl1271: cmd configure
[  114.940582] wl1271: acx tid config
[  114.944305] wl1271: cmd configure
[  114.949493] wl1271: acx ac cfg 0 cw_ming 31 cw_max 1023 aifs 3 txop 0
[  114.956390] wl1271: cmd configure
[  114.963073] wl1271: acx tid config
[  114.966796] wl1271: cmd configure
[  114.971954] wl1271: acx ac cfg 1 cw_ming 31 cw_max 1023 aifs 7 txop 0
[  114.978881] wl1271: cmd configure
[  114.989288] wl1271: acx tid config
[  114.993041] wl1271: cmd configure
[  115.000610] wl1271: acx group address tbl
[  115.004882] wl1271: cmd configure
root@cm-debian:~# [  115.022033] wl1271: elp work
[  115.025207] wl1271: chip to elp

root@cm-debian:~# ifconfig wlan0 down
[  127.561920] wl1271: waking up chip from elp
[  128.060485] wl1271: ERROR ELP wakeup timeout!
[  128.066558] wl1271: Hardware recovery in progress. FW ver: Rev 6.1.5.50.74 pc: 0x0
[  128.074951] wl1271: down
[  128.185699] ieee80211 phy0: Hardware restart was requested
root@cm-debian:~# 
root@cm-debian:~# ifconfig wlan0 up
[  133.334381] wl1271: chip id 0x4030111 (1271 PG20)
[  133.342620] wl1271: pause1 0x40f73
[  133.350219] wl1271: DRPW_SCRATCH_START 0031002c
[  133.355133] wl1271: clk2 0x80316a38
[  133.361785] wl1271: soft reset bootdata 0x0
[  133.371032] wl1271: nvs burst write 0x30546c: 0xbeef0000
[  133.378540] wl1271: nvs burst write 0x305470: 0xdead
[  133.385925] wl1271: ACX_EEPROMLESS_IND_REG
[  133.391540] wl1271: chip id 0x4030111
[  133.395538] wl1271: firmware chunks to be uploaded: 6
[  133.401000] wl1271: chunk 5 addr 0x0 len 196100
[  133.405853] wl1271: starting firmware upload
[  133.410675] wl1271: fw_data_len 196100 chunk_size 512
[  133.420379] wl1271: uploading fw chunk 0xd156000c to 0x0
[  133.426177] wl1271: uploading fw chunk 0xd156020c to 0x200
[  133.437103] wl1271: uploading fw chunk 0xd156040c to 0x400
[  133.444152] wl1271: uploading fw chunk 0xd156060c to 0x600
[  133.450134] wl1271: uploading fw chunk 0xd156080c to 0x800
[  133.457916] wl1271: uploading fw chunk 0xd1560a0c to 0xa00
[  133.464935] wl1271: uploading fw chunk 0xd1560c0c to 0xc00
[  133.471923] wl1271: uploading fw chunk 0xd1560e0c to 0xe00
[  133.478942] wl1271: uploading fw chunk 0xd156100c to 0x1000
[  133.486022] wl1271: uploading fw chunk 0xd156120c to 0x1200
[  133.493133] wl1271: uploading fw chunk 0xd156140c to 0x1400
[  133.500213] wl1271: uploading fw chunk 0xd156160c to 0x1600
[  133.507324] wl1271: uploading fw chunk 0xd156180c to 0x1800
[  133.514404] wl1271: uploading fw chunk 0xd1561a0c to 0x1a00
[  133.520477] wl1271: uploading fw chunk 0xd1561c0c to 0x1c00
[  133.528381] wl1271: uploading fw chunk 0xd1561e0c to 0x1e00
[  133.535491] wl1271: uploading fw chunk 0xd156200c to 0x2000
[  133.542602] wl1271: uploading fw chunk 0xd156220c to 0x2200
[  133.549713] wl1271: uploading fw chunk 0xd156240c to 0x2400
[  133.556793] wl1271: uploading fw chunk 0xd156260c to 0x2600
[  133.563903] wl1271: uploading fw chunk 0xd156280c to 0x2800
[  133.570983] wl1271: uploading fw chunk 0xd1562a0c to 0x2a00
[  133.580810] wl1271: uploading fw chunk 0xd1562c0c to 0x2c00
[  133.588195] wl1271: uploading fw chunk 0xd1562e0c to 0x2e00
[  133.595428] wl1271: uploading fw chunk 0xd156300c to 0x3000
[  133.602600] wl1271: uploading fw chunk 0xd156320c to 0x3200
[  133.609710] wl1271: uploading fw chunk 0xd156340c to 0x3400
[  133.616912] wl1271: uploading fw chunk 0xd156360c to 0x3600
[  133.624694] wl1271: uploading fw chunk 0xd156380c to 0x3800
[  133.631896] wl1271: uploading fw chunk 0xd1563a0c to 0x3a00
[  133.638061] wl1271: uploading fw chunk 0xd1563c0c to 0x3c00
[  133.645202] wl1271: uploading fw chunk 0xd1563e0c to 0x3e00
[  133.653106] wl1271: uploading fw chunk 0xd156400c to 0x4000
[  133.660217] wl1271: uploading fw chunk 0xd156420c to 0x4200
[  133.667358] wl1271: uploading fw chunk 0xd156440c to 0x4400
[  133.674438] wl1271: uploading fw chunk 0xd156460c to 0x4600
[  133.681549] wl1271: uploading fw chunk 0xd156480c to 0x4800
[  133.688720] wl1271: uploading fw chunk 0xd1564a0c to 0x4a00
[  133.697998] wl1271: uploading fw chunk 0xd1564c0c to 0x4c00
[  133.705352] wl1271: uploading fw chunk 0xd1564e0c to 0x4e00
[  133.712585] wl1271: uploading fw chunk 0xd156500c to 0x5000
[  133.719726] wl1271: uploading fw chunk 0xd156520c to 0x5200
[  133.727081] wl1271: uploading fw chunk 0xd156540c to 0x5400
[  133.734222] wl1271: uploading fw chunk 0xd156560c to 0x5600
[  133.741333] wl1271: uploading fw chunk 0xd156580c to 0x5800
[  133.748443] wl1271: uploading fw chunk 0xd1565a0c to 0x5a00
[  133.754486] wl1271: uploading fw chunk 0xd1565c0c to 0x5c00
[  133.762359] wl1271: uploading fw chunk 0xd1565e0c to 0x5e00
[  133.769470] wl1271: uploading fw chunk 0xd156600c to 0x6000
[  133.776550] wl1271: uploading fw chunk 0xd156620c to 0x6200
[  133.783660] wl1271: uploading fw chunk 0xd156640c to 0x6400
[  133.790771] wl1271: uploading fw chunk 0xd156660c to 0x6600
[  133.797851] wl1271: uploading fw chunk 0xd156680c to 0x6800
[  133.804962] wl1271: uploading fw chunk 0xd1566a0c to 0x6a00
[  133.812042] wl1271: uploading fw chunk 0xd1566c0c to 0x6c00
[  133.819152] wl1271: uploading fw chunk 0xd1566e0c to 0x6e00
[  133.825408] wl1271: uploading fw chunk 0xd156700c to 0x7000
[  133.836395] wl1271: uploading fw chunk 0xd156720c to 0x7200
[  133.843780] wl1271: uploading fw chunk 0xd156740c to 0x7400
[  133.851013] wl1271: uploading fw chunk 0xd156760c to 0x7600
[  133.858184] wl1271: uploading fw chunk 0xd156780c to 0x7800
[  133.864227] wl1271: uploading fw chunk 0xd1567a0c to 0x7a00
[  133.872131] wl1271: uploading fw chunk 0xd1567c0c to 0x7c00
[  133.879241] wl1271: uploading fw chunk 0xd1567e0c to 0x7e00
[  133.886352] wl1271: uploading fw chunk 0xd156800c to 0x8000
[  133.893463] wl1271: uploading fw chunk 0xd156820c to 0x8200
[  133.900543] wl1271: uploading fw chunk 0xd156840c to 0x8400
[  133.907653] wl1271: uploading fw chunk 0xd156860c to 0x8600
[  133.914733] wl1271: uploading fw chunk 0xd156880c to 0x8800
[  133.921813] wl1271: uploading fw chunk 0xd1568a0c to 0x8a00
[  133.928924] wl1271: uploading fw chunk 0xd1568c0c to 0x8c00
[  133.939422] wl1271: uploading fw chunk 0xd1568e0c to 0x8e00
[  133.946807] wl1271: uploading fw chunk 0xd156900c to 0x9000
[  133.954101] wl1271: uploading fw chunk 0xd156920c to 0x9200
[  133.961273] wl1271: uploading fw chunk 0xd156940c to 0x9400
[  133.968383] wl1271: uploading fw chunk 0xd156960c to 0x9600
[  133.975524] wl1271: uploading fw chunk 0xd156980c to 0x9800
[  133.981567] wl1271: uploading fw chunk 0xd1569a0c to 0x9a00
[  133.989440] wl1271: uploading fw chunk 0xd1569c0c to 0x9c00
[  133.996612] wl1271: uploading fw chunk 0xd1569e0c to 0x9e00
[  134.003753] wl1271: uploading fw chunk 0xd156a00c to 0xa000
[  134.011291] wl1271: uploading fw chunk 0xd156a20c to 0xa200
[  134.018524] wl1271: uploading fw chunk 0xd156a40c to 0xa400
[  134.025665] wl1271: uploading fw chunk 0xd156a60c to 0xa600
[  134.032775] wl1271: uploading fw chunk 0xd156a80c to 0xa800
[  134.039886] wl1271: uploading fw chunk 0xd156aa0c to 0xaa00
[  134.046997] wl1271: uploading fw chunk 0xd156ac0c to 0xac00
[  134.054077] wl1271: uploading fw chunk 0xd156ae0c to 0xae00
[  134.061157] wl1271: uploading fw chunk 0xd156b00c to 0xb000
[  134.067230] wl1271: uploading fw chunk 0xd156b20c to 0xb200
[  134.075073] wl1271: uploading fw chunk 0xd156b40c to 0xb400
[  134.082153] wl1271: uploading fw chunk 0xd156b60c to 0xb600
[  134.089263] wl1271: uploading fw chunk 0xd156b80c to 0xb800
[  134.096343] wl1271: uploading fw chunk 0xd156ba0c to 0xba00
[  134.103454] wl1271: uploading fw chunk 0xd156bc0c to 0xbc00
[  134.110534] wl1271: uploading fw chunk 0xd156be0c to 0xbe00
[  134.117645] wl1271: uploading fw chunk 0xd156c00c to 0xc000
[  134.124725] wl1271: uploading fw chunk 0xd156c20c to 0xc200
[  134.132446] wl1271: uploading fw chunk 0xd156c40c to 0xc400
[  134.143127] wl1271: uploading fw chunk 0xd156c60c to 0xc600
[  134.150543] wl1271: uploading fw chunk 0xd156c80c to 0xc800
[  134.157745] wl1271: uploading fw chunk 0xd156ca0c to 0xca00
[  134.164916] wl1271: uploading fw chunk 0xd156cc0c to 0xcc00
[  134.172058] wl1271: uploading fw chunk 0xd156ce0c to 0xce00
[  134.179290] wl1271: uploading fw chunk 0xd156d00c to 0xd000
[  134.186431] wl1271: uploading fw chunk 0xd156d20c to 0xd200
[  134.192474] wl1271: uploading fw chunk 0xd156d40c to 0xd400
[  134.200347] wl1271: uploading fw chunk 0xd156d60c to 0xd600
[  134.207580] wl1271: uploading fw chunk 0xd156d80c to 0xd800
[  134.214721] wl1271: uploading fw chunk 0xd156da0c to 0xda00
[  134.221832] wl1271: uploading fw chunk 0xd156dc0c to 0xdc00
[  134.228912] wl1271: uploading fw chunk 0xd156de0c to 0xde00
[  134.235992] wl1271: uploading fw chunk 0xd156e00c to 0xe000
[  134.243377] wl1271: uploading fw chunk 0xd156e20c to 0xe200
[  134.250518] wl1271: uploading fw chunk 0xd156e40c to 0xe400
[  134.259857] wl1271: uploading fw chunk 0xd156e60c to 0xe600
[  134.267242] wl1271: uploading fw chunk 0xd156e80c to 0xe800
[  134.274444] wl1271: uploading fw chunk 0xd156ea0c to 0xea00
[  134.281799] wl1271: uploading fw chunk 0xd156ec0c to 0xec00
[  134.288940] wl1271: uploading fw chunk 0xd156ee0c to 0xee00
[  134.296081] wl1271: uploading fw chunk 0xd156f00c to 0xf000
[  134.303314] wl1271: uploading fw chunk 0xd156f20c to 0xf200
[  134.309356] wl1271: uploading fw chunk 0xd156f40c to 0xf400
[  134.317260] wl1271: uploading fw chunk 0xd156f60c to 0xf600
[  134.324371] wl1271: uploading fw chunk 0xd156f80c to 0xf800
[  134.331481] wl1271: uploading fw chunk 0xd156fa0c to 0xfa00
[  134.338562] wl1271: uploading fw chunk 0xd156fc0c to 0xfc00
[  134.345367] wl1271: uploading fw chunk 0xd156fe0c to 0xfe00
[  134.353454] wl1271: uploading fw chunk 0xd157000c to 0x10000
[  134.360717] wl1271: uploading fw chunk 0xd157020c to 0x10200
[  134.367950] wl1271: uploading fw chunk 0xd157040c to 0x10400
[  134.377929] wl1271: uploading fw chunk 0xd157060c to 0x10600
[  134.385437] wl1271: uploading fw chunk 0xd157080c to 0x10800
[  134.392791] wl1271: uploading fw chunk 0xd1570a0c to 0x10a00
[  134.400054] wl1271: uploading fw chunk 0xd1570c0c to 0x10c00
[  134.407287] wl1271: uploading fw chunk 0xd1570e0c to 0x10e00
[  134.414489] wl1271: uploading fw chunk 0xd157100c to 0x11000
[  134.421691] wl1271: uploading fw chunk 0xd157120c to 0x11200
[  134.428863] wl1271: uploading fw chunk 0xd157140c to 0x11400
[  134.436065] wl1271: uploading fw chunk 0xd157160c to 0x11600
[  134.442230] wl1271: uploading fw chunk 0xd157180c to 0x11800
[  134.450256] wl1271: uploading fw chunk 0xd1571a0c to 0x11a00
[  134.457458] wl1271: uploading fw chunk 0xd1571c0c to 0x11c00
[  134.464660] wl1271: uploading fw chunk 0xd1571e0c to 0x11e00
[  134.471862] wl1271: uploading fw chunk 0xd157200c to 0x12000
[  134.479064] wl1271: uploading fw chunk 0xd157220c to 0x12200
[  134.486450] wl1271: uploading fw chunk 0xd157240c to 0x12400
[  134.493682] wl1271: uploading fw chunk 0xd157260c to 0x12600
[  134.503051] wl1271: uploading fw chunk 0xd157280c to 0x12800
[  134.510711] wl1271: uploading fw chunk 0xd1572a0c to 0x12a00
[  134.518035] wl1271: uploading fw chunk 0xd1572c0c to 0x12c00
[  134.525299] wl1271: uploading fw chunk 0xd1572e0c to 0x12e00
[  134.532531] wl1271: uploading fw chunk 0xd157300c to 0x13000
[  134.539733] wl1271: uploading fw chunk 0xd157320c to 0x13200
[  134.546936] wl1271: uploading fw chunk 0xd157340c to 0x13400
[  134.554138] wl1271: uploading fw chunk 0xd157360c to 0x13600
[  134.561309] wl1271: uploading fw chunk 0xd157380c to 0x13800
[  134.567474] wl1271: uploading fw chunk 0xd1573a0c to 0x13a00
[  134.576049] wl1271: uploading fw chunk 0xd1573c0c to 0x13c00
[  134.582214] wl1271: uploading fw chunk 0xd1573e0c to 0x13e00
[  134.590148] wl1271: uploading fw chunk 0xd157400c to 0x14000
[  134.597290] wl1271: uploading fw chunk 0xd157420c to 0x14200
[  134.604492] wl1271: uploading fw chunk 0xd157440c to 0x14400
[  134.611785] wl1271: uploading fw chunk 0xd157460c to 0x14600
[  134.618988] wl1271: uploading fw chunk 0xd157480c to 0x14800
[  134.626190] wl1271: uploading fw chunk 0xd1574a0c to 0x14a00
[  134.633392] wl1271: uploading fw chunk 0xd1574c0c to 0x14c00
[  134.642791] wl1271: uploading fw chunk 0xd1574e0c to 0x14e00
[  134.650299] wl1271: uploading fw chunk 0xd157500c to 0x15000
[  134.657653] wl1271: uploading fw chunk 0xd157520c to 0x15200
[  134.664916] wl1271: uploading fw chunk 0xd157540c to 0x15400
[  134.672119] wl1271: uploading fw chunk 0xd157560c to 0x15600
[  134.679351] wl1271: uploading fw chunk 0xd157580c to 0x15800
[  134.686553] wl1271: uploading fw chunk 0xd1575a0c to 0x15a00
[  134.693725] wl1271: uploading fw chunk 0xd1575c0c to 0x15c00
[  134.699890] wl1271: uploading fw chunk 0xd1575e0c to 0x15e00
[  134.707824] wl1271: uploading fw chunk 0xd157600c to 0x16000
[  134.715057] wl1271: uploading fw chunk 0xd157620c to 0x16200
[  134.722442] wl1271: uploading fw chunk 0xd157640c to 0x16400
[  134.729675] wl1271: uploading fw chunk 0xd157660c to 0x16600
[  134.736907] wl1271: uploading fw chunk 0xd157680c to 0x16800
[  134.744110] wl1271: uploading fw chunk 0xd1576a0c to 0x16a00
[  134.751312] wl1271: uploading fw chunk 0xd1576c0c to 0x16c00
[  134.758575] wl1271: uploading fw chunk 0xd1576e0c to 0x16e00
[  134.765808] wl1271: uploading fw chunk 0xd157700c to 0x17000
[  134.773010] wl1271: uploading fw chunk 0xd157720c to 0x17200
[  134.780944] wl1271: uploading fw chunk 0xd157740c to 0x17400
[  134.788116] wl1271: uploading fw chunk 0xd157760c to 0x17600
[  134.795288] wl1271: uploading fw chunk 0xd157780c to 0x17800
[  134.801452] wl1271: uploading fw chunk 0xd1577a0c to 0x17a00
[  134.809356] wl1271: uploading fw chunk 0xd1577c0c to 0x17c00
[  134.816558] wl1271: uploading fw chunk 0xd1577e0c to 0x17e00
[  134.823760] wl1271: uploading fw chunk 0xd157800c to 0x18000
[  134.830932] wl1271: uploading fw chunk 0xd157820c to 0x18200
[  134.838134] wl1271: uploading fw chunk 0xd157840c to 0x18400
[  134.845306] wl1271: uploading fw chunk 0xd157860c to 0x18600
[  134.852508] wl1271: uploading fw chunk 0xd157880c to 0x18800
[  134.859680] wl1271: uploading fw chunk 0xd1578a0c to 0x18a00
[  134.866882] wl1271: uploading fw chunk 0xd1578c0c to 0x18c00
[  134.874145] wl1271: uploading fw chunk 0xd1578e0c to 0x18e00
[  134.881347] wl1271: uploading fw chunk 0xd157900c to 0x19000
[  134.887481] wl1271: uploading fw chunk 0xd157920c to 0x19200
[  134.895446] wl1271: uploading fw chunk 0xd157940c to 0x19400
[  134.903289] wl1271: uploading fw chunk 0xd157960c to 0x19600
[  134.910644] wl1271: uploading fw chunk 0xd157980c to 0x19800
[  134.917999] wl1271: uploading fw chunk 0xd1579a0c to 0x19a00
[  134.925445] wl1271: uploading fw chunk 0xd1579c0c to 0x19c00
[  134.932678] wl1271: uploading fw chunk 0xd1579e0c to 0x19e00
[  134.939910] wl1271: uploading fw chunk 0xd157a00c to 0x1a000
[  134.947113] wl1271: uploading fw chunk 0xd157a20c to 0x1a200
[  134.954315] wl1271: uploading fw chunk 0xd157a40c to 0x1a400
[  134.961486] wl1271: uploading fw chunk 0xd157a60c to 0x1a600
[  134.968872] wl1271: uploading fw chunk 0xd157a80c to 0x1a800
[  134.976074] wl1271: uploading fw chunk 0xd157aa0c to 0x1aa00
[  134.983306] wl1271: uploading fw chunk 0xd157ac0c to 0x1ac00
[  134.989440] wl1271: uploading fw chunk 0xd157ae0c to 0x1ae00
[  134.997467] wl1271: uploading fw chunk 0xd157b00c to 0x1b000
[  135.003631] wl1271: uploading fw chunk 0xd157b20c to 0x1b200
[  135.011901] wl1271: uploading fw chunk 0xd157b40c to 0x1b400
[  135.019134] wl1271: uploading fw chunk 0xd157b60c to 0x1b600
[  135.026336] wl1271: uploading fw chunk 0xd157b80c to 0x1b800
[  135.033538] wl1271: uploading fw chunk 0xd157ba0c to 0x1ba00
[  135.040710] wl1271: uploading fw chunk 0xd157bc0c to 0x1bc00
[  135.047912] wl1271: uploading fw chunk 0xd157be0c to 0x1be00
[  135.055084] wl1271: uploading fw chunk 0xd157c00c to 0x1c000
[  135.062377] wl1271: uploading fw chunk 0xd157c20c to 0x1c200
[  135.069580] wl1271: uploading fw chunk 0xd157c40c to 0x1c400
[  135.076782] wl1271: uploading fw chunk 0xd157c60c to 0x1c600
[  135.082916] wl1271: uploading fw chunk 0xd157c80c to 0x1c800
[  135.090850] wl1271: uploading fw chunk 0xd157ca0c to 0x1ca00
[  135.098022] wl1271: uploading fw chunk 0xd157cc0c to 0x1cc00
[  135.105224] wl1271: uploading fw chunk 0xd157ce0c to 0x1ce00
[  135.112396] wl1271: uploading fw chunk 0xd157d00c to 0x1d000
[  135.119598] wl1271: uploading fw chunk 0xd157d20c to 0x1d200
[  135.126800] wl1271: uploading fw chunk 0xd157d40c to 0x1d400
[  135.133972] wl1271: uploading fw chunk 0xd157d60c to 0x1d600
[  135.141174] wl1271: uploading fw chunk 0xd157d80c to 0x1d800
[  135.148345] wl1271: uploading fw chunk 0xd157da0c to 0x1da00
[  135.155548] wl1271: uploading fw chunk 0xd157dc0c to 0x1dc00
[  135.162719] wl1271: uploading fw chunk 0xd157de0c to 0x1de00
[  135.168884] wl1271: uploading fw chunk 0xd157e00c to 0x1e000
[  135.176910] wl1271: uploading fw chunk 0xd157e20c to 0x1e200
[  135.184570] wl1271: uploading fw chunk 0xd157e40c to 0x1e400
[  135.191802] wl1271: uploading fw chunk 0xd157e60c to 0x1e600
[  135.199035] wl1271: uploading fw chunk 0xd157e80c to 0x1e800
[  135.206329] wl1271: uploading fw chunk 0xd157ea0c to 0x1ea00
[  135.213562] wl1271: uploading fw chunk 0xd157ec0c to 0x1ec00
[  135.220825] wl1271: uploading fw chunk 0xd157ee0c to 0x1ee00
[  135.228057] wl1271: uploading fw chunk 0xd157f00c to 0x1f000
[  135.235229] wl1271: uploading fw chunk 0xd157f20c to 0x1f200
[  135.242431] wl1271: uploading fw chunk 0xd157f40c to 0x1f400
[  135.249633] wl1271: uploading fw chunk 0xd157f60c to 0x1f600
[  135.256805] wl1271: uploading fw chunk 0xd157f80c to 0x1f800
[  135.263061] wl1271: uploading fw chunk 0xd157fa0c to 0x1fa00
[  135.269195] wl1271: uploading fw chunk 0xd157fc0c to 0x1fc00
[  135.278076] wl1271: uploading fw chunk 0xd157fe0c to 0x1fe00
[  135.285461] wl1271: uploading fw chunk 0xd158000c to 0x20000
[  135.292694] wl1271: uploading fw chunk 0xd158020c to 0x20200
[  135.299896] wl1271: uploading fw chunk 0xd158040c to 0x20400
[  135.307067] wl1271: uploading fw chunk 0xd158060c to 0x20600
[  135.314270] wl1271: uploading fw chunk 0xd158080c to 0x20800
[  135.321441] wl1271: uploading fw chunk 0xd1580a0c to 0x20a00
[  135.328643] wl1271: uploading fw chunk 0xd1580c0c to 0x20c00
[  135.335815] wl1271: uploading fw chunk 0xd1580e0c to 0x20e00
[  135.343017] wl1271: uploading fw chunk 0xd158100c to 0x21000
[  135.350189] wl1271: uploading fw chunk 0xd158120c to 0x21200
[  135.356323] wl1271: uploading fw chunk 0xd158140c to 0x21400
[  135.364318] wl1271: uploading fw chunk 0xd158160c to 0x21600
[  135.371520] wl1271: uploading fw chunk 0xd158180c to 0x21800
[  135.378723] wl1271: uploading fw chunk 0xd1581a0c to 0x21a00
[  135.385894] wl1271: uploading fw chunk 0xd1581c0c to 0x21c00
[  135.393096] wl1271: uploading fw chunk 0xd1581e0c to 0x21e00
[  135.400268] wl1271: uploading fw chunk 0xd158200c to 0x22000
[  135.407470] wl1271: uploading fw chunk 0xd158220c to 0x22200
[  135.414672] wl1271: uploading fw chunk 0xd158240c to 0x22400
[  135.421844] wl1271: uploading fw chunk 0xd158260c to 0x22600
[  135.429016] wl1271: uploading fw chunk 0xd158280c to 0x22800
[  135.436218] wl1271: uploading fw chunk 0xd1582a0c to 0x22a00
[  135.442352] wl1271: uploading fw chunk 0xd1582c0c to 0x22c00
[  135.450286] wl1271: uploading fw chunk 0xd1582e0c to 0x22e00
[  135.457489] wl1271: uploading fw chunk 0xd158300c to 0x23000
[  135.464691] wl1271: uploading fw chunk 0xd158320c to 0x23200
[  135.472137] wl1271: uploading fw chunk 0xd158340c to 0x23400
[  135.479522] wl1271: uploading fw chunk 0xd158360c to 0x23600
[  135.486724] wl1271: uploading fw chunk 0xd158380c to 0x23800
[  135.493927] wl1271: uploading fw chunk 0xd1583a0c to 0x23a00
[  135.501129] wl1271: uploading fw chunk 0xd1583c0c to 0x23c00
[  135.508331] wl1271: uploading fw chunk 0xd1583e0c to 0x23e00
[  135.515533] wl1271: uploading fw chunk 0xd158400c to 0x24000
[  135.522796] wl1271: uploading fw chunk 0xd158420c to 0x24200
[  135.529998] wl1271: uploading fw chunk 0xd158440c to 0x24400
[  135.536132] wl1271: uploading fw chunk 0xd158460c to 0x24600
[  135.544067] wl1271: uploading fw chunk 0xd158480c to 0x24800
[  135.551269] wl1271: uploading fw chunk 0xd1584a0c to 0x24a00
[  135.558441] wl1271: uploading fw chunk 0xd1584c0c to 0x24c00
[  135.565643] wl1271: uploading fw chunk 0xd1584e0c to 0x24e00
[  135.572814] wl1271: uploading fw chunk 0xd158500c to 0x25000
[  135.580017] wl1271: uploading fw chunk 0xd158520c to 0x25200
[  135.587188] wl1271: uploading fw chunk 0xd158540c to 0x25400
[  135.594390] wl1271: uploading fw chunk 0xd158560c to 0x25600
[  135.601562] wl1271: uploading fw chunk 0xd158580c to 0x25800
[  135.608764] wl1271: uploading fw chunk 0xd1585a0c to 0x25a00
[  135.616241] wl1271: uploading fw chunk 0xd1585c0c to 0x25c00
[  135.623474] wl1271: uploading fw chunk 0xd1585e0c to 0x25e00
[  135.629608] wl1271: uploading fw chunk 0xd158600c to 0x26000
[  135.637573] wl1271: uploading fw chunk 0xd158620c to 0x26200
[  135.644744] wl1271: uploading fw chunk 0xd158640c to 0x26400
[  135.651947] wl1271: uploading fw chunk 0xd158660c to 0x26600
[  135.659210] wl1271: uploading fw chunk 0xd158680c to 0x26800
[  135.666412] wl1271: uploading fw chunk 0xd1586a0c to 0x26a00
[  135.673614] wl1271: uploading fw chunk 0xd1586c0c to 0x26c00
[  135.681030] wl1271: uploading fw chunk 0xd1586e0c to 0x26e00
[  135.688232] wl1271: uploading fw chunk 0xd158700c to 0x27000
[  135.695434] wl1271: uploading fw chunk 0xd158720c to 0x27200
[  135.702636] wl1271: uploading fw chunk 0xd158740c to 0x27400
[  135.709808] wl1271: uploading fw chunk 0xd158760c to 0x27600
[  135.715972] wl1271: uploading fw chunk 0xd158780c to 0x27800
[  135.724182] wl1271: uploading fw chunk 0xd1587a0c to 0x27a00
[  135.730346] wl1271: uploading fw chunk 0xd1587c0c to 0x27c00
[  135.738311] wl1271: uploading fw chunk 0xd1587e0c to 0x27e00
[  135.745513] wl1271: uploading fw chunk 0xd158800c to 0x28000
[  135.752716] wl1271: uploading fw chunk 0xd158820c to 0x28200
[  135.759918] wl1271: uploading fw chunk 0xd158840c to 0x28400
[  135.767089] wl1271: uploading fw chunk 0xd158860c to 0x28600
[  135.774353] wl1271: uploading fw chunk 0xd158880c to 0x28800
[  135.781585] wl1271: uploading fw chunk 0xd1588a0c to 0x28a00
[  135.788757] wl1271: uploading fw chunk 0xd1588c0c to 0x28c00
[  135.795959] wl1271: uploading fw chunk 0xd1588e0c to 0x28e00
[  135.803161] wl1271: uploading fw chunk 0xd158900c to 0x29000
[  135.809295] wl1271: uploading fw chunk 0xd158920c to 0x29200
[  135.817321] wl1271: uploading fw chunk 0xd158940c to 0x29400
[  135.824554] wl1271: uploading fw chunk 0xd158960c to 0x29600
[  135.831756] wl1271: uploading fw chunk 0xd158980c to 0x29800
[  135.838928] wl1271: uploading fw chunk 0xd1589a0c to 0x29a00
[  135.846130] wl1271: uploading fw chunk 0xd1589c0c to 0x29c00
[  135.853332] wl1271: uploading fw chunk 0xd1589e0c to 0x29e00
[  135.860504] wl1271: uploading fw chunk 0xd158a00c to 0x2a000
[  135.867706] wl1271: uploading fw chunk 0xd158a20c to 0x2a200
[  135.874877] wl1271: uploading fw chunk 0xd158a40c to 0x2a400
[  135.882049] wl1271: uploading fw chunk 0xd158a60c to 0x2a600
[  135.889251] wl1271: uploading fw chunk 0xd158a80c to 0x2a800
[  135.895385] wl1271: uploading fw chunk 0xd158aa0c to 0x2aa00
[  135.903320] wl1271: uploading fw chunk 0xd158ac0c to 0x2ac00
[  135.910522] wl1271: uploading fw chunk 0xd158ae0c to 0x2ae00
[  135.917694] wl1271: uploading fw chunk 0xd158b00c to 0x2b000
[  135.924896] wl1271: uploading fw chunk 0xd158b20c to 0x2b200
[  135.932098] wl1271: uploading fw chunk 0xd158b40c to 0x2b400
[  135.939270] wl1271: uploading fw chunk 0xd158b60c to 0x2b600
[  135.946441] wl1271: uploading fw chunk 0xd158b80c to 0x2b800
[  135.953643] wl1271: uploading fw chunk 0xd158ba0c to 0x2ba00
[  135.960906] wl1271: uploading fw chunk 0xd158bc0c to 0x2bc00
[  135.968109] wl1271: uploading fw chunk 0xd158be0c to 0x2be00
[  135.975280] wl1271: uploading fw chunk 0xd158c00c to 0x2c000
[  135.981445] wl1271: uploading fw chunk 0xd158c20c to 0x2c200
[  135.989379] wl1271: uploading fw chunk 0xd158c40c to 0x2c400
[  135.996551] wl1271: uploading fw chunk 0xd158c60c to 0x2c600
[  136.003723] wl1271: uploading fw chunk 0xd158c80c to 0x2c800
[  136.011260] wl1271: uploading fw chunk 0xd158ca0c to 0x2ca00
[  136.018951] wl1271: uploading fw chunk 0xd158cc0c to 0x2cc00
[  136.026275] wl1271: uploading fw chunk 0xd158ce0c to 0x2ce00
[  136.033508] wl1271: uploading fw chunk 0xd158d00c to 0x2d000
[  136.040710] wl1271: uploading fw chunk 0xd158d20c to 0x2d200
[  136.047912] wl1271: uploading fw chunk 0xd158d40c to 0x2d400
[  136.055114] wl1271: uploading fw chunk 0xd158d60c to 0x2d600
[  136.062286] wl1271: uploading fw chunk 0xd158d80c to 0x2d800
[  136.069488] wl1271: uploading fw chunk 0xd158da0c to 0x2da00
[  136.076782] wl1271: uploading fw chunk 0xd158dc0c to 0x2dc00
[  136.082916] wl1271: uploading fw chunk 0xd158de0c to 0x2de00
[  136.090881] wl1271: uploading fw chunk 0xd158e00c to 0x2e000
[  136.098083] wl1271: uploading fw chunk 0xd158e20c to 0x2e200
[  136.105285] wl1271: uploading fw chunk 0xd158e40c to 0x2e400
[  136.112487] wl1271: uploading fw chunk 0xd158e60c to 0x2e600
[  136.121063] wl1271: uploading fw chunk 0xd158e80c to 0x2e800
[  136.128356] wl1271: uploading fw chunk 0xd158ea0c to 0x2ea00
[  136.135589] wl1271: uploading fw chunk 0xd158ec0c to 0x2ec00
[  136.142822] wl1271: uploading fw chunk 0xd158ee0c to 0x2ee00
[  136.150054] wl1271: uploading fw chunk 0xd158f00c to 0x2f000
[  136.157257] wl1271: uploading fw chunk 0xd158f20c to 0x2f200
[  136.164428] wl1271: uploading fw chunk 0xd158f40c to 0x2f400
[  136.171630] wl1271: uploading fw chunk 0xd158f60c to 0x2f600
[  136.178955] wl1271: uploading fw chunk 0xd158f80c to 0x2f800
[  136.186187] wl1271: uploading fw chunk 0xd158fa0c to 0x2fa00
[  136.192321] wl1271: uploading fw chunk 0xd158fc0c to 0x2fc00
[  136.200256] wl1271: uploading fw last chunk (4 B) 0xd158fe0c to 0x2fe00
[  136.208679] wl1271: chunk 4 addr 0x20000000 len 48972
[  136.214050] wl1271: starting firmware upload
[  136.218658] wl1271: fw_data_len 48972 chunk_size 512
[  136.226654] wl1271: uploading fw chunk 0xd158fe18 to 0x20000000
[  136.236206] wl1271: uploading fw chunk 0xd1590018 to 0x20000200
[  136.244415] wl1271: uploading fw chunk 0xd1590218 to 0x20000400
[  136.252624] wl1271: uploading fw chunk 0xd1590418 to 0x20000600
[  136.260833] wl1271: uploading fw chunk 0xd1590618 to 0x20000800
[  136.269104] wl1271: uploading fw chunk 0xd1590818 to 0x20000a00
[  136.277343] wl1271: uploading fw chunk 0xd1590a18 to 0x20000c00
[  136.285766] wl1271: uploading fw chunk 0xd1590c18 to 0x20000e00
[  136.294006] wl1271: uploading fw chunk 0xd1590e18 to 0x20001000
[  136.302276] wl1271: uploading fw chunk 0xd1591018 to 0x20001200
[  136.309448] wl1271: uploading fw chunk 0xd1591218 to 0x20001400
[  136.318511] wl1271: uploading fw chunk 0xd1591418 to 0x20001600
[  136.326751] wl1271: uploading fw chunk 0xd1591618 to 0x20001800
[  136.334991] wl1271: uploading fw chunk 0xd1591818 to 0x20001a00
[  136.344665] wl1271: uploading fw chunk 0xd1591a18 to 0x20001c00
[  136.353057] wl1271: uploading fw chunk 0xd1591c18 to 0x20001e00
[  136.361358] wl1271: uploading fw chunk 0xd1591e18 to 0x20002000
[  136.369598] wl1271: uploading fw chunk 0xd1592018 to 0x20002200
[  136.378021] wl1271: uploading fw chunk 0xd1592218 to 0x20002400
[  136.386260] wl1271: uploading fw chunk 0xd1592418 to 0x20002600
[  136.394561] wl1271: uploading fw chunk 0xd1592618 to 0x20002800
[  136.402770] wl1271: uploading fw chunk 0xd1592818 to 0x20002a00
[  136.411010] wl1271: uploading fw chunk 0xd1592a18 to 0x20002c00
[  136.419494] wl1271: uploading fw chunk 0xd1592c18 to 0x20002e00
[  136.426635] wl1271: uploading fw chunk 0xd1592e18 to 0x20003000
[  136.435729] wl1271: uploading fw chunk 0xd1593018 to 0x20003200
[  136.444091] wl1271: uploading fw chunk 0xd1593218 to 0x20003400
[  136.452301] wl1271: uploading fw chunk 0xd1593418 to 0x20003600
[  136.460510] wl1271: uploading fw chunk 0xd1593618 to 0x20003800
[  136.468719] wl1271: uploading fw chunk 0xd1593818 to 0x20003a00
[  136.476928] wl1271: uploading fw chunk 0xd1593a18 to 0x20003c00
[  136.485137] wl1271: uploading fw chunk 0xd1593c18 to 0x20003e00
[  136.493347] wl1271: uploading fw chunk 0xd1593e18 to 0x20004000
[  136.501556] wl1271: uploading fw chunk 0xd1594018 to 0x20004200
[  136.509735] wl1271: uploading fw chunk 0xd1594218 to 0x20004400
[  136.517944] wl1271: uploading fw chunk 0xd1594418 to 0x20004600
[  136.526153] wl1271: uploading fw chunk 0xd1594618 to 0x20004800
[  136.534332] wl1271: uploading fw chunk 0xd1594818 to 0x20004a00
[  136.542541] wl1271: uploading fw chunk 0xd1594a18 to 0x20004c00
[  136.550750] wl1271: uploading fw chunk 0xd1594c18 to 0x20004e00
[  136.558929] wl1271: uploading fw chunk 0xd1594e18 to 0x20005000
[  136.567138] wl1271: uploading fw chunk 0xd1595018 to 0x20005200
[  136.575317] wl1271: uploading fw chunk 0xd1595218 to 0x20005400
[  136.583618] wl1271: uploading fw chunk 0xd1595418 to 0x20005600
[  136.590789] wl1271: uploading fw chunk 0xd1595618 to 0x20005800
[  136.599853] wl1271: uploading fw chunk 0xd1595818 to 0x20005a00
[  136.608154] wl1271: uploading fw chunk 0xd1595a18 to 0x20005c00
[  136.617187] wl1271: uploading fw chunk 0xd1595c18 to 0x20005e00
[  136.625549] wl1271: uploading fw chunk 0xd1595e18 to 0x20006000
[  136.633789] wl1271: uploading fw chunk 0xd1596018 to 0x20006200
[  136.642028] wl1271: uploading fw chunk 0xd1596218 to 0x20006400
[  136.650238] wl1271: uploading fw chunk 0xd1596418 to 0x20006600
[  136.658447] wl1271: uploading fw chunk 0xd1596618 to 0x20006800
[  136.666687] wl1271: uploading fw chunk 0xd1596818 to 0x20006a00
[  136.674865] wl1271: uploading fw chunk 0xd1596a18 to 0x20006c00
[  136.683105] wl1271: uploading fw chunk 0xd1596c18 to 0x20006e00
[  136.691284] wl1271: uploading fw chunk 0xd1596e18 to 0x20007000
[  136.699493] wl1271: uploading fw chunk 0xd1597018 to 0x20007200
[  136.707702] wl1271: uploading fw chunk 0xd1597218 to 0x20007400
[  136.715881] wl1271: uploading fw chunk 0xd1597418 to 0x20007600
[  136.724182] wl1271: uploading fw chunk 0xd1597618 to 0x20007800
[  136.731323] wl1271: uploading fw chunk 0xd1597818 to 0x20007a00
[  136.740478] wl1271: uploading fw chunk 0xd1597a18 to 0x20007c00
[  136.748718] wl1271: uploading fw chunk 0xd1597c18 to 0x20007e00
[  136.757141] wl1271: uploading fw chunk 0xd1597e18 to 0x20008000
[  136.765380] wl1271: uploading fw chunk 0xd1598018 to 0x20008200
[  136.773590] wl1271: uploading fw chunk 0xd1598218 to 0x20008400
[  136.781890] wl1271: uploading fw chunk 0xd1598418 to 0x20008600
[  136.790130] wl1271: uploading fw chunk 0xd1598618 to 0x20008800
[  136.798339] wl1271: uploading fw chunk 0xd1598818 to 0x20008a00
[  136.806549] wl1271: uploading fw chunk 0xd1598a18 to 0x20008c00
[  136.814758] wl1271: uploading fw chunk 0xd1598c18 to 0x20008e00
[  136.822967] wl1271: uploading fw chunk 0xd1598e18 to 0x20009000
[  136.831146] wl1271: uploading fw chunk 0xd1599018 to 0x20009200
[  136.839355] wl1271: uploading fw chunk 0xd1599218 to 0x20009400
[  136.847564] wl1271: uploading fw chunk 0xd1599418 to 0x20009600
[  136.855773] wl1271: uploading fw chunk 0xd1599618 to 0x20009800
[  136.863983] wl1271: uploading fw chunk 0xd1599818 to 0x20009a00
[  136.872192] wl1271: uploading fw chunk 0xd1599a18 to 0x20009c00
[  136.880737] wl1271: uploading fw chunk 0xd1599c18 to 0x20009e00
[  136.887878] wl1271: uploading fw chunk 0xd1599e18 to 0x2000a000
[  136.896972] wl1271: uploading fw chunk 0xd159a018 to 0x2000a200
[  136.905212] wl1271: uploading fw chunk 0xd159a218 to 0x2000a400
[  136.913452] wl1271: uploading fw chunk 0xd159a418 to 0x2000a600
[  136.921630] wl1271: uploading fw chunk 0xd159a618 to 0x2000a800
[  136.929870] wl1271: uploading fw chunk 0xd159a818 to 0x2000aa00
[  136.938140] wl1271: uploading fw chunk 0xd159aa18 to 0x2000ac00
[  136.946350] wl1271: uploading fw chunk 0xd159ac18 to 0x2000ae00
[  136.954559] wl1271: uploading fw chunk 0xd159ae18 to 0x2000b000
[  136.962799] wl1271: uploading fw chunk 0xd159b018 to 0x2000b200
[  136.971008] wl1271: uploading fw chunk 0xd159b218 to 0x2000b400
[  136.979187] wl1271: uploading fw chunk 0xd159b418 to 0x2000b600
[  136.987396] wl1271: uploading fw chunk 0xd159b618 to 0x2000b800
[  136.995605] wl1271: uploading fw chunk 0xd159b818 to 0x2000ba00
[  137.003814] wl1271: uploading fw chunk 0xd159ba18 to 0x2000bc00
[  137.011596] wl1271: uploading fw last chunk (332 B) 0xd159bc18 to 0x2000be00
[  137.020355] wl1271: chunk 3 addr 0x40000 len 448
[  137.025360] wl1271: starting firmware upload
[  137.029937] wl1271: fw_data_len 448 chunk_size 512
[  137.037048] wl1271: uploading fw last chunk (448 B) 0xd159bd6c to 0x40000
[  137.045837] wl1271: chunk 2 addr 0x40be0 len 16432
[  137.050933] wl1271: starting firmware upload
[  137.055541] wl1271: fw_data_len 16432 chunk_size 512
[  137.065856] wl1271: uploading fw chunk 0xd159bf34 to 0x40be0
[  137.073760] wl1271: uploading fw chunk 0xd159c134 to 0x40de0
[  137.081695] wl1271: uploading fw chunk 0xd159c334 to 0x40fe0
[  137.089599] wl1271: uploading fw chunk 0xd159c534 to 0x411e0
[  137.097503] wl1271: uploading fw chunk 0xd159c734 to 0x413e0
[  137.105499] wl1271: uploading fw chunk 0xd159c934 to 0x415e0
[  137.113403] wl1271: uploading fw chunk 0xd159cb34 to 0x417e0
[  137.121337] wl1271: uploading fw chunk 0xd159cd34 to 0x419e0
[  137.129272] wl1271: uploading fw chunk 0xd159cf34 to 0x41be0
[  137.137176] wl1271: uploading fw chunk 0xd159d134 to 0x41de0
[  137.145111] wl1271: uploading fw chunk 0xd159d334 to 0x41fe0
[  137.153015] wl1271: uploading fw chunk 0xd159d534 to 0x421e0
[  137.161285] wl1271: uploading fw chunk 0xd159d734 to 0x423e0
[  137.169311] wl1271: uploading fw chunk 0xd159d934 to 0x425e0
[  137.176208] wl1271: uploading fw chunk 0xd159db34 to 0x427e0
[  137.185485] wl1271: uploading fw chunk 0xd159dd34 to 0x429e0
[  137.192352] wl1271: uploading fw chunk 0xd159df34 to 0x42be0
[  137.201293] wl1271: uploading fw chunk 0xd159e134 to 0x42de0
[  137.208160] wl1271: uploading fw chunk 0xd159e334 to 0x42fe0
[  137.216949] wl1271: uploading fw chunk 0xd159e534 to 0x431e0
[  137.223846] wl1271: uploading fw chunk 0xd159e734 to 0x433e0
[  137.232635] wl1271: uploading fw chunk 0xd159e934 to 0x435e0
[  137.240570] wl1271: uploading fw chunk 0xd159eb34 to 0x437e0
[  137.248504] wl1271: uploading fw chunk 0xd159ed34 to 0x439e0
[  137.256439] wl1271: uploading fw chunk 0xd159ef34 to 0x43be0
[  137.264495] wl1271: uploading fw chunk 0xd159f134 to 0x43de0
[  137.272460] wl1271: uploading fw chunk 0xd159f334 to 0x43fe0
[  137.280395] wl1271: uploading fw chunk 0xd159f534 to 0x441e0
[  137.288543] wl1271: uploading fw chunk 0xd159f734 to 0x443e0
[  137.296478] wl1271: uploading fw chunk 0xd159f934 to 0x445e0
[  137.304412] wl1271: uploading fw chunk 0xd159fb34 to 0x447e0
[  137.312347] wl1271: uploading fw chunk 0xd159fd34 to 0x449e0
[  137.319519] wl1271: uploading fw last chunk (48 B) 0xd159ff34 to 0x44be0
[  137.327819] wl1271: chunk 1 addr 0x312000 len 8092
[  137.332916] wl1271: starting firmware upload
[  137.337524] wl1271: fw_data_len 8092 chunk_size 512
[  137.345397] wl1271: uploading fw chunk 0xd159ff6c to 0x312000
[  137.354766] wl1271: uploading fw chunk 0xd15a016c to 0x312200
[  137.362792] wl1271: uploading fw chunk 0xd15a036c to 0x312400
[  137.370788] wl1271: uploading fw chunk 0xd15a056c to 0x312600
[  137.378814] wl1271: uploading fw chunk 0xd15a076c to 0x312800
[  137.386901] wl1271: uploading fw chunk 0xd15a096c to 0x312a00
[  137.394958] wl1271: uploading fw chunk 0xd15a0b6c to 0x312c00
[  137.403137] wl1271: uploading fw chunk 0xd15a0d6c to 0x312e00
[  137.411163] wl1271: uploading fw chunk 0xd15a0f6c to 0x313000
[  137.419464] wl1271: uploading fw chunk 0xd15a116c to 0x313200
[  137.426422] wl1271: uploading fw chunk 0xd15a136c to 0x313400
[  137.435424] wl1271: uploading fw chunk 0xd15a156c to 0x313600
[  137.442382] wl1271: uploading fw chunk 0xd15a176c to 0x313800
[  137.451263] wl1271: uploading fw chunk 0xd15a196c to 0x313a00
[  137.458221] wl1271: uploading fw chunk 0xd15a1b6c to 0x313c00
[  137.466369] wl1271: uploading fw last chunk (412 B) 0xd15a1d6c to 0x313e00
[  137.473815] wl1271: chunk 0 addr 0x316000 len 3784
[  137.478973] wl1271: starting firmware upload
[  137.483551] wl1271: fw_data_len 3784 chunk_size 512
[  137.490875] wl1271: uploading fw chunk 0xd15a1f10 to 0x316000
[  137.499572] wl1271: uploading fw chunk 0xd15a2110 to 0x316200
[  137.509582] wl1271: uploading fw chunk 0xd15a2310 to 0x316400
[  137.517608] wl1271: uploading fw chunk 0xd15a2510 to 0x316600
[  137.525604] wl1271: uploading fw chunk 0xd15a2710 to 0x316800
[  137.533630] wl1271: uploading fw chunk 0xd15a2910 to 0x316a00
[  137.541625] wl1271: uploading fw chunk 0xd15a2b10 to 0x316c00
[  137.548919] wl1271: uploading fw last chunk (200 B) 0xd15a2d10 to 0x316e00
[  137.557769] wl1271: chip id after firmware boot: 0x4030111
[  140.627502] wl1271: ERROR timeout waiting for the hardware to complete initialization
[  140.638031] omap_device: omap_i2c.1: new worst case deactivate latency 0: 91552
[  141.349945] wl1271: chip id 0x4030111 (1271 PG20)
[  141.358001] wl1271: pause1 0x40f73
[  141.363067] wl1271: DRPW_SCRATCH_START 0031002c
[  141.369812] wl1271: clk2 0x80316a38
[  141.375701] wl1271: soft reset bootdata 0x0
[  141.384735] wl1271: nvs burst write 0x30546c: 0xbeef0000
[  141.392181] wl1271: nvs burst write 0x305470: 0xdead
[  141.399536] wl1271: ACX_EEPROMLESS_IND_REG
[  141.405151] wl1271: chip id 0x4030111
[  141.409149] wl1271: firmware chunks to be uploaded: 6
[  141.414764] wl1271: chunk 5 addr 0x0 len 196100
[  141.419616] wl1271: starting firmware upload
[  141.424133] wl1271: fw_data_len 196100 chunk_size 512
[  141.431854] wl1271: uploading fw chunk 0xd156000c to 0x0
[  141.437713] wl1271: uploading fw chunk 0xd156020c to 0x200
[  141.448181] wl1271: uploading fw chunk 0xd156040c to 0x400
[  141.455200] wl1271: uploading fw chunk 0xd156060c to 0x600
[  141.462219] wl1271: uploading fw chunk 0xd156080c to 0x800
[  141.469299] wl1271: uploading fw chunk 0xd1560a0c to 0xa00
[  141.476318] wl1271: uploading fw chunk 0xd1560c0c to 0xc00
[  141.483337] wl1271: uploading fw chunk 0xd1560e0c to 0xe00
[  141.489288] wl1271: uploading fw chunk 0xd156100c to 0x1000
[  141.497161] wl1271: uploading fw chunk 0xd156120c to 0x1200
[  141.504241] wl1271: uploading fw chunk 0xd156140c to 0x1400
[  141.511352] wl1271: uploading fw chunk 0xd156160c to 0x1600
[  141.518524] wl1271: uploading fw chunk 0xd156180c to 0x1800
[  141.525604] wl1271: uploading fw chunk 0xd1561a0c to 0x1a00
[  141.532714] wl1271: uploading fw chunk 0xd1561c0c to 0x1c00
[  141.539794] wl1271: uploading fw chunk 0xd1561e0c to 0x1e00
[  141.546905] wl1271: uploading fw chunk 0xd156200c to 0x2000
[  141.553985] wl1271: uploading fw chunk 0xd156220c to 0x2200
[  141.561096] wl1271: uploading fw chunk 0xd156240c to 0x2400
[  141.567138] wl1271: uploading fw chunk 0xd156260c to 0x2600
[  141.575225] wl1271: uploading fw chunk 0xd156280c to 0x2800
[  141.582366] wl1271: uploading fw chunk 0xd1562a0c to 0x2a00
[  141.589477] wl1271: uploading fw chunk 0xd1562c0c to 0x2c00
[  141.596557] wl1271: uploading fw chunk 0xd1562e0c to 0x2e00
[  141.603668] wl1271: uploading fw chunk 0xd156300c to 0x3000
[  141.610748] wl1271: uploading fw chunk 0xd156320c to 0x3200
[  141.617858] wl1271: uploading fw chunk 0xd156340c to 0x3400
[  141.624938] wl1271: uploading fw chunk 0xd156360c to 0x3600
[  141.632049] wl1271: uploading fw chunk 0xd156380c to 0x3800
[  141.639129] wl1271: uploading fw chunk 0xd1563a0c to 0x3a00
[  141.645202] wl1271: uploading fw chunk 0xd1563c0c to 0x3c00
[  141.653106] wl1271: uploading fw chunk 0xd1563e0c to 0x3e00
[  141.660217] wl1271: uploading fw chunk 0xd156400c to 0x4000
[  141.667327] wl1271: uploading fw chunk 0xd156420c to 0x4200
[  141.674407] wl1271: uploading fw chunk 0xd156440c to 0x4400
[  141.681518] wl1271: uploading fw chunk 0xd156460c to 0x4600
[  141.688598] wl1271: uploading fw chunk 0xd156480c to 0x4800
[  141.695709] wl1271: uploading fw chunk 0xd1564a0c to 0x4a00
[  141.702789] wl1271: uploading fw chunk 0xd1564c0c to 0x4c00
[  141.709899] wl1271: uploading fw chunk 0xd1564e0c to 0x4e00
[  141.715942] wl1271: uploading fw chunk 0xd156500c to 0x5000
[  141.723785] wl1271: uploading fw chunk 0xd156520c to 0x5200
[  141.730865] wl1271: uploading fw chunk 0xd156540c to 0x5400
[  141.737945] wl1271: uploading fw chunk 0xd156560c to 0x5600
[  141.745056] wl1271: uploading fw chunk 0xd156580c to 0x5800
[  141.752136] wl1271: uploading fw chunk 0xd1565a0c to 0x5a00
[  141.759246] wl1271: uploading fw chunk 0xd1565c0c to 0x5c00
[  141.766418] wl1271: uploading fw chunk 0xd1565e0c to 0x5e00
[  141.773498] wl1271: uploading fw chunk 0xd156600c to 0x6000
[  141.780609] wl1271: uploading fw chunk 0xd156620c to 0x6200
[  141.787689] wl1271: uploading fw chunk 0xd156640c to 0x6400
[  141.793762] wl1271: uploading fw chunk 0xd156660c to 0x6600
[  141.801605] wl1271: uploading fw chunk 0xd156680c to 0x6800
[  141.808715] wl1271: uploading fw chunk 0xd1566a0c to 0x6a00
[  141.815795] wl1271: uploading fw chunk 0xd1566c0c to 0x6c00
[  141.822967] wl1271: uploading fw chunk 0xd1566e0c to 0x6e00
[  141.830047] wl1271: uploading fw chunk 0xd156700c to 0x7000
[  141.837158] wl1271: uploading fw chunk 0xd156720c to 0x7200
[  141.844238] wl1271: uploading fw chunk 0xd156740c to 0x7400
[  141.851348] wl1271: uploading fw chunk 0xd156760c to 0x7600
[  141.858428] wl1271: uploading fw chunk 0xd156780c to 0x7800
[  141.864471] wl1271: uploading fw chunk 0xd1567a0c to 0x7a00
[  141.872406] wl1271: uploading fw chunk 0xd1567c0c to 0x7c00
[  141.878448] wl1271: uploading fw chunk 0xd1567e0c to 0x7e00
[  141.886291] wl1271: uploading fw chunk 0xd156800c to 0x8000
[  141.893371] wl1271: uploading fw chunk 0xd156820c to 0x8200
[  141.900451] wl1271: uploading fw chunk 0xd156840c to 0x8400
[  141.907562] wl1271: uploading fw chunk 0xd156860c to 0x8600
[  141.914642] wl1271: uploading fw chunk 0xd156880c to 0x8800
[  141.921722] wl1271: uploading fw chunk 0xd1568a0c to 0x8a00
[  141.928833] wl1271: uploading fw chunk 0xd1568c0c to 0x8c00
[  141.935913] wl1271: uploading fw chunk 0xd1568e0c to 0x8e00
[  141.941955] wl1271: uploading fw chunk 0xd156900c to 0x9000
[  141.949859] wl1271: uploading fw chunk 0xd156920c to 0x9200
[  141.956970] wl1271: uploading fw chunk 0xd156940c to 0x9400
[  141.964080] wl1271: uploading fw chunk 0xd156960c to 0x9600
[  141.971160] wl1271: uploading fw chunk 0xd156980c to 0x9800
[  141.978271] wl1271: uploading fw chunk 0xd1569a0c to 0x9a00
[  141.985351] wl1271: uploading fw chunk 0xd1569c0c to 0x9c00
[  141.992462] wl1271: uploading fw chunk 0xd1569e0c to 0x9e00
[  141.999542] wl1271: uploading fw chunk 0xd156a00c to 0xa000
[  142.007232] wl1271: uploading fw chunk 0xd156a20c to 0xa200
[  142.014434] wl1271: uploading fw chunk 0xd156a40c to 0xa400
[  142.020477] wl1271: uploading fw chunk 0xd156a60c to 0xa600
[  142.028381] wl1271: uploading fw chunk 0xd156a80c to 0xa800
[  142.035522] wl1271: uploading fw chunk 0xd156aa0c to 0xaa00
[  142.042602] wl1271: uploading fw chunk 0xd156ac0c to 0xac00
[  142.049713] wl1271: uploading fw chunk 0xd156ae0c to 0xae00
[  142.056823] wl1271: uploading fw chunk 0xd156b00c to 0xb000
[  142.063995] wl1271: uploading fw chunk 0xd156b20c to 0xb200
[  142.071136] wl1271: uploading fw chunk 0xd156b40c to 0xb400
[  142.078216] wl1271: uploading fw chunk 0xd156b60c to 0xb600
[  142.085327] wl1271: uploading fw chunk 0xd156b80c to 0xb800
[  142.092437] wl1271: uploading fw chunk 0xd156ba0c to 0xba00
[  142.098480] wl1271: uploading fw chunk 0xd156bc0c to 0xbc00
[  142.106323] wl1271: uploading fw chunk 0xd156be0c to 0xbe00
[  142.113403] wl1271: uploading fw chunk 0xd156c00c to 0xc000
[  142.120605] wl1271: uploading fw chunk 0xd156c20c to 0xc200
[  142.127716] wl1271: uploading fw chunk 0xd156c40c to 0xc400
[  142.134796] wl1271: uploading fw chunk 0xd156c60c to 0xc600
[  142.141906] wl1271: uploading fw chunk 0xd156c80c to 0xc800
[  142.148986] wl1271: uploading fw chunk 0xd156ca0c to 0xca00
[  142.156097] wl1271: uploading fw chunk 0xd156cc0c to 0xcc00
[  142.163543] wl1271: uploading fw chunk 0xd156ce0c to 0xce00
[  142.170684] wl1271: uploading fw chunk 0xd156d00c to 0xd000
[  142.176727] wl1271: uploading fw chunk 0xd156d20c to 0xd200
[  142.184753] wl1271: uploading fw chunk 0xd156d40c to 0xd400
[  142.191864] wl1271: uploading fw chunk 0xd156d60c to 0xd600
[  142.198974] wl1271: uploading fw chunk 0xd156d80c to 0xd800
[  142.206207] wl1271: uploading fw chunk 0xd156da0c to 0xda00
[  142.213317] wl1271: uploading fw chunk 0xd156dc0c to 0xdc00
[  142.220428] wl1271: uploading fw chunk 0xd156de0c to 0xde00
[  142.227539] wl1271: uploading fw chunk 0xd156e00c to 0xe000
[  142.234619] wl1271: uploading fw chunk 0xd156e20c to 0xe200
[  142.241729] wl1271: uploading fw chunk 0xd156e40c to 0xe400
[  142.248901] wl1271: uploading fw chunk 0xd156e60c to 0xe600
[  142.254943] wl1271: uploading fw chunk 0xd156e80c to 0xe800
[  142.262786] wl1271: uploading fw chunk 0xd156ea0c to 0xea00
[  142.269897] wl1271: uploading fw chunk 0xd156ec0c to 0xec00
[  142.277008] wl1271: uploading fw chunk 0xd156ee0c to 0xee00
[  142.284088] wl1271: uploading fw chunk 0xd156f00c to 0xf000
[  142.291198] wl1271: uploading fw chunk 0xd156f20c to 0xf200
[  142.298278] wl1271: uploading fw chunk 0xd156f40c to 0xf400
[  142.305389] wl1271: uploading fw chunk 0xd156f60c to 0xf600
[  142.312469] wl1271: uploading fw chunk 0xd156f80c to 0xf800
[  142.319549] wl1271: uploading fw chunk 0xd156fa0c to 0xfa00
[  142.326660] wl1271: uploading fw chunk 0xd156fc0c to 0xfc00
[  142.332702] wl1271: uploading fw chunk 0xd156fe0c to 0xfe00
[  142.340545] wl1271: uploading fw chunk 0xd157000c to 0x10000
[  142.347930] wl1271: uploading fw chunk 0xd157020c to 0x10200
[  142.355468] wl1271: uploading fw chunk 0xd157040c to 0x10400
[  142.363708] wl1271: uploading fw chunk 0xd157060c to 0x10600
[  142.371215] wl1271: uploading fw chunk 0xd157080c to 0x10800
[  142.378479] wl1271: uploading fw chunk 0xd1570a0c to 0x10a00
[  142.385681] wl1271: uploading fw chunk 0xd1570c0c to 0x10c00
[  142.392883] wl1271: uploading fw chunk 0xd1570e0c to 0x10e00
[  142.400085] wl1271: uploading fw chunk 0xd157100c to 0x11000
[  142.407287] wl1271: uploading fw chunk 0xd157120c to 0x11200
[  142.414459] wl1271: uploading fw chunk 0xd157140c to 0x11400
[  142.421752] wl1271: uploading fw chunk 0xd157160c to 0x11600
[  142.428955] wl1271: uploading fw chunk 0xd157180c to 0x11800
[  142.436126] wl1271: uploading fw chunk 0xd1571a0c to 0x11a00
[  142.442291] wl1271: uploading fw chunk 0xd1571c0c to 0x11c00
[  142.450225] wl1271: uploading fw chunk 0xd1571e0c to 0x11e00
[  142.457427] wl1271: uploading fw chunk 0xd157200c to 0x12000
[  142.464630] wl1271: uploading fw chunk 0xd157220c to 0x12200
[  142.471801] wl1271: uploading fw chunk 0xd157240c to 0x12400
[  142.479003] wl1271: uploading fw chunk 0xd157260c to 0x12600
[  142.486175] wl1271: uploading fw chunk 0xd157280c to 0x12800
[  142.493347] wl1271: uploading fw chunk 0xd1572a0c to 0x12a00
[  142.500549] wl1271: uploading fw chunk 0xd1572c0c to 0x12c00
[  142.507720] wl1271: uploading fw chunk 0xd1572e0c to 0x12e00
[  142.514923] wl1271: uploading fw chunk 0xd157300c to 0x13000
[  142.522094] wl1271: uploading fw chunk 0xd157320c to 0x13200
[  142.528228] wl1271: uploading fw chunk 0xd157340c to 0x13400
[  142.536163] wl1271: uploading fw chunk 0xd157360c to 0x13600
[  142.543365] wl1271: uploading fw chunk 0xd157380c to 0x13800
[  142.550628] wl1271: uploading fw chunk 0xd1573a0c to 0x13a00
[  142.557830] wl1271: uploading fw chunk 0xd1573c0c to 0x13c00
[  142.565032] wl1271: uploading fw chunk 0xd1573e0c to 0x13e00
[  142.572235] wl1271: uploading fw chunk 0xd157400c to 0x14000
[  142.579376] wl1271: uploading fw chunk 0xd157420c to 0x14200
[  142.586547] wl1271: uploading fw chunk 0xd157440c to 0x14400
[  142.593749] wl1271: uploading fw chunk 0xd157460c to 0x14600
[  142.600921] wl1271: uploading fw chunk 0xd157480c to 0x14800
[  142.608093] wl1271: uploading fw chunk 0xd1574a0c to 0x14a00
[  142.614227] wl1271: uploading fw chunk 0xd1574c0c to 0x14c00
[  142.621887] wl1271: uploading fw chunk 0xd1574e0c to 0x14e00
[  142.630249] wl1271: uploading fw chunk 0xd157500c to 0x15000
[  142.636413] wl1271: uploading fw chunk 0xd157520c to 0x15200
[  142.644439] wl1271: uploading fw chunk 0xd157540c to 0x15400
[  142.651672] wl1271: uploading fw chunk 0xd157560c to 0x15600
[  142.658874] wl1271: uploading fw chunk 0xd157580c to 0x15800
[  142.666168] wl1271: uploading fw chunk 0xd1575a0c to 0x15a00
[  142.673370] wl1271: uploading fw chunk 0xd1575c0c to 0x15c00
[  142.680572] wl1271: uploading fw chunk 0xd1575e0c to 0x15e00
[  142.687957] wl1271: uploading fw chunk 0xd157600c to 0x16000
[  142.695190] wl1271: uploading fw chunk 0xd157620c to 0x16200
[  142.702392] wl1271: uploading fw chunk 0xd157640c to 0x16400
[  142.709594] wl1271: uploading fw chunk 0xd157660c to 0x16600
[  142.715728] wl1271: uploading fw chunk 0xd157680c to 0x16800
[  142.723785] wl1271: uploading fw chunk 0xd1576a0c to 0x16a00
[  142.730987] wl1271: uploading fw chunk 0xd1576c0c to 0x16c00
[  142.738220] wl1271: uploading fw chunk 0xd1576e0c to 0x16e00
[  142.745422] wl1271: uploading fw chunk 0xd157700c to 0x17000
[  142.752593] wl1271: uploading fw chunk 0xd157720c to 0x17200
[  142.760528] wl1271: uploading fw chunk 0xd157740c to 0x17400
[  142.767700] wl1271: uploading fw chunk 0xd157760c to 0x17600
[  142.774902] wl1271: uploading fw chunk 0xd157780c to 0x17800
[  142.782073] wl1271: uploading fw chunk 0xd1577a0c to 0x17a00
[  142.789276] wl1271: uploading fw chunk 0xd1577c0c to 0x17c00
[  142.796478] wl1271: uploading fw chunk 0xd1577e0c to 0x17e00
[  142.803649] wl1271: uploading fw chunk 0xd157800c to 0x18000
[  142.810852] wl1271: uploading fw chunk 0xd157820c to 0x18200
[  142.816986] wl1271: uploading fw chunk 0xd157840c to 0x18400
[  142.824920] wl1271: uploading fw chunk 0xd157860c to 0x18600
[  142.832122] wl1271: uploading fw chunk 0xd157880c to 0x18800
[  142.839294] wl1271: uploading fw chunk 0xd1578a0c to 0x18a00
[  142.846466] wl1271: uploading fw chunk 0xd1578c0c to 0x18c00
[  142.853729] wl1271: uploading fw chunk 0xd1578e0c to 0x18e00
[  142.860961] wl1271: uploading fw chunk 0xd157900c to 0x19000
[  142.868133] wl1271: uploading fw chunk 0xd157920c to 0x19200
[  142.875335] wl1271: uploading fw chunk 0xd157940c to 0x19400
[  142.882507] wl1271: uploading fw chunk 0xd157960c to 0x19600
[  142.889709] wl1271: uploading fw chunk 0xd157980c to 0x19800
[  142.896881] wl1271: uploading fw chunk 0xd1579a0c to 0x19a00
[  142.903045] wl1271: uploading fw chunk 0xd1579c0c to 0x19c00
[  142.910949] wl1271: uploading fw chunk 0xd1579e0c to 0x19e00
[  142.918151] wl1271: uploading fw chunk 0xd157a00c to 0x1a000
[  142.925354] wl1271: uploading fw chunk 0xd157a20c to 0x1a200
[  142.932525] wl1271: uploading fw chunk 0xd157a40c to 0x1a400
[  142.939727] wl1271: uploading fw chunk 0xd157a60c to 0x1a600
[  142.946899] wl1271: uploading fw chunk 0xd157a80c to 0x1a800
[  142.954101] wl1271: uploading fw chunk 0xd157aa0c to 0x1aa00
[  142.961273] wl1271: uploading fw chunk 0xd157ac0c to 0x1ac00
[  142.968566] wl1271: uploading fw chunk 0xd157ae0c to 0x1ae00
[  142.975769] wl1271: uploading fw chunk 0xd157b00c to 0x1b000
[  142.982971] wl1271: uploading fw chunk 0xd157b20c to 0x1b200
[  142.989135] wl1271: uploading fw chunk 0xd157b40c to 0x1b400
[  142.997070] wl1271: uploading fw chunk 0xd157b60c to 0x1b600
[  143.004272] wl1271: uploading fw chunk 0xd157b80c to 0x1b800
[  143.011596] wl1271: uploading fw chunk 0xd157ba0c to 0x1ba00
[  143.018890] wl1271: uploading fw chunk 0xd157bc0c to 0x1bc00
[  143.026123] wl1271: uploading fw chunk 0xd157be0c to 0x1be00
[  143.033294] wl1271: uploading fw chunk 0xd157c00c to 0x1c000
[  143.040496] wl1271: uploading fw chunk 0xd157c20c to 0x1c200
[  143.047698] wl1271: uploading fw chunk 0xd157c40c to 0x1c400
[  143.054870] wl1271: uploading fw chunk 0xd157c60c to 0x1c600
[  143.062072] wl1271: uploading fw chunk 0xd157c80c to 0x1c800
[  143.069244] wl1271: uploading fw chunk 0xd157ca0c to 0x1ca00
[  143.075378] wl1271: uploading fw chunk 0xd157cc0c to 0x1cc00
[  143.083404] wl1271: uploading fw chunk 0xd157ce0c to 0x1ce00
[  143.089538] wl1271: uploading fw chunk 0xd157d00c to 0x1d000
[  143.097473] wl1271: uploading fw chunk 0xd157d20c to 0x1d200
[  143.104858] wl1271: uploading fw chunk 0xd157d40c to 0x1d400
[  143.112091] wl1271: uploading fw chunk 0xd157d60c to 0x1d600
[  143.119293] wl1271: uploading fw chunk 0xd157d80c to 0x1d800
[  143.126678] wl1271: uploading fw chunk 0xd157da0c to 0x1da00
[  143.133880] wl1271: uploading fw chunk 0xd157dc0c to 0x1dc00
[  143.141082] wl1271: uploading fw chunk 0xd157de0c to 0x1de00
[  143.148284] wl1271: uploading fw chunk 0xd157e00c to 0x1e000
[  143.155548] wl1271: uploading fw chunk 0xd157e20c to 0x1e200
[  143.162750] wl1271: uploading fw chunk 0xd157e40c to 0x1e400
[  143.168914] wl1271: uploading fw chunk 0xd157e60c to 0x1e600
[  143.176849] wl1271: uploading fw chunk 0xd157e80c to 0x1e800
[  143.184539] wl1271: uploading fw chunk 0xd157ea0c to 0x1ea00
[  143.191772] wl1271: uploading fw chunk 0xd157ec0c to 0x1ec00
[  143.198974] wl1271: uploading fw chunk 0xd157ee0c to 0x1ee00
[  143.206298] wl1271: uploading fw chunk 0xd157f00c to 0x1f000
[  143.213500] wl1271: uploading fw chunk 0xd157f20c to 0x1f200
[  143.220703] wl1271: uploading fw chunk 0xd157f40c to 0x1f400
[  143.227905] wl1271: uploading fw chunk 0xd157f60c to 0x1f600
[  143.235107] wl1271: uploading fw chunk 0xd157f80c to 0x1f800
[  143.242279] wl1271: uploading fw chunk 0xd157fa0c to 0x1fa00
[  143.249481] wl1271: uploading fw chunk 0xd157fc0c to 0x1fc00
[  143.256652] wl1271: uploading fw chunk 0xd157fe0c to 0x1fe00
[  143.262817] wl1271: uploading fw chunk 0xd158000c to 0x20000
[  143.270935] wl1271: uploading fw chunk 0xd158020c to 0x20200
[  143.277069] wl1271: uploading fw chunk 0xd158040c to 0x20400
[  143.285003] wl1271: uploading fw chunk 0xd158060c to 0x20600
[  143.292205] wl1271: uploading fw chunk 0xd158080c to 0x20800
[  143.299407] wl1271: uploading fw chunk 0xd1580a0c to 0x20a00
[  143.306579] wl1271: uploading fw chunk 0xd1580c0c to 0x20c00
[  143.313781] wl1271: uploading fw chunk 0xd1580e0c to 0x20e00
[  143.321044] wl1271: uploading fw chunk 0xd158100c to 0x21000
[  143.328247] wl1271: uploading fw chunk 0xd158120c to 0x21200
[  143.335418] wl1271: uploading fw chunk 0xd158140c to 0x21400
[  143.342620] wl1271: uploading fw chunk 0xd158160c to 0x21600
[  143.348754] wl1271: uploading fw chunk 0xd158180c to 0x21800
[  143.356781] wl1271: uploading fw chunk 0xd1581a0c to 0x21a00
[  143.362945] wl1271: uploading fw chunk 0xd1581c0c to 0x21c00
[  143.370880] wl1271: uploading fw chunk 0xd1581e0c to 0x21e00
[  143.378082] wl1271: uploading fw chunk 0xd158200c to 0x22000
[  143.385253] wl1271: uploading fw chunk 0xd158220c to 0x22200
[  143.392456] wl1271: uploading fw chunk 0xd158240c to 0x22400
[  143.399627] wl1271: uploading fw chunk 0xd158260c to 0x22600
[  143.406829] wl1271: uploading fw chunk 0xd158280c to 0x22800
[  143.414001] wl1271: uploading fw chunk 0xd1582a0c to 0x22a00
[  143.421203] wl1271: uploading fw chunk 0xd1582c0c to 0x22c00
[  143.428375] wl1271: uploading fw chunk 0xd1582e0c to 0x22e00
[  143.434539] wl1271: uploading fw chunk 0xd158300c to 0x23000
[  143.442474] wl1271: uploading fw chunk 0xd158320c to 0x23200
[  143.449645] wl1271: uploading fw chunk 0xd158340c to 0x23400
[  143.456909] wl1271: uploading fw chunk 0xd158360c to 0x23600
[  143.464111] wl1271: uploading fw chunk 0xd158380c to 0x23800
[  143.471313] wl1271: uploading fw chunk 0xd1583a0c to 0x23a00
[  143.478485] wl1271: uploading fw chunk 0xd1583c0c to 0x23c00
[  143.485687] wl1271: uploading fw chunk 0xd1583e0c to 0x23e00
[  143.492858] wl1271: uploading fw chunk 0xd158400c to 0x24000
[  143.500061] wl1271: uploading fw chunk 0xd158420c to 0x24200
[  143.507232] wl1271: uploading fw chunk 0xd158440c to 0x24400
[  143.514434] wl1271: uploading fw chunk 0xd158460c to 0x24600
[  143.520568] wl1271: uploading fw chunk 0xd158480c to 0x24800
[  143.528503] wl1271: uploading fw chunk 0xd1584a0c to 0x24a00
[  143.535705] wl1271: uploading fw chunk 0xd1584c0c to 0x24c00
[  143.542877] wl1271: uploading fw chunk 0xd1584e0c to 0x24e00
[  143.550079] wl1271: uploading fw chunk 0xd158500c to 0x25000
[  143.557250] wl1271: uploading fw chunk 0xd158520c to 0x25200
[  143.564514] wl1271: uploading fw chunk 0xd158540c to 0x25400
[  143.571746] wl1271: uploading fw chunk 0xd158560c to 0x25600
[  143.578918] wl1271: uploading fw chunk 0xd158580c to 0x25800
[  143.586120] wl1271: uploading fw chunk 0xd1585a0c to 0x25a00
[  143.593322] wl1271: uploading fw chunk 0xd1585c0c to 0x25c00
[  143.600494] wl1271: uploading fw chunk 0xd1585e0c to 0x25e00
[  143.606658] wl1271: uploading fw chunk 0xd158600c to 0x26000
[  143.614685] wl1271: uploading fw chunk 0xd158620c to 0x26200
[  143.620819] wl1271: uploading fw chunk 0xd158640c to 0x26400
[  143.628845] wl1271: uploading fw chunk 0xd158660c to 0x26600
[  143.636047] wl1271: uploading fw chunk 0xd158680c to 0x26800
[  143.643218] wl1271: uploading fw chunk 0xd1586a0c to 0x26a00
[  143.650421] wl1271: uploading fw chunk 0xd1586c0c to 0x26c00
[  143.657623] wl1271: uploading fw chunk 0xd1586e0c to 0x26e00
[  143.664794] wl1271: uploading fw chunk 0xd158700c to 0x27000
[  143.671997] wl1271: uploading fw chunk 0xd158720c to 0x27200
[  143.679168] wl1271: uploading fw chunk 0xd158740c to 0x27400
[  143.686584] wl1271: uploading fw chunk 0xd158760c to 0x27600
[  143.693786] wl1271: uploading fw chunk 0xd158780c to 0x27800
[  143.699951] wl1271: uploading fw chunk 0xd1587a0c to 0x27a00
[  143.707885] wl1271: uploading fw chunk 0xd1587c0c to 0x27c00
[  143.715087] wl1271: uploading fw chunk 0xd1587e0c to 0x27e00
[  143.722290] wl1271: uploading fw chunk 0xd158800c to 0x28000
[  143.729461] wl1271: uploading fw chunk 0xd158820c to 0x28200
[  143.736633] wl1271: uploading fw chunk 0xd158840c to 0x28400
[  143.743835] wl1271: uploading fw chunk 0xd158860c to 0x28600
[  143.751098] wl1271: uploading fw chunk 0xd158880c to 0x28800
[  143.758270] wl1271: uploading fw chunk 0xd1588a0c to 0x28a00
[  143.765472] wl1271: uploading fw chunk 0xd1588c0c to 0x28c00
[  143.772674] wl1271: uploading fw chunk 0xd1588e0c to 0x28e00
[  143.779846] wl1271: uploading fw chunk 0xd158900c to 0x29000
[  143.786010] wl1271: uploading fw chunk 0xd158920c to 0x29200
[  143.793945] wl1271: uploading fw chunk 0xd158940c to 0x29400
[  143.801116] wl1271: uploading fw chunk 0xd158960c to 0x29600
[  143.808319] wl1271: uploading fw chunk 0xd158980c to 0x29800
[  143.815490] wl1271: uploading fw chunk 0xd1589a0c to 0x29a00
[  143.822692] wl1271: uploading fw chunk 0xd1589c0c to 0x29c00
[  143.830078] wl1271: uploading fw chunk 0xd1589e0c to 0x29e00
[  143.837310] wl1271: uploading fw chunk 0xd158a00c to 0x2a000
[  143.844512] wl1271: uploading fw chunk 0xd158a20c to 0x2a200
[  143.851715] wl1271: uploading fw chunk 0xd158a40c to 0x2a400
[  143.858917] wl1271: uploading fw chunk 0xd158a60c to 0x2a600
[  143.866210] wl1271: uploading fw chunk 0xd158a80c to 0x2a800
[  143.873413] wl1271: uploading fw chunk 0xd158aa0c to 0x2aa00
[  143.879547] wl1271: uploading fw chunk 0xd158ac0c to 0x2ac00
[  143.887512] wl1271: uploading fw chunk 0xd158ae0c to 0x2ae00
[  143.894683] wl1271: uploading fw chunk 0xd158b00c to 0x2b000
[  143.901885] wl1271: uploading fw chunk 0xd158b20c to 0x2b200
[  143.909088] wl1271: uploading fw chunk 0xd158b40c to 0x2b400
[  143.916259] wl1271: uploading fw chunk 0xd158b60c to 0x2b600
[  143.923522] wl1271: uploading fw chunk 0xd158b80c to 0x2b800
[  143.930725] wl1271: uploading fw chunk 0xd158ba0c to 0x2ba00
[  143.937927] wl1271: uploading fw chunk 0xd158bc0c to 0x2bc00
[  143.945098] wl1271: uploading fw chunk 0xd158be0c to 0x2be00
[  143.952301] wl1271: uploading fw chunk 0xd158c00c to 0x2c000
[  143.959472] wl1271: uploading fw chunk 0xd158c20c to 0x2c200
[  143.965637] wl1271: uploading fw chunk 0xd158c40c to 0x2c400
[  143.973541] wl1271: uploading fw chunk 0xd158c60c to 0x2c600
[  143.980743] wl1271: uploading fw chunk 0xd158c80c to 0x2c800
[  143.987915] wl1271: uploading fw chunk 0xd158ca0c to 0x2ca00
[  143.995117] wl1271: uploading fw chunk 0xd158cc0c to 0x2cc00
[  144.002288] wl1271: uploading fw chunk 0xd158ce0c to 0x2ce00
[  144.009613] wl1271: uploading fw chunk 0xd158d00c to 0x2d000
[  144.017181] wl1271: uploading fw chunk 0xd158d20c to 0x2d200
[  144.024536] wl1271: uploading fw chunk 0xd158d40c to 0x2d400
[  144.031799] wl1271: uploading fw chunk 0xd158d60c to 0x2d600
[  144.039001] wl1271: uploading fw chunk 0xd158d80c to 0x2d800
[  144.046203] wl1271: uploading fw chunk 0xd158da0c to 0x2da00
[  144.053497] wl1271: uploading fw chunk 0xd158dc0c to 0x2dc00
[  144.059631] wl1271: uploading fw chunk 0xd158de0c to 0x2de00
[  144.067596] wl1271: uploading fw chunk 0xd158e00c to 0x2e000
[  144.074798] wl1271: uploading fw chunk 0xd158e20c to 0x2e200
[  144.082000] wl1271: uploading fw chunk 0xd158e40c to 0x2e400
[  144.089385] wl1271: uploading fw chunk 0xd158e60c to 0x2e600
[  144.097351] wl1271: uploading fw chunk 0xd158e80c to 0x2e800
[  144.104705] wl1271: uploading fw chunk 0xd158ea0c to 0x2ea00
[  144.111938] wl1271: uploading fw chunk 0xd158ec0c to 0x2ec00
[  144.119110] wl1271: uploading fw chunk 0xd158ee0c to 0x2ee00
[  144.126495] wl1271: uploading fw chunk 0xd158f00c to 0x2f000
[  144.133697] wl1271: uploading fw chunk 0xd158f20c to 0x2f200
[  144.140899] wl1271: uploading fw chunk 0xd158f40c to 0x2f400
[  144.148101] wl1271: uploading fw chunk 0xd158f60c to 0x2f600
[  144.155303] wl1271: uploading fw chunk 0xd158f80c to 0x2f800
[  144.162475] wl1271: uploading fw chunk 0xd158fa0c to 0x2fa00
[  144.168609] wl1271: uploading fw chunk 0xd158fc0c to 0x2fc00
[  144.176696] wl1271: uploading fw last chunk (4 B) 0xd158fe0c to 0x2fe00
[  144.185150] wl1271: chunk 4 addr 0x20000000 len 48972
[  144.190490] wl1271: starting firmware upload
[  144.195159] wl1271: fw_data_len 48972 chunk_size 512
[  144.203338] wl1271: uploading fw chunk 0xd158fe18 to 0x20000000
[  144.212951] wl1271: uploading fw chunk 0xd1590018 to 0x20000200
[  144.221160] wl1271: uploading fw chunk 0xd1590218 to 0x20000400
[  144.229461] wl1271: uploading fw chunk 0xd1590418 to 0x20000600
[  144.237731] wl1271: uploading fw chunk 0xd1590618 to 0x20000800
[  144.245941] wl1271: uploading fw chunk 0xd1590818 to 0x20000a00
[  144.254150] wl1271: uploading fw chunk 0xd1590a18 to 0x20000c00
[  144.262359] wl1271: uploading fw chunk 0xd1590c18 to 0x20000e00
[  144.270568] wl1271: uploading fw chunk 0xd1590e18 to 0x20001000
[  144.278869] wl1271: uploading fw chunk 0xd1591018 to 0x20001200
[  144.286010] wl1271: uploading fw chunk 0xd1591218 to 0x20001400
[  144.295074] wl1271: uploading fw chunk 0xd1591418 to 0x20001600
[  144.303497] wl1271: uploading fw chunk 0xd1591618 to 0x20001800
[  144.311706] wl1271: uploading fw chunk 0xd1591818 to 0x20001a00
[  144.320129] wl1271: uploading fw chunk 0xd1591a18 to 0x20001c00
[  144.328369] wl1271: uploading fw chunk 0xd1591c18 to 0x20001e00
[  144.336578] wl1271: uploading fw chunk 0xd1591e18 to 0x20002000
[  144.344787] wl1271: uploading fw chunk 0xd1592018 to 0x20002200
[  144.352966] wl1271: uploading fw chunk 0xd1592218 to 0x20002400
[  144.361175] wl1271: uploading fw chunk 0xd1592418 to 0x20002600
[  144.369384] wl1271: uploading fw chunk 0xd1592618 to 0x20002800
[  144.377899] wl1271: uploading fw chunk 0xd1592818 to 0x20002a00
[  144.386138] wl1271: uploading fw chunk 0xd1592a18 to 0x20002c00
[  144.394348] wl1271: uploading fw chunk 0xd1592c18 to 0x20002e00
[  144.402557] wl1271: uploading fw chunk 0xd1592e18 to 0x20003000
[  144.410766] wl1271: uploading fw chunk 0xd1593018 to 0x20003200
[  144.418975] wl1271: uploading fw chunk 0xd1593218 to 0x20003400
[  144.427276] wl1271: uploading fw chunk 0xd1593418 to 0x20003600
[  144.434417] wl1271: uploading fw chunk 0xd1593618 to 0x20003800
[  144.443481] wl1271: uploading fw chunk 0xd1593818 to 0x20003a00
[  144.451721] wl1271: uploading fw chunk 0xd1593a18 to 0x20003c00
[  144.459960] wl1271: uploading fw chunk 0xd1593c18 to 0x20003e00
[  144.468170] wl1271: uploading fw chunk 0xd1593e18 to 0x20004000
[  144.476379] wl1271: uploading fw chunk 0xd1594018 to 0x20004200
[  144.484588] wl1271: uploading fw chunk 0xd1594218 to 0x20004400
[  144.492797] wl1271: uploading fw chunk 0xd1594418 to 0x20004600
[  144.501098] wl1271: uploading fw chunk 0xd1594618 to 0x20004800
[  144.509307] wl1271: uploading fw chunk 0xd1594818 to 0x20004a00
[  144.517547] wl1271: uploading fw chunk 0xd1594a18 to 0x20004c00
[  144.525726] wl1271: uploading fw chunk 0xd1594c18 to 0x20004e00
[  144.533935] wl1271: uploading fw chunk 0xd1594e18 to 0x20005000
[  144.542114] wl1271: uploading fw chunk 0xd1595018 to 0x20005200
[  144.550323] wl1271: uploading fw chunk 0xd1595218 to 0x20005400
[  144.558593] wl1271: uploading fw chunk 0xd1595418 to 0x20005600
[  144.566802] wl1271: uploading fw chunk 0xd1595618 to 0x20005800
[  144.575012] wl1271: uploading fw chunk 0xd1595818 to 0x20005a00
[  144.583221] wl1271: uploading fw chunk 0xd1595a18 to 0x20005c00
[  144.591491] wl1271: uploading fw chunk 0xd1595c18 to 0x20005e00
[  144.598632] wl1271: uploading fw chunk 0xd1595e18 to 0x20006000
[  144.607727] wl1271: uploading fw chunk 0xd1596018 to 0x20006200
[  144.615936] wl1271: uploading fw chunk 0xd1596218 to 0x20006400
[  144.624176] wl1271: uploading fw chunk 0xd1596418 to 0x20006600
[  144.632354] wl1271: uploading fw chunk 0xd1596618 to 0x20006800
[  144.640563] wl1271: uploading fw chunk 0xd1596818 to 0x20006a00
[  144.648773] wl1271: uploading fw chunk 0xd1596a18 to 0x20006c00
[  144.656951] wl1271: uploading fw chunk 0xd1596c18 to 0x20006e00
[  144.665130] wl1271: uploading fw chunk 0xd1596e18 to 0x20007000
[  144.673339] wl1271: uploading fw chunk 0xd1597018 to 0x20007200
[  144.681549] wl1271: uploading fw chunk 0xd1597218 to 0x20007400
[  144.689941] wl1271: uploading fw chunk 0xd1597418 to 0x20007600
[  144.698181] wl1271: uploading fw chunk 0xd1597618 to 0x20007800
[  144.706451] wl1271: uploading fw chunk 0xd1597818 to 0x20007a00
[  144.714691] wl1271: uploading fw chunk 0xd1597a18 to 0x20007c00
[  144.722900] wl1271: uploading fw chunk 0xd1597c18 to 0x20007e00
[  144.731109] wl1271: uploading fw chunk 0xd1597e18 to 0x20008000
[  144.739318] wl1271: uploading fw chunk 0xd1598018 to 0x20008200
[  144.747589] wl1271: uploading fw chunk 0xd1598218 to 0x20008400
[  144.754760] wl1271: uploading fw chunk 0xd1598418 to 0x20008600
[  144.763793] wl1271: uploading fw chunk 0xd1598618 to 0x20008800
[  144.772033] wl1271: uploading fw chunk 0xd1598818 to 0x20008a00
[  144.780273] wl1271: uploading fw chunk 0xd1598a18 to 0x20008c00
[  144.788482] wl1271: uploading fw chunk 0xd1598c18 to 0x20008e00
[  144.796691] wl1271: uploading fw chunk 0xd1598e18 to 0x20009000
[  144.804870] wl1271: uploading fw chunk 0xd1599018 to 0x20009200
[  144.813079] wl1271: uploading fw chunk 0xd1599218 to 0x20009400
[  144.821289] wl1271: uploading fw chunk 0xd1599418 to 0x20009600
[  144.829559] wl1271: uploading fw chunk 0xd1599618 to 0x20009800
[  144.837799] wl1271: uploading fw chunk 0xd1599818 to 0x20009a00
[  144.846008] wl1271: uploading fw chunk 0xd1599a18 to 0x20009c00
[  144.854217] wl1271: uploading fw chunk 0xd1599c18 to 0x20009e00
[  144.862426] wl1271: uploading fw chunk 0xd1599e18 to 0x2000a000
[  144.870605] wl1271: uploading fw chunk 0xd159a018 to 0x2000a200
[  144.878814] wl1271: uploading fw chunk 0xd159a218 to 0x2000a400
[  144.887023] wl1271: uploading fw chunk 0xd159a418 to 0x2000a600
[  144.895294] wl1271: uploading fw chunk 0xd159a618 to 0x2000a800
[  144.903503] wl1271: uploading fw chunk 0xd159a818 to 0x2000aa00
[  144.912139] wl1271: uploading fw chunk 0xd159aa18 to 0x2000ac00
[  144.920471] wl1271: uploading fw chunk 0xd159ac18 to 0x2000ae00
[  144.928771] wl1271: uploading fw chunk 0xd159ae18 to 0x2000b000
[  144.937011] wl1271: uploading fw chunk 0xd159b018 to 0x2000b200
[  144.945220] wl1271: uploading fw chunk 0xd159b218 to 0x2000b400
[  144.953430] wl1271: uploading fw chunk 0xd159b418 to 0x2000b600
[  144.961608] wl1271: uploading fw chunk 0xd159b618 to 0x2000b800
[  144.969818] wl1271: uploading fw chunk 0xd159b818 to 0x2000ba00
[  144.978027] wl1271: uploading fw chunk 0xd159ba18 to 0x2000bc00
[  144.985504] wl1271: uploading fw last chunk (332 B) 0xd159bc18 to 0x2000be00
[  144.994201] wl1271: chunk 3 addr 0x40000 len 448
[  144.999206] wl1271: starting firmware upload
[  145.003723] wl1271: fw_data_len 448 chunk_size 512
[  145.010925] wl1271: uploading fw last chunk (448 B) 0xd159bd6c to 0x40000
[  145.019073] wl1271: chunk 2 addr 0x40be0 len 16432
[  145.024230] wl1271: starting firmware upload
[  145.028839] wl1271: fw_data_len 16432 chunk_size 512
[  145.039886] wl1271: uploading fw chunk 0xd159bf34 to 0x40be0
[  145.047821] wl1271: uploading fw chunk 0xd159c134 to 0x40de0
[  145.055755] wl1271: uploading fw chunk 0xd159c334 to 0x40fe0
[  145.063659] wl1271: uploading fw chunk 0xd159c534 to 0x411e0
[  145.071594] wl1271: uploading fw chunk 0xd159c734 to 0x413e0
[  145.079498] wl1271: uploading fw chunk 0xd159c934 to 0x415e0
[  145.087432] wl1271: uploading fw chunk 0xd159cb34 to 0x417e0
[  145.095336] wl1271: uploading fw chunk 0xd159cd34 to 0x419e0
[  145.103454] wl1271: uploading fw chunk 0xd159cf34 to 0x41be0
[  145.111419] wl1271: uploading fw chunk 0xd159d134 to 0x41de0
[  145.119354] wl1271: uploading fw chunk 0xd159d334 to 0x41fe0
[  145.127288] wl1271: uploading fw chunk 0xd159d534 to 0x421e0
[  145.135192] wl1271: uploading fw chunk 0xd159d734 to 0x423e0
[  145.143127] wl1271: uploading fw chunk 0xd159d934 to 0x425e0
[  145.151031] wl1271: uploading fw chunk 0xd159db34 to 0x427e0
[  145.159027] wl1271: uploading fw chunk 0xd159dd34 to 0x429e0
[  145.166961] wl1271: uploading fw chunk 0xd159df34 to 0x42be0
[  145.174896] wl1271: uploading fw chunk 0xd159e134 to 0x42de0
[  145.183288] wl1271: uploading fw chunk 0xd159e334 to 0x42fe0
[  145.191253] wl1271: uploading fw chunk 0xd159e534 to 0x431e0
[  145.199188] wl1271: uploading fw chunk 0xd159e734 to 0x433e0
[  145.207214] wl1271: uploading fw chunk 0xd159e934 to 0x435e0
[  145.215148] wl1271: uploading fw chunk 0xd159eb34 to 0x437e0
[  145.223144] wl1271: uploading fw chunk 0xd159ed34 to 0x439e0
[  145.231079] wl1271: uploading fw chunk 0xd159ef34 to 0x43be0
[  145.239013] wl1271: uploading fw chunk 0xd159f134 to 0x43de0
[  145.246948] wl1271: uploading fw chunk 0xd159f334 to 0x43fe0
[  145.254852] wl1271: uploading fw chunk 0xd159f534 to 0x441e0
[  145.263214] wl1271: uploading fw chunk 0xd159f734 to 0x443e0
[  145.270080] wl1271: uploading fw chunk 0xd159f934 to 0x445e0
[  145.278869] wl1271: uploading fw chunk 0xd159fb34 to 0x447e0
[  145.285736] wl1271: uploading fw chunk 0xd159fd34 to 0x449e0
[  145.293701] wl1271: uploading fw last chunk (48 B) 0xd159ff34 to 0x44be0
[  145.302093] wl1271: chunk 1 addr 0x312000 len 8092
[  145.307159] wl1271: starting firmware upload
[  145.311767] wl1271: fw_data_len 8092 chunk_size 512
[  145.319091] wl1271: uploading fw chunk 0xd159ff6c to 0x312000
[  145.329010] wl1271: uploading fw chunk 0xd15a016c to 0x312200
[  145.337005] wl1271: uploading fw chunk 0xd15a036c to 0x312400
[  145.345031] wl1271: uploading fw chunk 0xd15a056c to 0x312600
[  145.353057] wl1271: uploading fw chunk 0xd15a076c to 0x312800
[  145.361145] wl1271: uploading fw chunk 0xd15a096c to 0x312a00
[  145.369171] wl1271: uploading fw chunk 0xd15a0b6c to 0x312c00
[  145.377197] wl1271: uploading fw chunk 0xd15a0d6c to 0x312e00
[  145.385192] wl1271: uploading fw chunk 0xd15a0f6c to 0x313000
[  145.393218] wl1271: uploading fw chunk 0xd15a116c to 0x313200
[  145.401214] wl1271: uploading fw chunk 0xd15a136c to 0x313400
[  145.409210] wl1271: uploading fw chunk 0xd15a156c to 0x313600
[  145.417236] wl1271: uploading fw chunk 0xd15a176c to 0x313800
[  145.425231] wl1271: uploading fw chunk 0xd15a196c to 0x313a00
[  145.433258] wl1271: uploading fw chunk 0xd15a1b6c to 0x313c00
[  145.440551] wl1271: uploading fw last chunk (412 B) 0xd15a1d6c to 0x313e00
[  145.449066] wl1271: chunk 0 addr 0x316000 len 3784
[  145.454223] wl1271: starting firmware upload
[  145.458831] wl1271: fw_data_len 3784 chunk_size 512
[  145.466735] wl1271: uploading fw chunk 0xd15a1f10 to 0x316000
[  145.476165] wl1271: uploading fw chunk 0xd15a2110 to 0x316200
[  145.484283] wl1271: uploading fw chunk 0xd15a2310 to 0x316400
[  145.492279] wl1271: uploading fw chunk 0xd15a2510 to 0x316600
[  145.500305] wl1271: uploading fw chunk 0xd15a2710 to 0x316800
[  145.508331] wl1271: uploading fw chunk 0xd15a2910 to 0x316a00
[  145.516601] wl1271: uploading fw chunk 0xd15a2b10 to 0x316c00
[  145.524047] wl1271: uploading fw last chunk (200 B) 0xd15a2d10 to 0x316e00
[  146.930877] wl1271: ERROR sdio read failed (-110)
[  146.937164] wl1271: ERROR sdio write failed (-110)
[  148.340606] wl1271: ERROR sdio read failed (-110)
[  148.345703] wl1271: chip id after firmware boot: 0x101
[  148.351196] wl1271: ERROR chip id doesn't match after firmware boot
[  150.466918] wl1271: ERROR sdio read failed (-110)
[  150.471923] wl1271: WARNING unsupported chip id: 0x1
[  150.583526] wl1271: ERROR firmware boot failed despite 3 retries
SIOCSIFFLAGS: No such device

--------------090201010609000707090808
Content-Type: text/x-log;
 name="wl12xx_calibrate.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wl12xx_calibrate.log"

root@cm-debian:~# modprobe wl12xx_sdio
[   72.916961] cfg80211: Calling CRDA to update world regulatory domain
[   79.620330] wl1271: loaded
[   79.628540] wl1271: initialized
root@cm-debian:~/ti-utils# ./calibrator plt calibrate
[  125.887390] wl1271: power up
[  126.498687] wl1271: chip id 0x4030111 (1271 PG20)
[  126.503692] wl1271: booting firmware ti-connectivity/wl1271-fw-2.bin
[  126.775756] wl1271: pause1 0xf03
[  126.788818] wl1271: DRPW_SCRATCH_START 0031002c
[  126.793731] wl1271: clk2 0x0
[  126.800354] wl1271: soft reset bootdata 0x0
[  126.809570] wl1271: nvs burst write 0x30546c: 0xdeadbeef
[  126.817321] wl1271: nvs burst write 0x305470: 0xbad
[  126.824615] wl1271: ACX_EEPROMLESS_IND_REG
[  126.830261] wl1271: chip id 0x4030111
[  126.835357] wl1271: firmware chunks to be uploaded: 6
[  126.840698] wl1271: chunk 5 addr 0x0 len 196100
[  126.845611] wl1271: starting firmware upload
[  126.850219] wl1271: fw_data_len 196100 chunk_size 512
[  126.857818] wl1271: uploading fw chunk 0xd156000c to 0x0
[  126.863616] wl1271: uploading fw chunk 0xd156020c to 0x200
[  126.873596] wl1271: uploading fw chunk 0xd156040c to 0x400
[  126.879577] wl1271: uploading fw chunk 0xd156060c to 0x600
[  126.887359] wl1271: uploading fw chunk 0xd156080c to 0x800
[  126.894378] wl1271: uploading fw chunk 0xd1560a0c to 0xa00
[  126.901397] wl1271: uploading fw chunk 0xd1560c0c to 0xc00
[  126.908416] wl1271: uploading fw chunk 0xd1560e0c to 0xe00
[  126.915527] wl1271: uploading fw chunk 0xd156100c to 0x1000
[  126.922637] wl1271: uploading fw chunk 0xd156120c to 0x1200
[  126.929748] wl1271: uploading fw chunk 0xd156140c to 0x1400
[  126.936859] wl1271: uploading fw chunk 0xd156160c to 0x1600
[  126.943969] wl1271: uploading fw chunk 0xd156180c to 0x1800
[  126.950042] wl1271: uploading fw chunk 0xd1561a0c to 0x1a00
[  126.957977] wl1271: uploading fw chunk 0xd1561c0c to 0x1c00
[  126.965118] wl1271: uploading fw chunk 0xd1561e0c to 0x1e00
[  126.975402] wl1271: uploading fw chunk 0xd156200c to 0x2000
[  126.981506] wl1271: uploading fw chunk 0xd156220c to 0x2200
[  126.988555] wl1271: uploading fw chunk 0xd156240c to 0x2400
[  126.995178] wl1271: uploading fw chunk 0xd156260c to 0x2600
[  127.001739] wl1271: uploading fw chunk 0xd156280c to 0x2800
[  127.008422] wl1271: uploading fw chunk 0xd1562a0c to 0x2a00
[  127.015014] wl1271: uploading fw chunk 0xd1562c0c to 0x2c00
[  127.021575] wl1271: uploading fw chunk 0xd1562e0c to 0x2e00
[  127.027648] wl1271: uploading fw chunk 0xd156300c to 0x3000
[  127.034545] wl1271: uploading fw chunk 0xd156320c to 0x3200
[  127.041107] wl1271: uploading fw chunk 0xd156340c to 0x3400
[  127.047668] wl1271: uploading fw chunk 0xd156360c to 0x3600
[  127.054199] wl1271: uploading fw chunk 0xd156380c to 0x3800
[  127.060302] wl1271: uploading fw chunk 0xd1563a0c to 0x3a00
[  127.066375] wl1271: uploading fw chunk 0xd1563c0c to 0x3c00
[  127.072509] wl1271: uploading fw chunk 0xd1563e0c to 0x3e00
[  127.078643] wl1271: uploading fw chunk 0xd156400c to 0x4000
[  127.084777] wl1271: uploading fw chunk 0xd156420c to 0x4200
[  127.090850] wl1271: uploading fw chunk 0xd156440c to 0x4400
[  127.098632] wl1271: uploading fw chunk 0xd156460c to 0x4600
[  127.104797] wl1271: uploading fw chunk 0xd156480c to 0x4800
[  127.110961] wl1271: uploading fw chunk 0xd1564a0c to 0x4a00
[  127.118286] wl1271: uploading fw chunk 0xd1564c0c to 0x4c00
[  127.124450] wl1271: uploading fw chunk 0xd1564e0c to 0x4e00
[  127.130584] wl1271: uploading fw chunk 0xd156500c to 0x5000
[  127.136627] wl1271: uploading fw chunk 0xd156520c to 0x5200
[  127.143157] wl1271: uploading fw chunk 0xd156540c to 0x5400
[  127.149719] wl1271: uploading fw chunk 0xd156560c to 0x5600
[  127.155883] wl1271: uploading fw chunk 0xd156580c to 0x5800
[  127.162017] wl1271: uploading fw chunk 0xd1565a0c to 0x5a00
[  127.168060] wl1271: uploading fw chunk 0xd1565c0c to 0x5c00
[  127.174194] wl1271: uploading fw chunk 0xd1565e0c to 0x5e00
[  127.180328] wl1271: uploading fw chunk 0xd156600c to 0x6000
[  127.186462] wl1271: uploading fw chunk 0xd156620c to 0x6200
[  127.192535] wl1271: uploading fw chunk 0xd156640c to 0x6400
[  127.198669] wl1271: uploading fw chunk 0xd156660c to 0x6600
[  127.204803] wl1271: uploading fw chunk 0xd156680c to 0x6800
[  127.210937] wl1271: uploading fw chunk 0xd1566a0c to 0x6a00
[  127.217071] wl1271: uploading fw chunk 0xd1566c0c to 0x6c00
[  127.223480] wl1271: uploading fw chunk 0xd1566e0c to 0x6e00
[  127.229614] wl1271: uploading fw chunk 0xd156700c to 0x7000
[  127.235748] wl1271: uploading fw chunk 0xd156720c to 0x7200
[  127.241882] wl1271: uploading fw chunk 0xd156740c to 0x7400
[  127.248016] wl1271: uploading fw chunk 0xd156760c to 0x7600
[  127.254089] wl1271: uploading fw chunk 0xd156780c to 0x7800
[  127.260192] wl1271: uploading fw chunk 0xd1567a0c to 0x7a00
[  127.266326] wl1271: uploading fw chunk 0xd1567c0c to 0x7c00
[  127.272460] wl1271: uploading fw chunk 0xd1567e0c to 0x7e00
[  127.278564] wl1271: uploading fw chunk 0xd156800c to 0x8000
[  127.284637] wl1271: uploading fw chunk 0xd156820c to 0x8200
[  127.290740] wl1271: uploading fw chunk 0xd156840c to 0x8400
[  127.296874] wl1271: uploading fw chunk 0xd156860c to 0x8600
[  127.303131] wl1271: uploading fw chunk 0xd156880c to 0x8800
[  127.309204] wl1271: uploading fw chunk 0xd1568a0c to 0x8a00
[  127.315429] wl1271: uploading fw chunk 0xd1568c0c to 0x8c00
[  127.321563] wl1271: uploading fw chunk 0xd1568e0c to 0x8e00
[  127.327697] wl1271: uploading fw chunk 0xd156900c to 0x9000
[  127.333831] wl1271: uploading fw chunk 0xd156920c to 0x9200
[  127.339874] wl1271: uploading fw chunk 0xd156940c to 0x9400
[  127.346832] wl1271: uploading fw chunk 0xd156960c to 0x9600
[  127.368499] wl1271: uploading fw chunk 0xd156980c to 0x9800
[  127.375274] wl1271: uploading fw chunk 0xd1569a0c to 0x9a00
[  127.400299] wl1271: uploading fw chunk 0xd1569c0c to 0x9c00
[  127.410888] wl1271: uploading fw chunk 0xd1569e0c to 0x9e00
[  127.426757] wl1271: uploading fw chunk 0xd156a00c to 0xa000
[  127.434020] wl1271: uploading fw chunk 0xd156a20c to 0xa200
[  127.441162] wl1271: uploading fw chunk 0xd156a40c to 0xa400
[  127.448303] wl1271: uploading fw chunk 0xd156a60c to 0xa600
[  127.455413] wl1271: uploading fw chunk 0xd156a80c to 0xa800
[  127.462524] wl1271: uploading fw chunk 0xd156aa0c to 0xaa00
[  127.469635] wl1271: uploading fw chunk 0xd156ac0c to 0xac00
[  127.476715] wl1271: uploading fw chunk 0xd156ae0c to 0xae00
[  127.483825] wl1271: uploading fw chunk 0xd156b00c to 0xb000
[  127.490936] wl1271: uploading fw chunk 0xd156b20c to 0xb200
[  127.497009] wl1271: uploading fw chunk 0xd156b40c to 0xb400
[  127.504882] wl1271: uploading fw chunk 0xd156b60c to 0xb600
[  127.512054] wl1271: uploading fw chunk 0xd156b80c to 0xb800
[  127.519195] wl1271: uploading fw chunk 0xd156ba0c to 0xba00
[  127.526306] wl1271: uploading fw chunk 0xd156bc0c to 0xbc00
[  127.533416] wl1271: uploading fw chunk 0xd156be0c to 0xbe00
[  127.540527] wl1271: uploading fw chunk 0xd156c00c to 0xc000
[  127.547637] wl1271: uploading fw chunk 0xd156c20c to 0xc200
[  127.554748] wl1271: uploading fw chunk 0xd156c40c to 0xc400
[  127.561950] wl1271: uploading fw chunk 0xd156c60c to 0xc600
[  127.569061] wl1271: uploading fw chunk 0xd156c80c to 0xc800
[  127.575134] wl1271: uploading fw chunk 0xd156ca0c to 0xca00
[  127.583007] wl1271: uploading fw chunk 0xd156cc0c to 0xcc00
[  127.590118] wl1271: uploading fw chunk 0xd156ce0c to 0xce00
[  127.597229] wl1271: uploading fw chunk 0xd156d00c to 0xd000
[  127.604339] wl1271: uploading fw chunk 0xd156d20c to 0xd200
[  127.611450] wl1271: uploading fw chunk 0xd156d40c to 0xd400
[  127.618560] wl1271: uploading fw chunk 0xd156d60c to 0xd600
[  127.625671] wl1271: uploading fw chunk 0xd156d80c to 0xd800
[  127.632781] wl1271: uploading fw chunk 0xd156da0c to 0xda00
[  127.639892] wl1271: uploading fw chunk 0xd156dc0c to 0xdc00
[  127.647003] wl1271: uploading fw chunk 0xd156de0c to 0xde00
[  127.653045] wl1271: uploading fw chunk 0xd156e00c to 0xe000
[  127.660919] wl1271: uploading fw chunk 0xd156e20c to 0xe200
[  127.667999] wl1271: uploading fw chunk 0xd156e40c to 0xe400
[  127.675109] wl1271: uploading fw chunk 0xd156e60c to 0xe600
[  127.682220] wl1271: uploading fw chunk 0xd156e80c to 0xe800
[  127.689331] wl1271: uploading fw chunk 0xd156ea0c to 0xea00
[  127.696777] wl1271: uploading fw chunk 0xd156ec0c to 0xec00
[  127.704193] wl1271: uploading fw chunk 0xd156ee0c to 0xee00
[  127.711395] wl1271: uploading fw chunk 0xd156f00c to 0xf000
[  127.718566] wl1271: uploading fw chunk 0xd156f20c to 0xf200
[  127.725708] wl1271: uploading fw chunk 0xd156f40c to 0xf400
[  127.732940] wl1271: uploading fw chunk 0xd156f60c to 0xf600
[  127.738983] wl1271: uploading fw chunk 0xd156f80c to 0xf800
[  127.746887] wl1271: uploading fw chunk 0xd156fa0c to 0xfa00
[  127.753997] wl1271: uploading fw chunk 0xd156fc0c to 0xfc00
[  127.761138] wl1271: uploading fw chunk 0xd156fe0c to 0xfe00
[  127.768249] wl1271: uploading fw chunk 0xd157000c to 0x10000
[  127.775451] wl1271: uploading fw chunk 0xd157020c to 0x10200
[  127.782684] wl1271: uploading fw chunk 0xd157040c to 0x10400
[  127.789855] wl1271: uploading fw chunk 0xd157060c to 0x10600
[  127.797088] wl1271: uploading fw chunk 0xd157080c to 0x10800
[  127.804260] wl1271: uploading fw chunk 0xd1570a0c to 0x10a00
[  127.811737] wl1271: uploading fw chunk 0xd1570c0c to 0x10c00
[  127.819030] wl1271: uploading fw chunk 0xd1570e0c to 0x10e00
[  127.825195] wl1271: uploading fw chunk 0xd157100c to 0x11000
[  127.833251] wl1271: uploading fw chunk 0xd157120c to 0x11200
[  127.839416] wl1271: uploading fw chunk 0xd157140c to 0x11400
[  127.847381] wl1271: uploading fw chunk 0xd157160c to 0x11600
[  127.854583] wl1271: uploading fw chunk 0xd157180c to 0x11800
[  127.861877] wl1271: uploading fw chunk 0xd1571a0c to 0x11a00
[  127.869110] wl1271: uploading fw chunk 0xd1571c0c to 0x11c00
[  127.876312] wl1271: uploading fw chunk 0xd1571e0c to 0x11e00
[  127.883514] wl1271: uploading fw chunk 0xd157200c to 0x12000
[  127.890716] wl1271: uploading fw chunk 0xd157220c to 0x12200
[  127.897918] wl1271: uploading fw chunk 0xd157240c to 0x12400
[  127.905120] wl1271: uploading fw chunk 0xd157260c to 0x12600
[  127.911285] wl1271: uploading fw chunk 0xd157280c to 0x12800
[  127.919342] wl1271: uploading fw chunk 0xd1572a0c to 0x12a00
[  127.925476] wl1271: uploading fw chunk 0xd1572c0c to 0x12c00
[  127.933441] wl1271: uploading fw chunk 0xd1572e0c to 0x12e00
[  127.940643] wl1271: uploading fw chunk 0xd157300c to 0x13000
[  127.947845] wl1271: uploading fw chunk 0xd157320c to 0x13200
[  127.955047] wl1271: uploading fw chunk 0xd157340c to 0x13400
[  127.962219] wl1271: uploading fw chunk 0xd157360c to 0x13600
[  127.969421] wl1271: uploading fw chunk 0xd157380c to 0x13800
[  127.976623] wl1271: uploading fw chunk 0xd1573a0c to 0x13a00
[  127.983825] wl1271: uploading fw chunk 0xd1573c0c to 0x13c00
[  127.991027] wl1271: uploading fw chunk 0xd1573e0c to 0x13e00
[  127.997131] wl1271: uploading fw chunk 0xd157400c to 0x14000
[  128.005523] wl1271: uploading fw chunk 0xd157420c to 0x14200
[  128.011688] wl1271: uploading fw chunk 0xd157440c to 0x14400
[  128.019805] wl1271: uploading fw chunk 0xd157460c to 0x14600
[  128.027069] wl1271: uploading fw chunk 0xd157480c to 0x14800
[  128.034393] wl1271: uploading fw chunk 0xd1574a0c to 0x14a00
[  128.041625] wl1271: uploading fw chunk 0xd1574c0c to 0x14c00
[  128.048828] wl1271: uploading fw chunk 0xd1574e0c to 0x14e00
[  128.056243] wl1271: uploading fw chunk 0xd157500c to 0x15000
[  128.063507] wl1271: uploading fw chunk 0xd157520c to 0x15200
[  128.070739] wl1271: uploading fw chunk 0xd157540c to 0x15400
[  128.077941] wl1271: uploading fw chunk 0xd157560c to 0x15600
[  128.085174] wl1271: uploading fw chunk 0xd157580c to 0x15800
[  128.092376] wl1271: uploading fw chunk 0xd1575a0c to 0x15a00
[  128.098541] wl1271: uploading fw chunk 0xd1575c0c to 0x15c00
[  128.106506] wl1271: uploading fw chunk 0xd1575e0c to 0x15e00
[  128.113800] wl1271: uploading fw chunk 0xd157600c to 0x16000
[  128.121032] wl1271: uploading fw chunk 0xd157620c to 0x16200
[  128.128234] wl1271: uploading fw chunk 0xd157640c to 0x16400
[  128.135467] wl1271: uploading fw chunk 0xd157660c to 0x16600
[  128.142669] wl1271: uploading fw chunk 0xd157680c to 0x16800
[  128.149993] wl1271: uploading fw chunk 0xd1576a0c to 0x16a00
[  128.157226] wl1271: uploading fw chunk 0xd1576c0c to 0x16c00
[  128.164520] wl1271: uploading fw chunk 0xd1576e0c to 0x16e00
[  128.171752] wl1271: uploading fw chunk 0xd157700c to 0x17000
[  128.178985] wl1271: uploading fw chunk 0xd157720c to 0x17200
[  128.186981] wl1271: uploading fw chunk 0xd157740c to 0x17400
[  128.194183] wl1271: uploading fw chunk 0xd157760c to 0x17600
[  128.200317] wl1271: uploading fw chunk 0xd157780c to 0x17800
[  128.208404] wl1271: uploading fw chunk 0xd1577a0c to 0x17a00
[  128.214538] wl1271: uploading fw chunk 0xd1577c0c to 0x17c00
[  128.222503] wl1271: uploading fw chunk 0xd1577e0c to 0x17e00
[  128.229736] wl1271: uploading fw chunk 0xd157800c to 0x18000
[  128.236938] wl1271: uploading fw chunk 0xd157820c to 0x18200
[  128.244140] wl1271: uploading fw chunk 0xd157840c to 0x18400
[  128.251342] wl1271: uploading fw chunk 0xd157860c to 0x18600
[  128.258544] wl1271: uploading fw chunk 0xd157880c to 0x18800
[  128.265747] wl1271: uploading fw chunk 0xd1578a0c to 0x18a00
[  128.272949] wl1271: uploading fw chunk 0xd1578c0c to 0x18c00
[  128.280151] wl1271: uploading fw chunk 0xd1578e0c to 0x18e00
[  128.287384] wl1271: uploading fw chunk 0xd157900c to 0x19000
[  128.293518] wl1271: uploading fw chunk 0xd157920c to 0x19200
[  128.301513] wl1271: uploading fw chunk 0xd157940c to 0x19400
[  128.308715] wl1271: uploading fw chunk 0xd157960c to 0x19600
[  128.316040] wl1271: uploading fw chunk 0xd157980c to 0x19800
[  128.323272] wl1271: uploading fw chunk 0xd1579a0c to 0x19a00
[  128.330474] wl1271: uploading fw chunk 0xd1579c0c to 0x19c00
[  128.337768] wl1271: uploading fw chunk 0xd1579e0c to 0x19e00
[  128.345001] wl1271: uploading fw chunk 0xd157a00c to 0x1a000
[  128.352233] wl1271: uploading fw chunk 0xd157a20c to 0x1a200
[  128.359954] wl1271: uploading fw chunk 0xd157a40c to 0x1a400
[  128.367279] wl1271: uploading fw chunk 0xd157a60c to 0x1a600
[  128.374572] wl1271: uploading fw chunk 0xd157a80c to 0x1a800
[  128.381805] wl1271: uploading fw chunk 0xd157aa0c to 0x1aa00
[  128.389038] wl1271: uploading fw chunk 0xd157ac0c to 0x1ac00
[  128.395172] wl1271: uploading fw chunk 0xd157ae0c to 0x1ae00
[  128.403167] wl1271: uploading fw chunk 0xd157b00c to 0x1b000
[  128.410369] wl1271: uploading fw chunk 0xd157b20c to 0x1b200
[  128.417663] wl1271: uploading fw chunk 0xd157b40c to 0x1b400
[  128.424896] wl1271: uploading fw chunk 0xd157b60c to 0x1b600
[  128.432128] wl1271: uploading fw chunk 0xd157b80c to 0x1b800
[  128.439361] wl1271: uploading fw chunk 0xd157ba0c to 0x1ba00
[  128.446563] wl1271: uploading fw chunk 0xd157bc0c to 0x1bc00
[  128.453765] wl1271: uploading fw chunk 0xd157be0c to 0x1be00
[  128.460968] wl1271: uploading fw chunk 0xd157c00c to 0x1c000
[  128.468261] wl1271: uploading fw chunk 0xd157c20c to 0x1c200
[  128.475463] wl1271: uploading fw chunk 0xd157c40c to 0x1c400
[  128.482696] wl1271: uploading fw chunk 0xd157c60c to 0x1c600
[  128.488861] wl1271: uploading fw chunk 0xd157c80c to 0x1c800
[  128.496826] wl1271: uploading fw chunk 0xd157ca0c to 0x1ca00
[  128.504028] wl1271: uploading fw chunk 0xd157cc0c to 0x1cc00
[  128.511230] wl1271: uploading fw chunk 0xd157ce0c to 0x1ce00
[  128.518432] wl1271: uploading fw chunk 0xd157d00c to 0x1d000
[  128.525634] wl1271: uploading fw chunk 0xd157d20c to 0x1d200
[  128.532836] wl1271: uploading fw chunk 0xd157d40c to 0x1d400
[  128.540069] wl1271: uploading fw chunk 0xd157d60c to 0x1d600
[  128.547241] wl1271: uploading fw chunk 0xd157d80c to 0x1d800
[  128.554443] wl1271: uploading fw chunk 0xd157da0c to 0x1da00
[  128.561645] wl1271: uploading fw chunk 0xd157dc0c to 0x1dc00
[  128.568847] wl1271: uploading fw chunk 0xd157de0c to 0x1de00
[  128.574981] wl1271: uploading fw chunk 0xd157e00c to 0x1e000
[  128.582977] wl1271: uploading fw chunk 0xd157e20c to 0x1e200
[  128.590179] wl1271: uploading fw chunk 0xd157e40c to 0x1e400
[  128.597412] wl1271: uploading fw chunk 0xd157e60c to 0x1e600
[  128.604614] wl1271: uploading fw chunk 0xd157e80c to 0x1e800
[  128.611816] wl1271: uploading fw chunk 0xd157ea0c to 0x1ea00
[  128.619018] wl1271: uploading fw chunk 0xd157ec0c to 0x1ec00
[  128.626220] wl1271: uploading fw chunk 0xd157ee0c to 0x1ee00
[  128.633422] wl1271: uploading fw chunk 0xd157f00c to 0x1f000
[  128.640686] wl1271: uploading fw chunk 0xd157f20c to 0x1f200
[  128.647918] wl1271: uploading fw chunk 0xd157f40c to 0x1f400
[  128.655364] wl1271: uploading fw chunk 0xd157f60c to 0x1f600
[  128.662597] wl1271: uploading fw chunk 0xd157f80c to 0x1f800
[  128.668762] wl1271: uploading fw chunk 0xd157fa0c to 0x1fa00
[  128.676727] wl1271: uploading fw chunk 0xd157fc0c to 0x1fc00
[  128.683959] wl1271: uploading fw chunk 0xd157fe0c to 0x1fe00
[  128.691162] wl1271: uploading fw chunk 0xd158000c to 0x20000
[  128.698364] wl1271: uploading fw chunk 0xd158020c to 0x20200
[  128.705596] wl1271: uploading fw chunk 0xd158040c to 0x20400
[  128.712768] wl1271: uploading fw chunk 0xd158060c to 0x20600
[  128.720062] wl1271: uploading fw chunk 0xd158080c to 0x20800
[  128.727264] wl1271: uploading fw chunk 0xd1580a0c to 0x20a00
[  128.734466] wl1271: uploading fw chunk 0xd1580c0c to 0x20c00
[  128.741699] wl1271: uploading fw chunk 0xd1580e0c to 0x20e00
[  128.748870] wl1271: uploading fw chunk 0xd158100c to 0x21000
[  128.755035] wl1271: uploading fw chunk 0xd158120c to 0x21200
[  128.763183] wl1271: uploading fw chunk 0xd158140c to 0x21400
[  128.769317] wl1271: uploading fw chunk 0xd158160c to 0x21600
[  128.777313] wl1271: uploading fw chunk 0xd158180c to 0x21800
[  128.784515] wl1271: uploading fw chunk 0xd1581a0c to 0x21a00
[  128.791748] wl1271: uploading fw chunk 0xd1581c0c to 0x21c00
[  128.798950] wl1271: uploading fw chunk 0xd1581e0c to 0x21e00
[  128.806152] wl1271: uploading fw chunk 0xd158200c to 0x22000
[  128.813354] wl1271: uploading fw chunk 0xd158220c to 0x22200
[  128.820587] wl1271: uploading fw chunk 0xd158240c to 0x22400
[  128.827789] wl1271: uploading fw chunk 0xd158260c to 0x22600
[  128.834991] wl1271: uploading fw chunk 0xd158280c to 0x22800
[  128.842193] wl1271: uploading fw chunk 0xd1582a0c to 0x22a00
[  128.848358] wl1271: uploading fw chunk 0xd1582c0c to 0x22c00
[  128.856292] wl1271: uploading fw chunk 0xd1582e0c to 0x22e00
[  128.863494] wl1271: uploading fw chunk 0xd158300c to 0x23000
[  128.870727] wl1271: uploading fw chunk 0xd158320c to 0x23200
[  128.877929] wl1271: uploading fw chunk 0xd158340c to 0x23400
[  128.885131] wl1271: uploading fw chunk 0xd158360c to 0x23600
[  128.892333] wl1271: uploading fw chunk 0xd158380c to 0x23800
[  128.899536] wl1271: uploading fw chunk 0xd1583a0c to 0x23a00
[  128.906738] wl1271: uploading fw chunk 0xd1583c0c to 0x23c00
[  128.913940] wl1271: uploading fw chunk 0xd1583e0c to 0x23e00
[  128.921142] wl1271: uploading fw chunk 0xd158400c to 0x24000
[  128.928344] wl1271: uploading fw chunk 0xd158420c to 0x24200
[  128.934509] wl1271: uploading fw chunk 0xd158440c to 0x24400
[  128.942535] wl1271: uploading fw chunk 0xd158460c to 0x24600
[  128.949768] wl1271: uploading fw chunk 0xd158480c to 0x24800
[  128.956970] wl1271: uploading fw chunk 0xd1584a0c to 0x24a00
[  128.964172] wl1271: uploading fw chunk 0xd1584c0c to 0x24c00
[  128.971405] wl1271: uploading fw chunk 0xd1584e0c to 0x24e00
[  128.978607] wl1271: uploading fw chunk 0xd158500c to 0x25000
[  128.985809] wl1271: uploading fw chunk 0xd158520c to 0x25200
[  128.993011] wl1271: uploading fw chunk 0xd158540c to 0x25400
[  129.000213] wl1271: uploading fw chunk 0xd158560c to 0x25600
[  129.007568] wl1271: uploading fw chunk 0xd158580c to 0x25800
[  129.014770] wl1271: uploading fw chunk 0xd1585a0c to 0x25a00
[  129.022094] wl1271: uploading fw chunk 0xd1585c0c to 0x25c00
[  129.028228] wl1271: uploading fw chunk 0xd1585e0c to 0x25e00
[  129.036193] wl1271: uploading fw chunk 0xd158600c to 0x26000
[  129.043426] wl1271: uploading fw chunk 0xd158620c to 0x26200
[  129.050659] wl1271: uploading fw chunk 0xd158640c to 0x26400
[  129.057861] wl1271: uploading fw chunk 0xd158660c to 0x26600
[  129.065155] wl1271: uploading fw chunk 0xd158680c to 0x26800
[  129.072540] wl1271: uploading fw chunk 0xd1586a0c to 0x26a00
[  129.079803] wl1271: uploading fw chunk 0xd1586c0c to 0x26c00
[  129.087005] wl1271: uploading fw chunk 0xd1586e0c to 0x26e00
[  129.094238] wl1271: uploading fw chunk 0xd158700c to 0x27000
[  129.101440] wl1271: uploading fw chunk 0xd158720c to 0x27200
[  129.109191] wl1271: uploading fw chunk 0xd158740c to 0x27400
[  129.116516] wl1271: uploading fw chunk 0xd158760c to 0x27600
[  129.123779] wl1271: uploading fw chunk 0xd158780c to 0x27800
[  129.129913] wl1271: uploading fw chunk 0xd1587a0c to 0x27a00
[  129.138000] wl1271: uploading fw chunk 0xd1587c0c to 0x27c00
[  129.144134] wl1271: uploading fw chunk 0xd1587e0c to 0x27e00
[  129.152587] wl1271: uploading fw chunk 0xd158800c to 0x28000
[  129.159851] wl1271: uploading fw chunk 0xd158820c to 0x28200
[  129.167083] wl1271: uploading fw chunk 0xd158840c to 0x28400
[  129.174316] wl1271: uploading fw chunk 0xd158860c to 0x28600
[  129.181518] wl1271: uploading fw chunk 0xd158880c to 0x28800
[  129.188751] wl1271: uploading fw chunk 0xd1588a0c to 0x28a00
[  129.195953] wl1271: uploading fw chunk 0xd1588c0c to 0x28c00
[  129.203155] wl1271: uploading fw chunk 0xd1588e0c to 0x28e00
[  129.210357] wl1271: uploading fw chunk 0xd158900c to 0x29000
[  129.217559] wl1271: uploading fw chunk 0xd158920c to 0x29200
[  129.223724] wl1271: uploading fw chunk 0xd158940c to 0x29400
[  129.231781] wl1271: uploading fw chunk 0xd158960c to 0x29600
[  129.237915] wl1271: uploading fw chunk 0xd158980c to 0x29800
[  129.245971] wl1271: uploading fw chunk 0xd1589a0c to 0x29a00
[  129.253204] wl1271: uploading fw chunk 0xd1589c0c to 0x29c00
[  129.260406] wl1271: uploading fw chunk 0xd1589e0c to 0x29e00
[  129.267608] wl1271: uploading fw chunk 0xd158a00c to 0x2a000
[  129.274810] wl1271: uploading fw chunk 0xd158a20c to 0x2a200
[  129.282012] wl1271: uploading fw chunk 0xd158a40c to 0x2a400
[  129.289215] wl1271: uploading fw chunk 0xd158a60c to 0x2a600
[  129.296417] wl1271: uploading fw chunk 0xd158a80c to 0x2a800
[  129.303619] wl1271: uploading fw chunk 0xd158aa0c to 0x2aa00
[  129.310974] wl1271: uploading fw chunk 0xd158ac0c to 0x2ac00
[  129.317108] wl1271: uploading fw chunk 0xd158ae0c to 0x2ae00
[  129.325195] wl1271: uploading fw chunk 0xd158b00c to 0x2b000
[  129.332427] wl1271: uploading fw chunk 0xd158b20c to 0x2b200
[  129.339630] wl1271: uploading fw chunk 0xd158b40c to 0x2b400
[  129.346832] wl1271: uploading fw chunk 0xd158b60c to 0x2b600
[  129.354064] wl1271: uploading fw chunk 0xd158b80c to 0x2b800
[  129.361267] wl1271: uploading fw chunk 0xd158ba0c to 0x2ba00
[  129.368530] wl1271: uploading fw chunk 0xd158bc0c to 0x2bc00
[  129.375762] wl1271: uploading fw chunk 0xd158be0c to 0x2be00
[  129.382965] wl1271: uploading fw chunk 0xd158c00c to 0x2c000
[  129.390167] wl1271: uploading fw chunk 0xd158c20c to 0x2c200
[  129.397369] wl1271: uploading fw chunk 0xd158c40c to 0x2c400
[  129.404571] wl1271: uploading fw chunk 0xd158c60c to 0x2c600
[  129.410736] wl1271: uploading fw chunk 0xd158c80c to 0x2c800
[  129.419067] wl1271: uploading fw chunk 0xd158ca0c to 0x2ca00
[  129.426300] wl1271: uploading fw chunk 0xd158cc0c to 0x2cc00
[  129.433532] wl1271: uploading fw chunk 0xd158ce0c to 0x2ce00
[  129.440734] wl1271: uploading fw chunk 0xd158d00c to 0x2d000
[  129.447937] wl1271: uploading fw chunk 0xd158d20c to 0x2d200
[  129.455139] wl1271: uploading fw chunk 0xd158d40c to 0x2d400
[  129.462371] wl1271: uploading fw chunk 0xd158d60c to 0x2d600
[  129.469573] wl1271: uploading fw chunk 0xd158d80c to 0x2d800
[  129.476776] wl1271: uploading fw chunk 0xd158da0c to 0x2da00
[  129.483978] wl1271: uploading fw chunk 0xd158dc0c to 0x2dc00
[  129.491180] wl1271: uploading fw chunk 0xd158de0c to 0x2de00
[  129.497467] wl1271: uploading fw chunk 0xd158e00c to 0x2e000
[  129.504730] wl1271: uploading fw chunk 0xd158e20c to 0x2e200
[  129.512878] wl1271: uploading fw chunk 0xd158e40c to 0x2e400
[  129.520111] wl1271: uploading fw chunk 0xd158e60c to 0x2e600
[  129.528106] wl1271: uploading fw chunk 0xd158e80c to 0x2e800
[  129.535308] wl1271: uploading fw chunk 0xd158ea0c to 0x2ea00
[  129.542602] wl1271: uploading fw chunk 0xd158ec0c to 0x2ec00
[  129.549835] wl1271: uploading fw chunk 0xd158ee0c to 0x2ee00
[  129.557037] wl1271: uploading fw chunk 0xd158f00c to 0x2f000
[  129.564270] wl1271: uploading fw chunk 0xd158f20c to 0x2f200
[  129.571472] wl1271: uploading fw chunk 0xd158f40c to 0x2f400
[  129.578674] wl1271: uploading fw chunk 0xd158f60c to 0x2f600
[  129.585876] wl1271: uploading fw chunk 0xd158f80c to 0x2f800
[  129.593078] wl1271: uploading fw chunk 0xd158fa0c to 0x2fa00
[  129.600280] wl1271: uploading fw chunk 0xd158fc0c to 0x2fc00
[  129.606414] wl1271: uploading fw last chunk (4 B) 0xd158fe0c to 0x2fe00
[  129.615478] wl1271: chunk 4 addr 0x20000000 len 48972
[  129.620819] wl1271: starting firmware upload
[  129.625457] wl1271: fw_data_len 48972 chunk_size 512
[  129.633605] wl1271: uploading fw chunk 0xd158fe18 to 0x20000000
[  129.643249] wl1271: uploading fw chunk 0xd1590018 to 0x20000200
[  129.651519] wl1271: uploading fw chunk 0xd1590218 to 0x20000400
[  129.659759] wl1271: uploading fw chunk 0xd1590418 to 0x20000600
[  129.668029] wl1271: uploading fw chunk 0xd1590618 to 0x20000800
[  129.676361] wl1271: uploading fw chunk 0xd1590818 to 0x20000a00
[  129.684631] wl1271: uploading fw chunk 0xd1590a18 to 0x20000c00
[  129.692962] wl1271: uploading fw chunk 0xd1590c18 to 0x20000e00
[  129.700164] wl1271: uploading fw chunk 0xd1590e18 to 0x20001000
[  129.709289] wl1271: uploading fw chunk 0xd1591018 to 0x20001200
[  129.717590] wl1271: uploading fw chunk 0xd1591218 to 0x20001400
[  129.725860] wl1271: uploading fw chunk 0xd1591418 to 0x20001600
[  129.734100] wl1271: uploading fw chunk 0xd1591618 to 0x20001800
[  129.742370] wl1271: uploading fw chunk 0xd1591818 to 0x20001a00
[  129.750610] wl1271: uploading fw chunk 0xd1591a18 to 0x20001c00
[  129.758850] wl1271: uploading fw chunk 0xd1591c18 to 0x20001e00
[  129.767089] wl1271: uploading fw chunk 0xd1591e18 to 0x20002000
[  129.775329] wl1271: uploading fw chunk 0xd1592018 to 0x20002200
[  129.783569] wl1271: uploading fw chunk 0xd1592218 to 0x20002400
[  129.800170] wl1271: uploading fw chunk 0xd1592418 to 0x20002600
[  129.808807] wl1271: uploading fw chunk 0xd1592618 to 0x20002800
[  129.817352] wl1271: uploading fw chunk 0xd1592818 to 0x20002a00
[  129.825805] wl1271: uploading fw chunk 0xd1592a18 to 0x20002c00
[  129.832946] wl1271: uploading fw chunk 0xd1592c18 to 0x20002e00
[  129.842132] wl1271: uploading fw chunk 0xd1592e18 to 0x20003000
[  129.850463] wl1271: uploading fw chunk 0xd1593018 to 0x20003200
[  129.858734] wl1271: uploading fw chunk 0xd1593218 to 0x20003400
[  129.866973] wl1271: uploading fw chunk 0xd1593418 to 0x20003600
[  129.875305] wl1271: uploading fw chunk 0xd1593618 to 0x20003800
[  129.883575] wl1271: uploading fw chunk 0xd1593818 to 0x20003a00
[  129.891815] wl1271: uploading fw chunk 0xd1593a18 to 0x20003c00
[  129.900054] wl1271: uploading fw chunk 0xd1593c18 to 0x20003e00
[  129.908294] wl1271: uploading fw chunk 0xd1593e18 to 0x20004000
[  129.916503] wl1271: uploading fw chunk 0xd1594018 to 0x20004200
[  129.924743] wl1271: uploading fw chunk 0xd1594218 to 0x20004400
[  129.932952] wl1271: uploading fw chunk 0xd1594418 to 0x20004600
[  129.941192] wl1271: uploading fw chunk 0xd1594618 to 0x20004800
[  129.949432] wl1271: uploading fw chunk 0xd1594818 to 0x20004a00
[  129.957641] wl1271: uploading fw chunk 0xd1594a18 to 0x20004c00
[  129.965942] wl1271: uploading fw chunk 0xd1594c18 to 0x20004e00
[  129.975158] wl1271: uploading fw chunk 0xd1594e18 to 0x20005000
[  129.983612] wl1271: uploading fw chunk 0xd1595018 to 0x20005200
[  129.991912] wl1271: uploading fw chunk 0xd1595218 to 0x20005400
[  130.000152] wl1271: uploading fw chunk 0xd1595418 to 0x20005600
[  130.008911] wl1271: uploading fw chunk 0xd1595618 to 0x20005800
[  130.017822] wl1271: uploading fw chunk 0xd1595818 to 0x20005a00
[  130.026184] wl1271: uploading fw chunk 0xd1595a18 to 0x20005c00
[  130.034454] wl1271: uploading fw chunk 0xd1595c18 to 0x20005e00
[  130.042694] wl1271: uploading fw chunk 0xd1595e18 to 0x20006000
[  130.050933] wl1271: uploading fw chunk 0xd1596018 to 0x20006200
[  130.059173] wl1271: uploading fw chunk 0xd1596218 to 0x20006400
[  130.067413] wl1271: uploading fw chunk 0xd1596418 to 0x20006600
[  130.075714] wl1271: uploading fw chunk 0xd1596618 to 0x20006800
[  130.082885] wl1271: uploading fw chunk 0xd1596818 to 0x20006a00
[  130.091979] wl1271: uploading fw chunk 0xd1596a18 to 0x20006c00
[  130.100189] wl1271: uploading fw chunk 0xd1596c18 to 0x20006e00
[  130.108459] wl1271: uploading fw chunk 0xd1596e18 to 0x20007000
[  130.116668] wl1271: uploading fw chunk 0xd1597018 to 0x20007200
[  130.124908] wl1271: uploading fw chunk 0xd1597218 to 0x20007400
[  130.133148] wl1271: uploading fw chunk 0xd1597418 to 0x20007600
[  130.141357] wl1271: uploading fw chunk 0xd1597618 to 0x20007800
[  130.149719] wl1271: uploading fw chunk 0xd1597818 to 0x20007a00
[  130.157958] wl1271: uploading fw chunk 0xd1597a18 to 0x20007c00
[  130.166229] wl1271: uploading fw chunk 0xd1597c18 to 0x20007e00
[  130.174468] wl1271: uploading fw chunk 0xd1597e18 to 0x20008000
[  130.182678] wl1271: uploading fw chunk 0xd1598018 to 0x20008200
[  130.190917] wl1271: uploading fw chunk 0xd1598218 to 0x20008400
[  130.199157] wl1271: uploading fw chunk 0xd1598418 to 0x20008600
[  130.207366] wl1271: uploading fw chunk 0xd1598618 to 0x20008800
[  130.215667] wl1271: uploading fw chunk 0xd1598818 to 0x20008a00
[  130.223999] wl1271: uploading fw chunk 0xd1598a18 to 0x20008c00
[  130.231170] wl1271: uploading fw chunk 0xd1598c18 to 0x20008e00
[  130.240264] wl1271: uploading fw chunk 0xd1598e18 to 0x20009000
[  130.248535] wl1271: uploading fw chunk 0xd1599018 to 0x20009200
[  130.256805] wl1271: uploading fw chunk 0xd1599218 to 0x20009400
[  130.265045] wl1271: uploading fw chunk 0xd1599418 to 0x20009600
[  130.273284] wl1271: uploading fw chunk 0xd1599618 to 0x20009800
[  130.281494] wl1271: uploading fw chunk 0xd1599818 to 0x20009a00
[  130.289733] wl1271: uploading fw chunk 0xd1599a18 to 0x20009c00
[  130.297973] wl1271: uploading fw chunk 0xd1599c18 to 0x20009e00
[  130.306274] wl1271: uploading fw chunk 0xd1599e18 to 0x2000a000
[  130.314636] wl1271: uploading fw chunk 0xd159a018 to 0x2000a200
[  130.322875] wl1271: uploading fw chunk 0xd159a218 to 0x2000a400
[  130.331115] wl1271: uploading fw chunk 0xd159a418 to 0x2000a600
[  130.339355] wl1271: uploading fw chunk 0xd159a618 to 0x2000a800
[  130.348419] wl1271: uploading fw chunk 0xd159a818 to 0x2000aa00
[  130.357696] wl1271: uploading fw chunk 0xd159aa18 to 0x2000ac00
[  130.366119] wl1271: uploading fw chunk 0xd159ac18 to 0x2000ae00
[  130.374420] wl1271: uploading fw chunk 0xd159ae18 to 0x2000b000
[  130.382690] wl1271: uploading fw chunk 0xd159b018 to 0x2000b200
[  130.390930] wl1271: uploading fw chunk 0xd159b218 to 0x2000b400
[  130.399169] wl1271: uploading fw chunk 0xd159b418 to 0x2000b600
[  130.407379] wl1271: uploading fw chunk 0xd159b618 to 0x2000b800
[  130.415618] wl1271: uploading fw chunk 0xd159b818 to 0x2000ba00
[  130.423858] wl1271: uploading fw chunk 0xd159ba18 to 0x2000bc00
[  130.431304] wl1271: uploading fw last chunk (332 B) 0xd159bc18 to 0x2000be00
[  130.440002] wl1271: chunk 3 addr 0x40000 len 448
[  130.445007] wl1271: starting firmware upload
[  130.449523] wl1271: fw_data_len 448 chunk_size 512
[  130.456634] wl1271: uploading fw last chunk (448 B) 0xd159bd6c to 0x40000
[  130.465423] wl1271: chunk 2 addr 0x40be0 len 16432
[  130.470581] wl1271: starting firmware upload
[  130.475189] wl1271: fw_data_len 16432 chunk_size 512
[  130.485473] wl1271: uploading fw chunk 0xd159bf34 to 0x40be0
[  130.493408] wl1271: uploading fw chunk 0xd159c134 to 0x40de0
[  130.501342] wl1271: uploading fw chunk 0xd159c334 to 0x40fe0
[  130.509307] wl1271: uploading fw chunk 0xd159c534 to 0x411e0
[  130.517242] wl1271: uploading fw chunk 0xd159c734 to 0x413e0
[  130.525177] wl1271: uploading fw chunk 0xd159c934 to 0x415e0
[  130.533111] wl1271: uploading fw chunk 0xd159cb34 to 0x417e0
[  130.541137] wl1271: uploading fw chunk 0xd159cd34 to 0x419e0
[  130.549102] wl1271: uploading fw chunk 0xd159cf34 to 0x41be0
[  130.557067] wl1271: uploading fw chunk 0xd159d134 to 0x41de0
[  130.565002] wl1271: uploading fw chunk 0xd159d334 to 0x41fe0
[  130.573120] wl1271: uploading fw chunk 0xd159d534 to 0x421e0
[  130.581237] wl1271: uploading fw chunk 0xd159d734 to 0x423e0
[  130.589202] wl1271: uploading fw chunk 0xd159d934 to 0x425e0
[  130.597167] wl1271: uploading fw chunk 0xd159db34 to 0x427e0
[  130.605133] wl1271: uploading fw chunk 0xd159dd34 to 0x429e0
[  130.613067] wl1271: uploading fw chunk 0xd159df34 to 0x42be0
[  130.621032] wl1271: uploading fw chunk 0xd159e134 to 0x42de0
[  130.629028] wl1271: uploading fw chunk 0xd159e334 to 0x42fe0
[  130.636993] wl1271: uploading fw chunk 0xd159e534 to 0x431e0
[  130.644958] wl1271: uploading fw chunk 0xd159e734 to 0x433e0
[  130.653137] wl1271: uploading fw chunk 0xd159e934 to 0x435e0
[  130.661102] wl1271: uploading fw chunk 0xd159eb34 to 0x437e0
[  130.669067] wl1271: uploading fw chunk 0xd159ed34 to 0x439e0
[  130.677124] wl1271: uploading fw chunk 0xd159ef34 to 0x43be0
[  130.684020] wl1271: uploading fw chunk 0xd159f134 to 0x43de0
[  130.692901] wl1271: uploading fw chunk 0xd159f334 to 0x43fe0
[  130.699768] wl1271: uploading fw chunk 0xd159f534 to 0x441e0
[  130.708587] wl1271: uploading fw chunk 0xd159f734 to 0x443e0
[  130.715484] wl1271: uploading fw chunk 0xd159f934 to 0x445e0
[  130.724304] wl1271: uploading fw chunk 0xd159fb34 to 0x447e0
[  130.731201] wl1271: uploading fw chunk 0xd159fd34 to 0x449e0
[  130.739166] wl1271: uploading fw last chunk (48 B) 0xd159ff34 to 0x44be0
[  130.747558] wl1271: chunk 1 addr 0x312000 len 8092
[  130.752624] wl1271: starting firmware upload
[  130.757263] wl1271: fw_data_len 8092 chunk_size 512
[  130.764343] wl1271: uploading fw chunk 0xd159ff6c to 0x312000
[  130.774505] wl1271: uploading fw chunk 0xd15a016c to 0x312200
[  130.782531] wl1271: uploading fw chunk 0xd15a036c to 0x312400
[  130.790740] wl1271: uploading fw chunk 0xd15a056c to 0x312600
[  130.798950] wl1271: uploading fw chunk 0xd15a076c to 0x312800
[  130.807037] wl1271: uploading fw chunk 0xd15a096c to 0x312a00
[  130.815093] wl1271: uploading fw chunk 0xd15a0b6c to 0x312c00
[  130.823120] wl1271: uploading fw chunk 0xd15a0d6c to 0x312e00
[  130.831176] wl1271: uploading fw chunk 0xd15a0f6c to 0x313000
[  130.839202] wl1271: uploading fw chunk 0xd15a116c to 0x313200
[  130.847229] wl1271: uploading fw chunk 0xd15a136c to 0x313400
[  130.855285] wl1271: uploading fw chunk 0xd15a156c to 0x313600
[  130.863311] wl1271: uploading fw chunk 0xd15a176c to 0x313800
[  130.871429] wl1271: uploading fw chunk 0xd15a196c to 0x313a00
[  130.879486] wl1271: uploading fw chunk 0xd15a1b6c to 0x313c00
[  130.886779] wl1271: uploading fw last chunk (412 B) 0xd15a1d6c to 0x313e00
[  130.895294] wl1271: chunk 0 addr 0x316000 len 3784
[  130.900451] wl1271: starting firmware upload
[  130.905059] wl1271: fw_data_len 3784 chunk_size 512
[  130.912994] wl1271: uploading fw chunk 0xd15a1f10 to 0x316000
[  130.922515] wl1271: uploading fw chunk 0xd15a2110 to 0x316200
[  130.930541] wl1271: uploading fw chunk 0xd15a2310 to 0x316400
[  130.938568] wl1271: uploading fw chunk 0xd15a2510 to 0x316600
[  130.946624] wl1271: uploading fw chunk 0xd15a2710 to 0x316800
[  130.954742] wl1271: uploading fw chunk 0xd15a2910 to 0x316a00
[  130.962799] wl1271: uploading fw chunk 0xd15a2b10 to 0x316c00
[  130.970062] wl1271: uploading fw last chunk (200 B) 0xd15a2d10 to 0x316e00
[  130.978912] wl1271: chip id after firmware boot: 0x4030111
[  130.998901] wl1271: cmd_box_addr 0x407b4 event_box_addr 0x4ce58
[  131.006469] wl1271: acx event mbox mask
[  131.010559] wl1271: cmd configure
[  131.016540] wl1271: MBOX ptrs: 0x4ce58 0x4ceac
[  131.023406] wl1271: MBOX ptrs: 0x4ce58 0x4ceac
[  131.028137] wl1271: cmd test
[  131.033447] wl1271: FEM autodetect: manual, manufacturer: 1
[  131.033477] 
[  131.041412] wl1271: cmd test
[  131.050506] wl1271: cmd test
[  131.054199] wl1271: cmd template_set 2
[  131.072479] wl1271: cmd template_set 3
[  131.079681] wl1271: cmd template_set 0
[  131.085266] wl1271: cmd template_set 6
[  131.089813] wl1271: cmd template_set 5
[  131.096069] wl1271: cmd template_set 4
[  131.101623] wl1271: cmd template_set 1
[  131.106353] wl1271: cmd template_set 13
[  131.112731] wl1271: cmd template_set 7
[  131.118316] wl1271: cmd template_set 7
[  131.123870] wl1271: cmd template_set 7
[  131.128417] wl1271: cmd template_set 7
[  131.134674] wl1271: acx mem map
[  131.138092] wl1271: cmd interrogate
[  131.143310] wl1271: acx data pd threshold
[  131.147705] wl1271: cmd configure
[  131.154876] wl1271: acx slot
[  131.157928] wl1271: cmd configure
[  131.163696] wl1271: acx service period timeout
[  131.168579] wl1271: cmd configure
[  131.174560] wl1271: acx rts threshold: 2353
[  131.179107] wl1271: cmd configure
[  131.184173] wl1271: acx dco itrim parameters
[  131.188781] wl1271: cmd configure
[  131.194702] wl1271: acx connection monitor parameters: disabled
[  131.201080] wl1271: cmd configure
[  131.207580] wl1271: acx sg sta cfg
[  131.211303] wl1271: cmd configure
[  131.218414] wl1271: acx sg enable
[  131.221923] wl1271: cmd configure
[  131.227630] wl1271: acx fm coex setting
[  131.231811] wl1271: cmd configure
[  131.236877] wl1271: acx cca threshold
[  131.240814] wl1271: cmd configure
[  131.245635] wl1271: wl1271 mem cfg
[  131.249328] wl1271: cmd configure
[  133.255279] wl1271: ERROR command complete timeout
[  133.261016] wl1271: WARNING CONFIGURE command NOK
[  133.266143] wl1271: WARNING wl1271 mem config failed: -110
[  133.982696] wl1271: chip id 0x4030111 (1271 PG20)
[  133.990905] wl1271: pause1 0x40f73
[  133.996032] wl1271: DRPW_SCRATCH_START 0031002c
[  134.002777] wl1271: clk2 0x80316a38
[  134.009063] wl1271: soft reset bootdata 0x0
[  134.018768] wl1271: nvs burst write 0x30546c: 0xdeadbeef
[  134.026428] wl1271: nvs burst write 0x305470: 0xbad
[  134.033691] wl1271: ACX_EEPROMLESS_IND_REG
[  134.039520] wl1271: chip id 0x4030111
[  134.043670] wl1271: firmware chunks to be uploaded: 6
[  134.049133] wl1271: chunk 5 addr 0x0 len 196100
[  134.053985] wl1271: starting firmware upload
[  134.058532] wl1271: fw_data_len 196100 chunk_size 512
[  134.066192] wl1271: uploading fw chunk 0xd156000c to 0x0
[  134.072082] wl1271: uploading fw chunk 0xd156020c to 0x200
[  134.082550] wl1271: uploading fw chunk 0xd156040c to 0x400
[  134.089538] wl1271: uploading fw chunk 0xd156060c to 0x600
[  134.096557] wl1271: uploading fw chunk 0xd156080c to 0x800
[  134.103546] wl1271: uploading fw chunk 0xd1560a0c to 0xa00
[  134.110565] wl1271: uploading fw chunk 0xd1560c0c to 0xc00
[  134.117553] wl1271: uploading fw chunk 0xd1560e0c to 0xe00
[  134.124572] wl1271: uploading fw chunk 0xd156100c to 0x1000
[  134.131652] wl1271: uploading fw chunk 0xd156120c to 0x1200
[  134.137695] wl1271: uploading fw chunk 0xd156140c to 0x1400
[  134.145538] wl1271: uploading fw chunk 0xd156160c to 0x1600
[  134.152862] wl1271: uploading fw chunk 0xd156180c to 0x1800
[  134.159973] wl1271: uploading fw chunk 0xd1561a0c to 0x1a00
[  134.167083] wl1271: uploading fw chunk 0xd1561c0c to 0x1c00
[  134.174194] wl1271: uploading fw chunk 0xd1561e0c to 0x1e00
[  134.181304] wl1271: uploading fw chunk 0xd156200c to 0x2000
[  134.188415] wl1271: uploading fw chunk 0xd156220c to 0x2200
[  134.195495] wl1271: uploading fw chunk 0xd156240c to 0x2400
[  134.202606] wl1271: uploading fw chunk 0xd156260c to 0x2600
[  134.209686] wl1271: uploading fw chunk 0xd156280c to 0x2800
[  134.215759] wl1271: uploading fw chunk 0xd1562a0c to 0x2a00
[  134.223602] wl1271: uploading fw chunk 0xd1562c0c to 0x2c00
[  134.230682] wl1271: uploading fw chunk 0xd1562e0c to 0x2e00
[  134.237792] wl1271: uploading fw chunk 0xd156300c to 0x3000
[  134.244873] wl1271: uploading fw chunk 0xd156320c to 0x3200
[  134.251953] wl1271: uploading fw chunk 0xd156340c to 0x3400
[  134.259033] wl1271: uploading fw chunk 0xd156360c to 0x3600
[  134.266113] wl1271: uploading fw chunk 0xd156380c to 0x3800
[  134.273193] wl1271: uploading fw chunk 0xd1563a0c to 0x3a00
[  134.280273] wl1271: uploading fw chunk 0xd1563c0c to 0x3c00
[  134.287445] wl1271: uploading fw chunk 0xd1563e0c to 0x3e00
[  134.293487] wl1271: uploading fw chunk 0xd156400c to 0x4000
[  134.301361] wl1271: uploading fw chunk 0xd156420c to 0x4200
[  134.308441] wl1271: uploading fw chunk 0xd156440c to 0x4400
[  134.315643] wl1271: uploading fw chunk 0xd156460c to 0x4600
[  134.322845] wl1271: uploading fw chunk 0xd156480c to 0x4800
[  134.329956] wl1271: uploading fw chunk 0xd1564a0c to 0x4a00
[  134.337066] wl1271: uploading fw chunk 0xd1564c0c to 0x4c00
[  134.344177] wl1271: uploading fw chunk 0xd1564e0c to 0x4e00
[  134.351257] wl1271: uploading fw chunk 0xd156500c to 0x5000
[  134.358367] wl1271: uploading fw chunk 0xd156520c to 0x5200
[  134.364532] wl1271: uploading fw chunk 0xd156540c to 0x5400
[  134.371643] wl1271: uploading fw chunk 0xd156560c to 0x5600
[  134.379394] wl1271: uploading fw chunk 0xd156580c to 0x5800
[  134.386505] wl1271: uploading fw chunk 0xd1565a0c to 0x5a00
[  134.393585] wl1271: uploading fw chunk 0xd1565c0c to 0x5c00
[  134.400695] wl1271: uploading fw chunk 0xd1565e0c to 0x5e00
[  134.407775] wl1271: uploading fw chunk 0xd156600c to 0x6000
[  134.414855] wl1271: uploading fw chunk 0xd156620c to 0x6200
[  134.421936] wl1271: uploading fw chunk 0xd156640c to 0x6400
[  134.429016] wl1271: uploading fw chunk 0xd156660c to 0x6600
[  134.436126] wl1271: uploading fw chunk 0xd156680c to 0x6800
[  134.442169] wl1271: uploading fw chunk 0xd1566a0c to 0x6a00
[  134.450073] wl1271: uploading fw chunk 0xd1566c0c to 0x6c00
[  134.457183] wl1271: uploading fw chunk 0xd1566e0c to 0x6e00
[  134.464294] wl1271: uploading fw chunk 0xd156700c to 0x7000
[  134.471374] wl1271: uploading fw chunk 0xd156720c to 0x7200
[  134.478485] wl1271: uploading fw chunk 0xd156740c to 0x7400
[  134.485565] wl1271: uploading fw chunk 0xd156760c to 0x7600
[  134.492645] wl1271: uploading fw chunk 0xd156780c to 0x7800
[  134.499755] wl1271: uploading fw chunk 0xd1567a0c to 0x7a00
[  134.506835] wl1271: uploading fw chunk 0xd1567c0c to 0x7c00
[  134.513916] wl1271: uploading fw chunk 0xd1567e0c to 0x7e00
[  134.519958] wl1271: uploading fw chunk 0xd156800c to 0x8000
[  134.527801] wl1271: uploading fw chunk 0xd156820c to 0x8200
[  134.534912] wl1271: uploading fw chunk 0xd156840c to 0x8400
[  134.541992] wl1271: uploading fw chunk 0xd156860c to 0x8600
[  134.549102] wl1271: uploading fw chunk 0xd156880c to 0x8800
[  134.556182] wl1271: uploading fw chunk 0xd1568a0c to 0x8a00
[  134.563262] wl1271: uploading fw chunk 0xd1568c0c to 0x8c00
[  134.570373] wl1271: uploading fw chunk 0xd1568e0c to 0x8e00
[  134.577453] wl1271: uploading fw chunk 0xd156900c to 0x9000
[  134.584533] wl1271: uploading fw chunk 0xd156920c to 0x9200
[  134.590576] wl1271: uploading fw chunk 0xd156940c to 0x9400
[  134.598480] wl1271: uploading fw chunk 0xd156960c to 0x9600
[  134.605590] wl1271: uploading fw chunk 0xd156980c to 0x9800
[  134.612670] wl1271: uploading fw chunk 0xd1569a0c to 0x9a00
[  134.619842] wl1271: uploading fw chunk 0xd1569c0c to 0x9c00
[  134.626953] wl1271: uploading fw chunk 0xd1569e0c to 0x9e00
[  134.634033] wl1271: uploading fw chunk 0xd156a00c to 0xa000
[  134.644134] wl1271: uploading fw chunk 0xd156a20c to 0xa200
[  134.651702] wl1271: uploading fw chunk 0xd156a40c to 0xa400
[  134.658905] wl1271: uploading fw chunk 0xd156a60c to 0xa600
[  134.666046] wl1271: uploading fw chunk 0xd156a80c to 0xa800
[  134.673156] wl1271: uploading fw chunk 0xd156aa0c to 0xaa00
[  134.680267] wl1271: uploading fw chunk 0xd156ac0c to 0xac00
[  134.687377] wl1271: uploading fw chunk 0xd156ae0c to 0xae00
[  134.694458] wl1271: uploading fw chunk 0xd156b00c to 0xb000
[  134.701568] wl1271: uploading fw chunk 0xd156b20c to 0xb200
[  134.707641] wl1271: uploading fw chunk 0xd156b40c to 0xb400
[  134.715484] wl1271: uploading fw chunk 0xd156b60c to 0xb600
[  134.722564] wl1271: uploading fw chunk 0xd156b80c to 0xb800
[  134.729675] wl1271: uploading fw chunk 0xd156ba0c to 0xba00
[  134.736755] wl1271: uploading fw chunk 0xd156bc0c to 0xbc00
[  134.743835] wl1271: uploading fw chunk 0xd156be0c to 0xbe00
[  134.751007] wl1271: uploading fw chunk 0xd156c00c to 0xc000
[  134.758117] wl1271: uploading fw chunk 0xd156c20c to 0xc200
[  134.765228] wl1271: uploading fw chunk 0xd156c40c to 0xc400
[  134.772338] wl1271: uploading fw chunk 0xd156c60c to 0xc600
[  134.778411] wl1271: uploading fw chunk 0xd156c80c to 0xc800
[  134.786224] wl1271: uploading fw chunk 0xd156ca0c to 0xca00
[  134.793334] wl1271: uploading fw chunk 0xd156cc0c to 0xcc00
[  134.800415] wl1271: uploading fw chunk 0xd156ce0c to 0xce00
[  134.807525] wl1271: uploading fw chunk 0xd156d00c to 0xd000
[  134.814605] wl1271: uploading fw chunk 0xd156d20c to 0xd200
[  134.821685] wl1271: uploading fw chunk 0xd156d40c to 0xd400
[  134.828796] wl1271: uploading fw chunk 0xd156d60c to 0xd600
[  134.835876] wl1271: uploading fw chunk 0xd156d80c to 0xd800
[  134.842956] wl1271: uploading fw chunk 0xd156da0c to 0xda00
[  134.850067] wl1271: uploading fw chunk 0xd156dc0c to 0xdc00
[  134.856109] wl1271: uploading fw chunk 0xd156de0c to 0xde00
[  134.867401] wl1271: uploading fw chunk 0xd156e00c to 0xe000
[  134.874725] wl1271: uploading fw chunk 0xd156e20c to 0xe200
[  134.881896] wl1271: uploading fw chunk 0xd156e40c to 0xe400
[  134.889038] wl1271: uploading fw chunk 0xd156e60c to 0xe600
[  134.895111] wl1271: uploading fw chunk 0xd156e80c to 0xe800
[  134.903045] wl1271: uploading fw chunk 0xd156ea0c to 0xea00
[  134.910156] wl1271: uploading fw chunk 0xd156ec0c to 0xec00
[  134.917266] wl1271: uploading fw chunk 0xd156ee0c to 0xee00
[  134.924438] wl1271: uploading fw chunk 0xd156f00c to 0xf000
[  134.931579] wl1271: uploading fw chunk 0xd156f20c to 0xf200
[  134.938659] wl1271: uploading fw chunk 0xd156f40c to 0xf400
[  134.945770] wl1271: uploading fw chunk 0xd156f60c to 0xf600
[  134.952880] wl1271: uploading fw chunk 0xd156f80c to 0xf800
[  134.959960] wl1271: uploading fw chunk 0xd156fa0c to 0xfa00
[  134.967071] wl1271: uploading fw chunk 0xd156fc0c to 0xfc00
[  134.973144] wl1271: uploading fw chunk 0xd156fe0c to 0xfe00
[  134.980987] wl1271: uploading fw chunk 0xd157000c to 0x10000
[  134.988159] wl1271: uploading fw chunk 0xd157020c to 0x10200
[  134.995330] wl1271: uploading fw chunk 0xd157040c to 0x10400
[  135.002532] wl1271: uploading fw chunk 0xd157060c to 0x10600
[  135.013793] wl1271: uploading fw chunk 0xd157080c to 0x10800
[  135.019989] wl1271: uploading fw chunk 0xd1570a0c to 0x10a00
[  135.028198] wl1271: uploading fw chunk 0xd1570c0c to 0x10c00
[  135.035491] wl1271: uploading fw chunk 0xd1570e0c to 0x10e00
[  135.042724] wl1271: uploading fw chunk 0xd157100c to 0x11000
[  135.049926] wl1271: uploading fw chunk 0xd157120c to 0x11200
[  135.057220] wl1271: uploading fw chunk 0xd157140c to 0x11400
[  135.064453] wl1271: uploading fw chunk 0xd157160c to 0x11600
[  135.071655] wl1271: uploading fw chunk 0xd157180c to 0x11800
[  135.078826] wl1271: uploading fw chunk 0xd1571a0c to 0x11a00
[  135.086029] wl1271: uploading fw chunk 0xd1571c0c to 0x11c00
[  135.093200] wl1271: uploading fw chunk 0xd1571e0c to 0x11e00
[  135.100402] wl1271: uploading fw chunk 0xd157200c to 0x12000
[  135.106536] wl1271: uploading fw chunk 0xd157220c to 0x12200
[  135.114837] wl1271: uploading fw chunk 0xd157240c to 0x12400
[  135.120971] wl1271: uploading fw chunk 0xd157260c to 0x12600
[  135.129119] wl1271: uploading fw chunk 0xd157280c to 0x12800
[  135.136322] wl1271: uploading fw chunk 0xd1572a0c to 0x12a00
[  135.143524] wl1271: uploading fw chunk 0xd1572c0c to 0x12c00
[  135.151214] wl1271: uploading fw chunk 0xd1572e0c to 0x12e00
[  135.159057] wl1271: uploading fw chunk 0xd157300c to 0x13000
[  135.168975] wl1271: uploading fw chunk 0xd157320c to 0x13200
[  135.176483] wl1271: uploading fw chunk 0xd157340c to 0x13400
[  135.183807] wl1271: uploading fw chunk 0xd157360c to 0x13600
[  135.191070] wl1271: uploading fw chunk 0xd157380c to 0x13800
[  135.198303] wl1271: uploading fw chunk 0xd1573a0c to 0x13a00
[  135.205596] wl1271: uploading fw chunk 0xd1573c0c to 0x13c00
[  135.212799] wl1271: uploading fw chunk 0xd1573e0c to 0x13e00
[  135.219940] wl1271: uploading fw chunk 0xd157400c to 0x14000
[  135.227386] wl1271: uploading fw chunk 0xd157420c to 0x14200
[  135.234710] wl1271: uploading fw chunk 0xd157440c to 0x14400
[  135.242156] wl1271: uploading fw chunk 0xd157460c to 0x14600
[  135.249389] wl1271: uploading fw chunk 0xd157480c to 0x14800
[  135.256622] wl1271: uploading fw chunk 0xd1574a0c to 0x14a00
[  135.262756] wl1271: uploading fw chunk 0xd1574c0c to 0x14c00
[  135.270782] wl1271: uploading fw chunk 0xd1574e0c to 0x14e00
[  135.276916] wl1271: uploading fw chunk 0xd157500c to 0x15000
[  135.284851] wl1271: uploading fw chunk 0xd157520c to 0x15200
[  135.294372] wl1271: uploading fw chunk 0xd157540c to 0x15400
[  135.300567] wl1271: uploading fw chunk 0xd157560c to 0x15600
[  135.308776] wl1271: uploading fw chunk 0xd157580c to 0x15800
[  135.316375] wl1271: uploading fw chunk 0xd1575a0c to 0x15a00
[  135.323638] wl1271: uploading fw chunk 0xd1575c0c to 0x15c00
[  135.330871] wl1271: uploading fw chunk 0xd1575e0c to 0x15e00
[  135.338104] wl1271: uploading fw chunk 0xd157600c to 0x16000
[  135.345306] wl1271: uploading fw chunk 0xd157620c to 0x16200
[  135.352478] wl1271: uploading fw chunk 0xd157640c to 0x16400
[  135.359680] wl1271: uploading fw chunk 0xd157660c to 0x16600
[  135.366973] wl1271: uploading fw chunk 0xd157680c to 0x16800
[  135.374176] wl1271: uploading fw chunk 0xd1576a0c to 0x16a00
[  135.381378] wl1271: uploading fw chunk 0xd1576c0c to 0x16c00
[  135.387512] wl1271: uploading fw chunk 0xd1576e0c to 0x16e00
[  135.395477] wl1271: uploading fw chunk 0xd157700c to 0x17000
[  135.402679] wl1271: uploading fw chunk 0xd157720c to 0x17200
[  135.413787] wl1271: uploading fw chunk 0xd157740c to 0x17400
[  135.421264] wl1271: uploading fw chunk 0xd157760c to 0x17600
[  135.428588] wl1271: uploading fw chunk 0xd157780c to 0x17800
[  135.435852] wl1271: uploading fw chunk 0xd1577a0c to 0x17a00
[  135.442016] wl1271: uploading fw chunk 0xd1577c0c to 0x17c00
[  135.449951] wl1271: uploading fw chunk 0xd1577e0c to 0x17e00
[  135.457183] wl1271: uploading fw chunk 0xd157800c to 0x18000
[  135.464355] wl1271: uploading fw chunk 0xd157820c to 0x18200
[  135.471557] wl1271: uploading fw chunk 0xd157840c to 0x18400
[  135.478759] wl1271: uploading fw chunk 0xd157860c to 0x18600
[  135.485961] wl1271: uploading fw chunk 0xd157880c to 0x18800
[  135.493133] wl1271: uploading fw chunk 0xd1578a0c to 0x18a00
[  135.500335] wl1271: uploading fw chunk 0xd1578c0c to 0x18c00
[  135.507507] wl1271: uploading fw chunk 0xd1578e0c to 0x18e00
[  135.514801] wl1271: uploading fw chunk 0xd157900c to 0x19000
[  135.522003] wl1271: uploading fw chunk 0xd157920c to 0x19200
[  135.528137] wl1271: uploading fw chunk 0xd157940c to 0x19400
[  135.536102] wl1271: uploading fw chunk 0xd157960c to 0x19600
[  135.543365] wl1271: uploading fw chunk 0xd157980c to 0x19800
[  135.550567] wl1271: uploading fw chunk 0xd1579a0c to 0x19a00
[  135.557769] wl1271: uploading fw chunk 0xd1579c0c to 0x19c00
[  135.564941] wl1271: uploading fw chunk 0xd1579e0c to 0x19e00
[  135.572143] wl1271: uploading fw chunk 0xd157a00c to 0x1a000
[  135.579315] wl1271: uploading fw chunk 0xd157a20c to 0x1a200
[  135.586517] wl1271: uploading fw chunk 0xd157a40c to 0x1a400
[  135.597686] wl1271: uploading fw chunk 0xd157a60c to 0x1a600
[  135.605194] wl1271: uploading fw chunk 0xd157a80c to 0x1a800
[  135.612548] wl1271: uploading fw chunk 0xd157aa0c to 0x1aa00
[  135.619812] wl1271: uploading fw chunk 0xd157ac0c to 0x1ac00
[  135.627044] wl1271: uploading fw chunk 0xd157ae0c to 0x1ae00
[  135.634246] wl1271: uploading fw chunk 0xd157b00c to 0x1b000
[  135.641448] wl1271: uploading fw chunk 0xd157b20c to 0x1b200
[  135.648620] wl1271: uploading fw chunk 0xd157b40c to 0x1b400
[  135.655822] wl1271: uploading fw chunk 0xd157b60c to 0x1b600
[  135.662994] wl1271: uploading fw chunk 0xd157b80c to 0x1b800
[  135.670196] wl1271: uploading fw chunk 0xd157ba0c to 0x1ba00
[  135.676330] wl1271: uploading fw chunk 0xd157bc0c to 0x1bc00
[  135.684387] wl1271: uploading fw chunk 0xd157be0c to 0x1be00
[  135.691619] wl1271: uploading fw chunk 0xd157c00c to 0x1c000
[  135.698791] wl1271: uploading fw chunk 0xd157c20c to 0x1c200
[  135.705993] wl1271: uploading fw chunk 0xd157c40c to 0x1c400
[  135.713165] wl1271: uploading fw chunk 0xd157c60c to 0x1c600
[  135.720367] wl1271: uploading fw chunk 0xd157c80c to 0x1c800
[  135.727539] wl1271: uploading fw chunk 0xd157ca0c to 0x1ca00
[  135.734741] wl1271: uploading fw chunk 0xd157cc0c to 0x1cc00
[  135.741912] wl1271: uploading fw chunk 0xd157ce0c to 0x1ce00
[  135.751892] wl1271: uploading fw chunk 0xd157d00c to 0x1d000
[  135.759399] wl1271: uploading fw chunk 0xd157d20c to 0x1d200
[  135.766754] wl1271: uploading fw chunk 0xd157d40c to 0x1d400
[  135.774017] wl1271: uploading fw chunk 0xd157d60c to 0x1d600
[  135.781280] wl1271: uploading fw chunk 0xd157d80c to 0x1d800
[  135.788482] wl1271: uploading fw chunk 0xd157da0c to 0x1da00
[  135.795684] wl1271: uploading fw chunk 0xd157dc0c to 0x1dc00
[  135.801818] wl1271: uploading fw chunk 0xd157de0c to 0x1de00
[  135.809844] wl1271: uploading fw chunk 0xd157e00c to 0x1e000
[  135.816009] wl1271: uploading fw chunk 0xd157e20c to 0x1e200
[  135.824035] wl1271: uploading fw chunk 0xd157e40c to 0x1e400
[  135.831237] wl1271: uploading fw chunk 0xd157e60c to 0x1e600
[  135.838439] wl1271: uploading fw chunk 0xd157e80c to 0x1e800
[  135.845642] wl1271: uploading fw chunk 0xd157ea0c to 0x1ea00
[  135.852905] wl1271: uploading fw chunk 0xd157ec0c to 0x1ec00
[  135.860107] wl1271: uploading fw chunk 0xd157ee0c to 0x1ee00
[  135.867309] wl1271: uploading fw chunk 0xd157f00c to 0x1f000
[  135.874511] wl1271: uploading fw chunk 0xd157f20c to 0x1f200
[  135.884979] wl1271: uploading fw chunk 0xd157f40c to 0x1f400
[  135.892486] wl1271: uploading fw chunk 0xd157f60c to 0x1f600
[  135.899841] wl1271: uploading fw chunk 0xd157f80c to 0x1f800
[  135.907104] wl1271: uploading fw chunk 0xd157fa0c to 0x1fa00
[  135.914337] wl1271: uploading fw chunk 0xd157fc0c to 0x1fc00
[  135.921539] wl1271: uploading fw chunk 0xd157fe0c to 0x1fe00
[  135.928741] wl1271: uploading fw chunk 0xd158000c to 0x20000
[  135.936218] wl1271: uploading fw chunk 0xd158020c to 0x20200
[  135.942382] wl1271: uploading fw chunk 0xd158040c to 0x20400
[  135.950347] wl1271: uploading fw chunk 0xd158060c to 0x20600
[  135.957550] wl1271: uploading fw chunk 0xd158080c to 0x20800
[  135.964752] wl1271: uploading fw chunk 0xd1580a0c to 0x20a00
[  135.971923] wl1271: uploading fw chunk 0xd1580c0c to 0x20c00
[  135.979125] wl1271: uploading fw chunk 0xd1580e0c to 0x20e00
[  135.986419] wl1271: uploading fw chunk 0xd158100c to 0x21000
[  135.993621] wl1271: uploading fw chunk 0xd158120c to 0x21200
[  136.000823] wl1271: uploading fw chunk 0xd158140c to 0x21400
[  136.008605] wl1271: uploading fw chunk 0xd158160c to 0x21600
[  136.015899] wl1271: uploading fw chunk 0xd158180c to 0x21800
[  136.023742] wl1271: uploading fw chunk 0xd1581a0c to 0x21a00
[  136.031066] wl1271: uploading fw chunk 0xd1581c0c to 0x21c00
[  136.042022] wl1271: uploading fw chunk 0xd1581e0c to 0x21e00
[  136.049560] wl1271: uploading fw chunk 0xd158200c to 0x22000
[  136.056884] wl1271: uploading fw chunk 0xd158220c to 0x22200
[  136.064147] wl1271: uploading fw chunk 0xd158240c to 0x22400
[  136.071350] wl1271: uploading fw chunk 0xd158260c to 0x22600
[  136.078552] wl1271: uploading fw chunk 0xd158280c to 0x22800
[  136.085784] wl1271: uploading fw chunk 0xd1582a0c to 0x22a00
[  136.092987] wl1271: uploading fw chunk 0xd1582c0c to 0x22c00
[  136.100158] wl1271: uploading fw chunk 0xd1582e0c to 0x22e00
[  136.106323] wl1271: uploading fw chunk 0xd158300c to 0x23000
[  136.114257] wl1271: uploading fw chunk 0xd158320c to 0x23200
[  136.121917] wl1271: uploading fw chunk 0xd158340c to 0x23400
[  136.129241] wl1271: uploading fw chunk 0xd158360c to 0x23600
[  136.136535] wl1271: uploading fw chunk 0xd158380c to 0x23800
[  136.143768] wl1271: uploading fw chunk 0xd1583a0c to 0x23a00
[  136.151123] wl1271: uploading fw chunk 0xd1583c0c to 0x23c00
[  136.158355] wl1271: uploading fw chunk 0xd1583e0c to 0x23e00
[  136.168640] wl1271: uploading fw chunk 0xd158400c to 0x24000
[  136.176147] wl1271: uploading fw chunk 0xd158420c to 0x24200
[  136.183502] wl1271: uploading fw chunk 0xd158440c to 0x24400
[  136.190765] wl1271: uploading fw chunk 0xd158460c to 0x24600
[  136.197998] wl1271: uploading fw chunk 0xd158480c to 0x24800
[  136.205200] wl1271: uploading fw chunk 0xd1584a0c to 0x24a00
[  136.212402] wl1271: uploading fw chunk 0xd1584c0c to 0x24c00
[  136.219604] wl1271: uploading fw chunk 0xd1584e0c to 0x24e00
[  136.227020] wl1271: uploading fw chunk 0xd158500c to 0x25000
[  136.234222] wl1271: uploading fw chunk 0xd158520c to 0x25200
[  136.241455] wl1271: uploading fw chunk 0xd158540c to 0x25400
[  136.248626] wl1271: uploading fw chunk 0xd158560c to 0x25600
[  136.254791] wl1271: uploading fw chunk 0xd158580c to 0x25800
[  136.262756] wl1271: uploading fw chunk 0xd1585a0c to 0x25a00
[  136.269958] wl1271: uploading fw chunk 0xd1585c0c to 0x25c00
[  136.277160] wl1271: uploading fw chunk 0xd1585e0c to 0x25e00
[  136.284332] wl1271: uploading fw chunk 0xd158600c to 0x26000
[  136.294067] wl1271: uploading fw chunk 0xd158620c to 0x26200
[  136.301544] wl1271: uploading fw chunk 0xd158640c to 0x26400
[  136.308837] wl1271: uploading fw chunk 0xd158660c to 0x26600
[  136.316406] wl1271: uploading fw chunk 0xd158680c to 0x26800
[  136.323699] wl1271: uploading fw chunk 0xd1586a0c to 0x26a00
[  136.330902] wl1271: uploading fw chunk 0xd1586c0c to 0x26c00
[  136.338104] wl1271: uploading fw chunk 0xd1586e0c to 0x26e00
[  136.345520] wl1271: uploading fw chunk 0xd158700c to 0x27000
[  136.353302] wl1271: uploading fw chunk 0xd158720c to 0x27200
[  136.361175] wl1271: uploading fw chunk 0xd158740c to 0x27400
[  136.368469] wl1271: uploading fw chunk 0xd158760c to 0x27600
[  136.375701] wl1271: uploading fw chunk 0xd158780c to 0x27800
[  136.382904] wl1271: uploading fw chunk 0xd1587a0c to 0x27a00
[  136.390106] wl1271: uploading fw chunk 0xd1587c0c to 0x27c00
[  136.397308] wl1271: uploading fw chunk 0xd1587e0c to 0x27e00
[  136.403442] wl1271: uploading fw chunk 0xd158800c to 0x28000
[  136.411499] wl1271: uploading fw chunk 0xd158820c to 0x28200
[  136.417633] wl1271: uploading fw chunk 0xd158840c to 0x28400
[  136.425598] wl1271: uploading fw chunk 0xd158860c to 0x28600
[  136.432800] wl1271: uploading fw chunk 0xd158880c to 0x28800
[  136.440063] wl1271: uploading fw chunk 0xd1588a0c to 0x28a00
[  136.447296] wl1271: uploading fw chunk 0xd1588c0c to 0x28c00
[  136.457183] wl1271: uploading fw chunk 0xd1588e0c to 0x28e00
[  136.464691] wl1271: uploading fw chunk 0xd158900c to 0x29000
[  136.472045] wl1271: uploading fw chunk 0xd158920c to 0x29200
[  136.479400] wl1271: uploading fw chunk 0xd158940c to 0x29400
[  136.486663] wl1271: uploading fw chunk 0xd158960c to 0x29600
[  136.493865] wl1271: uploading fw chunk 0xd158980c to 0x29800
[  136.501068] wl1271: uploading fw chunk 0xd1589a0c to 0x29a00
[  136.508270] wl1271: uploading fw chunk 0xd1589c0c to 0x29c00
[  136.515472] wl1271: uploading fw chunk 0xd1589e0c to 0x29e00
[  136.522674] wl1271: uploading fw chunk 0xd158a00c to 0x2a000
[  136.529846] wl1271: uploading fw chunk 0xd158a20c to 0x2a200
[  136.536010] wl1271: uploading fw chunk 0xd158a40c to 0x2a400
[  136.543945] wl1271: uploading fw chunk 0xd158a60c to 0x2a600
[  136.551147] wl1271: uploading fw chunk 0xd158a80c to 0x2a800
[  136.558319] wl1271: uploading fw chunk 0xd158aa0c to 0x2aa00
[  136.565734] wl1271: uploading fw chunk 0xd158ac0c to 0x2ac00
[  136.572967] wl1271: uploading fw chunk 0xd158ae0c to 0x2ae00
[  136.580169] wl1271: uploading fw chunk 0xd158b00c to 0x2b000
[  136.587371] wl1271: uploading fw chunk 0xd158b20c to 0x2b200
[  136.596771] wl1271: uploading fw chunk 0xd158b40c to 0x2b400
[  136.604339] wl1271: uploading fw chunk 0xd158b60c to 0x2b600
[  136.611663] wl1271: uploading fw chunk 0xd158b80c to 0x2b800
[  136.618896] wl1271: uploading fw chunk 0xd158ba0c to 0x2ba00
[  136.626129] wl1271: uploading fw chunk 0xd158bc0c to 0x2bc00
[  136.633331] wl1271: uploading fw chunk 0xd158be0c to 0x2be00
[  136.640533] wl1271: uploading fw chunk 0xd158c00c to 0x2c000
[  136.647735] wl1271: uploading fw chunk 0xd158c20c to 0x2c200
[  136.655181] wl1271: uploading fw chunk 0xd158c40c to 0x2c400
[  136.662384] wl1271: uploading fw chunk 0xd158c60c to 0x2c600
[  136.668548] wl1271: uploading fw chunk 0xd158c80c to 0x2c800
[  136.676879] wl1271: uploading fw chunk 0xd158ca0c to 0x2ca00
[  136.684143] wl1271: uploading fw chunk 0xd158cc0c to 0x2cc00
[  136.691375] wl1271: uploading fw chunk 0xd158ce0c to 0x2ce00
[  136.698608] wl1271: uploading fw chunk 0xd158d00c to 0x2d000
[  136.705810] wl1271: uploading fw chunk 0xd158d20c to 0x2d200
[  136.714172] wl1271: uploading fw chunk 0xd158d40c to 0x2d400
[  136.721618] wl1271: uploading fw chunk 0xd158d60c to 0x2d600
[  136.728942] wl1271: uploading fw chunk 0xd158d80c to 0x2d800
[  136.736206] wl1271: uploading fw chunk 0xd158da0c to 0x2da00
[  136.743438] wl1271: uploading fw chunk 0xd158dc0c to 0x2dc00
[  136.750732] wl1271: uploading fw chunk 0xd158de0c to 0x2de00
[  136.757934] wl1271: uploading fw chunk 0xd158e00c to 0x2e000
[  136.765136] wl1271: uploading fw chunk 0xd158e20c to 0x2e200
[  136.772338] wl1271: uploading fw chunk 0xd158e40c to 0x2e400
[  136.778594] wl1271: uploading fw chunk 0xd158e60c to 0x2e600
[  136.786743] wl1271: uploading fw chunk 0xd158e80c to 0x2e800
[  136.794677] wl1271: uploading fw chunk 0xd158ea0c to 0x2ea00
[  136.800811] wl1271: uploading fw chunk 0xd158ec0c to 0x2ec00
[  136.808776] wl1271: uploading fw chunk 0xd158ee0c to 0x2ee00
[  136.815948] wl1271: uploading fw chunk 0xd158f00c to 0x2f000
[  136.823150] wl1271: uploading fw chunk 0xd158f20c to 0x2f200
[  136.830352] wl1271: uploading fw chunk 0xd158f40c to 0x2f400
[  136.837524] wl1271: uploading fw chunk 0xd158f60c to 0x2f600
[  136.844726] wl1271: uploading fw chunk 0xd158f80c to 0x2f800
[  136.851898] wl1271: uploading fw chunk 0xd158fa0c to 0x2fa00
[  136.859069] wl1271: uploading fw chunk 0xd158fc0c to 0x2fc00
[  136.866271] wl1271: uploading fw last chunk (4 B) 0xd158fe0c to 0x2fe00
[  136.874481] wl1271: chunk 4 addr 0x20000000 len 48972
[  136.879852] wl1271: starting firmware upload
[  136.884460] wl1271: fw_data_len 48972 chunk_size 512
[  136.892486] wl1271: uploading fw chunk 0xd158fe18 to 0x20000000
[  136.902069] wl1271: uploading fw chunk 0xd1590018 to 0x20000200
[  136.910400] wl1271: uploading fw chunk 0xd1590218 to 0x20000400
[  136.918640] wl1271: uploading fw chunk 0xd1590418 to 0x20000600
[  136.926879] wl1271: uploading fw chunk 0xd1590618 to 0x20000800
[  136.935211] wl1271: uploading fw chunk 0xd1590818 to 0x20000a00
[  136.942382] wl1271: uploading fw chunk 0xd1590a18 to 0x20000c00
[  136.951507] wl1271: uploading fw chunk 0xd1590c18 to 0x20000e00
[  136.959777] wl1271: uploading fw chunk 0xd1590e18 to 0x20001000
[  136.968200] wl1271: uploading fw chunk 0xd1591018 to 0x20001200
[  136.976470] wl1271: uploading fw chunk 0xd1591218 to 0x20001400
[  136.984710] wl1271: uploading fw chunk 0xd1591418 to 0x20001600
[  136.992980] wl1271: uploading fw chunk 0xd1591618 to 0x20001800
[  137.001220] wl1271: uploading fw chunk 0xd1591818 to 0x20001a00
[  137.009582] wl1271: uploading fw chunk 0xd1591a18 to 0x20001c00
[  137.017852] wl1271: uploading fw chunk 0xd1591c18 to 0x20001e00
[  137.026092] wl1271: uploading fw chunk 0xd1591e18 to 0x20002000
[  137.034332] wl1271: uploading fw chunk 0xd1592018 to 0x20002200
[  137.042541] wl1271: uploading fw chunk 0xd1592218 to 0x20002400
[  137.050811] wl1271: uploading fw chunk 0xd1592418 to 0x20002600
[  137.059020] wl1271: uploading fw chunk 0xd1592618 to 0x20002800
[  137.067352] wl1271: uploading fw chunk 0xd1592818 to 0x20002a00
[  137.075683] wl1271: uploading fw chunk 0xd1592a18 to 0x20002c00
[  137.082855] wl1271: uploading fw chunk 0xd1592c18 to 0x20002e00
[  137.091979] wl1271: uploading fw chunk 0xd1592e18 to 0x20003000
[  137.100250] wl1271: uploading fw chunk 0xd1593018 to 0x20003200
[  137.108581] wl1271: uploading fw chunk 0xd1593218 to 0x20003400
[  137.116821] wl1271: uploading fw chunk 0xd1593418 to 0x20003600
[  137.125061] wl1271: uploading fw chunk 0xd1593618 to 0x20003800
[  137.133331] wl1271: uploading fw chunk 0xd1593818 to 0x20003a00
[  137.141540] wl1271: uploading fw chunk 0xd1593a18 to 0x20003c00
[  137.150268] wl1271: uploading fw chunk 0xd1593c18 to 0x20003e00
[  137.158538] wl1271: uploading fw chunk 0xd1593e18 to 0x20004000
[  137.166778] wl1271: uploading fw chunk 0xd1594018 to 0x20004200
[  137.174987] wl1271: uploading fw chunk 0xd1594218 to 0x20004400
[  137.183227] wl1271: uploading fw chunk 0xd1594418 to 0x20004600
[  137.191467] wl1271: uploading fw chunk 0xd1594618 to 0x20004800
[  137.199676] wl1271: uploading fw chunk 0xd1594818 to 0x20004a00
[  137.207916] wl1271: uploading fw chunk 0xd1594a18 to 0x20004c00
[  137.216217] wl1271: uploading fw chunk 0xd1594c18 to 0x20004e00
[  137.223632] wl1271: uploading fw chunk 0xd1594e18 to 0x20005000
[  137.232940] wl1271: uploading fw chunk 0xd1595018 to 0x20005200
[  137.241241] wl1271: uploading fw chunk 0xd1595218 to 0x20005400
[  137.249572] wl1271: uploading fw chunk 0xd1595418 to 0x20005600
[  137.257812] wl1271: uploading fw chunk 0xd1595618 to 0x20005800
[  137.266052] wl1271: uploading fw chunk 0xd1595818 to 0x20005a00
[  137.274291] wl1271: uploading fw chunk 0xd1595a18 to 0x20005c00
[  137.282531] wl1271: uploading fw chunk 0xd1595c18 to 0x20005e00
[  137.290740] wl1271: uploading fw chunk 0xd1595e18 to 0x20006000
[  137.298980] wl1271: uploading fw chunk 0xd1596018 to 0x20006200
[  137.307189] wl1271: uploading fw chunk 0xd1596218 to 0x20006400
[  137.315765] wl1271: uploading fw chunk 0xd1596418 to 0x20006600
[  137.324035] wl1271: uploading fw chunk 0xd1596618 to 0x20006800
[  137.332275] wl1271: uploading fw chunk 0xd1596818 to 0x20006a00
[  137.340545] wl1271: uploading fw chunk 0xd1596a18 to 0x20006c00
[  137.348754] wl1271: uploading fw chunk 0xd1596c18 to 0x20006e00
[  137.357086] wl1271: uploading fw chunk 0xd1596e18 to 0x20007000
[  137.364257] wl1271: uploading fw chunk 0xd1597018 to 0x20007200
[  137.373352] wl1271: uploading fw chunk 0xd1597218 to 0x20007400
[  137.381622] wl1271: uploading fw chunk 0xd1597418 to 0x20007600
[  137.389862] wl1271: uploading fw chunk 0xd1597618 to 0x20007800
[  137.398071] wl1271: uploading fw chunk 0xd1597818 to 0x20007a00
[  137.406433] wl1271: uploading fw chunk 0xd1597a18 to 0x20007c00
[  137.414703] wl1271: uploading fw chunk 0xd1597c18 to 0x20007e00
[  137.422943] wl1271: uploading fw chunk 0xd1597e18 to 0x20008000
[  137.431182] wl1271: uploading fw chunk 0xd1598018 to 0x20008200
[  137.439514] wl1271: uploading fw chunk 0xd1598218 to 0x20008400
[  137.447753] wl1271: uploading fw chunk 0xd1598418 to 0x20008600
[  137.455993] wl1271: uploading fw chunk 0xd1598618 to 0x20008800
[  137.464202] wl1271: uploading fw chunk 0xd1598818 to 0x20008a00
[  137.472442] wl1271: uploading fw chunk 0xd1598a18 to 0x20008c00
[  137.480682] wl1271: uploading fw chunk 0xd1598c18 to 0x20008e00
[  137.488922] wl1271: uploading fw chunk 0xd1598e18 to 0x20009000
[  137.497131] wl1271: uploading fw chunk 0xd1599018 to 0x20009200
[  137.505462] wl1271: uploading fw chunk 0xd1599218 to 0x20009400
[  137.512634] wl1271: uploading fw chunk 0xd1599418 to 0x20009600
[  137.521759] wl1271: uploading fw chunk 0xd1599618 to 0x20009800
[  137.529998] wl1271: uploading fw chunk 0xd1599818 to 0x20009a00
[  137.538238] wl1271: uploading fw chunk 0xd1599a18 to 0x20009c00
[  137.546478] wl1271: uploading fw chunk 0xd1599c18 to 0x20009e00
[  137.554718] wl1271: uploading fw chunk 0xd1599e18 to 0x2000a000
[  137.562927] wl1271: uploading fw chunk 0xd159a018 to 0x2000a200
[  137.571166] wl1271: uploading fw chunk 0xd159a218 to 0x2000a400
[  137.579467] wl1271: uploading fw chunk 0xd159a418 to 0x2000a600
[  137.587707] wl1271: uploading fw chunk 0xd159a618 to 0x2000a800
[  137.595947] wl1271: uploading fw chunk 0xd159a818 to 0x2000aa00
[  137.604156] wl1271: uploading fw chunk 0xd159aa18 to 0x2000ac00
[  137.612396] wl1271: uploading fw chunk 0xd159ac18 to 0x2000ae00
[  137.620635] wl1271: uploading fw chunk 0xd159ae18 to 0x2000b000
[  137.628875] wl1271: uploading fw chunk 0xd159b018 to 0x2000b200
[  137.637115] wl1271: uploading fw chunk 0xd159b218 to 0x2000b400
[  137.645324] wl1271: uploading fw chunk 0xd159b418 to 0x2000b600
[  137.653656] wl1271: uploading fw chunk 0xd159b618 to 0x2000b800
[  137.660797] wl1271: uploading fw chunk 0xd159b818 to 0x2000ba00
[  137.669860] wl1271: uploading fw chunk 0xd159ba18 to 0x2000bc00
[  137.676300] wl1271: uploading fw last chunk (332 B) 0xd159bc18 to 0x2000be00
[  137.685852] wl1271: chunk 3 addr 0x40000 len 448
[  137.690734] wl1271: starting firmware upload
[  137.695373] wl1271: fw_data_len 448 chunk_size 512
[  137.702484] wl1271: uploading fw last chunk (448 B) 0xd159bd6c to 0x40000
[  137.712249] wl1271: chunk 2 addr 0x40be0 len 16432
[  137.717437] wl1271: starting firmware upload
[  137.721954] wl1271: fw_data_len 16432 chunk_size 512
[  137.729980] wl1271: uploading fw chunk 0xd159bf34 to 0x40be0
[  137.739532] wl1271: uploading fw chunk 0xd159c134 to 0x40de0
[  137.747497] wl1271: uploading fw chunk 0xd159c334 to 0x40fe0
[  137.754394] wl1271: uploading fw chunk 0xd159c534 to 0x411e0
[  137.763275] wl1271: uploading fw chunk 0xd159c734 to 0x413e0
[  137.770172] wl1271: uploading fw chunk 0xd159c934 to 0x415e0
[  137.778991] wl1271: uploading fw chunk 0xd159cb34 to 0x417e0
[  137.785888] wl1271: uploading fw chunk 0xd159cd34 to 0x419e0
[  137.794677] wl1271: uploading fw chunk 0xd159cf34 to 0x41be0
[  137.801574] wl1271: uploading fw chunk 0xd159d134 to 0x41de0
[  137.810363] wl1271: uploading fw chunk 0xd159d334 to 0x41fe0
[  137.817260] wl1271: uploading fw chunk 0xd159d534 to 0x421e0
[  137.826049] wl1271: uploading fw chunk 0xd159d734 to 0x423e0
[  137.832946] wl1271: uploading fw chunk 0xd159d934 to 0x425e0
[  137.841735] wl1271: uploading fw chunk 0xd159db34 to 0x427e0
[  137.848632] wl1271: uploading fw chunk 0xd159dd34 to 0x429e0
[  137.857421] wl1271: uploading fw chunk 0xd159df34 to 0x42be0
[  137.864318] wl1271: uploading fw chunk 0xd159e134 to 0x42de0
[  137.873107] wl1271: uploading fw chunk 0xd159e334 to 0x42fe0
[  137.880004] wl1271: uploading fw chunk 0xd159e534 to 0x431e0
[  137.888793] wl1271: uploading fw chunk 0xd159e734 to 0x433e0
[  137.896728] wl1271: uploading fw chunk 0xd159e934 to 0x435e0
[  137.904754] wl1271: uploading fw chunk 0xd159eb34 to 0x437e0
[  137.912719] wl1271: uploading fw chunk 0xd159ed34 to 0x439e0
[  137.920715] wl1271: uploading fw chunk 0xd159ef34 to 0x43be0
[  137.928680] wl1271: uploading fw chunk 0xd159f134 to 0x43de0
[  137.936614] wl1271: uploading fw chunk 0xd159f334 to 0x43fe0
[  137.944824] wl1271: uploading fw chunk 0xd159f534 to 0x441e0
[  137.952789] wl1271: uploading fw chunk 0xd159f734 to 0x443e0
[  137.960754] wl1271: uploading fw chunk 0xd159f934 to 0x445e0
[  137.968719] wl1271: uploading fw chunk 0xd159fb34 to 0x447e0
[  137.976654] wl1271: uploading fw chunk 0xd159fd34 to 0x449e0
[  137.983856] wl1271: uploading fw last chunk (48 B) 0xd159ff34 to 0x44be0
[  137.992156] wl1271: chunk 1 addr 0x312000 len 8092
[  137.997222] wl1271: starting firmware upload
[  138.001831] wl1271: fw_data_len 8092 chunk_size 512
[  138.009918] wl1271: uploading fw chunk 0xd159ff6c to 0x312000
[  138.019714] wl1271: uploading fw chunk 0xd15a016c to 0x312200
[  138.027893] wl1271: uploading fw chunk 0xd15a036c to 0x312400
[  138.035949] wl1271: uploading fw chunk 0xd15a056c to 0x312600
[  138.044036] wl1271: uploading fw chunk 0xd15a076c to 0x312800
[  138.052154] wl1271: uploading fw chunk 0xd15a096c to 0x312a00
[  138.059173] wl1271: uploading fw chunk 0xd15a0b6c to 0x312c00
[  138.068176] wl1271: uploading fw chunk 0xd15a0d6c to 0x312e00
[  138.075164] wl1271: uploading fw chunk 0xd15a0f6c to 0x313000
[  138.084075] wl1271: uploading fw chunk 0xd15a116c to 0x313200
[  138.092224] wl1271: uploading fw chunk 0xd15a136c to 0x313400
[  138.100341] wl1271: uploading fw chunk 0xd15a156c to 0x313600
[  138.108428] wl1271: uploading fw chunk 0xd15a176c to 0x313800
[  138.116455] wl1271: uploading fw chunk 0xd15a196c to 0x313a00
[  138.124511] wl1271: uploading fw chunk 0xd15a1b6c to 0x313c00
[  138.131774] wl1271: uploading fw last chunk (412 B) 0xd15a1d6c to 0x313e00
[  138.140319] wl1271: chunk 0 addr 0x316000 len 3784
[  138.145385] wl1271: starting firmware upload
[  138.150054] wl1271: fw_data_len 3784 chunk_size 512
[  138.158050] wl1271: uploading fw chunk 0xd15a1f10 to 0x316000
[  138.167541] wl1271: uploading fw chunk 0xd15a2110 to 0x316200
[  138.175567] wl1271: uploading fw chunk 0xd15a2310 to 0x316400
[  138.183624] wl1271: uploading fw chunk 0xd15a2510 to 0x316600
[  138.191650] wl1271: uploading fw chunk 0xd15a2710 to 0x316800
[  138.199676] wl1271: uploading fw chunk 0xd15a2910 to 0x316a00
[  138.207702] wl1271: uploading fw chunk 0xd15a2b10 to 0x316c00
[  138.214996] wl1271: uploading fw last chunk (200 B) 0xd15a2d10 to 0x316e00
[  139.621795] wl1271: ERROR sdio read failed (-110)
[  139.628540] wl1271: ERROR sdio write failed (-110)
[  141.032348] wl1271: ERROR sdio read failed (-110)
[  141.037475] wl1271: chip id after firmware boot: 0x101
[  141.042907] wl1271: ERROR chip id doesn't match after firmware boot
[  143.156799] wl1271: ERROR sdio read failed (-110)
[  143.161926] wl1271: WARNING unsupported chip id: 0x1
[  143.278747] wl1271: ERROR firmware boot in PLT mode failed despite 3 retries
Fail to set PLT power mode on

Usage:  ./calibrator [options] plt calibrate [<single|dual>]

Do calibrate for single or dual band chip


Options:
        --debug         enable netlink debugging
root@cm-debian:~/ti-utils# 

--------------090201010609000707090808--
