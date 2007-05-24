Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:52358 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755287AbXEXGoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2007 02:44:12 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: yi.zhu@intel.com
Subject: Re: [PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS support
Date: Wed, 23 May 2007 23:42:26 -0700
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
References: <20070514051526.GA25582@mail.intel.com>
In-Reply-To: <20070514051526.GA25582@mail.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2568344.lVya32VBWn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705232342.31882.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2568344.lVya32VBWn
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 13 May 2007 22:15, Zhu Yi wrote:
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
The dls_info code looks like it was copied from the sta_info code and modif=
ied=20
to store what you need. No good.

Instead, you should modify struct sta_info to hold the information necessar=
y.=20
This also allows the rate control to work properly. AFAICT, mac80211 will=20
send all frames in DLS at the lowest rate because this code does not set up=
 a=20
sta_info for its destination. An appropriate sta_info entry is also necessa=
ry =20
to be able to set up encryption properly. (of course, user space can also s=
et=20
up a sta_info entry after setting up a DLS entry and make things work=20
correctly.. but that's dumb)

There is also a need for some way to notify the low level driver that it=20
should not attempt any power management after a direct link is established=
=20
(or that it should, once all DLS links are torn down). This callback/hook i=
s=20
also necessary to configure PS in hardware correctly in general and get rid=
=20
of the management frame sniffing that iwlwifi is currently doing to achieve=
=20
this.

> + if (dls_link_status(&sdata->u.sta, hdr.addr1) =3D=3D DLS_STATUS_OK){
How is this line suppose to work? I don't see hdr.addr1 initialized at any=
=20
point before this.

=2DMichael Wu

--nextPart2568344.lVya32VBWn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGVTPXT3Oqt9AH4aERAhC+AJ0QpjGAzQoNzfAynz0tj1gVLa/i3gCfQMCQ
1Zww+E1hfRhTP1LB8a+WTj0=
=9DIb
-----END PGP SIGNATURE-----

--nextPart2568344.lVya32VBWn--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
