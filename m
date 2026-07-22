Received: from out03-fra1-mx.uberspace.de (out03-fra1-mx.uberspace.de [185.139.157.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAF8339384;
	Wed, 22 Jul 2026 21:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.139.157.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784756210; cv=none; b=KSbShbks770tEdifw+MYTOSiBTQJzPu68LmgVPAEuXpZ/bEG3ppVaplkXm9BFLtvzC6IQPE5ygmwJfyg419zIlu1O8fv7Jw3MU1RcANdKh6mkaibnk5AxVrPXyF+Wtk7lLOMbLqciurvwjQfcwUYHduJD05ir64BD22rc9okBvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784756210; c=relaxed/simple;
	bh=LpUqXcF65OBl+6ZShaNXnzVaLuQLEwTmNnJ5wKXN65Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjq8cQfufbMuOy/ZHFBGfY7macbZiD7z4q+s4R6mlx+05yYNxo+VuVRdE8hEfue1Y4V8bpk4kTZsbB7K4u2MN53bAtDm55JJPRY4nWEQRLxujjIvCn5+MwVw24KtcM3B4Wm2/Z7ESqWoutNCH3mxGGw6z9gwo5OhAJzFVJNBRto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de; spf=pass smtp.mailfrom=plantwatch.de; dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b=q0ANRmWN; arc=none smtp.client-ip=185.139.157.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b="q0ANRmWN"
Received: from janus.uberspace.de (janus.uberspace.de [IPv6:2a0b:20c0:2000:62:be24:11ff:fe50:5107])
	by out03-fra1-mx.uberspace.de (Postfix) with ESMTPS id 3537C100058;
	Wed, 22 Jul 2026 23:36:35 +0200 (CEST)
From: Simon Dietz <simon.dietz@plantwatch.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plantwatch.de;
	s=uberspace1; t=1784756195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LpUqXcF65OBl+6ZShaNXnzVaLuQLEwTmNnJ5wKXN65Y=;
	b=q0ANRmWNeKR5JMF5utgYg7sBXeoOetylRgyUQB7bHX/ih9nrNb468lo+Q+2twXzgeAhovO
	ycwcSLDBPkKMEK0S/vqeLVa9z3Tv1Rys1mQDmdvT6Hg5mxCptJOH98UnvSjIUfDLZFyvDB
	rSYYHfp6SUMOvD3tyyPMy9KW1W1Zi5pinkCBi2+9Thxp3ZrNhJFsL/VzVdEgG38jjXQtSa
	t+qljpzBRzdaWIXL6Svvxs6LLnmyFqvKATldnmBifJwF2j6I3Ib4fuxqvCNdjBX/oXDHtt
	UtayEsjyNG83d7JjpHnjFin+C8GYELvxz95olyJPY2rg7d8nzt45QJJbtjg3ew==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=simon.dietz@plantwatch.de smtp.mailfrom=simon.dietz@plantwatch.de
To: andrew@lunn.ch
Cc: andrew+netdev@lunn.ch,
	davem@davemloft.net,
	dietz23838@hs-ansbach.de,
	edumazet@google.com,
	johannes@sipsolutions.net,
	kuniyu@google.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	simon.dietz@plantwatch.de
Subject: Re: short description of GeoNetworking
Date: Wed, 22 Jul 2026 23:34:37 +0200
Message-ID: <20260722213437.3593569-1-simon.dietz@plantwatch.de>
In-Reply-To: <937e2942-3c0d-4583-a741-8a96c4e0bbc4@lunn.ch>
References: <937e2942-3c0d-4583-a741-8a96c4e0bbc4@lunn.ch>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.02 / 999.00];
	BAYES_HAM(-2.92)[99.65%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MIME_GOOD(-0.10)[text/plain];
	LOCAL_OUTBOUND(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TAGGED_RCPT(0.00)[netdev];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:3320, ipnet:2003::/19, country:DE];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_SIGNED(0.00)[plantwatch.de:s=uberspace1];
	ALIAS_RESOLVED(0.00)[];
	FROM_HAS_DN(0.00)[]

Hi Andrew,

> I assume there is some daemon talking to gpsd on one side, and the
> kernel and the other? What other user space pieces are there?

At time of creation of the initial code base we used user space code to
pass the gps position data from gpds to the kernel module (first via
/proc then via ioctl). We also wrote some code that implemented a very
limited subset of the higher layer protocols (BTP and DNEM) for
testing purposes. We also had some scripts for qemu (for debugging
the implementation in an isolated environment) and ansible scripts to
patch the ath9k driver to actually use the 802.11p wifi band (which is
above the classic 5 GHz wifi 802.11ac band) for testing the inter-
operability with a specific commercial solution. However only the
geonetworking kernel module and the ansible scripts have been published

> So it would be good to include a link to your git repo. We generally
> want open user spaces tools.

I'll polish them a bit, then I'll publish them near-term.

> Given the previous definition, this makes no sense.

I may have simplified the modes of operation too much, sorry for the
confusion. Having the standard (ETSI EN 302 636-1) open (which contains
a visualization of the operating modes), let me try it again.

There is GeoUnicast, which is the most advanced and needs routing and
the cosine calculations to find the intermediary host in range closest
to the target host.

Then there is GeoBroadcast, where a packet is forwarded hop-by-hop
until it reaches a host inside the target geographic area. Once having
reached the target area it is then broadcasted (and re-broadcasted /
flooded) by hosts in that area (until the with each broadcast decreased
hop-limit reaches 0).

And there is Topologically-scoped broadcast (TSB) where a packet is
broadcasted to all nodes in the n-hop neighbourhood (with the special
case single-hop broadcast with n=1).

> How useful is the stack without unicast?

At first glance, not very much. But considering the use case (e.g. BTP
or DNEM) it is more common to notify all vehicles in range (TSB) or a
certain area (GeoBroadcast) to e.g. warn them of a car crash than to
search for a wrong-way driver and tell him via unicast that he is
driving in the wrong direction. And it's two-thirds of the standard.
Plus (and the most important) it would allow me to focus on more
essential stuff, first (like how to properly inject the gps position
data via netlink in a kernel conform manner) instead of aiming for full
standard conformity all at once (cathedral approach).

Simon

PS: I've seen your other emails commenting on the code, I'll answer
them later.
