Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51918 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751647AbXLJEF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 23:05:27 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: [PATCH 1/1] mac80211: pass in PS_POLL frames
Date: Sun, 9 Dec 2007 23:05:38 -0500
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	yi.zhu@intel.com
References: <11972036221022-git-send-email-ron.rindjunsky@intel.com>
In-Reply-To: <11972036221022-git-send-email-ron.rindjunsky@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4486830.sXs2Q8AcWA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200712092305.42530.flamingice@sourmilk.net> (sfid-20071210_040532_961114_B24417E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4486830.sXs2Q8AcWA
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 09 December 2007 07:33:42 Ron Rindjunsky wrote:
> This patch fixes should_drop_frame function to pass in ps poll control
> frames required for power save functioanlity. Interface types that do not
> have interest for PS POLL frames now drop it in handler.
>
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> ---
>  net/mac80211/ieee80211_i.h |    5 +++++
>  net/mac80211/rx.c          |   10 ++++++++--
>  net/mac80211/util.c        |    6 +++++-
>  3 files changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 2476cc5..a7746da 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -58,6 +58,11 @@ struct ieee80211_local;
>   * increased memory use (about 2 kB of RAM per entry). */
>  #define IEEE80211_FRAGMENT_MAX 4
>
> +/* IEEE 80211.11 minimal headers length */
One too many '11's in there.

> +#define IEEE80211_HDR_MIN_LEN_CTRL 16
> +#define IEEE80211_HDR_MIN_LEN_DATA 24
> +#define IEEE80211_HDR_MIN_LEN_MGMT 24
> +
This isn't really related to fixing the PS_POLL frame passing. It's a good=
=20
idea however - please put it in include/linux/ieee80211.h and follow the=20
naming conventions there.

Otherwise looks fine.

Thanks,
=2DMichael Wu

--nextPart4486830.sXs2Q8AcWA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHXLsWT3Oqt9AH4aERAohXAJ9aPtuO5TUtsR3kkj1qME6I23Q6OwCgrGu6
E4eXer5TKUTuN88QH6zF4FI=
=I2/s
-----END PGP SIGNATURE-----

--nextPart4486830.sXs2Q8AcWA--
