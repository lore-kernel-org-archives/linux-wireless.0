Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F991DED42;
	Wed,  7 Oct 2026 23:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791416178; cv=none; b=a+CFU6yxOa5s36muPOQu9s+QQ69jZei4YDM9lpMmwzUJZ07mMEWlPpNrl4BN1rBKYsvWkoA5dC1eYZUjc1eg19JPP1ZIH1mmLRlyHl0HGiL0iphNNc68R9oExeIVA8wLYtu7pgZsYnQKgN999aWj9WhHYK1Snim46ENkNCI+lVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791416178; c=relaxed/simple;
	bh=WAtsyR3IMXHkFwGaR8H+DzUJjsghz/U6TTUvUrOWBdY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZCUb6Kzn0ktxT/C9zG7jzdxVwTxKpEBmuGnp25Q0cXLFL4SNHOEgn0kP5oPVTGNl6P8G0kzULbmDhmtovUL2YPapSuPHdB6PS5+3N3Srp8GPLO56/ZO4nI/FLEpkdiReMsZcYoXXZqurW9Xkob1flEOeQU3f4tGxesZEdqL7eB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g675SK+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g675SK+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF5C1F000FF;
	Wed,  7 Oct 2026 23:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791416177;
	bh=T/lBhqG9M/WC30ZwIL8Bl+zdXOnryYrrFo07SgpP4iA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=g675SK+77V93tcEDh/P+lKNCv97KgF2wL2T89BbTrmSm9HWL5wizgQmAQAvpAx/b0
	 6dCJzKctMPd9Q7MP9Rk+1/qqExO0BXwfe0l/GsMiwdV1MYpzz1/T74lSHodV4rlG2Z
	 JqrddoEqUWUwbB10ARTwPI7amdytKRCrNvol304hGQkrOXWxAARkAnyrt1AyEKm3BN
	 TA22ykN7gpnsIhZuXtdhGlr6KzQSMXT09BT6Rw8A3CvGv18lHLV9yQ3d9+mq4jvbrj
	 kb6hQt+d9ZuW89cXgSS5xDNzv8tgzeoBmPvoXlhMzPirkLcUA3Ou969/3rlGM12Di9
	 rFF4676dOcQQA==
Date: Wed, 7 Oct 2026 16:36:16 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>, Kuniyuki Iwashima
 <kuniyu@google.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [GIT PULL] wireless-next-2026-10-07
Message-ID: <20261007163616.1088d364@kernel.org>
In-Reply-To: <20261007205827.467974-3-johannes@sipsolutions.net>
References: <20261007205827.467974-3-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Oct 2026 22:57:00 +0200 Johannes Berg wrote:
> Nothing much going on in wireless-next. However, next time
> I hope to land my RTNL-redux series which will (almost)
> completely wean the wireless stack off the RTNL, except in
> places where we need it for netdev register/unregister/etc.
> 
> I need to see what's going on with the per-netns mutex now,
> can we already use that instead?

That's a Kuniyuki question (cced). I've been trying to move 
HW drivers out of rtnl_lock and under netdev->lock.
Most of the rtnl_lock contention I've seen in prod at Meta
is in init_net
