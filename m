Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515A637DE92
	for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2026 11:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340412; cv=none; b=JRJJdS8xQ6+zbIkzpGu/a32ETNLu5ewtbMt3NR78bygr18GjAEcSMtggyD1IPlSBbkc23fd4FTywaA3XUqpvFW9BBe76zIctsLTOYAfCHw2AV1HJrowzXb5oAv2d4AkQGCGDcT5ACMUwkAYuMlg1wRZxbortB0PVmi4lja3wHlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340412; c=relaxed/simple;
	bh=c85k3SjcCHTVHenl6c9aqjSxzZGk8S6wRsjWowr2rYI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PPVunPdl1UkCp60x/J8zNXAD9ZLirz973n6AjiUt4Qg46KpALGr/YJLVfzOfgkW8oGTpQ6vXO4k3aMoXT9RZ5g7Yd1q1d2kzR6Y4gOwPsJrUcZBI892W0lU0LfbWNHjEJBRdUqjlEg/yyx1edAO+7GQVLbLshcX+gQqcQZZg34s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=cW8ELRZK; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="cW8ELRZK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=c85k3SjcCHTVHenl6c9aqjSxzZGk8S6wRsjWowr2rYI=;
	t=1776340411; x=1777550011; b=cW8ELRZKXhYZErNBga+RpWp7lNC2c4l8Mn+fXwFE7huM+sb
	XAOxXnetYr9qATPHIZlWTKVusO/3vylX7KzIYEO35J+lM4JiPKlqMJL3y6XuiiPrgxN6K/2eH6cVt
	9C0LQ8Np0hRFDpm9DqPlGulPnZiNdoW9x/vXqPpishokrtLOHUqtsFYi/2Eloz1qPssENGjhX3guH
	/Ho+FQJ3BCXxyCFA4iXPfo5TsV/8Bj3jRRp6ySdOw+FOYQaOQoLYRwgGava1ZHswoNl5qvdDhtIar
	lATewAlLSYppDaH57LwOfEgFGdzijL76AoDgonFPEwD3bJT4NESODIApwELVuSIA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wDLHl-00000007Pv5-0T6o;
	Thu, 16 Apr 2026 13:53:29 +0200
Message-ID: <dd6454a4679355f6e9fbf2416da58b45c9c3b792.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: mac80211: add __packed to union
 members of struct ieee80211_rx_status
From: Johannes Berg <johannes@sipsolutions.net>
To: Ping-Ke Shih <pkshih@realtek.com>, "linux-wireless@vger.kernel.org"
	 <linux-wireless@vger.kernel.org>
Date: Thu, 16 Apr 2026 13:53:28 +0200
In-Reply-To: <280094f50a534fc998037b21c36ebe11@realtek.com>
References: <20260411072509.1556635-1-pkshih@realtek.com>
	 <280094f50a534fc998037b21c36ebe11@realtek.com>
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

On Tue, 2026-04-14 at 00:55 +0000, Ping-Ke Shih wrote:
>=20
> > Because of size assertion of rtw88's efuse map [1], I found
> > arm-linux-gnueabi-gcc compiler throws this warning, but x86 gcc is abso=
lutely
> > silent and expected without this patch.

Yeah, depends on ABI padding rules.

> > [1]
> > https://lore.kernel.org/linux-wireless/7c65e315-5a2e-455e-87ee-8fc6d60e=
d807@gmail.com/T/#m43fdf8a1
> > c2b8cff92c1ef50faab7993522647162
>=20
> I'd note that discussion thread [2] of original kernel test robot.
> Arnd pointed out the cause is CONFIG_AEABI is not set, and he said
> nobody should be using ARM OABI any more.=20

Ah, right.

> Maybe, we can ignore the CPU and skip this patch.

Given that nobody complained in many years about not being able to use
wifi on those machines, I'd be inclined to just do that, yeah. But
thanks for digging into it!

johannes
