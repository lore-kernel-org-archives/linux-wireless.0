Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C14552E07A
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 18:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791915727; cv=none; b=QDGE5Y7p6UmBAS1f2B5M7RHwo/lVWXuGsWrI9iELnUNGMNBRYI92+k7uXY1ElvYQ1ieS6lABHVos4LBLBYJB6V2TlapK0VIS2ZTzNj//KWX5aQKp8YkgbnuQIvzGRMqUpZLIr/sVb6w4BYXtFKCSyqkoeUkIOIt4su4UO25Hm0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791915727; c=relaxed/simple;
	bh=1qSgBtvZcLztfzj2xS5hRI9jQXVX7deyMrzfui0US6g=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CobmdM3b8kTUurs8lWUfMyrrD3f/wjd223lpkfWupL2hrH8E0PtcmBwcCgiEerKQp5JaUecF6hLZTpmSK0QS/4rWkY/P6X3co0JaqcSu7GHWTPIfAaX10FSdHGt8W9JGRI83iBIhYm9XBLawAN+XwO05j62uZKov95pMawj3NfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=sioMloMF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="sioMloMF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=1qSgBtvZcLztfzj2xS5hRI9jQXVX7deyMrzfui0US6g=;
	t=1791915725; x=1793125325; b=sioMloMFnkqKJlxjOrxO/4fy7tnqhpkImu+Un7W1nvSaSzR
	IVFh+2rg2uVSKXDtTBWA/E0NqHSjxapbSJ4gAvKCfBzcU+oCsTKIV1Njs37wyzQ/nyvsHOoE+7/JH
	kKCd2GxbLstzjGIUEJB20FZ9S+5EEtLNzbeRrWyp3Rvfllap6xWBS593jSXteSc9mrXf6Ha7wEvuU
	tovmRzMrHNAeqT+HiCQuZJwCCKfnOJwb8Lee7Hjpdvp0qqJF/Ny2LZDW+XWn09JLuYqnmnIu1PbCG
	e4p4fPME65RStitw2JCTCQ5YwXWz5XEq1Smpk74Ayw4JsAfTVJ0gO+AqQ0azm7Fg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGh8U-000000005Xe-3kT7
	for linux-wireless@vger.kernel.org;
	Tue, 13 Oct 2026 20:22:03 +0200
Message-ID: <feaf62f6762bac17bc6e1edce2fc1d4d50adc3b4.camel@sipsolutions.net>
Subject: Re: [PATCH 10/11] wifi: mac80211: avoid tailroom accounting on new
 key installation
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 13 Oct 2026 20:22:02 +0200
In-Reply-To: <20261013150605.65fbe249d82e.Ie6b44dfeb421691898e1e181f38a6adfc780290d@changeid>
References: <20261013130604.254393-13-johannes@sipsolutions.net>
	 <20261013150605.65fbe249d82e.Ie6b44dfeb421691898e1e181f38a6adfc780290d@changeid>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-10-13 at 14:59 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> On a new key installation, going from not having a key to
> now having one, we currently synchronize_net() because the
> key is first assumed to be handled in software (requiring
> tailroom allocation, and that requires not transmitting a
> packet without enough tailroom, hence synchronization). It
> is then offloaded, usually not requiring tailroom anymore.
>=20
> During a new key installation, however, it's actually not
> the case that this is needed, since the key only becomes
> reachable to the TX path _after_ being installed into the
> hardware.
>=20
> Restructure the code so that the increment/decrement of
> the tailroom counter is skipped for newly installed keys.
>=20
> In the case of rekeying, this doesn't work since the old
> key is removed from hardware and may still be reachable
> by software, so the tailroom counter still increments to
> one until the old key is destroyed. This could be avoided
> with more effort, requiring tracking more precisely if a
> key is even used for TX at any given time.

This is well and all, but I'm starting to think we should just not do
this. Given that SW crypto really should be the slow-path, I think we
can instead simply remove the RCU sync *completely*, and accept that in
the race case, the (SW) crypto path may have to expand tailroom (and
might drop a frame if allocation fails).

That's far simpler, no need to add the RX_ONLY flag I did in patch 11
etc., ultimately instead of adding code it ends up removing some, since
we can also get rid of the dec_tailroom_needed_wk and all that.

Thoughts?

johannes
