Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44959 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbZGDHxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 03:53:00 -0400
Subject: Re: [WIP] p54: deal with allocation failures in rx path
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Max Filippov <jcmvbkbc@gmail.com>
In-Reply-To: <200907040053.05654.chunkeey@web.de>
References: <200907040053.05654.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7G2aUFnQb4kvVg9K2vkN"
Date: Sat, 04 Jul 2009 09:52:55 +0200
Message-Id: <1246693975.16770.68.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7G2aUFnQb4kvVg9K2vkN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-04 at 00:53 +0200, Christian Lamparter wrote:

> the simplest answer is probably this one:
> https://dev.openwrt.org/changeset/15761

Humm. Davem and I looked into this problem some time ago, came up with
patches and concluded that if everything is set up correctly this
shouldn't be happening.

Look at net/mac80211/iface.c::ieee80211_if_add:

        ndev->needed_headroom =3D local->tx_headroom +
                                4*6 /* four MAC addresses */
                                + 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
                                + 6 /* mesh */
                                + 8 /* rfc1042/bridge tunnel */
                                - ETH_HLEN /* ethernet hard_header_len */ =20
                                + IEEE80211_ENCRYPT_HEADROOM;
        ndev->needed_tailroom =3D IEEE80211_ENCRYPT_TAILROOM;

Due to that, skbs allocated for our device ought to have enough
headroom. If they don't, you should try to figure out where they're
coming from and why they don't,
http://johannes.sipsolutions.net/patches/kernel/all/2008-05-04-23:09/028-sk=
b-alloc-stackdump.patch might help with that.

OTOH, I guess that you're using IPv4 and that should do things
correctly, I think.

johannes


--=-7G2aUFnQb4kvVg9K2vkN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKTwpUAAoJEODzc/N7+Qma8kwP/jsyJw5yTo9EalwBsNMMsnK6
VKdaW5BGBamubxbh2/+GyZmzQyJYFUaFDYpPeb/t6izkWLil6kKZnMhrPHYxex4C
K8QN+MiEL7p2LU54iGh6HnGH1/CdRxQv9D0PDFOm3fD3OoFzeJYCoV6H9OUs6vcu
4Xy8O7wxKDTS7Dc9d+aJJg91BkIeStTYsjygYqlsPwjYwHQMmOQl7hte8Oa/0ozk
chcKSlFADi+c1wMJqYo1vbn4EtVMUhdBUFkWXy14npDL4QiAUmCG2woMPz9Ja0z4
4NpfBqZpZ4Efbr0ZfMFP3JpTbtlDlwpT81CImOqddk52wYKM7MDUKJV8NSXiH4Nn
RYdd0qiY2QwcyuJAW5vOiRSuBWqaneyrTx096vwqjLLVQdODe+cys11aq88bEfOV
n/GHQvLo0VKRdXLZxvDH5PUWmMnJfwGLpYbVGgiOTMqGzMkCuBH5Rz9qg1W+DBpX
yyo68wlkBYbqtdy2/1Hs8Aj1egmA0GSTUvqrMN6j5wcdJo8mPJAK8cMDfL3hEZ3u
iaQNh8NGlkpYrV7si3/H+5K/2HvEwiKPr4MyQCEn59fDNygD6SWwsQtC7q86jVTJ
xUhy3RvpeybUjDRx/bPt7nldMrcH7bYbxB2vuzymUDCIjD0jJ5JciCmHBqKAkUwa
mNnsTdZxbQN/O/UIbaC1
=sv7i
-----END PGP SIGNATURE-----

--=-7G2aUFnQb4kvVg9K2vkN--

