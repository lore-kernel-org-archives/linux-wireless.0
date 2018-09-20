Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55114 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387541AbeITTNj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 15:13:39 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kbuild@01.org, kbuild-all@01.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, Eliad Peller <eliad@wizery.com>,
        mathias.kretschmer@fit.fraunhofer.de
Subject: Re: [PATCH] mac80211: allow scans on radar channels, unless there is CAC or CSA
Date: Thu, 20 Sep 2018 15:30:05 +0200
Message-ID: <1800056.zUtZK9dVLA@prime> (sfid-20180920_153011_587391_2537E072)
In-Reply-To: <20180920092014.ajgykw7o7p73grfj@mwanda>
References: <20180920092014.ajgykw7o7p73grfj@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3798042.skqdUvjsf2"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3798042.skqdUvjsf2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Dan,

whoops, right ... thank you!

Will do in a v2, at least if this patch is wanted. :)

Thank you!
     Simon

On Thursday, September 20, 2018 12:20:14 PM CEST Dan Carpenter wrote:
> Hi Simon,
> 
> I love your patch! Perhaps something to improve:
> 
> url:   
> https://github.com/0day-ci/linux/commits/Simon-Wunderlich/mac80211-allow-sc
> ans-on-radar-channels-unless-there-is-CAC-or-CSA/20180919-071924 base:  
> https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git master
> 
> New smatch warnings:
> net/mac80211/scan.c:508 ieee80211_can_scan() warn: signedness bug returning
> '(-16)'
> 
> Old smatch warnings:
> net/mac80211/scan.c:511 ieee80211_can_scan() warn: signedness bug returning
> '(-16)'
> 
> #
> https://github.com/0day-ci/linux/commit/ad9617f275c425ddf25eb83678062ab87d4
> c0870 git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout ad9617f275c425ddf25eb83678062ab87d4c0870
> vim +508 net/mac80211/scan.c
> 
> f3b85252 Johannes Berg     2009-04-23  503
> 133d40f9 Stanislaw Gruszka 2012-03-28  504  static bool
> ieee80211_can_scan(struct ieee80211_local *local, ^^^^
> 133d40f9 Stanislaw Gruszka 2012-03-28  505  			       struct
> ieee80211_sub_if_data *sdata) 133d40f9 Stanislaw Gruszka 2012-03-28  506  {
> ad9617f2 Simon Wunderlich  2018-09-18  507  	if (sdata->wdev.cac_started)
> ad9617f2 Simon Wunderlich  2018-09-18 @508  		return -EBUSY;
>                                                         ^^^^^^^^^^^^^
> ad9617f2 Simon Wunderlich  2018-09-18  509
> ad9617f2 Simon Wunderlich  2018-09-18  510  	if (sdata->vif.csa_active)
> ad9617f2 Simon Wunderlich  2018-09-18  511  		return -EBUSY;
>                                                         ^^^^^^^^^^^^^^
> 164eb02d Simon Wunderlich  2013-02-08  512
> 2eb278e0 Johannes Berg     2012-06-05  513  	if
> (!list_empty(&local->roc_list)) 133d40f9 Stanislaw Gruszka 2012-03-28  514 
> 		return false;
> 133d40f9 Stanislaw Gruszka 2012-03-28  515
> 133d40f9 Stanislaw Gruszka 2012-03-28  516  	if (sdata->vif.type ==
> NL80211_IFTYPE_STATION && 392b9ffb Stanislaw Gruszka 2013-08-27  517  	   
> sdata->u.mgd.flags & IEEE80211_STA_CONNECTION_POLL) 133d40f9 Stanislaw
> Gruszka 2012-03-28  518  		return false;
> 133d40f9 Stanislaw Gruszka 2012-03-28  519
> 133d40f9 Stanislaw Gruszka 2012-03-28  520  	return true;
> 133d40f9 Stanislaw Gruszka 2012-03-28  521  }
> 133d40f9 Stanislaw Gruszka 2012-03-28  522
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology
> Center https://lists.01.org/pipermail/kbuild-all                   Intel
> Corporation


--nextPart3798042.skqdUvjsf2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAlujoN0ACgkQoSvjmEKS
nqF/+w/+KHuewkr+mtESKFJj8kGjKVukEsV1lzaKgV26YI0fTOIrbUah8XfdbnAa
or+bWNiejjnALoWYIZMAfNQGnYERTsBNZfocr/NCkHLi2/dpiwgJwHd2+qu2aGJ+
Sc3C7UVKkFhDtImCbHsCLCKJb7yWalEcta/MBaTeAi6tlLJwfcqQ493h2iztas2D
RVWM5MDkYCYbqjI3KHoQIOjTJ1DkwTUEiU54JM6+HUvR8wmyLcpTSShHPqRoxh6H
tSIijXLiP9kyrzPx2ZRCnFCHARt2h+tFYVekv0tZV1l71Z8xS8sEf/tQwYLl9dfn
h3gzAMtqWavPZZwm+1ow3LQFgEZaNxO4e66rIPXb3RGntHHPGNTsfUxFUiQTfs2V
gME8CG/4SYqDEeHf/5DfdbbnDyZ7QN0ISAmnDARKPl+Xy2bMfJGAGHxILJM7xN/P
Ca8f73kd7FExv4zqfbtl3t13FJ+t/ZWRufIe7cLWcvHPs7a1k3EM9nXtti3/Z8wH
y/hlVPIbStTpSWaCc/olUlYEdshIJ+hoN3o5d2hTJpsH8M/mJk5LdYaoy3Oqf0Ok
VQH8LrNou+Bva+0E8QjMBbBs0vhPl+F4iHaihu1Q6hT+G2OCyHzDQ89DdylABaLW
puzzNXu0zPu9PC3dP+qtbiQdbV/4LfMKrQBPaM6OAnUvY0Gk25s=
=qboF
-----END PGP SIGNATURE-----

--nextPart3798042.skqdUvjsf2--
