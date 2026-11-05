Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793914076;
	b=FhRVzjDb12ZC7HwdKAbUkw1l9HXbE4xamO5vseohIio5WdZ7irUFmPWfz3LWbbC7JtrH
	 kBtKcu48SNm9dv1EMcDN+HSmPyyC849d18r4SfCyPQhj8GIMZWYHrJGF0Ryk/+hkQLHo7
	 19JKzccFRabTAEoTdQ7FDyUnX0Jn/jf4toNb2NAWVtK+RIIK0HJ0D3RYRSug6KWKig0Iq
	 lbp319cfZhqP2ynZtyYh1s2/G5etEiTIpVIXwALd6lOEaJgU81IRgeRyGqszei23nsBWh
	 8kfwvVIyqDhCtcstjm/g9FBioSTR9IMO+Sy2ArDD1vDIxa4J95dNH67bEMJREEQWkjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793914076;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Date:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version:X-malware-bazaar;
	bh=qhO/oRvCr/o7gGAmyE7JOEVz/eO2LLZJ4uT0NKd8qiY=;
	b=sDcm9A4lyZieATRmXwOHpwA6ZXB57PUniKd4EpvCVJbHii0+Qty9YuJMZjUTRgRvi5m5
	 vvgDN0GsIE2OyNZLB1AnZ/DlNE4SGzZxM9HcvMkVbOoKqeBn7mfwwzRYNc6GtN4k7LM0Q
	 Dczj4m0BjRxpMNcA/2SlS9Mg3fOsXynFcMSncaOsdHFG5mQXqd6FlejykcLRYl7sycOBJ
	 zlIN9tujmPU/CmBnKYZTDfFg6PVnnoZObTmoa/uo/naj9vHFIIV6YKUEkvnZW8e6gXaDw
	 WK86WbEAF8i6AhQ58l3qvFe59XZwPJL198uZw0bWwdrfeUf9jaI60rG/HTGMpwCiBnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=vd6gx8rT;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA56606A32D
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 21:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=vd6gx8rT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=qhO/oRvCr/o7gGAmyE7JOEVz/eO2LLZJ4uT0NKd8qiY=; t=1793914075; x=1795123675; 
	b=vd6gx8rTLK7RiDeSLa4m7p2H2pHTNgfvzxlG4i3LgasNaoSI6RDEjhxUTBCprU/5r89vPv8Hy2N
	m8J4NxT1xWEUn4TBxkd1H/x7SthgQjbbmWWtIHto1mhs91cDqzqOfLt4flw6UKPoexvkUFBIK69Us
	LLtjUo0X2PBzJXZ14rTt2TBv4wGpsvyJKVA4V2Gz/nOpmKrsVN+8rbQrbM4KVuOQx1Ssptz7cutRL
	OVazapKQl0VUN53xzXpzhGfiDTXDaAcOYayv78oXg3GCbwFKRfVLczfwI6LnB0qwz10udDJ9Y8jeG
	DwsE1UeCIOJi2rK1K6H4rwIsvhGTBu/moBQg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xP4zx-00000008doE-16yM
	for linux-wireless@vger.kernel.org;
	Thu, 05 Nov 2026 22:27:53 +0100
Message-ID: <bd754f1c4187be8139d82f0387fc9f561ee74696.camel@sipsolutions.net>
Subject: [ANN] I will stop applying driver patches
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 05 Nov 2026 22:27:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi,

I'm not writing this happily, but seems I have no choice but to declare
"patch review bankruptcy".

When Kalle stepped down close to two years ago, I thought I made it
clear that I'd expect everyone here to help review patches, especially
driver ones, if I was going to start applying them.

Guess what didn't happen.

By my count, excluding iwlwifi and hwsim, I've applied ~360 driver
patches since, of which less than half have any Reviewed-by/Acked-by
tags [1]. In turn, this probably means I've (had to) review(ed) all the
others, and almost certainly did review more since I had to handle all
of them.

[1] I have an agreement with Arend that I apply patches to the
brcm[fs]mac driver, so those are included in the ones with tags.

That number doesn't even sound that big, but it never was something I
actually wanted to do, and never mind that I also applied 565 wifi stack
patches (plus ~300 of my own) with 22 (!) review tags from outside Intel
(where we have a process in place, so many of our own patches carry
reviewed-by tags) in the same time.

I also currently have/had (see below) another set of ~80 driver patches
in patchwork assigned to me right now, and 239 patches overall (though
about 1/3rd of that are probably my own [2]).

[2] which is a whole other problem, I've obviously also spent time
writing them, and almost nobody bothers (dares? [3]) reviewing those
either (at least in public)

[3] surely I must have a reputation for being acerbic ... right now I'm
just tired


And then ... at the same time, a lot of people really like to pile on
pressure:

 - regressions/bugs must be fixed 'within a week' (hi Thorsten)

 - patches to decades-old drivers are suddenly so important that people
   want them applied yesterday

 - roughly a million people who figured out how to push a button in an
   LLM chatbot think they're entitled to reviews that they immediately
   not read but just feed into said LLM again


So that's it, I can't do it any more. I'd say it was fun while it
lasted, but honestly, it really wasn't.

I don't know where we go from here.

I don't even know if this (alone) will help get my workload back to
reasonable levels, just the wifi stack alone feels more than enough
right now. Maybe I'll come back in a few weeks and say that I'll only
ever even read/apply patches from people/groups/companies who have
enough Reviewed-by lines themselves, or something like that.

I don't know if maybe someone will start maintaining some of those old
drivers and send pull requests, but right now I have no reason to think
there's anyone interested in it I'd even trust enough to pull code from,
almost nobody has shown that they even are able to review patches in any
way. I suspect the intersection of the sets "people who know anything
about the code" and "people who want to change it" is literally empty,
since everything is clearly just LLM driven.

I do know what I've done with the patches - I've delegated all driver
patches in patchwork to the 'wifibot' account (because nobody runs it),
and set up an auto-delegation rule.

And finally, lest this be misinterpreted otherwise:

I do also really like the actual technical work, figuring out the design
of how all the things fit together into the bigger picture, having those
discussions with people (!), thinking about problems and trying to fix
them, etc. So I'm not going away, I'm just saying I need to focus on the
wireless stack. There's more than enough going on to keep me busy for a
while yet: SMD transition AP & client side, NAN, (UHR) critical update
AP & client side, UHR mode management (client side), general
improvements like the RTNL work, latency reductions, TXQ work, etc.

johannes
