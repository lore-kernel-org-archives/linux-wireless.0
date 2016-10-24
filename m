Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s2.neomailbox.net ([5.148.176.60]:23202 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934818AbcJXMMO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 08:12:14 -0400
Date: Mon, 24 Oct 2016 20:11:29 +0800
From: Antonio Quartulli <a@unstable.cc>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if requested
Message-ID: <20161024121129.GA8925@prodigo.lan> (sfid-20161024_141245_467712_383AFA34)
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com>
 <1447464560-28104-2-git-send-email-antonio@meshcoding.com>
 <1448016547.3141.4.camel@sipsolutions.net>
 <564F1790.7030309@open-mesh.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
In-Reply-To: <564F1790.7030309@open-mesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2015 at 08:52:32PM +0800, Antonio Quartulli wrote:
> On 20/11/15 18:49, Johannes Berg wrote:
> >=20
> >> @@ -599,7 +599,9 @@ static int __ieee80211_start_scan(struct
> >> ieee80211_sub_if_data *sdata,
> >> =20
> >>  		if ((req->channels[0]->flags &
> >>  		     IEEE80211_CHAN_NO_IR) ||
> >> -		    !req->n_ssids) {
> >> +		    !req->n_ssids ||
> >> +		    ((req->channels[0]->flags &
> >> IEEE80211_CHAN_RADAR) &&
> >> +		     (req->flags &
> >> NL80211_SCAN_FLAG_PASSIVE_RADAR))) {
> >>  			next_delay =3D IEEE80211_PASSIVE_CHANNEL_TIME;
> >>
> >=20
> > I don't really see any circumstances under which it's valid to actively
> > scan radar channels ... seems like we should do this unconditionally?
>=20
> I think it would be reasonable only if the target channel is the one we
> are using and we have done CSA. But when scanning non-operative channels
> I don't think this could work.
>=20
> As discussed on IRC I'd rather go for passively scanning any DFS channel.
>=20
> Cheers,

Hey Johannes,

this has been sleeping for a while.. :)
Would it make sense to rebase it and resubmit it for inclusion?

Given the previous discussion we could change the logic as:
* always passively scan DFS channels that are not usable
* always actively scan DFS channels that are usable (i.e. CAC was performed=
).

How does it sound? this would totally avoid the use of the switch in the sc=
an
command.

Cheers,


--=20
Antonio Quartulli

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYDfpuAAoJEJ6F1zG2JyOs4/cQAIa1c/IolkbpbUxdzovmL4E5
JUcAKLNgF/UOf3izlY+SY7eXa256nhJdZY7B892WWwfwFhhPlKuQitIWqayLn/j9
yNQe0Ci82NKf4mXhGIwuGaRgOz68Zk0QDZkpjTFVXcMNSNzTz/BkzmTg7tNmw1/H
pIzIcRv/qbExfVlJBbCKDTPsq+PMzrbzDUMzx1mN4ZK2zd7hqB2/Vpu3gQqe9FVk
3y4o76ktDyWvPb8p5jEUJDtvPUAqvZpdHGoLoXtxqbh6823KWIIyWNvjNTrPdLym
OEamQPMKlilLDnVz2Kksfk3wC/NtPvC8Yo8+vd/wZTxOOFJUJeV9sRSnQQQADwj8
HInemcw8KMNz3mV9VSN6REPvI2Ecd5wfoqG/0cO3UREWxh5gxRvB3PKKzh8VxRNs
+mMJN7fDRlqaW4pdF2nCOUaoJpu11sUUcBBscSh3MBdsSM0HxvTkix4BWshyhct6
ohgs3cY1OTaKpgnOoN2z1M7evpBZa5NgyScfHUA6DIzIHs2JAjzET1fND4CURTm7
1JQ6KvhoQxgzIMIRs65QGf9aHDqNf7bCZLIzNbwcC/roNQm6fu27ChEenEKXAduE
XHU1rW9E5oXKSa6R1SAB8caocKyg0Jf+E3OManm/v0Jv0KLvg674F8vTO9oHJgZd
OreCb7B2xlwrHwMH7GtA
=iJQ1
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
