Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYLIP7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 10:59:41 -0500
Subject: Re: [PATCH 1/2] mac80211: add suspend/resume callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <20081209152908.M73523@bobcopeland.com>
References: <1227415286-30179-2-git-send-email-me@bobcopeland.com>
	 (sfid-20081123_054218_217354_D63E2DF4) <1227431953.3599.37.camel@johannes.berg>
	 <20081209152908.M73523@bobcopeland.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hsk9eZE2Cee4dqIfVNZy"
Date: Tue, 09 Dec 2008 16:59:06 +0100
Message-Id: <1228838346.1029.10.camel@johannes.berg> (sfid-20081209_165945_750562_CE78EDD9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hsk9eZE2Cee4dqIfVNZy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 10:40 -0500, Bob Copeland wrote:
> On Sun, 23 Nov 2008 10:19:13 +0100, Johannes Berg wrote
> > I think this should run through interfaces twice, in the first run to
> > remove keys, then remove stas and then in the second run remove the
> > interfaces, because otherwise you may be having keys left when the sta
> > for which the key was has been removed.
>=20
> Is this what you had in mind? (now on top of your cfg80211 patch, btw
> it called ->suspend() in the resume hook)

Can you adopt that patch too?

> I tested this with ath5k, it works in the sense that device suspends and
> resumes without any hangs or errors.
>=20
> However, netif_running(sdata->dev) seems to randomly be false for wlan0 o=
n
> the resume side so the interface doesn't always come up.  I haven't had
> time to track that down but it's not consistent.

I think it's just a bug below?

> +int __ieee80211_suspend(struct ieee80211_hw *hw)
> +{
> +	struct ieee80211_local *local =3D hw_to_local(hw);
> +	struct ieee80211_sub_if_data *sdata;
> +	struct ieee80211_if_init_conf conf;
> +	struct sta_info *sta;
> +
> +	printk(KERN_DEBUG "mac80211: suspending\n");
> +
> +	flush_workqueue(local->hw.workqueue);
> +
> +	/* disable keys */
> +	list_for_each_entry(sdata, &local->interfaces, list)
> +		ieee80211_disable_keys(sdata);
> +
> +	/* remove STAs */
> +	list_for_each_entry(sta, &local->sta_list, list) {
> +
> +		/* disable aggregation */
> +		ieee80211_sta_tear_down_BA_sessions(sdata, sta->sta.addr);
> +
> +		if (local->ops->sta_notify) {
> +			if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
> +				sdata =3D container_of(sdata->bss,
> +					     struct ieee80211_sub_if_data,
> +					     u.ap);
> +
> +			local->ops->sta_notify(hw, &sdata->vif,
> +				STA_NOTIFY_REMOVE, &sta->sta);
> +		}
> +	}

That looks pretty good.

> +	/* remove all interfaces */
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +
> +		if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN &&
> +		    sdata->vif.type =3D=3D NL80211_IFTYPE_MONITOR &&
> +		    netif_running(sdata->dev)) {

But shouldn't that be !=3D _AP_VLAN && !=3D _MONITOR && running?

> +	/* add interfaces */
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +
> +		if (sdata->vif.type !=3D NL80211_IFTYPE_AP_VLAN &&
> +		    sdata->vif.type !=3D NL80211_IFTYPE_MONITOR &&
> +		    netif_running(sdata->dev)) {

Like here

> diff --git a/net/mac80211/pm.h b/net/mac80211/pm.h
> new file mode 100644
> index 0000000..3d5ff02
> --- /dev/null
> +++ b/net/mac80211/pm.h
> @@ -0,0 +1,9 @@
> +#ifndef __MAC80211_PM_H
> +#define __MAC80211_PM_H
> +
> +#ifdef CONFIG_PM
> +int __ieee80211_suspend(struct ieee80211_hw *hw);
> +int __ieee80211_resume(struct ieee80211_hw *hw);
> +#endif

I'd just add those to ieee80211_i.h, and I don't think you really need
to protect them with #ifdef CONFIG_PM

johannes

--=-Hsk9eZE2Cee4dqIfVNZy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPpXGAAoJEKVg1VMiehFYCJUP/3ZbEpyg6z/cwJBOqn6DWpLh
bR7oJF5pSDP3w+oI1gVhAUl8Pn1pJQ1jIeYqW9JagSQog01Res9KvFBUv39pddLE
n016PoX3l6a8JZ/YaEuQqtulC5tMQ08xxZCMywAMIxVev9/M7vXHI/POuPY7A4VX
FOiVGP5QutfuqeQsKnKQj/oT7o5kz3nrJ99BLK3ThUk4jrAEiUTacBpF0Bz0IoB3
hMD1U3Y5mnhOctMZnwR63C5n2Mg/HGXJu+m2pFBX1cWwF2b5/Q2WUk7DBoqOAVUX
hYg1HHOQuJl7+tJ2ABnNuf3u1ctAvBkifkFyys4ssyuG9ZLJa5aHfFLmm/6WTW1V
YqR4ZLAe5w+B9TAayRFPUZ2CO/hrY/8oBpL+318pMxkxKXelqK1Wr106OXU4BtYg
wBZaDfLkwelgFZ0Wd1iFeTbrusZJyKpEoRTvOXbf3FpPcQ0wV4drQF/kPuur7FbA
8xCEz+6t8C6mu6CWPYX0RaptDOEXB4DPnxN787XbiD72zT5CGmPKvgHQCNH+PiuD
UrgZGFPsTEv22UoZ6a9+dp0YpWf0AM8MLn7B32ab5FlF6uXNWW3AM9ogD413bqUz
vdsADvsmm9SQ6hu7PVceszdzLlJNzlnY9miA8l7/5Ykcs5V5+WU+MdCjUjTqO9ce
YGC2/hdw+IvaVCmy8God
=sC1P
-----END PGP SIGNATURE-----

--=-Hsk9eZE2Cee4dqIfVNZy--

