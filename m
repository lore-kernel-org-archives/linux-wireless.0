Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbYIHIjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 04:39:05 -0400
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com> (sfid-20080908_011417_213526_BE6D478D)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
	 <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com>
	 (sfid-20080908_011417_213526_BE6D478D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UYLLlAhoxb+M1DS+LFY6"
Date: Mon, 08 Sep 2008 10:38:59 +0200
Message-Id: <1220863139.31304.33.camel@johannes.berg> (sfid-20080908_103910_345877_3B623B07)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UYLLlAhoxb+M1DS+LFY6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 02:14 +0300, Tomas Winkler wrote:

> Shouldn't carrier_off(stada->dev) stop the queue?  I haven't seen this
> before.

The other question is whether we should be doing netif_carrier_off() at
all since that throws away frames from the queue and attaches a noop
qdisc. When we're roaming quickly between two APs, we don't necessarily
want that, but we don't actually know whether or not we'll be able to
get back to an AP quickly when we disassociate for whatever reason.

johannes

--=-UYLLlAhoxb+M1DS+LFY6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxOSfAAoJEKVg1VMiehFYazEP+gL1MDPUqNfyAxHWM4xcrcdR
lmnH3jjGSBk867F5mlBPxCITRwrKv9kD4p5RHufBrwkI4HL5HLE2m5RblLOXPNam
T8gpJIVIy7lAon89JWpndjfbJ9wVM7Qp/XNBCLwvL+YrfLqemC0UGoSyv6mtwAJT
JkhJwTJHC6UleRgiAOCdTTFQJn8firiEfMkpJ+qq4nfaQNVxe6EV6ggHKUKwyMTn
QqiuX9MpAaWRAZ/z+SoirxsffmbcaTvsOkkPIam9iEHLKl0t2pR+wLXj1pZqhuaR
y+4KuAbrvbr5xSL8BlLps1lUhDKcwBh31duK6Ebm492M36AiMi4twP6W92wNIuYh
HKRCSGPEAuZRw0A67sYCx3rgnSU78Gr4fS1dgJQUQ4d3OyA9vnA9mNMyywxtiC1m
ECINa9OG4YJ+4dV3iNjvun/9TMxzolj40RLuPyHa+iqtkjY2QwgKHDxpQNhuowHC
AzhOxvreH5hqHuJLoJN7NhCySJwovdrQmC85VvbRtUJ7WJPOvwZhi0saDcsPVMG6
OkZ52Lhz3Udp+JjOa6kuvEoFoGFNSCpU4HwFN91dJFvTLGpWiRtlgBH8D21RDfed
Kwh229YduWU5+8FuOjENemdDHKds8bNQpZaLUWXMU05LoE5O5DtaXTFNEjhxVCA/
k6VocVHTZNmzrgmbgcsm
=umLx
-----END PGP SIGNATURE-----

--=-UYLLlAhoxb+M1DS+LFY6--

