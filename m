Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40274 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab0K3F0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 00:26:44 -0500
Subject: Re: [PATCH] mac80211: Fix frame injection using non-AP vif
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=D5ynvBGNLQnTJmpuBQHySVdudTkM9LughnT-o@mail.gmail.com>
References: <20101126184155.GA2689@jm.kir.nu>
	 <AANLkTi=D5ynvBGNLQnTJmpuBQHySVdudTkM9LughnT-o@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 06:26:39 +0100
Message-ID: <1291094799.3624.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-29 at 13:49 -0800, Luis R. Rodriguez wrote:
> On Fri, Nov 26, 2010 at 10:41 AM, Jouni Malinen
> <jouni.malinen@atheros.com> wrote:
> > In order for frame injection to work properly for some use cases
> > (e.g., finding the station entry and keys for encryption), mac80211
> > needs to find the correct sdata entry. This works when the main vif
> > is in AP mode, but commit a2c1e3dad516618cb0fbfb1a62c36d0b0744573a
> > broke this particular use case for station main vif. While this type of
> > injection is quite unusual operation, it has some uses and we should fix
> > it. Do this by changing the monitor vif sdata selection to allow station
> > vif to be selected instead of limiting it to just AP vifs. We still need
> > to skip some iftypes to avoid selecting unsuitable vif for injection.
> >
> > Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
> >
> > ---
> >  net/mac80211/tx.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > --- wireless-testing.orig/net/mac80211/tx.c     2010-11-26 20:21:02.000000000 +0200
> > +++ wireless-testing/net/mac80211/tx.c  2010-11-26 20:36:22.000000000 +0200
> > @@ -1595,7 +1595,12 @@ static void ieee80211_xmit(struct ieee80
> >                                                list) {
> >                                if (!ieee80211_sdata_running(tmp_sdata))
> >                                        continue;
> > -                               if (tmp_sdata->vif.type != NL80211_IFTYPE_AP)
> > +                               if (tmp_sdata->vif.type ==
> > +                                   NL80211_IFTYPE_MONITOR ||
> 
> Ah, for some reason I thought we were able to push frames as a monitor
> all along, no wonder packetspammer didn't work, or should it?

That'll still work -- it just won't encrypt the frames correctly where
necessary for a primary *station* interface.

johannes

