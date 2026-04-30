Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E5234405B
	for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2026 06:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777529374; cv=none; b=dWKS9oZjPvpyjS2LCA6kXqMKVry0upv2wm2xjXZVg82QKKJZVHt5Ht2BLRDbnu1d/X5RRCuhrlzvQO/lodzLfj0ygC7or/ladgUlE/rz8rM4yx5nP7Z7995LU0ubOlFqhzYXQQFHaAWaD3UECxlEeSkUo0L4KkrdzNGxEG+0QJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777529374; c=relaxed/simple;
	bh=3EWRZUhK3rT4WiA5eY4m6Qc1+BGLpbzAdVNaQ9oMjWo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PTV1GNfsQh73GzGnhLAWeiDH4LS8EmPoV081HZ5YYZQ5K7fS4aTFMFgkzJYYAP9vuYbbVyZZ2iEifXhi7mKk8b/a0zejniGngMIQnBD/LM4LxD7MyiQMhBX/Rb7gna8XKuBLfnZwhRRbD0ETHK/Tvvt+NwGJTNUPab7EFlnDtJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Zu4KPyYO; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Zu4KPyYO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=3EWRZUhK3rT4WiA5eY4m6Qc1+BGLpbzAdVNaQ9oMjWo=;
	t=1777529372; x=1778738972; b=Zu4KPyYOsFPcMugRjh7gibyzd9hKAeLmK77x+HDhRYk1ECj
	1CdDG917S5GAL/5WMBgiB8TBqq05nH7nlNK5cz3g0XcEyitDt0JEPsFTOq9Nni+iD9BuvwAuiZNDR
	0TDTdvRfN5ImbpE9YEY3dRJ64wDtjurDGqUhw2zGJDBrl5WlPwpQ7WbBXORzvNbYMVf3tIv9I0CgQ
	BxgirsBuIFOUaM99tWHJcl0K6U24L6kzVl1bx9N8kHZ1IqIMB/fKWe8fvKgxOJKYNyJKjuB3Kl2RE
	RgNuSx0MFah6SUCW1GIwrAZClxCZMPCnAL4MAYtr+yVnWz5xGVGM+oNh3zbkjIcA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wIKaR-00000004aU1-0UWx;
	Thu, 30 Apr 2026 08:09:23 +0200
Message-ID: <303a561b972f7951584c18218f92e0af1e48d6fc.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 00/31] wifi: mm81x: add mm81x driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: arien.judge@morsemicro.com, dan.callaghan@morsemicro.com, 
	ayman.grais@morsemicro.com, linux-wireless@vger.kernel.org
Date: Thu, 30 Apr 2026 08:09:19 +0200
In-Reply-To: <ggbwslzjowets5nq76nkws74hekllwpza4jie4m65edjk22l4s@rv7cbk6vlrgw> (sfid-20260430_074356_345909_AA1031AF)
References: <20260430045615.334669-1-lachlan.hodges@morsemicro.com>
	 <ggbwslzjowets5nq76nkws74hekllwpza4jie4m65edjk22l4s@rv7cbk6vlrgw>
	 (sfid-20260430_074356_345909_AA1031AF)
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

Hi Lachlan,

On Thu, 2026-04-30 at 15:43 +1000, Lachlan Hodges wrote:
> Johannes, this version was auto delegated to my patchwork due to the
> new rules, but since this is still under review I have delegated them
> back to you (I hope I've done that right :))

Sounds good. And as a bonus we know the patchwork delegation works, and
you have access to modify things ;-)

johannes
