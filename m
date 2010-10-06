Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:8384 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754226Ab0JFCZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 22:25:54 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0304391952
	for <linux-wireless@vger.kernel.org>; Wed,  6 Oct 2010 11:25:53 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>, vasanth@atheros.com
Subject: Re: [PATCH 5/5] ath5k: Add busy ratios to survey data
Date: Wed, 6 Oct 2010 11:25:54 +0900
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
References: <20101005095510.3083.46174.stgit@tt-desk> <20101005095531.3083.39403.stgit@tt-desk> <AANLkTimP=R4hsCWU+wP1aemHn1awzNQVWMa-_7OJEQLG@mail.gmail.com>
In-Reply-To: <AANLkTimP=R4hsCWU+wP1aemHn1awzNQVWMa-_7OJEQLG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010061125.54247.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed October 6 2010 07:38:34 Luis R. Rodriguez wrote:
> On Tue, Oct 5, 2010 at 2:55 AM, Bruno Randolf <br1@einfach.org> wrote:
> > Include the channel utilization (busy, rx, tx) in the survey results.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > ---
> >  drivers/net/wireless/ath/ath5k/base.c |   17 +++++++++++++++++
> >  1 files changed, 17 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath5k/base.c
> > b/drivers/net/wireless/ath/ath5k/base.c index c158f2e..a33d9f2 100644
> > --- a/drivers/net/wireless/ath/ath5k/base.c
> > +++ b/drivers/net/wireless/ath/ath5k/base.c
> > @@ -3008,6 +3008,7 @@ static int ath5k_get_survey(struct ieee80211_hw
> > *hw, int idx, {
> >        struct ath5k_softc *sc = hw->priv;
> >        struct ieee80211_conf *conf = &hw->conf;
> > +       struct ath_common *common = ath5k_hw_common(sc->ah);
> > 
> >         if (idx != 0)
> >                return -ENOENT;
> > @@ -3016,6 +3017,22 @@ static int ath5k_get_survey(struct ieee80211_hw
> > *hw, int idx, survey->filled = SURVEY_INFO_NOISE_DBM;
> >        survey->noise = sc->ah->ah_noise_floor;
> > 
> > +       ath_hw_cycle_counters_lock(common);
> > +       ath_hw_cycle_counters_update(common);
> > +       if (common->cc_survey.cycles > 0) {
> > +               survey->filled |= SURVEY_INFO_BUSY |
> > +                               SURVEY_INFO_BUSY_TX |
> > SURVEY_INFO_BUSY_RX; +               survey->busy =
> > common->cc_survey.rx_busy * 255 / +                                    
> >   common->cc_survey.cycles; +               survey->busy_tx =
> > common->cc_survey.tx_frame * 255 / +                                    
> >   common->cc_survey.cycles; +               survey->busy_rx =
> > common->cc_survey.rx_frame * 255 / +                                    
> >   common->cc_survey.cycles; +       }
> > +
> > +       memset(&common->cc_survey, 0, sizeof(struct ath_cycle_counters));
> > +       ath_hw_cycle_counters_unlock(common);
> > +
> 
> This is all being sucked out of common, so can we just share the
> filler for the survey between ath5k and ath9k? Note we should split up
> hw code and core driver code on the ath module by file.

sure, that would be good! noise floor comes from ath5k_hw though, but that can 
easily be moved to common. 

there's so much code which could be shared between ath5k and ath9k...

bruno
