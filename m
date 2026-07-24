Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598F2224B1E
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 06:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784875849; cv=none; b=uiv7SPf9mfB3oDVOS++Jdm99p8qqunyj9dw04GuWY3DMlbVKEmwWsKrDivKGx5ifyGt+Yv2szt1mf6VG9/7+l8oyAKiaHeetUW41RqX9f27Q+oxeStUyPSBfuU+NbCwq9daJ15L1eHyYMynMFWC/8W5Hue/X3z3/q4qiGcf6DuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784875849; c=relaxed/simple;
	bh=Cq2j6nCsG1W9YHy6Es6QD3t5KZFnZu4TP62QK/ukNQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qtUXEC/HEhuffRr3Ynsj4BDNXDsVT5rwnP733hdBIn+NX0txIbdkYFlC7SV5ipLdh8d5QZ+7XZcmxfHIxhjnt0QjBE/ih3nkC7Lx/lst6ASci8x0pQd5CKHe2a9NnqzQeUuVcp6ory4oXweAUPwjogccERihUihEF7um5p1I0P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=tqfx5bxW; arc=none smtp.client-ip=217.74.67.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="tqfx5bxW"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Fri, 24 Jul 2026 08:50:40 +0200 (CEST)
Date: Fri, 24 Jul 2026 08:50:38 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] wifi: mac80211: reject station association if AP is not
 started
Message-ID: <amMLPgO8Yv1wjMGa@nr200>
References: <373210a9-4365-4cac-823a-0eec391858e7@mail.kernel.org>
 <c9fa1c083ef9878240c2ee2fb223413153d93a68.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9fa1c083ef9878240c2ee2fb223413153d93a68.camel@sipsolutions.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1784875842; bh=HaUyiyeVE8/D8M/2JyJH7aoOIeDgF0ROU13rB91Bv7w=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=tqfx5bxWFjmLF7gFIMSPUjc73EyYTmVddwyTlJuo1y1TLj5ybofbY7sfxDji2znUS
	 U0Oy1O2FYBguvXhG7qqBcCdPk+1Xd0B2cfFBaID6Vew9HKawB88hRB+s8xL0+5RVvj
	 484WK87Cc0fEcWrzkHhYCl60RolfngK6+Rp88x6o=

On lip 23, 2026 11:14, Johannes Berg wrote:
> On Thu, 2026-07-23 at 08:11 +0000, syzbot wrote:
> > From: Slawomir Stepien <sst@poczta.fm>
> 
> I'm a bit confused? Did syzbot just pick up another patch?

Hi Johannes!

No, this issue has been found by syzbot while doing fuzzing testing.

> > dereferences the NULL chanctx_conf, triggering a WARN_ON:
> 
> That can't be right?

Yeah, right. I will rephrase it in v2.

> > Fix this by rejecting the addition or modification of a station to the
> > associated state if the AP has not been started (chanctx_conf is NULL).
> 
> That's a proxy for "AP is started", but not a good one, I think we
> actually have a flag or so somewhere? Maybe even reject it in cfg80211?

I haven't seen a good place for rejection, but let me double check.

> > Exempt Multi-Link Operation (MLO) interfaces from this check, as they
> > handle chanctx_conf per-link rather than globally on the VIF.
> 
> Feels like that's only necessary because the proxy is bad.
> 
> Also maybe a similar issue arises if an MLO AP is only half-started, and
> stations are added to all links, or so?

Not sure about MLO, but your suggestion sounds logical and such case might be the same as this one.
I will take a look at this too.

-- 
Slawomir Stepien
