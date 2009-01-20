Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55420 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZATTzT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 14:55:19 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 11:55:19 -0800
Date: Tue, 20 Jan 2009 11:54:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] mac80211: Add capability to enable/disable beaconing
Message-ID: <20090120195444.GE19581@tesla> (sfid-20090120_205524_910071_583A1DDA)
References: <18805.33791.193195.755178@gargle.gargle.HOWL> <1232448779.20158.4.camel@johannes.local> <18805.62728.34610.424793@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <18805.62728.34610.424793@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 08:00:08AM -0800, Sujith wrote:
> Johannes Berg wrote:
> > cOn Tue, 2009-01-20 at 13:27 +0530, Sujith wrote:
> > > This patch adds a flag to notify drivers to start and
> > > stop beaconing when needed, for example, during a scan run.
> >
> >
> > > +   if ((changed & IEEE80211_IFCC_BEACON) &&
> > > +       (sdata->vif.type == NL80211_IFTYPE_AP ||
> > > +        sdata->vif.type == NL80211_IFTYPE_ADHOC ||
> > > +        sdata->vif.type == NL80211_IFTYPE_MESH_POINT)) {
> > > +           if (local->sw_scanning || local->hw_scanning)
> > > +                   conf.enable_beacon = false;
> > > +           else
> > > +                   conf.enable_beacon = true;
> > > +   }
> > > +
> >
> > You really just want to do the minimal thing, right? :)
> 
> Oh, absolutely :)
> 
> > That won't work when userspace disables the beacon by removing it, for
> > instance, right now drivers won't know when hostapd removed the beacon
> > except that ieee80211_beacon_get will start returning 0... Also, I think
> > a separate change flag would be appropriate, sometimes we might just
> > re-enable the beacon without having changed it, after scanning?
> 
> Ok, how about this ?
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 9a5869e..72a3025 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -624,12 +624,18 @@ struct ieee80211_if_init_conf {
>   * enum ieee80211_if_conf_change - interface config change flags
>   *
>   * @IEEE80211_IFCC_BSSID: The BSSID changed.
> - * @IEEE80211_IFCC_BEACON: The beacon for this interface changed
> - *     (currently AP and MESH only), use ieee80211_beacon_get().
> + * @IEEE80211_IFCC_CONFIGURE_BEACON: The beacon for this interface changed
> + *     (currently AP,IBSS and MESH only), use ieee80211_beacon_get().
> + * @IEEE80211_IFCC_STOP_BEACON: Indicates that beaconing should be stopped
> + *     by the driver.
> + * @IEEE80211_IFCC_RESUME_BEACON: Beaconing can be resumed by the driver,
> + *     with the original template obtained from mac80211.
>   */
>  enum ieee80211_if_conf_change {
> -       IEEE80211_IFCC_BSSID    = BIT(0),
> -       IEEE80211_IFCC_BEACON   = BIT(1),
> +       IEEE80211_IFCC_BSSID            = BIT(0),
> +       IEEE80211_IFCC_CONFIGURE_BEACON = BIT(1),
> +       IEEE80211_IFCC_STOP_BEACON      = BIT(2),
> +       IEEE80211_IFCC_RESUME_BEACON    = BIT(3)

This would make grep'ing easier:

IEEE80211_IFCC_BEACON_CONFIGURE = BIT(1),
IEEE80211_IFCC_BEACON_STOP      = BIT(2),
IEEE80211_IFCC_BEACON_RESUME    = BIT(3)

  Luis
