Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2DVRpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 13:45:55 -0400
Message-ID: <1335116748.3450.0.camel@jlt3.sipsolutions.net> (sfid-20120422_194611_660755_04F73E12)
Subject: Re: [PATCH 1/1] mac80211: check for non-managed interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Date: Sun, 22 Apr 2012 19:45:48 +0200
In-Reply-To: <CANUX_P3EUTKsJG=J6tqZMNULbm3E+q8hTbtFz3emQyS8bN7sQw@mail.gmail.com> (sfid-20120422_190147_496942_E2822878)
References: <1335110415-12695-1-git-send-email-wey-yi.w.guy@intel.com>
	 <CANUX_P3EUTKsJG=J6tqZMNULbm3E+q8hTbtFz3emQyS8bN7sQw@mail.gmail.com>
	 (sfid-20120422_190147_496942_E2822878)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-04-22 at 20:01 +0300, Emmanuel Grumbach wrote:
> On Sun, Apr 22, 2012 at 19:00, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> > Average beacon signal only keep tracked by managed interface,
> > give warning and return 0 for the others.
> >
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > ---
> >  net/mac80211/util.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> >
> > diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> > index 89c1e5b..2cbcb6a 100644
> > --- a/net/mac80211/util.c
> > +++ b/net/mac80211/util.c
> > @@ -1799,5 +1799,10 @@ int ieee80211_ave_rssi(struct ieee80211_vif *vif)
> >        struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> >        struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> >
> > +       if (sdata->vif.type != NL80211_IFTYPE_STATION) {
> > +               /* non-managed type inferfaces */
> > +               WARN_ON(1);
> 
> WARN_ON_ONCE ?
> We don't need to flood the kernel log here

if (WARN_ON_ONCE(...))

would also be nicer :-)

johannes

