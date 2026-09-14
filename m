Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109633B19C4
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 07:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789370723; cv=none; b=FNmQVjTEcTP6lb209Pt8zHh6aGHrZxaBQ7LAw5envbiFgJ/rlyTl+oN/MitW93g1fespU8clbc2/uaRYnncRImqaRAy/itfViuMH0XVjaIsPEn19L8fiWhWXuSZwWC4e48PqicWSz/A974on9LZsdBg9LH1BFPrEuAf4U0MiJNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789370723; c=relaxed/simple;
	bh=ys8OYzOuRZ8J5hfWDd4nyv6C6OxmtSX9bs0Lh2fGK2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CA8PrYRPJ5BW7QqvMRX/A8LhraaMHUle8viF4c2O4I0ek2GcV9C7B/uuZVGi0GqDL7Qs7jog2QihOnj0CyMNxVS1XrDu/zMI3tJfCRCcSGrCZeOttqnjW10m+dtvaoaZQh+aqmbShd/ZkOYtLIxfuQyNUWwo6O5gUt1IdiB7P3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=IP+6smZJ; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="IP+6smZJ"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon, 14 Sep 2026 09:25:13 +0200 (CEST)
Date: Mon, 14 Sep 2026 09:25:10 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mac80211: verify if AP_VLAN belongs to the correct
 AP
Message-ID: <aqehVpLak6FWEpDS@nr200>
References: <20260910080454.725913-1-sst@poczta.fm>
 <9b3fd802df431355eb0784a79069e46a4e935e02.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b3fd802df431355eb0784a79069e46a4e935e02.camel@sipsolutions.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1789370713; bh=O8G8mLxiR2xe8SV8YEmiukqT/ZiFASYncP5iv+CdJ4M=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=IP+6smZJLNnABs+CR1ptsjDPZgKm+wh4rX1GZV45L6H4aUk5V61Y9YKxelG6olvft
	 FjO8MvqLcl7JPtXKv30zvh/eRWBzwOY9i2rnXw3AnOt38GFOHIOsWbBOu5LdsVNWLf
	 XedA1M52LKYMFWgcoO0LlVgmQsAx/a/UXal565eA=

On wrz 14, 2026 08:27, Johannes Berg wrote:
> On Thu, 2026-09-10 at 10:04 +0200, Slawomir Stepien wrote:
> > The get_vlan() only checks if NL80211_ATTR_STA_VLAN target is an
> > AP/AP_VLAN/P2P_GO interface on the same wiphy. It has no notion of which
> > specific AP a given AP_VLAN belongs to. Without a check in mac80211
> > itself, NL80211_CMD_NEW_STATION and NL80211_CMD_SET_STATION could
> > add/move a station onto an AP_VLAN interface that actually belongs to a
> > different AP on the same wiphy.
> > 
> > Reject the userspace request unless the VLAN interface's bss pointer
> > matches the bss of the interface the station is being added to/belongs
> > to.
> 
> Hmm. I thought I mentioned earlier that AP_VLAN belongs to AP whenever
> their addresses are the same - doesn't that mean this validation can be
> in cfg80211?

Yeah, my bad, I've fixed on mac80211 in my mind. Let me check how I can compare the addresseses in
get_vlan().

-- 
Slawomir Stepien
