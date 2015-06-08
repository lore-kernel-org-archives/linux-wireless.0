Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:44103 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbbFHMz4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 08:55:56 -0400
Message-ID: <1433768205.28058.19.camel@embedded.rocks> (sfid-20150608_145609_424963_E374F92E)
Subject: Re: brcmfmac: brcmf_p2p_create_p2pdev: timeout occurred
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Date: Mon, 08 Jun 2015 14:56:45 +0200
In-Reply-To: <55758D7E.3000603@broadcom.com>
References: <1433766944.28058.16.camel@embedded.rocks>
	 <55758D7E.3000603@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Mo, 2015-06-08 at 14:41 +0200, Arend van Spriel wrote:
> On 06/08/15 14:35, Jörg Krause wrote:
> > Hi,
> > 
> > I've trouble creating the p2p interface on a BCM43362 wifi device
> > running Linux kernel 4.0.4:
> > 
> >      # dmesg | grep brcmfmac
> >      [    7.010870] brcmfmac: brcmf_c_preinit_dcmds: Firmware 
> > version =
> >      wl0: Apr 22 2013 14:50:00 version 5.90.195.89.6 FWID 01
> > -b30a427d
> >      [    7.158905] brcmfmac: brcmf_cfg80211_reg_notifier: not a 
> > ISO3166
> >      code
> >      [   11.007164] brcmfmac: brcmf_p2p_create_p2pdev: timeout 
> > occurred
> > 
> > Trying to add the p2p interface manually:
> > 
> >      # iw phy0 interface add p2p0 type __p2pdev
> >      [  372.042704] brcmfmac: brcmf_link_down: WLC_DISASSOC failed 
> > (-52)
> >      [  373.637263] brcmfmac: brcmf_p2p_create_p2pdev: timeout 
> > occurred
> >      [  373.679377] brcmfmac: brcmf_cfg80211_del_key: invalid key 
> > index (4)
> >      [  373.685733] brcmfmac: brcmf_cfg80211_del_key: invalid key 
> > index (5)
> > 
> > Any idea?
> 
> Wondering whether it is similar to what Rafal reported. Can you do a 
> hexdump, ie. hexdump -C brcmfmac43362-sdio.bin | tail -30

This is the output:

$ hexdump -C brcmfmac43362-sdio.bin | tail -30
000357e0  03 37 a2 00 02 5e 02 f0  00 a8 01 87 60 05 60 6b 
 |.7...^......`.`k|
000357f0  03 00 02 de 02 f0 00 00  00 68 2b eb 00 13 11 00 
 |.........h+.....|
00035800  b0 2c 13 00 17 a1 00 e0  5e 85 60 b7 a1 00 6b de 
 |.,......^.`...k.|
00035810  86 23 33 11 01 86 e0 06  f7 f7 bf 00 02 de 02 f0 
 |.#3.............|
00035820  00 00 00 b0 5e 8f 00 10  64 00 b0 5e 87 00 17 a3 
 |....^...d..^....|
00035830  00 b0 5e 8b 00 10 65 00  b0 5a 03 00 17 a1 00 68 
 |..^...e..Z.....h|
00035840  41 93 00 13 1a 00 02 5e  02 f0 00 a2 00 b0 40 67  
|A......^......@g|
00035850  00 16 01 00 e0 41 93 00  50 64 00 b0 5a 07 00 17 
 |.....A..Pd..Z...|
00035860  a2 00 02 5e 02 f0 00 a8  00 e0 41 97 00 50 65 00 
 |...^......A..Pe.|
00035870  e8 5e 8f 00 37 a3 00 68  de 8f 00 13 15 00 02 de 
 |.^..7..h........|
00035880  02 f0 00 00 00 b0 5e 8f  00 10 64 00 b0 5e 87 00 
 |......^...d..^..|
00035890  17 a3 00 b0 5e 8b 00 10  65 00 b0 5a 03 00 17 80 
 |....^...e..Z....|
000358a0  00 68 41 93 00 13 28 00  02 5e 02 f0 0e 3f 00 b0 
 |.hA...(..^...?..|
000358b0  5e 07 00 16 01 00 e0 41  93 00 50 64 00 b0 5a 07 
 |^......A..Pd..Z.|
000358c0  00 17 81 00 02 5e 02 f0  0e 44 00 e0 41 97 00 50 
 |.....^...D..A..P|
000358d0  65 00 e8 5e 8f 00 37 a3  00 68 de 8f 00 13 23 00 
 |e..^..7..h....#.|
000358e0  02 de 02 f0 00 00 02 02  00 bf 00 01 88 02 03 c5 
 |................|
000358f0  73 00 01 b1 00 00 00 00  00 00 00 00 57 86 00 00 
 |s...........W...|
00035900  a5 c1 e1 42 05 5a c3 59  dc 01 75 51 3e 5b 23 49 
 |...B.Z.Y..uQ>[#I|
00035910  47 28 67 69 45 00 5e 55  f8 f5 c9 7d 42 0a b3 09 
 |G(giE.^U...}B...|
00035920  01 bd 32 08 01 00 34 33  33 36 32 61 32 2d 72 6f 
 |..2...43362a2-ro|
00035930  6d 6c 2f 73 64 69 6f 2d  67 2d 70 6e 6f 2d 70 6b  |ml/sdio-g
-pno-pk|
00035940  74 66 69 6c 74 65 72 2d  6b 65 65 70 61 6c 69 76  |tfilter
-keepaliv|
00035950  65 2d 77 61 70 69 2d 77  6d 65 2d 70 32 70 20 56  |e-wapi-wme
-p2p V|
00035960  65 72 73 69 6f 6e 3a 20  35 2e 39 30 2e 31 39 35  |ersion:
5.90.195|
00035970  2e 38 39 20 43 52 43 3a  20 62 64 31 65 33 65 35  |.89 CRC:
bd1e3e5|
00035980  61 20 44 61 74 65 3a 20  4d 6f 6e 20 32 30 31 33  |a Date:
Mon 2013|
00035990  2d 30 34 2d 32 32 20 31  37 3a 32 34 3a 34 34 20  |-04-22
17:24:44 |
000359a0  43 53 54 7d 00                                    |CST}.|
000359a5

Best regards
Jörg Krause
