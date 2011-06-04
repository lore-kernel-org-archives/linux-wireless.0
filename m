Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:22217 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab1FDR3N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 13:29:13 -0400
Date: Sat, 4 Jun 2011 19:29:40 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH wireless-2.6 v2] rt2x00: fix rmmod crash
Message-ID: <20110604172940.GA10984@localhost.localdomain> (sfid-20110604_192919_160593_4CD8D564)
References: <20110604144854.GA4865@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20110604144854.GA4865@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 04, 2011 at 04:48:54PM +0200, Stanislaw Gruszka wrote:
> Avoid queue and run autowakeup_work when device is not present anymore.

This patch fix a problem with autowakeup_work, but seems there is still
possible to use ->workqueue after free. This time with rxdone_work. I
have these memory corruptions when removing/loading rt73usb module in a
loop. Not observable with my previous patch.

Jun  4 17:13:30 localhost kernel: [ 3054.165453] BUG kmalloc-4096: Redzone overwritten
Jun  4 17:13:30 localhost kernel: [ 3054.165456] -----------------------------------------------------------------------------
Jun  4 17:13:30 localhost kernel: [ 3054.165458] 
Jun  4 17:13:30 localhost kernel: [ 3054.165462] INFO: 0xeeb4a032-0xeeb4a033. First byte 0xc0 instead of 0xcc
Jun  4 17:13:30 localhost kernel: [ 3054.165478] INFO: Allocated in 0xc06f age=3761052035 cpu=3342336 pid=304021504
Jun  4 17:13:30 localhost kernel: [ 3054.165484] INFO: Freed in 0xc06f age=4294917602 cpu=3342336 pid=1822949376
Jun  4 17:13:30 localhost kernel: [ 3054.165489] INFO: Slab 0xf500d900 objects=7 used=5 fp=0xeeb48000 flags=0x40004081
Jun  4 17:13:30 localhost kernel: [ 3054.165494] INFO: Object 0xeeb49030 @offset=4144 fp=0x0b06eeb4
Jun  4 17:13:30 localhost kernel: [ 3054.165496] 
Jun  4 17:13:30 localhost kernel: [ 3054.165499] Bytes b4 0xeeb49020:  34 00 00 00 a1 d6 29 00 5a 5a 5a 5a 5a 5a 5a 5a 4...¡Ö).ZZZZZZZZ
Jun  4 17:13:30 localhost kernel: [ 3054.165522]   Object 0xeeb49030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.165545]   Object 0xeeb49040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.165567]   Object 0xeeb49050:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.165588]   Object 0xeeb49060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.165610]   Object 0xeeb49070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b f6 58 c0 3f kkkkkkkkkkkköXÀ?
Jun  4 17:13:30 localhost kernel: [ 3054.165632]   Object 0xeeb49080:  20 b1 ff 58 57 6b 20 2e 34 1f 5a b4 a8 6c 1a 3b .±ÿXWk..4.Z´¨l.;
Jun  4 17:13:30 localhost kernel: [ 3054.165654]   Object 0xeeb49090:  44 a8 29 af 65 f8 35 ad 76 dd 4a 9f 24 4a dc 18 D¨)¯eø5­vÝJ.$JÜ.
Jun  4 17:13:30 localhost kernel: [ 3054.165676]   Object 0xeeb490a0:  24 4a 1f 12 7a dd 1e 00 90 4c 33 ee 57 6b 20 2e $J..zÝ...L3îWk..
Jun  4 17:13:30 localhost kernel: [ 3054.165698]   Object 0xeeb490b0:  11 13 ff 00 00 00 01 00 00 00 00 00 00 00 00 00 ..ÿ.............
Jun  4 17:13:30 localhost kernel: [ 3054.165720]   Object 0xeeb490c0:  00 00 00 0c 00 00 00 00 00 dd 1a 00 90 4c 34 01 .........Ý...L4.
Jun  4 17:13:30 localhost kernel: [ 3054.165742]   Object 0xeeb490d0:  05 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
Jun  4 17:13:30 localhost kernel: [ 3054.165764]   Object 0xeeb490e0:  00 00 00 00 00 dd 07 00 0c 43 07 00 00 00 43 53 .....Ý...C....CS
Jun  4 17:13:30 localhost kernel: [ 3054.165786]   Object 0xeeb490f0:  4c 2c 2b d2 35 75 16 e6 2c 5f 18 00 5c 01 0a 69 L,+Ò5u.æ,_..\..i
Jun  4 17:13:30 localhost kernel: [ 3054.165808]   Object 0xeeb49100:  00 00 00 00 00 00 00 00 00 00 c9 55 89 90 d3 79 ..........ÉU..Óy
Jun  4 17:13:30 localhost kernel: [ 3054.165830]   Object 0xeeb49110:  96 bd 80 00 00 00 ff ff ff ff ff ff 00 22 75 a7 .½....ÿÿÿÿÿÿ."u§
Jun  4 17:13:30 localhost kernel: [ 3054.165852]   Object 0xeeb49120:  31 e2 00 22 75 a7 31 e2 70 3b 3e a1 df 84 e3 08 1â."u§1âp;>¡ß.ã.
Jun  4 17:13:30 localhost kernel: [ 3054.165874]   Object 0xeeb49130:  00 00 64 00 11 04 00 0a 57 69 2d 46 49 20 44 6f ..d.....Wi-FI.Do
Jun  4 17:13:30 localhost kernel: [ 3054.165896]   Object 0xeeb49140:  6d 61 01 08 82 84 8b 96 12 24 48 6c 03 01 01 32 ma.......$Hl...2
Jun  4 17:13:30 localhost kernel: [ 3054.165918]   Object 0xeeb49150:  04 0c 18 30 60 33 08 20 01 02 03 04 05 06 07 33 ...0`3.........3
Jun  4 17:13:30 localhost kernel: [ 3054.165940]   Object 0xeeb49160:  08 21 05 06 07 08 09 0a 0b dd 27 00 50 f2 04 10 .!.......Ý'.Pò..
Jun  4 17:13:30 localhost kernel: [ 3054.165962]   Object 0xeeb49170:  4a 00 01 10 10 44 00 01 01 10 47 00 10 77 5b 66 J....D....G..w[f
Jun  4 17:13:30 localhost kernel: [ 3054.165984]   Object 0xeeb49180:  80 bf de 11 d3 8d 2f 00 22 75 a7 31 e2 10 3c 00 .¿Þ.Ó./."u§1â.<.
Jun  4 17:13:30 localhost kernel: [ 3054.166006]   Object 0xeeb49190:  01 01 05 04 00 01 00 00 2a 01 04 2d 1a ee 11 13 ........*..-.î..
Jun  4 17:13:30 localhost kernel: [ 3054.166028]   Object 0xeeb491a0:  ff 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 ÿ...............
Jun  4 17:13:30 localhost kernel: [ 3054.166050]   Object 0xeeb491b0:  00 0c 00 00 00 00 00 3d 16 01 05 06 00 00 00 00 .......=........
Jun  4 17:13:30 localhost kernel: [ 3054.166072]   Object 0xeeb491c0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f ................
Jun  4 17:13:30 localhost kernel: [ 3054.166093]   Object 0xeeb491d0:  01 01 dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 ..Ý..Pò....Pò...
Jun  4 17:13:30 localhost kernel: [ 3054.166115]   Object 0xeeb491e0:  00 50 f2 02 00 50 f2 04 01 00 00 50 f2 02 30 18 .Pò..Pò....Pò.0.
Jun  4 17:13:30 localhost kernel: [ 3054.166138]   Object 0xeeb491f0:  01 00 00 0f ac 02 02 00 00 0f ac 02 00 0f ac 04 ....¬.....¬...¬.
Jun  4 17:13:30 localhost kernel: [ 3054.166160]   Object 0xeeb49200:  01 00 00 0f ac 02 00 00 dd 18 00 50 f2 02 01 01 ....¬...Ý..Pò...
Jun  4 17:13:30 localhost kernel: [ 3054.166182]   Object 0xeeb49210:  00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 ...¤..'¤..BC^.b2
Jun  4 17:13:30 localhost kernel: [ 3054.166204]   Object 0xeeb49220:  2f 00 0b 05 01 00 1f 12 7a dd 1e 00 90 4c 33 ee /.......zÝ...L3î
Jun  4 17:13:30 localhost kernel: [ 3054.166226]   Object 0xeeb49230:  11 13 ff 00 00 00 01 00 00 00 6b 6b 6b 6b 6b 6b ..ÿ.......kkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166248]   Object 0xeeb49240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166270]   Object 0xeeb49250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166292]   Object 0xeeb49260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166314]   Object 0xeeb49270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166335]   Object 0xeeb49280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166357]   Object 0xeeb49290:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166380]   Object 0xeeb492a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166402]   Object 0xeeb492b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166424]   Object 0xeeb492c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166445]   Object 0xeeb492d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166467]   Object 0xeeb492e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166489]   Object 0xeeb492f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166511]   Object 0xeeb49300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166533]   Object 0xeeb49310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166555]   Object 0xeeb49320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166577]   Object 0xeeb49330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166599]   Object 0xeeb49340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166621]   Object 0xeeb49350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166643]   Object 0xeeb49360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166665]   Object 0xeeb49370:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166687]   Object 0xeeb49380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166709]   Object 0xeeb49390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166731]   Object 0xeeb493a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166753]   Object 0xeeb493b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166775]   Object 0xeeb493c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166797]   Object 0xeeb493d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166819]   Object 0xeeb493e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166840]   Object 0xeeb493f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166862]   Object 0xeeb49400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166884]   Object 0xeeb49410:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166906]   Object 0xeeb49420:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166928]   Object 0xeeb49430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166950]   Object 0xeeb49440:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166972]   Object 0xeeb49450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.166994]   Object 0xeeb49460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167016]   Object 0xeeb49470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167038]   Object 0xeeb49480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167060]   Object 0xeeb49490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167082]   Object 0xeeb494a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167104]   Object 0xeeb494b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167126]   Object 0xeeb494c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167148]   Object 0xeeb494d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167169]   Object 0xeeb494e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167191]   Object 0xeeb494f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167213]   Object 0xeeb49500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167236]   Object 0xeeb49510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167258]   Object 0xeeb49520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167280]   Object 0xeeb49530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167301]   Object 0xeeb49540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167323]   Object 0xeeb49550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167345]   Object 0xeeb49560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167367]   Object 0xeeb49570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167389]   Object 0xeeb49580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167411]   Object 0xeeb49590:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167433]   Object 0xeeb495a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167455]   Object 0xeeb495b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167477]   Object 0xeeb495c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167499]   Object 0xeeb495d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167521]   Object 0xeeb495e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167543]   Object 0xeeb495f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167565]   Object 0xeeb49600:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167587]   Object 0xeeb49610:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167609]   Object 0xeeb49620:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167631]   Object 0xeeb49630:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167653]   Object 0xeeb49640:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167675]   Object 0xeeb49650:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167697]   Object 0xeeb49660:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167719]   Object 0xeeb49670:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167740]   Object 0xeeb49680:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167762]   Object 0xeeb49690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167784]   Object 0xeeb496a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167806]   Object 0xeeb496b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167828]   Object 0xeeb496c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167850]   Object 0xeeb496d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167872]   Object 0xeeb496e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167894]   Object 0xeeb496f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167916]   Object 0xeeb49700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167938]   Object 0xeeb49710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167960]   Object 0xeeb49720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.167982]   Object 0xeeb49730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168004]   Object 0xeeb49740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168026]   Object 0xeeb49750:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168047]   Object 0xeeb49760:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168069]   Object 0xeeb49770:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168092]   Object 0xeeb49780:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168114]   Object 0xeeb49790:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168136]   Object 0xeeb497a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168158]   Object 0xeeb497b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168179]   Object 0xeeb497c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168201]   Object 0xeeb497d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168223]   Object 0xeeb497e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168245]   Object 0xeeb497f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168267]   Object 0xeeb49800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168289]   Object 0xeeb49810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168311]   Object 0xeeb49820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168333]   Object 0xeeb49830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168355]   Object 0xeeb49840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168377]   Object 0xeeb49850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168399]   Object 0xeeb49860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168421]   Object 0xeeb49870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168443]   Object 0xeeb49880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168465]   Object 0xeeb49890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168487]   Object 0xeeb498a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168509]   Object 0xeeb498b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168531]   Object 0xeeb498c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168552]   Object 0xeeb498d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168574]   Object 0xeeb498e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168596]   Object 0xeeb498f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168618]   Object 0xeeb49900:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168640]   Object 0xeeb49910:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168662]   Object 0xeeb49920:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168684]   Object 0xeeb49930:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168706]   Object 0xeeb49940:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168728]   Object 0xeeb49950:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168750]   Object 0xeeb49960:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168772]   Object 0xeeb49970:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168794]   Object 0xeeb49980:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168816]   Object 0xeeb49990:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168838]   Object 0xeeb499a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168860]   Object 0xeeb499b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168882]   Object 0xeeb499c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168903]   Object 0xeeb499d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168925]   Object 0xeeb499e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168948]   Object 0xeeb499f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168970]   Object 0xeeb49a00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.168992]   Object 0xeeb49a10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169014]   Object 0xeeb49a20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 00 00 kkkkkkkkkkkkkk..
Jun  4 17:13:30 localhost kernel: [ 3054.169036]   Object 0xeeb49a30:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
Jun  4 17:13:30 localhost kernel: [ 3054.169057]   Object 0xeeb49a40:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
Jun  4 17:13:30 localhost kernel: [ 3054.169079]   Object 0xeeb49a50:  00 00 01 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ......kkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169101]   Object 0xeeb49a60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169123]   Object 0xeeb49a70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169145]   Object 0xeeb49a80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169167]   Object 0xeeb49a90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169189]   Object 0xeeb49aa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169211]   Object 0xeeb49ab0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169232]   Object 0xeeb49ac0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169254]   Object 0xeeb49ad0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169276]   Object 0xeeb49ae0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169298]   Object 0xeeb49af0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169320]   Object 0xeeb49b00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169342]   Object 0xeeb49b10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169364]   Object 0xeeb49b20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169386]   Object 0xeeb49b30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169408]   Object 0xeeb49b40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169430]   Object 0xeeb49b50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169452]   Object 0xeeb49b60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169474]   Object 0xeeb49b70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169496]   Object 0xeeb49b80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169518]   Object 0xeeb49b90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169539]   Object 0xeeb49ba0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169561]   Object 0xeeb49bb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169583]   Object 0xeeb49bc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169605]   Object 0xeeb49bd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169627]   Object 0xeeb49be0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169649]   Object 0xeeb49bf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169671]   Object 0xeeb49c00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169693]   Object 0xeeb49c10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169715]   Object 0xeeb49c20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169737]   Object 0xeeb49c30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169759]   Object 0xeeb49c40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169781]   Object 0xeeb49c50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169803]   Object 0xeeb49c60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169825]   Object 0xeeb49c70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169847]   Object 0xeeb49c80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169869]   Object 0xeeb49c90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169891]   Object 0xeeb49ca0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169913]   Object 0xeeb49cb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169935]   Object 0xeeb49cc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169957]   Object 0xeeb49cd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.169979]   Object 0xeeb49ce0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170001]   Object 0xeeb49cf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170023]   Object 0xeeb49d00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170045]   Object 0xeeb49d10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170067]   Object 0xeeb49d20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170089]   Object 0xeeb49d30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170111]   Object 0xeeb49d40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170133]   Object 0xeeb49d50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170155]   Object 0xeeb49d60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170177]   Object 0xeeb49d70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170199]   Object 0xeeb49d80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170221]   Object 0xeeb49d90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170243]   Object 0xeeb49da0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170265]   Object 0xeeb49db0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170287]   Object 0xeeb49dc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170309]   Object 0xeeb49dd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170331]   Object 0xeeb49de0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170352]   Object 0xeeb49df0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170374]   Object 0xeeb49e00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170396]   Object 0xeeb49e10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170418]   Object 0xeeb49e20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170440]   Object 0xeeb49e30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170462]   Object 0xeeb49e40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170484]   Object 0xeeb49e50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170506]   Object 0xeeb49e60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170528]   Object 0xeeb49e70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170550]   Object 0xeeb49e80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170572]   Object 0xeeb49e90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170594]   Object 0xeeb49ea0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170616]   Object 0xeeb49eb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170638]   Object 0xeeb49ec0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170660]   Object 0xeeb49ed0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170682]   Object 0xeeb49ee0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170704]   Object 0xeeb49ef0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170726]   Object 0xeeb49f00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170748]   Object 0xeeb49f10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170770]   Object 0xeeb49f20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170793]   Object 0xeeb49f30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170815]   Object 0xeeb49f40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170837]   Object 0xeeb49f50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170859]   Object 0xeeb49f60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170881]   Object 0xeeb49f70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170903]   Object 0xeeb49f80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170925]   Object 0xeeb49f90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170947]   Object 0xeeb49fa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170969]   Object 0xeeb49fb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.170991]   Object 0xeeb49fc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.171013]   Object 0xeeb49fd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.171035]   Object 0xeeb49fe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.171057]   Object 0xeeb49ff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.171079]   Object 0xeeb4a000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.171101]   Object 0xeeb4a010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Jun  4 17:13:30 localhost kernel: [ 3054.171124]   Object 0xeeb4a020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 cc cc kkkkkkkkkkkkk¥ÌÌ
Jun  4 17:13:30 localhost kernel: [ 3054.171146]  Redzone 0xeeb4a030:  cc cc c0 c0                                     ÌÌÀÀ            
Jun  4 17:13:30 localhost kernel: [ 3054.171166]  Padding 0xeeb4a058:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Jun  4 17:13:30 localhost kernel: [ 3054.171190] Pid: 51, comm: kworker/u:5 Tainted: G        W   3.0.0-rc1+ #111
Jun  4 17:13:30 localhost kernel: [ 3054.171194] Call Trace:
Jun  4 17:13:30 localhost kernel: [ 3054.171205]  [<c04d335f>] print_trailer+0xe2/0xea
Jun  4 17:13:30 localhost kernel: [ 3054.171212]  [<c04d35ba>] check_bytes_and_report+0xa0/0xcc
Jun  4 17:13:30 localhost kernel: [ 3054.171219]  [<c04d3cb9>] check_object+0x48/0x16e
Jun  4 17:13:30 localhost kernel: [ 3054.171225]  [<c04d404f>] free_debug_processing+0x5f/0x16f
Jun  4 17:13:30 localhost kernel: [ 3054.171233]  [<c045fa1f>] ? trace_hardirqs_off_caller+0x2e/0x86
Jun  4 17:13:30 localhost kernel: [ 3054.171240]  [<c04d4480>] __slab_free+0x40/0x106
Jun  4 17:13:30 localhost kernel: [ 3054.171248]  [<c06f1ffd>] ? skb_release_data+0x7c/0x80
Jun  4 17:13:30 localhost kernel: [ 3054.171257]  [<c05b8f54>] ? debug_check_no_obj_freed+0x11/0x15
Jun  4 17:13:30 localhost kernel: [ 3054.171263]  [<c04d4619>] kfree+0xd3/0xdc
Jun  4 17:13:30 localhost kernel: [ 3054.171268]  [<c06f1ffd>] ? skb_release_data+0x7c/0x80
Jun  4 17:13:30 localhost kernel: [ 3054.171274]  [<c0462536>] ? lock_acquire+0xac/0xb7
Jun  4 17:13:30 localhost kernel: [ 3054.171281]  [<c06f1ffd>] ? skb_release_data+0x7c/0x80
Jun  4 17:13:30 localhost kernel: [ 3054.171287]  [<c06f1ffd>] skb_release_data+0x7c/0x80
Jun  4 17:13:30 localhost kernel: [ 3054.171293]  [<c06f221b>] __kfree_skb+0x17/0x74
Jun  4 17:13:30 localhost kernel: [ 3054.171299]  [<c06f22cb>] consume_skb+0x53/0x57
Jun  4 17:13:30 localhost kernel: [ 3054.171328]  [<f832bdb5>] ieee80211_rx+0x680/0x696 [mac80211]
Jun  4 17:13:30 localhost kernel: [ 3054.171335]  [<c06f0a6a>] ? __alloc_skb+0x75/0x100
Jun  4 17:13:30 localhost kernel: [ 3054.171342]  [<c0432f92>] ? get_parent_ip+0xb/0x31
Jun  4 17:13:30 localhost kernel: [ 3054.171348]  [<c043de47>] ? __local_bh_disable+0x83/0x88
Jun  4 17:13:30 localhost kernel: [ 3054.171359]  [<f835c90b>] rt2x00lib_rxdone+0x34e/0x392 [rt2x00lib]
Jun  4 17:13:30 localhost kernel: [ 3054.171368]  [<f8d381e5>] rt2x00usb_work_rxdone+0x57/0x7f [rt2x00usb]
Jun  4 17:13:30 localhost kernel: [ 3054.171376]  [<c044c43e>] process_one_work+0x1a6/0x2c8
Jun  4 17:13:30 localhost kernel: [ 3054.171382]  [<f8d3818e>] ? rt2x00usb_work_txdone+0x7a/0x7a [rt2x00usb]
Jun  4 17:13:30 localhost kernel: [ 3054.171389]  [<c044d547>] worker_thread+0xd3/0x14e
Jun  4 17:13:30 localhost kernel: [ 3054.171395]  [<c044d474>] ? manage_workers.clone.11+0x14f/0x14f
Jun  4 17:13:30 localhost kernel: [ 3054.171401]  [<c045048a>] kthread+0x72/0x77
Jun  4 17:13:30 localhost kernel: [ 3054.171408]  [<c0450418>] ? __init_kthread_worker+0x47/0x47
Jun  4 17:13:30 localhost kernel: [ 3054.171416]  [<c0761a42>] kernel_thread_helper+0x6/0x10
Jun  4 17:13:30 localhost kernel: [ 3054.171421] FIX kmalloc-4096: Restoring 0xeeb4a032-0xeeb4a033=0xcc
