Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:24094 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752069Ab0JHH5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 03:57:19 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0164794634
	for <linux-wireless@vger.kernel.org>; Fri,  8 Oct 2010 16:57:17 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] Race condition in CRDA calls?
Date: Fri, 8 Oct 2010 16:57:17 +0900
Cc: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <201003251801.57951.8an@praha12.net> <201006171347.58712.br1@einfach.org> <AANLkTik7ckoex4pP1IkY0Vx1j-S4k0WVV62h7Sn4uGCx@mail.gmail.com>
In-Reply-To: <AANLkTik7ckoex4pP1IkY0Vx1j-S4k0WVV62h7Sn4uGCx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010081657.17326.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello!

sorry to revive an old thread, but i finally found the time to continue on 
this. i can reproduce the regdomain intersection problem fairly regularly now. 
it happens on slow boards (soekris net4826), with more than one ath5k card, 
especially under high load. unfortunately this seems to be the case when 
OpenWRT loads, but i can also trigger it by bombarding it with traffic (iperf 
UDP) on the ethernet device, so the IRQ and SIRQ loads together are around 
50%.

On Thu June 17 2010 14:05:32 Luis R. Rodriguez wrote:
> I provided verbose instructions what can be done to further debug this.

the following output mixes kernel log output on the serial and iw event. it's 
a little messed up (lines cut) but i think you can see what's going on:

root@RMR1:/# config.sh reload kernel; iw event -t &

(the config.sh schript only reloads the mac80211, cfg80211 and ath module)

cfg80211: Calling CRDA to update world regulatory domain
root@RMR1:/# cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
1284335098.343222: phy #0: regulatory domain change: set to world roaming by 
the wireless core upon initiat

root@RMR1:/# insmod /lib/modules/2.6.32.10/ath5k.ko

ath5k 0000:00:0e.0: registered as 'phy0'
ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
ath5k 0000:00:0f.0: registered as 'phy1'
cfg80211: Calling CRDA for country: JP
ath5k phy1: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
cfg80211: Calling CRDA for country: JP
root@RMR1:/# cfg80211: Current regulatory domain intersected:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (2457000 KHz - 2472000 KHz @ 15000 KHz), (N/A, 2000 mBm)
    (2457000 KHz - 2472000 KHz @ 15000 KHz), (N/A, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
    (2474000 KHz - 2482000 KHz @ 8000 KHz), (N/A, 2000 mBm)
    (2474000 KHz - 2482000 KHz @ 8000 KHz), (N/A, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
1284335110.273907: phy #1: regulatory domain change: intersection used due to 
a request made by a driver o1
cfg80211: Current regulatory domain intersected:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (2457000 KHz - 2472000 KHz @ 15000 KHz), (N/A, 2000 mBm)
    (2457000 KHz - 2472000 KHz @ 15000 KHz), (N/A, 2000 mBm)
    (2457000 KHz - 2472000 KHz @ 15000 KHz), (N/A, 2000 mBm)
    (2457000 KHz - 2472000 KHz @ 15000 KHz), (N/A, 2000 mBm)
    (2457000 KHz - 2472000 KHz @ 15000 KHz), (N/A, 2000 mBm)
    (2457000 KHz - 2472000 KHz @ 15000 KHz), (N/A, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
    (2474000 KHz - 2482000 KHz @ 8000 KHz), (N/A, 2000 mBm)
    (2474000 KHz - 2482000 KHz @ 8000 KHz), (N/A, 2000 mBm)
    (2474000 KHz - 2482000 KHz @ 8000 KHz), (N/A, 2000 mBm)
    (2474000 KHz - 2482000 KHz @ 8000 KHz), (N/A, 2000 mBm)
    (2474000 KHz - 2482000 KHz @ 8000 KHz), (N/A, 2000 mBm)
    (2474000 KHz - 2482000 KHz @ 8000 KHz), (N/A, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
1284335114.847761: phy #1: regulatory domain change: intersection used due to 
a request made by a driver o

here again, the output of iw event on a proper console:

root@RMR1:~# 1284335259.046129: phy #1: regulatory domain change: intersection 
used due to a request made by a driver on phy1
1284335263.403515: phy #1: regulatory domain change: intersection used due to 
a request made by a driver on phy1

interesting that phy #1 appears twice...

if there is no intersection problem it looks like this:

1284334386.775218: phy #0: regulatory domain change: set to JP by a driver 
request on phy0
1284334387.020971: phy #1: regulatory domain change: set to JP by a driver 
request on phy1

btw: udev is not in use.

any ideas how to further debug this?

bruno
