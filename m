Received: from out01-fra1-mx.uberspace.de (out01-fra1-mx.uberspace.de [185.139.157.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E6F1A682E;
	Sat, 25 Jul 2026 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.139.157.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784991750; cv=none; b=Qt8WpWlMOCaif1QUdv+eA0omFZ9PZLY2fzoy9Xsuk6CQD6y4hcqmVtCPNjt6kaBg6HnNruLqYL7CGdb5E55+oKQr1+V5cyvw/DTY0BHecMtubY5l+6iCZKnUKFg43Un9oaJCqFYOVK80P4BxDXeBhA0ic9kZTllkf9uucHGWwL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784991750; c=relaxed/simple;
	bh=L7NNS97L5lFBRlRqpMWkpL+t083DwAT108jf0cGLBnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cmyv5QKPIdrQHNypO2no7LiFzKdw8j1U+HpAPJBXvvsbWtPAU3er+ncitc0NY0fM3VlnjZgZzDFtzHUT+Jq/nuEUSTiBO1eieSNdwLQ9pMJdTArRgCSqL74tZGzEW9Uj4w0uIRiEEElBE7Vso+owx1pv02BbFr4FomJc7vtJXNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de; spf=pass smtp.mailfrom=plantwatch.de; dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b=qlB7lJgp; arc=none smtp.client-ip=185.139.157.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b="qlB7lJgp"
Received: from janus.uberspace.de (janus.uberspace.de [IPv6:2a0b:20c0:2000:62:be24:11ff:fe50:5107])
	by out01-fra1-mx.uberspace.de (Postfix) with ESMTPS id A46B3400F7;
	Sat, 25 Jul 2026 17:02:12 +0200 (CEST)
From: Simon Dietz <simon.dietz@plantwatch.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plantwatch.de;
	s=uberspace1; t=1784991732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fZv9q0PX/ACqvH8vFCmvIkNrg2wZVDIkdqqYX2bPamo=;
	b=qlB7lJgppp1GhDHQb+wEVOIq7RrbcbxcjRnsfy2YjAgJYSqldKbvq0G2Dtb1BOLBCT3fVj
	o0prZpZ7YjAYa0MbsS+6nKTOWZVz57UdtwssT0DEn5CHkoXrvz5mEEPJUdY7AcJk12PG/y
	cpCnJ8xVxoXTurjOTCgeTZ8b+JDcI6WiDI9jx7vHvOXpnYrgrOQ+SGGRcl5D0baqBhZ/S7
	eHkN+BpfYsRTXxAp7bbJsWl9nuuYww6oKc4MTSNE7jzGQHg7kXr5l7WT3bhAXQhWHMYeU+
	2MCalkjUEWPjQHZCiicOo7rVO/Mg0hUddZrY4iH8lD5zaSMSsU2YpONGdysSSg==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=simon.dietz@plantwatch.de smtp.mailfrom=simon.dietz@plantwatch.de
To: johannes@sipsolutions.net
Cc: andrew+netdev@lunn.ch,
	andrew@lunn.ch,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	dietz23838@hs-ansbach.de,
	simon.dietz@plantwatch.de
Subject: Re: short description of GeoNetworking
Date: Sat, 25 Jul 2026 17:00:08 +0200
Message-ID: <20260725150009.183155-1-simon.dietz@plantwatch.de>
In-Reply-To: <127c720f9ceeaac6ec3872bfc7732ab27d968dfc.camel@sipsolutions.net>
References: <127c720f9ceeaac6ec3872bfc7732ab27d968dfc.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [1.26 / 999.00];
	SUSPICIOUS_RECIPS(1.50)[];
	BAYES_HAM(-1.14)[88.63%];
	MID_CONTAINS_FROM(1.00)[];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[netdev];
	ASN(0.00)[asn:3320, ipnet:2003::/19, country:DE];
	FROM_HAS_DN(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	DKIM_SIGNED(0.00)[plantwatch.de:s=uberspace1];
	FROM_EQ_ENVFROM(0.00)[];
	MISSING_XM_UA(0.00)[];
	LOCAL_OUTBOUND(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+]

Hi Johannes,

> Or put another way: for each packet, you need to know _where_ (as in
> physical location) it's going to go, so you can pick which peer to
> send it to, no? Is this really a *per-packet* property? If not, then
> I don't think the shape calculations etc. would really need to be in
> the kernel?

For GeoBroadcast the destination area & shape is a per-packet property.
For GeoUnicast and topologically scoped broadcast there is no such area
and/or shape. So the shape calculations need to stay in the kernel to
support GeoBroadcast packets, I think.

> A bigger issue with this might be that it's clearly a small piece of
> a large overall puzzle - Simon, you mentioned a modified driver
> somewhere I think (can't find that mention right now), which may be
> using the OCB support in the stack, perhaps, but also isn't upstream.

To unfold the puzzle a bit, for handling GeoNetworking packets in a
standard conform manner, the following things would have to be done:
* The wifi device has to be switched into ocb mode (included in
  upstream linux kernel and iw)
* The wifi device has to radio in the 5.9 Ghz spektrum, in particular
  between 5.875 and 5.925 GHz[1], therefore ath9k must be patched.
  These patches are not upstream, but rather short.
* wireless-db and CRDA must be patched to support the spektrum
  mentioned above, too.
* The linux kernel must support GeoNetworking, either natively like
  with the proposed patch series or (maybe?) via raw sockets. I am not
  sure, if the support is needed to recieve GeoNetworking packets and
  to record them with a tool like wireshark or if not, though. For
  sending GeoNetworking packets it is necessary.
* There has to be some kind of routing table interface to the kernel
  and userspace tooling to support routing and sending of GeoBroadcast
  and GeoUnicast packets.

> That's a far smaller patch than I expected 🙂

To be accepted upstream, the patch for wireless-db would have to add
these 802.11p list entries to all EU countries, so it would be larger.
Letting them reside in the world domain - which is the current
implementation - may not be acceptable. But the ath9k part is indeed
rather small.

> how do we get anything useful out of a socket family without them?

Valid point. GeoNetworking support in the linux kernel may possibly
increase its adoption in cases where linux is used (already). I may
write to their mailing list and ask, if such an open source 802.11p
implementation exists within the Automotive Grade Linux project.

Simon

[1] according to EU 2020/1426
