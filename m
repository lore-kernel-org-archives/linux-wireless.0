Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56533 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZCLIle (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 04:41:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 01:41:33 -0700
Date: Thu, 12 Mar 2009 14:11:21 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Set
	IEEE80211_TX_CTL_RATE_CTRL_PROBE in rate control for probe rates
Message-ID: <20090312084121.GB18111@vasanth-laptop> (sfid-20090312_094137_412234_52054801)
References: <1236352117-18466-1-git-send-email-vasanth@atheros.com> <1236352117-18466-2-git-send-email-vasanth@atheros.com> <18865.16679.121576.346045@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <18865.16679.121576.346045@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 06, 2009 at 08:58:39PM +0530, Sujith wrote:
> Vasanthakumar Thiagarajan wrote:
> > ---
> >  drivers/net/wireless/ath9k/rc.c |   13 ++++++++-----
> >  1 files changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
> > index 8327356..a35b525 100644
> > --- a/drivers/net/wireless/ath9k/rc.c
> > +++ b/drivers/net/wireless/ath9k/rc.c
> > @@ -750,7 +750,8 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
> >  static void ath_rc_rate_set_series(struct ath_rate_table *rate_table,
> >                                  struct ieee80211_tx_rate *rate,
> >                                  struct ieee80211_tx_rate_control *txrc,
> > -                                u8 tries, u8 rix, int rtsctsenable)
> > +                                u8 tries, u8 rix, int rtsctsenable,
> > +                                bool is_probe)
> >  {
> >       rate->count = tries;
> >       rate->idx = rix;
> > @@ -765,6 +766,8 @@ static void ath_rc_rate_set_series(struct ath_rate_table *rate_table,
> >               rate->flags |= IEEE80211_TX_RC_SHORT_GI;
> >       if (WLAN_RC_PHY_HT(rate_table->info[rix].phy))
> >               rate->flags |= IEEE80211_TX_RC_MCS;
> > +     if (is_probe)
> > +             rate->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
> >  }
> >
> 
> IEEE80211_TX_CTL_RATE_CTRL_PROBE is to be used with flags@ieee80211_tx_info
> and is not a per-rate flag.

oops, thanks.

