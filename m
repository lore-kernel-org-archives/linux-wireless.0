Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38605 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760121AbZLOTB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 14:01:27 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 11:01:27 -0800
Date: Tue, 15 Dec 2009 11:01:26 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?utf-8?B?THVrw6HFoQ==?= Turek <8an@praha12.net>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Implement mac80211 callback
 set_coverage_class
Message-ID: <20091215190126.GD2123@tux>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
 <1260899813-17585-6-git-send-email-8an@praha12.net>
 <20091215185016.GB2123@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <20091215185016.GB2123@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2009 at 10:50:16AM -0800, Luis Rodriguez wrote:
> On Tue, Dec 15, 2009 at 09:56:52AM -0800, Lukáš Turek wrote:
> > The callback sets slot time as specified in IEEE 802.11-2007 section
> > 17.3.8.6 (for 20MHz channels only for now) and raises ACK and CTS
> > timeouts accordingly. The values are persistent, they are restored after
> > device reset.
> >
> > Signed-off-by: Lukas Turek <8an@praha12.net>
> > ---
> >  drivers/net/wireless/ath/ath5k/ath5k.h |    2 +
> >  drivers/net/wireless/ath/ath5k/base.c  |   23 +++++++++++++
> >  drivers/net/wireless/ath/ath5k/pcu.c   |   55 ++++++++++++++++++++++++++++++++
> >  drivers/net/wireless/ath/ath5k/reset.c |    4 ++
> >  4 files changed, 84 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> > index ae311d2..66bcb50 100644
> > --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> > +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> > @@ -1063,6 +1063,7 @@ struct ath5k_hw {
> >         u32                     ah_cw_min;
> >         u32                     ah_cw_max;
> >         u32                     ah_limit_tx_retries;
> > +       u8                      ah_coverage_class;
> >
> >         /* Antenna Control */
> >         u32                     ah_ant_ctl[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
> > @@ -1200,6 +1201,7 @@ extern bool ath5k_eeprom_is_hb63(struct ath5k_hw *ah);
> >
> >  /* Protocol Control Unit Functions */
> >  extern int ath5k_hw_set_opmode(struct ath5k_hw *ah);
> > +extern void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class);
> >  /* BSSID Functions */
> >  extern int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac);
> >  extern void ath5k_hw_set_associd(struct ath5k_hw *ah);
> > diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> > index a4c086f..203622e 100644
> > --- a/drivers/net/wireless/ath/ath5k/base.c
> > +++ b/drivers/net/wireless/ath/ath5k/base.c
> > @@ -254,6 +254,8 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
> >                 u32 changes);
> >  static void ath5k_sw_scan_start(struct ieee80211_hw *hw);
> >  static void ath5k_sw_scan_complete(struct ieee80211_hw *hw);
> > +static void ath5k_set_coverage_class(struct ieee80211_hw *hw,
> > +               u8 coverage_class);
> >
> >  static const struct ieee80211_ops ath5k_hw_ops = {
> >         .tx             = ath5k_tx,
> > @@ -274,6 +276,7 @@ static const struct ieee80211_ops ath5k_hw_ops = {
> >         .bss_info_changed = ath5k_bss_info_changed,
> >         .sw_scan_start  = ath5k_sw_scan_start,
> >         .sw_scan_complete = ath5k_sw_scan_complete,
> > +       .set_coverage_class = ath5k_set_coverage_class,
> >  };
> >
> >  /*
> > @@ -3274,3 +3277,23 @@ static void ath5k_sw_scan_complete(struct ieee80211_hw *hw)
> >         ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
> >                 AR5K_LED_ASSOC : AR5K_LED_INIT);
> >  }
> > +
> > +/**
> > + * ath5k_set_coverage_class - Set IEEE 802.11 coverage class
> > + *
> > + * @hw: struct ieee80211_hw pointer
> > + * @coverage_class: IEEE 802.11 coverage class number
> > + *
> > + * Mac80211 callback. Sets slot time, ACK timeout and CTS timeout for given
> > + * coverage class. The values are persistent, they are restored after device
> > + * reset.
> > + */
> > +static void ath5k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
> > +{
> > +       struct ath5k_softc *sc = hw->priv;
> > +
> > +       mutex_lock(&sc->lock);
> > +       ath5k_hw_set_coverage_class(sc->ah, coverage_class);
> > +       sc->ah->ah_coverage_class = coverage_class;
> 
> Can you move this last line setting the sc->ah->ah_coverage_class
> to ath5k_hw_set_coverage_class() instead? Although ath5k will likely

I meant will likely *not*

> require a real "hw module" split as we have in ath9k now ath9k_hw
> it would still be good to see this sort of stuff being done
> consistantly.

  Luis
