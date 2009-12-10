Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51872 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758909AbZLJAPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 19:15:12 -0500
Date: Wed, 9 Dec 2009 19:06:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com
Subject: Re: [PATCH] wireless: update old static regulatory domain rules
Message-ID: <20091210000612.GA8515@tuxdriver.com>
References: <1260389724-2392-1-git-send-email-linville@tuxdriver.com> <646765f40912091437y22d322c6m295cff07a95c4ebe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <646765f40912091437y22d322c6m295cff07a95c4ebe@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 10, 2009 at 09:37:25AM +1100, Julian Calaby wrote:
> On Thu, Dec 10, 2009 at 07:15, John W. Linville <linville@tuxdriver.com> wrote:
> > Update "US" and "JP" for current rules, and replace "EU" rules with the
> > world roaming domain (since it was only a pseudo-domain anyway).
> >
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> >  net/wireless/reg.c |   75 +++++++++++++++++----------------------------------
> >  1 files changed, 25 insertions(+), 50 deletions(-)
> >
> > diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> > index c01470e..baa898a 100644
> > --- a/net/wireless/reg.c
> > +++ b/net/wireless/reg.c
> > @@ -206,15 +179,17 @@ static const struct ieee80211_regdomain *static_regdom(char *alpha2)
> >                return &us_regdom;
> >        if (alpha2[0] == 'J' && alpha2[1] == 'P')
> >                return &jp_regdom;
> > +       /* Use world roaming rules for "EU", since it was a pseudo
> > +          domain anyway... */
> >        if (alpha2[0] == 'E' && alpha2[1] == 'U')
> > -               return &eu_regdom;
> > -       /* Default, as per the old rules */
> > -       return &us_regdom;
> > +               return &world_regdom;
> > +       /* Default, world roaming rules */
> > +       return &world_regdom;
> >  }
> 
> Is the if statement for the "EU" regdom really necessary (except as
> documentation) as we're returning &world_regdom by default?

No, it's not necessary except as documentation.  However, I like it
just for that reason. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
