Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29694 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0LFGDb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 01:03:31 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 05 Dec 2010 22:03:16 -0800
Date: Mon, 6 Dec 2010 11:33:10 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 12/27] ath9k_hw: Find chansel of
	AR_PHY_65NM_CH0_SYNTH7 from an array for AR9485
Message-ID: <20101206060310.GS12908@vasanth-laptop>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com> <1291288031-3409-13-git-send-email-vasanth@atheros.com> <4CF84BB8.8090007@openwrt.org> <20101203045054.GP12908@vasanth-laptop> <4CF8DF08.2060307@openwrt.org> <20101203124050.GR12908@vasanth-laptop> <4CF8E718.9070207@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CF8E718.9070207@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 03, 2010 at 06:18:24PM +0530, Felix Fietkau wrote:
> On 2010-12-03 1:40 PM, Vasanthakumar Thiagarajan wrote:
> > On Fri, Dec 03, 2010 at 05:44:00PM +0530, Felix Fietkau wrote:
> >> On 2010-12-03 5:50 AM, Vasanthakumar Thiagarajan wrote:
> >> > On Fri, Dec 03, 2010 at 07:15:28AM +0530, Felix Fietkau wrote:
> >> >> On 2010-12-02 12:06 PM, Vasanthakumar Thiagarajan wrote:
> >> >> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> >> >> > ---
> >> >> >  drivers/net/wireless/ath/ath9k/ar9003_phy.c |   25 ++++++++++++++++++++++++-
> >> >> >  1 files changed, 24 insertions(+), 1 deletions(-)
> >> >> > 
> >> >> > diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> >> >> > index b34a9e9..136e64a 100644
> >> >> > --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> >> >> > +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> >> >> > @@ -25,6 +25,24 @@ static const int cycpwrThr1_table[] =
> >> >> >  /* level:  0   1   2   3   4   5   6   7   8  */
> >> >> >  	{ -6, -4, -2,  0,  2,  4,  6,  8 };     /* lvl 0-7, default 3 */
> >> >> >  
> >> >> > +/* Chansel table used by ar9485 */
> >> >> > +static const u32 ar9003_chansel_xtal_40M[] = {
> >> >> > +	0xa0ccbe,
> >> >> > +	0xa12213,
> >> >> > +	0xa17769,
> >> >> > +	0xa1ccbe,
> >> >> > +	0xa22213,
> >> >> > +	0xa27769,
> >> >> > +	0xa2ccbe,
> >> >> > +	0xa32213,
> >> >> > +	0xa37769,
> >> >> > +	0xa3ccbe,
> >> >> > +	0xa42213,
> >> >> > +	0xa47769,
> >> >> > +	0xa4ccbe,
> >> >> > +	0xa5998b,
> >> >> > +};
> >> >> > +
> >> >> >  /*
> >> >> >   * register values to turn OFDM weak signal detection OFF
> >> >> >   */
> >> >> > @@ -75,7 +93,12 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
> >> >> >  	freq = centers.synth_center;
> >> >> >  
> >> >> >  	if (freq < 4800) {     /* 2 GHz, fractional mode */
> >> >> > -		channelSel = CHANSEL_2G(freq);
> >> >> > +		if (AR_SREV_9485(ah)) {
> >> >> > +			int ichan = ieee80211_frequency_to_channel(freq);
> >> >> > +
> >> >> > +			channelSel = ar9003_chansel_xtal_40M[ichan - 1];
> >> >> How about using this formula for AR9485:
> >> >> 
> >> >> #define CHANSEL_2G_AR9485(_freq)	(((_freq) * 0x10000 - 215) / CHANSEL_DIV)
> >> >> 
> >> >> While I don't know where the 215 comes from (the calculation does not
> >> >> appear to be documented anywhere and I found it by trial & error),
> >> >> I do think it's better to have a simple formula than a long table
> >> >> of hardcoded values.
> >> > 
> >> > I don't know, having some arbitrary formula would
> >> > complicate things especially if we want to integrate
> >> > changes from internal code base. I prefer the table.
> >> How would it complicate things? Right now the resulting values are
> >> exactly the same. If we get a new table from the HAL, I'll either come
> >> up with a new formula, or we switch to the table then. But in the mean
> >> time we'll have better code.
> > 
> > In that case, I'm not comfortable with the magic number. I'll try to
> > ask people about the relation between the older one and the newer
> > one.
> Yeah, I asked around already and didn't get an answer yet, as the source
> of these values does not seem to be documented internally.

I don't have any doc for this register yet.

> But how exactly is *one* magic number (and it's even a very small one)
> worse than 14 of them, especially since anybody can verify that the
> generated raw values are exactly the same?

Anyway, still this formula gets it wrong for channel 14.
Lets have this table for now, I'll clean this up once I
get the proper doc for this register?.

Vasanth

