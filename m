Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B30D19EED3;
	Sun,  2 Aug 2026 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785687878; cv=none; b=fuqSCN6Y9HvylV+rdPnZaMTg6Ijf0e8F4BTTnj9eexRu64PBvQ/eUVolXdYlsRHuhTn1bkGGRJbXh0mnzsE5L2JBxCnfvEnKf34pGcp/pNO+mY3UoE4DzLFvl2NqNYV8GtSG+kfRcAOS+ujmZEYOf9aPoGh08gMrOEP/yRpwNZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785687878; c=relaxed/simple;
	bh=2N67rBdxioQDx1xaPVBbr7GvEE/HW6PQ9+tCBUaqDhI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SveCX+fnyfZ9MTFnBgXCg81no9hfEFbc23IfXM8c20INvwdEHltGqtAE+MezV9GTdhbWmKKGFbGDLeNiNZ3yJAoczPm05cDtFq1lveP4DoykMCxlZ45jQqoPsSs2T8fy1oDJJ514gpef/VHqyT4oi9Yee6jnFGz7n5sU7M9F4SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=AAy50+v4; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="AAy50+v4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=q6nZe581EnD+hfJNAceKYLHHjXCHhv/8bNGeKqtAV7o=;
	t=1785687877; x=1786897477; b=AAy50+v4ER+0JLoWBAUKkcR6Z+9xHwzTLM8Aw9oGr/ID3cJ
	MgM2sFBhxOTGc9dqhd09vyTN7zdFmkAQze1HhiD+fzGPK4YJPVCMB6jD2tvQx2Aiy8b46o/OpYR1Y
	1ey89Ce2wEJXmXnB/mPp612G83zmv+QAVieiK44T9lDzieZCcNbi2mhmhCqla/WlybSX0ixTeDEtg
	KBjniAQfY5dAU9+8b4YsvgJopcsPKu3uuic/bo2TX9GjxcVB0cljzKv3BhWQeUTm4NG9moXFqSAey
	fd56WFV/XCLsYKkbexPolieP3p4jHc/ETcOOJwd5lZZKnLDgjT5BbMYFGe9cejOw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqYzJ-0000000Dvkf-0Uh7;
	Sun, 02 Aug 2026 18:24:34 +0200
Message-ID: <a0ab921cb2172a07b37d2a221917a78ba6e14da0.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: rsi: Fix types to appease CFI
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Hansson <newbie13xd@gmail.com>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org
Cc: Stefan Hansson <newbyte@postmarketos.org>
Date: Sun, 02 Aug 2026 18:24:32 +0200
In-Reply-To: <20260802-rsi-cfi-fix-v1-1-5821d2cb54ee@postmarketos.org>
References: <20260802-rsi-cfi-fix-v1-1-5821d2cb54ee@postmarketos.org>
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

On Sun, 2026-08-02 at 14:22 +0200, Stefan Hansson wrote:
> Avoids errors like:
>=20
>     CFI failure at kthread+0x124/0x1cc (target: rsi_coex_scheduler_thread=
+0x0/0x1b4 [redpine_91x]; expected type: 0x89fb613d)

Yeah, well. Everyone gets _one_ warning to send patches that actually
build warning-free, after that I just drop them without notice...

johannes
