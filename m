Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56231 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZCMJYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 05:24:42 -0400
Subject: Re: [PATCH] mwl8k: Marvell TOPDOG wireless driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090310091333.GG4738@xi.wantstofly.org> (sfid-20090310_101347_405119_5EF3E76C)
References: <20090310091333.GG4738@xi.wantstofly.org>
	 (sfid-20090310_101347_405119_5EF3E76C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y568DommHp73na+UdgWE"
Date: Fri, 13 Mar 2009 10:22:49 +0100
Message-Id: <1236936169.25931.63.camel@johannes.local> (sfid-20090313_102445_158995_2CED9102)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y568DommHp73na+UdgWE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-10 at 10:13 +0100, Lennert Buytenhek wrote:

> +		/*
> +		 * Check for pending join operation. save a copy of
> +		 * the beacon and schedule a tasklet to send finalize
> +		 * join command to the firmware.
> +		 */
> +		if (mwl8k_capture_bssid(priv, wh))
> +			mwl8k_save_beacon(priv, skb);

This raises an interesting problem I'm debugging in iwlwifi right now --
when you suspend/resume mac80211 assumes, currently, that all it has to
do is completely reconfigure the hardware (cf. net/mac80211/pm.c,
__ieee80211_resume()), it is currently missing this piece of code
though:

        list_for_each_entry(sdata, &local->interfaces, list) {
                if (!netif_running(sdata->dev))
                        continue;
                if (sdata->vif.type =3D=3D NL80211_IFTYPE_MONITOR)
                        continue;
                ieee80211_if_config(sdata, ~0);
                ieee80211_bss_info_change_notify(sdata, ~0);
        }

(Think about it for a second before I explain)




This means that after resume, the finalize join command will not be run,
although mac80211 assumes that it is connected to the AP, and the
firmware was reset completely.

We may be disconnected if we sleep for too long, but that is acceptable,
as soon as we send something the AP will then throw us out and we go
through the association procedure again. We may want to add some code to
detect that (maybe just send a nullfunc "going to sleep" before suspend,
and "awake now" after resume?) but it should work anyway.

I don't have a good solution right now. We could always go through the
assoc process again, but that seems wasteful. Or we could just have
mac80211 hand down the beacon/probe response data in the assoc setting
(bss config)

johannes

--=-y568DommHp73na+UdgWE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJuiXnAAoJEKVg1VMiehFYp3UP/3rI9zrG5i+VmaZfVvfjwZah
aYyH6wbtJ+EyWFHg77k2VkdVXS4QMdjowSNLiE9mq77vu7k/9gJSvPMILcSJR4T1
pW2z+kLjNTHBWF9Fuq2AH2MyWCp88854c+4YkuLQttJqc/v43GnhChtArWjxuaDR
7/08S6Sj9hLHWBAtW+G9LYyZ68cvmLTIBFeD4Qh2MXR99tHZ3wVaoa7RXboDrM1v
gs6BfL2zsWzpsJM3A5LblPcyadVo0QjKFDqNsyKi/0uQPkC1iY6vc5bpkpGNdTxh
SjEojLdsF1oDcDpQmRSwOfJTA+Sql2Ar24gJIfuIiii4VFqmv+G/ADOPLEDptCwI
VWFXAX//A3mpPIvv5HkpoPT6OUD2iC6wcaRNi3Lpkvx9m2Jtsfpxul9uIRs3tJyY
vzXZ4IYGM7dkI2kbVFjclPeH0z2E9jf3lIkWxDCxd0k/t/oC9sJ8Twh6Hi1W5Gv9
lcSLw2MrS+Z+/D/dhAD1bIJm7bauGp35lJlzdBhjj6wIyzUTtzY1GjwtEMJV21UU
2jw/KBWuuzibneZONaRjjGGGsjR4Em8NQ59Bgha9yL++fc4lIrpV9e7nJLu2B8I6
8hvRU/edd7IWoRB1NADHu7FGozsiuc7SZ82Ybf1O7kuRpaDEFyfoSnHmJAZ5g0QL
Z2Jkk1I4S6A2mtTTxrq8
=qyR6
-----END PGP SIGNATURE-----

--=-y568DommHp73na+UdgWE--

