Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s32.bay0.hotmail.com ([65.54.246.232]:34619 "EHLO
	bay0-omc3-s32.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbYBNC2e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 21:28:34 -0500
Message-ID: <BAY101-W1421BB30E73369FE0A2E3DC8250@phx.gbl> (sfid-20080214_022838_372811_F76D121D)
From: Adam Turk <bofh1234@hotmail.com>
To: Pavel Roskin <proski@gnu.org>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: kernel 2.6.25-rc1 and no /dev/rt73usb
Date: Wed, 13 Feb 2008 21:28:33 -0500
In-Reply-To: <1202952347.29519.5.camel@dv>
References: <BAY101-W101597BA2B1DDD58D6F497C8250@phx.gbl>
 <1202952347.29519.5.camel@dv>
Content-Type: text/plain; charset=iso-8859-1
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: proski@gnu.org
>> On Wed, 2008-02-13 at 20:14 -0500, Adam Turk wrote:
>
>> However no rt73usb device is created. Why isn't this working?
>
> Network devices don't have corresponding device nodes under /dev. The=
y
> can be seen with "ifconfig -a", and the wireless properties can be
> examined and changed with iwconfig.
>
> The messages may be different because you changed the debug level or
> because the device is not brought up by some reason. By the way, it's
> better to examine kernel messages with the dmesg command, because is
> shows all messages, whereas syslog can suppress some of them.

Ok.  nothing listed in ifconfig -a.  Here is the dmesg output.  Still t=
he same error message as 2.6.24.
drivers/usb/core/inode.c: creating file '002'
usb 1-1: New USB device found, idVendor=3D148f, idProduct=3D2573
usb 1-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 1-1: Product: 802.11 bg WLAN
usb 1-1: Manufacturer: Ralink
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0002
rt73usb 1-1:1.0: usb_probe_interface
rt73usb 1-1:1.0: usb_probe_interface - got id
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET BG: 0x00=
00
phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0002, =
rev: 0002573a.
phy0: Selected rate control algorithm 'pid'
phy0: Failed to initialize wep
phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
rt73usb: probe of 1-1:1.0 failed with error -12
usbcore: registered new interface driver rt73usb

What is wrong with thing?
Thanks,

_________________________________________________________________
Climb to the top of the charts!=A0Play the word scramble challenge with=
 star power.
http://club.live.com/star_shuffle.aspx?icid=3Dstarshuffle_wlmailtextlin=
k_jan-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
