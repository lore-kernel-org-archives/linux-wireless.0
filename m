Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB222472AF;
	Sun, 19 Jul 2026 16:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784478104; cv=none; b=KFoyisL5XY3bFR3O7oWWAa3o3NZMgWWaeTTtFZQ3f8tPuLEo3yADfv0qiFlL1F82r0Rsd/8naCxhO97HzrF63BZZ+0PcEd5Uii9/zMuLqdLKsCBVKwpNAuNNsthrf2TaFXSbr9WJAq5w5Fhbs82YdV/e2hoFGKMlJnfwfcNAnKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784478104; c=relaxed/simple;
	bh=qJDsm+1H+0RCYLmhtkrGSVDe6OyTsvj5id+X2Q3D490=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oeBB3JjsPIiO2Fb1c26B8Azy3/aLS6ojRR/E171d9aUcgs787Gkni5Wjt2neC3+UctbY+a0uOcak58UMnZSSv4REKBw8XPjD1u/j/KB8/vYhyQfap83r/3tp/P8a9B06/LybZ9+AeMRzCHvGyC42p3CrIqvfgb1IvzOiXw6vXlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=eRZMvZ44; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="eRZMvZ44"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=Ruq8iipBlYZJsuapdYU5ZF4VaOzSi3668kvvhkMucsI=; b=eRZMvZ44RzlfXwqVf9lFtPCMD2
	aIs42/izjjVJA7Qu31FZx6jZk89WKvxaz4clEucY1Lo7ytqSlpeOGtMC2vGrJAl4WZdVkw9qXHiJF
	doUdXCoimiG6xf/tDKAxF9SQJoqCoayj8ZjsGvKvkTSplhiIzyWAhTaZdLY3zYY8jaPU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1wlUGl-00D6mq-B0; Sun, 19 Jul 2026 18:21:35 +0200
Date: Sun, 19 Jul 2026 18:21:35 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Simon Dietz <simon.dietz@plantwatch.de>
Cc: netdev@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, johannes@sipsolutions.net, kuniyu@google.com,
	linux-wireless@vger.kernel.org, dietz23838@hs-ansbach.de
Subject: Re: [RFC PATCH net-next v0.1 0/1] add GeoNetworking protocol
Message-ID: <89b3aa8c-f2ec-4b27-b5b0-5891d870e001@lunn.ch>
References: <20260718210046.2357882-1-simon.dietz@plantwatch.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718210046.2357882-1-simon.dietz@plantwatch.de>

On Sat, Jul 18, 2026 at 11:00:32PM +0200, Simon Dietz wrote:
> Implement the GeoNetworking / ETSI ITS-G5 ('net/gn') protocol which
> is based on 802.11p wifi and used for vehicle2x applications. It is
> standardized by the ETSI and used by some car manufacturers
> (especially in europe). It enables ad-hoc, multi-hop geographical
> communication and routing among vehicles (and road- or railside
> infrastructure).
> 
> Most work of this implementation has been done by the bachelor
> project 2018/2019 of the operating systems and middleware group of
> the Hasso Plattner Institute, University of Potsdam, which the author
> was part of.

Hi Simon

Is there are architecture documentation somewhere?

One of my comments was about routing tables. Should there be a user
space component determining the routes, and the kernel just has a
static routing table? That would be typical for IP.

There also seems to be a need for location information. How does that
get into the kernel? Is there a daemon for that? Patches to gpsd?

    Andrew
