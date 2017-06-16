Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36241 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdFPKzD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 06:55:03 -0400
Received: by mail-io0-f174.google.com with SMTP id y77so28254429ioe.3
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 03:55:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABWe71weMrbEA=htjdRpUBofKo04jeQ9B56xvUzq2zF1YBmQFg@mail.gmail.com>
References: <CABWe71weMrbEA=htjdRpUBofKo04jeQ9B56xvUzq2zF1YBmQFg@mail.gmail.com>
From: =?UTF-8?B?5a2Z5bu65biM?= <ycsunjane@gmail.com>
Date: Fri, 16 Jun 2017 18:55:02 +0800
Message-ID: <CABWe71yir2pdRPW40SMG3fh6DHwNqm2YgPNg43jCix-of6SCKA@mail.gmail.com> (sfid-20170616_125507_670429_65A5746C)
Subject: Re: ath9k: wds mode can not recieve any packets.
To: linux-wireless@vger.kernel.org, nbd@openwrt.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

all:

I have  catched the error info when rx error  with:

echo 0xffffffff > /sys/kernel/debug/ieee80211/phy0/ath9k/debug

error info:

[  524.921114] ath: phy0: enable IER
[  524.924315] ath: phy0: AR_IMR 0x81840175 IER 0x1
[  525.000052] ath: phy0: listenTime=3D183359 OFDM:2 errs=3D46/s CCK:7
errs=3D308/s ofdm_turn=3D1
[  525.006532] ath: phy0: Calibration @22499 finished:   ani, caldone: true
[  525.021461] ath: phy0: disable IER
[  525.023486] ath: phy0: enable IER
[  525.026712] ath: phy0: AR_IMR 0x81840175 IER 0x1
[  525.123859] ath: phy0: disable IER
[  525.125887] ath: phy0: enable IER
[  525.129115] ath: phy0: AR_IMR 0x81840175 IER 0x1
[  525.226269] ath: phy0: disable IER
[  525.228315] ath: phy0: enable IER
[  525.231562] ath: phy0: AR_IMR 0x81840175 IER 0x1
[  525.310052] ath: phy0: listenTime=3D183613 OFDM:2 errs=3D46/s CCK:7
errs=3D308/s ofdm_turn=3D1
[  525.316533] ath: phy0: Calibration @22530 finished:   ani, caldone: true
[  525.328660] ath: phy0: disable IER
[  525.330732] ath: phy0: enable IER
[  525.333910] ath: phy0: AR_IMR 0x81840175 IER 0x1
[  525.431133] ath: phy0: disable IER
[  525.433165] ath: phy0: enable IER
[  525.436392] ath: phy0: AR_IMR 0x81840175 IER 0x1
[  525.533664] ath: phy0: disable IER
[  525.535690] ath: phy0: enable IER
[  525.538918] ath: phy0: AR_IMR 0x81840175 IER 0x1
[  525.620053] ath: phy0: listenTime=3D183874 OFDM:2 errs=3D46/s CCK:7
errs=3D308/s ofdm_tu

On Tue, Jun 13, 2017 at 3:38 PM, =E5=AD=99=E5=BB=BA=E5=B8=8C <ycsunjane@gma=
il.com> wrote:
> Ath9k in 4addr wds mode. After a while the station will break off.
> Station connectivity remains. But `ifconfig` cannot see any recv
> packet.
>
> wlan0     Link encap:Ethernet  HWaddr C8:EE:A6:2E:60:D8
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:17402577 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:33065526 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:1165838023 (1.0 GiB)  TX bytes:51166664044 (47.6 GiB)
>
> RX packets count stop increase.
>
>
> /sys/kernel/debug/ieee80211/phy0/ath9k/recv
>          PKTS-ALL :   21445223
>          BYTES-ALL : 2458906640
>
>
>   PKTS-ALL still increase.
