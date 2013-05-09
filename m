Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40459 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3EISSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 14:18:35 -0400
Date: Thu, 9 May 2013 20:18:27 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Sujith Manoharan <sujith@msujith.org>
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Disable spectral scan code to fix crash on
 rmmod.
Message-ID: <20130509181827.GA22871@pandem0nium> (sfid-20130509_201838_923107_57C3ADBD)
References: <1368050908-7554-1-git-send-email-greearb@candelatech.com>
 <20875.13834.615920.337442@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
In-Reply-To: <20875.13834.615920.337442@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 09, 2013 at 11:07:14AM +0530, Sujith Manoharan wrote:
> greearb@candelatech.com wrote:
> > From: Ben Greear <greearb@candelatech.com>
> >=20
> > With CONFIG_ATH9K_DEBUGFS enabled, and slub memory poisoning
> > enabled, I see this crash on rmmod of ath9k.  I'm not sure how
> > to fix this properly, but in the meantime, this patch to disable
> > the spectral scan code works around the problem for me.
> >=20
> > With memory poisoning and the verify_mem_not_deleted code
> > below added, the crash looks as follows...  The dentry
> > is not *always* freed at this point, probably because rcu
> > callbacks haven't completed.  You still get a crash soon
> > after, however.
>=20
> The relay file should probably be closed before calling ieee80211_unregis=
ter_hw().
> The ath9k debugfs directory is created inside the phy#/ directory and tha=
t would
> get cleaned up when the wiphy is unregistered.
>=20
> Does this help ?

Looks good to me, moving the closing of the relayfs file before the unregis=
tering. Thanks
a lot for fixing my bugs, Sujith. :)

Acked-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

(BTW, would you mind sending this as proper [PATCH] again?)


>=20
> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireles=
s/ath/ath9k/debug.c
> index 4101c4a..cecbe1f 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.c
> +++ b/drivers/net/wireless/ath/ath9k/debug.c
> @@ -1684,6 +1684,14 @@ void ath9k_get_et_stats(struct ieee80211_hw *hw,
>  	WARN_ON(i !=3D ATH9K_SSTATS_LEN);
>  }
> =20
> +void ath9k_deinit_debug(struct ath_softc *sc)
> +{
> +	if (config_enabled(CONFIG_ATH9K_DEBUGFS) && sc->rfs_chan_spec_scan) {
> +		relay_close(sc->rfs_chan_spec_scan);
> +		sc->rfs_chan_spec_scan =3D NULL;
> +	}
> +}
> +
>  int ath9k_init_debug(struct ath_hw *ah)
>  {
>  	struct ath_common *common =3D ath9k_hw_common(ah);
> diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireles=
s/ath/ath9k/debug.h
> index 62da19c..223418d 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.h
> +++ b/drivers/net/wireless/ath/ath9k/debug.h
> @@ -297,6 +297,7 @@ struct ath9k_debug {
>  };
> =20
>  int ath9k_init_debug(struct ath_hw *ah);
> +void ath9k_deinit_debug(struct ath_softc *sc);
> =20
>  void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int statu=
s);
>  void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
> @@ -332,6 +333,10 @@ static inline int ath9k_init_debug(struct ath_hw *ah)
>  	return 0;
>  }
> =20
> +static inline void ath9k_deinit_debug(struct ath_softc *sc)
> +{
> +}
> +
>  static inline void ath_debug_stat_interrupt(struct ath_softc *sc,
>  					    enum ath9k_int status)
>  {
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless=
/ath/ath9k/init.c
> index c7b888f..c0aa4ff 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -903,7 +903,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
>  	if (!ath_is_world_regd(reg)) {
>  		error =3D regulatory_hint(hw->wiphy, reg->alpha2);
>  		if (error)
> -			goto unregister;
> +			goto debug_cleanup;
>  	}
> =20
>  	ath_init_leds(sc);
> @@ -911,6 +911,8 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
> =20
>  	return 0;
> =20
> +debug_cleanup:
> +	ath9k_deinit_debug(sc);
>  unregister:
>  	ieee80211_unregister_hw(hw);
>  rx_cleanup:
> @@ -939,11 +941,6 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
>  		sc->dfs_detector->exit(sc->dfs_detector);
> =20
>  	ath9k_eeprom_release(sc);
> -
> -	if (config_enabled(CONFIG_ATH9K_DEBUGFS) && sc->rfs_chan_spec_scan) {
> -		relay_close(sc->rfs_chan_spec_scan);
> -		sc->rfs_chan_spec_scan =3D NULL;
> -	}
>  }
> =20
>  void ath9k_deinit_device(struct ath_softc *sc)
> @@ -957,6 +954,7 @@ void ath9k_deinit_device(struct ath_softc *sc)
> =20
>  	ath9k_ps_restore(sc);
> =20
> +	ath9k_deinit_debug(sc);
>  	ieee80211_unregister_hw(hw);
>  	ath_rx_cleanup(sc);
>  	ath9k_deinit_softc(sc);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlGL6HMACgkQrzg/fFk7axYhjgCgqmozBcxiAf+utZZfQPGCRfS9
+SQAnjhDQH+U+UYt3iVBzMBqf1Ox0jhF
=g1ec
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
