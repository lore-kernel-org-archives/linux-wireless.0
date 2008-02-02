Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:57644 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYBBVfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 16:35:42 -0500
Received: by py-out-1112.google.com with SMTP id u52so2367538pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 13:35:41 -0800 (PST)
Message-ID: <43e72e890802021335g181e76e9gf95356ac729ad6d9@mail.gmail.com> (sfid-20080202_213548_137844_B83D987C)
Date: Sat, 2 Feb 2008 16:35:39 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: Cleanup after API changes patch
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com,
	johannes@sipsolutions.net
In-Reply-To: <47A33ECA.5030005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080201012544.GD28995@ruslug.rutgers.edu>
	 <47A33ECA.5030005@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 1, 2008 10:46 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 02/01/2008 02:25 AM, Luis R. Rodriguez wrote:
> > Cleanup after API changes patch (checkpatch.pl stuff) and on
> > ath5k_hw_rf5112_channel() make use of the new channel->band and
> > existing ath5k_channel_ok() instead of re-implementing the checks
> > again. This was necessary to make the code cleaner and fit
> > the 80-chars wide limit so sending it within the same patch.
> >
> > Finally make a note that we should eventually move cap_range stuff
> > to struct wiphy.
> >
> > This patch applies ontop of Nick's API changes patch.
> >
> > Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
> >
> > drivers/net/wireless/ath5k/ath5k.h:   Changes-licensed-under: ISC
> > drivers/net/wireless/ath5k/base.c:    Changes-licensed-under: 3-Clause-BSD
> > drivers/net/wireless/ath5k/initvals.c:        Changes-licensed-under: ISC
> > drivers/net/wireless/ath5k/phy.c:     Changes-licensed-under: ISC
> > ---
> >  drivers/net/wireless/ath5k/ath5k.h    |    8 ++-
> >  drivers/net/wireless/ath5k/base.c     |  126 +++++++++++++++++++--------------
> >  drivers/net/wireless/ath5k/initvals.c |    6 +-
> >  drivers/net/wireless/ath5k/phy.c      |   48 +++++++++----
> >  4 files changed, 118 insertions(+), 70 deletions(-)
> >
> [...]
> > diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> > index 8ddac36..bd9c9a8 100644
> > --- a/drivers/net/wireless/ath5k/base.c
> > +++ b/drivers/net/wireless/ath5k/base.c
> [...]
> > @@ -889,13 +900,15 @@ ath5k_copy_channels(struct ath5k_hw *ah,
> >               /* Write channel info and increment counter */
> >               channels[count].center_freq = freq;
> >
> > -             if((mode == AR5K_MODE_11A) ||
> > -             (mode == AR5K_MODE_11G)){
> > -                     channels[count].hw_value = chfreq|CHANNEL_OFDM;
> > -             } else if((mode == AR5K_MODE_11A_TURBO) ||
> > -             (mode == AR5K_MODE_11G_TURBO)){
> > -                     channels[count].hw_value = chfreq|CHANNEL_OFDM|CHANNEL_TURBO;
> > -             }if(mode == AR5K_MODE_11B) {
> > +             if ((mode == AR5K_MODE_11A) ||
> > +                     (mode == AR5K_MODE_11G)) {
> > +                     channels[count].hw_value =
> > +                             chfreq | CHANNEL_OFDM;
> > +             } else if ((mode == AR5K_MODE_11A_TURBO) ||
> > +                     (mode == AR5K_MODE_11G_TURBO)) {
> > +                     channels[count].hw_value =
> > +                             chfreq | CHANNEL_OFDM|CHANNEL_TURBO;
> > +             } if (mode == AR5K_MODE_11B) {
>
> 'else' or '\n' before the if, please

Good catch, that should have been an "else if" there. Will repost all
pending patches in a series addressing all posted comments.

  Luis
