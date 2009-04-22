Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbZDVVJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 17:09:44 -0400
Subject: Re: [RFC 2/2] mac80211: unify config_interface and bss_info_changed
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1240434309.29805.73.camel@rc-desk>
References: <20090422154559.528196740@sipsolutions.net>
	 <20090422154644.464399343@sipsolutions.net>
	 <1240434309.29805.73.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XiD1b28OVX+Cg7s06KZV"
Date: Wed, 22 Apr 2009 23:09:11 +0200
Message-Id: <1240434551.30082.25.camel@johannes.local> (sfid-20090422_230946_944164_DCEDD4EA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XiD1b28OVX+Cg7s06KZV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Reinette,

Thanks for your comments!

> >  #define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
> >  void iwl_bss_info_changed(struct ieee80211_hw *hw,
> > -                                    struct ieee80211_vif *vif,
> > -                                    struct ieee80211_bss_conf *bss_con=
f,
> > -                                    u32 changes)
> > +                         struct ieee80211_vif *vif,
> > +                         struct ieee80211_bss_conf *bss_conf,
> > +                         u32 changes)
> >  {
> >         struct iwl_priv *priv =3D hw->priv;
> >         int ret;
> >=20
> >         IWL_DEBUG_MAC80211(priv, "changes =3D 0x%X\n", changes);
> >=20
> > +       if (!iwl_is_alive(priv))
> > +               return;
> > +
> > +       mutex_lock(&priv->mutex);
> > +
> > +       if ((changes & BSS_CHANGED_BSSID) && !iwl_is_rfkill(priv)) {
> > +               /* If there is currently a HW scan going on in the back=
ground
> > +                * then we need to cancel it else the RXON below will f=
ail. */
> > +               if (iwl_scan_cancel_timeout(priv, 100)) {
> > +                       IWL_WARN(priv, "Aborted scan still in progress =
"
> > +                                   "after 100ms\n");
> > +                       IWL_DEBUG_MAC80211(priv, "leaving - scan abort =
failed.\n");
> > +                       mutex_unlock(&priv->mutex);
> > +                       return;
> > +               }
> > +               memcpy(priv->staging_rxon.bssid_addr,
> > +                      bss_conf->bssid, ETH_ALEN);
> > +
> > +               /* TODO: Audit driver for usage of these members and se=
e
> > +                * if mac80211 deprecates them (priv->bssid looks like =
it
> > +                * shouldn't be there, but I haven't scanned the IBSS c=
ode
> > +                * to verify) - jpk */
> > +               memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
> > +
> > +               if (priv->iw_mode =3D=3D NL80211_IFTYPE_AP)
> > +                       iwlcore_config_ap(priv);
> > +               else {
> > +                       int rc =3D iwlcore_commit_rxon(priv);
> > +                       if ((priv->iw_mode =3D=3D NL80211_IFTYPE_STATIO=
N) && rc)
> > +                               iwl_rxon_add_station(
> > +                                       priv, priv->active_rxon.bssid_a=
ddr, 1);
> > +               }
> > +       } else {
> > +               iwl_scan_cancel_timeout(priv, 100);
> > +               priv->staging_rxon.filter_flags &=3D ~RXON_FILTER_ASSOC=
_MSK;
> > +               iwlcore_commit_rxon(priv);
> > +       }
>=20
> I do not think the above if clause fully captures what was done in
> iwl_mac_config_interface(). If rfkill is enabled we do not want to send
> a command to the device. This is possible in this else clause. Perhaps
> the else can have an extra check like ...
>=20
> ...
> } else if (!iwl_is_rfkill(priv)) {
> ...

Oh indeed. That looks like a bug. The entire thing was rather odd -- I
first had the code below the rest of bss_info_changed and then it just
didn't work at all. Seems iwlwifi implicitly relied on an undocumented
call ordering in mac80211 :)

> Why did you choose not to copy the code dealing with AP mode from
> iwl_mac_config_interface()? I know that the driver does not currently
> support it, but removing this code makes it harder for the case if this
> support is added back. Considering the code is not currently used, would
> you be ok with adding it as commented code?

Sure. It was just that I looked at the code:

> > -       if (priv->iw_mode =3D=3D NL80211_IFTYPE_AP) {
> > -               if (!conf->bssid) {
> > -                       conf->bssid =3D priv->mac_addr;
> > -                       memcpy(priv->bssid, priv->mac_addr, ETH_ALEN);
> > -                       IWL_DEBUG_MAC80211(priv, "bssid was set to: %pM=
\n",
> > -                                          conf->bssid);
> > -               }
> > -               if (priv->ibss_beacon)
> > -                       dev_kfree_skb(priv->ibss_beacon);
> > -
> > -               priv->ibss_beacon =3D ieee80211_beacon_get(hw, vif);
> > -       }

and it didn't seem to make any sense to me. ibss_beacon? Also, it
doesn't depend on configuration that the beacon changed? Either way, I
can add the code back, maybe with a small cleanup.

Thanks,
johannes

--=-XiD1b28OVX+Cg7s06KZV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ74d1AAoJEKVg1VMiehFYf4MP/2cxgG0tRPwIO2wbMFi+V9II
3MqgdR5H/albaIy4KZA0iFrYSgbH1jFFYVXfeaB7cM347Az+QCfzjlrzuXAga/3j
nL45ZFLY8kFUHocdxfTGYeDC6XGGxlc8eGQqk96EBui8ua5+DhuDEGdy5U4NuPwA
c8FJBRXEW1GKtaURrEX2zn7BCNlS+viXnYRjnquW9kvzryXWouOGXexPY4KNxaLI
b+UQG/CExIr8qQEajJL9tKVO6DCu0OgCB6nQ+jJi2ApC2icOA9cZAncNaGQua98B
8HYqk+FqpvTsroLED7q7ntq+6461ADzKq1la1T2l1RgQIlY7BK3mDRFKwf6lB2ey
+QqvrfeqDyiwJnAx5QcLPSi7qmM54pmC8Li8lltUrn179gFkPZ1zwKfxBrDsH1ut
v88LfUilNbpyeOEAKnF0QjgVALOf+4RxBoyVlkseVjyhOAbSbof/jOk+ly9ETWkS
pDEUmdAP6EstUitBEXeu6jLZh8kGNwK2qzvhk7vPFAsqlYKE/KbXxI+j2yf9BWR4
+fFZQTjACPIpptpzVN2/mXLjp/nq3Uy5QeG5QrJb3pwjDyYXx2slDB4HmxDy+q9B
ao5DidQtDH8fyBF3fpeCkIUVXai41CDNa+MpCxEyuHZ7nD3JncCaAqhSNbU1aM6W
VLId4HCS4EKwTN/J8Cz1
=jqxL
-----END PGP SIGNATURE-----

--=-XiD1b28OVX+Cg7s06KZV--

