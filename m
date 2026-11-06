Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.21.23.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926361;
	b=go7ZvAG5kuR+RUxuTptdJvnxSBHTdk4gfAGBE8uWjLivyHN1MjmxDJQ5DSEXFWC/TuvB
	 W7DNa/lQ8YaIEN08G+PycLrKc/54n5qxviRzPyV6SsgSTb7Gf2uTrbVKQifRmBDXfRqjQ
	 lM2RAguZHTK/LlOSHGwZZLJcZlqxrFyeUUuirKkmt6+hjV2rXFHKLDvZf1Zp6V4E8Cp6G
	 +WPsJtgf3qgstw0GRIMVUrPQjlFbGXBe06fAWM+zHd2JXhtjDMH9+s4db2f3BZaSEdFk6
	 pyAs4LezbId+SAAIw+cISOLKG+OybXSMngP3ZSdDeoxV8K9S6EWLU6wve3oIFs4VObQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926361;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Message-ID:Subject:From:To:Cc:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:Date:MIME-Version:User-Agent;
	bh=L2iRF38Eeq77EXZtj5bywGAvf0gLjK4tU0zN6pMilL4=;
	b=TDEa8RUcsWCVwuKnMBD9gqn8iD1ZexITyEGDtzwYb0TKi+3chTJU1Q8k2CIDIq8187ld
	 yHF9LX4DclfpcZMpXPY5KIpj0p4dM0qPu/Igx7xLjJ67qhxZuCjkPq6abXzB8amS2Xk5k
	 3WiTdKijqPBM4o4glYkVPCF4bSt4v0agE9YPcS01G2sK0lHc1Z2TPM9TTdRlKyzZA4yC1
	 FLNn+sOrL0BYjY31FmXP3BJtTHwivimLtL46qmJ/e3Ux9wxOFJ5iUq1RYGVo9Q265xir9
	 ebkywqyvVJ8i44sFCtYpmOnZt0MboX344NWNivh9L5ti6yC18TLk85ZLWlr+zjPVhBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=disroot.org;
	spf=pass smtp.mailfrom=disroot.org;
	dkim=pass header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=bADB4pXv;
	arc=none smtp.remote-ip=178.21.23.139
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCFD606A31B
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 00:52:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DCFD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=bADB4pXv
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 3774980A47;
	Fri, 06 Nov 2026 01:52:32 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id MZueTc91sEOk; Fri,  6 Nov 2026 01:52:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1793926351; bh=L2iRF38Eeq77EXZtj5bywGAvf0gLjK4tU0zN6pMilL4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=bADB4pXvqpKpc9Wl4Z4KJxDdsnxbsPyEcf2+G3vue229AEXRJigIhH3bmBKA06oZ3
	 4Tmh294jZWuP0LNx8nq/TNRlk3qdvW2ssQ6b1eFjCw8OW9CxF67ePc6nmFxcDc2mj4
	 g9OTdO+xA66iA5TVPcd0nPqCqsFNlnEyzpVWn57JXgEzDRbVqI5tkm77f4xGd5yapr
	 +xQbKkRiIrjCjWJye3T42OORjDmXHVHutLuw5upHN50hnjGz7vE0mfMPRGg8t7rkCq
	 Q0PNtr38AZFgytLiWrSUQvxBXTVGTOjtaunEEY0e+TleT7AmDom+Yz+ixGJOe6Z4Lj
	 ssUeMzKTRye/A==
Message-ID: <4d72ef2c4f12595c629b8ddcd46f6f7b379bb576.camel@disroot.org>
Subject: Re: [PATCH wireless-next] wifi: mac80211: mesh: notify driver of
 peer capability changes
From: Florian Maurer <fmaurer@disroot.org>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: linux-wireless@vger.kernel.org, Johannes Berg
 <johannes@sipsolutions.net>
In-Reply-To: <26af137a-e2f4-4b96-b72c-1e95ffa9dddf@tu-dortmund.de>
References: <20261101130636.1867958-1-fmaurer@disroot.org>
	 <26af137a-e2f4-4b96-b72c-1e95ffa9dddf@tu-dortmund.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:52:29 +0100
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Evolution 3.56.2-0+deb13u1 

Hi Simon,

On Sun, 2026-11-01 at 16:24 +0100, Simon Schippers wrote:
> On 11/1/26 14:06, Florian Maurer wrote:
> > This touches the same FIXME as Simon's RFC [1], but addresses a
> > different case: a peer whose capabilities change between peerings.
> > It does not change anything for an established peer, so it does not
> > help when a peer comes back with the same capabilities.
>=20
> Thanks for your work! I think I ran into a similar issue while
> experimenting with changing bandwidth live via iw. Your change looks
> good to me.

Thanks, would you be willing to add a Reviewed-by on the patch?

> My patch is more of an (ugly) workaround calling
> rate_control_rate_init() on every beacon, which fixed my case of a
> peer that temporarily went out of range and came back with the wrong
> MCS still selected.
> I'd still like to find a proper fix for that case. I'm not sure
> whether this is the right place for it, or whether it belongs in the
> rate control algorithm itself.

From reading the code, rate_control_rate_init() returns early when
there is no rate control algorithm in the host. Your RFC mentions
ath10k, which picks its rates in firmware, so I don't see how your
current workaround could change anything there. I haven't tested this
on ath10k though, so I may be missing something.

Regards
Florian
