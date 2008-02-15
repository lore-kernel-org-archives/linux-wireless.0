Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759517AbYBOPLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 10:11:03 -0500
Subject: Re: sending ARP triggers BUG
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <D936D925018D154694D8A362EEB0892003ABCBD2@orsmsx416.amr.corp.intel.com>
References: <D936D925018D154694D8A362EEB0892003ABCBD2@orsmsx416.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e6YI0ODnjkEYXObHoFZr"
Date: Fri, 15 Feb 2008 16:10:19 +0100
Message-Id: <1203088219.8931.199.camel@johannes.berg> (sfid-20080215_151123_265934_61D68FBB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e6YI0ODnjkEYXObHoFZr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Reinette,

> I recently started seeing the BUG below. ieee80211_subif_start_xmit
> calls pskb_expand_head, but this function BUGs because the skb is
> shared.=20

I've been expecting this for a while now since I never found where on
mac80211's input path we make sure the skb isn't cloned/shared... I say
we just put an skb_unshare() into there since we need to modify the skb
once we get it.

johannes

--=-e6YI0ODnjkEYXObHoFZr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7WrWqVg1VMiehFYAQKxihAAgQkShSeJ1bIi+xB0JLgAm1tFBmTnWIZz
2dQbkIdwzL1d3UlTens+MBJjSjHpKX+07KSkmQ5AXyH/bWF+VdFXTVu6uzHKkiwQ
P0UBGTdnapnUwTsBa0rSZmofBdw9jqMQ+QC1ls0ucVk0yzDbUVQjNI6Lbux7fnhm
7sUoZVE4yHr4JfhgT0NEpDt25b93P5gG396UizQOex4pfK/uCDpOfnDHE44ROTYn
gX6ELX7y4aOt6yfp5vLOy7S99ZX/nqHMQXdzi8iIK9CkNNQdWCq5+Tufkxt5rpfm
PT0od8mI461PwU78d/WEejls7SkqfxN7wZlFEVTxg0JN5qP8dfiDKVcjufg85E2d
ODY9T10LxIhE9VpEojCWqZAy/RAiMql8YhUJcFv3hFEVR0SaSUSfVCBGZpHrXwHf
qfoeWAiNJ82v5gP0pHrolYSFvgbEka8l1Wf40LF+he2HQzoAzvLqRac0d8q4YVsC
SkVMIbldRMcRxbMmbilkA4ziMaxQz5om9D1dNHOEYK/zDR2gsziSqASB4OPgdl0+
0O3HeJnROEuLt+LUtCHBbV3Qqu1x2+/LiaOJiYLiW2MiUWPZGrl/X610XFx4lZzr
z4PUe9GX9Ee+iPcudikEFFwPLs9UGGLjCXNTQnnsDAVFlHYaIongYzKWUfWD2RyZ
11rCTpSZWaw=
=2WWU
-----END PGP SIGNATURE-----

--=-e6YI0ODnjkEYXObHoFZr--

