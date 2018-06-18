Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:42412 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754519AbeFRUBX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 16:01:23 -0400
Received: by mail-oi0-f68.google.com with SMTP id k190-v6so15997789oib.9
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2018 13:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20180618135329.N2TLO.197792.root@dnvrco-web12> <5B280692.2060106@broadcom.com>
In-Reply-To: <5B280692.2060106@broadcom.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Mon, 18 Jun 2018 22:01:11 +0200
Message-ID: <CAFBinCBe=d-z-uzCm0Smn5Ee3btj_YNOH-s8jFzNX7qX=4ug8g@mail.gmail.com> (sfid-20180618_220127_258448_D24A7474)
Subject: Re: Atheros AR9462 - 5Ghz not working
To: arend.vanspriel@broadcom.com
Cc: mgreger@cinci.rr.com, pozega.tomislav@gmail.com,
        janusz.dziedzic@gmail.com, linux-wireless@vger.kernel.org,
        sedat.dilek@gmail.com, kazikcz@gmail.com, bvermeul@blackstar.nl
Content-Type: multipart/mixed; boundary="0000000000009ebd7e056ef00720"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0000000000009ebd7e056ef00720
Content-Type: text/plain; charset="UTF-8"

Hi Arend,

On Mon, Jun 18, 2018 at 9:23 PM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> + Martin
thank you for CC'ing me!

> On 6/18/2018 3:53 PM, mgreger@cinci.rr.com wrote:
> >
> > ---- Tom Psyborg <pozega.tomislav@gmail.com> wrote:
> >> Hi
> >>
> >> Your log only show attemps on ch 2447, Can you try connecting to 5GHz
> >> AP? Connect to Hidden Wireless Network option at the bottom of the
> >> nm-applet? Running airodump in monitor mode to see if it captures
> >> anything? Maybe your laptop's antennas were designed for 2.4G card
> >> only but this just dumb guessing...
> >>
> >
> > It won't connect to any 5GHz AP.
> > I don't run network manager or Gnome, in fact X11 is not installed on this machine at all.
> > I don't think there is such a thing as 2.4GHz vs 5GHz antennas.
>
> Actually there is. At least there are 2.4G specific antennas and
> dual-band antennas.
>
> In 4.11 there have been a couple eeprom related changes dealing with
> endianness of fields in eeprom. Could be those cause a regression for
> you. I don't have the exact sha id of those commits, but I added the
> author to this thread.
I couldn't find the whole thread in a mailing list archive somewhere
could the original reporter please send a kernel log (dmesg) and some
information about the host system?

if the host system uses devicetree (maybe because it's an ARM based
system or some PowerMac, etc.) then please keep reading

Bas Vermeulen (I added him to this thread *in case* we find out that
it's the same issue) reported that a AR9278 card refused to work in
his "PowerMac G5"
he posted a patch here: [0]
back then I asked if he could test and send a modified version of his
patch - I included that below
(if someone is interested in the cause: whenever there is a devicetree
node for the ath9k card then the driver-internal flag AH_NO_EEP_SWAP
is set unconditionally. this flag is *NOT* set if there's no
devicetree node. if it is set then the driver doesn't try to swap the
EEPROM data as this breaks some OpenWrt based devices. however, since
all OpenWrt devices set the "qca,no-eeprom" property we can move
setting the AH_NO_EEP_SWAP flag into the existing if-block and
hopefully solve all issues)


Regards
Martin


[0] https://patchwork.kernel.org/patch/10241731/

--0000000000009ebd7e056ef00720
Content-Type: application/x-patch;
	name="ath9k-no-eep-swap-only-with-of-no-eeprom.patch"
Content-Disposition: attachment;
	filename="ath9k-no-eep-swap-only-with-of-no-eeprom.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jikokrmm0>
X-Attachment-Id: f_jikokrmm0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9pbml0LmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaW5pdC5jCmluZGV4IGMwNzBhOWU1MWViZi4uZmFl
NTcyYjM4NDE2IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaW5p
dC5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9pbml0LmMKQEAgLTYzNiwx
NSArNjM2LDE1IEBAIHN0YXRpYyBpbnQgYXRoOWtfb2ZfaW5pdChzdHJ1Y3QgYXRoX3NvZnRjICpz
YykKIAkJcmV0ID0gYXRoOWtfZWVwcm9tX3JlcXVlc3Qoc2MsIGVlcHJvbV9uYW1lKTsKIAkJaWYg
KHJldCkKIAkJCXJldHVybiByZXQ7CisKKwkJYWgtPmFoX2ZsYWdzICY9IH5BSF9VU0VfRUVQUk9N
OworCQlhaC0+YWhfZmxhZ3MgfD0gQUhfTk9fRUVQX1NXQVA7CiAJfQogCiAJbWFjID0gb2ZfZ2V0
X21hY19hZGRyZXNzKG5wKTsKIAlpZiAobWFjKQogCQlldGhlcl9hZGRyX2NvcHkoY29tbW9uLT5t
YWNhZGRyLCBtYWMpOwogCi0JYWgtPmFoX2ZsYWdzICY9IH5BSF9VU0VfRUVQUk9NOwotCWFoLT5h
aF9mbGFncyB8PSBBSF9OT19FRVBfU1dBUDsKLQogCXJldHVybiAwOwogfQogCg==
--0000000000009ebd7e056ef00720--
