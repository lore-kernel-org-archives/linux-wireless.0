Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:62742 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966375AbXFHCPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 22:15:32 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: yi.zhu@intel.com
Subject: Re: [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
Date: Thu, 7 Jun 2007 19:14:52 -0700
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
References: <20070606082210.GA28649@mail.intel.com>
In-Reply-To: <20070606082210.GA28649@mail.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2756693.5u9BNL005o";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706071914.56402.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2756693.5u9BNL005o
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 06 June 2007 01:22, Zhu Yi wrote:
> +#define IEEE80211_TSINFO_TYPE(a)	((a.short1 & 0x0001) >> 0)
> +#define IEEE80211_TSINFO_TSID(a)	((a.short1 & 0x001E) >> 1)
> +#define IEEE80211_TSINFO_DIR(a)		((a.short1 & 0x0060) >> 5)
> +#define IEEE80211_TSINFO_POLICY(a)	((a.short1 & 0x0180) >> 7)
> +#define IEEE80211_TSINFO_AGG(a)		((a.short1 & 0x0200) >> 9)
> +#define IEEE80211_TSINFO_APSD(a)	((a.short1 & 0x0400) >> 10)
> +#define IEEE80211_TSINFO_UP(a)		((a.short1 & 0x3800) >> 11)
> +#define IEEE80211_TSINFO_ACK(a)		((a.short1 & 0xC000) >> 14)
> +#define IEEE80211_TSINFO_SCHEDULE(a)	((a.byte3 & 0x01) >> 0)
> +
> +#define SET_TSINFO_TYPE(i, d)		(i.short1 |= (d << 0) & 0x0001)
> +#define SET_TSINFO_TSID(i, d)		(i.short1 |= (d << 1) & 0x001E)
> +#define SET_TSINFO_DIR(i, d)		(i.short1 |= (d << 5) & 0x0060)
> +#define SET_TSINFO_POLICY(i, d)		(i.short1 |= (d << 7) & 0x0180)
> +#define SET_TSINFO_AGG(i, d)		(i.short1 |= (d << 9) & 0x0200)
> +#define SET_TSINFO_APSD(i, d)		(i.short1 |= (d << 10) & 0x0400)
> +#define SET_TSINFO_UP(i, d)		(i.short1 |= (d << 11) & 0x3800)
> +#define SET_TSINFO_ACK(i, d)		(i.short1 |= (d << 14) & 0xC000)
> +#define SET_TSINFO_SCHEDULE(i, d)	(i.byte3 |= (d << 0) & 0x01)
> +
Everything that touches short1 looks broken on big endian.

-Michael Wu

--nextPart2756693.5u9BNL005o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGaLugT3Oqt9AH4aERAq/OAKCORKzjNPALTLCd2OdP8wDJsGKjVACeOOwO
8VTMdQt6IBthnx2DbhdPOmE=
=peSg
-----END PGP SIGNATURE-----

--nextPart2756693.5u9BNL005o--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
