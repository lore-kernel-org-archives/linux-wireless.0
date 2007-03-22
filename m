Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:63494 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932564AbXCVXTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 19:19:34 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/4] Try #5: Radiotap on Monitor Mode interfaces for rx and tx
Date: Thu, 22 Mar 2007 18:58:04 -0400
Cc: andy@warmcat.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <20070320103955.600509703@warmcat.com> <1174500637.3944.9.camel@johannes.berg>
In-Reply-To: <1174500637.3944.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2139142.E3EkotEnRf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703221858.09200.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2139142.E3EkotEnRf
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 21 March 2007 14:10, Johannes Berg wrote:
> Ok so people don't want to have this in cfg80211, all the better for me
> since it's less work.
>
> I urge you to solve the issues with this injection interface, we've
> established that you can use packet filters to grab only management
> frames but monitor interfaces definitely still interact very badly with
> power management, and when the hardware has a BSS filter then this will
> also be disabled with a monitor interface (if monitor during operation
> is supported) which again puts more load on the host.
>
> I have previously suggested to use the IFF_PROMISC bit for this, but
> this will also need good driver/stack API since currently drivers that
> support monitor during operation will just turn off BSS filters and such
> when a monitor interface is added. That will have to be changed in
> drivers as well.
>
Note that my patch predates the suggestion that IFF_PROMISC be used to turn=
 on=20
monitor mode on the hardware. (2006-12-18) I merely updated it so that=20
monitor interfaces output radiotap whether or not the driver supports.

This patch series is not meant to replace the management interface. I just=
=20
gave Andy Green the radiotap RX patch so he could do some work in the right=
=20
direction, but that patch isn't complete by itself. (That's why I didn't si=
gn=20
off on it) In particular, patches doing these things in addition to what th=
is=20
current patch series does will be needed to finally remove the management=20
interface:

1. Make it easy to flip monitor mode on and off in drivers and support your=
=20
IFF_PROMISC suggestion.
2. Make the use of radiotap by drivers configurable independently of monito=
r=20
mode.
3. Report the result of a TX through monitor interfaces after=20
ieee80211_tx_status is called. This requires new radiotap definitions.
4. Move things like radar detection and the rest of ieee80211_msg_* to=20
cfg/nl80211 if they are necessary.
5. Port hostap and wpa_supplicant to the new interface. Will require some f=
un=20
with packet filtering..
6. Kill the mgmt interface once and for all.

We don't need to replace the mgmt interface at once however. Addressing the=
=20
first two issues should be sufficient to merge the radiotap RX/TX patches.=
=20
After that, 3-6 can be done one by one.

=2DMichael Wu

--nextPart2139142.E3EkotEnRf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGAwoBT3Oqt9AH4aERAumNAJ0WlBqNFKm3aD3P6oB8YcCpuG/P/wCfT+GT
v1tKv8PwbztWVw4X87eQ4pQ=
=yMLU
-----END PGP SIGNATURE-----

--nextPart2139142.E3EkotEnRf--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
