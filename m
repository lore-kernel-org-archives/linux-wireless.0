Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc1-s14.bay0.hotmail.com ([65.54.246.86]:13293 "EHLO
	bay0-omc1-s14.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758075AbYBBOuI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 09:50:08 -0500
Message-ID: <BAY101-W13598C0E7CF8F2AAD14642C8310@phx.gbl> (sfid-20080202_145025_935822_F3615A36)
From: Adam Turk <bofh1234@hotmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: rt73 driver doesn't work in 2.6.24
Date: Sat, 2 Feb 2008 09:50:08 -0500
In-Reply-To: <200802021536.50534.IvDoorn@gmail.com>
References: <BAY101-W12F4D19DA27A5DA9F177E1C8310@phx.gbl>
 <200802021536.50534.IvDoorn@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> rt73usb 1-1:1.0: usb_probe_interface
>> rt73usb 1-1:1.0: usb_probe_interface - got id
>> phy0 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
>> phy0 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
>> phy0 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET BG: 0=
x0000
>> phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 000=
2, rev: 0002573a.
>> phy0: Selected rate control algorithm 'simple'
>> phy0: Failed to initialize wep
>
> This is a problem with mac80211 loading the wep encryption, did you l=
oad the arc4 module?
>
> Ivo

bt ~ # lsmod
Module Size Used by
snd_seq_oss 30080 0
snd_seq_midi_event 7808 1 snd_seq_oss
snd_seq 46256 4 snd_seq_oss,snd_seq_midi_event
snd_pcm_oss 36640 0
snd_mixer_oss 16128 2 snd_pcm_oss
fuse 45972 1
snd_ca0106 32992 1
snd_rawmidi 23200 1 snd_ca0106
snd_seq_device 7688 2 snd_seq_oss,snd_rawmidi
snd_ac97_codec 92320 1 snd_ca0106
rt73usb 27520 0
snd_pcm 65412 3 snd_pcm_oss,snd_ca0106,snd_ac97_codec
rt2x00usb 12032 1 rt73usb
rt2x00lib 19712 2 rt73usb,rt2x00usb
snd_timer 21252 2 snd_seq,snd_pcm
snd 48740 10 snd_seq_oss,snd_seq,snd_pcm_oss,snd_mixer_oss,snd_ca0106,s=
nd_rawmidi,snd_seq_device,snd_ac97_codec,snd_pcm,snd_timer
firmware_class 10240 1 rt2x00lib
soundcore 8160 2 snd
crc_itu_t 2944 1 rt2x00lib
ac97_bus 2944 1 snd_ac97_codec
mac80211 110988 2 rt2x00usb,rt2x00lib
snd_page_alloc 10888 2 snd_ca0106,snd_pcm
cfg80211 13832 1 mac80211

No it doesn't appear so.  So lets do it:
insmod arc4.ko=20
rmmod rt73usb
rmmod rt2x00usb
rmmod rt2x00lib

I then unplugged and plugged in (waiting 30 seconds) and still no joy. =
Same messages as earlier.  Does arc4 have to be compiled into the kerne=
l?

Thanks,

_________________________________________________________________
Need to know the score, the latest news, or you need your Hotmail=AE-ge=
t your "fix".
http://www.msnmobilefix.com/Default.aspx-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
