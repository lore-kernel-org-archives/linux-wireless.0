Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB352C1584;
	Sun,  2 Aug 2026 18:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785696772; cv=none; b=ErT9mFoCPqOnR8lZmcaNBbpMD+VL6fjN7ozXHMZZwqRu1KSzIvi3eG7ZXpBowlcP8kIeKyg0M0Y6FTTtITafu5kgW2JrGbMatqgx7qfxaMUC7YiA/hPJdu1S9XZj3elwvqV0Zzp8EqSc5B6VqV7CcezU+I+vXQ8MRC0wTELl+aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785696772; c=relaxed/simple;
	bh=kg1Ubs5hh8yagdF4ZRFnQtABqhvw1Fz3ph+iJ7/tZ3s=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jN9455qild5/Gi6kV+05pygXQBR8BvWxauJlwBQOG2xzH2BGbI7l35YahojEQZM/510PRLku2IaByfJb+UVr8OSYdVxQZ0Ae6UHgBMK4KDNdB9s/5Ii44BLfLOM//Mv/veSQ1RUc7CCr4Ohm5yezqhQqxdrP3MBhPQH3hgwCV/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=jjaCGM8z; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="jjaCGM8z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ecv3dAnjpbj95dDhT6WhWjFxzbgkCUgzqbqZU5zaHHQ=;
	t=1785696770; x=1786906370; b=jjaCGM8zibInWoAshLKc6qxte3KX295NJDhFfcMAf+GC8fy
	g6Qmrnz+ATfz0pcgQUeTW8A8wWs+OT4Ni3n2d6ejQM1PgqIW7FOSf0qa7uD5A+81CrihWSdCbv7mB
	Nxu5Zcu+LCabuF+NrWsvOP05HA5FcKzsYm4z3JSU7u4350x7eNlrmSA6ITwfFxiuR9+WssNftj1a1
	bYA9d59axzJfk9TG4NK7jtD5Hj0daWnao0Zvp/solARth7NgiEKXxzdOSTh9rqM1sxw0WHknqh0St
	Fl89dP2jfxaQrTh6Sb5cAkNF/KZOH8gKqa/Qs1lheB8g8hYluPaIB0TtqxmFHFkg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqbIl-0000000DyWI-0tHl;
	Sun, 02 Aug 2026 20:52:47 +0200
Message-ID: <35231759dc9633edf72a745d0079897c000ff5ea.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: rsi: Fix types to appease CFI
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Hansson <newbyte@postmarketos.org>, Stefan Hansson
	 <newbie13xd@gmail.com>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org
Date: Sun, 02 Aug 2026 20:52:46 +0200
In-Reply-To: <ba0fbf6a-024d-425c-aed3-ab0ee67246d4@postmarketos.org>
References: <20260802-rsi-cfi-fix-v1-1-5821d2cb54ee@postmarketos.org>
	 <a0ab921cb2172a07b37d2a221917a78ba6e14da0.camel@sipsolutions.net>
	 <ba0fbf6a-024d-425c-aed3-ab0ee67246d4@postmarketos.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Sun, 2026-08-02 at 20:40 +0200, Stefan Hansson wrote:
> Hello Johannes,
>=20
> On 02/08/2026 18:24, Johannes Berg wrote:
> > On Sun, 2026-08-02 at 14:22 +0200, Stefan Hansson wrote:
> > > Avoids errors like:
> > >=20
> > >      CFI failure at kthread+0x124/0x1cc (target: rsi_coex_scheduler_t=
hread+0x0/0x1b4 [redpine_91x]; expected type: 0x89fb613d)
> >=20
> > Yeah, well. Everyone gets _one_ warning to send patches that actually
> > build warning-free, after that I just drop them without notice...
>=20
> Could you clarify what you are referring to here? I don't get any errors=
=20
> when building after applying this patch on top of next-20260730:

Alright, so it does build, sorry. I was just looking at nipa:
https://patchwork.kernel.org/project/linux-wireless/patch/20260802-rsi-cfi-=
fix-v1-1-5821d2cb54ee@postmarketos.org/

But I see now it's just duplicating the kernel-doc issues across all the
builds ... I wasn't paying attention to _what_ it was reporting and the
kthread_complete_and_exit() use in the functions and thought it was
likely getting "control reaches end of non-void function" warnings since
you change functions to int without ever returning anything.

> If you are referring to checkpatch.pl complaining about the=20
> aforementioned error line being too long, I can wrap it if you prefer tha=
t.

Nah, that's fine, no worries.

johannes
