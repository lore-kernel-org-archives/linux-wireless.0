Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EA9400DF6
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 08:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189834; cv=none; b=M1+uEYz1gQY2FZoT/QgUzE0vbtm5UgdD2InLiV+DVsxTFckoQVxKwACt++Gr0X/R47cak1v1lxmj58svp5zXVV4k8J2QBnr0mkuI31IVmoir/JGm5YqGfyOs6RO3sJ+thDwtCk98X/JWdqXwuFhYDsB3ojwW2QXpORxaU3WaGh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189834; c=relaxed/simple;
	bh=j5CT5uilFsWBe6KvghEbMcuaNCzI3OgyA7C9uA6Flvw=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZsO8YEWrXkOqudTz+eWrYBq/mhAhmuMcgNn2PcBL6ztDJ+byvBte16sAaPJ4Mzeg4hfatCtj7ubZ0+W4vGtoJoiJkFRT1Efd3IbXQT2zLOq9TM+pz8ITQSTBsPNAPh0ds7izMu37J5FI/4xd4OsOzZzSxrdUd7XeAjhFU59jFVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=HxlRGlnF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="HxlRGlnF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=twFldm5+E2Klgae48XSP868AlybiJG2g3DLqIECKuyM=;
	t=1791189833; x=1792399433; b=HxlRGlnFR74Mawfun5QMHzOc5Eld3WlD5jFdN4wSGzkRy07
	p89y1EBK/Uv05MHFnM3QyvpD6H4nCi9GLvRNjcJe137qbvPoQe+wWQHniWn3i+Q7TSUeWdaL7dYjr
	2WdC0xEJjP0ZrJYUn1Xc1t1seKbl6N1fZwUIffw8Qis9PUwbPfccgjOyfsMY7jkcguf06SgMhJ7Yq
	e986SUfTQ1dL9KjDhgt37oEVZcKi9jHfIh3uMQfWx7L9jHO5xrTU9xb4UESkcB7/tcXXa32iULCvt
	XaiyNcKqCyMDx9cj8MsVZTg25HCoIaH6ODx9Q6ltbuTXZIHi2l8H1B6v2d3hZREw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDeIY-000000058Fl-2NzA
	for linux-wireless@vger.kernel.org;
	Mon, 05 Oct 2026 10:43:50 +0200
Message-ID: <0fb4ac3a33933c64b8660a5cdd1e5c357d345717.camel@sipsolutions.net>
Subject: Re: [RFC PATCH 00/12] wifi: AP side locking improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 05 Oct 2026 10:43:49 +0200
In-Reply-To: <20261004214504.1636783-14-johannes@sipsolutions.net>
References: <20261004214504.1636783-14-johannes@sipsolutions.net>
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

On Sun, 2026-10-04 at 23:40 +0200, Johannes Berg wrote:
> This obviously goes on top of my (fixed) RTNL redux series.
>=20
> The idea here is that wiphy mutex can be held for quite a bit
> of time (e.g. waiting for firmware), but beacon updates (e.g.
> with the critical update design I had proposed a long while
> back) and other things should be fast.
>=20
> So with this not all things require wiphy mutex. These are:
>=20
>  - beacon and related template updates
>    (this one needs driver opt-in),
>  - mgmt frame TX,
>  - control port TX, and
>  - peer probe.
>=20
> This does make the implementation slightly more complex, but
> the added complexity is almost entirely in mac80211 (and some
> in cfg80211), unless a driver wants to opt in to unlocked
> beacon/template updates, which it has to implement itself for
> obvious reasons.

Thinking about this some more, there are a couple of corner cases I
don't like:

 - the semantics of "only for netdevs" and the get_device() in the
   implementation are strange

 - because of that, we can't do this for non-AP, and NAN would benefit

If we add a refcount_t to wdevs for this, and then use wdev_hold()
instead of dev_hold() (which uses the netdev dev_hold if it's there)
then it starts working for everything and the implementation gets nicer
too.

I'll rework it accordingly for the next round.

johannes
