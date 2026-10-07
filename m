Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0034B4027;
	Wed,  7 Oct 2026 14:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791384918; cv=none; b=obcboxQkLW2phqGM2SgHap/VaCfMuWpNPZvaEr2VHR7CgoTv1xiLUWuehUJRQHumTV3HKQSi0Bun6yFu1R4PF9aDAVyWgMbACKOqZ0EburbprY9U0QF6GaHsMHVWpoWO3FlN4iPpjgs34sCY+i5bzA6XTQptierx7uO6sshoiCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791384918; c=relaxed/simple;
	bh=jRuZf2Z9vpenxDb+GYJexrqjYoXsd4bLd8+09fF67OA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rT3hg3laK9CWeH7dqPPjm04T/unBDiAnG8v246vzTIz88xX73EYPkjlGkCTZTsfT4deQt8IPgsh2wsY2QPhu3FSrsZDVb10pcL0bVZXEYwdXiXmZg18zORP3RcM3tEbyRldc+Yb8L5LUG81lCmqc+HHj16kuk1DXKCH/JckJeUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ei/vZLNJ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ei/vZLNJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=7efoYhAx0UinMkFbLmi5X6yxMmqYY3kQVGPcfxylJ5g=;
	t=1791384914; x=1792594514; b=ei/vZLNJ1qd9NalPYT4ZRmxVmMTz56qqRgmYYgdhpdpycS1
	pYdhjHXhFrTqi6orFLVcdQ/6g3eHZbYXm5acqkMhGR4UXtEMRSRtjbCk0gJiKPtGJJaK2k7TlxC6X
	Yt/B0T1mZFadoFrE7LzK4xDtn1BHy5vuKn3ve2a4lz7yU3vhyLvEZuvMQ3bqRnzoMS5AGmkWwQCHN
	zbNaBZdpeEIqm1zXYcZUCpBoSs7UnNT7dM1Rj0urzwgQBrc+bOtFmUKn4hmoQF8BAeFDwBNHBNxXn
	f1iHIo1ssoXaFNWqtJtJKuQQC3ROPql3Bun58FTBAGiuVeEWjRkoGrOkjEvAUIWw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xET30-00000008AQM-32Ya;
	Wed, 07 Oct 2026 16:55:10 +0200
Message-ID: <16aa99921c4e92e8d4da3c84aacbec2e673666aa.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: nl80211: don't WARN on a missing self-managed
 regdom
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Fran=E7ois?= Roux <franzelfranzel@gmail.com>
Cc: Diederik de Haas <diederik@cknow-tech.com>, Emmanuel Grumbach
	 <emmanuel.grumbach@intel.com>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Wed, 07 Oct 2026 16:55:09 +0200
In-Reply-To: <20261006161744.3804-1-franzelfranzel@gmail.com> (sfid-20261006_181759_239008_AC7457D2)
References: <20261006161744.3804-1-franzelfranzel@gmail.com>
	 (sfid-20261006_181759_239008_AC7457D2)
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

On Tue, 2026-10-06 at 18:17 +0200, Fran=C3=A7ois Roux wrote:
> nl80211_get_reg_do() has a WARN_ON() for a self-managed wiphy without a
> private regdomain. Userspace can trigger it with a plain
> NL80211_CMD_GET_REG request.
>=20
> Drivers can register such a wiphy first and set its regdomain later.
> ath12k, for example, calls ieee80211_register_hw() and only then applies
> the regdomain with ath12k_regd_update(). iwd queries the regdomain of a
> new wiphy as soon as it shows up, so it can hit that window at boot:
>=20
>   WARNING: net/wireless/nl80211.c:10828 at nl80211_get_reg_do+0x1d0/0x1fc=
 [cfg80211], CPU#5: iwd/721

I'm not a fan of this, I think the drivers should have the regdom ready.

> The same trace has been reported with an Intel BE200 (iwlwifi).

I _thought_ we fixed that issue.

Anyway I think we need to fix the bugs, not paper over them. If it comes
to it we can even put a WARN_ON there to reject wiphy registration w/o a
regdomain. There should be one. As it is, iwd will get empty data or
something, that makes no sense.

johannes
