Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246AbXILP0c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 11:26:32 -0400
Subject: Re: iwlist and network-manager bug report
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jean Tourrilhes <jt@hpl.hp.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1189526874.6161.30.camel@johannes.berg>
References: <1189526874.6161.30.camel@johannes.berg>
Content-Type: text/plain; charset=utf-8
Date: Wed, 12 Sep 2007 11:22:52 -0400
Message-Id: <1189610572.5644.28.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-09-11 at 18:07 +0200, Johannes Berg wrote:
> Hi Jean,
>=20
> I have no idea where to send bug reports for iwlist so I'm mailing yo=
u
> directly with CC to wireless-dev so others are aware.
>=20
> Dan, for NM I suppose the right bug tracker would be redhats? I'm
> offline as I'm writing this so I can't check.

NM 0.6.x and earlier (quite wrongly) treat the SSID as a string.  That
has been fixed in 0.7 trunk, though we do need to make sure that NM
0.6.x and earlier don't puke with it.

SSID conversion is really, really tricky, and NM tries a few things to
coerce the SSID to UTF-8, including trying your LANG encoding if it
exists.  None of these methods work reliably though.

Any suggestions?

Obviously NM needs to be fixed.

> Anyhow, the problem is that my landlord has an AP that broadcasts an
> SSID with a 0xFC byte in it (supposedly an "=C3=BC" in windows). iwli=
st,
> however, just prints
>=20
> 		ESSID:"B

iwlist just stuffs the SSID into a null-terminated buffer and prints it=
,
it doesn't try to do any cleanup of the SSID at all.

Dan

> and nothing more (the SSID is B\xFC...). wpa_supplicant converts it t=
o
> an underscore in its output (B_...), and network-manager also seems t=
o
> not like it, though it doesn't display any networks right now. Might =
or
> might not be related.
>=20
> I think it shouldn't be displayed truncated, although it is probably =
not
> possible to display it in a fashion that all shells will properly par=
se
> and convert to the right binary before invoking iwconfig or such.
>=20
> johannes

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
