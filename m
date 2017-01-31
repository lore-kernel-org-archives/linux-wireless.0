Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36411 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdAaGYT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 01:24:19 -0500
Received: by mail-oi0-f44.google.com with SMTP id u143so208716554oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2017 22:24:19 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 31 Jan 2017 07:24:13 +0100
Message-ID: <CACna6rx_gU-k790j=SnSvOtq5C2vxXWEQ75k=Y2CiUsHnrHEsA@mail.gmail.com> (sfid-20170131_072451_453466_D5BF2393)
Subject: Unsupported NVRAM on D-Link DIR-885L (affects brcmfmac)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>,
        Arend Van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just noticed my DIR-885L has some weird NVRAM format. Linux doesn't
support it, it reads only part of it, which may affect brcmfmac.

There goes the most interesting part:
00000000  46 4c 53 48 50 3e 00 00  3f 01 00 00 4b 01 00 00  |FLSHP>..?...K.=
..|
00000010  00 00 00 00 31 3a 70 61  35 67 38 30 61 33 3d 30  |....1:pa5g80a3=
=3D0|
00000020  78 31 64 36 36 2c 30 78  65 34 35 66 2c 30 78 32  |x1d66,0xe45f,0=
x2|
00000030  32 37 61 2c 30 78 32 33  36 65 2c 30 78 31 64 30  |27a,0x236e,0x1=
d0|
00000040  30 2c 30 78 65 62 38 38  2c 30 78 33 32 39 36 2c  |0,0xeb88,0x329=
6,|
(...)
00003e00  3d 36 35 35 33 35 00 31  3a 72 78 67 61 69 6e 65  |=3D65535.1:rxg=
aine|
00003e10  72 72 32 67 61 30 3d 36  33 00 30 3a 75 6c 62 70  |rr2ga0=3D63.0:=
ulbp|
00003e20  64 6f 66 66 73 35 67 62  34 61 31 3d 36 35 35 33  |doffs5gb4a1=3D=
6553|
00003e30  35 00 30 3a 6d 63 73 62  77 32 30 35 67 68 70 6f  |5.0:mcsbw205gh=
po|
00003e40  3d 32 38 35 38 38 33 35  39 36 38 00 00 00 00 00  |=3D2858835968.=
....|
00003e50  6f 66 66 73 65 74 32 30  69 6e 34 30 6d 32 67 3d  |offset20in40m2=
g=3D|
00003e60  36 35 35 33 35 00 65 74  30 6d 61 63 61 64 64 72  |65535.et0macad=
dr|
00003e70  3d 30 30 3a 30 30 3a 30  30 3a 30 30 3a 30 30 3a  |=3D00:00:00:00=
:00:|
00003e80  30 30 00 31 3a 72 78 67  61 69 6e 73 32 67 74 72  |00.1:rxgains2g=
tr|

Header has length field 50 3e 00 00 which means 0x3e50 bytes. I was
surprised to see more entries after then "end" of the NVRAM.

What's interesting CFE (bootloader) also can't read these entries.

Any idea what format is that?

--=20
Rafa=C5=82
