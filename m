Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37761 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbZLDM35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 07:29:57 -0500
Subject: Re: [PATCH] mac80211: Fix bug in computing crc over dynamic IEs in
 beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
In-Reply-To: <1259928694-7824-1-git-send-email-vasanth@atheros.com>
References: <1259928694-7824-1-git-send-email-vasanth@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-X+R/Cc+sgoMRyz+cgOl5"
Date: Fri, 04 Dec 2009 13:29:58 +0100
Message-ID: <1259929798.29974.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X+R/Cc+sgoMRyz+cgOl5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-12-04 at 17:41 +0530, Vasanthakumar Thiagarajan wrote:
> On a 32-bit machine, BIT() macro does not give the required
> bit value if the bit is mroe than 31.=20

For some reason I thought it did, thanks.

> In ieee802_11_parse_elems_crc(),
> BIT() is suppossed to get the bit value more than 31 (42 (id of ERP_INFO_=
IE),
> 37 (CHANNEL_SWITCH_IE), (42), 32 (POWER_CONSTRAINT_IE), 45 (HT_CAP_IE),
> 61 (HT_INFO_IE)). As we do not get the required bit value for the above
> IEs, crc over these IEs are never calculated, so any dynamic change in th=
ese
> IEs after the association is not really handled on 32-bit platforms.
> This patch fixes this issue.

Right. Note that this function may need to be changed/extended if we
ever need to watch for changes in even higher IEs, but so far we don't.

johannes


--=-X+R/Cc+sgoMRyz+cgOl5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLGQDCAAoJEODzc/N7+QmaZxkQAId1+suJSjMgYrtJgtvq2V3G
EfHDE2dmW4pAqSqrHiyI4RbW79aGBDodEVBIHvAMO6UDv/NQ0JFsu4Qe3VLcWyG8
g/m4+JoQj08SCktBs+pFM1qprUFArtNuqPdiuA9nB+H4fOu7KcorQ7EO+Vxbyz3Z
3fHgEuC9zxSkOJbKPb9ZzPQ4/7qVo+MKp1dcQy+jMp66zEr3yOZxwEGblDerE858
HXNE901jp2egGs8pG+YZoUuLolZZ/6P+TlxS7ikg65HFRnUXKWe4Ruan9AIif9ay
cMmw1so4x59QFmqQsDyofE3ms6Qjyflr07WFi6JQHywQ2SX/77Rt83MEQ0i5vNsp
o1RT9nx0b8blUr2W+f8HSxgDtcIqeLKDA32SfLDB1C0uQx7OyUZNIiEkhU9gPGkc
+bnrTHt6MOarArTRPl3tjoKax63GwNyGPRUhzlhjbD25PLe9N3l49hpOoPTlJlsQ
jMS1egKcRoECWrxt5gc3LpNNavctoaPUlqR3u2E2hzz33G91Rbty8cjFCYJ8TiHw
V3pJTXSqkrN/CefIyNtvfxQgiHrS7T6Lw8wf5LRybyUljL3pn7CbIZ6OAfeFtHi+
19yg02YppftBx2lW8xLVqOdjYgj6TnQRATjKKpuLpsKgBctU1eF8BHWakgRdmsOP
eYu6rd5/ZvUhUBgVS7ol
=KOv+
-----END PGP SIGNATURE-----

--=-X+R/Cc+sgoMRyz+cgOl5--

