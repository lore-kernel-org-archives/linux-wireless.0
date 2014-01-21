Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:43883 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbaAUPhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 10:37:42 -0500
Message-ID: <52DE9210.10105@open-mesh.com> (sfid-20140121_163746_235005_EF315CC3)
Date: Tue, 21 Jan 2014 16:28:16 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>,
	thomas@net.t-labs.tu-berlin.de
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	The list for a Better Approach To Mobile Ad-hoc
	 Networking <b.a.t.m.a.n@lists.open-mesh.org>
Subject: Re: [RFC 0/5] Export Minstrel best API information via get_station()
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com> <28926A5E-E0FA-4677-BC0C-68E5E11C188F@net.t-labs.tu-berlin.de>
In-Reply-To: <28926A5E-E0FA-4677-BC0C-68E5E11C188F@net.t-labs.tu-berlin.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="etXUxBQrwh2QJ7PL1bGvuEv4RTDOeIjAP"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--etXUxBQrwh2QJ7PL1bGvuEv4RTDOeIjAP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

[added batman-adv mailing list to the CC]

On 21/01/14 14:52, Thomas H=FChn wrote:
> Hi Antonio,
>=20
> I like you idea of making use of information from different layers to t=
ry to enhance wireless communication.=20
> It seems reasonable for me to start exporting and further using/experim=
enting with that rate, where minstrel estimates the maximum throughput.
> But on closer inspection, it might also be of certain interest (maybe n=
ot batman in particular) to use the most robust rate, which both Minstrel=
s version do also have an estimate.
> So what do you think about exporting the whole sorted rate table struct=
ure (struct ieee80211_sta_rates) instead of extracting the single max thr=
=2E rate ?
>=20

Thank you very much for your feedback!

I like your idea about opening this change a bit more and allow other
modules to use the same information.

However the ieee80211_sta_rates structure you mentioned is mac80211
private and it does not carry any data about the probability of success
(which is a Minstrel specific value and for this reason it is not
present in this ieee80211 generic structure).


Assuming that we want to keep the new exported data Minstrel specific
(we really want this), we could extend the station_info to carry a *set*
of "cfg80211_minstrel_rate_info" objects (new struct introduced within
this patchset) which could represent the sorted rate table.

However I am not sure how this table can be used once exported, since
the only thing having a meaning is the order. Other than that I don't
see what a module could do with it (other than choosing the first entry).=



Instead of exporting the whole rate table, should we only report those
rates that have a particular meaning for Minstrel?
I think Minstrel is the only component having enough information about
which rate is meaningful and which not. What do you think?


This could be done by exporting several cfg80211_minstrel_rate_info, e.g.=

- max_throughput_rate
- most_robust_rate
- ...

(I used random names here)


Cheers,

> Greetings Thomas
>=20
>=20
> On 21.01.2014, at 12:09, Antonio Quartulli <antonio@meshcoding.com> wro=
te:
>=20
>> Hello list,
>>
>> we (as batman-adv developers) are currently working on a new version o=
f the
>> our routing protocol which is going to use some Minstrel internal info=
rmation
>> to compute the metric.
>> In particular I am interested in the currently selected bitrate (which=
 Minstrel
>> selected because it "maximises the throughput") and it's probability o=
f success.
>>
>> To achieve so I am proposing here a change to the get_station API.
>> This change is supposed to export the needed information only if the c=
urrent
>> driver is using the Minstrel (or Minstrel HT) RC algorithm.
>>
>> Patch 1 introduced the change in get_station()
>> Patch 2 add a new rate_control API used to query the RC algorithm and =
retrieve
>>        the information. Then it fills the sinfo object.
>> Patch 3 and 4 are implementing this rate_control API in minstrel and m=
instrel_ht
>> Patch 5 exports the get_station API in order to allow other modules to=
 use it.
>>
>>
>> I already had a discussion with Johannes about this patch being not ge=
neric
>> enough and really focussed on Minstrel only.
>>
>> However this change will just
>> introduce a new exported capability in the station_info object: if the=
 driver
>> does not support it (e.g. it does not use Minstrel) then we simply won=
't have
>> this information (like we already do with other capabilities).
>>
>>
>> Cheers,
>>
>> p.s. I may need to add some more kerneldoc
>>
>>
>> Antonio Quartulli (5):
>>  cfg80211: export minstrel best rate information through get_station()=

>>  mac80211: export minstrel best rate information in set_sta_info()
>>  mac80211: minstrel - implement get_minstrel_best_rate() API
>>  mac80211: minstrel_ht - implement get_minstrel_best_rate() API
>>  cfg80211: implement cfg80211_get_station
>>
>> include/net/cfg80211.h             | 28 ++++++++++++++++++++++++++++
>> include/net/mac80211.h             | 15 +++++++++++++++
>> net/mac80211/cfg.c                 | 15 +++++++++++++++
>> net/mac80211/rc80211_minstrel.c    | 12 ++++++++++++
>> net/mac80211/rc80211_minstrel_ht.c | 30 ++++++++++++++++++++++++++++++=

>> net/wireless/nl80211.c             | 22 ++++++++++++++++++++++
>> 6 files changed, 122 insertions(+)
>>
>> --=20
>> 1.8.5.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wirele=
ss" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Antonio Quartulli


--etXUxBQrwh2QJ7PL1bGvuEv4RTDOeIjAP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3pIUAAoJEEKTMo6mOh1VL48P/2+jkNbyM0RbI/W5Ycjnf85W
vbMTaixUDnnlM+NCcAzvo+fa5qP9WaElx3qECwcNnktriPGZe8SkpgX9lpS6DMgX
/Dc63okEshA9nzSuVoHwG9yDwMNKdWjDVwtOUT69iF2svxztg3dIw4kfxgS5yCM2
fIZTs4EJ7wZoO1GvzRRp7iXo+9Go+XECyuploXrKLTmt9sOcK2vaETsX41SfsKm/
9ERgR9I8mMXTfnkseQS+Taf01gyVNWsk4V1a25IZrkUKwf6IG5XRHgZkjCxT2REA
ileoqFbO5RhEmaN4KRCWZIBO0qIupr/4VVi6sHSNeE+k+xJdXA/pcfzPGhcJAVm1
x+ZFN1PGGa7DQsH/1RpwcLINMvJ0EMfcI4fb3nXj3zV32lX3Ee7y7ehDAADqVx5+
Tl4r6xO0fo/SvayTREMZyQePuAot23MT1+RpWU/4Bs6xoTc//7QeOf+cV4rCReAE
g21vk9ZcwtTExGXg6s6cDoq9GodMzut0PB9OkAaxoDKJqOoJASH36sgdu6x1HfaV
9UEaPxR7/uRmq2h4T0v4zvlcUkvtQZ+NqS39kDYX5Z9vzr1StEhPAdASp7MJXrhy
zKEaqqKRBq9R8dRWJ4efvdIzz9FczrhY3VcH3HBoKWATkqLWTg6OTVNrafY6tHpl
KvQ3QWXV+jm4sh0bRZPk
=dpBi
-----END PGP SIGNATURE-----

--etXUxBQrwh2QJ7PL1bGvuEv4RTDOeIjAP--
