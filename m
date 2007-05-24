Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:33211 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754497AbXEXHOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2007 03:14:31 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: yi.zhu@intel.com
Subject: Re: [PATCH 3/3] mac80211: debugfs support for TSM and DLS
Date: Thu, 24 May 2007 00:12:46 -0700
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20070514051535.GA25591@mail.intel.com>
In-Reply-To: <20070514051535.GA25591@mail.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1218383.V5ejhrfuFY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705240012.51922.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1218383.V5ejhrfuFY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 13 May 2007 22:15, Zhu Yi wrote:
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 8b939d0..c273afe 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -59,6 +60,10 @@ struct ieee80211_local;
>   * increased memory use (about 2 kB of RAM per entry). */
>  #define IEEE80211_FRAGMENT_MAX 4
>
> +/* Minimum and Maximum TSID used by EDCA. EDCA uses 0~7; HCCA uses 8~15 =
*/
> +#define EDCA_TSID_MIN 0
> +#define EDCA_TSID_MAX 7
> +
>  struct ieee80211_fragment_entry {
>  	unsigned long first_frag_time;
>  	unsigned int seq;
> @@ -178,6 +183,31 @@ struct ieee80211_tx_stored_packet {
>  	unsigned int last_frag_rate_ctrl_probe:1;
>  };
>
> +struct sta_ts_data {
> +	enum {
> +		TS_STATUS_UNUSED	=3D 0,
> +		TS_STATUS_ACTIVE	=3D 1,
> +		TS_STATUS_INACTIVE	=3D 2,
> +		TS_STATUS_THROTTLING	=3D 3,
> +	} status;
> +	u8 dialog_token;
> +	u8 up;
> +	u32 admitted_time_usec;
> +	u32 used_time_usec;
> +};
> +
> +#define DLS_STATUS_OK		0
> +#define DLS_STATUS_NOLINK	1
> +#define DLS_STATUS_SETUP	2
> +struct dls_info {
> +	atomic_t refcnt;
> +	int status;
> +	u8 addr[ETH_ALEN];
> +	struct dls_info *hnext; /* next entry in hash table list */
> +	u32 timeout;
> +	u32 supp_rates;
> +};
> +
>  typedef ieee80211_txrx_result (*ieee80211_tx_handler)
>  (struct ieee80211_txrx_data *tx);
>
These chunks were present in the second patch of this series.

So, who is going to be responsible for configuring DLS and TS? If we're goi=
ng=20
to leave this policy up to userspace.. why not implement most of the DLS=20
handshake/teardown code in wpa_supplicant directly? It would make the=20
remaining DLS code in the kernel much more straightforward.

However, that's still more of an implementation detail. I'm curious about h=
ow=20
DLS would actually get initiated and used if I am, for example, transferrin=
g=20
a large file from one STA to another on the same AP. It seems like the sort=
=20
of information needed to make this decision are similar to what is needed t=
o=20
decide when to set up BA.

=2DMichael Wu

--nextPart1218383.V5ejhrfuFY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGVTrzT3Oqt9AH4aERAhj8AKCKxhRyGD+Uj0VXp5Q3QbY4HSTHAgCguXFl
70VJlum+z4b8hruiCApMt+4=
=vYXK
-----END PGP SIGNATURE-----

--nextPart1218383.V5ejhrfuFY--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
