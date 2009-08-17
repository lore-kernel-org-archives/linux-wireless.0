Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38000 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZHQHYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 03:24:00 -0400
Subject: Re: [PATCH] cfg80211: set SME state machine correctly for roam
 event
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1250476527.9651.21.camel@debian>
References: <1250155399-17847-1-git-send-email-yi.zhu@intel.com>
	 <1250157249.21250.0.camel@johannes.local> <1250222301.4972.31.camel@debian>
	 <1250261645.24924.22.camel@johannes.local>
	 <1250476527.9651.21.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xIA2iaW/PxSXdsSvEvtv"
Date: Mon, 17 Aug 2009 09:23:52 +0200
Message-Id: <1250493832.11216.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xIA2iaW/PxSXdsSvEvtv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-17 at 10:35 +0800, Zhu Yi wrote:

> Yes, the iwmc3200wifi device sends special disconnect and reassoc events
> for roaming. But since we know we'll be reassociated shortly, we don't
> propagate this special disconnect event outside (to kernel SME and
> userspace). I agree we should use cfg80211_roamed() to indicate a real
> roam event. But sometimes the device reassociated to the same BSSID. Do
> you think the driver should simply ignore this event or still call
> cfg80211_connect_result() as well?

You probably can't just ignore it since it might require re-doing WPA
handshake, so I think I'd just send a "roamed to the same" event.

> Continue with the above case, in my current implementation, I call=20
> cfg80211_connect_result(). Then I find the SME enters a weird state
> (CFG80211_SME_CONNECTED while wdev->current_bss is NULL). So I think if
> we don't allow cfg80211_connect_result() to be called while
> CFG80211_SME_CONNECTED, let's put a big WARN_ON at the beginning of
> __cfg80211_connect_result(). The current code seems allow this case
> (i.e. send some roam event), thus I'm confused.

Ok, I'll take a look. There probably was a reason that's somewhat
related to the cfg80211 SME, but it must be possible to change.

johannes

--=-xIA2iaW/PxSXdsSvEvtv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKiQV+AAoJEODzc/N7+QmapnMP+wTWqXwRqrHhbsioe2lrdsak
XfQD6HIMdoKs3D4ILWBYs3IZ6MlgjUv7mv6IH2mlH1oAJZienbhpvz/PvfwMLwcC
P87+C56fKyP1vSd/WfyLvLE9V6CfOqxdWUuy7NRr1uZWWbDqzkFIhz0a0WibC5pG
Z34t/V31rVt05O4uK2USrEf4TSktRcpZdrED7yYJVnd25NnFAnJdfOWs8oNXa0Mo
hnKQPpcGCQsMZsjZ6iDY/a6TPcu7mKG7WLSlpuNgg/EwuZ7tE1tp3+zYCCUq30UF
BS9E80m3Neagrs05Zm0YeWWbeo0+SF7t2BUN09bM48+PKCx7x8frAVDs7zVCaXH+
JTTXdRKIDAfmjc9L8Vivtq+EwLy+TC900opNiOEkIfA+WeJgqphbpHL6rNBDUO2e
Rcpz78EwaE2uOLi8fCLzvjxFpoLNf69VDgfXUW1lmPBCOjHANvlUKSIIo4a194Ze
BY3aaJYzmExb5WJmamPlwJgt91x4rVhiIiyY0OPofbqJyu7xY2ydpGb8M8u2qc56
llBZOlLx0EA+Butxf1t3cPEGWbytdyef6OU1bmHHYv75uUPqUWBzaOo9WQUwfull
O3xEmHfatCTBzBVfcTLlXW/w2zKosy1jxYVnx3H5JHmAnclzo2/D4EUioN+wtCqB
Oxz/ipZB7l9Dp59vZf+m
=+Nj7
-----END PGP SIGNATURE-----

--=-xIA2iaW/PxSXdsSvEvtv--

