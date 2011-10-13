Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab1JMKuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 06:50:00 -0400
Subject: Re: [RFC 02/07] compat-wireless: Connection quality monitor
 extensions
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	linux-wireless@vger.kernel.org,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
In-Reply-To: <CAFED-jk8xp62A8cyR1qbbFzfM1AJRMUzGQ1Z3b4pDGdBPWYOrw@mail.gmail.com> (sfid-20111013_124236_591211_FD237BC0)
References: <op.v27rulkhya27un@edmitar>
	 <1318407677.3933.18.camel@jlt3.sipsolutions.net>
	 <CAFED-jk8xp62A8cyR1qbbFzfM1AJRMUzGQ1Z3b4pDGdBPWYOrw@mail.gmail.com>
	 (sfid-20111013_124236_591211_FD237BC0)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 12:49:55 +0200
Message-ID: <1318502995.5612.15.camel@jlt3.sipsolutions.net> (sfid-20111013_125004_181914_29B1A22E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Please trim your quotes. There's no point in quoting all of the email to
reply to specific points.


> >> +++ b/include/linux/nl80211.h
> >> @@ -2311,6 +2311,14 @@ enum nl80211_ps_state {
> >>    * @NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT: RSSI threshold event
> >>    * @NL80211_ATTR_CQM_PKT_LOSS_EVENT: a u32 value indicating that this many
> >>    *  consecutive packets were not acknowledged by the peer
> >> + * @NL80211_ATTR_CQM_BEACON_MISS_THOLD: BEACON threshold. This value
> >> specifies
> >> + *   the threshold for the BEACON loss level at which an event will be
> >> + *   sent. Zero to disable.
> >
> > Should it really be zero to disable rather than leaving it out to
> > disable?
> 
> Similar like in case of NL80211_ATTR_CQM_RSSI_
> Usefull to disable in run-time also - when associated.

I don't think you understood my question, but I think it's actually OK
as is so you can change other config w/o disabling this.

> >> + * @NL80211_ATTR_CQM_BEACON_MISS_THOLD_EVENT: BEACON miss event
> >> + * @NL80211_ATTR_CQM_TX_FAIL_THOLD: TX threshold. This value specifies the
> >> + *   the threshold for the TX loss level at which an event will be
> >> + *   sent. Zero to disable.
> >> + * @NL80211_ATTR_CQM_TX_FAIL_THOLD_EVENT: TX threshold event
> >
> > How's this not the same as PKT_LOSS_EVENT?
> 
> Based on supplicant code - this is mapped to EVENT_STATION_LOW_ACK.
> Seems used only in case we are GO/AP and not configurable from user space.
> I think possible to reuse PKT_LOSS_EVENT.
> But still new HW_FLAGS is required for that and counter configuration
> from user space could be usefull.

Yeah so add the config for PKT_LOSS_EVENT.

> >> +     if (!(local->hw.flags &
> IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS)) {
> >> +             if (sdata->vif.type != NL80211_IFTYPE_STATION)
> >> +                     return -EOPNOTSUPP;
> >> +             return 0;
> >
> > This looks/is wrong in multiple ways.
> 
> 
> Could you add more description here - this is almost the same like
> ieee80211_set_cqm_rssi_config() fuction.

Well so evidently this accepts the config if the HW supports it and the
interface type isn't station -- that's bad.

Also, I haven't seen any evidence that you implemented support for this
in mac80211 if the device doesn't support it, so you can't do it this
way.

> >> -             } else {
> >> +             } else if (!(local->hw.flags &
> >> +                             IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS) &&
> >> +                        !(local->hw.flags &
> >> +                             IEEE80211_HW_SUPPORTS_CQM_TX_FAIL)) {
> >>                       /*
> >>                        * We actually lost the connection ... or did we?
> >>                        * Let's make sure!
> >
> > explain.
> 
> In case of BEACON_MISS we should not report connection_loss to upper
> layer, we should only notify about beacon_miss and give a chance to
> roam without disconnection. Without that first we will see
> disconnection in wpa_supplicant. Next if roam will fail and driver
> support IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS should report this
> connection_lost by itself via ieee80211_connection_loss().

So then the test is wrong -- it has to be dependent on wpa_s actually
having asked for this.


I really don't want to be reviewing this with so many basic errors. It
looks like you blindly copied parts of the other CQM things without
understanding what they do. Please find somebody else to review &
explain things with you first, I can't do that at this point.

johannes

