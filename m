Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:15012 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbYKBU1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 15:27:43 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1631648rnd.17
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 12:27:42 -0800 (PST)
Message-ID: <43e72e890811021227m30231c2ega9ab1c3f0eac71d6@mail.gmail.com> (sfid-20081102_212748_783572_B2A3844E)
Date: Sun, 2 Nov 2008 13:27:42 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Iordan Iordanov" <iiordanov@gmail.com>
Subject: Re: ath9k driver runs out of TX descriptors
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43075fc60811012033t6fdcd1c4h2c4868659afa9ec5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43075fc60811012033t6fdcd1c4h2c4868659afa9ec5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 1, 2008 at 8:33 PM, Iordan Iordanov <iiordanov@gmail.com> wrote:
> Hi,
>
> I am not a member of the mailing list yet, so please cc me on any
> communication regarding this bug report. I wanted to get the word out
> as soon as I can. I installed an AR5008 adapter in my laptop tonight.
> lspci shows:
>
> 0c:00.0 Network controller: Atheros Communications Inc. AR5008
> Wireless Network Adapter (rev 01)
>
> I am running Ubuntu 8.10, but I grabbed the latest source code
> (compat-wireless-2008-10-31), built the drivers, installed them, and
> loaded the newly built ath9k.
>
> I connected to a WPA2 protected network without a problem. However,
> when I used scp to copy a large file 30 GB) using the wireless
> adapter, the kernel started reporting this:
>
> [18461.865129] ath9k: 0.1
> [18461.865244] ath9k 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [18461.865333] ath9k 0000:0c:00.0: setting latency timer to 64
> [18462.007742] phy0: Selected rate control algorithm 'ath9k_rate_control'
> [18462.010958] Registered led device: ath9k-phy0:radio
> [18462.012169] Registered led device: ath9k-phy0:assoc
> [18462.013374] Registered led device: ath9k-phy0:tx
> [18462.014500] Registered led device: ath9k-phy0:rx
> [18462.016345] phy0: Atheros 5416: mem=0xf90a0000, irq=17
> [18462.026126] udev: renamed network interface wlan0 to wlan3
> [18466.076165] ADDRCONF(NETDEV_UP): wlan3: link is not ready
> [18469.168304] wlan3: authenticate with AP 00:14:bf:20:8e:36
> [18469.170528] wlan3: authenticated
> [18469.170538] wlan3: associate with AP 00:14:bf:20:8e:36
> [18469.174538] wlan3: RX AssocResp from 00:14:bf:20:8e:36 (capab=0x411
> status=0 aid=2)
> [18469.174546] wlan3: associated
> [18469.182436] ADDRCONF(NETDEV_CHANGE): wlan3: link becomes ready
> [18477.579665] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.581659] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.583162] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.585725] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.587235] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.588736] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.592405] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.593970] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.595999] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.597870] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.599936] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.602325] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.604278] ath_tx_prepare: TX queue: 1 is full, depth: 1004

This is not critical and common, we were supposed to change this to a
debug message only so you wouldn't see it. When it occurs we just tell
the upper layers to hold its horses.

> .
> .
> .
>
> [18477.719308] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.720793] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.726773] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.729087] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> [18477.730679] ath_tx_prepare: TX queue: 1 is full, depth: 1004
> etc., etc., etc.
>
> At this point, I decided to put a nasty hack into the source code to
> see if the error disappears. In core.h
>
> compat-wireless-2008-10-31/drivers/net/wireless/ath9k/core.h
>
> I changed:
>
> #define ATH_TXBUF               512
>
> to
>
> #define ATH_TXBUF               2048

You are increasing the size the driver uses with this too, which we
want to avoid.

> and sure enough, so far I've copied a few GB's and the error has not recurred.

I take it you don't see any throughput performance enhancements though right?

> On a lighter note, can anybody enlighten me as to why for an AR5008, I
> had to load the ath9k and not the ath5k driver?!! This really puzzles
> me.

11n Atheros devices begin on AR9xxx, AR5416 and AR5008 (although I
think this is just mislabeled and should be AR5416) are the first
generation 11n devices and escaped the new nomenclature.

  Luis
