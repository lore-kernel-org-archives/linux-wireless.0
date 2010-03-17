Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:49617 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab0CQFs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 01:48:28 -0400
Subject: Re: [RFC PATCHv2 1/1] mac80211: Add support connection monitor in
 hardware
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1268775935.8918.2.camel@jlt3.sipsolutions.net>
References: <1268650643-23191-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268650643-23191-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1268775935.8918.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 07:44:31 +0200
Message-ID: <1268804671.10120.584.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-16 at 22:45 +0100, ext Johannes Berg wrote:
> On Mon, 2010-03-15 at 12:57 +0200, Juuso Oikarinen wrote:
> > This patch is based on a RFC patch by Kalle Valo.
> > 
> > The wl1271 has a feature which handles the connection monitor logic
> > in hardware, basically sending periodically nullfunc frames and reporting
> > to the host if AP is lost, after attempting to recover by sending
> > probe-requests to the AP.
> > 
> > Add support to mac80211 by adding a new flag IEEE80211_HW_CONNECTION_MONITOR
> > which prevents conn_mon_timer from triggering during idle periods, and
> > prevents sending probe-requests to the AP if beacon-loss is indicated by the
> > hardware.
> > 
> > Cc: Kalle Valo <kalle.valo@nokia.com>
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> >  include/net/mac80211.h |    4 ++++
> >  net/mac80211/mlme.c    |   33 ++++++++++++++++++++++++++++++++-
> >  2 files changed, 36 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> > index 936bc41..cd7b471 100644
> > --- a/include/net/mac80211.h
> > +++ b/include/net/mac80211.h
> > @@ -954,6 +954,9 @@ enum ieee80211_tkip_key_type {
> >   *	Hardware can provide ack status reports of Tx frames to
> >   *	the stack.
> >   *
> > + * @IEEE80211_HW_CONNECTION_MONITOR:
> > + *      The hardware performs its own connection monitoring, including
> > + *      periodic keep-alives to the AP and probing the AP on beacon loss.
> 
> I think this should mention that you get disconnected right away when
> you then signal beacon loss with the mac80211 api call, which is new.
> Might also be worth updating the API docs for that function.

Yes, those are still missing. I'll add those to v3.

> > @@ -936,8 +939,36 @@ void ieee80211_beacon_loss_work(struct work_struct *work)
> >  	struct ieee80211_sub_if_data *sdata =
> >  		container_of(work, struct ieee80211_sub_if_data,
> >  			     u.mgd.beacon_loss_work);
> > +	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> > +	struct ieee80211_local *local = sdata->local;
> > +	u8 bssid[ETH_ALEN];
> > +
> > +	if (!(sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR))
> > +		ieee80211_mgd_probe_ap(sdata, true);
> > +	else {
> > +		mutex_lock(&ifmgd->mtx);
> > +		if (!ifmgd->associated) {
> > +			mutex_unlock(&ifmgd->mtx);
> > +			return;
> > +		}
> >  
> > -	ieee80211_mgd_probe_ap(sdata, true);
> > +		memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
> > +
> > +		printk(KERN_DEBUG "No probe-response from AP %pM, "
> > +		       "disconnected.\n", bssid);
> > +
> > +		ieee80211_set_disassoc(sdata);
> > +		ieee80211_recalc_idle(local);
> > +		mutex_unlock(&ifmgd->mtx);
> > +		/*
> > +		 * must be outside lock due to cfg80211,
> > +		 * but that's not a problem.
> > +		 */
> > +		ieee80211_send_deauth_disassoc(sdata, bssid,
> > +					       IEEE80211_STYPE_DEAUTH,
> > +					       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
> > +					       NULL);
> > +	}
> 
> This !() is a little awkward, how about moving this to a new function?
> and the message is also really misleading.

Technically, the message is not misleading at least for the hw I'm
working with (as it will send probe-requests to the AP similarly as the
mac80211 would in this case) but I'll try to figure out something more
generic fort this.

I'll try to address these still for v3.

-Juuso

> johannes
> 


