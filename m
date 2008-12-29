Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20491 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbYL2PpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 10:45:09 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 07:45:09 -0800
Date: Mon, 29 Dec 2008 07:44:53 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Sujith Manoharan <Sujith.Manoharan@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH v3 02/16] ath9k: use hw->conf on ath_setcurmode()
Message-ID: <20081229154453.GP5944@tesla> (sfid-20081229_164514_272855_3890EDA2)
References: <1230076731-22946-1-git-send-email-lrodriguez@atheros.com> <1230076731-22946-2-git-send-email-lrodriguez@atheros.com> <1230076731-22946-3-git-send-email-lrodriguez@atheros.com> <18776.21485.750323.652519@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <18776.21485.750323.652519@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 28, 2008 at 08:37:01PM -0800, Sujith Manoharan wrote:
> Luis Rodriguez wrote:
> > +       switch (conf->channel->band) {
> > +       case IEEE80211_BAND_2GHZ:
> > +               if (conf_is_ht20(conf))
> > +                       sc->cur_rate_table =
> > +                         sc->hw_rate_table[ATH9K_MODE_11NG_HT20];
> > +               else if (conf_is_ht40_minus(conf))
> > +                       sc->cur_rate_table =
> > +                         sc->hw_rate_table[ATH9K_MODE_11NG_HT40MINUS];
> > +               else if (conf_is_ht40_plus(conf))
> > +                       sc->cur_rate_table =
> > +                         sc->hw_rate_table[ATH9K_MODE_11NG_HT40PLUS];
> > +               else {
> > +                       sc->sc_protrix = 1;
> > +                       sc->cur_rate_table =
> > +                         sc->hw_rate_table[ATH9K_MODE_11G];
> > +               }
> > +               break;
> > +       case IEEE80211_BAND_5GHZ:
> > +               if (conf_is_ht20(conf))
> > +                       sc->cur_rate_table =
> > +                         sc->hw_rate_table[ATH9K_MODE_11NA_HT20];
> > +               else if (conf_is_ht40_minus(conf))
> > +                       sc->cur_rate_table =
> > +                         sc->hw_rate_table[ATH9K_MODE_11NA_HT40MINUS];
> > +               else if (conf_is_ht40_plus(conf))
> > +                       sc->cur_rate_table =
> > +                         sc->hw_rate_table[ATH9K_MODE_11NA_HT40PLUS];
> > +               else
> > +                       sc->cur_rate_table = sc->hw_rate_table[ATH9K_MODE_11A];
> > +               break;
> > +       default:
> > +               break;
> > +       }
> >  }
> 
> We don't have separate rate tables for ht20, ht40+, ht40-.
> Setting cur_rate_table just once using conf_is_ht() to any HT mode would suffice.

I do see we have different rate tables for these though, do you mean we can
consolidate on the rate tables?

  Luis
