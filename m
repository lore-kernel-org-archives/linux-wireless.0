Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbZEKKB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 06:01:56 -0400
Subject: Re: [RFC 3/5] mac80211: fix idle trigger upon resume
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1242033904-25694-4-git-send-email-lrodriguez@atheros.com>
References: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com>
	 <1242033904-25694-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-s3tKVsVl+Lc3mGnlbVx9"
Date: Mon, 11 May 2009 12:01:55 +0200
Message-Id: <1242036115.3284.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s3tKVsVl+Lc3mGnlbVx9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-11 at 05:25 -0400, Luis R. Rodriguez wrote:
> When we suspend we stop the queues, then upon resume
> the new idle checks will immediately pick up we're
> idle and ask call our driver's config callback. At
> this point its pointless to to call this callback
> as we haven't yet come back from suspend. We avoid
> then making assumptions about being idle until we know
> we've come back from suspend. We do this by checking
> the reason stop on all our queues.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/mac80211/ieee80211_i.h |    2 ++
>  net/mac80211/iface.c       |    5 +++++
>  net/mac80211/util.c        |   39 ++++++++++++++++++++++++++++++++++++++=
+
>  3 files changed, 46 insertions(+), 0 deletions(-)

> +EXPORT_SYMBOL(ieee80211_any_queues_stopped_by_reason);

You certainly should not export this symbol.

Also, __ieee80211_queues_stopped_by_reason is misnamed since it checks
only a single queue. I also think that we can do this much better by
keeping track of the suspend state in a new variable rather than looking
at all the queues; even just checking queue 0 would be sufficient, but I
think a new variable is warranted.

johannes

--=-s3tKVsVl+Lc3mGnlbVx9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKB/eMAAoJEODzc/N7+QmaHr0QAJENXefaN+kRI/ebtKUfVR2a
HitkyimAq0IOXHoAb4FVHyIwih2QPGRV3/JbbaYLyrE5XcBOUtrt3f24dLXf34tU
oZXfO8chRPaEkK1oBYHRewIPDz1NDiF4hMZf4/eGf19mO0vfS5/VME2Hn84JH2p9
tAkxLQBoJ1uNvVHFK5qBXUweu6i61YB0Ggn4g7huW9BiSO7L9y4oQHRoRnFnQKQg
QImz54jawQAyD8npKNZACl0QSER5pVCMVEu/21w6qe3+wn/9xT+oasv3wceQItfV
PWQFSwAYlSLRQvHBizaHAljTJP6nceWRA0gBMIStynRuYVznUTPlsnHfqLLJ2UiZ
60pMNoUIKYEt33SYoWhcTnjaia5MI+u1SzpXZFRFaaeA8OyVJebJX2yQ1aLK1WFy
hIUFxJk09DQ36PH9l5rQx42xFYuYlD4RhtDkcFVLMPZy1mSKDeILCKoFckWmu6Ba
zstLoQ7IsewB/qCv2mD0TFpnJBoyLqt1EPdwR9bOSZEi5Y3Vwn/WWfhjFqmkEnln
VQBOY4YjTFTxBWUZ2fIpoAJ2XMxf8OTMlVqmet6rBZ7S4Oj2JMFWYlZ1v82L7K4x
NY32uY9mhzSS6za00N04hFv6s/b5i5w/UrgJcQPGfigWi5ow48alp6WKlanLXnmC
qY8fhQK+ifyGCfU30VBC
=U08q
-----END PGP SIGNATURE-----

--=-s3tKVsVl+Lc3mGnlbVx9--

