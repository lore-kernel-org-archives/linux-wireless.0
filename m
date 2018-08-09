Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:56334 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726890AbeHJAxr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 20:53:47 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Peter Oh <peter.oh@bowerswilkins.com>
Cc: Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        Jasmine Strong <jas@eero.com>,
        Ben Greear <greearb@candelatech.com>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        =?utf-8?B?TWljaGHFgg==?= Kazior <kazikcz@gmail.com>
Subject: Re: [PATCHv2] ath10k : Fix channel survey dump
Date: Fri, 10 Aug 2018 00:26:43 +0200
Message-ID: <11036966.yxZ1zVvfjs@sven-edge> (sfid-20180810_002656_311649_DDD5A141)
In-Reply-To: <619039a5-3b30-b49d-dc85-9ccfa4403251@bowerswilkins.com>
References: <d586156d3861a6cf0f479ff12ddd6544@codeaurora.org> <619039a5-3b30-b49d-dc85-9ccfa4403251@bowerswilkins.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1614932.M8rUiM9o42"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1614932.M8rUiM9o42
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Donnerstag, 9. August 2018 20:46:26 CEST Peter Oh wrote:
> > In ath9k driver also survey data being accumulated in driver and send 
> > survey data to user space is accumulated one. same thing we are 
> > implementing in FW(with WMI request type WMI_BSS_SURVEY_REQ_TYPE_READ) 
> > instead of doing it in driver.
> It seems you're changing the behavior, not fixing a bug.
> WMI_BSS_SURVEY_REQ_TYPE_READ_CLEAR is handled differently from 
> WMI_BSS_SURVEY_REQ_TYPE_READ and as Jasmine addressed, userspace apps 
> that's counting on WMI_BSS_SURVEY_REQ_TYPE_READ_CLEAR behavior will be 
> broken their functions with your change.
> This means this patch will break backward compatibility.

Sounds to me like a bug when there is a driver independent API but two 
incompatible implementations:

* one driver using accumulated values over time
* one driver using non-accumulated values which are reset after each read to 0

Especially because there is already software which expects the accumulated 
values and which has no way to find out whether the just received data is now
accumulated or not. And it is also quite bad to have non-accumulated (ath10k's 
read+clear) data when multiple programs need to gather this data at the same 
time.

@Felix, @Johannes: Should &struct ieee80211_ops->get_survey/
NL80211_CMD_GET_SURVEY return "accumulated" channel utilizations values or 
clear the counters on each read? Might have missed the relevant phrase in 
include/uapi/linux/nl80211.h, include/net/cfg80211.h or
include/net/mac80211.h - so feel free to just point me to the already
existing documentation.


Btw. the same author also tried to implement the "accumulated data" behavior 
for get_survey in cfg80211 when a driver only supports read+clear:
https://patchwork.kernel.org/patch/10417673/

And here the earlier attempt (changing it from read_clear to read): 
https://patchwork.kernel.org/patch/9701459/ - the answer from Felix suggests 
that the accumulated values would be correct for the channel utilization 
related info in struct survey_info.

Kind regards,
	Sven


--nextPart1614932.M8rUiM9o42
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAltsv6MACgkQXYcKB8Em
e0YfCBAAslGx9BTK0YtmKGa+ad8zi5E395a6/6L7CNyQ/5ZXfM4q55jfHZ8YM6Wn
kz4+113VbdLFlpQ5iKyA1GeJx5P8ofnFAHYmrSbg23xz1Z4G9SEwM++cO8v41Nvj
1+HvbmambzRXX6RuVTVyFXfjU7nEFL5+sc3bc0v9fAX0Ewf6JoDPofIBrg2uYSgq
5O+kw7EVRa6BsKnDq19JWZv11GA5EVF8NnSpUiGjKcnx7nCWgzXONE1SDXG7hrT4
PdII9iF8YJFDUIxm9skylVRWSDYEdlAEPdSvTcUuLHAHZmTS9316TqLRWECIy+Ty
2aQxi1ksdhE45rMWG33gIGlncl5tcBxPsyXYoYZC0QkdWdTuz+bFiO04doJQ5e53
8T8XWV6xlhr0KuC7P1465j+k7sCZA4U/LEF6Z6gWc0VdkN/q8NSZCg5KwT7zm3bD
7HXRDunpTJ4OVdWi6z6RotGBfjr2ukoGN90silrfa/R4LpRHw/Hc3Jsm7tZkRS6y
DH30Y8xJp+5TDLsnEj0G5e/TAAs3+c+zBBDd34kDne5Kw1NMvWaDEKK/dV/GWY45
0RF7cuoEIHJfgpHtRfydqFnM4SCHZT+Vswpss9OIftbPLfonN3xAvdzUz6hCk5C1
jdq/Kl1o6GLlqDxFNQabhiQaIfOJXj476fkmNyPFfYwffSINa8o=
=5TNR
-----END PGP SIGNATURE-----

--nextPart1614932.M8rUiM9o42--
