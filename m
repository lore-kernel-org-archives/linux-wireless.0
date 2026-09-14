Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FB447206A;
	Mon, 14 Sep 2026 12:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390580; cv=none; b=nbGD0q1WTchaQn3EPQFGITweg8fViQFJYxDpQwqrf0AUYKh1znInLyGsDfg0JJzSa6U2z2wD/3ImXjyb+RoSe5mumpc/paBaVcLUqI8nm8XtUfm/cSSdiYqNEA2lSM1IcLo6U/ZQBsqkE98YmRUgBeNZjfCyOc5QNbSim7P4tUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390580; c=relaxed/simple;
	bh=op7RJRMnijOtfhRS//6m+Rlo0sKezYS6mYhZSEvm+V8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jJ32DGGFE6FVfgHGicsRriz8yjgPKvlKT/uo62dcR3t9DPGmcxnY7i+URCyCrQ0raRn1WCGput0RIt+s+wPa1DJnM56MLc02c6bBCkcPIvBaINWpCd/v8cmdsZfQBhlb6Z4cfHdg8vLBaTTBybQ12MGmMzdr/RTGNvpuUzGCzT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=hxX3JcfT; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="hxX3JcfT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=4i4VM7Z46kXIn0YfP8jxZ58jbHidsr6xHVhYZgaY9o0=;
	t=1789390577; x=1790600177; b=hxX3JcfT2q3lEKSygw6uZ3ik2tdKT3lWjx/hjjhiTnbFI+l
	BE1zZ8WK6a1OJIhZbRZP6IzuA0a1YbeilpdOtX7LLlW/W/10qfKD/lTXS9QQKPHJJIK7omkwSfTek
	XqWpuumdX+4A67q9tZBxiy1Ln3IcMxjoeiTIzHadUDxPqe40Jdi1wAosrsgoDr/8qDLopglvhbLJC
	emhgYhLkBBsLusDSG7ohlxA2aSpUmDNJcS+6qhl8zyY18aRzjAx3UcePhWCQCfXVU38cJNMPUuwLj
	u+96205OJUhc3fAzOSVrCzJr4gS6+rdg1OBqvUtu16vO/RT3r63who0Xp7nyGFhw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x66EI-0000000FSq8-1SM3;
	Mon, 14 Sep 2026 14:56:14 +0200
Message-ID: <f54733f96719f5efc360cfae62555e7413ddc696.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: mac80211: don't reconfigure when the last
 emulated chanctx is removed
From: Johannes Berg <johannes@sipsolutions.net>
To: Nerijus =?UTF-8?Q?Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>,
 	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 14 Sep 2026 14:56:12 +0200
In-Reply-To: <20260904032235.355479-1-nerijus.bendziunas@gmail.com> (sfid-20260904_052244_513528_82A5051C)
References: <20260904032235.355479-1-nerijus.bendziunas@gmail.com>
	 (sfid-20260904_052244_513528_82A5051C)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-09-04 at 06:22 +0300, Nerijus Bend=C5=BEi=C5=ABnas wrote:
> ieee80211_emulate_remove_chanctx() calls _ieee80211_hw_conf_chan() after
> the last channel context has been removed. With no context left,
> ieee80211_calc_hw_conf_chan() falls back to the default channel, so the
> driver is switched to a channel nobody asked for, and the next context
> switches it again.
>=20
> A monitor interface retunes by removing its context and adding a new
> one, so every retune costs the driver two channel changes. Nothing is
> transmitting or receiving without a context, and the new context sets
> the channel, so the extra reconfiguration is unnecessary. Keep clearing
> radar_enabled so the next configuration starts clean.
>=20
> Measured on an AR9271 (ath9k_htc), where a channel change is a full chip
> reset over USB, hopping across the 13 channels in 2.4 GHz, 1000 hops:
>=20
>                   drv_config calls   median hop   p95 hop
>   before                     2006      123.5 ms    183 ms
>   after                      1006       92.0 ms    105 ms
>=20
> Delivery of injected frames to a second card was 99.1% before and 98.3%
> after (3863 and 3835 of 3900).
>=20
> Assisted-by: Claude:claude-fable-5-1
> Signed-off-by: Nerijus Bend=C5=BEi=C5=ABnas <nerijus.bendziunas@gmail.com=
>
> ---
> Changes in v2:
> - Add the Assisted-by tag.
> - Rewrite the commit message and shorten the in-code comment. No change
>   to the code.
>=20
>  net/mac80211/main.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index a59837b9f480..643d59e878c9 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -289,9 +289,12 @@ void ieee80211_emulate_remove_chanctx(struct ieee802=
11_hw *hw,
>  {
>  	struct ieee80211_local *local =3D hw_to_local(hw);
> =20
> +	/*
> +	 * No context is left, so there is nothing to configure; the next
> +	 * context sets the channel. Reconfiguring here would switch the
> +	 * driver to the default channel only to switch it again.
> +	 */

Don't leave useless LLM comments in the code - clearly that comment was
only written by the LLM because of the case you were trying to fix, it's
not really related to the code at all ...

Either way though, this is wrong - if regulatory kicks you off a channel
then we don't even allow monitor, but this change would leave the
monitor on it anyway.

johannes
