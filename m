Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYKXNlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 08:41:11 -0500
Subject: Re: p54: AP mode: no data frame despite traffic indication set in
	TIM
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Chr <chunkeey@web.de>
In-Reply-To: <f76a32050811240536n4643d477jb49f8e18cb860820@mail.gmail.com> (sfid-20081124_143654_582633_D11529BD)
References: <f76a32050811210612i13ee251ewd6c1cab616a62529@mail.gmail.com>
	 <f76a32050811240536n4643d477jb49f8e18cb860820@mail.gmail.com>
	 (sfid-20081124_143654_582633_D11529BD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bTqIQMTXBIMFTZPtdF06"
Date: Mon, 24 Nov 2008 14:41:08 +0100
Message-Id: <1227534069.2927.5.camel@johannes.berg> (sfid-20081124_144114_502026_DF519C6F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bTqIQMTXBIMFTZPtdF06
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-24 at 14:36 +0100, Stefan Steuerwald wrote:

> I see "dropped TX filtered frame" messages in the syslog when at the
> same time I see wireless packet sequences as described below. Please
> see the attached logs.

Ah, very good, thank you.

> Nov 24 13:49:11 alix kernel: wlan0: STA 00:22:41:91:8e:96 aid 1 send
> PS frame since STA not sleeping anymore
> Nov 24 13:49:11 alix kernel: phy0: dropped TX filtered frame,
> queue_len=3D0 PS=3D0 @135594

That confirms my suspicion that something is going on with p54.
Christian, can you review the comment in net/mac80211/main.c around line
400, the one about races, wrt. p54?

> which may explain why I don't see any data packet on the air. Also
> attached is hostapd log.

Indeed.

> Another thing is the fact that we see 24(!) consecutive beacons with
> TIM bit set until the iPod finally wakes up. It seems to be lying to
> the AP, as it advertises a listen_interval of only 10. May this cause
> the above?

That is another issue, yes, but probably not causing it, we'd be seeing
"expired buffered frame" messages if it was, I think.

johannes

--=-bTqIQMTXBIMFTZPtdF06
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKq7xAAoJEKVg1VMiehFYojkP/1rf97Ed0Pqkg3zIzXoVZsIV
bZiB7h7iU61p5/JwQai0/SOlUGVb1tDPxjGxJ1LZkzBYt9ZYDx33HSjWhZvZw7Gp
ygYHijxC+3pZUdXTSf5Bp7lk35wt9OHNtj7nxtjxQXlsJi5J3bpjRn7sc1CPPgac
E8RJrwb32Ns8n4b4IK1na/9mpDCEgBpvEE7LHH9TaRWCayx54lTBh0ufie5gBF8G
7LdNq+btNZrBNx5x2rXvhdSlMEruF00Q/+MyiRDiY8tw1vtVHk7DuJIGP84joLfx
gH2jOxYdOh/NJhR3e9GxgpED5QWWJBc9ukw6lLjdE43F1J7Sbp050NFSBkCvG5XB
Y4iyXLUQ2/n+1edPlhatz/so36pc4qHqfLFumdFokQkdmWIaX0LH/Po8DxqwOal0
W7ybJFZbfUPTEaAxYzGU7ElrNAbD9usHhM0d4dEJb5Hhm3XFAql4A2topAcs+B9k
w08HXeZvlAbJgl9DfiqHS70CMEPVQVfE7bkwrfPQdXCh1K+Yr3cGR993d4mclyxy
fLPPCP4M5Xpf4pLSnfPfgbiOYxmisgM4SyQw7HMxBX8Znicdsn0AYTCI/1MAL42m
vLDEmrcQcthJhzF3WyioMyNa0jG6R61mr1brQ7+0CdL9rYQuQWMV9N7vEm5CSjxl
ZndRIDPEUIegrixb2az+
=p/WA
-----END PGP SIGNATURE-----

--=-bTqIQMTXBIMFTZPtdF06--

