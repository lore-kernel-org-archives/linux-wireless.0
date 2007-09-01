Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbXIABKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 21:10:53 -0400
Subject: radiotap injection bugs & extending it
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Andy Green <andy@warmcat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jwhcHpGG54Yy+eUS5MMD"
Date: Sat, 01 Sep 2007 03:12:15 +0200
Message-Id: <1188609135.7585.105.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jwhcHpGG54Yy+eUS5MMD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[John, Andy, sorry for the dupe, accidentally addressed to John instead
of the list. please reply here]

Hey,

Just noticed this:
__ieee80211_tx_prepare:

struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
[...]
tx->sta =3D sta_info_get(local, hdr->addr1);
[...]
__ieee80211_parse_tx_radiotap(..)

which seems a bit weird. Shouldn't we grab the sta only after removing
the radiotap stuff? :)


Also, after doing more work on mac80211 I now again have hostapd running
via monitor interfaces. However, there's a bit of a problem there.

After a few changes to mac80211, I have these TX handlers:
        ieee80211_tx_h_check_assoc,
        ieee80211_tx_h_sequence,
        ieee80211_tx_h_ps_buf,
        ieee80211_tx_h_select_key,
        ieee80211_tx_h_michael_mic_add,
        ieee80211_tx_h_fragment,
        ieee80211_tx_h_encrypt,
        ieee80211_tx_h_rate_ctrl,
        ieee80211_tx_h_misc,
        ieee80211_tx_h_load_stats,

Of these, check_assoc should be skipped unconditionally for injected
packets. sequence should be done, ps_buf I'm not sure about though I
suppose that if the STA really goes into powersave very quickly then
hostapd would need ps_buf.

Then we have select_key (and mic adding/encrypt depends on it) which
should IMHO depend on IEEE80211_RADIOTAP_F_WEP; fragment could depend on
IEEE80211_RADIOTAP_F_FRAG. rate_ctrl should depend on the presence of
the IEEE80211_RADIOTAP_RATE field, if it was present then rate_ctrl is
skipped. This addresses this TODO item:
           * TODO: auto-select when the rate field is not present!

misc does a few things:
retry should be taken from IEEE80211_RADIOTAP_DATA_RETRIES if present or
otherwise automatically assigned, cts/rts should be taken from the
radiotap TX flags IEEE80211_RADIOTAP_F_TX_CTS and
IEEE80211_RADIOTAP_F_TX_RTS or automatically determined.

This is basically it, except for short preamble setting. That is a bit
of a problem, however, because it's not a tristate in radiotap and we
want a tristate (long/short/automatic). Ideas on this item?

Comments on the whole thing? I think we shouldn't be skipping TX
handlers unconditionally.

johannes

--=-jwhcHpGG54Yy+eUS5MMD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2Lxv/ETPhpq3jKURAlmHAJ4w+G6S8dG5mQjWgWxuKHUsaGztsQCfR/o1
CQzNCnxYUqco4QCX2z2IphA=
=/E65
-----END PGP SIGNATURE-----

--=-jwhcHpGG54Yy+eUS5MMD--

