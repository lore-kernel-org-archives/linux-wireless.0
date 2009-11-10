Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbZKJJU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 04:20:56 -0500
Subject: Re: [RFC] iwlagn: reenable AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
In-Reply-To: <1257816610-26290-1-git-send-email-linville@linville-t41.local>
References: <1257816610-26290-1-git-send-email-linville@linville-t41.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bVesynPCfH7McvFIdt6w"
Date: Tue, 10 Nov 2009 10:20:22 +0100
Message-ID: <1257844822.3623.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bVesynPCfH7McvFIdt6w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-09 at 20:30 -0500, John W. Linville wrote:

> Really just poking around here...am I on the right track?  Or is the
> iwlagn firmware supposed to handle buffering broadcast frames?

I don't think this patch will work. When a beacon is updated and we then
send out multicast frames it's typically been quite a while since the
beacon was sent which can be quite bad for PS stations. I tried
something like this once and it didn't really work at all, ARP requests
went unanswered pretty much.

> Looking at Johannes's docs, I don't see anything that seems
> to relate to "implement sequence numbering for frames with the
> IEEE80211_TX_CTL_ASSIGN_SEQ flag (or ask the hardware to do it for
> those frames)".  Anyone know how to ask the hardware to do that?

It does that, but for legacy reasons iwlwifi makes it depend on whether
the frame is QoS or not without checking the flag. It also assigns its
own seqnos to qos frames ...

> I also don't see anything for "When sending probe response frames,
> the timestamp must be adjusted by the hardware or firmware."  But,
> I didn't look too hard -- maybe I missed it?

That is normally not required to be programmed specifically, but I don't
know in this case.

johannes

PS: you sent this patch as linville@linville-t41.local


--=-bVesynPCfH7McvFIdt6w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+TBQAAoJEODzc/N7+QmaH40QALxCfIwN2aUWwS1vQYffc9yZ
C7i+7BYQt7iJP16oqnlfYhbxjOcHwFbLMm5H318c/TG6J0IZAaOJzKSKlm/2Kbu+
8KxmjJDB5qjN+Y0NOKBRWTCk4K4It19WKidtIOxizTpurfE2ut3EO49iJFbnAHCz
ZBjISjhjTi4pPrA2nWM0jXCsEmcgw7stUUZz1dcxkaXKy+ws/Qwa1bSHxERKotx2
nfiEiV2mL0oVj6KzZ2PZjpc6sVc5Nsxf5L/7zcmAfiKBJB7N8BgCAKwmAz/QBHEC
Sn5kMab9nyRKqapLbEpsegKYbz/KkPH07z0IlqyBoOBDR2o8Lu9pgHtFQmhu2o2I
96ptVwYfHscb9PNPT5AH0/lRP/cuXP8+O2ppYu8H+5ydarN5CDomBomJFBGPRGgu
uRII4tTlFBJBVr0sRZQuQAOR7yD32WN0xRn6pULT/hrDWk53zUunO1sTFuF4duqS
hlSb9fEVDLaFETdIDY5JffFnqDu99mZtFBeBVfrc1dMAo8Mt8E90zhyTpKIhKNU2
vt7v+VlRkduy+rJ6AXCuRMYvpAENsvnVDuRgDUeIXrI1UCbts0nspguomlRsVTG6
7wC7OE6FLDS0fXOX/FnHGtNke/qd8mt+m8W7u2NDLUYZjxSzz+ZZDmuksGhbw3xj
7nrIZGFaVJxVGVpFZrkp
=YUfs
-----END PGP SIGNATURE-----

--=-bVesynPCfH7McvFIdt6w--

