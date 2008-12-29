Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18774 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbYL2PrM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 10:47:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 07:47:12 -0800
Date: Mon, 29 Dec 2008 07:46:57 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Sujith Manoharan <Sujith.Manoharan@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH v3 07/16] ath9k: use ieee80211_conf on
	ath9k_hw_iscal_supported()
Message-ID: <20081229154657.GQ5944@tesla> (sfid-20081229_164717_197511_7BE5D8A3)
References: <1230076731-22946-1-git-send-email-lrodriguez@atheros.com> <1230076731-22946-2-git-send-email-lrodriguez@atheros.com> <1230076731-22946-3-git-send-email-lrodriguez@atheros.com> <1230076731-22946-4-git-send-email-lrodriguez@atheros.com> <1230076731-22946-5-git-send-email-lrodriguez@atheros.com> <1230076731-22946-6-git-send-email-lrodriguez@atheros.com> <1230076731-22946-7-git-send-email-lrodriguez@atheros.com> <1230076731-22946-8-git-send-email-lrodriguez@atheros.com> <18776.21554.302227.967726@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <18776.21554.302227.967726@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 28, 2008 at 08:38:10PM -0800, Sujith Manoharan wrote:
> Luis Rodriguez wrote:
> > -       case IQ_MISMATCH_CAL:
> > -               if (!IS_CHAN_B(chan))
> > -                       retval = true;
> > -               break;
> > +       case IQ_MISMATCH_CAL: /* Both 2 GHz and 5 GHz support OFDM */
> > +               return true;
> >         case ADC_GAIN_CAL:
> >         case ADC_DC_CAL:
> > -               if (!IS_CHAN_B(chan)
> > -                   && !(IS_CHAN_2GHZ(chan) && IS_CHAN_HT20(chan)))
> > -                       retval = true;
> > +               if (conf->channel->band == IEEE80211_BAND_5GHZ &&
> > +                 conf_is_ht20(conf))
> > +                       return true;
> >                 break;
> >         }
> 
> Why are the IS_CHAN_B() checks removed ?

Because 1) it will currently never happen 2) we need a better check for is CCK in mac80211, not
an internal check.

  Luis
