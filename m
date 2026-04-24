Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D553D6494;
	Fri, 24 Apr 2026 13:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038957; cv=none; b=L9fXET5kEojQWFeT5OIxrUneYEu1+iU0gp5O0q2s6N+ss1XacBeXkDxSj9dkp83tWU0HoGo/RtofYzioX5UigvIyRxhS3reqS8HcM06Q+C//nlD/egqgodOdqn4psH4v9UE63ML3mre15TDa0GSdvY+yRFN+iw3hZix1vzyycEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038957; c=relaxed/simple;
	bh=KIOumPPfyu6yk1E11eobp+/yQImq5ZMrtuLQbYTpbWg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KBmWAWX2V7pB07hB5a5d5+PW0CblEBNvzQmPx58/mTTT47XA8dsRcZd1VQAj+2Mw7tQAq6/I4XFbRE0DavqKm8hLCMdFPdi3cPhb7osE1b4gIJKEU6Dkur19LlE0GYF4wd5H/InjUGhJ6YlcYC1EXi83DnyspmVFbXVeMLgMbcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ne0MDl6Y; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ne0MDl6Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=KIOumPPfyu6yk1E11eobp+/yQImq5ZMrtuLQbYTpbWg=;
	t=1777038953; x=1778248553; b=ne0MDl6YNHkbNTEx18nSiYon5yVqqe17SpU7X8oajDIXzeU
	8BqMqFrfD0D5HFKszOxsbxGsobz1jJ7bdfBtWtWBNx5OmgxA2TUkEQG3dUD5OjVo83lchHou64i3C
	PR8Ph4+J8XinYQcBo77P2Z76ekk5MpzUtoCiTcEG4oN+4n1ep4oCFj1ibscSWFX07OC6ZYgPGe9tm
	zsXZJTy8cAj8+dDpHKzfG1flp7GFgU8LJmB9BWGhZQM7XxRdu2p9YPs11iv2U+u1VHSbD5810NMt7
	scw5u+d4UegM3fbM/+jpAitm5es8uaZ6IqstEyPMf0Ak9Dfjr61SJAorwJkN4GQw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wGH0V-00000009Gi4-3K93;
	Fri, 24 Apr 2026 15:55:47 +0200
Message-ID: <9f7df38831598001ac6cd79ab4fb95b4b6e042fd.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: restore monitor injection when
 coexisting with another VIF
From: Johannes Berg <johannes@sipsolutions.net>
To: Brite <brite.airgeddon@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, fjhhz1997@gmail.com, oscar.alfonso.diaz@gmail.com
Date: Fri, 24 Apr 2026 15:55:46 +0200
In-Reply-To: <20260424120807.25005-1-brite.airgeddon@gmail.com> (sfid-20260424_140854_559281_CA03D57D)
References: 
	<CA+bbHrVWmSpWZ9GBVJ5vffh1qYEye=EWMq9tKA-_uzfW+raC8A@mail.gmail.com>
	 <20260424120807.25005-1-brite.airgeddon@gmail.com>
	 (sfid-20260424_140854_559281_CA03D57D)
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

On Sat, 2026-04-25 at 00:08 +1200, Brite wrote:
>=20
> Earlier attempts on this thread addressed the same bug but had side
> effects - notably full VM freezes during the airgeddon evil-twin flow,
> reported by =C3=93scar in the thread. This patch takes a different approa=
ch
> and has not exhibited those side effects across the tested configurations=
.
>=20

I don't believe that all this complexity is necessary, and the code
changes have are fairly clearly LLM-created w/o such disclosures.
Dropping.

johannes
