Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:30343 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbXKBWTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2007 18:19:54 -0400
Received: by py-out-1112.google.com with SMTP id u77so1781646pyb
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2007 15:19:53 -0700 (PDT)
Message-ID: <40f31dec0711021519x62600f54i9ed3c2946515659@mail.gmail.com> (sfid-20071102_221957_334099_0C84B0DD)
Date: Sat, 3 Nov 2007 00:19:52 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] ath5k: Set ACK to user lower bit rates
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <43e72e890711021439y4f6ce2fdh84935ad746ce9383@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071102204638.GA3227@pogo>
	 <40f31dec0711021413u397f9cb9r99ef8b9ca51ea01c@mail.gmail.com>
	 <40f31dec0711021425y4e4bee5bi1c63ea165e6ed6a7@mail.gmail.com>
	 <43e72e890711021439y4f6ce2fdh84935ad746ce9383@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/11/2, Luis R. Rodriguez <mcgrof@gmail.com>:
> On 11/2/07, Nick Kossifidis <mickflemm@gmail.com> wrote:
> > 2007/11/2, Nick Kossifidis <mickflemm@gmail.com>:
> > > 2007/11/2, Luis R. Rodriguez <mcgrof@gmail.com>:
> > > > Sorry, forgot this last hunk in my patch series... This applies on top
> > > > of my series.
> > > >
> > > > This sets the ACK bitrate to the lower rates. Without this I get
> > > > about 70% packet loss when using the 11M rate. Not sure exactly what rates
> > > > this is setting the HW to send the ACKs in but it sure does help.
> > > >
> > >
> > > 6Mbits for OFDM (have checked it out with various sniffers), if not
> > > set i usualy get 24Mbits for acks when transmiting on 54Mbit.
> > >
> > > Haven't checked it for CCK but i guess it's 1 or 2 Mbits, have a look
> > > at my comments inside reg.h...
> > >
> > > #define AR5K_STA_ID1_ACKCTS_6MB         0x01000000      /* Use 6Mbit/s
> > > for ACK/CTS (?) */
> > > #define AR5K_STA_ID1_BASE_RATE_11B      0x02000000      /* Use 11b
> > > base rate (for ACK/CTS ?) [5211+] */
> > >
> >
> > Also note that setting these bits is safe and cause a more stable
> > behaviour. If these bits are not set then control_rate is being used
>
> Why do you say that? How do you know?
>

Using sniffers/analyzers with madwifi i can see that either
control_rate is being used or base rate (i guess HAL chooses if it
will use control_rate or base rate). I know for sure that if i
explicitly set these bits to use lower rates with madwifi (which also
has this function that writes directly on the register) i only get
6Mbits for ack frames and if i don't i usualy get 24Mbits
(control_rate) but nothing else (that's because i'm transmitting @ 24
- 54Mbits).

> > (check out rate tables -remember these tables are hardcoded in hal,
> > that's why they have put control_rate there, to let us know what rate
> > is being used for ack/cts frames by hw-).
> >
> > Here it is...
> > (transmision rate) -> (ack/cts rate)
> >
> > OFDM
> > 6 - 12 -> 6
> > 12 - 24 -> 12
> > 24 - 54 -> 24
> >
> > CCK
> > 1 - 2 -> 1
> > 2 - 11 -> 2
>
> This is not a concoction by the HAL or driver, this is what the spec
> yields. Let me quote the relevant section, which is in tx.c on
> mac80211:
>
> IEEE 802.11, 9.6:
>          - control response frame (CTS or ACK) shall be transmitted using the
>            same rate as the immediately previous frame in the frame exchange
>            sequence, if this rate belongs to the PHY mandatory rates, or else
>            at the highest possible rate belonging to the PHY rates in the
>            BSSBasicRateSet
>

I don't see how this is relevant, as i told you i can only see ack
frames on the above rates (6,12,24) with madwifi regardless of the
previously transmited frame's rate, also BSSBasicRateSet  is nothing
standard, i checked out 802.11-1999 and here is what it says...

"The set of data rates (in units of 500 kbit/s) that must
be supported by all STAs to join this BSS. The STA
that is creating the BSS must be able to receive and
transmit at each of the data rates listed in the set."

so what we get (6,12,24 for acks) is not defined anywhere, so i guess
is hw-related.

> Also I think it might be possible to change the ACK rate per used TX
> rate. I am not sure where this can be set though. In my latest
> approach I just removed the control_rate all together as we should be
> following the spec. I left the control rate though just to gradually
> shift in the right direction and as I'm not yet 100% sure this is just
> for the ACK timeout.
>

control_rate isn't used anywhere in ath5k (like the rest of rate
tables), i'm not sure if rate control algorithms on madwifi use this.
As i've said before we should remove that led blinking stuff and get
rid of them (btw shouldn't we register gpio led with led class ?)

> > So it still doesn't make sense that you had 70% loss i mean any rate
> > between 2 and 11Mbits would cause the same ack rate (2Mbits), even if
> > you didn't set that bit.
>
> Yeah, it seemed strange to me too.
>
>   Luis
>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
