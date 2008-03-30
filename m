Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbYCaLwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 07:52:50 -0400
Subject: mac80211 MLME scanning - BSS list trouble
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	Bill Moss <bmoss@CLEMSON.EDU>, Daniel Drake <dsd@gentoo.org>,
	Dan Williams <dcbw@redhat.com>, Vladimir Koutny <vlado@ksp.sk>,
	Tomas Winkler <tomasw@gmail.com>,
	John Linville <linville@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DOnVt30fvr7V9SjfSho3"
Date: Sun, 30 Mar 2008 10:33:19 +0200
Message-Id: <1206865999.22530.187.camel@johannes.berg> (sfid-20080331_125256_160835_6A512197)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DOnVt30fvr7V9SjfSho3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

Apologies for the long CC list, it seems lots of people were either
involved with the scanning code or could know how it should work :)

After having two bug reports about the BSS list/probe_resp variable in
mac80211 and a very detailed analysis of the problem from Bill Moss, I
think I've understood the problem now but I'm not sure how to proceed
because I do not understand the reason for "Do not allow beacons to
override data from probe responses".

I'll get into more detail of that code in a bit, but let me give a
global overview first for those not intimately familiar with the code.

In the MLME/scan code, mac80211 keeps a list of BSS info structures (for
each hardware that is registered to the system), each of the structures
containing information on the BSS, see struct ieee80211_sta_bss in
ieee80211_i.h.

When we scan, we will always try to keep each of the BSS structs we have
updated with the last information received, but there is code to prevent
updating it from a beacon when we have previously received probe
responses.

Now, this code has two mostly orthogonal problems.

The first one is that there is no actual expiration of BSS structs. Each
BSS struct has a 'last_update' member that contains (in jiffies) the
time this item was last updated. This means that we accumulate BSS
information forever, but due to the 'last_update' only the last few
items will be returned to the user on asking for a scan result. This
obviously has problems since a rogue station could bombard us with fake
probe responses and cause us to build a huge BSS list which is never
again freed until the hardware is deregistered. This will need to be
fixed, of course.

The second problem is the one Bill Moss and Vladimir Koutny were running
into. As soon as we receive a probe response from a BSS, we never again
update it from beacons, hence userspace can never find an AP during
passive scanning if we've seen that BSSID before during an active scan.
In Vladimir Koutny's case this is due to a hardware bug (though I can't
see why any hardware would behave that way), in Bill Moss's case I'm not
entirely sure why he's not getting probe responses, maybe the AP is just
not quick enough.
In any case, the problem then is that last_update is updated only along
with the remaining information in a BSS struct, which is quite correct.
The question, however, is: why are beacons not allowed to override probe
response information? That is, why does this piece of code exist:

        if (sdata->vif.type !=3D IEEE80211_IF_TYPE_IBSS &&
            bss->probe_resp && beacon) {
                /* STA mode:
                 * Do not allow beacon to override data from Probe Response=
. */
                ieee80211_rx_bss_put(dev, bss);
                return;
        } =20

I failed to find any explanation for it in the git archive (it was part
of the first code drop from Jiri that made it into a wireless tree and I
don't have any older git archives handy) nor in my email though I
vaguely remember there was a reason for it (or I may have made it up).

Bill Moss reports that removing this piece of code (and then the
probe_resp variable =EF=BB=BFcompletely since it'll be write-only) fixes th=
e
problem, and it's obvious why.

The only thing I'm not sure about is whether that will introduce
regressions because probe responses can contain better information than
beacons. The only reason I can find for this would be an AP that has
multiple SSIDs with different security settings on each and announces
those only in the probe responses (and otherwise uses a hidden SSID),
but we only handle that now, much later than the code there that was
already present.

However, that actually seems to have another bug, if you have such an AP
will you find two BSSes, one with a hidden and one with a visible SSID?

Any hints about this code or the desired behaviour would be greatly
appreciated.

Thanks,
johannes

--=-DOnVt30fvr7V9SjfSho3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+9QTaVg1VMiehFYAQI4OBAAnqYz2N7hYoGj+qH8T4fwY5BYUoNAtOUS
uHdYT6m+iszMvahiy+UO6RjcoeRsA+ABJAT9BqB92Xv2wbOw5uZyt2PcDel2wSTc
sZVR9Tn1bLgDb9vD2Jo6TT3rDbNmBf7AKRNczfW1PHY0oWBAeoJDIJgsOuDLWxLF
kZZM9zZAXCyh0s2iqkUNayPk3rfq2adOppp0/MR/GjFOyenj6s0iA7edtWJOM4AC
ZKn2vX9sqMtJXv0iScRon6cMCbS86+mL0qlvmlxXAvvyGDIorfXFivZz+a37qIL+
v/jgDwwg/QO8D/hLgU7uDiRsLb2p75uivZG26FtCGDoKn0zaeqKk42H2FCya2y6W
sZvFX81s363pJNrSv8q4wucewdyZjjrXJh1KeapgkRlnsRDr2mtyot0IeQSBNfIX
tae5LXqLiXe+DwzM0IiPBw3P9jcLduakv2ccHsaAG1HxXQBhVNqMxkypvo6lL+rh
LPX2AR8pIPiZSzSA4L+EVMGsBKP7xi9YskGP7Txq/gOoEmUEKcUjX2QHFh9lzbj4
jYkcSnB2PJ4G0vHFEFYw8T129KToX7/7tz0abzc57NQQqf41vktI7/Xm/XNsD1iu
e30owRkHaEbml1c25So4a2sQ3T96yxJbpWl0NgH0H31EW7NodSCZ07EWYwFzjHeh
I/47nINvbnI=
=pqa8
-----END PGP SIGNATURE-----

--=-DOnVt30fvr7V9SjfSho3--

