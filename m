Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbYGAIDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 04:03:47 -0400
Subject: Re: [PATCH 1/2] mac80211: add bar capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1214898291-6232-2-git-send-email-tomas.winkler@intel.com>
References: <1214898291-6232-1-git-send-email-tomas.winkler@intel.com>
	 <1214898291-6232-2-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1/qtp1xYJmfpsusECQNT"
Date: Tue, 01 Jul 2008 10:03:05 +0200
Message-Id: <1214899385.7763.9.camel@johannes.berg> (sfid-20080701_100427_946239_3CD90C1E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1/qtp1xYJmfpsusECQNT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Can you capitalise BAR in the patch subjects please? I think of an
actual bar when reading that :)

> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -235,6 +235,8 @@ struct ieee80211_bss_conf {
>   * @IEEE80211_TX_STAT_ACK: Frame was acknowledged
>   * @IEEE80211_TX_STAT_AMPDU: The frame was aggregated, so status
>   * 	is for the whole aggregation.
> + * @IEEE80211_TX_STAT_AMPDU_NO_BACK: no block ack was returned,
> + * 	so consider using block ack request (BAR).

This flag I don't understand. When does the driver set this? And what
does mac80211 do to "consider", it seems to always just try to set up a
block-ack session.

I'd still loke to see a "HT operation" document that describes how all
this works together so other people can write HT capable drivers :)

> +	bar_control |=3D (u16)IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL;

??

> +	bar_control |=3D (u16)IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA;
> +	bar_control |=3D (u16)(tid << 12);
> +	bar->control =3D cpu_to_le16(bar_control);
> +	bar->start_seq_num =3D cpu_to_le16(ssn);
> +
> +	/* must be sent through voice AC */
> +	skb->priority =3D 3;

Does that actually work? The current wme.c code will still call
classify_1d() and that will use the IP TOS unless you set the priority
to 256..263.

johannes

--=-1/qtp1xYJmfpsusECQNT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIaeS0AAoJEKVg1VMiehFYHrgQAJbMdlOLwJLl2SfAaAwD7sNv
MTYMBZ/CH/2xD7aWRjmhlt06tKGIGpXezreCDs8YAOpR1+52qZLt9WELsOFl4y+D
Q+wdhnlHTtzezKyHbBFsa83z3V7lwJiKE+8oe2dQ0YkQ6qtwPBmtFlA5SnJB8QLo
D08kE4rqFsiDqyaufypkcsRnZoD7OXiM/0UvlWZT911hKJ6VCO+wLUpQpMMbDpno
tiAmhYe29QWJGEIHGxPnTSL9IlrlOdQhKuZVhlLjvXCZ5nzCtTZRVvgdmnN9kr3Z
i4laOnPrEuMkz3KR8eRg4yo9BaLiDBRjHJ7F5ZdKIBVbETTgx0zG1UR0l80UfjDL
GHp67Izt/t4rOzRgRdJ+F1lqNkGyqPDEnhCPYj5xMkZ/7sPFcothleCEmsfMNkg3
G1W06E+gnWCHIXphRipCeS8jegc6GwGXQJ7AQAUSXwfZgHkulkOzV6evXzyW47Id
2RHrtHYBFuALKgw4vfINrdtl0fF0xYdz9eK4RN1NRKwbdrZFJsbKqQO7yM185W5n
rHTEsHIUpBNofFkHljjj9CE6Wlu9pyRRXXQVcwCvujFxAj5OmguP05f4zYSd9+P4
QqweAgBdooTRk5+kNS3iIjPx6dx0ZYYZO/q7P5tA/U+MZ/sMc7VyA9x6KOzaF/qM
/XOtA95wYw4saGkzaGIQ
=NEgF
-----END PGP SIGNATURE-----

--=-1/qtp1xYJmfpsusECQNT--

