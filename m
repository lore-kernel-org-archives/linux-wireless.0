Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbXKLQJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 11:09:58 -0500
Subject: Re: [RFC] b43: multiple MAC addresses support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20071111025808.GK4031@jm.kir.nu>
References: <1194572631.4793.64.camel@johannes.berg>
	 <1194605550.4793.93.camel@johannes.berg>  <20071111025808.GK4031@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1kkO2MLWAws7vIEYrLoF"
Date: Mon, 12 Nov 2007 13:02:31 +0100
Message-Id: <1194868951.5229.36.camel@johannes.berg> (sfid-20071112_161012_991754_40DEE96F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1kkO2MLWAws7vIEYrLoF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> You could always modify the beacon period to a suitable number that
> would be divisible by whatever number of BSSes there are and/or add
> empty slot to move from, say, 7 to 8, and just not send a beacon at some
> of the slots.

Hmm. I'd have said that yes, this works, but rereading the spec I'm not
too certain any more. But more below.

> Sending a burst of all beacons at the same time is also a
> valid option up to a certain limit on how long a time would be allocated
> for this. However, this may have some timing issues when there are
> multiple power save buffered broadcast/multicast frames waiting to be
> sent out.

That's the point I wasn't quite sure on, would it be valid to send the
frames in the order beacon1, beacon2, beacon3, mc1, mc1, ..., mc2, ...,
mc3, ...?

[slight reordering of your mail]

> Some low-level operation
> would also need to make sure the beacon timestamp is correct if the
> frame gets delayed due to other frames.

On Broadcom hardware, I'm pretty sure that the transmit engine updates
the timestamp only during transmission so that shouldn't be a problem.

> In general, it would be good to try to send the beacon frames
> as close to their correct time as possible to allow power saving
> stations to remain asleep most of the time.=20

Time zero is defined as TBTT, so this means we need to send the frame as
close to TU "Beacon Interval" * N where N is a non-negative number. Is
my interpretation correct here? If so, and because we only have a single
TSF, doesn't this mean that we should send the beacons all together as
quickly as possible? If we tried spreading them out we'd be sending them
at something like "Beacon Interval" * (N + 0.25) which isn't something
we should do, no?

Another thing that I just realised is that I'm not sure whether we
update the TSF in probe responses correctly or at all because as far as
I can tell it's only done for the probe response microcode offload.
We'll have to look into this.

Actually, what we can do is adjust the offset for each of the beacons
differently. So when we're sending a beacon at TSF "interval * (N+.25)"
we can round that up to "interval * (N+1)" by adjusting the TSF write
offset. This means that stations will adopt a TSF that is larger than
ours by a bit. If we'd do the same for probe responses (which should be
fairly easy), would the timing work out? I'm not entirely clear about
CFP operation etc.

Effectively, only one of our BSSes would be sending out our own TSF, the
other ones would be sending something up to say 0.875 of the beacon
interval larger (assuming we limit the number of BSSes to eight). All
STAs would adopt this time, but what influence does that have on other
operation?

> I think it would be perfectly fine to try to simply the configuration
> and implementation by requiring all BSSes to use the same beacon
> interval and allow small changes in the interval, if needed. hostapd
> does not have code for this type of modifications.

I think I can do pretty much whatever we want, including send TSF
offsets as described above. But I'm not entirely clear on the
side-effects of that. If the TSF offsets are possible without
significant side effects then we're pretty much free to do whatever we
want in software (under some constraints), in the microcode I'd probably
simply pull the broadcast/multicast FIFO at the beacon interval and send
whatever software put into it and allow for extended frame control wrt.
timestamping for beacons/probe responses.

> I've done some
> experiments with configuring the hardware to use beacon interval divided
> by number of BSSes, but ended up using burst of beacon frames instead
> (and all BSSes were forced to use the same beacon interval).

Do you remember any reason?

johannes

--=-1kkO2MLWAws7vIEYrLoF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzhA1qVg1VMiehFYAQKoexAAgmcdH6ZyWsu1h7LJWi4SYk4w/CfgfdnW
XYLkeQZIwkFbGRH6Uqi9+MfbJtSVS/zTCC/h30zfUuCyXkAaysYVWM0yGXFiuhlN
ycykhsw5tZx1Vd4UTfEgc/L9BX2QXPwzfXWLQAXc2vu9dCsbZjdRUHfWJ4X9wAbZ
abRjJ+2AQNZeuyF2+m4b0JZF+zLo2mP5mCAVuiBS4eXhDk56yv/Rh/UuAtexW0eZ
49N0e+lp9S8O/UxiDh4xcTEHAl1w9smpQyzoe3ISPJBfl0oy2R77K5bkhq54ODtW
FYvYKKAjxWKIUSGIitcwmaLdZ3wugdgtyEWxGZihm9mO3EnIrx0mH1aubpbC7iMK
LetGIb7ms2Q/AkhMnc3FmqIZiDg+Yvo9vREopxVK1c0I9eO0uAlr6WUb9xs8pTKE
ThooMw3nJOnk5tl5DYQyLInExDaEEwFXWpJuJgwvgUkTinwiAiB8GnDm1Jb1BT78
FVzV0HDrUCqFcim3RkJswKJ/pNWiFAnpgcr/taCqsFcQuCkn3F7nJsiCoZ84yb2+
oYEbyZMRNiI+oWB4gujJFTMjaBhdcCoNjs7shoCTPXEY8U6QrhJm3ExgDHTEj+D9
AdI1Z7b76GUWie58/DQH3JPV8o+aXQYlkAI+AE3VL1LNTp62eUOyABA7fiFcZ/oy
tjFMuwLUGrU=
=TiCw
-----END PGP SIGNATURE-----

--=-1kkO2MLWAws7vIEYrLoF--

