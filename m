Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59471 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYIEVO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 17:14:29 -0400
Subject: Re: [PATCH 08/39] iwl3945: replace association and beacon hooks
	with bss_info_changed cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
In-Reply-To: <1220412419-15404-9-git-send-email-yi.zhu@intel.com> (sfid-20080903_053112_984921_AFC1F0BC)
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
	 (sfid-20080903_053112_984921_AFC1F0BC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fNM3OSJW5VSJpewrjLo0"
Date: Fri, 05 Sep 2008 23:14:25 +0200
Message-Id: <1220649265.11109.29.camel@johannes.berg> (sfid-20080905_231433_824485_FB5F0E5A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fNM3OSJW5VSJpewrjLo0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-03 at 11:26 +0800, Zhu Yi wrote:
> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
>=20
> Let mac80211 and bss_info_changed callback handle the association and
> beacon changes.

Nice.


> @@ -688,87 +688,6 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv =
*priv,
> =20
>  	switch (le16_to_cpu(header->frame_control) & IEEE80211_FCTL_FTYPE) {
>  	case IEEE80211_FTYPE_MGMT:

You can, umm, simplify all this code a bit now:

        if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
                iwl3945_pass_packet_to_mac80211(priv, rxb, &rx_status);
                return;
        }

        switch (le16_to_cpu(header->frame_control) & IEEE80211_FCTL_FTYPE) =
{
        case IEEE80211_FTYPE_MGMT:
        case IEEE80211_FTYPE_DATA:
                /* fall through */
        default:
                iwl3945_pass_packet_to_mac80211(priv, rxb, &rx_status);
                break;
        }


a single line can express the same :)

johannes

--=-fNM3OSJW5VSJpewrjLo0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwaEtAAoJEKVg1VMiehFY/YcP/3Io+ocVE9dzM57zUQtYMsmD
CQ3c8FBKEB33K44zXWsWIoZZUtsC3YdnaXH/S7eXT9qHbhzhyvpAIiMsqYXWTPmP
6/WBR00bFV7mYMWNU2nSPx1rM0Z9VffQ2i8d0GOrsrzJbPxYpPohRxy52z2naN9K
hYnyhQw9DCjnidkllRSP/iH11SqZiMCSl/2YXGAzM48gBQYabrNSJJtj4B4lm9nz
GqiK6LN9zB5anO/q3+fNrOP6N6x/vEncH3pGuEtkCygQNUoH+YYmIGyRtO4GYGEy
+qMr/6oMPkBJgJEO6Zmxx6DE4ApqV+Sp2XGBFyGVWfUho9HdfpwVfjuTcd8D9avu
dvJrNSHTSsB63GzZDYh94cyHeglBNAI/aiNAJ9y/mAFl66VemO8Yucva6O4q3z6X
tsb8PjDPfY2SaC5hzzuQrFf8wAkF5FVmarrSNyH+zcJjznlSSVCDW9ZiGTmt1T8S
F3aogy4uSdIInupowB7n/2ZUL+YMum/IiyjC03Zims6xbLVNVF7BfpegCToUEZmc
iuNEklS9lmjOKtQhXKK1WFdD193m+D8iIyW2Zh4J/o08AsSzuDeKH3OY0E6SUz2y
sxPl83HrpP8ak7HKtab5l89Bw6q4gNk8uNbKy7QztBmF5DlUUMAMjoPIRRs9oV1o
CkQ95ejuNYHOqT2Ink00
=g+hH
-----END PGP SIGNATURE-----

--=-fNM3OSJW5VSJpewrjLo0--

