Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B8C38E5C5
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 07:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791272675; cv=none; b=lsqvqRn6h4TXYYqnDSASAABFZ/um8W8JTEOuZSDjC4bcuGbiJSy4yNVvmAphNbxy7B1YZPGKJjES5UheUuIYuWpD3WOtd6zhXtxzTRoPFUwK6clwkjXpe+dYAjD5dx6z4vvaFDlvHoXgB4RYGTjbr98hGJ6tfY5AEEeF2KHk/+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791272675; c=relaxed/simple;
	bh=MOIOsCArn9K3dbCms5X/hAI+3yYgK1ixZRs4KbK9sCA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=erp+ItvgIRasiJNHnBXVLxAdUAEEYKhyBeE/eHEbBJTTZMRbT/FK1T5IVzJlqjLvQ3TnZN4JdUSkQL1S1ShH5AwoSeiwecyc6iw+B6qgwvseLlSQv1dDIntTlBrTAh2bI+3RolYbs3RRxEHUwjQqAPY/7yTUcUs2xB8Jvc6Et64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=F428oBqr; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="F428oBqr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=sg0+2jbOZFQyKWVMb7LUBe+KQuAavnM8Q2Kwdmu605c=;
	t=1791272673; x=1792482273; b=F428oBqr0eqQfDGiR46PvKqCaBa89Kwmfw3KO5isAFe+hmi
	q08LTERTaWR8pzjz0OkNzQ5DotGF7yFPrS6oMRqGgj3ChvfwxjJ4JzKUK3i96IgwKK1U+bv7F4008
	c1Ck3UnhoYLsfjgStyVicNIPQv36e66EEPmrdnL0NGchmfoGNxX/NEpjYbferjacB6Ki0ZsiK3V1O
	YSF2D+YZ5CJyon2Zafrt04xpfKPM0aWc82WPKDttEOzcnEv6zInFogO+dxo810RcvzQLDvx7/7u8X
	fw+OhqWfyH2fw1TjjRBBzeamHYnAiuioP7B5p56bFaUWGhBF4mEtBcyqsXH84aiA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDzqf-00000006Q8L-2VX9;
	Tue, 06 Oct 2026 09:44:30 +0200
Message-ID: <da737a625b8ee416ffcaea37ab9c84e705634c4c.camel@sipsolutions.net>
Subject: Re: [PATCH RFC wireless-next] wifi: mac80211: correct rx freq
 handling for S1G
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: linux-wireless@vger.kernel.org, benjamin.berg@intel.com, 
	arien.judge@morsemicro.com
Date: Tue, 06 Oct 2026 09:44:28 +0200
In-Reply-To: <20261002072954.1168872-1-lachlan.hodges@morsemicro.com> (sfid-20261002_093135_409872_DAA7268A)
References: <20261002072954.1168872-1-lachlan.hodges@morsemicro.com>
	 (sfid-20261002_093135_409872_DAA7268A)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-10-02 at 17:29 +1000, Lachlan Hodges wrote:
>=20
> +++ b/include/net/mac80211.h
> @@ -1741,6 +1741,8 @@ enum mac80211_rx_encoding {
>   * @freq: frequency the radio was tuned to when receiving this frame, in=
 MHz
>   *	This field must be set for management frames, but isn't strictly need=
ed
>   *	for data (other) frames - for those it only affects radiotap reportin=
g.
> + *	For S1G, when operating on a 2MHz primary channel, this may be the
> + *	center frequency of the 2MHz primary rather than the 1MHz primary.

Should it really say "may be"? Vs. something more specific about being
1/2 MHz center depending on how it was transmitted/received?

> -static bool ieee80211_rx_valid_freq(int freq, struct ieee80211_link_data=
 *link)
> +bool __ieee80211_rx_valid_freq(struct wiphy *wiphy,
> +			       struct ieee80211_rx_status *status,
> +			       const struct cfg80211_chan_def *chandef)
> +{
> +	u32 pri_khz =3D ieee80211_channel_to_khz(chandef->chan);
> +	u32 rx_khz =3D ieee80211_rx_status_to_khz(status);
> +	struct ieee80211_channel *sibling;
> +
> +	if (rx_khz =3D=3D pri_khz)
> +		return true;

This is also in the original, but now it's called more I think, might
make sense to check them before conversion to kHz? But not sure what the
compiler would do here for the *1000.

> +	/* Any non-S1G case from here is not a valid freq */
> +	if (!cfg80211_chandef_is_s1g(chandef))
> +		return false;
> +
> +	if (!chandef->s1g_primary_2mhz)
> +		return false;
> +
> +	/*
> +	 * Find the sibling 1MHz channel of the 2MHz primary to calculate
> +	 * the 2MHz primary center frequency.
> +	 */
> +	sibling =3D cfg80211_s1g_get_primary_sibling(wiphy, chandef);
> +	if (!sibling)
> +		return false;
> +
> +	return rx_khz =3D=3D (pri_khz + ieee80211_channel_to_khz(sibling)) / 2;


All of this gets really complex, IMHO.

Maybe here's another thought: we have

	u16 freq: 13, freq_offset: 1;

What if we make that

	u16 freq: 13, freq_offset: 1,
	    s1g_width_2mhz: 1;

(or something, handwaving about the name) and ask that the driver puts
the 1 MHz center frequency into freq/_offset (so mac80211's comparison
on RX is just =3D=3D), but we can still get back the right frequency to
report further out (scan, radiotap) again? Or use two bits (above/below)
then we don't even need to have the sibling channel lookup (we'd just
believe the driver).

I don't know, I'm just thinking out loud, but I feel like maybe that'd
make it more likely we don't break it (again) when we have HT/VHT/etc.
in mind?

johannes
