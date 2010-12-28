Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37629 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab0L1Is5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 03:48:57 -0500
Received: by pwj3 with SMTP id 3so1000480pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 00:48:57 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19737.42080.713574.605350@gargle.gargle.HOWL>
Date: Tue, 28 Dec 2010 14:18:32 +0530
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>
Subject: Re: [PATCH 3/5] ath9k_htc: Handle FATAL events
In-Reply-To: <20101228082356.GB31274@vasanth-laptop>
References: <19737.39891.227133.163154@gargle.gargle.HOWL>
	<20101228082356.GB31274@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan wrote:
> On Tue, Dec 28, 2010 at 01:42:03PM +0530, Sujith wrote:
> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > 
> > The device has to be reset when a FATAL event is received.
> > Not doing so would leave the card in a non-working state.
> > 
> > Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/htc.h          |    6 ++-
> >  drivers/net/wireless/ath/ath9k/htc_drv_init.c |    8 ++-
> >  drivers/net/wireless/ath/ath9k/htc_drv_main.c |   57 ++++++++++++++++++++++++-
> >  drivers/net/wireless/ath/ath9k/wmi.c          |   18 +++++++-
> >  drivers/net/wireless/ath/ath9k/wmi.h          |    3 +-
> >  5 files changed, 84 insertions(+), 8 deletions(-)
> > 
> > +void ath9k_htc_reset(struct ath9k_htc_priv *priv)
> > +{
> > +	struct ath_hw *ah = priv->ah;
> > +	struct ath_common *common = ath9k_hw_common(ah);
> > +	struct ieee80211_channel *channel = priv->hw->conf.channel;
> > +	struct ath9k_hw_cal_data *caldata;
> > +	enum htc_phymode mode;
> > +	__be16 htc_mode;
> > +	u8 cmd_rsp;
> > +	int ret;
> > +
> > +	mutex_lock(&priv->mutex);
> 
> This will result in a deadlock with the one in ath9k_htc_stop().

Indeed yes, nice catch.
There is no need to lock the cancellation stuff anyway,
I'll just move them outside the lock.

Thanks for the review.

Sujith
