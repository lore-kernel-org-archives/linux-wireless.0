Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:41046 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbYLRXOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 18:14:21 -0500
Received: by qyk4 with SMTP id 4so743832qyk.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 15:14:19 -0800 (PST)
Message-ID: <494AD947.9040609@cortland.com> (sfid-20081219_001445_846067_3E135831)
Date: Thu, 18 Dec 2008 18:14:15 -0500
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
MIME-Version: 1.0
To: Bob Copeland <bcopeland@gmail.com>
CC: Keir <keirlawson@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, javier@cozybit.com
Subject: Re: Mesh now completely broken on ath5k, latest git
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>	 <4947ABAF.9060205@cortland.com>	 <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com>	 <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com>	 <40f31dec0812170906vd8e4445q9920c66905064df8@mail.gmail.com>	 <e27b78a40812171004r3a8d424dk7c390aaf7c757665@mail.gmail.com>	 <494A578A.7070803@cortland.com>	 <b6c5339f0812181138s1ba134a6qeff21eb063a87e08@mail.gmail.com>	 <494ABA6D.8070002@cortland.com> <b6c5339f0812181348x49e5c68bia827d9feb4ef0e6c@mail.gmail.com>
In-Reply-To: <b6c5339f0812181348x49e5c68bia827d9feb4ef0e6c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Thu, Dec 18, 2008 at 4:02 PM, Steve Brown <sbrown@cortland.com> wrote:
>   
>> Lots of these however:
>> Dec 18 15:53:20 fl-ws kernel: ath5k phy23: beacon queue 7 didn't stop?
>>     
>
> Can you change the if statement that prints that in ath5k_beacon_send() in
> base.c to capture the return value?  i.e.:
>
> int err;
> ...
>
> err = ath5k_hw_stop_tx_dma(ah, sc->bhalq);
> if (unlikely(err)) {
>     ATH5K_WARN(... "...didn't stop? %d\n", sc->bhalq, err);
> }
>
>   
>> If I make the same change to the current git, still no beacons. But, the
>> "queue 7" msgs persist.
>>     
>
> Not sure, I was about to blame ath5k_configure_filter() but I see it does
> turn on the beacons for mesh.
>
>   
Dec 18 18:04:26 fl-ws kernel: ath5k phy24: beacon queue 7 didn't stop? -16
Dec 18 18:04:26 fl-ws kernel: ath5k phy24: beacon queue 7 didn't stop? -16

BUSY?

I'm using a:
03:0a.0 Ethernet controller: Atheros Communications Inc. AR5413 
802.11abg NIC (rev 01)
    Subsystem: Atheros Communications Inc. EnGenius EMP-8602 (400mw) or 
Compex WLM54AG
    Flags: medium devsel, IRQ 22
    Memory at feab0000 (32-bit, non-prefetchable) [size=64K]
    Capabilities: [44] Power Management version 2
    Kernel modules: ath5k

Steve

