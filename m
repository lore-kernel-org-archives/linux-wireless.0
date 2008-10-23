Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5-g19.free.fr ([212.27.42.35]:45698 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbYJWFbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 01:31:16 -0400
Message-ID: <49000C21.2010808@free.fr> (sfid-20081023_073128_736473_93064082)
Date: Thu, 23 Oct 2008 07:31:13 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [PATCH 4/5] crda: Updated regulatory information for France	(FR)
References: <cover.1223583376.git.benoit.papillault@free.fr> <48FE399E.6050907@free.fr> <20081022150323.GO6190@tesla>
In-Reply-To: <20081022150323.GO6190@tesla>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Luis R. Rodriguez a =E9crit :
> CC'ing Jean as he's another French wireless developer.
>=20
> On Tue, Oct 21, 2008 at 01:20:46PM -0700, Benoit PAPILLAULT wrote:
>> This patch is for review. It might be tricky to use the INDOOR/OUTDO=
OR
>> with those definitions, but it will be another issue.
>=20
> INDOOR/OUTDOOR flag is welcomed when it can be determined. In order
> to make use of it we will need to add wireless state in cfg80211, and
> let the user be able to update this, say through iw or wpa_supplicant=
=2E
> But that's for later just as with DFS.

=46ine with me here.

>=20
> But using it in the db is great, thanks.
>=20
>> Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
>> ---
>>  db.txt |   15 ++++++++++-----
>>  1 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/db.txt b/db.txt
>> index 6a282b6..bfc91ef 100644
>> --- a/db.txt
>> +++ b/db.txt
>> @@ -199,12 +199,17 @@ country FI:
>>         (5170 - 5250 @ 40), (N/A, 20)
>>         (5250 - 5330 @ 40), (N/A, 20), DFS
>>         (5490 - 5710 @ 40), (N/A, 27), DFS
>> -
>> +# Data from http://www.arcep.fr/index.php?id=3D9272#12931
>> +# Updated 2008-10-04
>> +# 1W =3D> 30dBm, 200mW =3D> 23dBm, 100mW =3D> 20dBm, 10mW =3D> 10dB=
m
>> +# TPC is needed for 5250-5350 and 5470-5725, which flag to use?
>>  country FR:
>> -       (2402 - 2482 @ 40), (N/A, 20)
>> -       (5170 - 5250 @ 40), (N/A, 20)
>> -       (5250 - 5330 @ 40), (N/A, 20), DFS
>> -       (5490 - 5710 @ 40), (N/A, 27), DFS
>> +       (2400 - 2454 @ 40), (N/A, 20)
>> +       (2454 - 2483.5 @ 40), (N/A, 20), NO-OUTDOOR
>=20
> 2483.5 - 2454 =3D 29.5 so 29.5 should be the max bandwidth.

Not exactly. The maximum power in this band depends on whether we are
indoor or outdoor. If we are indoor, we are allowed to have 20dBm in th=
e
whole 2400 - 2454 MHz band and can still use 40MHz bandwidth. Maybe I
should describe that different?

	(2412 - 2483.5 @ 40), (N/A, 20), NO-OUTDOOR
        (2412 - 2454 @ 40), (N/A, 20), NO-INDOOR
        (2454 - 2483.5 @ 40) (N/A, 10), NO-INDOOR

In fact, this depends on the indoor/outdoor flags issue which can be
resolved later.

>=20
>> +       (2454 - 2483.5 @ 40), (N/A, 10), NO-INDOOR
>=20
> Same here.
>=20
>> +       (5150 - 5250 @ 40), (N/A, 23), NO-OUTDOOR
>> +       (5250 - 5350 @ 40), (N/A, 23), NO-OUTDOOR, DFS, PASSIVE-SCAN
>> +       (5470 - 5725 @ 40), (N/A, 30), DFS, PASSIVE-SCAN
>=20
> Hm, actually so I had removed PASSIVE-SCAN from all entries
> as I had determined that this was only used for DFS purposes.
> As you can see in your case both have DFS so I'd leave only DFS.
> So essentially we can get rid of these:
>=20
>         RRF_PASSIVE_SCAN        =3D 1<<7, /* passive scan is required=
 */
>         RRF_NO_IBSS             =3D 1<<8, /* IBSS is not allowed */
>=20
> What I noted was that PASSIVE-SCAN for example was only used for when
> we don't have DFS in STA and NO_IBSS when we don't have DFS in IBSS.
>=20
> So we can just stick to DFS flag, unless you are aware of other
> considerations for them. Thoughts?

If it's documented that the DFS flag implies PASSIVE_SCAN, that's fine
with me.

>=20
>   Luis

Regards,
Benoit
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJAAwhOR6EySwP7oIRApcqAKC/+B/fPUu6+8caHOqnA/GwsnGCdwCfcuSR
YX46su0CSrQCynR/RQ1CLnM=3D
=3D9NM9
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
