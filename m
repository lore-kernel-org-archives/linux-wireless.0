Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:41655 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab3KFPLK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 10:11:10 -0500
From: Sven Eckelmann <sven@open-mesh.com>
To: ath9k-devel@venema.h4ckr.net
Cc: linux-wireless@vger.kernel.org, simon@open-mesh.com,
	openwrt-devel@lists.openwrt.org, Felix Fietkau <nbd@openwrt.org>
Subject: ath9k: Deaf QCA9558 when setting rxchainmask
Date: Wed, 06 Nov 2013 16:04:25 +0100
Message-ID: <19772470.YgPhAz9cYD@bentobox> (sfid-20131106_161114_100365_C126CFFF)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4027139.FNsUmsH3v2"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart4027139.FNsUmsH3v2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

I've needed to test some problems with a QCA9558 Rev 0 based 3x3 2.4G device. 
During these tests I've wanted to try different antenna configurations to 
reduce the complexity of the problem. This was done by setting the 
rxchainmask/txchainsmask to settings like 1, 5 and 7. Unfortunatelly, the 
setting 5 (antenna 0 and 1) turned the device completely deaf. Here an 
overview of the settings (excerpt)

chainmask | ant 0 | ant 1 | ant 2 | Status
1         | 1     | 0     | 0     | works
5         | 1     | 0     | 1     | deaf
7         | 1     | 1     | 1     | works

The antenna setting is used in ath9k at different places but trigger seems to 
be the AR_PHY_RX_CHAINMASK register write in ar9003_phy.c in the function 
ar9003_hw_set_chain_masks. Forcing it to 7 instead of the requested 5 avoids 
this deaf state (but makes the rx chainmask setting useless). Of course, this 
is not a valid workaround and quite unexpected.

The test platform was a current trunk OpenWrt build together with compat-
wireless 2013-02-22, compat-wireless 2013-06-27 and backports 2013-10-31. The 
settings were configured using the txantenna and rxantenna of the OpenWrt 
wireless config system. Both were always set to the same values during the 
tests.

The deaf state was identified using 1x1 and 2x2 clients which could receive 
the beacons of the device. The QCA9558 device was then unable to receive the 
probe request from the clients or any other traffic on the air. This was also 
checked by a monitor (flags: control) interface on the same phy.

Maybe someone knows whether this is a known problem with this SoC or what 
information can be gathered to debug this problem further.

Kind regards,
	Sven
--nextPart4027139.FNsUmsH3v2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCgAGBQJSelp5AAoJEF2HCgfBJntGmGQP/RYHJDWp8V0vxN6/tRtAntIC
HB5W4MrYqahSYoItQBJT1MQgoLVfBhvfT8yrhtT2yBmkeb2O8y7DM4PnDY88xSnm
s3muWczfP1ssleugeDh4fdd4gHDFz3t7quJg3FsFCObdOj8lIZUP38vppEN7S/Fu
OABbMKD8JfkqMpij1EYv0q3265WORv3FLnwWXelL8YvnNGFK+pJ3tzzPOWDcNadb
T5ZvbSGFrJW6+P2GoIb4pCJr9wFa6E+LaL/eudaAptpvQWJ4H6hnz+SYPaeAmcsZ
Vf/k4sHbVa1QK1RupNYqgn9RtUoRXOQMt/y3nHo5bnr4hDxIkdJDuRIQ+bARGuQK
vE5j37OUxMlM6d3sbyOtYZxdD91Nh5C76/YmJqaOk0MuLr3X5PoA6Y8FSPMjIW5Y
UGuEMycXEUGALx2vJTyZFgf1qMs+OUcXxMt8cJb9+q1lNYD6uhGqO8CdYuejOXGO
xALjDrf08N55ycdI6j9MddhJJV14JlP/jVGibbf4DNxUGxWRB3Cr7kIu+wtpJPYe
BfrKAjXPpApC+QnsD4hNnEvCMP+ty4JHzcZChCrOheNaUb14jUoGD5GcpYgWPYL3
rjFeIh5gnqj+ugAdzeCgHBVraJK3RWPtrgX+CK6vscLbhWAUo7PBbVBigbYAeyUV
3+oogJIZhvxmfH7RKuel
=uiwG
-----END PGP SIGNATURE-----

--nextPart4027139.FNsUmsH3v2--

