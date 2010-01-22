Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0AVTDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 14:03:11 -0500
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
From: Johannes Berg <johannes@sipsolutions.net>
To: wey-yi.w.guy@intel.com
Cc: linux-wireless@vger.kernel.org, j@w1.fi
In-Reply-To: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0iuDuF7ZJOs8uU1Rmaph"
Date: Fri, 22 Jan 2010 20:03:01 +0100
Message-ID: <1264186981.2593.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0iuDuF7ZJOs8uU1Rmaph
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[adding Jouni]

On Thu, 2010-01-21 at 13:39 -0800, wey-yi.w.guy@intel.com wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>=20
> In current implementation, mac80211 send dtim_period update to driver
> during association, but if no NetworkManager or similar application
> perform scan operation, plus tim_ie is not part of probe response; mac802=
11 will
> not get beacon with dtim information later, then  mac80211 will not pass =
the
> information to driver for update.
>=20
> Call ieee80211_hw_config() with IEEE80211_CONF_CHANGE_PS flag set to
> allow driver make correct dtim adjustment if dtim_period change
> detected. Also perform recalc_ps operation if needed.

This seems fine.

However, I think it's indicative of a bigger problem. I gave it some
thought, and came to the conclusion that it previously didn't happen
because we always won the race. Let me explain.

Previously, we would switch the channel completely to the new operating
channel before even probing the AP. That way, we would virtually always
receive a beacon from the new AP between the time we started the
association process (probe,auth,assoc) and configuring the driver.

Now with the new changes that use the off-channel work, we may return to
the old "operating" channel, which may be no particular channel, between
all these steps. Thus, if there's no beacon between any of probe
request/response, auth "request"/"response", assoc request/response, we
never get one, and this situation happens.

I see two solutions, apart from this special-case patch fixing=20

First, we could go back to the original behaviour if we have just one
virtual interface. But that still leaves us with the race, we might do
all three frame exchanges within a beacon interval and still miss the
beacon, we just tend to not do that and get a beacon.

The other solution I see is that we add a new step before or after the
direct probe step, which would just be "wait for a beacon". This would
ensure we have both probe and beacon information always ready. It would
also ensure we have both probe and beacon info for our new userspace
reporting of that.

johannes

--=-0iuDuF7ZJOs8uU1Rmaph
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWfZiAAoJEODzc/N7+QmavloQAMvQtcTj4tdZSgrky0vsSSf5
lhS9ehw4eOh/B77OXo3y6gBR1B/bxyOxpHYy1ssLD3hskbmYmXHJ8LGKPL9Bq59j
89sa+fIF3H5Apt7hioFyTg+1fNNzawUHz9WtcHC9EIxL1aEn+BhSkEb7k7llS9m9
tnw1rZ8qVd6NQsiZaa6vqCFrgc759rIpCgOPyuTKWyge4wJqY3pLRCkaiJPEfCPj
erZMhM8JJTFcwSaIEHmV30GdDVdKBQcIPsfKPtBMS6/FLBgaI4qq13Sc0fVQXlNg
NLap8oKc/8PaBjJZoy2ABncCrNPRS/Bj4ejM1+yEe0qShZrzooIBfMTgL9MTK3YO
bIc4PTm5x7mTWypU47PXYzBuHOY1Dtl0xqn6YWrrOYbI576hCmqoa24VN8CLA3FA
9tkJUy3I/Q2FCX10av63RiulIf3AaJAEkjCsfx+Ze9RLnW7szaguETX32lSDhA6M
TGqF45kSS5ktF1mfkkSrjeIOlm0VrJwyPqk+AHjtl9mhO49o56vlJ5k30/ce0d8d
tMZXi3azNKbqpLnTvpeGK+/oSjF4uzVBRDJ7q8SnBStl80PyoJRbEhPwSYEDpMDh
g/JkfWkUZnEufua3PliTYALinGAiIu9IEQ8eWsQAfvEm4DXp1shpgyxq33Tc0jVO
QyvFvaY+J1j0H6oEtz+x
=Humv
-----END PGP SIGNATURE-----

--=-0iuDuF7ZJOs8uU1Rmaph--

