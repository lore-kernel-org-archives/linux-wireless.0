Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAFA1D63F0;
	Wed,  4 Feb 2026 08:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770194200; cv=none; b=ZSu9ba/UrJR7/uxszku6wc+uSaj//YbNJe7tSotpvTMitlTuomn8+K2SzsH9m15quGXtad//Qf3O2eu7f0i3W8L/HM9IL1PJiM3pVDGmwBZfv8vpWhpOJ1E8YdGcI5KwRYI5qiLuQHxAWN1aHVz+0IVR4XHa34mCCU4RO23RvWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770194200; c=relaxed/simple;
	bh=bO4tIM5TTvyUWbeV4PrVZX6fnl3M+hk0K0pfu1y11OM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LbuqEAvsU5g0uyeS2ZBqHp/t5KAGHf50GvD1PWMxAuJe8cvSc6OmCtT4ol/OQQltJJ59izHYJFQ/M9ckJ46zkjeP02Nns/3WMsFPCl7dPlrdtXounK6qW1qXs62lfYHgQ0yK4JGN+VWxEz6Zax6vfJ2uoXVFmIbqpdM09QqCt78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Ob9A4Mov; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Ob9A4Mov"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=zFc4t2YP9piAbEtpMrzMAQaYd6CbnAPfpaHLU9/xw3M=;
	t=1770194200; x=1771403800; b=Ob9A4MovSDiJf9YCH5AOBUmCd9mRp6RkMi6Qk/zMxens8YY
	xqeohhpCRT0/KKYbp5FDIcTL+duCMKnAQsF9z9/JQ3S2h8/H8TOVXEdTiDDqGW6RjynZB4lmmqsoT
	s/s/0a/ZRL3pdusIcI/YU58eEn0xt31gggSNeCVZ+NM4EpvorMMSgfyYWfnz74rngY9YKMZZpUr8D
	2WKOWePdIaS69/BGi4PojbjKHabfL8X26p3NiOLGG1aXIfVScMX98mwjvfyo3dbHGlBqq2k6VMRPJ
	pe2QZclbhiFodAR+wk9hQ9s/4Q/a9a+ZQMCm1qjplSs51AsH2+aAsY0OuRFLUAUg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vnYND-0000000EBiF-47P4;
	Wed, 04 Feb 2026 09:36:32 +0100
Message-ID: <bc92582d5de175ec325ae53ed3fe18a5e073438b.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: nl80211: drop impossible negative band check
From: Johannes Berg <johannes@sipsolutions.net>
To: Sun Jian <sun.jian.kdev@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 04 Feb 2026 09:36:29 +0100
In-Reply-To: <20260204081821.730673-1-sun.jian.kdev@gmail.com> (sfid-20260204_091842_124304_F2AC914A)
References: <20260204081821.730673-1-sun.jian.kdev@gmail.com>
	 (sfid-20260204_091842_124304_F2AC914A)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-02-04 at 16:18 +0800, Sun Jian wrote:
> band is derived from nla_type() of a nested netlink attribute, which is
> a masked u16 value and therefore cannot be negative. Drop the dead
> "band < 0" checks and keep the upper bound validation.

I've seen this before, but I'm not really convinced it is entirely
correct. C says:

   All enumerations have an underlying type. The underlying type can be
   explicitly specified using an enum type specifier and is its fixed
   underlying type. If it is not explicitly specified, the underlying
   type is the enumeration=E2=80=99s compatible type, which is either char =
or a
   standard or extended signed or unsigned integer type.

It would thus _seem_ to be possible for an enum to generally be a signed
type, and therefore a 'signed short', and therefore an nla_type() that's
a u16 could end up with a negative value...

Am I wrong?

johannes
