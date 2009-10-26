Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16716 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600AbZJZUoo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 16:44:44 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 13:44:49 -0700
Date: Mon, 26 Oct 2009 13:44:47 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Kalle Valo <kalle.valo@iki.fi>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH v2 2/4] ath9k_hw: distinguish single-chip solutions on
	initial probe print
Message-ID: <20091026204447.GA5713@tux>
References: <1256575447-4591-1-git-send-email-lrodriguez@atheros.com> <87d449hp73.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87d449hp73.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 01:31:44PM -0700, Kalle Valo wrote:
> "Luis R. Rodriguez" <lrodriguez@atheros.com> writes:
> 
> > Devices with external radios have revisions which we can count on.
> > On single chip solutions these EEPROM values for these radio revision
> > also exist but are not meaningful as the radios are embedded onto the
> > same chip. Each single-chip device evolves together as one device.
> >
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >
> > Changes hw_name to 60 bytes.
> 
> Thanks, much better now.
> 
> Another minor comment, sorry that I didn't notice it earlier:
> 
> > +void ath9k_hw_name(struct ath_hw *ah, char *hw_name)
> > +{
> > +     /* chipsets >= AR9280 are single-chip */
> > +     if (AR_SREV_9280_10_OR_LATER(ah)) {
> > +             sprintf(hw_name,
> > +                     "Atheros single-chip AR%s Rev:%x",
> > +                     ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
> > +                     ah->hw_version.macRev);
> > +     }
> > +     else {
> > +             sprintf(hw_name,
> > +                     "Atheros AR%s MAC/BB Rev:%x AR%s RF Rev:%x: ",
> > +                     ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
> > +                     ah->hw_version.macRev,
> > +                     ath9k_hw_rf_name((ah->hw_version.analog5GhzRev &
> > +                                      AR_RADIO_SREV_MAJOR)),
> > +                     ah->hw_version.phyRev);
> > +     }
> > +}
> 
> I think you should provide the size of hw_name to this function and
> use snprintf() to avoid writing out of bounds.

I was going to do this but since I know the users of it and control
it seemed to not matter. I'll respin with this added, better to be careful.

Thanks for the review.

  Luis
