Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60103 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762313AbXIVKVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Sep 2007 06:21:38 -0400
Subject: API to regulatory control (1)
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mGNPxiEi0Ro4/GFJ0Swf"
Date: Sat, 22 Sep 2007 12:22:54 +0200
Message-Id: <1190456574.18521.220.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mGNPxiEi0Ro4/GFJ0Swf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ok since I'm having trouble communicating this via IRC and other people
may have input too, let me summarise how I think regulatory control
should be implemented. This is a high-level overview and maybe Luis's
stuff actually implements things this way, but I can't really tell
because the interesting information (i.e. the API) is buried in
thousands of lines of code of boring definitions. Not to dismiss the
effort to collect all this info, but I think it's rather unimportant at
this stage.

So let me first explain how I see a mac80211-based driver communicating
with mac80211/cfg80211 on regulatory info.

I think each driver should include a few arrays that define which
channels the hardware is capable of operating in. These arrays may be
statically or dynamically allocated depending on the needs. This
basically consists of:

struct ieee80211_channel {
	/* first part set by driver */
	u16 freq;		/* in MHz */
	int hardware_value;	/* arbitrary */
	enum ieee80211_modulation modulation; /* CCK, OFDM */

	u8 supp_dbm_power_max;	/* maximum TX power device supports */

	/* second part updated by regulatory agent */
	u32 flags;		/* disabled, active scan, passive scan, IBSS, DFS, ... */
	u8 perm_dbm_ptmp_power_max; /* permitted pmtp power */
	u8 perm_dbm_ptp_power_max;  /* permitted ptp power */
};

[NOTE: I think there's a restriction on OFDM somewhere so we must have a
channel struct for each modulation to be able to disable OFDM/force
lower power with OFDM]

These are aggregated into an array as such:
struct ieee80211_channels {
	struct ieee80211_channel *band2ghz;
	struct ieee80211_channel *band5ghz;
	int num_band2ghz, num_band5ghz;
};

It would not really be necessary to have a separate list for the two
bands currently in use but it is definitely a lot easier on the code
later.

Now, the driver (say b43) has defined a struct ieee80211_channels it may
call say b43_supported_channels.

Next, the driver needs to say which modulations/bitrates it supports:
struct ieee80211_rate {
	/* stuff from the driver */
	enum ieee80211_modulation modulation; /* OFDM, CCK, CCK_SHORTPRE */
	u32 rate; /* in units of 100 Kbps */
	/* internal stuff */
	TBD;
};

Again, it's stuffed together into an array:
struct ieee80211_rates {
	struct ieee80211_rate *rates;
	int num_rates;
};

so let's say we now have a b43_supported_rates variable although we
really have one for A, B, BG and ABG devices.

NOTE: All this rate stuff is *NOT* interesting for regulatory. *IFF*
there are regulatory restrictions on bitrates anywhere then we need to
make this part of the channels array!

Ok enough of the declarations.

Now, before the driver registers it's hardware struct, it puts both
&b43_supported_channels into the "struct wiphy". This is how both
mac80211 and cfg80211 get told about it. &b43_supported_rates is put
into struct ieee80211_hw, only mac80211 needs to know about it, fullmac
drivers never need to show this information to anything outside except
maybe for some cfg80211 *hooks*.

**For mac80211 drivers, this is it!**

Internally, mac80211 or fullmac drivers of course need to check the
channel structs internally when they are asked to move to a different
channel or change TX power.

At this point, however, the regulatory agent API only starts. First of
all, the channel list has already been registered with cfg80211 because
a pointer is part of struct wiphy. Then, when by any way possible, the
regulatory restrictions change (user setting, ...) the fields marked
"second part updated by regulatory agent" are updated for each wiphy and
a notifier chain is invoked that drivers may register on to get updates.
I'm not sure how important this notifier chain is but it can't hurt to
have it.

=46rom what I can see, this finishes the channel restrictions API. Since
none of the information in the channels list is specific to some device,
it may be allocated statically.

johannes

--=-mGNPxiEi0Ro4/GFJ0Swf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG9Oz+/ETPhpq3jKURAktnAKCixT1fFpkFpQZ8hJafB44euLHI4wCeNfP0
utz1NycmKUL7MzPbyQ8YjZA=
=rBSX
-----END PGP SIGNATURE-----

--=-mGNPxiEi0Ro4/GFJ0Swf--

