Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:53090 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbaAVLiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 06:38:07 -0500
Message-ID: <1390390684.4189.9.camel@porter.coelho.fi> (sfid-20140122_123812_365301_DD4EA617)
Subject: Re: [PATCH 2/7] mac80211: treat IBSS CSA finish failure seriously
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 22 Jan 2014 13:38:04 +0200
In-Reply-To: <1390316421.6199.25.camel@jlt4.sipsolutions.net>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140120_152540_652074_76AA6981) <1390316421.6199.25.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-21 at 16:00 +0100, Johannes Berg wrote:
> On Mon, 2014-01-20 at 15:21 +0100, Michal Kazior wrote:
> > Other interface modes are checked against failure.
> > This should avoid false-positive channel switch
> > events where IBSS CSA actually failed.
> > 
> > Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> > ---
> >  net/mac80211/cfg.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> > index 62bf6c4..76fe1f90 100644
> > --- a/net/mac80211/cfg.c
> > +++ b/net/mac80211/cfg.c
> > @@ -3039,7 +3039,9 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
> >  			return;
> >  		break;
> >  	case NL80211_IFTYPE_ADHOC:
> > -		ieee80211_ibss_finish_csa(sdata);
> > +		err = ieee80211_ibss_finish_csa(sdata);
> > +		if (err < 0)
> > +			return;
> 
> Looks fine, though I suppose this should then perhaps also return a
> changed bitmap to be used later. Ditto for mesh, I guess.

Yes, I agree.  I actually had started to work on some patches to align
all this, but I'll leave it to Michal. ;)

--
Luca.

