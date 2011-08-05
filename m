Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54371 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab1HEHXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 03:23:53 -0400
Date: Fri, 5 Aug 2011 12:54:12 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: Felix Fietkau <nbd@openwrt.org>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 11/13] ath9k_hw: Disable Walsh spatial spreading for 2
 chains
Message-ID: <20110805072411.GA5510@vmraj-lnx.users.atheros.com> (sfid-20110805_092357_532163_AA6EFF08)
References: <1312480447-27483-1-git-send-email-rmanohar@qca.qualcomm.com>
 <4E3AE3A0.2000308@openwrt.org>
 <20110805025452.GA28266@vmraj-lnx.users.atheros.com>
 <CAJ-VmomqOOh8zEn-ofu6FuNwWVYrfvJ8iXeJbbKTGA2LLGpD5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAJ-VmomqOOh8zEn-ofu6FuNwWVYrfvJ8iXeJbbKTGA2LLGpD5w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 05, 2011 at 02:35:44PM +0800, Adrian Chadd wrote:
> There's already code in the driver that subtracts 3 and 5 dB from the
> max TX power.
> 
> Some NICs have value=0 for pwrdecrease2chain and pwrdecrease3chain; I
> have a feeling the EEPROMs in those have been programmed assuming 2 or
> 3 chain TX with the current setting (ie, AR_PHY_FC_WALSH in
> AR_PHY_TURBO). If they've calibrated the EEPROM settings based on that
> bit being set for 2 or 3 chain TX, you may find they're already doing
> the "right" thing. Flipping that bit off (and unconditionally
> subtracting TX power) may result in a lower TX power than regulatory?
> 
Those pwrdecrease fields are applicable for AR9280 chips not for AR9003.
> I do suggest that someone with the relevant test equipment do some
> investigation into what the behaviour is of a variety of NICs. I'd
> love to survey what's going on but I'd have to acquire access to a
> spectrum analyser.
>
These changes were done based on our system team's comments.

--
Rajkumar
> 
> 
> Adrian
> 
> On 5 August 2011 10:54, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> > On Thu, Aug 04, 2011 at 08:23:28PM +0200, Felix Fietkau wrote:
> >> On 2011-08-04 7:54 PM, Rajkumar Manoharan wrote:
> >> >The Walsh bit is disabled for regulatory consideration.
> >> >
> >> >As per the FCC rulings, only transmissions that are completely
> >> >non-coherent, are allowed to waive the array gain contribution
> >> >to EIRP for multi-transmit configurations. The use of 2-stream
> >> >with 2 transmit and use of 3-steam with 3 transmit qualifies
> >> >for this spatial multiplexing MIMO classification as long as
> >> >the streams are directly mapped to each radio (not Walsh spread
> >> >prior to splitting to multiple radios)
> >> I think ath9k does not waive the array gain contribution. I haven't
> >> checked AR9003, but on AR9002 and older, it explicitly includes the
> >> array gain contribution in the tx power limit calculation. I'm not
> >> sure that unconditionally disabling spatial spreading is the right
> >> way to deal with this.
> >>
> > We might violate the FCC rule with 2x2 config(3dB higher at 2-stream)
> > if this bit is enabled. Based on chainmask we can disable Walsh bit.
> > Any comments?
> >
> > --
> > Rajkumar
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
