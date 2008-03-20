Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S943602AbYCTAAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 20:00:49 -0400
Subject: Re: [PATCH 4/7] mac80211: get a TKIP phase key from skb
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1205970106-22196-5-git-send-email-reinette.chatre@intel.com>
References: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com>
	 <1205970106-22196-2-git-send-email-reinette.chatre@intel.com>
	 <1205970106-22196-3-git-send-email-reinette.chatre@intel.com>
	 <1205970106-22196-4-git-send-email-reinette.chatre@intel.com>
	 <1205970106-22196-5-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/jZygFyZQXirVpLYDSxp"
Date: Thu, 20 Mar 2008 01:00:28 +0100
Message-Id: <1205971228.16475.79.camel@johannes.berg> (sfid-20080320_000127_025235_F5F22377)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/jZygFyZQXirVpLYDSxp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for your efforts!

> +enum ieee80211_tkip_key_type {
> +	IEEE80211_TKIP_P1_KEY	=3D 1<<0,

Please don't make them look like flags, not giving any explicit value at
all would be fine.
=20
>  /**
> + * ieee80211_get_tkip_rc4_key - get a phase 2 key for skb
> + *
> + * This function computes a phase 2 key for an skb. It computes
> + * a phase 1 key if needed (iv16 wraps around). This function is to
> + * be used by drivers which can do HW encryption but need to compute
> + * to phase 2 key in SW.

That documentation seems wrong given you can ask for key types.

Looks good otherwise.

johannes

--=-/jZygFyZQXirVpLYDSxp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+GpG6Vg1VMiehFYAQKGFxAAiRK9kooH9fZuqd8JgBR51JRaeBOFOMgq
vaT5VEyl8CvI3GPGt6KgU2giYgqh81GHt1y5kTvsUx9inUlDW7nG3f575gtYE/Un
EtCZ86strycMjkwU04cn8P/Nqbkv+CNmmy+GT3DeO5qYRxAZ3I1IayY98eaVoa75
yJljuRVf+FHTKg6OmVTx0iAHKC8PDNxzdl/9siQMpz7D870xvtwuWhj5t5jkfLax
Kka8cxicmWgf5NIFICwV+Yf43JJJUaX9lsk0VK+SNRBwA0bLKVYKzr/URylJnTeg
40sHdLGhD14rMXV8EaeXNCqBXragc7MXVISMbRbZ5F/PbIOvdKzJehOymnt9/POm
PDB0Fr3LtNrmH8U3ZTpjZy8G6O3eTHrndUnhbZFLKdKz1N4/9IX7ESUrkKc365Qb
YLycc6lEF19IN8hNVnDtOMLrLd7LLbep17/KS6As62frhaIGJ+/avHuIQPnSiNJv
aec+R2S7klKLD6gLfZpoaymu8qcn97LtlbJ7aHuqBGdLzGFekBgYMgyDAjylZxmx
3VzFF/s7KrcMobf3VkQK23aBGp41EW+H1vZaUzy0gP7QVuq3a0c8pNr8KjAlP93M
N8soMNS92sCbytgUqaqp5IImJkDqHorHtmU7B4Ztrbu3gepfURWduU6lldwp4V4T
5Wokx6v9oqc=
=2QgJ
-----END PGP SIGNATURE-----

--=-/jZygFyZQXirVpLYDSxp--

