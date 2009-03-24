Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:30285 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbZCXFsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 01:48:32 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3246157wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 22:48:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237859527.5714.60.camel@marvin>
References: <1237849455.16745.41.camel@marvin> <43e72e890903231610k54ba0f15hf1e3146290c7d67a@mail.gmail.com>
	<1237859527.5714.60.camel@marvin>
Date: Mon, 23 Mar 2009 22:48:15 -0700
Message-ID: <43e72e890903232248m1f6fc27fw92086d391c86d3eb@mail.gmail.com> (sfid-20090324_064837_343601_5717775C)
Subject: Re: [BUG] rtl8187, cfg80211 - unable to handle kernel NULL pointer
	dereference
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Martin Capitanio <martin@capitanio.org>
Cc: Larry.Finger@lwfinger.net, herton@mandriva.com.br,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 6:52 PM, Martin Capitanio <martin@capitanio.org=
> wrote:
> Am Montag, den 23.03.2009, 16:10 -0700 schrieb Luis R. Rodriguez:
>> On Mon, Mar 23, 2009 at 4:04 PM, Martin Capitanio <martin@capitanio.=
org> wrote:
>> > Setting the EU or DE regulatory domain (cfg80211 ieee80211_regdom=3D=
EU)
>> > seems to be working, but afterwards inserting the rtl8187 driver c=
auses crash:
>>
>> Please try with today's wireless-testing a set of fixes went in to
>
> Sure, I tried "DE" with the same result as well.
>
> Fortunately, wireless-testing doesn't crash during the rtl8187 driver=
 load
> anymore, but changing the regulatory domain seems to be no-op (see be=
low).
>
> Furthermore the current wireless-testing breaks the rtl8187 driver co=
mpletely.
> If I try to connect to an AP (with or without changing the domain),
> it hard-freezes the kernel without any log entry.
>
>> address a bug with "EU". Mind you, "EU" is an invalid ISO3166-alpha2
>> so you may want to consider start using your own valid country alpha=
2
>> code. If you use "EU" now you'll world roam.
>
> I wonder why is there than the EU (confusing) code at all?

Its complete crap, in fact stop using the module parameter. "EU" is
part of the 3 static regulatory domains left from the old regulatory
implementation. It should have been removed eons ago but old habits
are hard to kill. Fortunately distributions are now shipping and with
OLD_REG disabled on 2.6.28 (both FC11 and Ubuntu Jaunty). The "EU"
option and even the ieee80211_regdom module parameter are simply not
an option in 2.6.28 and 2.6.29 if OLD_REG is disabled, we have a
suitable replacement -- a userspace call.

Unfortunately I just added the module parameter when OLD_REG is
disabled to try to remove OLD_REG completely but that didn't seem to
work yet.

> Actually I would expect a "smallest common intersection" of the 27 Eu=
ropean
> Union member states.

Heh, well its easier than that you get a ISO / IEC 3166 alpha2 for
each country. So you just pick your country. "EU" is an ancient
regulatory concoction, it should be ignored and forgotten.

> Martin
>
> ----
> 2.6.29-rc8-wl at commit 8fe80c672051978895d0c3ef7be1dc7bcaa8621e
>
> [ =C2=A0 14.724111] cfg80211: Using static regulatory domain info
> [ =C2=A0 14.724154] cfg80211: Regulatory domain: US

So, not all of my patches were applied... Specifically the one that
removed OLD_REG was not applied. This is why you are getting "US"
still as your default. You probably have OLD_REG enabled in your
kernel.

