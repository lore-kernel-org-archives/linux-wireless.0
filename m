Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AC9415F28;
	Thu, 23 Jul 2026 12:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784810259; cv=none; b=UiFS3XdYLkii4uheTnuUXWj/DZDgDd1IJNWQRW22nPezY87cbPYKjHhf1uqkM9TPHimXTiYztSDQvePblDJE2vjRXBjP5ts+4boU1kKKk0HMYP60jLQCDfIkuFqIY+F99UsAN94FbBU43st9k90RnBhWlB9ESaw4pGTNlAcyy5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784810259; c=relaxed/simple;
	bh=IVI/bIpXXKp/JwUgdG45QQ5y5P7lSSROBy4SbKW1+iQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HuHlNzIo2Bu8ptvne0Zgl+snOgWkciUyGq4wDX32kRy0a7oBLPF8toTjQhdUvM7Z1Z/lPibSL4TWraZjmgGkz0GcTDePagBVd026wILwf3h6m4zUaQp+WxRZl+evXubCENncvwcpEWmKqpo+epSfJzENwcSYoh1Tj8xHrjg+Mq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=gi8Z5jh9; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="gi8Z5jh9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=IVI/bIpXXKp/JwUgdG45QQ5y5P7lSSROBy4SbKW1+iQ=;
	t=1784810257; x=1786019857; b=gi8Z5jh9psNWIe5s6wzth94npDVVe/L9YHKux3iuek7Yoil
	pUY6JKxP9g3MyuTjFp7UtkNOrbQbKcJVK0VerlrY+YVFOIsGtT6uXvk1tagtU4kq4ynZ5NI3YhMwq
	bpWw60bYQF/IM2oTwSa3cp9zo3tsn3uYSsbHlhQ3zgodg0MJY1yXBAsikEsa0+AMR0dukQthCo3zi
	yUPUnd2I6hEruJEFr9/HmucuLfxA4OQQt+pM86Vy5ZtEXSVPVPo/7NhiP+7wQREu13KA1sG5mfHX9
	A+qSlGmNLcSFTCMjGtHavTHZykSySMnn/toKT94IrfrFh3cKReIqyUIRYD9GZJ3w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmsg5-0000000BuKq-1Krp;
	Thu, 23 Jul 2026 14:37:29 +0200
Message-ID: <127c720f9ceeaac6ec3872bfc7732ab27d968dfc.camel@sipsolutions.net>
Subject: Re: short description of GeoNetworking
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lunn <andrew@lunn.ch>, Simon Dietz <simon.dietz@plantwatch.de>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, dietz23838@hs-ansbach.de, 
	edumazet@google.com, kuniyu@google.com, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org
Date: Thu, 23 Jul 2026 14:37:28 +0200
In-Reply-To: <70e14ff7-fa2f-42a9-b880-a6adf5713c10@lunn.ch>
References: <937e2942-3c0d-4583-a741-8a96c4e0bbc4@lunn.ch>
	 <20260722213437.3593569-1-simon.dietz@plantwatch.de>
	 <70e14ff7-fa2f-42a9-b880-a6adf5713c10@lunn.ch>
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

On Thu, 2026-07-23 at 02:30 +0200, Andrew Lunn wrote:
>=20
>=20
> Closest to the target. Opposite to how i interpreted it. I still think
> a device in the middle might be better, but that needs a true WiFi
> person to comment on it.

I didn't really want to comment much on this, but I guess you're calling
me out ;-)

I _think_ in 11p there isn't much notion of being able to do rate
adaptation, so it probably doesn't matter (much) from an airtime usage
POV (if the frame makes it through at all). From a robustness POV it
might matter more, but then it also depends how you select which
stations you consider to be reachable at all.

As for the user-space vs. kernel-space split: clearly, only highly
specialised applications are going to be able to=C2=A0use this socket famil=
y
at all, not only because it's a special socket family, but also because
they're going to have to figure out where to send a packet?

Or put another way: for each packet, you need to know _where_ (as in
physical location) it's going to go, so you can pick which peer to send
it to, no? Is this really a *per-packet* property? If not, then I don't
think the shape calculations etc. would really need to be in the kernel?

In fact I'm sort of asking myself if - since the applications are so
specialized - it even makes sense to have a socket family for it? Not
sure, lacking the high-level design context I guess.


A bigger issue with this might be that it's clearly a small piece of a
large overall puzzle - Simon, you mentioned a modified driver somewhere
I think (can't find that mention right now), which may be using the OCB
support in the stack, perhaps, but also isn't upstream.

> So looking at it from this perspective, how does the Linux Foundation
> Automotive Grade Linux fit in? Does it have a V2V stack? Is it kernel
> or user space? If they have a full implementation, which is open
> source, but just out of tree, with a range of applications, would it
> be better to spend some time to clean up and merge their code?

And then also related to that - it seems these would be very specialized
applications to start with, how do we get anything useful out of a
socket family without them?

johannes
