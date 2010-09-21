Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35423 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab0IUKSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 06:18:16 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Sep 2010 03:18:09 -0700
Date: Tue, 21 Sep 2010 15:47:57 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Kick start paprd calibration whenever
	operating channel changes
Message-ID: <20100921101757.GA4229@vasanth-laptop>
References: <1285048487-16795-1-git-send-email-vasanth@atheros.com> <1285048487-16795-2-git-send-email-vasanth@atheros.com> <4C9883A4.60302@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C9883A4.60302@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 21, 2010 at 03:36:28PM +0530, Felix Fietkau wrote:
> On 2010-09-21 7:54 AM, Vasanthakumar Thiagarajan wrote:
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/hw.h   |    1 +
> >  drivers/net/wireless/ath/ath9k/main.c |   18 +++++++++++++++++-
> >  2 files changed, 18 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> > index df47f79..c1b4962 100644
> > --- a/drivers/net/wireless/ath/ath9k/hw.h
> > +++ b/drivers/net/wireless/ath/ath9k/hw.h
> > @@ -645,6 +645,7 @@ struct ath_hw {
> >  	struct ath9k_hw_capabilities caps;
> >  	struct ath9k_channel channels[38];
> >  	struct ath9k_channel *curchan;
> > +	struct ath9k_channel prev_paprd_chan;
> >  
> >  	union {
> >  		struct ar5416_eeprom_def def;
> > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> > index a133878..9150788 100644
> > --- a/drivers/net/wireless/ath/ath9k/main.c
> > +++ b/drivers/net/wireless/ath/ath9k/main.c
> > @@ -266,6 +266,20 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
> >  	return r;
> >  }
> >  
> > +static bool is_paprd_done(struct ath_hw *ah)
> > +{
> > +	struct ath9k_channel *curchan, *paprd_chan;
> > +
> > +	curchan = ah->curchan;
> > +	paprd_chan = &ah->prev_paprd_chan;
> > +
> > +	if ((paprd_chan->channel == curchan->channel) &&
> > +	    paprd_chan->chanmode == curchan->chanmode)
> > +		return true;
> > +
> > +	return false;
> > +}
> That seems like code duplication to me. The caldata already has the
> channel number and the channel flags. ath9k_hw_reset() clears the entire
> caldata whenever that changes. Because of that, ah->caldata->paprd_done
> should have already been set to zero automatically after the reset
> triggered by an operating channel change.
> Is that part not working, or why did you write this patch?
> Either way, we should not have a separate check just for paprd, it
> belongs to the other calibrations.

I don't want to do paprd again whenever coming back from off-channel
(like during background scanning).

Vasanth
