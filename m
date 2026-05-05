Received: from mail-244119.protonmail.ch (mail-244119.protonmail.ch [109.224.244.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEB13DDDD1
	for <linux-wireless@vger.kernel.org>; Tue,  5 May 2026 16:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778000048; cv=none; b=neuBRsS3XvWUQk7C+RQt7LBN5sNkkIOtLyoUHi6bCDmdD+REatOIcedh38MTzq0aUJqA3zqq1BHSmI75TTfy98gkdi2ioiaQbi1DAuYPG/bZwr5MDqz2FCDNBtHP6bTBoiMlvVUrK505gbwXgE0SzO9kJJqNlMx11+UwLHaqAHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778000048; c=relaxed/simple;
	bh=RgjykZJQtq/5oxPuYAxsDhObBg9LJKnrRy9mZLWFBgU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GbCdmtx9jl8PAC4u8Y56fwMfPI2PtKIrMp3g7cZm0Mjvybg5OLprErwG6IWrIx84nP0QgxtuIK5vvgiEFPHXTjDSCfbebKTycXp8Kw+ihOzJIjedbJLxjuXxE27CquigR/6P+rQ/C9/dop/9JHOukoxi7/AS/mcHqU5W6+/7aos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=met-dubbel-l.nl; spf=pass smtp.mailfrom=met-dubbel-l.nl; dkim=pass (2048-bit key) header.d=met-dubbel-l.nl header.i=@met-dubbel-l.nl header.b=NYGi0P8J; arc=none smtp.client-ip=109.224.244.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=met-dubbel-l.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=met-dubbel-l.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=met-dubbel-l.nl header.i=@met-dubbel-l.nl header.b="NYGi0P8J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=met-dubbel-l.nl;
	s=protonmail; t=1778000032; x=1778259232;
	bh=RgjykZJQtq/5oxPuYAxsDhObBg9LJKnrRy9mZLWFBgU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=NYGi0P8JMu7RSnZSF9MAiAEV762qY3ETuy0Aj/z8OI7oPKGqCMa+jKmTftvQtknBe
	 /wLVfaVnZBrrrZibS2R5+jl2VsUbfwvfFrhgGLMYqV11/MW14iIWVwccjVuPDWqrZc
	 DZ01adqNrQ+1LvZ9UVoHtdI6hYvUwssZWYy8N+zUjU/+o1Hgn+trCrEfxFHopMKIlG
	 66IfO7+puOwy21lC9u/OtKDN1+vnbs+6rc2N1sGxF0a55uqhwooEg5RWqVIWM/xoHr
	 BWWprImUW2baaiEux5W09xrJ9Ol1aq+RMdGm/xkbQWueSIuoc8XGf73ITHo1i2QKlU
	 T6MBF6RKSw2mg==
Date: Tue, 05 May 2026 16:53:46 +0000
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
From: Willmar Knikker <willmar@met-dubbel-l.nl>
Cc: jjohnson@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: ath11k: fix use after free in ath11k_dp_rx_msdu_coalesce.
Message-ID: <20260505180437.73b03be9@WillmarsWorkFidge>
In-Reply-To: <7d3c5eae-233a-4c31-b64e-70f0afe74da6@oss.qualcomm.com>
References: <20260505143025.234292-1-willmar@met-dubbel-l.nl> <7d3c5eae-233a-4c31-b64e-70f0afe74da6@oss.qualcomm.com>
Feedback-ID: 179140708:user:proton
X-Pm-Message-ID: 9691e8226cd1b459a1f5c5de37cc561a41464191
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 05 May 2026 08:08:48 -0700
"Jeff Johnson" <jeff.johnson@oss.qualcomm.com> wrote:

>=20
> rather than repeating code imo it would be "better" to cache the flag bef=
ore
> freeing and then test the cached flag.
>=20
> however as you note this proposed logic matches the logic already present=
 in
> the "Free up all buffers of the MSDU" portion of the function, so from th=
at
> perspective the proposal is consistent with that logic.
>=20
> let's see if anyone else has an opinion...
>=20
> /jeff

imo, i would agree that would be cleaner.
But as this is my first patch i did not want to make to big of a change
so reusing the pattern from above felt te safest.

> This issue is present since day 1...
>=20
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")

Should i make v2 commit to add that tag?=20

Thanks for taking the time.

=09--- Willmar K.

