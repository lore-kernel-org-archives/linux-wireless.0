Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FABF214A84
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 18:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791225788; cv=none; b=ZSLYqWZ0+3wIUjpQTIZvcdj+6VM2WoJyl5Z69tbM/ooRoodoxjvXX5d27SP1KfvWn4CXHwNEy4Q5BCdTcp7yHlIb6qs/pJqgPfY+DSQm84otePzmiLHdA1tHKNJ4/FOyY3eHB8B8YI15I5oR+FJdYkxCzjAvHGOTMUi5Rv1c0os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791225788; c=relaxed/simple;
	bh=tcmviAl98scsnRd743wJhgY3XHfu966REeEXLCHa2LI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ce+8ED5wLpUVtqDlTOzLtjWV+hZZyARMzP2bdLc2hYU7sq4aY4BvNX7Psetde2kYNX8wS14JF2pCWIgOuaDaWEgGk7KebZ/9koEBeFFJM4s0V5Dg8qREctKV5D2Ofi/we6Y7rW1A0jPv+30R0jfioKA/jzcSmQe7uafVpTO4WCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=lb1CIFKb; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="lb1CIFKb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=tcmviAl98scsnRd743wJhgY3XHfu966REeEXLCHa2LI=;
	t=1791225786; x=1792435386; b=lb1CIFKbwr5TMGZQt61bu0i8aJadNuJC5yBW3g5r848b0ez
	OOE1T8ooHFRBMwtzOKpJ3SHasV1Rmml3E7rLB6RgQk/xESopiFjkq+Kz0YHaIf4sHxwRBylIwvEf3
	HRbOiNLMDfmEsnR+g6vuIqbXatOc0juCFTkbkhOqoqIoq1vT+oFFfvmBP0TCryaqHVKcLuRuY9wS1
	iMPtMy8rbWG2NHqzZHn5qM5DvTzNwX52KwLSlvaTpI4qFK591qJ3MMZH5eTF/tvk2Jk8Dt/0AJvsg
	4xK2DTdNKGmdUAXanP/QLPUMgZiOrrFTOhac4EHwPoT7YOzLWqbmL8uF30j5kMYQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDneP-00000005XxG-3btu;
	Mon, 05 Oct 2026 20:43:02 +0200
Message-ID: <53a5031c46cc6726163a6776e4026ed6fa552c2a.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 09/18] wifi: cfg80211: document wiphy
 mutex for radar/CAC events
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Norris <briannorris@chromium.org>
Cc: linux-wireless@vger.kernel.org, Francesco Dolcini <francesco@dolcini.it>
Date: Mon, 05 Oct 2026 20:43:01 +0200
In-Reply-To: <asPuIvquaejUkaLE@google.com> (sfid-20261005_203623_989612_42C4D784)
References: <20261005100525.1991059-20-johannes@sipsolutions.net>
	 <20261005120526.fe5960ae72ab.I57002ac3e57d2ac4613eb0cb0e6d17bedccf0cbd@changeid>
	 <asPiiI6-JpMd3vKr@google.com>
	 <c5990e315e83eb6014d6ab02f9846a9d10a901f8.camel@sipsolutions.net>
	 <asPuIvquaejUkaLE@google.com> (sfid-20261005_203623_989612_42C4D784)
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

On Mon, 2026-10-05 at 11:36 -0700, Brian Norris wrote:
> > I think so. Or we can discuss it should be async in cfg80211, or an
> > async version? I guess first we should discuss how to solve it either
> > way, and look at all the drivers that still have the issue.
>=20
> At first, I thought it'd be trivial to just throw in
> wiphy_lock()/unlock() in 1 or 2 places, similar to commit 0d7c2194f17c
> ("wifi: mwifiex: add missing locking for cfg80211 calls"). But I'm not
> sure that's actually sound -- it might introduce some locking inversion
> problems, where (for example) mwifiex_del_virtual_intf() expects to be
> able to flush/destroy these workers, but it's already holding the wiphy
> mutex.
>=20
> (I wonder if commit 0d7c2194f17c is similarly unsound.)

Yeah, I have no idea :-)

Some worker here could maybe move to wiphy work these days? But you
probably wouldn't want arbitrary rx/tx handled with wiphy mutex ...

> Either I'm missing something (quite possible), or it'll take a little
> more thought on what the right solution should be.
>=20
> Anyway, I'm fine with your approach of document first, fix later. It's
> hard to move anything if you have to reason through every crazy /
> lightly-maintained driver for every problem.

I pretty much try to for all the ones that are correct in the first
place, but ... ;-)

johannes
