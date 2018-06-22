Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932748AbeFVOsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 10:48:13 -0400
Date: Fri, 22 Jun 2018 16:48:10 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>
Subject: Re: mt76x2e MCU message 31 timed out
Message-ID: <20180622144809.GA9773@redhat.com> (sfid-20180622_164819_714036_348E7AFB)
References: <CAFED-jkby2sk9OQnuH5PD8isr0n_CM6Eufs7Ds5fhavYfYdLBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFED-jkby2sk9OQnuH5PD8isr0n_CM6Eufs7Ds5fhavYfYdLBw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Fri, Jun 22, 2018 at 10:37:35AM +0200, Janusz Dziedzic wrote:
> Have this card in my laptop:
> 02:00.0 Network controller: MEDIATEK Corp. Device 7612
> 
> [    8.478104] mt76x2e 0000:02:00.0: ASIC revision: 76120044
> [    8.489582] mt76x2e 0000:02:00.0: ROM patch already applied
> [    8.833476] mt76x2e 0000:02:00.0: Firmware Version: 0.0.00
> [    8.833477] mt76x2e 0000:02:00.0: Build: 1
> [    8.833479] mt76x2e 0000:02:00.0: Build Time: 201507311614____
> [    8.856115] mt76x2e 0000:02:00.0: Firmware running!
> [    9.558075] mt76x2e 0000:02:00.0 wlp2s0: renamed from wlan1

I'm just curious. Does the card was installed in the laptop by default?
If so what is the model of the laptop?

> Linux test4 4.17.0-rc7+ #5 SMP Mon May 28 12:35:22 CEST 2018 x86_64 GNU/Linux
> 
> Seems iw scan works correctly and first assoc. After will run some
> traffic (iperf in such case) get:
> 
> [  432.372081] wlp2s0: associate with 52:b4:f7:f0:16:c2 (try 2/3)
> [  432.375255] wlp2s0: RX AssocResp from 52:b4:f7:f0:16:c2
> (capab=0x511 status=0 aid=2)
> [  432.375336] wlp2s0: associated
> [  432.451097] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
> [  522.562157] mt76x2e 0000:02:00.0: MCU message 31 (seq 13) timed out
> [  524.610281] mt76x2e 0000:02:00.0: MCU message 31 (seq 14) timed out
> [  526.658384] mt76x2e 0000:02:00.0: MCU message 31 (seq 15) timed out
> [  528.258455] mt76x2e 0000:02:00.0: MCU message 30 (seq 1) timed out
> [  529.282499] mt76x2e 0000:02:00.0: MCU message 30 (seq 2) timed out
> [  530.402544] mt76x2e 0000:02:00.0: MCU message 30 (seq 3) timed out
> [  531.426587] mt76x2e 0000:02:00.0: MCU message 30 (seq 4) timed out
> [  531.427444] wlp2s0: authenticate with 52:b4:f7:f0:14:ac
> [  532.450624] mt76x2e 0000:02:00.0: MCU message 30 (seq 5) timed out
> [  533.474666] mt76x2e 0000:02:00.0: MCU message 30 (seq 6) timed out
> [  534.498709] mt76x2e 0000:02:00.0: MCU message 30 (seq 7) timed out
> [  535.522736] mt76x2e 0000:02:00.0: MCU message 30 (seq 8) timed out
> [  535.522807] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 1/3)
> [  535.726740] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 2/3)
> [  535.930742] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 3/3)
> [  536.134747] wlp2s0: authentication with 52:b4:f7:f0:14:ac timed out

I observed quite similar issue on some rt2800 devices when
I applied  this patch:
https://github.com/sgruszka/wireless-drivers-next/commit/846d205edd8c36d1b7828fee54bf4cf40bf8cb1a
It works on some devices and does not work on others with similar
symptoms - correctly associate but stop to work as soon as some
data traffic is performed.

So, I would check if send IEEE80211_TX_CTL_RATE_CTRL_PROBE frames
with qsel = MT_QSEL_EDCA would help. 

Another thing to try is checkout vendor driver and see if there is need
to add extra code if device is_mt7612() .

Regards
Stanislaw
