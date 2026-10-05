Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1110947F780
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 13:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791208387; cv=none; b=kaTnyv1BQauIGSvs749DhKXivrmVqOs2fio4OIXNMAuDJ3eWYrrx0H8CbyPHV0M7Ci/QHBR8d03LiwQpCZHuNMHOwuaBSNqsPhvEENj4xK4+LG4NYAtv07TE3KUq9elrVX73Fy+ZDdy7DiA4aqlYmkPWSWptDK8rZOURP0k1Bd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791208387; c=relaxed/simple;
	bh=upvw4IDjgA8RDPA6jQW3ut6ymG7dgerGoYHRrwLeE4Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y0IpYX9ZhyuZOe9ahZ2K8wtITFB4rzJBRePHaeTUDEctDGcJ3kkp8ZU/BsPsz97sCHY4ZXKi/Y2YTGhk52nGfVuDgdJqOlSZCi/dOhqI+2PCuU8vkwXHlNAydCWzEglOpBW+LFkIFYf1Hf/bruQMu3bNfYkeJUC/kd6qN0DToiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rN9fw/ns; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rN9fw/ns"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=upvw4IDjgA8RDPA6jQW3ut6ymG7dgerGoYHRrwLeE4Y=;
	t=1791208386; x=1792417986; b=rN9fw/nsDelaVR2b789DSexdwHVqY6cMoM5AzzhpRloa1kN
	pVePTTjJoNjMjCSGts58taMJYxoxtNGZOLQsfKrrxnip+pzQkNPTdKqZJEMMyEW5Sr20vRispEuDN
	WY+Pw8+I5vfxeXUfL89FWOg4swwj9Z5vuw+uLx99p4HxB+okuAX+QYD+WW8vHop5KTOC2PwW5Cl3W
	nMklZ8SG7yRjYl1lU1BTjtDSqVyOPbevZfkVXQ1YmfNjfbPX1FxeTcmd8foOjxUhW3BzYTG6Vfbke
	L2n4ZSHCtQMqukmihtjabKRdL63flvG2nsgSvDZZ5dwIOfgi8NEiF9cdX0BWhHdA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDj7l-00000005MVC-3WEb;
	Mon, 05 Oct 2026 15:53:02 +0200
Message-ID: <fecc3de9ceec2ca6dbd49194c1963cc3456fe566.camel@sipsolutions.net>
Subject: Re: [PATCH RFC wireless-next] wifi: mac80211: correct rx freq
 handling for S1G
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: linux-wireless@vger.kernel.org, benjamin.berg@intel.com, 
	arien.judge@morsemicro.com
Date: Mon, 05 Oct 2026 15:53:01 +0200
In-Reply-To: <yobzz5gqn2mb2mogqlxmwrilrzp5orz7up656p7zgvjukfp4jy@kv4f2szn2gkl> (sfid-20261002_115454_129599_D74A6614)
References: <20261002072954.1168872-1-lachlan.hodges@morsemicro.com>
	 <640a58333ee31c09703cf6f591d96933374093df.camel@sipsolutions.net>
	 <yobzz5gqn2mb2mogqlxmwrilrzp5orz7up656p7zgvjukfp4jy@kv4f2szn2gkl>
	 (sfid-20261002_115454_129599_D74A6614)
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

On Fri, 2026-10-02 at 19:54 +1000, Lachlan Hodges wrote:
> >=20
> > > =C2=A0=C2=A0=C2=A0For
> > > =C2=A0=C2=A0=C2=A0management frames obviously makes sense but for dat=
a frames
> > > =C2=A0=C2=A0=C2=A0sent on a wider channel wouldn't this be set to the=
 operating
> > > =C2=A0=C2=A0=C2=A0channel? Especially for i.e sniffer? The mm81x driv=
er reports
> > > =C2=A0=C2=A0=C2=A0it like this but maybe it should just report the co=
ntrol channel?
> >=20
> > So .. are you saying you always report the _overall_ center frequency,
> > even for 4/8/16 MHz widths, or just for 1 MHz vs 2 MHz primary?
>=20
> Yes, our firmware reports the frame at the overall center frequency,
> even for 4/8/16 MHz widths. Looking at our out of tree shim driver
> (5G mapping) it does the same thing i.e report the center frequency
> of 40/80/160 channel which is probably why mm81x does this.

I guess that makes some sense.

> Anyways this is not really a big deal knowing that we can just
> override it with the 1MHz control channel.

Sure, but should you?

> > I note that even S1G radiotap didn't really specify where the channel
> > is: https://radiotap.org/fields/S1G, so I'm not sure it can even report
> > everything correctly? The "Channel" field can't even cover the 1/2 MHz
> > centers.
>=20
> Yea this is on the TODO list.. Once initial monitor mode support lands,
> which I was going to send today but this bug has appeared, then we'll
> be fixing up the radiotap standard to better convey everything.

:)

> > So I think in some way this is almost more of a question of what you
> > want/need for radiotap than anything else.
>=20
> So another question then, Im looking at a poorly sourced 802.11ac
> wireshark capture and in the radiotap header it has:
>=20
> 802.11 radio information
> =C2=A0=C2=A0=C2=A0=C2=A0PHY type: 802.11ac (VHT) (8)
> =C2=A0=C2=A0=C2=A0=C2=A0Short GI: False
> =C2=A0=C2=A0=C2=A0=C2=A0Bandwidth: 80 MHz (4)
> =C2=A0=C2=A0=C2=A0=C2=A0TXOP_PS_NOT_ALLOWED: False
> =C2=A0=C2=A0=C2=A0=C2=A0User 0: MCS 7
> =C2=A0=C2=A0=C2=A0=C2=A0Data rate: 292.5 Mb/s
> =C2=A0=C2=A0=C2=A0=C2=A0Channel: 36
> =C2=A0=C2=A0=C2=A0=C2=A0Frequency: 5180MHz
> =C2=A0=C2=A0=C2=A0=C2=A0Signal strength (dBm): -40 dBm
> =C2=A0=C2=A0=C2=A0=C2=A0Noise level (dBm): -96 dBm
> =C2=A0=C2=A0=C2=A0=C2=A0Signal/noise ratio (dB): 56 dB
> =C2=A0=C2=A0=C2=A0=C2=A0TSF timestamp: 1911262072856970
> =C2=A0=C2=A0=C2=A0=C2=A0[Duration: 53=C2=B5s]
>=20
> Where this is just a QoS data frame.. channel 36 is a 20MHz control
> channel @ 5180MHz and a width of 80MHz. I am assuming then, that if
> we were to follow this (as mentioned above) in the radiotap portion
> it would show as the 1MHz control (for channel + freq) and the width
> being the operating 4/8/.. ?

I don't know - I believe that "802.11 radio information" is synthesised
by wireshark from the other fields. It'd have to actually implement that
first, presumably by parsing some S1G data.

But once that's there I guess yes, that's what it'd show. You could also
just have it synthesise it differently I guess, or take only things from
some (extended) S1G field, or ... any number of things?

> Anyways, it seems like a small patch to handle freq_offset and then
> just changing the driver to report the 1MHz primary should hopefully
> fix all this up so Ill send that once I confirm.

If that's OK then I guess might be simplest overall.

johannes
