Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431DD48820E
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 12:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791547952; cv=none; b=LzW9AikJ/ElZIH7rVn1BtzaqEwUh9GOWR6dkf/bTBqK2EDY82k0Yv+HgGAV14h9YxY1jUf+6mLmclqNX5b1tOFjUNMWKuAvMrfw2qMkvYClQAzVZM9lih2fk/xel/XXAGz8eZK2IVkOkh/KzmxUsv8A7gyVLxtwIeetVRD02Wtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791547952; c=relaxed/simple;
	bh=z2Xci7ePKeBsSgRXq4c9o8tM/YEe7t8RHCiIjm8LIBs=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=E06FruVo6QF2cqHsVSNmKPSmDQR4dWbkXc7J0e/8wAKrUR+qWheS56skRQqf3XKzMTP4kU03Ys8VCX1nucRKROfgfIJgHgR/OGf7EIC/KJfQTZ/Dpmn7v5IKpXYWQ2utodbbgrHJHdxmpvdYO0AXcIs1XuiGjuoxd/CU161sH98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y2PaYntD; arc=none smtp.client-ip=91.218.175.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y2PaYntD"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=z2Xci7ePKeBsSgRXq4c9o8tM/YEe7t8RHCiIjm8LIBs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791547941; v=1; x=1792152741;
 b=Y2PaYntDO9wdyA2teVqmP9hd4+DR5WsoTQj8spK0PnAA0GvClZd4aKU5dx8SqXY2YEUcPstH
 yxK+Ru3yDB4BFOfEvydAqvfZPwpcTRvN8pXfAYxHsaO4dYQ69Oy82F7tiLxH1ZGjt8hoEUe1jYH
 xCvg0TArUs98NAVQOwJJgNS4=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 58b9d102c4600c1e;
	Fri, 09 Oct 2026 12:12:21 +0000
X-Mizu-Trace-ID: 58b9d102c4600c1e
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 Oct 2026 14:12:20 +0200
Message-Id: <DM0AQQ0P3D7K.1SIDA6SAMC3L2@linux.dev>
Cc: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Kalle
 Valo" <kvalo@kernel.org>, "Brian Norris" <briannorris@chromium.org>
Subject: Re: [PATCH wireless 1/2] wifi: rtw88: program the channel when the
 device is started
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Jeremy Fareau" <jeremy.fareau@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20261007091225.413-1-jeremy.fareau@gmail.com>
 <20261007091225.413-2-jeremy.fareau@gmail.com>
In-Reply-To: <20261007091225.413-2-jeremy.fareau@gmail.com>

On Wed Oct 7, 2026 at 11:12 AM CEST, Jeremy Fareau wrote:
> The chip is reset by power_off()/power_on(), but mac80211 only calls
> ieee80211_ops::config() when its own channel state changes.  After a
> stop/start cycle, such as
>
>     ip link set <dev> down
>     ip link set <dev> up
>

I don't think there is need to say what stop/start cycle is in commit
message.

> the channel is unchanged from mac80211's point of view, so the radio is
> never reprogrammed.  The device then listens on whatever channel the
> hardware came up on while iw reports the configured one, and receives
> almost nothing.
>
> Observed with an RTL8814AU (ALFA AWUS1900) in monitor mode on an
> aarch64 host.  A 25 s capture on channel 6 after a down/up cycle yields
> 3 frames, and 431 frames as soon as any real channel change is
> requested.  An RTL8812AU (Linksys WUSB6300) on the same host, the same
> channel and the same second yields 2438 frames.
>
> Program the channel in rtw_ops_start(), like rtw_ips_pwr_up() already
> does when leaving IPS.
>
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Assisted-by: LLM
> Signed-off-by: Jeremy Fareau <jeremy.fareau@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/mac80211.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/=
wireless/realtek/rtw88/mac80211.c
> index b01b98d24b0a..827f38390969 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -57,6 +57,17 @@ static int rtw_ops_start(struct ieee80211_hw *hw)
> =20
>  	mutex_lock(&rtwdev->mutex);
>  	ret =3D rtw_core_start(rtwdev);
> +
> +	/* The chip is reset by power_off()/power_on(), but mac80211 only calls
> +	 * ieee80211_ops::config() when its own channel state changes. After a
> +	 * stop/start cycle the channel is unchanged from mac80211's point of
> +	 * view, so the radio would never be reprogrammed and the device would
> +	 * receive nothing. Program it here, like rtw_ips_pwr_up() already does
> +	 * when leaving IPS.
> +	 */

We don't use that comment style anymore. Change it to:

/*
 * text
 * text
 */

Also that comment is rather extensive, maybe shorten it to something
like:

/*
 * The chip is reset by power_off() and power_on(), but mac80211 won't
 * call config() after stop/start since its channel state is unchanged.
 * Reprogram the channel here, as rtw_ips_pwr_up() does.
 */

> +	if (!ret && hw->conf.chandef.chan)
> +		rtw_set_channel(rtwdev);
> +
>  	mutex_unlock(&rtwdev->mutex);
> =20
>  	return ret;

Besides that I noticed that there are many double spaces after
punctuation in commit message, so please fix that too. And
should this cc stable?

Best regards,
Luka Gejak
