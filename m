Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:54037 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab0LBFnl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 00:43:41 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 21:43:26 -0800
Date: Thu, 2 Dec 2010 11:13:16 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 11/26] ath9k_hw: Find chansel of AR_PHY_65NM_CH0_SYNTH7
	from an array for AR9485
Message-ID: <20101202054316.GL12908@vasanth-laptop>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com> <1291188775-13707-12-git-send-email-vasanth@atheros.com> <4CF67BAB.60504@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CF67BAB.60504@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 01, 2010 at 10:15:31PM +0530, Felix Fietkau wrote:
> On 2010-12-01 8:32 AM, Vasanthakumar Thiagarajan wrote:
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/ar9003_phy.c |   25 ++++++++++++++++++++++++-
> >  1 files changed, 24 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> > index 4e35bda..4739af1 100644
> > --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> > +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> > @@ -25,6 +25,24 @@ static const int cycpwrThr1_table[] =
> >  /* level:  0   1   2   3   4   5   6   7   8  */
> >  	{ -6, -4, -2,  0,  2,  4,  6,  8 };     /* lvl 0-7, default 3 */
> >  
> > +/* Chansel table used by ar9485 */
> > +static const u32 ar9003_chansel_xtal_40M[] = {
> > +	0xa0ccbe,
> > +	0xa12213,
> > +	0xa17769,
> > +	0xa1ccbe,
> > +	0xa22213,
> > +	0xa27769,
> > +	0xa2ccbe,
> > +	0xa32213,
> > +	0xa37769,
> > +	0xa3ccbe,
> > +	0xa42213,
> > +	0xa47769,
> > +	0xa4ccbe,
> > +	0xa5998b,
> > +};
> > +
> >  /*
> >   * register values to turn OFDM weak signal detection OFF
> >   */
> > @@ -75,7 +93,12 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
> >  	freq = centers.synth_center;
> >  
> >  	if (freq < 4800) {     /* 2 GHz, fractional mode */
> > -		channelSel = CHANSEL_2G(freq);
> > +		if (AR_SREV_9485(ah)) {
> > +			int ichan = ieee80211_frequency_to_channel(freq);
> > +
> > +			channelSel = ar9003_chansel_xtal_40M[ichan - 1];
> > +		} else
> > +			channelSel = CHANSEL_2G(freq);
> I looked at the values of this table, this is exactly the same as what
> CHANSEL_2G() returns except that the table has an offset of -14.
> Please use CHANSEL_2G(freq) - 14 for AR9485 and drop the table to avoid
> adding more unnecessary hardcoded values.

Not exactly. See the following CHANSEL_2G(freq).

 a0cccc
 a12222
 a17777
 a1cccc
 a22222
 a27777
 a2cccc
 a32222
 a37777
 a3cccc
 a42222
 a47777
 a4cccc
 a52222

Vasanth
