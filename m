Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35779 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbYFSRpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 13:45:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [RFC 3/2] get rid of rx handler function pointers
Date: Thu, 19 Jun 2008 19:44:52 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1213879121.8967.9.camel@johannes.berg> <1213896016.2125.51.camel@brick>
In-Reply-To: <1213896016.2125.51.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806191944.52164.mb@bu3sch.de> (sfid-20080619_194521_350366_0BFD8B49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 19 June 2008 19:20:16 Harvey Harrison wrote:
> > =EF=BB=BF#define CALL_RXH(rxh) if ((res =3D rxh(rx)) !=3D RX_CONTIN=
UE) goto rxh_done;
>=20
> Would it really be so bad to just open-code them rather than the macr=
o approach?

I think the macro makes it readable. And as it is defined locally it
does not obfuscate it.

> 	res =3D =EF=BB=BFieee80211_rx_h_passive_scan(rx);
> 	if (res !=3D RX_CONTINUE) goto rxh_done;

This would most likely need to look like this, if opencoded:

	res =3D =EF=BB=BFieee80211_rx_h_passive_scan(rx);
	if (res !=3D RX_CONTINUE)
		goto rxh_done;

>=20
> 	res =3D =EF=BB=BFieee80211_rx_h_check(rx);
> 	if (res !=3D RX_CONTINUE) goto rxh_done;
>=20
> 	...
>
--=20
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
