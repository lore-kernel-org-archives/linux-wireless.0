Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:12516 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752169Ab0L1Jn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 04:43:59 -0500
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0149859437
	for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 18:43:58 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Dave Kilroy <kilroyd@googlemail.com>
Subject: Re: [PATCH RFC] mac80211: Extend channel to frequency mapping for 802.11j
Date: Tue, 28 Dec 2010 18:43:57 +0900
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20101224074410.16337.90008.stgit@localhost6.localdomain6> <AANLkTi=R58EGLrsT5sTk7JTqWvaeJ5caytHMt3VCSOki@mail.gmail.com>
In-Reply-To: <AANLkTi=R58EGLrsT5sTk7JTqWvaeJ5caytHMt3VCSOki@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012281843.57453.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat December 25 2010 01:46:00 Dave Kilroy wrote:
> On Fri, Dec 24, 2010 at 7:44 AM, Bruno Randolf <br1@einfach.org> wrote:
> > Extend channel to frequency mapping for 802.11j Japan 4.9GHz band,
> > according to IEEE802.11 section 17.3.8.3.2 and Annex J. Because there
> > are now overlapping channel numbers in the 2GHz and 5GHz band we can't
> > map from channel to frequency without knowing the band. This is no
> > problem as in most contexts we know the band. In places where we don't
> > know the band (and WEXT compatibility) we assume the 2GHz band for
> > channels below 14.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > ---
> > -int ieee80211_channel_to_frequency(int chan)
> > +int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band)
> >  {
> > -       if (chan < 14)
> > -               return 2407 + chan * 5;
> > -
> > -       if (chan == 14)
> > -               return 2484;
> > -
> > -       /* FIXME: 802.11j 17.3.8.3.2 */
> > -       return (chan + 1000) * 5;
> > +       /* see 802.11 17.3.8.3.2 and Annex J
> > +        * there are overlapping channel numbers in 5GHz and 2GHz bands
> > */ +       if (band == IEEE80211_BAND_5GHZ) {
> > +               if (chan >= 182 && chan <= 196)
> > +                       return 4000 + chan * 5;
> > +               else
> > +                       return 5000 + chan * 5;
> > +       } else { /* IEEE80211_BAND_2GHZ */
> > +               if (chan == 14)
> > +                       return 2484;
> > +               else if (chan < 14)
> > +                       return 2407 + chan * 5;
> > +               else
> > +                       return 0; /* not supported */
> > +       }
> >  }
> >  EXPORT_SYMBOL(ieee80211_channel_to_frequency);
> > 
> >  int ieee80211_frequency_to_channel(int freq)
> >  {
> > +       /* see 802.11 17.3.8.3.2 and Annex J */
> >        if (freq == 2484)
> >                return 14;
> > -
> > -       if (freq < 2484)
> > +       else if (freq < 2484)
> >                return (freq - 2407) / 5;
> > -
> > -       /* FIXME: 802.11j 17.3.8.3.2 */
> > -       return freq/5 - 1000;
> > +       else if (freq >= 4910 && freq <= 4980)
> > +               return (freq - 4000) / 5;
> > +       else
> > +               return (freq - 5000) / 5;
> >  }
> >  EXPORT_SYMBOL(ieee80211_frequency_to_channel);
> 
> You don't have to use them, but there are a few channel/frequency
> conversion routines in include/ieee80211.h which could be reused in
> these functions.

Thanks for that info, I didn't know about those functions. I just checked 
them and it seems most of them are not used, AFAICT:

ieee80211_fhss_chan_to_freq - not used
ieee80211_freq_to_fhss_chan - not used
ieee80211_hr_chan_to_freq - not used
ieee80211_freq_to_hr_chan - not used
ieee80211_erp_chan_to_freq - not used
ieee80211_freq_to_erp_chan - not used
ieee80211_ofdm_chan_to_freq - not used
ieee80211_freq_to_ofdm_chan - not used

The only two which are used are for 2GHz channels:

ieee80211_dsss_chan_to_freq - atmel, airo, wl3501_cs, orinoco, rndis_wlan
ieee80211_freq_to_dsss_chan - atmel, airo, orinoco, zd1201

Anyhow i guess it would make sense to have a common channel to frequency 
mapping function for mac80211 and other wireless drivers? The problem is now 
we have to use enum ieee80211_band which is defined cfg80211.h...

Any opinions?

bruno
