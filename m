Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422667AbXDZJjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 05:39:48 -0400
Subject: Re: [PATCH 10/13] mac80211: set bssid to broadcast before scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20070423184814.7029.99423.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	 <20070423184814.7029.99423.stgit@magic.sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TLyvNCoyNuq9HybD2AJJ"
Date: Tue, 24 Apr 2007 18:24:11 +0200
Message-Id: <1177431851.3528.36.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TLyvNCoyNuq9HybD2AJJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-23 at 14:48 -0400, Michael Wu wrote:

> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -502,6 +502,7 @@ struct ieee80211_local {
>  	struct ieee80211_hw_mode *oper_hw_mode, *scan_hw_mode;
>  	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
>  	size_t scan_ssid_len;
> +	u8 scan_bssid[ETH_ALEN];
>  	struct list_head sta_bss_list;
>  	struct ieee80211_sta_bss *sta_bss_hash[STA_HASH_SIZE];
>  	spinlock_t sta_bss_lock;

Do you see any use for setting scan_bssid to anything other than the
broadcast address? It doesn't seem useful to add this field here at this
time.

johannes

--=-TLyvNCoyNuq9HybD2AJJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGLi8q/ETPhpq3jKURAu1TAKCrXpaFwNSikYJP5/4xFfDmRVin2wCgjRus
ihGqZCyN4xprklP7up5PQ9c=
=F1O2
-----END PGP SIGNATURE-----

--=-TLyvNCoyNuq9HybD2AJJ--

