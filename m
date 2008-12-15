Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6-g19.free.fr ([212.27.42.36]:35142 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYLOWvH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 17:51:07 -0500
Message-ID: <4946C6D9.1060101@free.fr> (sfid-20081215_235114_041612_DB3C9745)
Date: Mon, 15 Dec 2008 22:06:33 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: Updated padding stuff for the RX and TX side.
 TX side has been 100%
References: <1229351698-21116-1-git-send-email-benoit.papillault@free.fr> <20081215170613.GA22627@jm.kir.nu>
In-Reply-To: <20081215170613.GA22627@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jouni Malinen a =E9crit :
> On Mon, Dec 15, 2008 at 03:34:58PM +0100, Benoit Papillault wrote:
>> This patch is close to the original code except that
>> ieee80211_get_hdrlen_from_skb() has been replaced by
>> ath5k_hw_get_hdrlen_from_skb() which is specific to Atheros hardware=
=2E The same
>> probably applies to ath9k as well.
>=20
> Most of this is changes on how unspecified frames are handled (e.g.,
> frames that are not used in IEEE 802.11). What is the use case that
> justifies this type of extra complexity to be added into the driver?
> Please note that there are no guarantees that all hardware revisions
> behave the same as far as undocumented functionality is concerned. Th=
e
> only clear case when padding is required is data frames with non-empt=
y
> frame body.
>=20

Agreed. In fact, I wanted to know how the hardware behaves in the
general case to better understand it in the particular case of 802.11
frames. To me, the bug we have seen when receiving a ACK frame in
monitor mode was not because "ACK is a small control frame", it was
because the header length we computed was smaller than what the hardwar=
e
considered.

Another point is that we have to deal with anything on the RX side, be
it later classified as invalid or not.

As far as the hardware is concerned, I'm not working for Atheros, but I
bet that hardware guys did the same thing for all their chipsets. I
could test it on AR5416 and AR9160 if needed.

To reply to Bob as well, we need to compute the number of padded bytes =
+
the position at which the padding occurs, so proper "header" length is
required.

Just my 2 cents.

Benoit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJRsbZOR6EySwP7oIRArWVAJ0fjqY01Xi3qTH7DIJBE9D+c099pQCgp/u5
pHHZiKOzsU83CEecamnuZpY=3D
=3Dw10J
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
