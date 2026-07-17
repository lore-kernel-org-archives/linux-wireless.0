Received: from out03-fra1-mx.uberspace.de (out03-fra1-mx.uberspace.de [185.139.157.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BE733ADAC;
	Fri, 17 Jul 2026 15:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.139.157.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302950; cv=none; b=FtrqdXfgRO1AszGA4tgzUK6UKoqmuaeyLIN2nA7OpHGlbAPrvdK/c9iU4Yo7cVvO1lnbJxxwPvIs4187CqevKYTdG0xWFbrxKvuzIokxqMBYtXZPGNzNyYptC6ESo3uHBSiktr8VsyEtadjg+3eA+mq17Y0HicpoxFQlwXj6Ryk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302950; c=relaxed/simple;
	bh=0zDAeGaeN++KZl5iGbdTvfyEPMfCz1Pd2QVxgBqFuyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lz9thArmQP6rcuJ/uVohpgOAD7oGpdi+670DfBcYkBoorpRxY/CBTGjI7mA9mEb7ga1NX7APhCC1HtIXbftUIGjXyvzjfKCBqS5xXUcpssfIrR1kMOnIafBO0PgPskNpD6aGWv2shjpGZYy9vy56dIhUJfh+GLovq3q0LYtz1kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de; spf=pass smtp.mailfrom=plantwatch.de; dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b=jMg6UvX1; arc=none smtp.client-ip=185.139.157.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b="jMg6UvX1"
Received: from janus.uberspace.de (janus.uberspace.de [IPv6:2a0b:20c0:2000:62:be24:11ff:fe50:5107])
	by out03-fra1-mx.uberspace.de (Postfix) with ESMTPS id 6FACB1003DD;
	Fri, 17 Jul 2026 17:42:18 +0200 (CEST)
From: Simon Dietz <simon.dietz@plantwatch.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plantwatch.de;
	s=uberspace1; t=1784302938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0zDAeGaeN++KZl5iGbdTvfyEPMfCz1Pd2QVxgBqFuyc=;
	b=jMg6UvX1XHT/lzV8mq+pqCEukt51n6p6OcWPIiVBesC9ApTBsFCnlR4r8BIAFVj8On4Qgb
	OluuA4Vxe0SQVk+LvA5te1GLyTjUGFq5LdJySBsEX8kAQezd7/zX3gvgrcDsrdxj/ssDX9
	hAtiP1KgZQ71eusskJ6GdMW8+A5IkEb/o4NB+rpgtkgWuwJDPfgPmwzToDubI/yMS3wrqB
	UqZhAOer/GaVFIzGQLqf1J7qn3Eehu8I/p8ggplSEZ73mVdSEmzOekV5rbPN24cm7mQevh
	pGX+raRb2Afb5KUk9imbGmePmhWsdL1r7Rn/vToXxE1PgghZN4N5VJCsdG7C2A==
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
Subject: Re: [RFC PATCH net-next 0/6] net: add GeoNetworking protocol
Date: Fri, 17 Jul 2026 17:40:33 +0200
Message-ID: <20260717154033.2092529-1-simon.dietz@plantwatch.de>
In-Reply-To: <9db571aa-4d5c-456a-ab24-796119c9807b@lunn.ch>
References: <9db571aa-4d5c-456a-ab24-796119c9807b@lunn.ch>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [2.89 / 999.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.01)[50.88%];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[netdev];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:3320, ipnet:2003::/19, country:DE];
	LOCAL_OUTBOUND(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	DKIM_SIGNED(0.00)[plantwatch.de:s=uberspace1];
	FROM_HAS_DN(0.00)[]

> I'm probably doing a deep dive too early, but ...
Thanks for your time and the fast response.

> Nothing new has been added to /proc for a long time. Please consider
> a different interface. I've not yet looked to see what is there, but
> networking now pretty much only uses netlink.

/proc has been used during the development of the gn module for passing
gps data from the user space to the kernel. This behaviour has been
changed to ioctl. Procfs has only been kept for debugging reasons. It
can safely be removed and will be in the next patch version.

> New IOCTL code is also very likely to be rejected. The functionality
> should go through netlink.

I'll take a look into netlink and rewrite the new IOCTL code.

> Generally, inline functions in a .c file are rejected. It is better
> to let the compiler decide. The exception would be if you have a
> benchmark which shows inline actually helps.

Noted. No inline functions (besides proven by benchmarks).

> This seems like debug. At minimum, it should be _dbg(), but maybe it
> should be removed altogether.

I thought to have changed all pr_info to pr_debug, this one slipped
through.

> When does this wrap around? Maybe add it as a comment.

Noted.

> Commented out code is not something we want in the kernel.

Indeed all BUG calls should have been removed with one of the
subsequent patches together with most of the commented out code. I'll
take another look to ensure all comment out code is removed.

> Maybe one of your later patches fixes this. We might want to consider
> squashing them, so the review is done on the final clean code.

That's good advice. I'll adhere to it.

> netdev uses reverse christmas tree, longest lines first, shortest
> last. It should apply to all functions.

Fixed in patch 6/6. And partially included in squashing subsequent
patches so they fully adhere to the coding style from the start.

> Not the sort of thing you normally see in the kernel.
> I've not looked at the code enough to see the big picture, but
> generally, the kernel routing table is static, and fed from a user
> space daemon. Should all this code be in user space?

In GeoNetworking routing decisions can be and are in non broadcast
situations based on the distance to the other vehicle/host. To be more
precise routing is based on if the reciever is in the same area as the
sender. If the sender needs to forward a packet to a reciever outside
its own range, it is forward to the intermediary closest to the
reciever.

That's kind of the core idea/feature of GeoNetworking. I don't see the
possibility to move this part into the userspace. But this does not
mean that there is no option at all.

>> static void debug_loc_te(void) ...
> debugfs? a netlink dump operation?

I'd like to keep this debug function for now. I agree that it should be
removed/changed in the final patch before an actual merge to net-next.

Simon
