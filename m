Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:45921 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYLSUSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 15:18:15 -0500
Received: by qw-out-2122.google.com with SMTP id 3so323129qwe.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 12:18:13 -0800 (PST)
Message-ID: <494C0181.8050008@cortland.com> (sfid-20081219_211818_563641_3ED730D5)
Date: Fri, 19 Dec 2008 15:18:09 -0500
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
If I revert this part of the pcu patch, the "queue 7" messages go away. 
Beacons remain.

-       ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
+       /* When in AP mode zero timer0 to start TSF */
+       if (ah->ah_op_mode == NL80211_IFTYPE_AP)
+               ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
+       else
+               ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);

The corresponding snippet of hal code seems to be:

        case HAL_M_HOSTAP:
                if (AH_PRIVATE(ah)->ah_opmode == HAL_M_HOSTAP)
                        OS_REG_WRITE(ah, AR_TIMER0, 0);
                else
                        OS_REG_WRITE(ah, AR_TIMER0, next_beacon);

No idea what's going on.

Steve

