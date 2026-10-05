Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D2A4D6C49
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 17:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791222737; cv=none; b=LxQkjN7p5nn1cCySj57tpdgzk4LXBXxvnRFnKRkv8PSrFtLzyHBGjT09sE0tBskeIFKeBjMg8TcTAPqYBBFpXf4HKobq96XjNccJyHunWcigZ0RC4CuM2RJsl7baqoVwt6qGKeZ5XMi9aKxzEr8+yRz7LunTmcutKQ2G84u4OM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791222737; c=relaxed/simple;
	bh=vAMCRLqD0WNE2t7clBW9czsDLjVjbseyQ1YZRefKcDU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FhXo6JmhI1dXemy/51jggA8XQuyv9uEl9iIKL+hERu1950y9x5GVlIgrM+Y+ctgYaK/JN2qD6MeJoDjY8SczJr3sA3NW+KkmaL34wm5uzZpwkzeC1H/jtEgut7uzv6WaNDdKGCaNNrsb2vTTCcNEgtvN2olUoW8YqMkhjclq6Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Iv0cNna9; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Iv0cNna9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=OCnAMf9CrMnNv2ZNeBmqz2ZzMtNQ152KoefPA3rg44A=;
	t=1791222735; x=1792432335; b=Iv0cNna95hP7qjoyo1+LfURsNaQceHa/TM8LPoG4Xt4fXar
	MwCIG8e/nVimDSnrppC9HSv4yhtivfcOSLRq63vCGgzv/BJzOHZ95dmD19zDTWMxjn8AYD44Awsek
	046GpTYg1h9e1JQLlLLNPQbjPZXRCfPhrVWa6o7F5ybauZj9sae2iTywfkGqfouYyBXJ1E+LOmTzx
	dWDjoRwjE4TciKJdwIqRPBiB8QKyweS5Hqv69QTAvan+NDrZkqrbScLAgMj19SKcSBcqyVMvxTdqM
	ud69XN2ERFtuhMCqPDd60TiO/Fe0lZOih6NrDW6itAgMaXIYW5SjHN+WU3boJcPw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDmrE-00000005VkW-0Rdi;
	Mon, 05 Oct 2026 19:52:12 +0200
Message-ID: <c5990e315e83eb6014d6ab02f9846a9d10a901f8.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 09/18] wifi: cfg80211: document wiphy
 mutex for radar/CAC events
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Norris <briannorris@chromium.org>
Cc: linux-wireless@vger.kernel.org, Francesco Dolcini <francesco@dolcini.it>
Date: Mon, 05 Oct 2026 19:52:11 +0200
In-Reply-To: <asPiiI6-JpMd3vKr@google.com> (sfid-20261005_194653_412780_31ACF618)
References: <20261005100525.1991059-20-johannes@sipsolutions.net>
	 <20261005120526.fe5960ae72ab.I57002ac3e57d2ac4613eb0cb0e6d17bedccf0cbd@changeid>
	 <asPiiI6-JpMd3vKr@google.com> (sfid-20261005_194653_412780_31ACF618)
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

Hi Brian,

Woah, thanks for looking through this! :-)

On Mon, 2026-10-05 at 10:46 -0700, Brian Norris wrote:
> > The DFS state of channels and the CAC state of the wdev is
> > protected by the wiphy mutex, so the radar and CAC events
> > must be reported by drivers with the wiphy mutex held. In
> > mac80211 we do this, but some drivers don't yet:
> >  - mwifiex/nxpwifi have an event handling worker,
>=20
> FWIW, one of the two contexts that call cfg80211_cac_event() in mwifiex
> does *not* (by inspection) seem to hold this.=C2=A0

Yeah I know - that's why I wrote "some drivers __don't__ yet".

It's always been broken though, and I kinda just wanted to move on. It's
racy, but I think mostly wrt. the valid_links warning (which isn't
relevant here) and the data accesses, nothing worse will happen.

> Is this something you'd
> prefer individual driver users/maintainers resolve?

I think so. Or we can discuss it should be async in cfg80211, or an
async version? I guess first we should discuss how to solve it either
way, and look at all the drivers that still have the issue.

> >  void cfg80211_cac_event(struct net_device *netdev,
> >  			const struct cfg80211_chan_def *chandef,
>=20
> Should we add an assert to this API?
>=20
> 	lockdep_assert_wiphy(wiphy);

Well I figured if I do that now then tools (and perhaps people) will
start complaining and that'd just put more pressure on everyone to fix
it ... that's why I didn't yet, but I guess I should've outlined that
better in the commit message (even after a --- marker).

johannes
