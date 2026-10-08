Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AD930D3ED
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 02:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791425127; cv=pass; b=UdsxXN0q/yXJpO88XusIJAdR8FM3xg327BgwgZ9No7XuVyeqNDuwnznjhL4XiEyOCSw75L67JO0euakQ/Ru6cxxYAQ/8wVMvGv/kcocdze1IaN1dkUSaRwI1D6sWv4NBXx/Z2AAnfotOi+b9RAt/vqBUfUTMvVdejr+ol6Tg0F8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791425127; c=relaxed/simple;
	bh=Ni306d2UPLub9wUBwVghGvNx0tRdsbeFxp1OD2fB2cU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qh2ldwSZ65EGPl4R0+AAelF/Y1b+mC+1F0m+58Nunx7jC5Mc4T2BZRBb2TkUd8qXWoLluO5zVyWUSdef8Jueu7MmtvqKUoCtvWjt3UHELxvnIS/yoIuSoSfMOOXAPA8QtYD06qh0UZMS5upVNBioCBCgJdhgkKs5zxFf5IiirnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rrnk92/m; arc=pass smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rrnk92/m"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-15ea896ddc8so3733392c88.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 19:05:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791425126; cv=none;
        d=google.com; s=arc-20260327;
        b=eQNB4zYL71Cygzfi2ngmarFHC45EPOhhS7LYcjN0Y7hdMHql2TCXQfqdDlwnIJBeZE
         M+6qzhSEG6TO41S0mjOmgd9XtNoRtoQPJSpzYjfBa+YDpBIMISWB6Nf0EXg1z5lWA4/i
         g2ffkQMxKxGAggaD+muLk8n1LcSXWrDwEqsVtB87C4sy867ndpQ9RAQE8irYODk61t0i
         +7h9hfAf9HUDCHNvzgddK6wpxnPPqp65pu7YsYuvJHTQfVYxYXtePtm+DMOG0gZpLoIi
         I0rI/tUtFdhm3B8dh1eJjGi5XkSqu30UnF1b/7mBHMqwuQ9AsXsk8dy/OFtRu1B9DJ3M
         rvWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L5+sxVMEc2cKh2K5I24giOZHwMBI7dDvEremqs2FRZM=;
        fh=ST4jkm+PR440HqF2VxTVw7/h6PY8uXwVvLyGhJ/z3As=;
        b=ZcO+cEeiDksj4HSk9ofhkMCxHFDdXDImwDgqA4alS+uufdmRW4GacFgEuBwhrkrrXj
         7o3pKT58PHKNqkLaIQUxW5UnrVabtA/yOJq5w1aoxW6bZvAcyuosZWvaw8gtqs8M50Nc
         Aq2kUti4KzcO2lyTc+YitqsSooBaRG1QiFdOtuNK9E2ZsZVDv+PpmKo9kLRb5ENLiHR5
         jXLWlczewiuJoqOY1G/pi2u1r9Ha3MWLpUOq80INZkLtCg/CdPvn/LcjBbIOt4KN/BZJ
         42EZpwBZ67ShlgOsjOj0Xc9jfhOlYXAv/i6+oLDk7h8n4mxptOa6LY4yDwA0Lm1NgzuT
         R0Ag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791425126; x=1792029926; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L5+sxVMEc2cKh2K5I24giOZHwMBI7dDvEremqs2FRZM=;
        b=Rrnk92/md5QEsJLlRe69xESZbSbS3PNNCYJhYKf6mrsh3LOQ+XNtRwG5Qz8PHm7Vj0
         3C4SS3xTnqtfhfyKpB3T+fZS3bAF9rxdU9feDo2Tynn3uaeC1qh/qC333fWmZywuTLu0
         OOH4lflRkYzVwuCp6HvKs/xH/s4R1DQu28DoIZUNks0rTrS89TnJHLR27jHCSuUI8+nW
         +VEneJOuPQlKWBrpsDmamwLUVZI56x9HaupyIzXmsw0lBS6TqaXQTMFfl2XaW8d3Vufc
         4TggmoHlZb/F/ACt6bbkBRzteVpDn3q1r6XZKkTeqLsuszela06pfGXAX+cV8+09VNVo
         yiLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791425126; x=1792029926;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L5+sxVMEc2cKh2K5I24giOZHwMBI7dDvEremqs2FRZM=;
        b=hV+QQyzzajbPfPN5v+nBd6UoHTQ3cfo0lo1BBnlo0HxRmcwOwHYD1Hq6SwmjvZOexx
         ycUon060t7mtYkFp4d8Sg9O3gWIsN3c/6ezCVX9cD4Lx88gPdmdJEYcsM9JWGgP7CMuP
         E8Zz4CiO+0Ewk80LSHUy6/YrIjIngmiMV2Yjf3KI8BpwDWrEw+8STi3kFmT4S7v3+Qjx
         I8tua4l3Wsvy1Hnac4NwuYcUZBpUm1iVrjiL8GcRgDJuG82357RKbUdm9ZncSkckLUn8
         3NHa+yzm1gFE7eU/dkU8TicPxW5brU8v1OqKEI2CYualKlHKWASKuru0v72JINz8gjt4
         EoFQ==
