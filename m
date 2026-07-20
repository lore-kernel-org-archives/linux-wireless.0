Received: from out03-fra1-mx.uberspace.de (out03-fra1-mx.uberspace.de [185.139.157.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0E43BB10D;
	Mon, 20 Jul 2026 18:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.139.157.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784572705; cv=none; b=lbzs37OAZ1zbLVY6hkWjyS2vXYnkPVIUSmTZ/pH3uw4wVsm5WQtmDU4dMRXwAjemG4EGG9ABpBIrJC5CacF+5cnrYtU12RdAGhATPAnARulP7OUqYey+ExSP6a/JA8TrR7OBZQRbTq0AzhLfdBU6syXBG2iODSxJCj7INyJU6BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784572705; c=relaxed/simple;
	bh=+D/jvR+nWaTGle9+uQBAlmOXwDU0d2e8H6bH926NAgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVcpWTTicYLd6FYY2Nc3KYagb43g6angdj49D8vWZRlnHG/rIwaW3PKMyzaT0jCMWoHDicmdIxtw70+s4wwLJAy1hhw2FfsTA5XEOLLQVia4vDxAICyJdwDbSJ80Zlu8K7EzPX9xJMxIPP4KkBrmO07/bKYUtD0wMvgpXum9Ta8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de; spf=pass smtp.mailfrom=plantwatch.de; dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b=BSYIlBPQ; arc=none smtp.client-ip=185.139.157.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b="BSYIlBPQ"
Received: from janus.uberspace.de (janus.uberspace.de [IPv6:2a0b:20c0:2000:62:be24:11ff:fe50:5107])
	by out03-fra1-mx.uberspace.de (Postfix) with ESMTPS id A34F31003A5;
	Mon, 20 Jul 2026 20:38:02 +0200 (CEST)
From: Simon Dietz <simon.dietz@plantwatch.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plantwatch.de;
	s=uberspace1; t=1784572682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d6dgKISvWOp8ieGBJdP+x356b3uKBjwOxLCgJcyB2kk=;
	b=BSYIlBPQu7Wp6eBnQE83oq+dN/zFOhr6kfWLh/BfMYnivK2ynWD89EQwmysmwuk0LmDo2Q
	pUfGvOFwEOB6mXsLaHz0UrsZU08M2TzAz6jqZ/ek8agM2sxsz25VpnbYc/2VmC9BmysSZu
	bTMGfSDuztqZAtLmWb7NBKixDt0xRA2dCaK3giqtFh5Jk4rVBrwGN/ij2ilETqTCFUuag6
	gLzYGRBP3jCDhoRDA3zD+KvpTqii2aXmjGNEOaU8PQs0N0fLVo5ur6YNm5oNmYtM9ice+L
	Fl24PslvFhFXBB5bip71ljL5cAlYARqvgE6pV7pTvbZzyO0Kxu0onq4oQw4New==
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
Subject: short description of GeoNetworking
Date: Mon, 20 Jul 2026 20:36:13 +0200
Message-ID: <20260720183613.2020886-1-simon.dietz@plantwatch.de>
In-Reply-To: <89b3aa8c-f2ec-4b27-b5b0-5891d870e001@lunn.ch>
References: <89b3aa8c-f2ec-4b27-b5b0-5891d870e001@lunn.ch>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [2.90 / 999.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.00)[33.29%];
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

Hi Andrew,

> Is there an architecture documentation somewhere?
No really available one, at least not public. The ETSI ITS standard is
public available and there are research papers, but that would be a lot
to read.

> One of my comments was about routing tables.
I agree that cosine calculations may not belong to the kernel space.
Before we continue talking about routing tables, let me give a short

Description of the GeoNetworking (gn) protocol

GeoNetworking is used in a vehicle2x context where vehicles exchange
position information (and other data in higher protocol layers like
BTP) for use cases like trafic jam notifications, or railroad crossing
communication with cars or trains.

gn transmitts packets in various possible 'modes', including:
* broadcast (all recievers in range, like ip)
* single hop broadcast (all recievers in direct range, like ip, if the
  reviever is in the same network and no default gateway is used)
* unicast (one reciever out of range, packet is sent to the closest
  intermediary; only here a routing decision is involved)

gn packets contain a gps position and a geographic target scope, which
can be one of predefined shapes (rectangle, circle, ellipsis) and
dimensions of that shape (radius if circle, length and width if
rectangle). Hosts with a position outside the shape may recieve, e.g.
a broadcast, but drop the packet (because it's out of the target scope)

There are beacon packets, which are continously sent by each host,
which contain the gps position of the host in order for the other hosts
to be able to perform distance calculations necessary for the routing
and (if no beacon packet has been recieved for a certain while) for
pruning the routing tables from other hosts which are no longer there.

There are location service (ls) requests, which are used to query
nearby hosts for the location of a host out of the sender's own range,
which are answered with ls reply packets.

There is an address rotation mechanism for privacy reasons, so it may
occur, that a vehicle disappears at a point and reappears as different
vehicle (without advertisement of the address change, so a correlation
of old/new address is not feasable).


So regarding routing there is the question where (user or kernel space)
the beacons and location service should be handled.

I would suggest to handle them in kernel space and only notify the user
space, if something happens (previously unknown beacon recieved, ls
reply recieved, ...) instead of passing all the beacon and ls packets
to user space.

> There also seems to be a need for location information. How does that
> get into the kernel? Is there a daemon for that? Patches to gpsd?
In the first version /proc has been used, after that ioctl; today
netlink generic seems to be the most reasonable option. We used
standard u-blox gps recievers and wrote a little userspace tool to
inject the location information into the kernel space (via ioctl).

That brings me to the question, how the ideal interface between user
and kernel space should look like for this module/functionality.

For short term, it should be possible to strip the routing stuff incl.
the cos table from the module and return -EOPNOTSUPP and/or -EINVAL
when using advanced stuff like routing and only support recieving gn
packets and send broadcast and beacon packets. Routing could then be
added in a v2 patch series.

What do you think?

Simon

