Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbYIYJXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 05:23:49 -0400
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
In-Reply-To: <1222328058.2510.470.camel@debian.sh.intel.com>
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 (sfid-20080924_080231_170139_3D180880)  <1222245882.18015.62.camel@johannes.berg>
	 <1222328058.2510.470.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BAFoM3P4TNlKoLeL/TKI"
Date: Thu, 25 Sep 2008 11:23:11 +0200
Message-Id: <1222334592.10563.59.camel@johannes.berg> (sfid-20080925_112353_943638_8276A824)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BAFoM3P4TNlKoLeL/TKI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-25 at 15:34 +0800, Zhu Yi wrote:
> On Wed, 2008-09-24 at 02:44 -0600, Johannes Berg wrote:
> > On Wed, 2008-09-24 at 13:57 +0800, Zhu Yi wrote:
> > > From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > >=20
> > > The patch adds channels sysfs entry for iwl3945. Make it consistent
> > > with iwlagn.
> >=20
> > I advocate just make it consistent by removing it entirely.
>=20
> We need a way to show the channel info the card EEPROM advocated, not
> the final one intersected with the regdomain. Are you suggesting a
> debugfs entry?

Not that I understand why you need that since iw shows all channels you
are registering (albeit with possibly a few more flags like "disabled"),
but yeah, if anything all this stuff should be in debugfs. There's also
this little fact that this channel list shouldn't ever get used, you
should be (and afaik are since I fixed it) using what the regdomain is
enforcing, and you're already printing the channel list when enough
debugging flags are set on driver load.

Therefore, I don't understand why you need to clutter the driver with
this code. Malicious gossip has it you're trying to obfuscate the code
to a point where everybody else refuses to work on it.

Anyhow, I see none of the sysfs files you're exporting as being
userspace API that is actually needed in that form.

Also, looking into more details, your sysfs files seem to fall into
three categories:

 1) things that mac80211 provides but you haven't hooked up
 2) things that are generally useful, but you've added to your driver
    instead of helping build the generic framework
 3) things that are truly only useful for your internal debugging

1) notably TX power;

2) it looks like retry_rate should be settable through a generic rate
   control API if it is truly useful (otherwise category 3), power_level
   also belongs here, sometimes one can't avoid the impression that
   you're adding things like that to avoid having to help define and
   implement the generic functionality;

3) Neither flags nor filter flags seem useful (and filter flags you can
   actually influence via nl80211) to set outside test environments,
   statistics falls here too, same probably with antenna, status, error
   and events logs and "measurement".

Similar issues surround the module parameters, I won't go into them
other than saying that they constitute API as well and at least having
different versions for 4965 and 5000 hw seems entirely pointless. Many
of them seem rather pointless in general, and something not only you
have been doing and that I've asked for before is that I'd like to see a
generic option to disable hardware crypto in _mac80211_ rather than each
driver because this is actually genuinely useful if you want to monitor
frames at the same time.

johannes

--=-BAFoM3P4TNlKoLeL/TKI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI21h7AAoJEKVg1VMiehFYyqgQAIjOFVDSVzQ/kkPZz2kbr/ES
4XFxiTxYH7L/0wEIv5Tn1mjJWXspn1/2aWaZaolZ+DcAI7WLpKvXxXWOSlY+8U1F
Hs/yqP93miIyKtO9GOAefKuguN961k2f12Wg1IqpdgnHaLcMqdwXObCZPWn1zpbJ
r047HR7iR/xNtqdpzW6znXAqN4Lny6juPEkQaXb+/zFC76HzNNp0B/hgA9EUvrr0
bANOUKi11ZLrKbm5XHaald2JgXIZOzyC7NxiBy6i81bos0gEBeYeojSNwrOCzDnv
+5x/zvMNSjRhNm8wdsbAJ25+gows86g8q2sEXsehjUTMb49J9QeIuxIlXNkHWENS
pkEXWt45vcC5eCtk2xw/oDix/EVR0gtC+0gznM4vX3uOyjXeRu0QYxKBuvbTcnRT
s6KKJbfTomJ6EYoDQa+7TeZd3kQ1Dg14L5bmrLPI4WCQimndJ+nPa3zC4GvhYJxt
IZt0BUmUiRtMP3Ru6OYJr8AHq9NH82CIvUwhdvK4Fi65PtMO/YLp94wGTzhuVGuz
FH9ZA0BSXbwjnKLYGAgigGzurajwE0mFu2PfLOGTWL3LlV0SxnljzHSTWEjnQ/Hi
Lw83HiWf0SQO/IceWIvOcKbKz7MJZ3ih996PyUyDAvbt9OJHM3HsovPcEcgxEfUH
UIA3Am06BOrYLypVE55k
=dWh8
-----END PGP SIGNATURE-----

--=-BAFoM3P4TNlKoLeL/TKI--

