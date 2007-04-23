Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:47316 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753607AbXDWU7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 16:59:32 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 03/13] mac80211: fix virtual interface related locking
Date: Mon, 23 Apr 2007 16:55:24 -0400
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <20070423184812.7029.7682.stgit@magic.sourmilk.net> <20070423224116.03d99954@griffin.suse.cz>
In-Reply-To: <20070423224116.03d99954@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1541882.ACy4JOY4s4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704231655.28314.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1541882.ACy4JOY4s4
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 23 April 2007 16:41, Jiri Benc wrote:
> > +	netif_tx_lock(local->mdev);
>
> Shouldn't it be netif_tx_lock_bh?
>
Softirqs should already be disabled by the caller.

> >  	if (((dev->flags & IFF_ALLMULTI) !=3D 0) ^ (sdata->allmulti !=3D 0)) {
> >  		if (sdata->allmulti) {
> >  			sdata->allmulti =3D 0;
> > @@ -2177,9 +2178,12 @@ static void ieee80211_set_multicast_list(struct
> > net_device *dev) flags |=3D IFF_ALLMULTI;
> >  		if (local->iff_promiscs)
> >  			flags |=3D IFF_PROMISC;
> > +		read_lock(&local->sub_if_lock);
> >  		local->ops->set_multicast_list(local_to_hw(local), flags,
> >  					      local->mc_count);
>
> Would be nice to have documented that set_multicast_list is called in
> atomic context.
>
Sure, but this is no different from other network drivers.

> > [...]
> > @@ -3871,6 +3884,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, stru=
ct
> > sk_buff *skb, struct sk_buff *skb_new;
> >  		u8 *bssid =3D ieee80211_get_bssid(hdr, skb->len - radiotap_len);
> >
> > +		read_lock(&local->sub_if_lock);
> >  		list_for_each_entry(sdata, &local->sub_if_list, list) {
> >  			rx.u.rx.ra_match =3D 1;
> >  			switch (sdata->type) {
> > @@ -3906,10 +3920,9 @@ void __ieee80211_rx(struct ieee80211_hw *hw,
> > struct sk_buff *skb, rx.u.rx.ra_match =3D 0;
> >  				} else if (!sta)
> >  					sta =3D rx.sta =3D
> > -						ieee80211_ibss_add_sta(local->mdev,
> > +						ieee80211_ibss_add_sta(sdata->dev,
> >  								       skb, bssid,
> >  								       hdr->addr2);
> > -						/* FIXME: call with sdata->dev */
> >  				break;
> >  			case IEEE80211_IF_TYPE_AP:
> >  				if (!bssid) {
> > @@ -3964,6 +3977,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, stru=
ct
> > sk_buff *skb, &rx, sta);
> >  		} else
> >  			dev_kfree_skb(skb);
> > +		read_unlock(&local->sub_if_lock);
>
> Documenting that sub_if_lock cannot be taken under sta_bss_lock nor
> under sta_lock would be nice.
>
> local->ops->conf_tx and ->set_time are called under spinlock, are we ok
> with that?
>
Since conf_tx is being called from ieee80211_sta.c, I'd rather have it run=
=20
from the workqueue. As far set_time.. would be nice to call it outside of t=
he=20
tasklet but that can be addressed in another patch. Calling it under readlo=
ck=20
is okay since writes are so rare and the callback isn't allowed to sleep=20
anyway.

> >  		return res;
> >  	case HOSTAP_IF_VLAN:
> >  		if (left < sizeof(struct hostapd_if_vlan))
> >  			return -EPROTO;
> >
> > -		res =3D ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
> > +		res =3D ieee80211_if_add(dev, param->u.if_info.name, NULL,
> > +				       IEEE80211_IF_TYPE_VLAN);
> >  		if (res)
> >  			return res;
> > -		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_VLAN);
> >  #if 0
> >  		res =3D ieee80211_if_update_vlan(new_dev, vlan->id);
> >  		if (res)
>
> I know that the next few lines are commented out but please fix them as
> well or remove the #ifed out code completely, otherwise we may be in
> trouble later.
>
It doesn't even compile now since ieee80211_if_update_vlan doesn't exist=20
anymore.

> > [...]
> > @@ -1093,36 +1098,34 @@ static int ieee80211_ioctl_update_if(struct
> > net_device *dev, struct ieee80211_local *local =3D
> > wdev_priv(dev->ieee80211_ptr); struct net_device *wds_dev =3D NULL;
> >  		struct ieee80211_sub_if_data *sdata;
> > +		int ret;
> >
> >  		if (left < sizeof(struct ieee80211_if_wds))
> >  			return -EPROTO;
> >
> > +		read_lock(&local->sub_if_lock);
> >  		list_for_each_entry(sdata, &local->sub_if_list, list) {
> >  			if (strcmp(param->u.if_info.name,
> >  				   sdata->dev->name) =3D=3D 0) {
> >  				wds_dev =3D sdata->dev;
> > +				dev_hold(wds_dev);
> >  				break;
> >  			}
> >  		}
> > +		read_unlock(&local->sub_if_lock);
> >
> >  		if (!wds_dev || sdata->type !=3D IEEE80211_IF_TYPE_WDS)
> >  			return -ENODEV;
> >
> > -		return ieee80211_if_update_wds(wds_dev, wds->remote_addr);
> > +		ret =3D ieee80211_if_update_wds(wds_dev, wds->remote_addr);
> > +		dev_put(wds_dev);
>
> This was the place with unnecessary dev_hold/dev_put you talked about,
> right? Just wanted to show I'm paying attention :-)
>
Yup.

> > [...]
> > @@ -2239,6 +2239,7 @@ static int ieee80211_ioctl_clear_keys(struct
> > net_device *dev) struct sta_info *sta;
> >
> >  	memset(addr, 0xff, ETH_ALEN);
> > +	read_lock(&local->sub_if_lock);
> >  	list_for_each_entry(sdata, &local->sub_if_list, list) {
> >  		for (i =3D 0; i < NUM_DEFAULT_KEYS; i++) {
> >  			keyconf =3D NULL;
> > @@ -2256,6 +2257,7 @@ static int ieee80211_ioctl_clear_keys(struct
> > net_device *dev) }
> >  		sdata->default_key =3D NULL;
> >  	}
> > +	read_unlock(&local->sub_if_lock);
>
> Again, local->ops->set_key called under spinlock.
>
The good thing about this rwlock is that writers are extremely rare. (and n=
ot=20
going to happen in this case since we're holding rtnl which is a prerequisi=
te=20
to adding/removing virtual interfaces)

> Recursively taken lock. Ok, it's rwlock locked for reading, but I'd
> still prefer not doing that.
>
Opps. Good catch.

I'll post a new patch in an hour or so.

Thanks,
=2DMichael Wu

--nextPart1541882.ACy4JOY4s4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGLR1AT3Oqt9AH4aERAsCLAKC7AZLWTjvif7nj1fPW9OO4I9DitACeOMqD
v2rdIZd6qLGls6CYiKkxCU4=
=wUE8
-----END PGP SIGNATURE-----

--nextPart1541882.ACy4JOY4s4--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
