Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbXJKJPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 05:15:52 -0400
Subject: Re: rt2500pci 2.0.9 not working
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcus Better <marcus@better.se>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com>
References: <fdqhn4$qab$1@sea.gmane.org> <fei4sd$mm0$1@sea.gmane.org>
	 <1192008384.12541.8.camel@johannes.berg> <fei71k$tu7$1@sea.gmane.org>
	 <1192009901.12541.15.camel@johannes.berg> <feibbk$de1$1@sea.gmane.org>
	 <1192015848.12541.20.camel@johannes.berg> <feig3h$urf$1@sea.gmane.org>
	 <1192038202.4770.3.camel@johannes.berg>
	 <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E3NfSeI2Tx/sfKBXqbQ1"
Date: Thu, 11 Oct 2007 11:15:59 +0200
Message-Id: <1192094159.4770.21.camel@johannes.berg> (sfid-20071011_101555_444857_F2EE459A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-E3NfSeI2Tx/sfKBXqbQ1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-11 at 11:05 +0200, Marcus Better wrote:

> > No, but you can comment out the B mode registration in rt2500pci and se=
e
> > if that helps.
>=20
> I have very limited time to find out how to do that, but will gladly try =
a
> patch...

Me neither. It seems to be in rt2x00dev.c, Ivo can you help maybe? Just
for debugging. I'd have thought that adding the 'break' statement would
fix it.

Alternatively, could you print out the selected mode in
ieee80211_ioctl.c:ieee80211_set_channel?

something like
printk(KERN_DEBUG "selected mode %d\n", local->oper_hw_mode->mode);
printk(KERN_DEBUG "select channel %d\n", local->oper_channel);

johannes

--=-E3NfSeI2Tx/sfKBXqbQ1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARw3pzqVg1VMiehFYAQKeSQ/7BNlLNmbNn+Uisj2ymMT7QyghDt6axYWL
tiqywpFin0yJ7cDmrkzcPmNl8kbBtJsnOtvx1qL4nNqHktTI1/4SeumbYmoc5wLN
dd8/KIbNPzsMQ9VI8TsbgtbEsmf7AqZsgHVibS4xO2ZeNI39jVUK2rOp6CpE2eDe
YtDDbcDDaik4wBQsEv004NPK3XmH7a9hwlNKqJizFuWlgMokLxCsJtjZFPnDkl8I
unlOowR17n8rY3Haf/MSaEdqDGLlrTVBtww0gMBXKfadUaC5zMePDHycIAFuGbQi
fMpEd3hSrLrQFrryOK6vxtGVglxw3wd86aXd7UW/w+VMXXCyty+cA37xQOjLyFXe
ND+0Wv1ssdghUCTtX5nPh4S43SfdqTNLiK7CZnGFgWdXWpEk36NhT4GseLKHMMTu
g8raK0TjQvmoezXCktAK1uSwd4RfYdlQ3S/WsF/9q+VQSqibRWsUM+CxnhzwjP3Y
NlIVMT78mGaC518X26GUHogd2eLixwH6Bgppi6wOmrE8W7CNyAGw57ctAPET1z1A
hjdhxoZVAo2+UzfQ8m7+TB4tacbn1mgXpFhzUKB29ZjZiVPMjzpft8N5w5WAaOaX
Vr/OYVUC7k7QutMJCa0l92cEYaOI/mdLZ+AgG+z6MWMiMHsvwpb1sNFiSfobXxYu
dy7w57giPXI=
=3xpV
-----END PGP SIGNATURE-----

--=-E3NfSeI2Tx/sfKBXqbQ1--

