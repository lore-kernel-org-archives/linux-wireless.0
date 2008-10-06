Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbYJGQ5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 12:57:39 -0400
Subject: Re: [PATCH 2/4] mac80211: add multi-rate retry support
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <48E8E588.30001@openwrt.org>
References: <48E8E48E.5090300@openwrt.org> <48E8E528.7060501@openwrt.org>
	 <48E8E588.30001@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t7DL/+mP9dJzM5lMXr3a"
Date: Mon, 06 Oct 2008 23:49:46 +0200
Message-Id: <1223329786.3778.38.camel@johannes.berg> (sfid-20081007_185744_338674_4D48E319)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t7DL/+mP9dJzM5lMXr3a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-05 at 18:04 +0200, Felix Fietkau wrote:
> This patch adjusts the rate control API to allow multi-rate retry
> if supported by the driver. The ieee80211_hw struct specifies how
> many alternate rate selections the driver supports.

Don't those drivers that announce supporting max_altrates =3D 1 have to
update the status for alternative rates too? Also, should
max_altrate_tries =3D=3D 0 indicate that that is fixed? But b43 with the
default firmware actually _is_ capable of changing the number of retries
(default to 3/3 or 3/4 I think), just not per frame. Should we have that
in the API too?

Another thing, it seems you didn't update those drivers to report the
rates and number of tries, at least for b43 that is actually possible.

Also, can you explain the use of IEEE80211_TX_CTL_RATE_CTRL_PROBE?

johannes

--=-t7DL/+mP9dJzM5lMXr3a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6of3AAoJEKVg1VMiehFYwnsP+gJXvOFw/4qRYL4A3aUkOo+k
7aUk5GDy99Rf0qvOpiMz9MMiPk1sdGe4PiNQiN83KKrV5lsyJ+RGL40nINm+L+Sm
PkRRQX5eP5d9Ln2OHDhBGmnVNfbDb6BjBypNOTtadILJFnG7FN/549ZitOPwN8UA
mNIRsV+K8QdPzPUDaAjVMQW8tlSV7gl9xPz62W9a6INr27t/8X4ThZs+5CD8A+tp
+RVN7xjuJbNtdRR3jfG//fBp321uoJHafSt07SNr+18EGb21zG+HqG2QsWQRvR9a
0av6NhKc3VcUO40t4zTTh4ON4jJmtrwlGivHq1d1BGibGonjWaEY11K2M2zmy9mh
9Os/wey1wh9XEcUueKRAPHFwvpJAdaPaYn62MJ3KN9xv1DA3lRfW+POipCFGbsf3
MCAopmETwGUlnjcen+5kUa2sHWZkFB3avU/I66DHscRFRL1uQjzREUukR6MUG+4Y
NaDCN/ytmHIRCfv0JT+hl/NtdNloX93E+g6ZDDfOZZf61RIgPL59bNEAsymJmi4u
ar7idgnxufsWsvcDuD3yL9YahM+VrekahdkwjPJPOCAVkq2KOA8l8i5u2bYrrKh3
k1m9IM/fAt1h1eJqU/JuOX+u7UEgZFH+eEip02kpFKeRVWNCIZ66SZPh6WtWF9C6
JAjlZz5OT7X0yVfAk8EP
=4hJ+
-----END PGP SIGNATURE-----

--=-t7DL/+mP9dJzM5lMXr3a--

