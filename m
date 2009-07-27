Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43827 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZG0QDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 12:03:19 -0400
Subject: Re: [PATCH 1/3] mac80211: cooperate more with network namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248710387.8500.5.camel@johannes.local>
References: <20090713223333.042733013@sipsolutions.net>
	 <20090713223413.255405284@sipsolutions.net>  <1248653082.3106.7.camel@mj>
	 <1248683249.19945.29.camel@johannes.local>  <1248708886.2688.4.camel@mj>
	 <1248710387.8500.5.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-c2ci8SgBUWytnNCNZpCn"
Date: Mon, 27 Jul 2009 18:02:48 +0200
Message-Id: <1248710568.8500.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c2ci8SgBUWytnNCNZpCn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-27 at 17:59 +0200, Johannes Berg wrote:
> On Mon, 2009-07-27 at 11:34 -0400, Pavel Roskin wrote:
>=20
> > If you mean "verify info->control.vif is not NULL", it makes no
> > difference for me.  No BUG is triggered.  info->control.vif is never
> > NULL in ieee80211_tx_pending(), but sdata->dev is NULL the second time
> > ieee80211_tx_pending() is called.  Just skipping that case doesn't help=
,
> > I still get a panic in that function after about 10 calls.
>=20
> Weird.
> So where does it panic if you skip with sdata->dev =3D=3D NULL?
>=20
> I don't see how sdata->dev can possibly be NULL. Hmm. Ok, I think we may
> not be recycling things correctly. Is it possible that this is a frame
> that was rejected by the device, or maybe a frame that was attempted to
> transmit, but then got into software retransmit?

I have to leave now for an hour or two, but I'll review that code after
I return. It's possible that this never happened before because skb->iif
wasn't touched by drivers, but skb->cb is.

Actually, you're using ath5k, right? So we can see what
info->control.vif points to after ath5k has used the skb, because
apparently it's a valid pointer at least, just not a real vif pointer
any more.

johannes

--=-c2ci8SgBUWytnNCNZpCn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbc+lAAoJEODzc/N7+QmaQbEP/R0xP0cT3NC3B4YHVALD55dP
E9mCm0IqV1Z5cByw+hFLwS7Ue6GiR0Ol1Ss5bUJLh7bb2WTjPYLCemX+3+kJn0u+
kBVKhBhnnDUW6uqnjumZZq27oByEBTCR3CUbsMuQUoZuXpTlrfd5yr4A5OlRtV1z
lXx7PtGdh2e1jGgSdgHt24L3SSuNgty9tg7zoDBRnP3EceNvTtNwujfAuBOLd1Ym
qAlqxxbsRgrUuw6Y2EaYmQ5qcZk3TcSu7M+Vpp05pMdbX0aGm6XapbJ5YjKQs5jb
EPTOQeKnwiaXboFzEFjY7bd0v++3vyXFc+wtV9SKIIdeJP6N5Jd9h0FdqydSucku
6gFbW1XbmEJ2IDO+niX1Fh0xtDr/ky2kRhx98ktPuGFRRuwZvNxiY6NYQSm10wG1
1qn5EGhBJLqE2ToJyhnA0FXN154MeQY1xNxXMtEGKSfqO2Mv4jS09t0RO7Oeyzcv
U9QGVXKMeI4wcHs1M2/eTOtPTMhsvIuDlKVBb4qYijnR3alktFPCblJ77DqsUID3
5ruB63jeWbrxjeq1hBqhqrcHmZWSSCsg5PTaoNow8ieLTB8xTAtYPg4xcg459M8k
ybHURfN1HtfDSgBxhaRS+rc8DXgh4vqrLQPkxXtzULgsuoNSzN9SDztBeZK0hr6D
V4fWKBsofwwB8gVI/iw3
=+nA/
-----END PGP SIGNATURE-----

--=-c2ci8SgBUWytnNCNZpCn--

