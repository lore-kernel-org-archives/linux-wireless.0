Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46640 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbZHNOyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 10:54:11 -0400
Subject: Re: [PATCH] cfg80211: set SME state machine correctly for roam
 event
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1250222301.4972.31.camel@debian>
References: <1250155399-17847-1-git-send-email-yi.zhu@intel.com>
	 <1250157249.21250.0.camel@johannes.local> <1250222301.4972.31.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8v3ehC/ekuf3faqeFxAY"
Date: Fri, 14 Aug 2009 16:54:05 +0200
Message-Id: <1250261645.24924.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8v3ehC/ekuf3faqeFxAY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-14 at 11:58 +0800, Zhu Yi wrote:

> The device notifies both when it begins to roam and after the new
> association is made. Yes, I think I missed the cfg80211_roamed call for
> the real roam event. But there is still a reassociation path that the
> above situation could happen (__cfg80211_connect_result is called while
> in CFG80211_SME_CONNECTED state). Or do you think we should suppress
> reassoc event from driver?

Would that be after a disconnect event?

I think that after a DISCONNECTED event the device should go to sleep
completely and wait for userspace instructions. Otherwise we end up
having a weird situation _again_ where userspace has no idea what the
device is doing. I suppose if the device just keeps trying you just have
to tell it to stop after a bit if it doesn't find a new connections.

Otherwise, if you're roaming, you still get a disconnect/reassoc or
something like that? Those together should form a ROAMED event.

> Actually, the code in __cfg80211_connect_result() has already handled
> the (wdev->sme_state =3D=3D CFG80211_SME_CONNECTED) case. The problem is
> wdev->current_bss is set to NULL but leaves wdev->sme_state still as
> CFG80211_SME_CONNECTED. So I think the patch is still valid, but needs a
> better description.

I don't think I understand?

Why would you ever have a connect_result() while already connected?

johannes

--=-8v3ehC/ekuf3faqeFxAY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhXqKAAoJEODzc/N7+QmaflUP/2jOFZn251VR46p7QSSrrd81
PO2jSi+e2EhZ7zfKHE7tgn9htM9vVAMfhxYtYAtYxgwCvBa+xM6rMQUvrKfUHsut
pEVeE9IAM4cAI1BX7DJjT/r3w1eoUF77zdiBOFK/1OR/DsWvoxHnaEOQiNdZdwvv
Mnu2fhwJEjGq4Arytr/hJ6hoVAvTrnQe6sgcu1pP1oDLgCY0Hyjhr2bNqujxLEOt
IeJ7pH+ZDhc65CeIAKw4/gOxCRrMmaJurmLsNYV09g+ptA2pYnK0Fjt8VSOIU7b7
ZFXgG6FOrftJ+wQHLkD5yN6O46AEAh7v5aIxbUHy0/L7NSQ+TMy2p3xQlAX3cXRQ
oKmDQOVN9j4JV5DMUSFqknWR5gZO1fHLPqh6SqKDI/RXu4HCvLeXUHDBjsGC/vlc
chbLZ8XxRPc8RcyB2CUFhhFpwzVUcfPHggNi4dpIuLyHlJIWDvzWDFaePU8Bk53P
MshEvffg8OFH6fyG6isQ8DxHBX9szpW10bS3w09FBHEkIMTW/MkfO+qWQrAoRpgt
4u9gWubkBYMxR6W53L3m+Mmoeo+y2ZkwfKjP6taO/KYg96iqiQmhMjZehpZ4nS+m
4naqQvSSDJLOQb9l2Zu6kyTOsxLq4hnoWluh6UjNKEQGuSQ58MefYbRNiYG1V27G
Ue0cEulAGLlxERIgYsSl
=6n4K
-----END PGP SIGNATURE-----

--=-8v3ehC/ekuf3faqeFxAY--

