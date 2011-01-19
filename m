Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:28696 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753636Ab1ASLw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 06:52:27 -0500
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0706147946
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 20:52:26 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 5/8] ath5k: Add 802.11j 4.9GHz channels to allowed channels
Date: Wed, 19 Jan 2011 20:52:53 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6> <20110119092057.19628.9296.stgit@localhost6.localdomain6> <AANLkTi=2crGZhucAhNHU-iaOkRamg33tQo_-K5h9d64v@mail.gmail.com>
In-Reply-To: <AANLkTi=2crGZhucAhNHU-iaOkRamg33tQo_-K5h9d64v@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101192052.53702.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed January 19 2011 20:14:41 Bob Copeland wrote:
> On Wed, Jan 19, 2011 at 4:20 AM, Bruno Randolf <br1@einfach.org> wrote:
> > Add the 802.11j (20MHz channel width) channels to the allowed channels.
> > This still does not enable 802.11j in ath5k since these frequencies are
> > out of the configured range. A later patch will deal with that.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > ---
> > 
> > -static bool ath5k_is_standard_channel(short chan)
> > +static bool ath5k_is_standard_channel(short chan, enum ieee80211_band
> > band) {
> > -       return ((chan <= 14) ||
> > -               /* UNII 1,2 */
> > -               ((chan & 3) == 0 && chan >= 36 && chan <= 64) ||
> > +       if (band == IEEE80211_BAND_2GHZ && chan <= 14)
> > +               return true;
> 
> This routine is only used to post-filter the channels so I don't
> think we need to check the band.  It's mostly just to weed out all
> of the 10 mhz-spaced 5 ghz channels we used to export.
> 
> > -               ((chan & 3) == 1 && chan >= 149 && chan <= 165));
> > +               ((chan & 3) == 1 && chan >= 149 && chan <= 165) ||
> > +               /* 802.11j 5.030-5.080 GHz (20MHz) */
> > +               (chan == 8 || chan == 12 || chan == 16) ||
> 
> Ok I was also going to complain that some channel numbers < 14 were
> valid in the 5 ghz band but you know that :)

That's also the reason why we need to know the band:

in 2GHz all channels < 14 are allowed.
in 5GHz only a few.

Thanks for your review!

bruno
