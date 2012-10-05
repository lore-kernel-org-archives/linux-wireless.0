Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:53432 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab2JEQFQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 12:05:16 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL on AR9003
Date: Fri, 05 Oct 2012 18:05:13 +0200
Message-ID: <1705773.eSZj456rS3@bentobox> (sfid-20121005_180522_108442_FE6FCD12)
In-Reply-To: <506EF975.7040909@openwrt.org>
References: <1348756862-8788-1-git-send-email-sven@narfation.org> <1661867.OB0LbMnEW9@bentobox> <506EF975.7040909@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2009197.yyubZJTeAi"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart2009197.yyubZJTeAi
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 05 October 2012 17:15:01 Felix Fietkau wrote:
> Thanks for testing, but for submitting I'd prefer something simple,
> how about this:
> ---
> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> @@ -1035,6 +1035,10 @@ static bool ar9003_hw_ani_control(struct
>  		 * is_on == 0 means MRC CCK is OFF (more noise imm)
>  		 */
>  		bool is_on = param ? 1 : 0;
> +
> +		if (ah->caps.rx_chainmask == 1)
> +			break;
> +
>  		REG_RMW_FIELD(ah, AR_PHY_MRC_CCK_CTRL,
>  			      AR_PHY_MRC_CCK_ENABLE, is_on);
>  		REG_RMW_FIELD(ah, AR_PHY_MRC_CCK_CTRL,

Yes, looks good.

Kind regards,
	Sven
--nextPart2009197.yyubZJTeAi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQbwU5AAoJEF2HCgfBJntGZFIP/29xDoO0kqUECk9TGGridf1J
tCqFEc+BA6VNLZROOBaBojtqPGsaBpQGdtq9AufvAjTwzXmfhdqBjBL72CIxhyvJ
6nZ5NSFqcd+gDnDrtrgVstyC/JM+BA1+EdrHydIo8Se/KC50G9iI1sRRdEfSkKWt
eJgSigK1UQzO9XgJsJw1nJtPUMHAx+XY78einE+gJLOSAW+hum0+yyMxPHKiy+ql
TFD4dFn1POQFTNh+fc8Ad90KBd1i7138IOZj81lshXRlt892AgK0iPeycEbbVIty
/0h9SAHaB2G/FAD4/28/Zib2o+2zY9N7rn4qZ6b3q0OO6MihQJkoAi+KJ+iHL6FE
BypjZlCY3ko92MznD1zQKp0y1PpgYBrjsg6Cj7C2w25PNIp3VisHyaiBG5ok8zqz
n6csepRkiET667Syk6BFum0JPDJvZA+GkHV2BnF3W5O9mVQcEt0uYp++BwaXu9RY
mG2IRkp9gHOhh9gaS+JAKZbstewSiOpSyMUyY8lzFkAyMdsALkNw5kOMrXrJ0zYg
nVUgz6zVwg3dj9yQyzD4ItqAvSdWfsVlXp7pLACQcTO9w3Ugvu7ky6GxVA7j3utP
8JNPNRyfy3wKkZ7lBBpxV1N507U//pqoYS9hFrGVIKKTyZTsg+oMI6Q8rGgx5q6B
d2bjVyW+cJVHMtwhPREF
=Vi6R
-----END PGP SIGNATURE-----

--nextPart2009197.yyubZJTeAi--

