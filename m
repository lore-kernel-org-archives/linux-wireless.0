Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:58541 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777AbZLIXvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 18:51:19 -0500
From: =?windows-1252?q?Luk=E1=9A_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 4/4] ath5k: Implement mac80211 callback set_coverage
Date: Thu, 10 Dec 2009 00:51:18 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net> <200912091412.47689.8an@praha12.net> <4B1FA685.4040605@openwrt.org>
In-Reply-To: <4B1FA685.4040605@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5397046.y4zICbgbAh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912100051.24119.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5397046.y4zICbgbAh
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 9.12.2009 14:30 you wrote:
> That's definitely completely inaccurate. Even before you get packet
> loss, as you lower the ACK timeout value, you will first start to get an
> increase in the number of retransmissions.
In fact the ping was "ping -s 1472 -c 1000 -i 0.002", that's more than=20
12Mbit/s pushed into the link. Sorry, I shouldn't call it "ordinary ping".
I didn't say it was perfect, but it couldn't have been completely inaccurat=
e,=20
because I found the athctrl value for 11a mode and Madwifi value for 11g mo=
de=20
that way.

> Yes, the current formula in Madwifi looks correct. We should use that.
OK, I will prepare a revised patch series. However I need to fix the usec t=
o=20
clock conversion in Ath5k before (currently it's correct for 802.11a only).

Lukas Turek

--nextPart5397046.y4zICbgbAh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLIDf8AAoJEEBjvk/UOfYwGysP/1KHrvi7SsmR7qSbJ0WRkfdN
y2uLG1dDmgfgXKgfTQbMWQqsWTrvtVt0NMo3wdccxzRe2ONC+Ena2Uc5g13CQcfm
wsGNmSLhT2imweiJ+p+PcgW+scsKrmKjMDwMXAMwov0NckawtmMGpGoiOzb2q2Yd
F0p/7/i/wlcEQNDcIlX/grHr7YYiN97VXa2rUzCmd/ZztiHlCiaG7DRX1fim+YGf
6yQn3WnhEWfn9noJIGyBFvKMcNOdg8VOePfBpk1f5wV5zsoHRfzUfydcsFte4UnT
RyMpYj4umMcMTA4VgrivwcCN0ZMzhKJB/m8g38CwNYkonp0IKoAIvyVGWgbqoFK5
HOo+C5FaEp0Vufajuc1aK2OtokFp8I2MXi8jEj/1mciW8ZHR5Zn9dzALpWFqs+Ce
eFOyaxk6V4KnBF0aOJKr+5qvmTWataQTGg1AOr/l7mOASSJCp74bJD7Ts3O3aQwW
YkfunG8BfWqBm43dkOQKZRy9C2NQo7y3Pj5N2rb5StE+HZlXOFUfAAEnUFW0ZF6e
I5Xe18ML7+HoNlMGgenFKsjJQkugj/wLBQXun0px3cKxKlpUkA7r0DkCamdAY5e7
u1qhW2wqZq/Z4utfmiRHU1moi536hpdKXucajJMsXGR5aoghdV0J4rxgG0L9k0PA
8dNnKz2jWMFXXjMpfK1U
=K4cj
-----END PGP SIGNATURE-----

--nextPart5397046.y4zICbgbAh--
