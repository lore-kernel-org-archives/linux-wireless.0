Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52196 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2EBQvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 12:51:22 -0400
Received: by vcqp1 with SMTP id p1so601282vcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2012 09:51:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABF+-6XbdG_QMa0iQJMpbOsr4bXCq4mDEB6unkM8jxNGWYwFyQ@mail.gmail.com>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
	<CABF+-6XbdG_QMa0iQJMpbOsr4bXCq4mDEB6unkM8jxNGWYwFyQ@mail.gmail.com>
Date: Wed, 2 May 2012 12:51:21 -0400
Message-ID: <CABF+-6VkbgDyeH-3tg0Y4RtbwE=cqSy47TB0pLeJ6=V17OpWqg@mail.gmail.com> (sfid-20120502_185126_341771_78627CFC)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Kevin Groeneveld <kgroeneveld@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

Thanks for the response.

> Could you enable following options and send kernel log:
> CW1200_DEBUGFS=y
> CW1200_WSM_DEBUG=y
> CW1200_WSM_DUMPS=y
> CW1200_BH_DEBUG=y

I already had these options on.  The following is the debugfs status
after attempting a scan:

CW1200 Wireless LAN driver status
Hardware:   5.5
Firmware:   WSM 3020.380
FW API:     1042
FW caps:    0x000B
Mode:       station
Assoc:      passive
Channel:    1
EDCA(0):    7, 15, 2, 3264, 200
EDCA(1):    15, 31, 2, 6016, 200
EDCA(2):    31, 1023, 3, 0, 200
EDCA(3):    31, 1023, 7, 0, 200
HT:         off
RSSI thold: 0
RSSI hyst:  0
TXFL thold: 0
Linkloss:   60
Bcnloss:    20
Long retr:  4
Short retr: 7
RC in use:  0
BA stat:    0, 0 (0)
Block ACK:  off

Queue       0:
 capacity: 16
 queued:   0
 pending:  0
 sent:     0
 locked:   no
 overfull: no
 link map: 0-> 00 00 00 00 00 00 00 00 <-8

Queue       1:
 capacity: 16
 queued:   0
 pending:  0
 sent:     0
 locked:   no
 overfull: no
 link map: 0-> 00 00 00 00 00 00 00 00 <-8

Queue       2:
 capacity: 16
 queued:   0
 pending:  0
 sent:     0
 locked:   no
 overfull: no
 link map: 0-> 00 00 00 00 00 00 00 00 <-8

Queue       3:
 capacity: 16
 queued:   0
 pending:  0
 sent:     0
 locked:   no
 overfull: no
 link map: 0-> 00 00 00 00 00 00 00 00 <-8

Link map:   0-> .. .. .. .. .. .. .. .. <-7
Asleep map: 0-> .. .. .. .. .. .. .. .. <-7
PSPOLL map: 0-> .. .. .. .. .. .. .. .. <-7


BH status:  alive
Pending RX: 0
Pending TX: 0
TX bufs:    8 x 1632 bytes
Used bufs:  0
Powermgmt:  on
Device:     alseep
WSM status: idle
WSM cmd:    0xFFFF (9 bytes)
WSM retval: 0
Datapath:   unlocked
TXed:       0
AGG TXed:   0
MULTI TXed: 0 (0)
RXed:       0
AGG RXed:   0
TX miss:    0
TX align:   0
TX burst:   0
RX burst:   0
TX TTL:     0
Scan:       idle
Led state:  0x00


The following is from the kernel log:

