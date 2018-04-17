Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35130 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750821AbeDQGdS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 02:33:18 -0400
Received: by mail-wr0-f173.google.com with SMTP id w3so15490986wrg.2
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 23:33:18 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: pradeepc@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k:add support for multicast rate control
Date: Tue, 17 Apr 2018 08:33:12 +0200
Message-ID: <8422067.oV49EfR4qE@bentobox> (sfid-20180417_083322_646235_1123123C)
In-Reply-To: <fe1af65b1042bc3c2b551dcbe7d53f3c@codeaurora.org>
References: <fe1af65b1042bc3c2b551dcbe7d53f3c@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4779734.HQabqmaVvQ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4779734.HQabqmaVvQ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Montag, 16. April 2018 22:10:50 CEST pradeepc@codeaurora.org wrote:
[...]
> > I see two major problems here without checking the actual 
> > implementation
> > details:
> > 
> > * hw_value is incorrect for a couple of devices. Some devices use a 
> > different
> >   mapping when they receive rates inforamtion (hw_value) then the ones 
> > you use
> >   for the mcast/bcast/beacon rate setting. I've handled in my POC patch 
> > like
[...]
> Isn't this already fixed in https://patchwork.kernel.org/patch/9150145/ 
> ?

No, this is exactly the patch which causes the problem for you. The parameter 
for these settings stayed the same but this patch changes the order in 
ieee80211_rate to make it easier for the driver to parse the (reordered) rx 
status information for CCK rates (maybe also tx - not sure about that right 
now).

> > * bcast + mcast (+ mgmt) have to be set separately
> 
> Can you please let me know why this would be necessary?
> Although I see minstrel rate control is currently seems using the 
> mcast_rate
> setting to set MGMT/BCAST/MCAST rates, will this not be misleading to 
> user
> passed value with 'iw set mcast_rate' for MGMT traffic as well?

What about broadcast? MGMT was only mentioned here because it is the third 
item which can be manipulated the same way. But yes, it would be good to get 
the mgmt rates in sync with the non-hw-rate-control drivers.

Kind regards,
	Sven
--nextPart4779734.HQabqmaVvQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlrVlSgACgkQXYcKB8Em
e0YLWBAAmfnmrJgumArkUs0UCtPepXD7kU8lvjkyKxCFWPduV7h2RnGlg7ewQB8l
x64Q622sOMj5q3AEEQ92aMpBygiD7WmqOKdc8vT2ppEKqAUELzXmWu/SzgtZkzDU
rxfi2rrPu1WxH/gyg4Gf8NvFf/w4585SMNwA0U/PLQsgSqqA6H2a45ZAWdGp9ZXe
Ttq2dVklkWzlyVDqYaRcACsM0Jl1ZiQpg7xIgeN2L6cTBkW0+LjlB1cDf0LBEJLY
CLPSR3Eddgdt4aoZ3QMly7VAXN5Nevc3EFKtiGPqG3k/EXYgk+UdZyPrDl+bDGJX
nvhvKWChyld/WaKioBaQ/MDjxwfXDElG3wMszCFB/HdbdR4D12ggAWI1M/kkBvXU
eYJLP3bn/BfKjm6xSzOy3wu5l5kZigWzehkIQKPGS9g+0yg/0UmDPfr4F8U+ZaAb
V84L4G6dVIYEU1Bf7Z0jEieIwl9dxeOZYdyHiruwlydqsf6UY8PLHUsXLt3RHgVn
1rsyVXBdqtS3dgqfPUon2FSzgVrdvTNErbKnJ1ypoISNrqkp1i454j8dweZzzIZl
t3bMsQIu464DOk8onxE7zlevkQpHfQwBWYiEe94XLCa5FNynL4fjP6NIihby4oay
rEqjbam4YeqzOnf1IDFfOA870zY4QbMWH0MbjjN2pBkMtL6C9z8=
=2FLg
-----END PGP SIGNATURE-----

--nextPart4779734.HQabqmaVvQ--
