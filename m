Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYGEQax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 12:30:53 -0400
Subject: Re: [RFC PATCH] iwlwifi: Memory allocation optimization.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>
In-Reply-To: <1215103274-8516-1-git-send-email-tomas.winkler@intel.com>
References: <1215103274-8516-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tbJhPFjNNv0f9zw+asoA"
Date: Sat, 05 Jul 2008 18:30:35 +0200
Message-Id: <1215275435.6848.12.camel@johannes.berg> (sfid-20080705_183057_416155_4A3A1DDC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tbJhPFjNNv0f9zw+asoA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-03 at 19:41 +0300, Tomas Winkler wrote:
> From: Gregory Greenman <gregory.greenman@intel.com>
>=20
> This patch optimizes memory allocation. The cmd member of
> iwl_tx_queue was allocated previously as a continuous block
> of memory. This patch allocates separate memory chunks for each command
> and maps/unmaps these chunks in the run time.

You still allocate a lot of unused memory. Why don't you, at least
temporarily until you've figured out how to do gather-IO [1], reduce the
maximum number of DMA fragments to 2 so you need 1/10th the memory? You
can always bump it back up after you do the necessary mac80211 changes.

johannes

[1] and I still maintain that you will not be able to, but that's
irrelevant.

--=-tbJhPFjNNv0f9zw+asoA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIb6GoAAoJEKVg1VMiehFYJX0P+gPpcsrwByZMQ02liicy07Gu
NkRjZDyzuh4aPXzRPJcXhS1R8w6eFZOP1Oqh6ZGd14AzT5Wrh0GFOjbLR2EzAZ6m
nSaCXmkMdc5h0ikSEHdKbzC5cQjnnF1Kfb960NRDXLCBKy25Jzaq6ujqEvIaz6wl
BWwfPaX+GdKMC0tMasb2VMrWGlLy6m0xwWwXFZleq0LBEpD03jpWsSeobsiOiLvh
M2BsxtUGcYB3a6R6YF2YlFPyvnl4ZnyL8RFsH8dTcbT8aCJtlR2opD6DSdbzrB38
4+K9rFiZBQdPMj4VcGt4eJu5mIWQxuRVmhoWRmqvzy+ETmSX+JTuW+ZfVZa/PXh6
rbpuV3sEJajPo3BXC1ji/Cu3H/Gx15PrdgEB66Nx7edWFkggHhIZZokHCTT4ELbu
v3AJEI8KBxoZZTdBprV2hWSOJvWKsTja/vAYISqKMRiP1gfvMu6JNWYQ6530uwE6
SAziN8h991XZATbnegmfEf9hucOjswT4LcL1V1DmJMopyxvKkEG4C/VFfKwSk9fl
GvGWB+26HgHrbgNLMMw7can23im5MRvYo7wckWREBEOAj03+vmW3j3KKdYZyeRLt
gO3TYQKMzSBz22Wqec1m7nq4a/ynDb97MSELD7re17XP+9TQSxKsrvOSsFMXnx7V
ZF2QEqAa9L9LydnNjrAz
=UjgW
-----END PGP SIGNATURE-----

--=-tbJhPFjNNv0f9zw+asoA--