> [ =C2=A0 14.724186] =C2=A0(start_freq - end_freq @ bandwidth), (max_a=
ntenna_gain, max_eirp)
> [ =C2=A0 14.724233] =C2=A0(2402000 KHz - 2472000 KHz @ 40000 KHz), (6=
00 mBi, 2700 mBm)
> [ =C2=A0 14.724267] =C2=A0(5170000 KHz - 5190000 KHz @ 40000 KHz), (6=
00 mBi, 2300 mBm)
> [ =C2=A0 14.724300] =C2=A0(5190000 KHz - 5210000 KHz @ 40000 KHz), (6=
00 mBi, 2300 mBm)
> [ =C2=A0 14.724334] =C2=A0(5210000 KHz - 5230000 KHz @ 40000 KHz), (6=
00 mBi, 2300 mBm)
> [ =C2=A0 14.724367] =C2=A0(5230000 KHz - 5330000 KHz @ 40000 KHz), (6=
00 mBi, 2300 mBm)
> [ =C2=A0 14.724402] =C2=A0(5735000 KHz - 5835000 KHz @ 40000 KHz), (6=
00 mBi, 3000 mBm)
> [ =C2=A0 14.724453] cfg80211: Calling CRDA for country: US
> [ =C2=A0 14.731855] usbcore: registered new interface driver hiddev
> [ =C2=A0 14.734528] input: Logitech USB Receiver as /devices/pci0000:=
00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input6
> [ =C2=A0 14.744220] generic-usb 0003:046D:C526.0001: input,hidraw0: U=
SB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1/input0
> [ =C2=A0 14.749224] input: Logitech USB Receiver as /devices/pci0000:=
00/0000:00:1d.0/usb5/5-1/5-1:1.1/input/input7
> [ =C2=A0 14.760185] generic-usb 0003:046D:C526.0002: input,hiddev0,hi=
draw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0=
-1/input1
> [ =C2=A0 14.761508] usbcore: registered new interface driver usbhid
> [ =C2=A0 14.762406] usbhid: v2.6:USB HID core driver
> [ =C2=A0 14.785424] uvcvideo: Found UVC 1.00 device CNF7051 (04f2:b07=
0)
> [ =C2=A0 14.787514] input: CNF7051 as /devices/pci0000:00/0000:00:1a.=
7/usb1/1-2/1-2:1.0/input/input8
> [ =C2=A0 14.795375] Bluetooth: Generic Bluetooth USB driver ver 0.4
> [ =C2=A0 14.795520] usbcore: registered new interface driver btusb
> [ =C2=A0 14.874378] usbcore: registered new interface driver uvcvideo
> [ =C2=A0 14.874417] USB Video Class driver (v0.1.0)
> [ =C2=A0 15.384073] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x9280=
b1, caps: 0xa04711/0xa04000
> [ =C2=A0 15.406636] rtl8187: 8187B chip detected.
> [ =C2=A0 15.407152] phy0: Selected rate control algorithm 'minstrel'
>
>
> modprobe -r rtl8187
> modprobe -r cfg80211
> modprobe cfg80211 ieee80211_regdom=3DDE
> [ =C2=A0570.676064] usbcore: deregistering interface driver rtl8187
> [ =C2=A0570.944071] usb 2-6: reset high speed USB device using ehci_h=
cd and address 4
> [ =C2=A0687.552176] cfg80211: Using static regulatory domain info
> [ =C2=A0687.552182] cfg80211: Regulatory domain: US
> [ =C2=A0687.552186] =C2=A0(start_freq - end_freq @ bandwidth), (max_a=
ntenna_gain, max_eirp)
> [ =C2=A0687.552191] =C2=A0(2402000 KHz - 2472000 KHz @ 40000 KHz), (6=
00 mBi, 2700 mBm)
> [ =C2=A0687.552196] =C2=A0(5170000 KHz - 5190000 KHz @ 40000 KHz), (6=
00 mBi, 2300 mBm)
> [ =C2=A0687.552201] =C2=A0(5190000 KHz - 5210000 KHz @ 40000 KHz), (6=
00 mBi, 2300 mBm)
> [ =C2=A0687.552206] =C2=A0(5210000 KHz - 5230000 KHz @ 40000 KHz), (6=
00 mBi, 2300 mBm)
> [ =C2=A0687.552210] =C2=A0(5230000 KHz - 5330000 KHz @ 40000 KHz), (6=
00 mBi, 2300 mBm)
> [ =C2=A0687.552215] =C2=A0(5735000 KHz - 5835000 KHz @ 40000 KHz), (6=
00 mBi, 3000 mBm)

