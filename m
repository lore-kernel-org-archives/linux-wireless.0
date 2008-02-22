Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50419 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbYBVN4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 08:56:46 -0500
Subject: mac80211 locking: tasklet vs. non-tasklet
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Tomas Winkler <tomasw@gmail.com>, bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KF5N6T1ZsOageNf4aBv/"
Date: Fri, 22 Feb 2008 11:29:05 +0100
Message-Id: <1203676145.26341.39.camel@johannes.berg> (sfid-20080222_135652_855219_D8443BD0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KF5N6T1ZsOageNf4aBv/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Looking through the locking in sta_info I noticed it was completely
broken especially wrt STA flag updates. However, most other things are
fine iff the drivers only use EITHER ieee80211_rx_irqsafe and
ieee80211_tx_status_irqsafe OR __ieee80211_rx and ieee80211_tx_status.
Also, in the latter case, drivers have to make sure that only one of
each of those calls is active at the same time, even on an SMP system.

The only drivers that currently use the non-irqsafe versions are ath5k
and iwlwifi, where iwlwifi even mixes between the two groups. ath5k
seems fine, it defers both to tasklets so only one call can be done at a
time.

With iwlwifi, however, there is a possibility that it invokes
ieee80211_tx_status() on one CPU while mac80211's tasklet is processing
another TX status that was submitted with ieee80211_tx_status_irqsafe().
Tomas, I think you mentioned that the TX status processing can't
actually ever call the non-irqsafe version, can we remove that call to
be sure? :)

Alternatively, short of imposing these requirements, we can add new
locking in mac80211. I don't think that would be good though.

johannes

--=-KF5N6T1ZsOageNf4aBv/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR76j8KVg1VMiehFYAQKA5hAAkXFrGdhZCSyKMxGE7OgVvdjW/WG8e53h
4/Rmt3XEDLq3+pI50W6fWF04wLW51cKLpFBOVfMyFjeD7zAwKWWMDd6Vc1Ei7HzT
nk2wJL9rHiHrAw4N6mwQyWQo6f4XpImVATBI8xgjehzG+O5KW7JFw3nA29M7Ftq6
v9CSWr8kqWi+UREBOGp2iFCxOW/nSIL409pOhZpx0UwMOQzoc4wQX3CeKQ8+7Vch
iUoJj3ajwwFvR6opuHwTEvVibTiHSo+k4XO/h/TM7zsOe5UccdzN17ml53Ne1UXb
i4O9Uz07jVoLA4vE16W/LlMOyD86fUTldALbLQbKcf3HbIM29AFoXhoy0Aqh2JBv
FVg3Cr3JZBdLzHZgcajHix8Azw0o8DD3jfAS/toFeEqby0qfkAqJouPXtl/zZCdt
9QMQcvrSTxlrOdjp8SaoTSHu0oQI6yFVWYkF9N3JGlPLF2tVnaMXobd7xhrcWkeF
8T+Ev3Rc0WBxxNLBHga6QdV+nIufkxFHvwKFJATVHiwbtXdhfwuvJ0EOHy9V/8VH
Gk3itxsEJWLuVs18YITLi1nqWG3ZSbdgPOPKoUzerOs8PPIXV7MnfkGKH9C8lQkQ
Z+Hnbm5KdhZt3Vgpuz7c01D+DbOfglqT5sEnD9PBN0L4UCYe18aZ4l7eEKCyI4jV
jr6YKp596Lw=
=wFJG
-----END PGP SIGNATURE-----

--=-KF5N6T1ZsOageNf4aBv/--

