Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arabica.frei.media ([176.9.117.169]:41330 "EHLO mail.frei.media"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750892AbdGGMMw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 08:12:52 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_754F0F17-EE0B-4C93-BE92-01E9FC86C0CE"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH] ath10k: set a-mpdu reference number in ath10k (receiver)
From: Matthias Frei <mf@frei.media>
In-Reply-To: <87o9syf1uf.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 7 Jul 2017 14:12:41 +0200
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-Id: <D2C4D994-E760-490A-805C-494D05BA46F2@frei.media> (sfid-20170707_141255_719371_08B2AAAE)
References: <B8D63297-0A88-42A3-B789-3849895CF201@frei.media> <87o9syf1uf.fsf@kamboji.qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Apple-Mail=_754F0F17-EE0B-4C93-BE92-01E9FC86C0CE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

> So this counter is per wiphy, not per vdev. Is that ok?


Well, I think this should be okay.
The counter depends on the point of view. Counting per wiphy and looking =
on the physical transmission it counts every incoming ampdu that was =
received by the physical wireless card. On the other hand, looking =
=E2=80=9Edown the network stack=E2=80=9C from the application layer, you =
may want a consistent ampdu reference number.
I think doing the counting per wiphy should be okay, because it is still =
a virtual counter on the receivers site. Doing the counting per wiphy =
still allows to identify aggregated mpdu=E2=80=99s on the application =
layer, as you just search for mpdus with the same reference number. =
Additionally, counting per whipy enables you to get a feeling on the =
application layer, how much incoming load the wiphy has to handle at the =
moment. Considering this counter is only used for debugging and =
research, this additional information can be useful or if not, it does =
not change anything.


> What about locking? How is this protected or doesn't it need anything?
I don=E2=80=99t think locking is needed here since the counter is per =
wiphy and it is only incremented on the last mpdu of a ampdu. =
Additionally, locking is also not used in ath9k.

Thanks!
Best,
Matthias Frei



> Am 06.07.2017 um 09:42 schrieb Kalle Valo <kvalo@qca.qualcomm.com>:
>=20
> Matthias Frei <mf@frei.media> writes:
>=20
>> Set the a-mpdu reference number in ath10k to make it accessible in =
the receivers radiotap header. Implemented as in ath9k.
>> The reference number is needed for troubleshooting and research at =
the receivers site (e.g. to identify mpdu's that were aggregated in an =
a-mpdu)
>>=20
>> Signed-off-by: Matthias Frei <mf@frei.media>
>=20
> I did some changes in pending branch, please review them:
>=20
> =
https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=3D=
pending&id=3Df722728460a5c9e9200a7f1362fa605a714c1968
>=20
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -989,6 +989,9 @@ struct ath10k {
>> 		u32 reg_ack_cts_timeout_orig;
>> 	} fw_coverage;
>>=20
>> +	/* AMPDU */
>> +	u32 ampdu_ref;
>=20
> The comment is not providing any extra value, I'll remove that.
>=20
> What about locking? How is this protected or doesn't it need anything?
>=20
> Also I renamed this to ampdu_reference just to be consistent with the
> mac80211 name.
>=20
>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> @@ -877,16 +877,24 @@ static void ath10k_htt_rx_h_ppdu(struct ath10k =
*ar,
>> 		status->nss =3D 0;
>> 		status->encoding =3D RX_ENC_LEGACY;
>> 		status->bw =3D RATE_INFO_BW_20;
>> -		status->flag &=3D ~RX_FLAG_MACTIME_END;
>> -		status->flag |=3D RX_FLAG_NO_SIGNAL_VAL;
>> +		status->flag &=3D ~(RX_FLAG_MACTIME_END | =
RX_FLAG_AMPDU_IS_LAST);
>> +		status->flag |=3D RX_FLAG_NO_SIGNAL_VAL | =
RX_FLAG_AMPDU_DETAILS | RX_FLAG_AMPDU_LAST_KNOWN;
>=20
> This added a new warning:
>=20
> drivers/net/wireless/ath/ath10k/htt_rx.c:894: line over 90 characters
>=20
> I fixed that by separating the setting of ampdu flags.
>=20
>> +		/* set ampdu ref */
>> +		status->ampdu_reference =3D ar->ampdu_ref;
>=20
> The comment is not telling anything new so removed it.
>=20
>> -	if (is_last_ppdu)
>> +	if (is_last_ppdu) {
>> 		ath10k_htt_rx_h_mactime(ar, status, rxd);
>> +
>> +		/* set ampdu last segment flag */
>> +		status->flag |=3D RX_FLAG_AMPDU_IS_LAST;
>> +		ar->ampdu_ref++;
>> +	}
>=20
> So this counter is per wiphy, not per vdev. Is that ok?
>=20
> --
> Kalle Valo


--Apple-Mail=_754F0F17-EE0B-4C93-BE92-01E9FC86C0CE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: FREI.media

iQIcBAEBCgAGBQJZX3q6AAoJEEwLkI6cZ4BOsUsP/3qA458WhIk8kMBsZmfDF7fZ
xz+19hLZcVfvnvF8YZEDpPJYSrSOk8tibO1wJsqK7lrZ+0eYmwK0zgjD6w6WxVtX
8wt+mRZ41IQVQqfNMcauqf9W+Zt9dhRrh3GMDMaCXp0vmNj/BQYQtGmiW9nlIZxM
atDRQG88ytf8ijSi+Ry+jaSZy6Wdl5cF9zwpQ+e7NkYo75heen/T9pKrcr0u29pV
Y+4pZq2OijGHYbUkoAucB0De2jqiY6s1K6QygjDMk7FxQsrEo0wL7GiPyJ9RI4Ca
yUYeWE039T2p60QarsHkC/DZrK1tVmqK2pJfe6MEMHVKz3nMMT5oSlOEVn42Lfjj
A+Ul4QNmhtnC4tUVojAsEmxgerj1lPOS3s6I/GZMGWMHYezJ+gMncCNAe+QTwmSx
yHg1lUA03SPcVfxFfPqolkKmEoqLRpTRfHnE3EpJNn7/NmvgMQ0eHuyYRrxw8CvI
iE4mP+AuUVwzQMPdT9EnBgH03TxiJbloobG1/399Qap1NQFPiWwpF42ulLCNvJEa
5IhNM00t3IeemTJXk47l2tCWIpuDZOKBpGHOEMw5wCqiWbxgu0PcmJAoLrjKTQe/
t9+oUSnR92ka1870xCHhrgAEXAy8d+Uk7PFQzRflcCMAsiMmIOyAI9gHo/OLJHAq
/K775KOjK1O8uXCJcH9L
=n7uk
-----END PGP SIGNATURE-----

--Apple-Mail=_754F0F17-EE0B-4C93-BE92-01E9FC86C0CE--
