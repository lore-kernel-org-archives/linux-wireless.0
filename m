Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:36823 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751578AbeFWUhX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Jun 2018 16:37:23 -0400
Received: by mail-qt0-f169.google.com with SMTP id o9-v6so8916843qtp.3
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jun 2018 13:37:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKR_QV+c-z_A+8Miikd-zMhShkFT_8UMuZ-wmVRaQ=2C7yb5TA@mail.gmail.com>
References: <CAFED-jkby2sk9OQnuH5PD8isr0n_CM6Eufs7Ds5fhavYfYdLBw@mail.gmail.com>
 <20180622144809.GA9773@redhat.com> <CAFED-jkt6yoRjvAAJNs2Ob5Rq53s7qa1Ydpy-G2A7gkLDT7V2Q@mail.gmail.com>
 <CAKR_QV+c-z_A+8Miikd-zMhShkFT_8UMuZ-wmVRaQ=2C7yb5TA@mail.gmail.com>
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Date: Sat, 23 Jun 2018 22:37:21 +0200
Message-ID: <CAFED-jkYzG7dd-f5kHzWrb=kViFsjUcW54sPW0z3rmnqQb4vQA@mail.gmail.com> (sfid-20180623_223735_544689_99D015A0)
Subject: Re: mt76x2e MCU message 31 timed out
To: Tom Psyborg <pozega.tomislav@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2018-06-23 19:33 GMT+02:00 Tom Psyborg <pozega.tomislav@gmail.com>:
> Do they sell dual-band version with ext amplifiers? I saw there is
> 5GHz version with 25dBm power modification...
>
Dual band is half version with lower power.

I also have full one with higher power - but works only in router
MT7621 (2xMIPS with HT - so, 4 cores - 880MHz).
My laptop PCI don't see this cards (some quirks probably for PCIE required?).

BTW, ath9k pcie works fine in MT7621 while ath10k not :)

Seems PCIE standard is "not the same" :)

BR
Janusz

> On 22/06/2018, Janusz Dziedzic <janusz.dziedzic@gmail.com> wrote:
>> 2018-06-22 16:48 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
>>> Hi
>>>
>>> On Fri, Jun 22, 2018 at 10:37:35AM +0200, Janusz Dziedzic wrote:
>>>> Have this card in my laptop:
>>>> 02:00.0 Network controller: MEDIATEK Corp. Device 7612
>>>>
>>>> [    8.478104] mt76x2e 0000:02:00.0: ASIC revision: 76120044
>>>> [    8.489582] mt76x2e 0000:02:00.0: ROM patch already applied
>>>> [    8.833476] mt76x2e 0000:02:00.0: Firmware Version: 0.0.00
>>>> [    8.833477] mt76x2e 0000:02:00.0: Build: 1
>>>> [    8.833479] mt76x2e 0000:02:00.0: Build Time: 201507311614____
>>>> [    8.856115] mt76x2e 0000:02:00.0: Firmware running!
>>>> [    9.558075] mt76x2e 0000:02:00.0 wlp2s0: renamed from wlan1
>>>
>>> I'm just curious. Does the card was installed in the laptop by default?
>>> If so what is the model of the laptop?
>>>
>> No, I just buy this card on aliexpress and put into some dell (MTK
>> MT7612 2x2 half miniPCIE).
>>
>>>> Linux test4 4.17.0-rc7+ #5 SMP Mon May 28 12:35:22 CEST 2018 x86_64
>>>> GNU/Linux
>>>>
>>>> Seems iw scan works correctly and first assoc. After will run some
>>>> traffic (iperf in such case) get:
>>>>
>>>> [  432.372081] wlp2s0: associate with 52:b4:f7:f0:16:c2 (try 2/3)
>>>> [  432.375255] wlp2s0: RX AssocResp from 52:b4:f7:f0:16:c2
>>>> (capab=0x511 status=0 aid=2)
>>>> [  432.375336] wlp2s0: associated
>>>> [  432.451097] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
>>>> [  522.562157] mt76x2e 0000:02:00.0: MCU message 31 (seq 13) timed out
>>>> [  524.610281] mt76x2e 0000:02:00.0: MCU message 31 (seq 14) timed out
>>>> [  526.658384] mt76x2e 0000:02:00.0: MCU message 31 (seq 15) timed out
>>>> [  528.258455] mt76x2e 0000:02:00.0: MCU message 30 (seq 1) timed out
>>>> [  529.282499] mt76x2e 0000:02:00.0: MCU message 30 (seq 2) timed out
>>>> [  530.402544] mt76x2e 0000:02:00.0: MCU message 30 (seq 3) timed out
>>>> [  531.426587] mt76x2e 0000:02:00.0: MCU message 30 (seq 4) timed out
>>>> [  531.427444] wlp2s0: authenticate with 52:b4:f7:f0:14:ac
>>>> [  532.450624] mt76x2e 0000:02:00.0: MCU message 30 (seq 5) timed out
>>>> [  533.474666] mt76x2e 0000:02:00.0: MCU message 30 (seq 6) timed out
>>>> [  534.498709] mt76x2e 0000:02:00.0: MCU message 30 (seq 7) timed out
>>>> [  535.522736] mt76x2e 0000:02:00.0: MCU message 30 (seq 8) timed out
>>>> [  535.522807] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 1/3)
>>>> [  535.726740] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 2/3)
>>>> [  535.930742] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 3/3)
>>>> [  536.134747] wlp2s0: authentication with 52:b4:f7:f0:14:ac timed out
>>>
>>> I observed quite similar issue on some rt2800 devices when
>>> I applied  this patch:
>>> https://github.com/sgruszka/wireless-drivers-next/commit/846d205edd8c36d1b7828fee54bf4cf40bf8cb1a
>>> It works on some devices and does not work on others with similar
>>> symptoms - correctly associate but stop to work as soon as some
>>> data traffic is performed.
>>>
>>> So, I would check if send IEEE80211_TX_CTL_RATE_CTRL_PROBE frames
>>> with qsel = MT_QSEL_EDCA would help.
>>>
>> Thanks, will check this.
>>
>>> Another thing to try is checkout vendor driver and see if there is need
>>> to add extra code if device is_mt7612() .
>>>
>>> Regards
>>> Stanislaw
>>
>>
>>
>> --
>> Janusz Dziedzic
>>



-- 
Janusz Dziedzic
