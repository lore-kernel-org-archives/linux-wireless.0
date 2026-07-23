Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E238634C;
	Thu, 23 Jul 2026 00:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766636; cv=none; b=LWZ4RTdzwRtKjOAZ3tkPWFJ/XOEnLHl+kCxphUXzMiNFHjU3gXUdlNEB6/AmrMHHPtKuFQbqvWPR8S3LjcIB054KKlXYGVVyc5igXUT+c3h6XlWfPzNon9bsgvYMxqw1OavCnWnblGmFr5+KgSV/Ci7B5inIlU+jcxT/8/6KtQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766636; c=relaxed/simple;
	bh=wiUKXVPSQhbQfqhadkLxD5C8osxFBR6gmbjqYytYsoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SpOe/Bewa2EoiNgbYsJK4l8vFzupNWDIvXhItBhXk3PBvlUBDNXWcLEAr5qcCpqS/VKRpo2PxSlvO0jw64+VSdpSLehU+R1lGt8FsQG5Uj/ScOxfSEb/Em4bUBSiYmDy1VHrkQuc219naswWYzD3SvfoAbv2CpPSd2V2jPam6zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=DVcH2MAI; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="DVcH2MAI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=ouQIFpyuWdJrpFFaW+NrPMyErzpQb0SxrxolxQwB7Hc=; b=DVcH2MAIlbuKW2D0qaXEKaTUkv
	L2XwYWytV5aZHa9eZCoqqbyD5pjJtlIpa/nJ4gBUnItpNLQ2hFrdUnNzTWBmF+YPgpUEropcasA2i
	ZaSvYHAW85OKdrSlwNlIDlekaO/DM11o4Bi4w4NMhf3fYhPQ/eJG12V4wz75z8yqWj6g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1wmhKD-00DiVD-FB; Thu, 23 Jul 2026 02:30:09 +0200
Date: Thu, 23 Jul 2026 02:30:09 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Simon Dietz <simon.dietz@plantwatch.de>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, dietz23838@hs-ansbach.de,
	edumazet@google.com, johannes@sipsolutions.net, kuniyu@google.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: short description of GeoNetworking
Message-ID: <70e14ff7-fa2f-42a9-b880-a6adf5713c10@lunn.ch>
References: <937e2942-3c0d-4583-a741-8a96c4e0bbc4@lunn.ch>
 <20260722213437.3593569-1-simon.dietz@plantwatch.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722213437.3593569-1-simon.dietz@plantwatch.de>

>                                                                     to
> patch the ath9k driver to actually use the 802.11p wifi band (which is
> above the classic 5 GHz wifi 802.11ac band)

That is another issue. It make no sense to merge without having at
least one wifi driver support the needed frequency bands.

> I may have simplified the modes of operation too much, sorry for the
> confusion. Having the standard (ETSI EN 302 636-1) open (which contains
> a visualization of the operating modes), let me try it again.
> 
> There is GeoUnicast, which is the most advanced and needs routing and
> the cosine calculations to find the intermediary host in range closest
> to the target host.

Closest to the target. Opposite to how i interpreted it. I still think
a device in the middle might be better, but that needs a true WiFi
person to comment on it.

> > How useful is the stack without unicast?
> 
> At first glance, not very much. But considering the use case (e.g. BTP
> or DNEM) it is more common to notify all vehicles in range (TSB) or a
> certain area (GeoBroadcast) to e.g. warn them of a car crash than to
> search for a wrong-way driver and tell him via unicast that he is
> driving in the wrong direction. And it's two-thirds of the standard.
> Plus (and the most important) it would allow me to focus on more
> essential stuff, first (like how to properly inject the gps position
> data via netlink in a kernel conform manner) instead of aiming for full
> standard conformity all at once (cathedral approach).

So looking at it from this perspective, how does the Linux Foundation
Automotive Grade Linux fit in? Does it have a V2V stack? Is it kernel
or user space? If they have a full implementation, which is open
source, but just out of tree, with a range of applications, would it
be better to spend some time to clean up and merge their code?

   Andrew
