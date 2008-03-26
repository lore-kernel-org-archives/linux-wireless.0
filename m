Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbYC0Msm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 08:48:42 -0400
Subject: "Try to stop Tx aggregation on non active TID" messages
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K6UtYpBppXR55E2ypXlW"
Date: Wed, 26 Mar 2008 22:59:10 +0100
Message-Id: <1206568750.22530.8.camel@johannes.berg> (sfid-20080327_124855_672815_CC6DF277)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K6UtYpBppXR55E2ypXlW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ron,

It seems that after commit b4b5e1f49e9982a1ea0b3408e0df6adee49dad54

    mac80211: tear down of block ack sessions
   =20
    This patch adds a clean tear down for all block ack sessions if interfa=
ce
    goes down or if a deauthentication is done.
   =20
    Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
    Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

we have a slew of messages saying

[18131.640793] Stop a BA session requested for 00:1a:2a:2c:a2:c5 tid 13
[18131.640798] Try to stop Tx aggregation on non active TID

just like we had for the RX case before.

Please decide once and for all decide whether it is valid to call those
functions, now especially ieee80211_stop_tx_ba_session() when no session
was created.

As indicated by this message rate control algorithms shouldn't call this
function when no TX BA session is present. Therefore the stack itself
shouldn't do so either. The same holds for RX BA sessions.

Please make sure the stack itself always uses the functions only as
specified by their API. Feel free to change the API to allow calling a
function without as session in progress, but in that case please don't
print out anything at all.

Thanks,
johannes

--=-K6UtYpBppXR55E2ypXlW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+rHLaVg1VMiehFYAQKfJBAAsZz8R1FmONmHbpjKX3JExpHPz3Nxk80f
ASQ0vNXxwBf7jgq2NOdH3vGsqidvxUGB8nlNqpxbFEdPgjuvQMTgoaI7ySXBscL+
9QwDQGNpLqOU9P6BzJdJgqi7+n3pb461x4VO+OrACm5Xdggv320QrpqAkqQPW33b
D92AGWnqLOOfyID45BaMpgJ7UhP6lylguaEH2KDkkjHBW3uSmdzA5CP7Oj38hyIo
Fyzd0Qo+1sGWKGtVooy8w23D9exBHoirZMOtmKz8CnhBQ+cYVtwqwy5DZw5Hjz+F
1kZrRljsGxoO13nXLJ7ULZC4PtLCjKmO96G9tKkgG5T9Ra2SUFzG1WWmeKgeW2yn
uMJlksZvYbT9psRZsnyNZxizdwcezX65T5GxaV05eAvFrgrNjuUNGzQdlIgPGGXi
FuUs8PeKBlwmbJzc6Vk8v7orYszvFNV9Vq14BK9uVRl+RKHysnhD81gNdbb7R6ci
LFyVSPBG/N4BzsYw223jaimN2SL08h8av6404uvrBDSdq7Ij92iEqNIGTe4xig48
s3tFSPJSkkKav2diH6efn2o4X7XPup7jTh/6e3e9VhDyxmypDTJiwEbJ1xeEPMa0
lZEmdGL1o2MpZKD+tdBKShgbr/MbKwN5DFvGJbIh8j9U3GVhvGVsq9tLnb82tv0H
UK5Rks0CDdg=
=ZVOT
-----END PGP SIGNATURE-----

--=-K6UtYpBppXR55E2ypXlW--

