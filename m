Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:30359 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756236AbYAUB5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 20:57:30 -0500
From: bruno randolf <bruno@thinktube.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Mon, 21 Jan 2008 10:57:21 +0900
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Ivo van Doorn" <ivdoorn@gmail.com>,
	"Ulrich Kunitz" <kune@deine-taler.de>,
	"Daniel Drake" <dsd@gentoo.org>
References: <20080118125252.6455.41047.stgit@one> <43e72e890801200217i7a7e5349uebf56d42c63cf48e@mail.gmail.com>
In-Reply-To: <43e72e890801200217i7a7e5349uebf56d42c63cf48e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801211057.21619.bruno@thinktube.com> (sfid-20080121_015734_231778_87B3C86D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 20 January 2008 19:17:04 Luis R. Rodriguez wrote:
> Adding Johill and Michael as they are maintainers of mac80211 and they
> need to review this. Please add them on further mac80211 patches.

oh, sorry. sure!

> On Jan 18, 2008 7:52 AM, Bruno Randolf <bruno@thinktube.com> wrote:
> > +
> > +       /* check if we need to merge IBSS */
> > +       if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && beacon &&
> > +           !local->sta_sw_scanning && !local->sta_hw_scanning &&
> > +           mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
> > +           memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len)
> > == 0) { +#ifdef CONFIG_MAC80211_IBSS_DEBUG
> > +               static unsigned long last_tsf_debug;
> > +#endif
> > +               if (rx_status->flag & RX_FLAG_TSFT)
> > +                       mactime = rx_status->mactime;
> > +               else {
> > +                       mactime = -1LLU;
> > +                       printk(KERN_WARNING "%s: IBSS mode needs mactime
> > for " +                               "beacons\n", dev->name);
>
> Does this merit a WARN_ON() ? This essentially will prevent IBSS
> merges for drivers that haven't set mactime yet.
>
> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > index 6cc1e7e..5617e17 100644
> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> > @@ -1609,7 +1609,10 @@ static int prepare_for_handlers(struct
> > ieee80211_sub_if_data *sdata, case IEEE80211_IF_TYPE_IBSS:
> >                 if (!bssid)
> >                         return 0;
> > -               if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
> > +               if ((rx->fc & IEEE80211_FCTL_FTYPE) ==
> > IEEE80211_FTYPE_MGMT && +                   (rx->fc &
> > IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
>
> Since we are letting all beacons through how about adding a check for
> ssid on ieee80211_rx_bss_info()?
>
> (memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) == 0)
>
> Just not sure exactly we'd check for it yet.

sure, that's in the previous part of the patch:

> > +           mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
> > +           memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len)
> > == 0) 

greetings,
bruno
