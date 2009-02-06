Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbZBFUhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 15:37:42 -0500
Subject: Re: [PATCH 07/11] mac80211: fix race in TX aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090206191322.GB5031@tesla>
References: <20090205160738.990564487@sipsolutions.net>
	 <20090205161133.193146777@sipsolutions.net>  <20090206191322.GB5031@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WNqiKYpi4PUUKSuW9xYn"
Date: Fri, 06 Feb 2009 21:37:35 +0100
Message-Id: <1233952655.4175.15.camel@johannes.local> (sfid-20090206_213746_935357_B03EA88D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WNqiKYpi4PUUKSuW9xYn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-06 at 11:13 -0800, Luis R. Rodriguez wrote:

> > @@ -135,23 +163,13 @@ static void sta_addba_resp_timer_expired
> >          * flow in sta_info_create gives the TID as data, while the tim=
er_to_id
> >          * array gives the sta through container_of */
> >         u16 tid =3D *(u8 *)data;
> > -       struct sta_info *temp_sta =3D container_of((void *)data,
> > +       struct sta_info *sta =3D container_of((void *)data,
> >                 struct sta_info, timer_to_tid[tid]);
> > -
> > -       struct ieee80211_local *local =3D temp_sta->local;
> > -       struct ieee80211_hw *hw =3D &local->hw;
> > -       struct sta_info *sta;
> > +       struct ieee80211_local *local =3D sta->local;
> >         u8 *state;
> >=20
> > -       rcu_read_lock();
> > -
> > -       sta =3D sta_info_get(local, temp_sta->sta.addr);
> > -       if (!sta) {
> > -               rcu_read_unlock();
> > -               return;
> > -       }
> > -
> >         state =3D &sta->ampdu_mlme.tid_state_tx[tid];
> > +
> >         /* check if the TID waits for addBA response */
> >         spin_lock_bh(&sta->lock);
> >         if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
> > @@ -161,21 +179,15 @@ static void sta_addba_resp_timer_expired
> >                 printk(KERN_DEBUG "timer expired on tid %d but we are n=
ot "
> >                                 "expecting addBA response there", tid);
> >  #endif
> > -               goto timer_expired_exit;
> > +               return;
> >         }
> >=20
> >  #ifdef CONFIG_MAC80211_HT_DEBUG
> >         printk(KERN_DEBUG "addBA response timer expired on tid %d\n", t=
id);
> >  #endif
> >=20
> > -       /* go through the state check in stop_BA_session */
> > -       *state =3D HT_AGG_STATE_OPERATIONAL;
> > +       __ieee80211_stop_tx_ba_session(local, sta, tid, WLAN_BACK_INITI=
ATOR);
> >         spin_unlock_bh(&sta->lock);
> > -       ieee80211_stop_tx_ba_session(hw, temp_sta->sta.addr, tid,
> > -                                    WLAN_BACK_INITIATOR);
> > -
> > -timer_expired_exit:
> > -       rcu_read_unlock();
> >  }
>=20
> Do we not need the sta under rcu lock on the sta_addba_resp_timer_expired=
()?
> With this patch wouldn't we have a race between passing this to
> __ieee80211_stop_tx_ba_session() and it being removed using sta_info_dest=
roy()?

No, because this is the timer that we take care to kill in _destroy.

johannes

--=-WNqiKYpi4PUUKSuW9xYn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJjJ+MAAoJEKVg1VMiehFYAiUQAIXIV5nRgNZEhlla/xUVJteX
KlgBG6PFZSFkLX6V1ak5ML+nYSBzDu2wQYKUe8HeiUUtsKrAio1Jy4j/wPtuaVls
Mq7HL8j48PeUtHlqoXPeX9Ys0lGZtVU49ua5+p4ByO/DVH5xED9mKpFcMRL9Aeip
5npWCoQXR8/NG3PmVsUFOh1wnplfxS+EtSZSn6j2rF92ThohQf8IcLZbrZH8vAZQ
kJSJSLX0IzEDNl8G7TE0sJ1egnoXZ8SnwiSc84jJY0IBNJT7hX2wkeirYI7TiR34
Eg/SZR9z1F+3+KBn9/WpscoEIootYDzbj5fI9Rgw0Qt0API/KP6WgQy/Ib2qcI90
kd19nHLvtyXq0CpXR+DjMn/2MyuGva+rv4hgEVd4hSQ8XORbZ2XhGuUuheuYZzfw
3YTk2b4Zc6/EyWl2srICeCYFp95hM7urYc81V6TAcEjrqFW2RUgt6tRBz+ZXEova
b98rEOdJWSA3b8aLdbLVQB7g7c59MaSZfI1x4T465NoDphdg7aXB37sRv5e/fLJY
Z9GkTOgPaT9aoK+r7pISQz6g0ey2qQRWke+V5AiCg58gPxkWpGGDEQmiZK08eZ1T
KeHpi6s58VzcA6hZdXw97OyeufCEORb6SHwjltN2IyV7U+fgT7ycJkveGdXK5qqQ
rfLi3xGtRnHj4zt5Xn/y
=RnZF
-----END PGP SIGNATURE-----

--=-WNqiKYpi4PUUKSuW9xYn--

