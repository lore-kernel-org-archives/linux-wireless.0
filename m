Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:55270 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0DNG43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 02:56:29 -0400
Subject: Re: [RFC PATCH 2/2] cfg80211: Remove default dynamic PS timeout
 value
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Julian Calaby <julian.calaby@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kalle.valo@iki.fi" <kalle.valo@iki.fi>
In-Reply-To: <q2u646765f41004132350zdd258fp1d59016dae8ecda6@mail.gmail.com>
References: <1271227264-26868-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271227264-26868-3-git-send-email-juuso.oikarinen@nokia.com>
	 <q2u646765f41004132350zdd258fp1d59016dae8ecda6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 09:51:51 +0300
Message-ID: <1271227911.10120.1263.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-04-14 at 08:50 +0200, ext Julian Calaby wrote:
> On Wed, Apr 14, 2010 at 16:41, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
> > Now that the mac80211 is choosing dynamic ps timeouts based on the ps-qos
> > network latency configuration, configure a default value of -1 as the dynamic
> > ps timeout in cfg80211. This value allows the mac80211 to determine the value
> > to be used.
> >
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> >  net/mac80211/mlme.c |    2 +-
> >  net/wireless/core.c |    3 ++-
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > index 22860bd..6c5c034 100644
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -514,7 +514,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
> >                if (timeout < 0) {
> >                        if (latency <= 50000)
> >                                timeout = 300;
> > -                       else if (latency <= 2000000)
> > +                       else if (latency <= 2000000000)
> >                                timeout = 100;
> >                        else
> >                                timeout = 0;
> 
> This doesn't seem to belong with the description.
> 
> Thanks,
> 

Oh, damn. I amended this fix to the incorrect one of the two patches.
Please stand by for v2.

-Juuso


