Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60382 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab2BBEJp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 23:09:45 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20266.3200.403302.486325@gargle.gargle.HOWL> (sfid-20120202_050948_879110_FA77074A)
Date: Thu, 2 Feb 2012 09:39:36 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>
Subject: Re: [PATCH 1/2] ath9k: recover the chip from tx/rx stuck
In-Reply-To: <20120202035652.GB25988@vmraj-lnx.users.atheros.com>
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
	<20265.65072.546108.448327@gargle.gargle.HOWL>
	<20120202035652.GB25988@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> On Thu, Feb 02, 2012 at 08:38:32AM +0530, Sujith Manoharan wrote:
> > Rajkumar Manoharan wrote:
> > > +void ath_start_rx_poll(struct ath_softc *sc, const u32 msec)
> > > +{
> > > +	if (!AR_SREV_9300_20_OR_LATER(sc->sc_ah))
> > > +		return;
> > 
> > I have not reviewed the patch, but to do such workarounds for an entire
> > family of chips is overkill. Has it been confirmed that the other
> > chips falling under this SREV check require this snafu ?
> >
> unfortunately this snafu is applicable for all ar9380 MAC based chips ;)
> and confirmed the same.

Ok. But this stuff really needs to be verified for other chips.
These 'poll' workarounds are piling up.

Sujith
