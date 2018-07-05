Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:53696 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752458AbeGEIrO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 04:47:14 -0400
Received: by mail-wm0-f54.google.com with SMTP id b188-v6so9720919wme.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2018 01:47:14 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Toke =?ISO-8859-1?Q?H=F8iland=2DJ=F8rgensen?= <toke@toke.dk>
Cc: simon.wunderlich@openmesh.com,
        Daniel Bailey <daniel.bailey@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        linux-wireless@vger.kernel.org
Subject: mac80211: AQM and block_tx
Date: Thu, 05 Jul 2018 10:47:11 +0200
Message-ID: <2846230.fHgAC8qB8Q@bentobox> (sfid-20180705_104718_382014_511B5C74)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart10662715.4p9Da4tgGb"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart10662715.4p9Da4tgGb
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Toke,

we are currently testing DFS with ath10k and noticed that AQM seems to ignore 
cfg80211_csa_settings->block_tx. Problem is now that the channel switch is 
started on a detected radar

  echo 1 >/sys/kernel/debug/ieee80211/phy1/ath10k/dfs_simulate_radar

NL80211_ATTR_CH_SWITCH_BLOCK_TX is set for the channel switch by hostapd but 
the AP still sends QoS data to the client.

Was there a fix for such a problem which I might have missed? I've just worked 
around that by setting wake_tx_queue TO NULL in ath10k. This still must be 
verified but at least I didn't see any packets anymore on a monitor interface.

Kind regards,
	Sven
--nextPart10662715.4p9Da4tgGb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAls92w8ACgkQXYcKB8Em
e0bGOxAAxsbRXPP8K5WtJozcUlUZlK3sg0N47Y6rrlyIKpfZtu9h6+CR0wW+48xQ
/Byx+MEvPnJHl2Eqs6pH1XRDOc85XFBDH62JxRJVli/yiEoLVIYX3Bjg/QGHTox6
l0w53qrbTTvCBZULbiZtcCRMcoCSQiElkHAREfdBvfFZsz7qa/iXPmOKnSz8228m
J8pa+getmtk35QldBUc+tYostxK66JB1JMtEGxidaFoB7+8Z0FoRfEpVvfNx2iSm
8RjYt7rlhK1r+nqD9CX/zeeDBKUapZZ7XmdkvBJOqSqzW8dbG+wOxKidKcZIS8Cj
Xyh2P0BRAlb0MeSqBlHHoEnOPgrg24Wc1Ym9sk5dtWObhS7wD3KA7BWXi4o25y3k
8sHQjSZyNzJ8D4gS+sadmbi2czune+IZQpQTNgKRe9kCEMHBhlgfGwuPB4hURzA/
fZQIxeYH/nqQe1JzozatzFFSF/zYwJ8XQxXuhXkDOtAHN8izyu/RGa/zowrYuh5m
BEDjXU31l/sD546+rp7AJw2Sn20JUO42DJgTIKo5IChQvNQyCHoP+UPyhBA9KjSe
4Llm+8MdwrAvU9EWNVfh4bpaBwtgAfLZJlI53PWqRB2kVN6eH2FLKROg8Ff5p0KI
BbLR6pEJNpw/2zfXwJRobqjeWnpkh6etIBsK0I/ZJLsnaaa7aJg=
=PeOp
-----END PGP SIGNATURE-----

--nextPart10662715.4p9Da4tgGb--
