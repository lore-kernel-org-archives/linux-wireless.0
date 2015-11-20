Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36313 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162723AbbKTMxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 07:53:39 -0500
Received: by pacdm15 with SMTP id dm15so116220928pac.3
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2015 04:53:38 -0800 (PST)
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if requested
To: Johannes Berg <johannes@sipsolutions.net>
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com>
 <1447464560-28104-2-git-send-email-antonio@meshcoding.com>
 <1448016547.3141.4.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
From: Antonio Quartulli <antonio@open-mesh.com>
Message-ID: <564F1790.7030309@open-mesh.com> (sfid-20151120_135342_850532_59E6315E)
Date: Fri, 20 Nov 2015 20:52:32 +0800
MIME-Version: 1.0
In-Reply-To: <1448016547.3141.4.camel@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ai6qep7n1gwLo3VBK2Nh3Ab3Hvti3EB5n"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ai6qep7n1gwLo3VBK2Nh3Ab3Hvti3EB5n
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 20/11/15 18:49, Johannes Berg wrote:
>=20
>> @@ -599,7 +599,9 @@ static int __ieee80211_start_scan(struct
>> ieee80211_sub_if_data *sdata,
>> =20
>>  		if ((req->channels[0]->flags &
>>  		     IEEE80211_CHAN_NO_IR) ||
>> -		    !req->n_ssids) {
>> +		    !req->n_ssids ||
>> +		    ((req->channels[0]->flags &
>> IEEE80211_CHAN_RADAR) &&
>> +		     (req->flags &
>> NL80211_SCAN_FLAG_PASSIVE_RADAR))) {
>>  			next_delay =3D IEEE80211_PASSIVE_CHANNEL_TIME;
>>
>=20
> I don't really see any circumstances under which it's valid to actively=

> scan radar channels ... seems like we should do this unconditionally?

I think it would be reasonable only if the target channel is the one we
are using and we have done CSA. But when scanning non-operative channels
I don't think this could work.

As discussed on IRC I'd rather go for passively scanning any DFS channel.=


Cheers,


--=20
Antonio Quartulli


--ai6qep7n1gwLo3VBK2Nh3Ab3Hvti3EB5n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWTxeZAAoJENpFlCjNi1MRS0EQAJzlei4jwUXayNzknivBcQrt
OO2f2hYgWItXUs1fCTQAuhJPvr6lCPWgurPowL/Jcr6j80+lPPnug04n7qWcL2GR
036DDbFTm8mxVew7OeQ8XnRzwa50NOH66Z2JiZx8X+kOjPMc2b9P3Y146vK/Hbo+
T6vCZS5J9Y8VEpY6Uj9PX72y+ou+BeZ4VqYq5j6+Gp23YfrN8reRY38so61RPmwJ
KumI2vBoq0T+woTcYBIDsMEo+U8sqQZTDEbZxxMbCfatLJPankb5cqyMYA3sHkle
3mPgLXOcngs0tqmNzAENYdX4Qtn9gbcL+8uXFcUs7QPaLqeIdzz3ptVVnerQboI4
j7tp5ZaCF3kjgHjCVSps+i/cyjql4BzZMz4uWcJ9IE5G2UtmqXYg07rusvxcY9Mv
RF3mifJy+3b5SGG3K/WemsW14SThxLS9DEGFrFJh3JCPgUNgRyMBd873jDlCraUS
VOaooEeY2LJ3mymJY3gnBFM/kcgawqEBUJb9vSxudd3VAqE4z1IFe5pNw4DvWWMR
+akOQixyFpFuUpOzpPEUuk356ITud68uxQ7mkwKk8XxXQNYJgWP3lCGL79d/A9DZ
SHY2gihjqCDT17pOJn6AsC0DkJXlca94JeGAyHt++WjvALAIDRZeaG2TID2Xz1Hx
qPM2ak64HqOsYFuoBYdL
=yAFj
-----END PGP SIGNATURE-----

--ai6qep7n1gwLo3VBK2Nh3Ab3Hvti3EB5n--
