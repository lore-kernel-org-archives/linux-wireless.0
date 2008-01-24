Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37652 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYAXOsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 09:48:18 -0500
Subject: Re: [PATCH 01/12] mac80211: A-MPDU Tx add session's and low level
	driver's API
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <12009163391152-git-send-email-ron.rindjunsky@intel.com> (sfid-20080121_115237_868897_926DBC00)
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163391152-git-send-email-ron.rindjunsky@intel.com>
	 (sfid-20080121_115237_868897_926DBC00)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Woz1WVjL4ejSfO4toI13"
Date: Thu, 24 Jan 2008 10:23:51 +0100
Message-Id: <1201166631.3454.57.camel@johannes.berg> (sfid-20080124_144849_986100_A70EB2B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Woz1WVjL4ejSfO4toI13
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  	int (*ampdu_action)(struct ieee80211_hw *hw,
>  			    enum ieee80211_ampdu_mlme_action action,
> -			    const u8 *ra, u16 tid, u16 ssn);
> +			    u8 *addr, u16 tid, u16 *ssn);

Any reason you're removing the "const"?
 =20
> +int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 t=
id);

Maybe the other functions should instead use a const u8 *ra?

I don't have much to say about this patch really :)

johannes

--=-Woz1WVjL4ejSfO4toI13
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5hZJqVg1VMiehFYAQLapQ/+JWOgu1ULLnWiYzMzRxNDUQIowjtoGpfn
j4BaV3eYcU1kGpjdmEsg6loeu3ILZcU3GZB3uYf6Jxhzcw7s+qnf/Sc0/XSd143u
dC2eePwsFnrry8uSgVF5DUWENebtYpETa+mp8V+8L/RTAHXx9+G3L3e1mQyD7x/x
d4vJC/uQ9xI7oncD3TWjXr6KY6JX5t+G4oyDCNiRWT99LfEFwapsDj2JOSIeBeog
jhuP+NXNbpFNtQA9tBswa1yebb6JtGUH/Z2IFcLZXowXOBNldbWJVzVEhqxYmjtr
DUkUnhCb8SqQPxYabn5vUDXXBHyN+HLGiHSgqJsjZhhg1WtGj6bPJIKA/pORJcbx
KQ68L2FAkQ+l2XBG9PROk79Xr5TvJAYTK1fzWpIstZmcJj5oSrtVxQfkweX13wmn
XAj8AxcJt3ZZGzNOCLZfv2laWEqdacun7Zo0Ptv9HJzwe57CYr9fUHhHe9tgm4+5
NPoXtXDtb3gVfl7b6gDUmdMLU2eYhlaAu4XdzJbOItuw7G5Lm5IOHIRPM12kATz6
4sgreBGFLGYkCRiOJLaSN+4O1U8DAe/ZJCg2IRwQeGg17Cjhwvvo/LOPqBYmecR1
gdUZ20lh1CmAj7Mux/mbHH8qq5zcz32fYodyNDYsEYTnzAWAfzDgBs3s3sg7wOTC
zVsEal4ZG1M=
=54ou
-----END PGP SIGNATURE-----

--=-Woz1WVjL4ejSfO4toI13--

