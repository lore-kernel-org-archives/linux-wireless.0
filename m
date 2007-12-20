Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49176 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbXLTRmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 12:42:54 -0500
Subject: Re: [PATCH 3/8 v2] mac80211: A-MPDU Rx adding basic functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11981435612196-git-send-email-ron.rindjunsky@intel.com>
References: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
	 <11981435612196-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TX0iL6tLJsRYF/wu0wZK"
Date: Thu, 20 Dec 2007 15:41:15 +0100
Message-Id: <1198161675.16241.53.camel@johannes.berg> (sfid-20071220_174259_525362_9FE55B0D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TX0iL6tLJsRYF/wu0wZK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

A few minor comments, looks good otherwise.

>  	status =3D WLAN_STATUS_REQUEST_DECLINED;
> =20
> +

spurious newline added, I'd think.

> +	/* prepare reordering buffer */
> +	tid_agg_rx->reorder_buf =3D
> +		kmalloc(buf_size * sizeof(struct sk_buf *), GFP_ATOMIC);
> +	if (!tid_agg_rx->reorder_buf) {
> +		printk(KERN_ERR "can not allocate reordering buffer "
> +						"to tid %d\n", tid);

Should that be ratelimited just in case somebody is trying over and over
again while we're under memory pressure?

> +	skb =3D dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom + 1 +
> +					sizeof(mgmt->u.action.u.delba));

What's "+ 1"?

> +			printk(KERN_DEBUG "rx BA session requested to stop on "
> +				"unactive tid %d\n", tid);

typo: "inactive"

> +	sta =3D sta_info_get(local, temp_sta->addr);
> +
> +	if (!sta)
> +		return;

Still have that?

Thanks,
johannes

--=-TX0iL6tLJsRYF/wu0wZK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2p/CqVg1VMiehFYAQIQew//QOMCCOq16UJZluqe9RFBClzWvbCyJlkd
b9h4pUn+pgF1lit2MWRpvyZCai0E6SW0AWkEjWUcQrbj7gU8irPgOYMkpmr9NrEW
9SR4+SeREwi/p7SUTgvK9AdGCGAa4f0PCyqFAR4E0Iw/plKMN7GBqKPm8WE9o2+G
YqJRlVmoWy9qijXbRGwYIfAGc5iWmPep6plcRq/hnwjFUAyHIAK8Jk6/cpAoU6RC
rKOapNqogpJ0SYWMPzhdgZ7GUQawPu8NIPjpKHxJykTkp3HXem3JB2SfDFpfIcxt
giyzdp9dI2L2lGQXH/43qcFrhOAUtx/OBmlclbpyiYO5AAjIfJ4KRlN2dcFVYfEG
V9KwfpRje2dvKY432EGLZxkzjjY6RjmxDKYyWge9o46QP6JxtwcW20fhJkB/T0w1
EAoZ7xnVfvu0sjGedbsvSXNM/1m3Lr7QGdO2/fSutrnhmxF3mVpM2SKLxUru1I66
Evh83BKeQcV9ZADbX03FlvtPtdhfOjkR34msW9nBRyMt6kfLC6vwVXiIEDNQB1lL
HNqneRVKGhRzKMWJMXXLkNtEzk9B+g9Sq43s3nW7NyxYKHCJRHocDlrZz41Le6cF
qeoBV4Kww5MRXp4jdevw4pdyzuLXLIj8uKYN6DlBd34ukJTQUJdVrUStum0NSMSr
70107l6W06o=
=4YKb
-----END PGP SIGNATURE-----

--=-TX0iL6tLJsRYF/wu0wZK--