So.. this still happens because within OLD_REG "DE" is not a valid
static regulatory domain, so first you get by default the "US" static
regulatory domain. That is -- if you want to use OLD_REG and get a
static regulatory domain applied by default first you only have 3
options:

"US"
"EU"
"JP"

Now this is pure garbage and which is why people should stop using
OLD_REG and forget about it.

> [ =C2=A0687.552501] cfg80211: Calling CRDA for country: DE

Strange well I just tested with OLD_REG and I get the same "US" crap
as above but then immediately after that I got "DE" as follows:

[15895.175144] cfg80211: Regulatory domain changed to country: DE
[15895.175189] 	(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[15895.175241] 	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm=
)
[15895.175274] 	(5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm=
)
[15895.175312] 	(5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm=
)

You probably don't have the wireless-regdb and crda installed. We have
offloaded all this regulatory information to userspace, you know get a
decent world roaming regulatory domain by default instead of assuming
everyone lives the United States. Then you can set the regulatory
domain.

http://wireless.kernel.org/download/wireless-regdb/
sudo make install

http://wireless.kernel.org/download/crda/
make
sudo make install

Then you should get your "DE".

> modprobe rtl8187
> [ =C2=A0731.873109] rtl8187: 8187B chip detected.
> [ =C2=A0731.877283] phy0: Selected rate control algorithm 'minstrel'
> [ =C2=A0731.877990] phy0: hwaddr , RTL8187BvE V0 + rtl8225z2
> [ =C2=A0731.878047] usbcore: registered new interface driver rtl8187
>
> iw reg get
> country US:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(2402 - 2472 @ 40), (6, 27)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5170 - 5190 @ 40), (6, 23)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5190 - 5210 @ 40), (6, 23)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5210 - 5230 @ 40), (6, 23)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5230 - 5330 @ 40), (6, 23)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5735 - 5835 @ 40), (6, 30)
>
> iw reg set DE
> iw reg get
> country US:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(2402 - 2472 @ 40), (6, 27)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5170 - 5190 @ 40), (6, 23)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5190 - 5210 @ 40), (6, 23)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5210 - 5230 @ 40), (6, 23)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5230 - 5330 @ 40), (6, 23)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5735 - 5835 @ 40), (6, 30)
>
>
> iw list
> Wiphy phy0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Band 1:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Frequencies:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2412 MHz [1] (27.0 dBm)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2417 MHz [2] (27.0 dBm)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2422 MHz [3] (27.0 dBm)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2427 MHz [4] (27.0 dBm)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2432 MHz [5] (27.0 dBm)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2437 MHz [6] (27.0 dBm)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2442 MHz [7] (27.0 dBm)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2447 MHz [8] (27.0 dBm)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2452 MHz [9] (27.0 dBm)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2457 MHz [10] (27.0 dBm)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2462 MHz [11] (27.0 dBm)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2467 MHz [12] (disabled)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2472 MHz [13] (disabled)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2484 MHz [14] (disabled)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Bitrates:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 1.0 Mbps
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 2.0 Mbps
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 5.5 Mbps
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 11.0 Mbps
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 6.0 Mbps
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 9.0 Mbps
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 12.0 Mbps
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 18.0 Mbps
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 24.0 Mbps
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 36.0 Mbps
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 48.0 Mbps
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* 54.0 Mbps
> =C2=A0 =C2=A0 =C2=A0 =C2=A0max # scan SSIDs: 4
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Supported interface modes:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Station
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Monitor

I don't see any panics, everything is as expected --except my removal
of OLD_REG patch was not applied.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
