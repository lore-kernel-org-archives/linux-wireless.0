Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584F83BBFD3;
	Mon, 20 Jul 2026 20:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784578614; cv=none; b=e1k4in6M+ioPrarTXVrLFRY/+6GwgRFbWxHmC8VGzZc+jBd9eUC7AwTjOq4+kdiT/Y01Jx6oG9s0e1e1zXVccP05ayDAPoAgRty+V/N0jtS345t+hta0mvP992BEzkmvLbw90LRIU1nMcFlFO31mnkCokwecp2J3ujCHRw0d+tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784578614; c=relaxed/simple;
	bh=RCCc6wUnb7eRLMFWNp0Ap0THoK08GCD9mtVB3fVxdIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjXT2sAE3BkysV+816uaCQu5ARkN1zx2QhdiRQX5LX2m+uZvUnfQFbxMFzWhGHMulgLR7aM2lSW6oo0/NV1Te40ephaie23BF2nHAhOTn0RcJVVQIqV2a0TzEcaH0CtuLzmnaLwKRB5Qu+cKwDwEaNxYOgEPbuWWTtaN2VsrphI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=KCZKTTY/; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="KCZKTTY/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=X6si59MHAC2aF8OSuOresxDGb43YZ6XnzLFCCvh2a34=; b=KCZKTTY/a+cI31Zp+vBJohP4zj
	hpSTz8spJvsLTRalxJRaIDGNqIFb6FELZx3w6FkKkLZfaJd1FzpaYGOpAR0omNdOXKylSdfgW396F
	cm+CWveuqdaW8LmKUteGeczsTwfAggPSBeqb/xXvoAhvkOJ27EM2/VSXoVreZlBzAcBw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1wluPh-00DJmg-Lz; Mon, 20 Jul 2026 22:16:33 +0200
Date: Mon, 20 Jul 2026 22:16:33 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Simon Dietz <simon.dietz@plantwatch.de>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, dietz23838@hs-ansbach.de,
	edumazet@google.com, johannes@sipsolutions.net, kuniyu@google.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: short description of GeoNetworking
Message-ID: <937e2942-3c0d-4583-a741-8a96c4e0bbc4@lunn.ch>
References: <89b3aa8c-f2ec-4b27-b5b0-5891d870e001@lunn.ch>
 <20260720183613.2020886-1-simon.dietz@plantwatch.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720183613.2020886-1-simon.dietz@plantwatch.de>

On Mon, Jul 20, 2026 at 08:36:13PM +0200, Simon Dietz wrote:
> Hi Andrew,
> 
> > Is there an architecture documentation somewhere?
> No really available one, at least not public. The ETSI ITS standard is
> public available and there are research papers, but that would be a lot
> to read.

Sorry, i was meaning Linux architecture. Something is feeding in GPS
location information. I assume there is some daemon talking to gpsd on
one side, and the kernel and the other? What other user space pieces
are there?

> > One of my comments was about routing tables.
> I agree that cosine calculations may not belong to the kernel space.
> Before we continue talking about routing tables, let me give a short
> 
> Description of the GeoNetworking (gn) protocol
> 
> GeoNetworking is used in a vehicle2x context where vehicles exchange
> position information (and other data in higher protocol layers like
> BTP) for use cases like trafic jam notifications, or railroad crossing

BTP?

> communication with cars or trains.
> 
> gn transmitts packets in various possible 'modes', including:
> * broadcast (all recievers in range, like ip)

Hold on. IP broadcast, not L2 broadcast. So if you have a mash, this
broadcast is L2 multi hop, but stays within the same IP subnet.

> * single hop broadcast (all recievers in direct range, like ip, if the
>   reviever is in the same network and no default gateway is used)

Given the previous definition, this makes no sense. IP broadcast never
leaves the IP subnet. You need to use IP multicast, and an IP
multicast gateway for such packets to go into other subnets. And then
you need PIM or some other multicast routing protocol.

> * unicast (one reciever out of range, packet is sent to the closest
>   intermediary; only here a routing decision is involved)

Closest intermediary. So the idea is the maximise the number of L2
hops?  That can make sense, assuming the underlying WiFi network is
using different coding rates. A short hop can use a high coding rate,
making the use of air time shorter. If the furthest intermediary was
used, you need to use a lower coding rate, which takes up more air
time.

And only unicast needs routing? So broadcast is dumb flood everywhere,
and the receiver needs to remove duplicates, and not reflood
duplicates. And broadcast uses the lowest coding rate, so giving the
biggest coverage, but takes up the most air time.

> gn packets contain a gps position and a geographic target scope, which
> can be one of predefined shapes (rectangle, circle, ellipsis) and
> dimensions of that shape (radius if circle, length and width if
> rectangle). Hosts with a position outside the shape may recieve, e.g.
> a broadcast, but drop the packet (because it's out of the target scope)

So the sender does not care about the shape, it is the receiver which
does the filtering. And there is no concept of a receiver which is
outside the shape being able to fill dead spots by transmitting back
towards the shape?

> There are location service (ls) requests, which are used to query
> nearby hosts for the location of a host out of the sender's own range,
> which are answered with ls reply packets.

So this is a flood search? Is the outward path recorded in each LS
request packet as it hops away from the sender?  So when it reaches
the target, the reply can be hop-by-hop unicast back to the requester?

> I would suggest to handle them in kernel space and only notify the user
> space, if something happens (previously unknown beacon recieved, ls
> reply recieved, ...) instead of passing all the beacon and ls packets
> to user space.

We generally split policy from mechanical actions. Doing a routing
table lookup is mechanical, and goes in the kernel. The policy of what
to put in the routing table is generally in userspace. If you think
about IP routing, we have a couple of different OSPF versions, BGP,
IS-IS, RIP, EIGRP, etc. Each implement a different policy.

It also seems like there is some scope for experimentation here with
routing. A node at the edge of the shape receiving from a node in the
middle of the shape could consider where its neighbours are within the
same, and set the coding rate for the broadcast based on the unicast
coding rates to pick the highest rate which should work for all
neighbours, so saving air time? And rather than trying to maximise
hops, you could try to find an intermediary somewhere in the middle,
so you balance hops and coding rate/air time?

That sort of experimentation is a lot harder to do in the kernel, it
is more natural to do in userspace.

> > There also seems to be a need for location information. How does that
> > get into the kernel? Is there a daemon for that? Patches to gpsd?
> In the first version /proc has been used, after that ioctl; today
> netlink generic seems to be the most reasonable option. We used
> standard u-blox gps recievers and wrote a little userspace tool to
> inject the location information into the kernel space (via ioctl).

So it would be good to include a link to your git repo. We generally
want open user spaces tools. And i would expect a generic solution,
e.g. using gpsd, so any of the GPSes supported by gpds can be used.
However, given the simplicity of the API, this is not a GPU after all,
this is less important.

> That brings me to the question, how the ideal interface between user
> and kernel space should look like for this module/functionality.
> 
> For short term, it should be possible to strip the routing stuff incl.
> the cos table from the module and return -EOPNOTSUPP and/or -EINVAL
> when using advanced stuff like routing and only support recieving gn
> packets and send broadcast and beacon packets. Routing could then be
> added in a v2 patch series.

How useful is the stack without unicast?

    Andrew
