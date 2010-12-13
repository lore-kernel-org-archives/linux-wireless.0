Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:32957 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab0LMH0f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 02:26:35 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 23:26:19 -0800
Date: Mon, 13 Dec 2010 12:56:04 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 5/7] ath9k_hw: fix PA predistortion training power
	selection
Message-ID: <20101213072604.GB13721@vasanth-laptop>
References: <1292160877-50618-1-git-send-email-nbd@openwrt.org> <1292160877-50618-2-git-send-email-nbd@openwrt.org> <1292160877-50618-3-git-send-email-nbd@openwrt.org> <1292160877-50618-4-git-send-email-nbd@openwrt.org> <1292160877-50618-5-git-send-email-nbd@openwrt.org> <20101213060253.GA13721@vasanth-laptop> <4D05C8EF.6030603@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4D05C8EF.6030603@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 13, 2010 at 12:49:11PM +0530, Felix Fietkau wrote:
> On 2010-12-13 7:02 AM, Vasanthakumar Thiagarajan wrote:
> > On Sun, Dec 12, 2010 at 07:04:35PM +0530, Felix Fietkau wrote:
> >> The EEPROM contains scale factors for the tx power, which define
> >> the range of allowable difference between target power and training
> >> power. If the difference is too big, PA predistortion cannot be used.
> >> For 2.4 GHz there is only one scale factor, for 5 GHz there are
> >> three, depending on the specific frequency range.
> >> 
> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> >> ---
> >>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    8 ++
> >>  drivers/net/wireless/ath/ath9k/ar9003_paprd.c  |   99 ++++++++++++++++++++----
> >>  drivers/net/wireless/ath/ath9k/ar9003_phy.h    |    8 ++
> >>  drivers/net/wireless/ath/ath9k/hw.h            |    2 +
> >>  drivers/net/wireless/ath/ath9k/main.c          |    4 +-
> >>  5 files changed, 104 insertions(+), 17 deletions(-)

> >> +static int get_streams(int mask)
> >> +{
> >> +	return !!(mask & BIT(0)) + !!(mask & BIT(1)) + !!(mask & BIT(2));
> >> +}
> > ah->caps.max_txchains can be used instead of this function.
> No, it cannot. I need the number of active chains, not the number of
> chains that the hardware is capable of using.

Ah, right.
> 
> >> +
> >> +static int ar9003_get_training_power_5g(struct ath_hw *ah)
> >> +{
> >> +	struct ath_common *common = ath9k_hw_common(ah);
> >> +	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
> >> +	struct ar9300_modal_eep_header *hdr = &eep->modalHeader5G;
> >> +	struct ath9k_channel *chan = ah->curchan;
> >> +	unsigned int power, scale, delta;
> >> +
> >> +	if (chan->channel >= 5700)
> >> +		scale = MS(hdr->papdRateMaskHt20, AR9300_PAPRD_SCALE_1);
> >> +	else if (chan->channel >= 5400)
> >> +		scale = MS(hdr->papdRateMaskHt40, AR9300_PAPRD_SCALE_2);
> >> +	else
> >> +		scale = MS(hdr->papdRateMaskHt40, AR9300_PAPRD_SCALE_1);
> > 
> > A helper function would be nice to get the paprd scale factor which
> > will also be used to disable paprd for particular rates. Anyway, i'm
> > doing changes to disable paprd based on scale factor and tx power,
> > i'll add a helper in my series.
> OK.

seems like it is missing endian conversion for big endian platform ?.

Vasanth
