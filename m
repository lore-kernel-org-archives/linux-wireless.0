Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83479246BCD;
	Fri, 17 Jul 2026 14:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298670; cv=none; b=aJuT59yPB424sGDxSByeLGZKu7o+R8M2m8qId0GTjgacDWo5JS0UJ7zb3lqphQ8km25UTUoyK4kJhpeg6eQ3qBD2wDw8BHMaURbUe+nz0LTRfJS6K1Hbtm7mP/KQtvbKMZQsj5KyXuEYRdXFXyVbkRMcoKfjtHP827wWHcFre4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298670; c=relaxed/simple;
	bh=x43WABfRrQmTgHSWxif6YQkf+OShmTXhXBvgZYTwJ+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6ftJW6Je3b0q19nyiTXQdYn/Z5DviPkAH8Dzp8dG38OpCBBOO8JgeU4vc5TeV+pSxuIDe83x+8Pi/NTUnrTbPjYZVofPFOFGyyqH1a5BCX+YJBeP/RlTipJS2sk4aecGaIknSCN40yXc/jIZjMHGLfRfERKzTfAz3Vb6/1FVbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=mkcDUMrw; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="mkcDUMrw"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id 4E87C228D5;
	Fri, 17 Jul 2026 16:31:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784298666;
	bh=OCI7dqd3heCu3mo5D7WQBBmAEYaadfOKWnanUZ0DyBg=; h=From:To:Subject;
	b=mkcDUMrwIyoZgX70TyOQrCul5D9WyijCHoXAbitsJkry9kbjE6IVPFoNIm0eSd+PT
	 T7dtrNMTUDiOg82ePKa5W0hfhoUvV1eXEKTH2MmUqPAdJQVqpofZYDMN434H7aJmg0
	 Ew9AA+wVftAC2T0Wlzh+DbvC0rB/QFC6wu6C9H7VyIjcyLZb1wfHJgTHGInCk5INLK
	 bBYg/FRiLvymI61MQml6mIQeucmHUKbJfNLvlM5yEDBeWCiZZqqNroVSlMZPAEYJN7
	 syQgGKACDiS7VgSYxTJiR4IJFQaREswsLIvGhjHvopEYAQeLAwyDxF3/52bY5EkRGy
	 azUxLfp1soxXA==
Date: Fri, 17 Jul 2026 16:31:02 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Christopher Kleiner <chris@kleiner.pro>
Cc: briannorris@chromium.org, linux-wireless@vger.kernel.org,
	francesco@dolcini.it, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mwifiex: validate HT/VHT element length before
 storing beacon IE pointers
Message-ID: <20260717143102.GA512678@francesco-nb>
References: <20260717000017.61415-1-chris@kleiner.pro>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717000017.61415-1-chris@kleiner.pro>

On Thu, Jul 16, 2026 at 08:00:17PM -0400, Christopher Kleiner wrote:
> mwifiex_update_bss_desc_with_ie() stores raw pointers into the beacon
> buffer for the HT Capability, HT Operation, VHT Capability and VHT
> Operation elements without checking that the element is long enough to
> hold the corresponding fixed-size structure. The generic IE loop only
> guarantees that the declared element length fits inside the beacon
> buffer (bytes_left >= total_ie_len); it does not guarantee that
> element_len is large enough for the struct that later consumers copy.
> 
> beacon_buf is a tight kmemdup() of the over-the-air IEs. When the
> association command is built, mwifiex_cmd_append_11n_tlv() /
> mwifiex_cmd_append_11ac_tlv() copy a fixed number of bytes from the
> stored pointers (sizeof(struct ieee80211_ht_cap) and friends). A
> malicious AP that emits a beacon or probe response ending in a
> truncated (e.g. zero-length) HT Capability element leaves bcn_ht_cap
> pointing near the end of the slab, and the subsequent copy reads out of
> bounds. The leaked bytes are placed into the association request
> transmitted back to the AP, disclosing adjacent slab memory; on
> CONFIG_KASAN / panic_on_oops kernels it is an out-of-bounds oops.
> 
> Commit 685c9b7750bf ("mwifiex: Abort at too short BSS descriptor
> element") added such length checks for the FH/DS/CF/IBSS parameter sets
> and a few other elements, but did not cover the HT/VHT capability and
> operation elements. Validate element_len against the size of the
> structure that will be consumed, mirroring those existing checks.
> 
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christopher Kleiner <chris@kleiner.pro>

Duplicate? We already have this in review https://lore.kernel.org/all/20260709100800.7026-1-doruk@0sec.ai/
