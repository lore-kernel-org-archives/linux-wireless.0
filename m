Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D48412276
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 07:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790927901; cv=none; b=hIKZ+d/TkQF7JJB1GAZHbGVJgPON1Fg+qNxhmwub5pUoWzX0pvnpNwNA6J73/LfMjByKWPAZeGUkqtfAiyeyBVUyzJTKlI8r3Pp0eUUcHMhPuJKSUv4K7aUt9raeO94Ats+/1gXnjxanpE2eDBmAE/uPM+5mMQWUSsfdROZjWds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790927901; c=relaxed/simple;
	bh=/lEAsUsnPRS7xgWTIL9VfW/Bo7Xb8ZWtLL15B5jQZAk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ClOwD0XODKLdWkunJF3AeLj+OcRmvciHTfsZt02KvPv9xFFzqgotCwuuxBMiWdGDibF7LHjPDURk5YZI3tRn1AGy3LDuciryhcfk7AISHfpKxZxU/nDXfK8Lu5GYlW9Sr/tm9N1YNTGLuLixl5tyfRal/z5w7HXxgtGpdDucDu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=v3yBzfvm; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="v3yBzfvm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=LOKefFY2MChfMJpTnddNGPyuhNGmo/Fdb7YT8hBmCW8=;
	t=1790927899; x=1792137499; b=v3yBzfvmLVASjOxFYD2+nWs08XepRUiJOtdOiYZDeoOR9+v
	c5hfi4aKsQ2Y2f/m6aAo14EmiHi9lOFI1AoOVkFFUdAuy+SgmMh4ueU8/EUybsefvN0Q3AT4Vru7v
	4nItawTJAdJIv/IllK/3W03q/3D3TZF5+zxmG34Dea2AAs1DIrwNkpILemnm/FKbkTWPooHVzkNAN
	zQj7gd/UB4cKW26e4v8nM7zpDyMXLeENZJJupi2RDoR49BxBgtYmVAh6nsFfASatWMOBrOCUzumJ+
	sqXy9sJl5lxsl5vsnOPEG+D7KGMlPaX8Os0q3IhWx5GAt0/IZGsezKM1nEV7HkcA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCY9j-00000001HbN-1ZLi;
	Fri, 02 Oct 2026 09:58:11 +0200
Message-ID: <640a58333ee31c09703cf6f591d96933374093df.camel@sipsolutions.net>
Subject: Re: [PATCH RFC wireless-next] wifi: mac80211: correct rx freq
 handling for S1G
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: linux-wireless@vger.kernel.org, benjamin.berg@intel.com, 
	arien.judge@morsemicro.com
Date: Fri, 02 Oct 2026 09:58:10 +0200
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
> 6d531b9af16e ("wifi: mac80211: rework RX packet handling") reworked
> Rx frame handling with a specific focus on MLD, but it also introduced
> some changes for non-MLD interfaces. Previously when a station was
> looked up (either because the driver did not pass one or handling
> a management frame) it was done via hdr->addr2 and that was it. Now
> the received frames frequency is validated against the links
> control channel alongside the station lookup.

No surprise, I guess, but sorry.

> S1G has a unique feature where the control or primary channel can
> either be 1MHz or 2MHz. However there is _always_ a 1MHz primary.
> S1G drivers advertise these 1MHz primaries but it means if a 2MHz
> primary is used the control channel inside the chandef may not be
> the channel used to pass management frames.

Yeah, so I think part of this is also related to how we through the 1
MHz vs. 2 MHz in S1G. I feel like the spec thinks this differently,
while in the chandef we basically think it almost as if 2 MHz was
equivalent to 40 MHz HT, combined out of two 1 MHz channels, except we
added the flag:

 * @s1g_primary_2mhz: Indicates if the control channel pointed to
 *      by 'chan' exists as a 1MHz primary subchannel within an
 *      S1G 2MHz primary channel.

To also answer your question first:

> is rx_status->freq always meant to be the control channel?=20

For HT/..., yes, that's how it works. Not sure that's really *by design*
as much as by historical accident, but I don't think we will (even can)
change it now.

In some way it makes sense though because otherwise you'd see this
flicker around all the time as frames with different bandwidths are
transmitted, which would be strange too in a single BSS.

Note it also affects how radiotap is reported, so S1G might be in the
opposite camp now, wanting to report the 2 MHz channel center frequency?

>    For
>    management frames obviously makes sense but for data frames
>    sent on a wider channel wouldn't this be set to the operating
>    channel? Especially for i.e sniffer? The mm81x driver reports
>    it like this but maybe it should just report the control channel?

So .. are you saying you always report the _overall_ center frequency,
even for 4/8/16 MHz widths, or just for 1 MHz vs 2 MHz primary?

I note that even S1G radiotap didn't really specify where the channel
is: https://radiotap.org/fields/S1G, so I'm not sure it can even report
everything correctly? The "Channel" field can't even cover the 1/2 MHz
centers.

So I think in some way this is almost more of a question of what you
want/need for radiotap than anything else.

Internally, reporting just the (1 MHz) "chandef primary" would be
matching the HT/... behaviour.

> As a result, the rework
> causes the following two issues on an S1G link:
>=20
> 1. When data frames are passed to mac80211 without a station (for
>    example using ieee80211_rx_ni()) the frames rx status frequency
>    is compared against the 1MHz control frequency used by the link
>    via ieee80211_rx_valid_freq. Since the rx status reported is of
>    the center frequency of transmission (i.e either the operating
>    channel or the 2MHz primary in the case of multicast/EAPOL etc.)
>    these frames are _all_ dropped.

Of course if you're using rx_ni() now then you could possibly arrange to
call ieee80211_rx_napi(hw, link_sta, skb, NULL) with the correct station
looked up beforehand, and entirely bypass the question, doing whatever
you want with the frequency?

johannes
