Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35124 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbdAaKKY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 05:10:24 -0500
Received: by mail-oi0-f44.google.com with SMTP id j15so211413590oih.2
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2017 02:09:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rx_gU-k790j=SnSvOtq5C2vxXWEQ75k=Y2CiUsHnrHEsA@mail.gmail.com>
References: <CACna6rx_gU-k790j=SnSvOtq5C2vxXWEQ75k=Y2CiUsHnrHEsA@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 31 Jan 2017 11:09:09 +0100
Message-ID: <CACna6ry2_7Lqty6-Ov=B=TiHXDN6qTSLE_pYMMvZ3wiUFF9jgQ@mail.gmail.com> (sfid-20170131_111316_857867_A81DBB4A)
Subject: Re: Unsupported NVRAM on D-Link DIR-885L (affects brcmfmac)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>,
        Arend Van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 January 2017 at 07:24, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wro=
te:
> I just noticed my DIR-885L has some weird NVRAM format. Linux doesn't
> support it, it reads only part of it, which may affect brcmfmac.
>
> There goes the most interesting part:
> 00000000  46 4c 53 48 50 3e 00 00  3f 01 00 00 4b 01 00 00  |FLSHP>..?...=
K...|
> 00000010  00 00 00 00 31 3a 70 61  35 67 38 30 61 33 3d 30  |....1:pa5g80=
a3=3D0|
> 00000020  78 31 64 36 36 2c 30 78  65 34 35 66 2c 30 78 32  |x1d66,0xe45f=
,0x2|
> 00000030  32 37 61 2c 30 78 32 33  36 65 2c 30 78 31 64 30  |27a,0x236e,0=
x1d0|
> 00000040  30 2c 30 78 65 62 38 38  2c 30 78 33 32 39 36 2c  |0,0xeb88,0x3=
296,|
> (...)
> 00003e00  3d 36 35 35 33 35 00 31  3a 72 78 67 61 69 6e 65  |=3D65535.1:r=
xgaine|
> 00003e10  72 72 32 67 61 30 3d 36  33 00 30 3a 75 6c 62 70  |rr2ga0=3D63.=
0:ulbp|
> 00003e20  64 6f 66 66 73 35 67 62  34 61 31 3d 36 35 35 33  |doffs5gb4a1=
=3D6553|
> 00003e30  35 00 30 3a 6d 63 73 62  77 32 30 35 67 68 70 6f  |5.0:mcsbw205=
ghpo|
> 00003e40  3d 32 38 35 38 38 33 35  39 36 38 00 00 00 00 00  |=3D285883596=
8.....|
> 00003e50  6f 66 66 73 65 74 32 30  69 6e 34 30 6d 32 67 3d  |offset20in40=
m2g=3D|
> 00003e60  36 35 35 33 35 00 65 74  30 6d 61 63 61 64 64 72  |65535.et0mac=
addr|
> 00003e70  3d 30 30 3a 30 30 3a 30  30 3a 30 30 3a 30 30 3a  |=3D00:00:00:=
00:00:|
> 00003e80  30 30 00 31 3a 72 78 67  61 69 6e 73 32 67 74 72  |00.1:rxgains=
2gtr|
>
> Header has length field 50 3e 00 00 which means 0x3e50 bytes. I was
> surprised to see more entries after then "end" of the NVRAM.
>
> What's interesting CFE (bootloader) also can't read these entries.
>
> Any idea what format is that?

I used original D-Link firmware and did:
nvram set foo=3D"loremipsum"
nvram commit

After that NVRAM looks normal. Length is 04 66 00 00 which is 0x6604

00000000  46 4c 53 48 04 66 00 00  2e 01 00 00 4b 01 00 00  |FLSH.f......K.=
..|
00000010  00 00 00 00 77 6c 31 5f  33 67 70 70 6c 69 73 74  |....wl1_3gppli=
st|
00000020  3d 00 77 6c 30 5f 72 65  61 6c 6d 6c 69 73 74 3d  |=3D.wl0_realml=
ist=3D|
00000030  6d 61 69 6c 2e 65 78 61  6d 70 6c 65 2e 63 6f 6d  |mail.example.c=
om|
00000040  2b 30 2b 32 31 3d 32 2c  34 23 35 2c 37 3f 63 69  |+0+21=3D2,4#5,=
7?ci|
(...)
00003e00  33 3d 31 30 38 00 77 6c  31 5f 61 63 73 5f 63 69  |3=3D108.wl1_ac=
s_ci|
00003e10  5f 73 63 61 6e 5f 74 69  6d 65 6f 75 74 3d 33 30  |_scan_timeout=
=3D30|
00003e20  30 00 77 6c 31 5f 6d 6f  64 65 3d 61 70 00 77 6c  |0.wl1_mode=3Da=
p.wl|
00003e30  30 5f 64 66 73 5f 70 72  65 66 3d 00 30 3a 72 78  |0_dfs_pref=3D.=
0:rx|
00003e40  67 61 69 6e 65 72 72 32  67 61 31 3d 33 31 00 30  |gainerr2ga1=3D=
31.0|
00003e50  3a 70 64 6f 66 66 73 65  74 34 30 69 6e 38 30 6d  |:pdoffset40in8=
0m|
00003e60  35 67 62 31 3d 36 35 35  33 35 00 77 6c 31 5f 72  |5gb1=3D65535.w=
l1_r|
00003e70  78 63 68 61 69 6e 5f 70  77 72 73 61 76 65 5f 65  |xchain_pwrsave=
_e|
00003e80  6e 61 62 6c 65 3d 31 00  77 6c 30 5f 61 6d 70 64  |nable=3D1.wl0_=
ampd|
(...)
000065d0  78 65 31 61 65 2c 30 78  32 39 36 31 2c 30 78 32  |xe1ae,0x2961,0=
x2|
000065e0  34 36 31 2c 30 78 31 65  61 39 2c 30 78 64 61 37  |461,0x1ea9,0xd=
a7|
000065f0  63 2c 30 78 32 30 62 31  2c 30 78 32 33 37 38 00  |c,0x20b1,0x237=
8.|
00006600  00 00 00 00 ff ff ff ff  ff ff ff ff ff ff ff ff  |..............=
..|
00006610  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |..............=
..|

Should we care about this previous weird NVRAM format?

--=20
Rafa=C5=82
