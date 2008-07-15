Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbYGOISc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 04:18:32 -0400
Subject: Re: [PATCH 1/1] mac80211: add direct probe before association
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1216076865-9826-1-git-send-email-tomas.winkler@intel.com>
References: <1216076865-9826-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uk7FI3rQl89orTL/0qFc"
Date: Tue, 15 Jul 2008 10:18:22 +0200
Message-Id: <1216109902.23746.27.camel@johannes.berg> (sfid-20080715_101840_165250_E11BDC8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uk7FI3rQl89orTL/0qFc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	ifsta->direct_probe_tries++;
> +	if (ifsta->direct_probe_tries > IEEE80211_AUTH_MAX_TRIES) {
> +		printk(KERN_DEBUG "%s: direct probe to AP %s timed out\n",
> +		       dev->name, print_mac(mac, ifsta->bssid));
> +		ifsta->state =3D IEEE80211_DISABLED;
> +		return;
> +	}
> +
> +	printk(KERN_DEBUG "%s: direct probe to AP %s try %d\n",
> +			dev->name, print_mac(mac, ifsta->bssid),
> +			ifsta->direct_probe_tries);

I just removed all the log flooding. Don't add it back please.

johannes

--=-uk7FI3rQl89orTL/0qFc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIfF1LAAoJEKVg1VMiehFYMOwP/2B2KFLjyzcDndtTLyp/s1ow
Yz8CFlXN+2w1kaBBGecBN4TFRXsxRcfIEtb7FTZGy/DzXkxy0UjnS+pG1Gi/7juY
XBp/9yof/xgBevktZN+gX19Qn0L9HT2sl3LJ3BjOcJGSTm8INYYKJTZPe6LqvbWJ
9ClAcjbV6KXaTFF8+D9Tn6mLMV+qkoj9+sNHI+odOf+kd+zQwtw5Za8/XAtlhqu6
bgHaLxvFFX/nPbhMrejrk9Sbea09+gUAfoGcXYGrSh2sBhfGNCnXMDa7fzQyYS8f
CSw9D5kBuEvIUT9XWxCrzgvlQj5gefcGJ2UAXrm4rNuItIkFFTop2CUs5Iz0FnOI
zJ5lsPm4JW/fGvuOnfdlLJMbXmOuShqxG5bqV4FOA14IAeX3WLsAS4607+6hk7nf
SEAgMKBZPNdVbo8D5L03nciCfiippvR9aaFvS1h9mdA9nL2AF83qbzP5A9094pht
dg8blI5RClDRYglNkyskrt+N1ojsTTZFwkAiNE2HO4hg9KAvICLaL5MgSQ8WCTLF
LXh64eKvbFMH2VbhDtktRjn70UqpnmfK8GYR1yMxqTBWX2RinSkiXXBkrS6ZmkNT
pBfDsKd9kzIXKsaOkQ9PtiIfO50LncS1UA13xckRdIsG+aSSHxLHrjpfc86p7ty6
RbxJmuw6tid6MrhY8YI2
=Nkao
-----END PGP SIGNATURE-----

--=-uk7FI3rQl89orTL/0qFc--

