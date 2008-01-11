Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832AbYAKV1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 16:27:42 -0500
Subject: Re: [RFC PATCH 02/10] mac80211: A-MPDU Tx add MLME structures
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11999857492094-git-send-email-ron.rindjunsky@intel.com>
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857492094-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Mb9B11bveUSXoNImA9yZ"
Date: Fri, 11 Jan 2008 17:31:33 +0100
Message-Id: <1200069093.3861.183.camel@johannes.berg> (sfid-20080111_212745_541323_143B9B5A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Mb9B11bveUSXoNImA9yZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> +#define HT_AGG_STATE_INITIATOR_MSK      BIT(HT_AGG_STATE_INITIATOR_SHIFT=
)

I think you should use a tab here instead of spaces ;)

>  struct sta_ampdu_mlme {
>  	struct tid_ampdu_rx tid_rx[STA_TID_NUM];
> +	struct tid_ampdu_tx tid_tx[STA_TID_NUM];
>  	spinlock_t ampdu_rx;
> +	spinlock_t ampdu_tx;
> +	u8 dialog_token_allocator;
>  };
> =20
>  struct sta_info {
> @@ -148,6 +175,7 @@ struct sta_info {
>  					     of this STA */
>  	struct sta_ampdu_mlme ampdu_mlme;
>  	u8 timer_to_tid[STA_TID_NUM];	/* convert timer id to tid */
> +	u8 tid_to_tx_q[STA_TID_NUM];	/* map tid to tx queue */

I wonder if we're reaching a point where this is blowing up the sta info
stuff enough to warrant putting in ifdefs for the aggregation stuff...
When you have a small AP where you know it won't be able to do
aggregation due to the hardware, you could turn it off and save a
significant amount of memory per sta-info. Not sure though, and we
should definitely do it *after* this patch series if at all.

johannes

--=-Mb9B11bveUSXoNImA9yZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4eZ5KVg1VMiehFYAQITFRAApZSMikz8sR/RFm21X+Cy3/7xjzl7shxb
e0Z9tK3BV1lh5aELxpGsG23S28/iE1r3qYmY4+dFTN1cxOq1DXheFzsFzYey/J1D
4ZIDWWBiRItJZtZUS8J5XhTp1PwCB7blecPSK6q2TJHIpxgSFVK3qoQKo4lgWiAt
7zjzxJBCQ1bkdB3fnBCgtBpx9qjajynQNYAGSv/w/uCMsrOdNFwBgeIM0ipDELXL
qevvlXU0eH2H72pN5bcpIBKWFxV0kMk4ZaQRN8fZ6Iog+WebjBTqaeXhUZgQGQ3i
yXuxZuRkhAZCwf+CNX0R8v/6LAEBHTLzUOn34Y6m+YeaU7zB7YkZVmsF73cTexrP
ewMM2PlSC5TfSSk23XCBcosKVGN7ESomUkkcgH82iMUEJMP2wWiWef6dO2ojKmx2
zD+Bfm7OMHgeu6pYafyvNMrlvNRKWUsZm+eCw+/CLcl9Nophm5cFASAMJo0QW5KR
9j3mb8afBVP/gZMOUGg9rVPn18k373wcAhYGNNPWlx4PR6VEsK6rw+jWYTFp9Qbt
7dEyI9S6ojGzwDhD+IxttqeTIlx5Yh+UXtzZV+eITnezf1SZh8OrP9JxLUCy8I2+
BQ7WRFZFBebZfeWZAea7lEJT+ime3wwbP2HEb89gN7apsmIT49WglyJsSJB/KdeK
bT0B5GQkQJk=
=veCH
-----END PGP SIGNATURE-----

--=-Mb9B11bveUSXoNImA9yZ--

