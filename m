Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55628 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3AaQsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 11:48:11 -0500
Message-ID: <1359650902.8415.93.camel@jlt4.sipsolutions.net> (sfid-20130131_174815_135838_F691B747)
Subject: Re: [PATCHv7 2/3] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 31 Jan 2013 17:48:22 +0100
In-Reply-To: <20130131163126.GB1387@pandem0nium>
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359643448.8415.62.camel@jlt4.sipsolutions.net>
	 <20130131163126.GB1387@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 17:31 +0100, Simon Wunderlich wrote:

> > > +void ieee80211_dfs_cac_timer_work(struct work_struct *work)
> > > +{
> > > +	struct delayed_work *delayed_work =
> > > +		container_of(work, struct delayed_work, work);
> > > +	struct ieee80211_sub_if_data *sdata =
> > > +		container_of(delayed_work, struct ieee80211_sub_if_data,
> > > +			     dfs_cac_timer_work);
> > > +
> > > +	rtnl_lock();
> > 
> > what part requires rtnl?
> > 
> ieee80211_vif_release_channel() calls __ieee80211_vif_release_channel()
> and has ASSERT_RTNL() before parsing the AP VLAN list.
> 
> cfg80211_radar_event() probably doesn't need it ... I should remove it
> from the rtnl lock, I guess?

Doesn't really matter, I was just wondering in general but the AP VLAN
list makes sense.

> > > +void ieee80211_radar_detected(struct ieee80211_vif *vif, gfp_t gfp)
> > > +{
> > > +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> > > +
> > > +	trace_api_radar_detected(sdata);
> > > +
> > > +	/* may happen to devices which have been added but are not up */
> > > +	if (!cfg80211_chandef_valid(&sdata->vif.bss_conf.chandef))
> > > +		return;
> > 
> > Huh, what does device and up have to do with that?
> > 
> 
> What I've tried:
>  * configure 2 SSIDs in hostapd, start it
>  * both wlan0 and wlan0-1 got created
>  * only wlan0 comes up, wlan0-1 was rejected because of missing channel combinations
>  * now I've injected a radar - which should be sent to wlan0 and wlan0-1
>  * wlan0 could send the event, but wlan0-1 had no bss configured and therefore no chandef
> 
> I can change this comment to "may happen to devices which have currently no BSS configured",
> maybe that it is not so confusing ...

Not sure I understand, how would the radar detected event come to an
interface that doesn't really exist for the driver?

johannes

