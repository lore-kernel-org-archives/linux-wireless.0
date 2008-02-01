Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYBAQrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 11:47:47 -0500
Subject: mac80211 QoS/aggregation questions, thoughts
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Ivo van Doorn <ivdoorn@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Patrick McHardy <kaber@trash.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ieM+z3B60ReyaTUNtBue"
Date: Fri, 01 Feb 2008 17:15:12 +0100
Message-Id: <1201882512.4188.66.camel@johannes.berg> (sfid-20080201_164753_992632_B2A4D78D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ieM+z3B60ReyaTUNtBue
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ron,

I just noticed this:

        /* try to get a Qdisc from the pool */
        for (i =3D IEEE80211_TX_QUEUE_BEACON; i < local->hw.queues; i++)
                if (!test_and_set_bit(i, &q->qdisc_pool)) {

shouldn't that be i =3D IEEE80211_TX_QUEUE_BEACON + 1?

Or, more likely, something like adding
	IEEE80211_TX_QUEUE_FIRST_AMPDU =3D 8,

to enum ieee80211_tx_queue and using that above? This way it seems it'll
use the "beacon" queue which feels wrong, although that queue is only
"used" by mac80211 to configure IBSS beacon parameters...

To be honest, I'm totally unclear on how all this queue stuff is
supposed to work. Ivo pointed me to IEEE80211_TX_QUEUE_AFTER_BEACON
which is unused and duplicated with IEEE80211_TXCTL_SEND_AFTER_DTIM.

It seems to me that this queue stuff is mostly designed after atheros
hardware and we should be getting rid of it...

Ultimately, we only need four data queues as required by WMM and then
A-MPDU queues. Right now, you can only use 12 of the 16 queues iwl4965
hw offers (well actually 13 but I think using the BEACON queue ID is
wrong so 12 if that mistake is corrected) as far as I can tell, because
the qdisc_pool is only searched starting with IEEE80211_TX_QUEUE_BEACON
(but see above).

Here's a possible plan:

     1. move queue configuration for data queues to bss-config
        structure, it really is part of the bss configuration since it
        is mandated by the AP
     2. get rid of IEEE80211_TX_QUEUE_BEACON, it isn't used in mac80211
        and it's not hardware-independent, not all hardware actually
        uses a queue for beacons (b43 for example does beaconing
        differently), those drivers that do use a queue will have to do
        that internally. Also, the one place where it is used is the
        queue configuration for IBSS beacons, but that somewhat bogus
        anyway since we never reset that should we go back into AP mode
        after being in IBSS! Hence, I think the driver should handle
        that when an interface is brought up. Ivo, any comments?
     3. get rid of IEEE80211_TX_QUEUE_AFTER_BEACON, we have
        IEEE80211_TXCTL_SEND_AFTER_DTIM now and that is
        hardware-independent
     4. remove IEEE80211_TX_QUEUE_SVP, it's something strange and
        atheros specific
     5. remove IEEE80211_TX_QUEUE_DATA4, only rt61pci uses that and that
        use is strange, Ivo? We never submit frames to that queue...

This would leave us with the regular WMM four data queues. When hardware
announces more than four queues we would assume that the remaining
queues are usable for aggregation so that drivers for hardware that
needs a beacon queue (for example) would have to subtract that from the
number of available queues announced to mac80211.

An alternative that allows us to utilize hardware with more queues fully
w/o aggregation would be to have the drivers declare 'regular' and
'ampdu' queues in separate fields. Then, we'd be able to write the
multiqueue netdev support in a way that allows registers a queue for
each 'regular' queue.

That would possibly allow something I've thought about earlier: letting
users configure the queues with tc(8), i.e. having some sort of fixed
qdisc that is always on top of the master netdev and that is a simple
one-to-one mapping of bands to the hw queues, but allows per-band
configuration (like pfifo's limit) that sets the queue parameters, i.e.
AIFS, CW_min/max and burst time.

The effect of this would be to sort of externalise all of WMM support
into the qdisc configuration, by default you'd have a filter attached
that does the WMM classification. Of course, when operating in STA mode,
the queue parameters cannot be changed, but that can be handled in the
qdisc.

That seems mostly sane to me, opinions? We might have to write a new tc
module to allow accessing these things (although in STA mode it's not
changeable and in AP mode hostapd wants full control), but we should be
able to dump the config anyway. Also, I'm not sure whether it is
possible to make a qdisc non-removable, but that shouldn't be too hard
to add even if it is not currently possible. The simple 'wireless fifo'
qdisc that controls the queue parameters should always be present.

Phew, enough thinking for now, I'll wait for comments.

johannes

--=-ieM+z3B60ReyaTUNtBue
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6NFj6Vg1VMiehFYAQKO+RAAozmsgEaCEJsobN31P29LBEfEhjJwrjX8
F5GDWhLcGJPY61cSTl9RTxGA+yP9W3u3DtD3TfICTvACNWslC+/vjkwHiax3A3oM
2H747i1w7VsSZmIjaop5xu7uj/accTCbpVFOo1AWHeFk0ssnFrL2CRhQHs1/achT
fFp8Sa0F1poi81ZcbVksL8G7r38cLyfql3SrpgoI3pVzaliJD4PIZhueVdwZZ7Xa
z3fda8RB8KU5BqKg/FpEJCaYJ/Rnb3DdZ+QgEgcsJl6UODLwBOgM09oZmEEk0dkz
Z21yOo7tnFdAKLqbLbJ4i5UIqN52Z1BFjAzrpjhlwNGvPA7FBEZ2raR4DFvKLamd
d6bNbhlMAnLyvL3lqt4Eo3u8K5sEOWIE0KIBx/MtrPLGxrqn5RJERgcHjsiPW9tM
Mz/FCJ400GkrCfnJn3oXFi9vuAqv+RRwsOKauO4YTET5CluJs17V4IqnplGkxhWI
whQb5pvxoD5KE/0rVDcecB52DS30kII2Yo8wvwmBhJGprcbTQ07f+OjXbWypMN72
olxyYuI9Txm58+ihntUqTI0b+RcdJn12jW4VSz0xRkGw79R6fKztRdtIYua++/dm
L5E1nuyTB+2YKFWcbQUcDXii96zbcRXsM8v8loxuYPIoEU9TQfmDIflnJ3YWfXWL
db/mqLwcd0k=
=PumW
-----END PGP SIGNATURE-----

--=-ieM+z3B60ReyaTUNtBue--

