Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:61802 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751698AbXCQXVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 19:21:25 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
Date: Sat, 17 Mar 2007 19:20:31 -0400
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
References: <20070317105800.659633351@warmcat.com> <200703171751.50898.flamingice@sourmilk.net> <45FC6727.3090008@warmcat.com>
In-Reply-To: <45FC6727.3090008@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1948880.Vx30VJKnQn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703171920.37469.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1948880.Vx30VJKnQn
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 17 March 2007 18:09, Andy Green wrote:
> Yeah naturally it was my first move to use what was there, but the
> result was a panic that went away when I moved the skb to belong to the
> "master" interface's index and separately persistently tagged the packet
> as being injected.
>
I don't see anything that would prevent this from working.. if you have a=20
patch which does this and crashes, I'll take a look at it.

> Is it safe against race problems on interface removal to consider to
> look up against the interface index at actual send time?
>
Yes. dev_get_by_index in ieee80211_master_start_xmit calls dev_hold. When i=
t=20
is done, dev_put is called. The headroom reservation code looks suspicious=
=20
though.. it doesn't call dev_put if it fails. Fortunately, this is unlikely=
=20
to happen.

Thanks,
=2DMichael Wu

--nextPart1948880.Vx30VJKnQn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF/HfFT3Oqt9AH4aERAkWYAJ9u6YMVkJIX5JlEC4SAbtVEtdq5AwCeN0sP
zqGn+seC7O9B7lB3QmrRc+U=
=FACM
-----END PGP SIGNATURE-----

--nextPart1948880.Vx30VJKnQn--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
