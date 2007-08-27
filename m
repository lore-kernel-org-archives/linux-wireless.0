Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:29311 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751008AbXH0Ebg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 00:31:36 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: port of my recent patches to net-2.6.24
Date: Mon, 27 Aug 2007 00:29:31 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Jouni Malinen <j@w1.fi>,
	Jiri Slaby <jirislaby@gmail.com>
References: <1188027470.9529.5.camel@johannes.berg>
In-Reply-To: <1188027470.9529.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1445253.alPJtqiKNO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708270029.35845.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1445253.alPJtqiKNO
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 25 August 2007 03:37, Johannes Berg wrote:
> http://johannes.sipsolutions.net/patches/net-2.6.24/
>
Patches 1-9: ACK

Patch 10:
+	/*
+	 * No point in finding a key if the frame is neither
+	 * addressed to us nor a multicast frame.
+	 */
+	if (!rx->u.rx.ra_match)
+		return TXRX_DROP;
If you really want to drop the frame, it should be done elsewhere. It doesn=
't=20
seem appropriate here. TXRX_CONTINUE instead should be okay.

+		/*
+		 * The device doesn't give us the IV so won't be
+		 * able to look up the key. That's ok though, we
+		 * don't need to decrypt the frame, we just won't
+		 * be able to keep statistics accurate.
+		 * Except for key threshold notifications, should
+		 * we somehow allow the driver to tell us which key
+		 * the hardware used if this flag is set?
+		 */
Who won't be able to look up the key?

Second sentence seems a bit sketchy too but as long as I can understand it =
on=20
the first try.. ;)

+		if (rx->skb->len < 8 + hdrlen)
+			/* COUNT THIS? */
+			return TXRX_DROP;
=46or comments like these, I try to put the comment on the same line since =
I=20
expect to see code immediately following an if/for/while/etc. statement tha=
t=20
doesn't have curly braces. No problem if you prefer this style, however..

=2D	if (rx->fc & IEEE80211_FCTL_PROTECTED && rx->key && rx->u.rx.ra_match) {
+	if (rx->key && rx->u.rx.ra_match) {
There's no way rx->u.rx.ra_match can be 0 now, can it?

I think the goto find_by_index can be avoided easily by testing for=20
(!is_multicast_ether_addr(hdr->addr1) && rx->sta) instead.

Patch 11: Well, okay. I'll probably add something like this back in the fut=
ure=20
for improved rate control but it's not being used now so it should be=20
removed. ACK

Patch 12:
=2D	int allow_broadcast_always; /* whether to allow TX of broadcast frames
=2D				     * even when there are no associated STAs
=2D				     */
=2D
Hmm.. that seems useful.. yet nothing is using it? What happen here?

ACK

Patch 13-14: ACK

Patch 15:
+	/*
+	 * TODO: re-add support for sending MIC failure indication
+	 * with all info via nl80211
+	 */
Re-add? Don't think nl80211 ever had support for MIC failure event reportin=
g,=20
but I guess I'm reading this differently. ACK

Patch 16: ACK

Patch 17 (by Jiri Slaby):
+	pkt_data->flags &=3D ~(IEEE80211_TXPD_REQ_TX_STATUS |
+		IEEE80211_TXPD_DO_NOT_ENCRYPT | IEEE80211_TXPD_REQUEUE |
+		IEEE80211_TXPD_MGMT_IFACE);
Or set it to 0?

Patch 18-21: ACK

I'll review the rest of the patches tomorrow.. Patch 22 (revamp key handlin=
g)=20
is a bit too big and scary for me to review tonight.

Thanks,
=2DMichael Wu

--nextPart1445253.alPJtqiKNO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG0lMvT3Oqt9AH4aERAgRhAJ4vg5SmtYWxP8OFTUyjpCf2YJMnzQCcCT6J
7/lUzJasaOSrF6aTavgpTbQ=
=s2HA
-----END PGP SIGNATURE-----

--nextPart1445253.alPJtqiKNO--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
