Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37658 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab1IMRMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 13:12:34 -0400
Date: Tue, 13 Sep 2011 22:43:09 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Paul Stewart <pstew@google.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_hw: Do full chip reset on 11A channels
Message-ID: <20110913171308.GA21972@vmraj-lnx.users.atheros.com> (sfid-20110913_191237_381816_0B147D7B)
References: <1315927132-21716-1-git-send-email-rmanohar@qca.qualcomm.com>
 <CAMcMvsj+AHdjf-JteV=vpYYAgRXOCvsFmN=YwWibXAzQyBwdUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAMcMvsj+AHdjf-JteV=vpYYAgRXOCvsFmN=YwWibXAzQyBwdUQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 13, 2011 at 09:01:29AM -0700, Paul Stewart wrote:
> On Tue, Sep 13, 2011 at 8:18 AM, Rajkumar Manoharan
> <rmanohar@qca.qualcomm.com> wrote:
> > AR9003 seems to have issues sometimes with fast channel change
> > in 5GHz and this case is handled specifically for AR9002 by doing
> > a full reset. So let's do a full reset for 5GHz channles for all
> > chipsets.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/hw.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> > index 308847d..622bfc9 100644
> > --- a/drivers/net/wireless/ath/ath9k/hw.c
> > +++ b/drivers/net/wireless/ath/ath9k/hw.c
> > @@ -1504,7 +1504,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
> >            (chan->channel != ah->curchan->channel) &&
> >            ((chan->channelFlags & CHANNEL_ALL) ==
> >             (ah->curchan->channelFlags & CHANNEL_ALL)) &&
> > -           (!AR_SREV_9280(ah) || AR_DEVID_7010(ah))) {
> > +           !IS_CHAN_5GHZ(chan)) {
> 
> I'm not sure I understand.  Are you asserting that AR9002 does not
> need a full reset for channel change in 2GHz?   The code before your
> change would fall through for AR_SREV_9280(ah) && !AR_DEVID_7010(ah)
> whether in 2HGz or 5GHz, but that case gets removed with your change.
> Is that intentional?
>
Yes. Fast channel change is completely supported on 2GHz band. And also
if you look at the log history, the fast channel change was initially
disabled in 5GHz alone for AR9280 chips. AR7010 chip is the usb version of
AR9280. Instead of adding chip specific checks, the fastcc is disabled for
5GHz.

--
Rajkumar