[    8.101627] Compat-wireless backport release: compat-wireless-2012-04-24-1
[    8.108519] Backport based on linux-next.git next-20120424
[    8.192370] cfg80211: Calling CRDA to update world regulatory domain
[    8.215057] cfg80211: World regulatory domain updated:
[    8.220311] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    8.236156] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    8.245162] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[    8.254101] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[    8.271167] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    8.278927] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   80.672423] Probe called
[   80.674493] [BH] register.
[   80.731090] WLAN device is ready.
[   80.731108] Cut 2.x silicon is detected.
[   80.731533] Cut 2.2 detected.
[   80.731580] cw1200_load_firmware: CW1200 detected.
[   80.816222] Firmware download completed.
[   80.816289] SW IRQ subscribe
[   80.821093] [BH] irq.
[   80.821140] [BH] irq.
[   80.821177] [BH] irq.
[   80.821212] [BH] irq.
[   80.821246] [BH] irq.
[   80.821375] [WSM] <<< 0x0801 (168)
[   80.821398] CW1200 WSM init done.
[   80.821402]    Input buffers: 8 x 1632 bytes
[   80.821407]    Hardware: 5.5
[   80.821411]    WSM firmware [WSM_A30.02.0380_PTA4W Feb 17 2012
10:43:10], ver: 3020, build: 380, api: 1042, cap: 0x000B
[   80.848338] [WSM] >>> 0x0006 [MIB: 0x1006] (9)
[   80.848348] [BH] wakeup.
[   80.848502] [BH] irq.
[   80.848536] [BH] irq.
[   80.848570] [BH] irq.
[   80.848692] [WSM] <<< 0x0406 (8)
[   80.848701] [BH] Powerave is enabled.
[   80.848793] [WSM] >>> 0x0006 [MIB: 0x1024] (12)
[   80.848801] [BH] wakeup.
[   80.848942] [BH] irq.
[   80.848975] [BH] irq.
[   80.849095] [WSM] <<< 0x0406 (8)
[   80.859122] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   80.861178] is registered as 'phy0'
[   81.841078] [BH] Device wakedown.
[  123.215695] [WSM] >>> 0x0013 (48)
[  123.215711] [BH] wakeup.
[  123.215758] [BH] Device wakeup.
[  123.233368] [BH] irq.
[  123.233418] [BH] irq.
[  123.233456] [BH] irq.
[  123.233490] [BH] irq.
[  123.233537] [BH] Device wakeup.
[  123.233597] [BH] Device awake.
[  123.233794] [WSM] <<< 0x0413 (8)
[  123.233887] [WSM] >>> 0x0006 [MIB: 0x1013] (16)
[  123.233896] [BH] wakeup.
[  123.234042] [BH] irq.
[  123.234075] [BH] irq.
[  123.234109] [BH] irq.
[  123.234142] [BH] irq.
[  123.234264] [WSM] <<< 0x0406 (8)
[  123.254241] [WSM] >>> 0x0009 (840)
[  123.254257] [BH] wakeup.
[  123.254590] [BH] irq.
[  123.254630] [BH] irq.
[  123.254667] [BH] irq.
[  123.254703] [BH] irq.
[  123.254738] [BH] irq.
[  123.254872] [WSM] <<< 0x0409 (44)
[  123.254947] [WSM] >>> 0x0006 [MIB: 0x1009] (12)
[  123.254956] [BH] wakeup.
[  123.255109] [BH] irq.
[  123.255144] [BH] irq.
[  123.255180] [BH] irq.
[  123.255314] [WSM] <<< 0x0406 (8)
[  123.255385] [WSM] >>> 0x0006 [MIB: 0x1009] (12)
[  123.255394] [BH] wakeup.
[  123.255545] [BH] irq.
[  123.255579] [BH] irq.
[  123.255616] [BH] irq.
[  123.255743] [WSM] <<< 0x0406 (8)
[  123.255816] [WSM] >>> 0x0006 [MIB: 0x0003] (12)
[  123.255824] [BH] wakeup.
[  123.255975] [BH] irq.
[  123.256008] [BH] irq.
[  123.256045] [BH] irq.
[  123.256080] [BH] irq.
[  123.256208] [WSM] <<< 0x0406 (8)
[  123.256284] [WSM] >>> 0x0012 (16)
[  123.256292] [BH] wakeup.
[  123.256460] [BH] irq.
[  123.256494] [BH] irq.
[  123.256617] [WSM] <<< 0x0412 (8)
[  123.256683] [WSM] >>> 0x0013 (48)
[  123.256690] [BH] wakeup.
[  123.256855] [BH] irq.
[  123.256890] [BH] irq.
[  123.257017] [WSM] <<< 0x0413 (8)
[  123.257080] [WSM] >>> 0x0006 [MIB: 0x1013] (16)
[  123.257087] [BH] wakeup.
[  123.257271] [BH] irq.
[  123.257307] [BH] irq.
[  123.257346] [BH] irq.
[  123.257470] [WSM] <<< 0x0406 (8)
[  123.257533] [WSM] >>> 0x0012 (16)
[  123.257539] [BH] wakeup.
[  123.257687] [BH] irq.
[  123.257722] [BH] irq.
[  123.258940] [WSM] <<< 0x0412 (8)
[  123.259080] [WSM] >>> 0x0013 (48)
[  123.259088] [BH] wakeup.
[  123.259272] [BH] irq.
[  123.259307] [BH] irq.
[  123.259438] [WSM] <<< 0x0413 (8)
[  123.259477] [WSM] >>> 0x0006 [MIB: 0x1013] (16)
[  123.259485] [BH] wakeup.
[  123.259637] [BH] irq.
[  123.259671] [BH] irq.
[  123.259706] [BH] irq.
[  123.259740] [BH] irq.
[  123.259866] [WSM] <<< 0x0406 (8)
[  123.259905] [WSM] >>> 0x0012 (16)
[  123.259912] [BH] wakeup.
[  123.260058] [BH] irq.
[  123.260092] [BH] irq.
[  123.260127] [BH] irq.
[  123.260161] [BH] irq.
[  123.260195] [BH] irq.
[  123.260321] [WSM] <<< 0x0412 (8)
[  123.260356] [WSM] >>> 0x0013 (48)
[  123.260363] [BH] wakeup.
[  123.260508] [BH] irq.
[  123.260542] [BH] irq.
[  123.260667] [WSM] <<< 0x0413 (8)
[  123.260703] [WSM] >>> 0x0006 [MIB: 0x1013] (16)
[  123.260711] [BH] wakeup.
[  123.260860] [BH] irq.
[  123.260894] [BH] irq.
[  123.260929] [BH] irq.
[  123.260963] [BH] irq.
[  123.261125] [WSM] <<< 0x0406 (8)
[  123.261164] [WSM] >>> 0x0012 (16)
[  123.261171] [BH] wakeup.
[  123.261321] [BH] irq.
[  123.261355] [BH] irq.
[  123.261390] [BH] irq.
[  123.261519] [WSM] <<< 0x0412 (8)
[  123.261555] [WSM] >>> 0x0013 (48)
[  123.261562] [BH] wakeup.
[  123.261710] [BH] irq.
[  123.261743] [BH] irq.
[  123.261778] [BH] irq.
[  123.261905] [WSM] <<< 0x0413 (8)
[  123.261941] [WSM] >>> 0x0006 [MIB: 0x1013] (16)
[  123.261950] [BH] wakeup.
[  123.262099] [BH] irq.
[  123.262133] [BH] irq.
[  123.262256] [WSM] <<< 0x0406 (8)
[  123.262303] [WSM] TX is locked.
[  123.262312] [BH] wakeup.
[  123.262319] [WSM] TX is unlocked.
[  123.262332] [WSM] >>> 0x0006 [MIB: 0x0006] (12)
[  123.262339] [BH] wakeup.
[  123.262495] [BH] irq.
[  123.262529] [BH] irq.
[  123.262658] [WSM] <<< 0x0406 (8)
[  123.262691] [WSM] TX is locked.
[  123.262702] [WSM] >>> 0x0016 (8)
[  123.262708] [BH] wakeup.
[  123.262874] [BH] irq.
[  123.262909] [BH] irq.
[  123.263039] [WSM] <<< 0x0416 (8)
[  123.284588] [BH] irq.
[  123.284640] [BH] irq.
[  123.284783] [WSM] <<< 0x080A (8)
[  123.284796] [BH] wakeup.
[  123.284803] [WSM] TX is unlocked.
[  123.284836] [WSM] TX is locked.
[  123.284851] [WSM] >>> 0x0006 [MIB: 0x1006] (9)
[  123.284858] [BH] wakeup.
[  123.285007] [BH] irq.
[  123.285040] [BH] irq.
[  123.285161] [WSM] <<< 0x0406 (8)
[  123.285173] [BH] Powerave is enabled.
[  123.285201] [BH] wakeup.
[  123.285207] [WSM] TX is unlocked.
[  124.281096] [BH] Device wakedown.
[  153.599285] [WSM] TX is locked.
[  153.599309] [WSM] >>> 0x0006 [MIB: 0x1006] (9)
[  153.599319] [BH] wakeup.
[  153.599367] [BH] Device wakeup.
[  153.607490] [BH] irq.
[  153.607539] [BH] irq.
[  153.607575] [BH] irq.
[  153.607609] [BH] irq.
[  153.607642] [BH] irq.
[  153.607691] [BH] Device wakeup.
[  153.607749] [BH] Device awake.
[  153.607945] [WSM] <<< 0x0406 (8)
[  153.607957] [BH] Powerave is enabled.
[  153.608030] [BH] wakeup.
[  153.608059] [WSM] TX is unlocked.
[  153.608109] [WSM] >>> 0x0006 [MIB: 0x1002] (82)
[  153.608116] [BH] wakeup.
[  153.608255] [BH] irq.
[  153.608288] [BH] irq.
[  153.608408] [WSM] <<< 0x0406 (8)
[  153.608499] [WSM] >>> 0x0006 [MIB: 0x1002] (82)
[  153.608507] [BH] wakeup.
[  153.608649] [BH] irq.
[  153.608681] [BH] irq.
[  153.608715] [BH] irq.
[  153.608835] [WSM] <<< 0x0406 (8)
[  153.608925] [WSM] TX is locked.
[  153.608963] [WSM] >>> 0x0007 (192)
[  153.608970] [BH] wakeup.
[  153.609203] [BH] irq.
[  153.609240] [BH] irq.
[  153.609369] [WSM] <<< 0x0407 (8)
[  154.557453] [BH] irq.
[  154.557501] [BH] irq.
[  154.557638] [WSM] <<< 0x0806 (12)
[  154.557688] [WSM] >>> 0x0007 (64)
[  154.557696] [BH] wakeup.
[  154.557935] [BH] irq.
[  154.557970] [BH] irq.
[  154.558098] [WSM] <<< 0x0407 (8)
[  154.831678] [BH] irq.
[  154.831714] [BH] irq.
[  154.831842] [WSM] <<< 0x0806 (12)
[  154.831873] [BH] wakeup.
[  154.831880] [WSM] TX is unlocked.
[  154.831925] [WSM] TX is locked.
[  154.831934] [BH] wakeup.
[  154.831939] [WSM] TX is unlocked.
[  154.831948] [WSM] TX is locked.
[  154.831957] [WSM] >>> 0x0006 [MIB: 0x1006] (9)
[  154.831964] [BH] wakeup.
[  154.832172] [BH] irq.
[  154.832208] [BH] irq.
[  154.832334] [WSM] <<< 0x0406 (8)
[  154.832345] [BH] Powerave is enabled.
[  154.832378] [BH] wakeup.
[  154.832385] [WSM] TX is unlocked.
[  155.831063] [BH] Device wakedown.
[  217.456101] [WSM] >>> 0x0005 (8)
[  217.456118] [BH] wakeup.
[  217.456166] [BH] Device wakeup.
[  217.464294] [BH] irq.
[  217.464343] [BH] irq.
[  217.464379] [BH] irq.
[  217.464413] [BH] irq.
[  217.464446] [BH] irq.
[  217.464496] [BH] Device wakeup.
[  217.464555] [BH] Device awake.
[  217.464750] [WSM] <<< 0x0405 (104)
[  218.461064] [BH] Device wakedown.

I ran "ifconfig wlan0 up" at about time stamp 123 and "iw wlan0 scan"
at about 153.

As you can see in the log I am compiling the driver patched into
compat-wireless-2012-04-24.  I am using a kernel based on 2.6.35.3.
Maybe this is a bad combination or not even a valid way of doing
things.  I don't have much experience with wireless drivers in Linux.

Thanks,

Kevin