X-Forwarded-Encrypted: i=1; AKwUvBwfl7q+a5blGGNy5BcJUom5eGcnup+dx9XaJXIBoGUvIGm0xzwjdnuRMGOcgIV5zPkirPquUp3bmQVjphX3cg==@vger.kernel.org
X-Gm-Message-State: AFuF++k5/c08tTZWMYu/mBiPmJbpMGZVcyiJK3M5Wslkg2I4PHP6JIhC
	r03KNtmHOZFh8jT8cylQwAXbp/sq1gZd1n97y8C3I6e2zbGNVYGX4jWA64gZ3mEpb8bLECpOyX2
	+9WucVICRKlbv9oO8aKfmjp9ro0oy1utJtoO2LRq8dXe1WLn9b96UyNWvjZfc7w==
X-Gm-Gg: AYBFou36VELiOUcw/QMG/fdmrXKOCsPOsXdMWnO1Ou65D6SarkfNXuOv5yDI7Ha+Ue8
	RSgI+w7Cu2mghIKt1veCBFidr2MTZNesBW0/woBumJSjYJUk/ckMY8MU7tIFJjx1woj6E9b8/1R
	LFMDh81KAN1Ls5ydr1jh5pHA7z9K+psOFFEI39gpRz0GpnNIfXsRZPtsOu+mudLZOPhGLQEmcjf
	w9HI+QtYsKmWML8btZ4EEzkswWp2po/we9zPBsrsBXaS89l5cjyQFWBTQ3D3IjDWN177qoAnxTI
	JE+Pp/p02EPfFwF6Ztpf/GQ2CmDASDaa7wWiq3wEfnrTERZZhdVVyTZnO71nA9yCDPD23mRF2er
	iUGYUaATXW9OKos+1J3PvYMipYVnpA6t6XNDZGxIAghsQKwiIsf2scS/a5trVbKvUQHtUS8MX1f
	7ittAbsB2ppfVxSype2riKxHKs
X-Received: by 2002:a05:7022:f512:b0:148:4d6c:201e with SMTP id
 a92af1059eb24-16206660134mr4036329c88.23.1791425124444; Wed, 07 Oct 2026
 19:05:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007205827.467974-3-johannes@sipsolutions.net> <20261007163616.1088d364@kernel.org>
In-Reply-To: <20261007163616.1088d364@kernel.org>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 7 Oct 2026 19:05:13 -0700
X-Gm-Features: AclHuK8ZNy7OfoQWPMuSSktixGokC1G6AjDqLfquJpDruLGf4EocVEsfBjNcNRw
Message-ID: <CAAVpQUATko2Oig53r1+VHe+4Y3fFeX1xOw5RAnXtUAGwvQoB5A@mail.gmail.com>
Subject: Re: [GIT PULL] wireless-next-2026-10-07
To: Jakub Kicinski <kuba@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 7, 2026 at 4:36=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Wed,  7 Oct 2026 22:57:00 +0200 Johannes Berg wrote:
> > Nothing much going on in wireless-next. However, next time
> > I hope to land my RTNL-redux series which will (almost)
> > completely wean the wireless stack off the RTNL, except in
> > places where we need it for netdev register/unregister/etc.

That's great !

We saw a wifi driver holding RTNL long on Android.  Also,
I hope we could remove the long comment in __rtnl_unlock().

> >
> > I need to see what's going on with the per-netns mutex now,
> > can we already use that instead?

Do you mean moving net->rtnl_mutex out of Kconfig ?

Recently, I've been converting the first-class rtnetlink handlers
with dedicated locks, but others not worth the effort will simply
replace rtnl_lock() with rtnl_net_lock().

rtnl_net_lock() still acquires rtnl_lock(), but if we always compile
net->rtnl_mutex, using __rtnl_net_lock() for the latter should be
okay.


>
> That's a Kuniyuki question (cced). I've been trying to move
> HW drivers out of rtnl_lock and under netdev->lock.
> Most of the rtnl_lock contention I've seen in prod at Meta
> is in init_net

FWIW, I've still seen contention while creating/removing containers.
