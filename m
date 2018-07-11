Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:35288 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbeGKSI3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 14:08:29 -0400
Received: by mail-qk0-f174.google.com with SMTP id u21-v6so14132204qku.2
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2018 11:03:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180711122947.GA5309@redhat.com>
References: <CAFED-jkby2sk9OQnuH5PD8isr0n_CM6Eufs7Ds5fhavYfYdLBw@mail.gmail.com>
 <20180622144809.GA9773@redhat.com> <CAFED-jkt6yoRjvAAJNs2Ob5Rq53s7qa1Ydpy-G2A7gkLDT7V2Q@mail.gmail.com>
 <20180711122947.GA5309@redhat.com>
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Date: Wed, 11 Jul 2018 20:02:59 +0200
Message-ID: <CAFED-jnbu_v-z4QVw1YEgof_9BS2eJudyMkevxqN3Jza6jkSeQ@mail.gmail.com> (sfid-20180711_200304_148869_80AB4ABF)
Subject: Re: mt76x2e MCU message 31 timed out
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2018-07-11 14:29 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
> (correct Felix email address)
>
> On Fri, Jun 22, 2018 at 05:51:53PM +0200, Janusz Dziedzic wrote:
>> 2018-06-22 16:48 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
>> > Hi
>> >
>> > On Fri, Jun 22, 2018 at 10:37:35AM +0200, Janusz Dziedzic wrote:
>> >> Have this card in my laptop:
>> >> 02:00.0 Network controller: MEDIATEK Corp. Device 7612
>> >>
>> >> [    8.478104] mt76x2e 0000:02:00.0: ASIC revision: 76120044
>> >> [    8.489582] mt76x2e 0000:02:00.0: ROM patch already applied
>> >> [    8.833476] mt76x2e 0000:02:00.0: Firmware Version: 0.0.00
>> >> [    8.833477] mt76x2e 0000:02:00.0: Build: 1
>> >> [    8.833479] mt76x2e 0000:02:00.0: Build Time: 201507311614____
>> >> [    8.856115] mt76x2e 0000:02:00.0: Firmware running!
>> >> [    9.558075] mt76x2e 0000:02:00.0 wlp2s0: renamed from wlan1
>> >
>> > I'm just curious. Does the card was installed in the laptop by default?
>> > If so what is the model of the laptop?
>> >
>> No, I just buy this card on aliexpress and put into some dell (MTK
>> MT7612 2x2 half miniPCIE).
>>
>> >> Linux test4 4.17.0-rc7+ #5 SMP Mon May 28 12:35:22 CEST 2018 x86_64 GNU/Linux
>> >>
>> >> Seems iw scan works correctly and first assoc. After will run some
>> >> traffic (iperf in such case) get:
>> >>
>> >> [  432.372081] wlp2s0: associate with 52:b4:f7:f0:16:c2 (try 2/3)
>> >> [  432.375255] wlp2s0: RX AssocResp from 52:b4:f7:f0:16:c2
>> >> (capab=0x511 status=0 aid=2)
>> >> [  432.375336] wlp2s0: associated
>> >> [  432.451097] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
>> >> [  522.562157] mt76x2e 0000:02:00.0: MCU message 31 (seq 13) timed out
>> >> [  524.610281] mt76x2e 0000:02:00.0: MCU message 31 (seq 14) timed out
>> >> [  526.658384] mt76x2e 0000:02:00.0: MCU message 31 (seq 15) timed out
>> >> [  528.258455] mt76x2e 0000:02:00.0: MCU message 30 (seq 1) timed out
>> >> [  529.282499] mt76x2e 0000:02:00.0: MCU message 30 (seq 2) timed out
>> >> [  530.402544] mt76x2e 0000:02:00.0: MCU message 30 (seq 3) timed out
>> >> [  531.426587] mt76x2e 0000:02:00.0: MCU message 30 (seq 4) timed out
>> >> [  531.427444] wlp2s0: authenticate with 52:b4:f7:f0:14:ac
>> >> [  532.450624] mt76x2e 0000:02:00.0: MCU message 30 (seq 5) timed out
>> >> [  533.474666] mt76x2e 0000:02:00.0: MCU message 30 (seq 6) timed out
>> >> [  534.498709] mt76x2e 0000:02:00.0: MCU message 30 (seq 7) timed out
>> >> [  535.522736] mt76x2e 0000:02:00.0: MCU message 30 (seq 8) timed out
>> >> [  535.522807] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 1/3)
>> >> [  535.726740] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 2/3)
>> >> [  535.930742] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 3/3)
>> >> [  536.134747] wlp2s0: authentication with 52:b4:f7:f0:14:ac timed out
>> >
>> > I observed quite similar issue on some rt2800 devices when
>> > I applied  this patch:
>> > https://github.com/sgruszka/wireless-drivers-next/commit/846d205edd8c36d1b7828fee54bf4cf40bf8cb1a
>> > It works on some devices and does not work on others with similar
>> > symptoms - correctly associate but stop to work as soon as some
>> > data traffic is performed.
>> >
>> > So, I would check if send IEEE80211_TX_CTL_RATE_CTRL_PROBE frames
>> > with qsel = MT_QSEL_EDCA would help.
>> >
>> Thanks, will check this.
>
> I guess it does not help? You can check attached patch instead
> (note I only compile tested it).
>
Sure, result below:

root@test4:~# uname -a
Linux test4 4.18.0-rc4+ #7 SMP Wed Jul 11 15:43:36 CEST 2018 x86_64 GNU/Linux

root@test4:~# lspci |grep MEDIA
02:00.0 Network controller: MEDIATEK Corp. Device 7612

test@test4:~$ iperf -s -i2
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.114 port 5001 connected with 192.168.1.103 port 51156
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0- 2.0 sec  3.21 MBytes  13.5 Mbits/sec
[  4]  2.0- 4.0 sec  0.00 Bytes  0.00 bits/sec
[  4]  4.0- 6.0 sec  0.00 Bytes  0.00 bits/sec
[  4]  6.0- 8.0 sec  0.00 Bytes  0.00 bits/sec
[  4]  8.0-10.0 sec  0.00 Bytes  0.00 bits/sec
...

root@test4:~# modprobe -r mt76x2e
root@test4:~# modprobe mt76x2e
root@test4:~# ifconfig wlp2s0 up
SIOCSIFFLAGS: Connection timed out

[ 1222.427751] wlp2s0: associated
[ 1222.530438] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
[ 1570.177690] wlp2s0: deauthenticating from e2:b4:f7:00:17:4e by
local choice (Reason: 3=DEAUTH_LEAVING)
[ 1586.686971] mt76x2e 0000:02:00.0: ASIC revision: 76120044
[ 1586.699224] mt76x2e 0000:02:00.0: ROM patch build: 20141115060606a
[ 1586.700652] mt76x2e 0000:02:00.0: Firmware Version: 0.0.00
[ 1586.700653] mt76x2e 0000:02:00.0: Build: 1
[ 1586.700655] mt76x2e 0000:02:00.0: Build Time: 201507311614____
[ 1586.721801] mt76x2e 0000:02:00.0: Firmware running!
[ 1587.737844] mt76x2e 0000:02:00.0: MCU message 1 (seq 1) timed out
[ 1587.738317] ieee80211 phy2: Selected rate control algorithm 'minstrel_ht'
[ 1587.741315] mt76x2e 0000:02:00.0 wlp2s0: renamed from wlan0
[ 1609.113782] mt76x2e 0000:02:00.0: MCU message 20 (seq 2) timed out
[ 1627.609749] mt76x2e 0000:02:00.0: MCU message 20 (seq 3) timed out
[ 1716.985370] mt76x2e 0000:02:00.0: MCU message 20 (seq 4) timed out


root@test4:~# modprobe -r mt76x2e
root@test4:~# modprobe  mt76x2e
root@test4:~# ifconfig wlp2s0 up
root@test4:~#

Seems when data stall (iperf) and next reload driver, works much
better - 1st or 2nd try for ifconfig up works correctly. So, for sure
patch improve hw (re)start.

Regarding iperf - as before :)

BR
Janusz

> Regards
> Stanislaw
>>
>> > Another thing to try is checkout vendor driver and see if there is need
>> > to add extra code if device is_mt7612() .
>> >
>> > Regards
>> > Stanislaw
>>
>>
>>
>> --
>> Janusz Dziedzic



-- 
Janusz Dziedzic
