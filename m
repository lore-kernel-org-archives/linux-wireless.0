Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:27736 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYBBBsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 20:48:36 -0500
Received: by an-out-0708.google.com with SMTP id d31so328154and.103
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 17:48:35 -0800 (PST)
Message-ID: <40f31dec0802011748i5a1b8aaftf42f7798762cca3d@mail.gmail.com> (sfid-20080202_014839_888735_3E146012)
Date: Sat, 2 Feb 2008 03:48:34 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: ath5k: reset for 5424-based card
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20080201225345.GA15922@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080131155901.GA7997@hash.localnet>
	 <40f31dec0801310856p28513848nd22c4b3c590b7a46@mail.gmail.com>
	 <20080201040358.GA13428@hash.localnet>
	 <40f31dec0802010409i47374309o5da3d76fb1bc7025@mail.gmail.com>
	 <20080201225345.GA15922@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/2, Bob Copeland <me@bobcopeland.com>:
> On Fri, Feb 01, 2008 at 02:09:26PM +0200, Nick Kossifidis wrote:
> >
> > Do you have an AP so you can run the testbed-trace as described here ?
> > http://madwifi.org/wiki/DevDocs/MadwifiTrace
>
> Yeah I have an AP but it's broadcom based.  I'll try to do the traces this
> weekend.
>

Thanx ;-)

> > One more question: can you plz describe card's behaviour with ath5k ?
> > What error message does it return on reset-failure ?
>
> Well, with the change from my original post, the card appears to
> function somewhat but the cpu gets busy and the whole machine crawls.
> Note, I didn't make any changes for initvals.
>
> I can associate but not for very long.  dmesg looks like this:
>
> ath5k phy0: Atheros AR5424 chip found (MAC: 0xa3, PHY: 0x61)
> NET: Registered protocol family 17
> ath0: Initial auth_alg=0
> ath0: authenticate with AP 00:1a:70:da:a9:cd
> ath0: RX authentication from 00:1a:70:da:a9:cd (alg=0 transaction=2
> status=0)
> ath0: authenticated
> ath0: associate with AP 00:1a:70:da:a9:cd
> ath0: RX AssocResp from 00:1a:70:da:a9:cd (capab=0x411 status=0 aid=2)
> ath0: associated
> ath0: switched to long barker preamble (BSSID=00:1a:70:da:a9:cd)
> ath5k_hw_get_isr: 0x00000020
> ath5k_hw_get_isr: 0x00000020
> ath5k_hw_get_isr: 0x00000020
> ath5k_hw_get_isr: 0x00000020

Great info ! Your card sends the RXORN interrupt (Rx overrun), at
least we know what the problem is ;-)

How about your signal strength ?

> [repeats a ton]
> ath0: No ProbeResp from current AP 00:1a:70:da:a9:cd - assume out of
> range

That's normal since we have rx overrun frames don't reach the driver...

> and sometimes:
> ath5k phy3: noise floor calibration timeout (2462MHz)
>

That's ok since we haven't added initvals/rfbuffer tables for your
card so phy isn't initialized propertly (this is the first problem we
should fix so we can be sure that rx overrun is not phy-related).

> With debug on these were the resets I was seeing, may be normal but I
> didn't know:
>
> ath5k trace ath5k_hw_stop_tx_dma:1241
> ath5k trace ath5k_hw_stop_pcu_recv:2433
> ath5k trace ath5k_hw_set_rx_filter:2518
> ath5k trace ath5k_hw_stop_rx_dma:1143
> ath5k trace ath5k_hw_reset:573
> ath5k trace ath5k_hw_get_rf_gain:1349
> ath5k trace ath5k_hw_nic_wakeup:290
> ath5k trace ath5k_hw_set_power:1058
> ath5k trace ath5k_hw_set_power:1058
> ath5k trace ath5k_hw_nic_reset:1011
> ath5k trace ath5k_hw_txpower:2012
> ath5k trace ath5k_hw_get_rate_table:401
> ath5k trace ath5k_hw_disable_pspoll:4342
> ath5k trace ath5k_hw_set_opmode:2187
> ath5k trace ath5k_hw_reset_tx_queue:3173
>

Yup on rx overrun card resets but it worries me that get_isr reports
it, get_isr only prints an interrupt code when it doesn't process it,
and that's a bug in your case (on some cards rx overrun is fatal and
we don't handle this right now, well just one more fix to add on my
pending patches ;-) ).

Try this fix...
edit drivers/net/wireless/ath5k/hw.c, go to ath5k_hw_get_isr and
you'll see this...

1472         if (ah->ah_version != AR5K_AR5210) {
1473                 /*HIU = Host Interface Unit (PCI etc)*/
1474                 if (unlikely(data & (AR5K_ISR_HIUERR)))
1475                         *interrupt_mask |= AR5K_INT_FATAL;


Change AR5K_ISR_HIUERR with AR5K_ISR_RXORN

This will force a card reset once you receive an RXORN interrupt (will
report it as FATAL) and will get rid of get_isr message ;-)



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
