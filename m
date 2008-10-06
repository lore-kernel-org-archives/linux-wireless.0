Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44367 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbYJFRq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 13:46:29 -0400
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223311803.15196.36.camel@johannes.berg> (sfid-20081006_185054_691408_9EB600FE)
References: <1223311803.15196.36.camel@johannes.berg>
	 (sfid-20081006_185054_691408_9EB600FE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZOvvNWazKFZ9ANg4dBeE"
Date: Mon, 06 Oct 2008 19:45:49 +0200
Message-Id: <1223315149.3778.10.camel@johannes.berg> (sfid-20081006_194633_389108_45665CED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZOvvNWazKFZ9ANg4dBeE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-5000-hw.h	2008=
-10-06 18:09:21.375233932 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-5000-hw.h	2008-10-0=
6 18:32:50.180236365 +0200
> @@ -84,46 +84,43 @@
>  #define IWL50_NUM_AMPDU_QUEUES		  10
>  #define IWL50_FIRST_AMPDU_QUEUE		  10
> =20
> -#define IWL_sta_id_POS 12
> -#define IWL_sta_id_LEN 4
> -#define IWL_sta_id_SYM val
> -
>  /* Fixed (non-configurable) rx data from phy */
> =20
>  /* Base physical address of iwl5000_shared is provided to SCD_DRAM_BASE_=
ADDR
>   * and &iwl5000_shared.val0 is provided to FH_RSCSR_CHNL0_STTS_WPTR_REG =
*/
>  struct iwl5000_sched_queue_byte_cnt_tbl {
> -	struct iwl4965_queue_byte_cnt_entry tfd_offset[IWL50_QUEUE_SIZE +
> -						       IWL50_MAX_WIN_SIZE];
> +	/* highest 4 bits of each entry are sta ID */
> +	__le16 _tfd_offset[IWL50_QUEUE_SIZE + IWL50_MAX_WIN_SIZE];
>  } __attribute__ ((packed));
> =20
> +static inline void
> +iwl5000_queue_byte_cnt_set(struct iwl5000_sched_queue_byte_cnt_tbl *tbl,
> +			   u32 idx, u16 cnt)
> +{
> +	BUG_ON(idx >=3D IWL50_QUEUE_SIZE + IWL50_MAX_WIN_SIZE);

I just hit that BUG_ON, which means that something is passing a bogus
value in. If I'm right and this isn't a bug in my patch (I cannot see
how it should be) then it means that will corrupt memory silently
without my patch. FWIW, the index is 511, which is totally wrong, being
called from iwl5000_txq_inval_byte_cnt_tbl.

I'd much appreciate if somebody would review this patch. I think it's
right and the added sanity check blows up because of other bugs, but
obviously I cannot guarantee that I didn't make a stupid mistake.

johannes

--=-ZOvvNWazKFZ9ANg4dBeE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6k7JAAoJEKVg1VMiehFYGlwP/3G/kUPf4c0xc8/wKslVpZFz
AjujA0RyPnuUPSpAJwfD4pvXvpC+Ot/isE75oYPo+e1EvhF+1RB3Vb4QQJK+fbAc
5CopgxmvR7apQIHDbw1fJaf/rxDPNbLD7RPlUxVCdVjomgMnavEsLiEHHncxnPDx
ekjvNXekwFOcMmMIeVuZzQJtAZUPM7+J/CvsRsFMMz7buXNDQHwGeELzb5dwfyd2
ljpvleSduGg0CCwh/hYaUknh0M/0+/RjPUB5rDYyHPj5Avnh9sAzC3UMY0+zAOpN
FD3lBtI7+B2NWsVaZOYpeAxIzg3x38jRsd3AcVwo9yBzu4O7UlmFCTwsQLaKBvaV
xy+pi+AUByaalXIIQFDk5jDS+AqNzG4e3IPIOyL3t/Yi+4sRPecaFQRpU/gmlsWO
bjbGkO1G4lxMNJ8fRvhtDrR6N5aop33gVgTVXWw0f/sLtV673xNgqn90X3hNlcFg
2mnS+OyK16eFuoGcl8CTRJXslW20tkxwbIU6N9+A0GTxwjMYagPhKiMFwre60zDz
yK38o2M2h2GZdUflOFHyjjFNQcw8DHskVzUwXplPB5VYoQxiIEf4CWfRK4DHaN3P
O8d9PHwSyghsoN/Thn9gti1uv02iCW2dyxFpfo10Nadpn25xbuHEF8hXzyH+KlLA
wohGLnv+w7b/bRChL7v0
=X37h
-----END PGP SIGNATURE-----

--=-ZOvvNWazKFZ9ANg4dBeE--

