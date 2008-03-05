Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406AbYCEKDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 05:03:50 -0500
Subject: Re: [PATCH 05/11] mac80211: adding mac80211_tx_control_flags and
	HT flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <c85cb4470803050200w6d981525w11688f0921867d5a@mail.gmail.com> (sfid-20080305_100051_308051_571E68F9)
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
	 <1204710116.25502.48.camel@johannes.berg>
	 <c85cb4470803050200w6d981525w11688f0921867d5a@mail.gmail.com>
	 (sfid-20080305_100051_308051_571E68F9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PReBil+Sn7C9Ufpxmj6k"
Date: Wed, 05 Mar 2008 11:03:37 +0100
Message-Id: <1204711417.25502.59.camel@johannes.berg> (sfid-20080305_100354_127925_8DC89618)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PReBil+Sn7C9Ufpxmj6k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-03-05 at 12:00 +0200, Ron Rindjunsky wrote:
> > > Tx command can be a combination of any of these flags, along with
> > > bitrate represented by ieee80211_rate. this will allow legacy drivers=
 to
> > > switch easily to any 11n rate representation.
> >
> > Looks good, but I wonder if there's any chance we'll see a generic rate
> > control algorithm use these flags? I.e. one not tied to Intel HW and
> > hidden in the iwlwifi subdir.
> >
> I sure hope so. the problem with current use of ieee80211_rates is
> since it is targeted for ABG rates you can have all rates ready in
> advance in the ieee80211_rates vector, but as soon an algorithm will
> need to move those rates to siso/mimo, 40 mhz, ect. each combination
> will multiple this vector, ending in a very big one. using the flags
> will allow any rate scaling algorithm to keep using current
> ieee80211_rates vector method, with any flags combination suitable.

Hmm. Can you explain the new HT flags a bit better?

What, for example, is OFDM_HT? What happens when you select a bitrate
of, say, 11MBit and have the 40_MHZ_WIDTH flag set?

johannes

--=-PReBil+Sn7C9Ufpxmj6k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR85v96Vg1VMiehFYAQKnAg/+I0aIrSLjbB8iboIRj0Pqr9aqA4DYQjN6
5q2Lp/l6YK5nG+5G2yt9eblCBe+yBGx4hK1T46tlPgyTIKyQagj3tspVIviCDK+o
+y1W3sxRrcFU2B8BM/a4BNTRjZ/oCFcNE9MjHxnG/Mu4kQC38KuZH91KHByKd+gT
Grcj4WPQeXB4qntOp/os24gqc7e1vS7p60Q0j47mHe6UfPCmb15G1eFBeszLlMTH
mdgjBLPaJQ9SeuX9OxqR4roz469ink8IQfF7NpOYj5ecmwwYt3pGp4bpXPcAc+uc
Naq/yNyHUTi01iRJVAog+M9TjMM6dbyp/iqfwFGNcqt4oB5D7Wyvsw63/JGgOIUD
eyBM76FjtX0z6KxEqvimApuoNIoNJkv+hQjGIjJ9CKtyh6BK9YsqMcsf4yaB7tOA
ycIwoj8YK79g9cZATmke1JDholQQQOk2O5NTCkuwJLV0dc9mBcNcWMmx9ZXNGwBH
ywwCSEHEN/lIWKWn4p9qcaPXZwb7jpZpTw5ez3LdF3cJcj22pWTQTYXyE8FLK6tu
EZvRJZDvIHU88KGDc+707wEtaxAzzDfgKo0ZfejVU8ef3djQYugvADasstMPnTV7
Nj4k3ZAS7ApjDD93Ceka3OwVusuSe1DjrNDOJIjuQv6ns/XFaXUkw4p9v5Bm5omK
m1vX2bz3Ios=
=481e
-----END PGP SIGNATURE-----

--=-PReBil+Sn7C9Ufpxmj6k--

