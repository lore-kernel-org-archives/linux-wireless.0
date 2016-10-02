Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cock.li ([185.100.85.212]:60301 "EHLO cock.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750845AbcJBQD0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Oct 2016 12:03:26 -0400
Subject: Re: RTL8192EU on rtl8xxxu driver breaks every few minutes
To: Jes Sorensen <Jes.Sorensen@redhat.com>
References: <c6784dde-65df-87cd-f97e-33fbd8dd55ff@waifu.club>
 <wrfj4m5acouw.fsf@redhat.com>
 <80b8ae50-ca27-674f-0e7e-79b931bae199@waifu.club>
 <wrfjr3816jpr.fsf@redhat.com>
Cc: linux-wireless@vger.kernel.org
From: "Franc[e]sco" <lolisamurai@waifu.club>
Message-ID: <ec3a2db3-1e52-e2f1-1a3a-52bdfed3c803@waifu.club> (sfid-20161002_180430_409613_BD6BBADF)
Date: Sun, 2 Oct 2016 18:03:16 +0200
MIME-Version: 1.0
In-Reply-To: <wrfjr3816jpr.fsf@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------1958C3EB904183B596E72750"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1958C3EB904183B596E72750
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Thanks for the patch, just tested the rtl8xxxu-devel branch and it seems
to have the same exact issue with the same dmesg output with the
addition of "rtl8192eu_active_to_emu: Disabling MAC timed out" when I
disconnect the dongle.

I checked out and compiled the whole kernel from the branch because the
4.7.4 sources seemed to be missing the rtl8192eu_active_to_emu function.

These are the main networking scripts provided by Linux From Scratch, by
the way:
http://www.linuxfromscratch.org/lfs/view/7.10/scripts/apds24.html
http://www.linuxfromscratch.org/lfs/view/7.10/scripts/apds26.html

On 10/01/2016 01:39 AM, Jes Sorensen wrote:
> I just pushed a patch into rtl8xxxu-devel which may resolve this issue.
> There were problems with the 8192eu not handling driver reload very
> well. It is possible the network scripts you run would trigger the shut
> down and restart that caused this problem.
>
> I would be interested in knowing if this patch resolves the problem for
> you.
>
> Jes
>
> PS: Please fix your mail client - adding unlisted-recipients to the Cc
> line and cutting out the person you are responding to is really
> annoying.
>


--------------1958C3EB904183B596E72750
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192eu-iw-link-devel.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192eu-iw-link-devel.txt"

# uname -a
Linux lfs 4.8.0-rc6 #1 SMP Wed Feb 10 17:55:47 CET 2016 x86_64
GNU/Linux

# iw wlan0 link
Connected to e0:3f:49:97:0c:68 (on wlan0)
SSID: memes
freq: 2472
RX: 4853613 bytes (23417 packets)
TX: 2256453 bytes (9807 packets)
signal: -57 dBm
tx bitrate: 1.0 MBit/s

bss flags:short-slot-time
dtim period:1
beacon int:100

--------------1958C3EB904183B596E72750
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192eu-dmesg-devel.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192eu-dmesg-devel.txt"

[   49.588764] usb 2-1.4: New USB device found, idVendor=0bda, idProduct=818b
[   49.589418] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=
3
[   49.590060] usb 2-1.4: Product: 802.11n NIC
[   49.590681] usb 2-1.4: Manufacturer: Realtek
[   49.591307] usb 2-1.4: SerialNumber: 00e04c000001
[   49.592149] usb 2-1.4: This Realtek USB WiFi dongle (0x0bda:0x818b) is unteste
d!
[   49.592791] usb 2-1.4: Please report results to Jes.Sorensen@gmail.com
[   49.756655] usb 2-1.4: Vendor: Realtek
[   49.757295] usb 2-1.4: Product: 802.11n NIC
[   49.757932] usb 2-1.4: Serial: \xffffffff\xffffffff\xffffffff\xffffffff\xfffff
fff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff
[   49.758560] usb 2-1.4: rtl8192eu_parse_efuse: dumping efuse (0x200 bytes):
[   49.759196] usb 2-1.4: 00: 29 81 00 7c 01 40 03 00
[   49.759819] usb 2-1.4: 08: 40 74 04 50 14 00 00 00
[   49.760442] usb 2-1.4: 10: 21 20 1f 23 23 23 2d 2c
[   49.761072] usb 2-1.4: 18: 2b 2d 2d ff ef ef ff ff
[   49.761701] usb 2-1.4: 20: ff ff ff ff ff ff ff ff
[   49.762318] usb 2-1.4: 28: ff ff ff ff ff ff ff ff
[   49.762930] usb 2-1.4: 30: ff ff ff ff ff ff ff ff
[   49.763532] usb 2-1.4: 38: ff ff 1f 1d 1c 1e 1e 1e
[   49.764133] usb 2-1.4: 40: 2a 29 28 29 29 ff ef ef
[   49.764730] usb 2-1.4: 48: ff ff ff ff ff ff ff ff
[   49.765319] usb 2-1.4: 50: ff ff ff ff ff ff ff ff
[   49.765893] usb 2-1.4: 58: ff ff ff ff ff ff ff ff
[   49.766447] usb 2-1.4: 60: ff ff ff ff ff ff ff ff
[   49.766998] usb 2-1.4: 68: ff ff ff ff ff ff ff ff
[   49.767540] usb 2-1.4: 70: ff ff ff ff ff ff ff ff
[   49.768083] usb 2-1.4: 78: ff ff ff ff ff ff ff ff
[   49.768619] usb 2-1.4: 80: ff ff ff ff ff ff ff ff
[   49.769152] usb 2-1.4: 88: ff ff ff ff ff ff ff ff
[   49.769686] usb 2-1.4: 90: ff ff ff ff ff ff ff ff
[   49.770220] usb 2-1.4: 98: ff ff ff ff ff ff ff ff
[   49.770748] usb 2-1.4: a0: ff ff ff ff ff ff ff ff
[   49.771271] usb 2-1.4: a8: ff ff ff ff ff ff ff ff
[   49.771794] usb 2-1.4: b0: ff ff ff ff ff ff ff ff
[   49.772312] usb 2-1.4: b8: 20 0d ff 00 33 88 ff ff
[   49.772830] usb 2-1.4: c0: ff 01 20 13 00 00 00 ff
[   49.773347] usb 2-1.4: c8: 00 00 ff ff ff ff ff ff
[   49.773863] usb 2-1.4: d0: da 0b 8b 81 e7 47 02 00
[   49.774373] usb 2-1.4: d8: 19 88 00 1e 33 09 03 52
[   49.774871] usb 2-1.4: e0: 65 61 6c 74 65 6b 0d 03
[   49.775373] usb 2-1.4: e8: 38 30 32 2e 31 31 6e 20
[   49.775867] usb 2-1.4: f0: 4e 49 43 00 ff ff ff ff
[   49.776351] usb 2-1.4: f8: ff ff ff ff ff ff ff ff
[   49.776836] usb 2-1.4: 100: ff ff ff ff ff ff ff ff
[   49.777321] usb 2-1.4: 108: ff ff ff ff ff ff ff ff
[   49.777804] usb 2-1.4: 110: ff ff ff ff ff ff ff 0d
[   49.778275] usb 2-1.4: 118: 03 00 05 00 30 00 00 00
[   49.778747] usb 2-1.4: 120: 00 93 ff ff ff ff ff ff
[   49.779212] usb 2-1.4: 128: ff ff ff ff ff ff ff ff
[   49.779679] usb 2-1.4: 130: f6 a8 98 2d 03 92 98 00
[   49.780142] usb 2-1.4: 138: fc 8c 00 11 9b 44 02 0a
[   49.780608] usb 2-1.4: 140: ff ff ff ff ff ff ff ff
[   49.781073] usb 2-1.4: 148: ff ff ff ff ff ff ff ff
[   49.781536] usb 2-1.4: 150: ff ff ff ff ff ff ff ff
[   49.781996] usb 2-1.4: 158: ff ff ff ff ff ff ff ff
[   49.782447] usb 2-1.4: 160: ff ff ff ff ff ff ff ff
[   49.782898] usb 2-1.4: 168: ff ff ff ff ff ff ff ff
[   49.783336] usb 2-1.4: 170: ff ff ff ff ff ff ff ff
[   49.783774] usb 2-1.4: 178: ff ff ff ff ff ff ff ff
[   49.784207] usb 2-1.4: 180: ff ff ff ff ff ff ff ff
[   49.784628] usb 2-1.4: 188: ff ff ff ff ff ff ff ff
[   49.785035] usb 2-1.4: 190: ff ff ff ff ff ff ff ff
[   49.785429] usb 2-1.4: 198: ff ff ff ff ff ff ff ff
[   49.785816] usb 2-1.4: 1a0: ff ff ff ff ff ff ff ff
[   49.786187] usb 2-1.4: 1a8: ff ff ff ff ff ff ff ff
[   49.786551] usb 2-1.4: 1b0: ff ff ff ff ff ff ff ff
[   49.786907] usb 2-1.4: 1b8: ff ff ff ff ff ff ff ff
[   49.787261] usb 2-1.4: 1c0: ff ff ff ff ff ff ff ff
[   49.787610] usb 2-1.4: 1c8: ff ff ff ff ff ff ff ff
[   49.787944] usb 2-1.4: 1d0: ff ff ff ff ff ff ff ff
[   49.788267] usb 2-1.4: 1d8: ff ff ff ff ff ff ff ff
[   49.788579] usb 2-1.4: 1e0: ff ff ff ff ff ff ff ff
[   49.788891] usb 2-1.4: 1e8: ff ff ff ff ff ff ff ff
[   49.789195] usb 2-1.4: 1f0: ff ff ff ff ff ff ff ff
[   49.789492] usb 2-1.4: 1f8: ff ff ff ff ff ff ff ff
[   49.789780] usb 2-1.4: RTL8192EU rev B (SMIC) 2T2R, TX queues 3, WiFi=1, BT=0,
 GPS=0, HI PA=0
[   49.790086] usb 2-1.4: RTL8192EU MAC: 00:19:88:00:1e:33
[   49.790393] usb 2-1.4: rtl8xxxu: Loading firmware rtlwifi/rtl8192eu_nic.bin
[   49.816242] usb 2-1.4: Firmware revision 19.0 (signature 0x92e1)
[   66.100685] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   67.325452] wlan0: authenticate with e0:3f:49:97:0c:68
[   67.348290] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[   67.352300] wlan0: authenticated
[   67.354252] wlan0: associate with e0:3f:49:97:0c:68 (try 1/3)
[   67.365086] wlan0: RX AssocResp from e0:3f:49:97:0c:68 (capab=0xc11 status=0 a
id=1)
[   67.367429] usb 2-1.4: rtl8xxxu_bss_info_changed: HT supported
[   67.369542] wlan0: associated
[   67.370083] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  380.420651] wlan0: deauthenticated from e0:3f:49:97:0c:68 (Reason: 3=DEAUTH_LE
AVING)
[  381.674392] wlan0: authenticate with e0:3f:49:97:0c:68
[  381.697604] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[  381.906162] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[  382.114170] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[  382.322189] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[  383.954439] wlan0: authenticate with e0:3f:49:97:0c:68
[  383.976941] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[  384.178355] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[  384.386363] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[  384.594383] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[  386.730693] wlan0: authenticate with e0:3f:49:97:0c:68
[  386.753198] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[  386.954610] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[  387.162618] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[  387.370637] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[  397.516819] wlan0: authenticate with e0:3f:49:97:0c:68
[  397.529074] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[  397.731597] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[  397.939614] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[  398.147631] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[  426.414414] wlan0: authenticate with e0:3f:49:97:0c:68
[  426.437384] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[  426.638255] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[  426.846263] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[  427.054281] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[  463.313819] wlan0: authenticate with e0:3f:49:97:0c:68
[  463.336685] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[  463.537642] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[  463.745651] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[  463.953670] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[  553.226072] wlan0: authenticate with e0:3f:49:97:0c:68
[  553.249034] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[  553.449901] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[  553.657909] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[  553.865928] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[  622.136403] wlan0: authenticate with e0:3f:49:97:0c:68
[  622.159308] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[  622.360239] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[  622.568248] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[  622.776267] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[  759.053074] wlan0: authenticate with e0:3f:49:97:0c:68
[  759.075897] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[  759.276802] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[  759.484810] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[  759.692829] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[  913.971203] wlan0: authenticate with e0:3f:49:97:0c:68
[  913.994407] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[  914.203030] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[  914.411037] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[  914.619056] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[ 1063.896978] wlan0: authenticate with e0:3f:49:97:0c:68
[ 1063.919829] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[ 1064.120800] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[ 1064.328809] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[ 1064.536826] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[ 1230.816360] wlan0: authenticate with e0:3f:49:97:0c:68
[ 1230.838703] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[ 1231.040109] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[ 1231.243792] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[ 1231.448163] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[ 1250.385904] kworker/dying (27) used greatest stack depth: 11848 bytes left
[ 1386.726605] wlan0: authenticate with e0:3f:49:97:0c:68
[ 1386.749555] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[ 1386.950442] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[ 1387.158451] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[ 1387.366469] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[ 1518.642733] wlan0: authenticate with e0:3f:49:97:0c:68
[ 1518.665180] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[ 1518.866556] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[ 1519.074564] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[ 1519.282583] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[ 1653.551219] wlan0: authenticate with e0:3f:49:97:0c:68
[ 1653.574209] wlan0: send auth to e0:3f:49:97:0c:68 (try 1/3)
[ 1653.782935] wlan0: send auth to e0:3f:49:97:0c:68 (try 2/3)
[ 1653.990955] wlan0: send auth to e0:3f:49:97:0c:68 (try 3/3)
[ 1654.198974] wlan0: authentication with e0:3f:49:97:0c:68 timed out
[ 1718.100734] usb 2-1.4: USB disconnect, device number 7
[ 1718.131956] usb 2-1.4: rtl8192eu_active_to_emu: Disabling MAC timed out
[ 1718.132866] usb 2-1.4: disconnecting

--------------1958C3EB904183B596E72750--
