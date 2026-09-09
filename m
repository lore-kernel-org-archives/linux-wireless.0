Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE67D3E832B;
	Wed,  9 Sep 2026 20:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788984798; cv=none; b=Z+RhZXUsbOAFGfr9ydzoPJRdtzK5SGPx0shmyMf1zdjmVwOe4e8J0kuvCLZsIVLTAVnX9lyl99hA3IKOupyU+8TTEvKnaZbnVDhcd+m+W6fSup3PWJ9CN7yBaUg+7L+TlIMUhVasPfs2xz/t4pwTH4CGrQh9pXG+itDaPD+bjTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788984798; c=relaxed/simple;
	bh=bnC9i/qyrIrvmIuMX4qik5bvAcDw9t6bIP1TOqxUKNs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=djI+JZo3oAZTEiZWD1hWH695/NwEjlGbESRJ95sOW8wCfzU2ZzNutJ7r2Cg2WExD9tSBshi/DfFuDSUh8uVG4BgLSJAiv1XUGeRvpJwQ8XBryp3JpuQHfhpnb2yPrD7TwQzoKfHsOVjZ06Gu1Mj/IVLjrK0V+APBHEideaCveWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DR/n6eKN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DR/n6eKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2E31F000FF;
	Wed,  9 Sep 2026 20:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788984789;
	bh=3ESmjIDaAZL3gvYROvt+bUtd2dtK8PDyuE2Z4g7MRIY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DR/n6eKNdaynq1gsYXZ/BwaPHXNus9E3/0vj6BrXjMblDdcaFAsb7h1+ttvROLj/Y
	 VilZ8LrOrckcLoYRbIN9ipl7TELaiWdUpXt7ibYsNdxhcwuXBx1ELanUKtZ5JA+/1E
	 TR6IUorEcPrV/Fsrqd3d4br5LbvBd4sPgV72V1aMWdcr7q8QDJujAjyqXuCNUaPSwz
	 EzI88LTScrLZ9J6XTytdz9a/C/Z3XYXK1DJ04o7Gx6cSXZqfZ+JY8hbCFsvKVtIJL7
	 pgFY16M4J0CDcrfvo3NYHiX6BUL/hu7jHYIAA3CX5hybZnbLfH9PTS6FN5rcjn/SKN
	 Ztil6yC4LQ0QA==
Date: Wed, 9 Sep 2026 13:13:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>, "David S . Miller" 
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni 
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org
Subject: Re: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility
 Domain (SMD) AP support
Message-ID: <20260909131308.6bda08e0@kernel.org>
In-Reply-To: <0e950f7f0c3f5a2c1f6476e255716b09876624f4.camel@sipsolutions.net>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
	<20260908125017.0fb226c5@kernel.org>
	<404004c4c97bf776077685b7ec33a14fa777cd70.camel@sipsolutions.net>
	<80266eb9666d6106110d998cb6330868da55bf59.camel@sipsolutions.net>
	<20260908132004.29176fec@kernel.org>
	<0e950f7f0c3f5a2c1f6476e255716b09876624f4.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 08 Sep 2026 22:27:52 +0200 Johannes Berg wrote:
> On Tue, 2026-09-08 at 13:20 -0700, Jakub Kicinski wrote:
> > Ah, missed the skb extension. Obvious AI slop. Fun times.  
> 
> "Look Mom, I can push a button, I'm an engineer now!"
> 
> Do we have rules? I'm currently refusing to read anything that has an AI
> written commit message ... at the very least.
> 
> While I was on vacation the AI sloperators were arguing with each other
> on the wireless list:
> https://lore.kernel.org/linux-wireless/20260827074442.826644@enxio.de/
> 
> Can I ban those email addresses somehow?

We have a bot in nipa (mailbot.py) which follows the mailing list.
It can already update patchwork state.
I was thinking of adding support for bans there, something like 
 pv-bot: ban-1mo
and for a month the bot would respond "you have been banned, bla bla"
and auto-discard patches from patchwork.
That said I haven't gotten to the point of wanting to ban anyone yet.
Most of the "contributors" excrete 10+ patches in a day, then get bored
and disappear. Corporate slop may be more persistent tho, Qualcomm
employees must have gotten LLM access because we also saw slop from them
on netdev. TBH I see similar problems within Meta, tho. Random people
who can barely master Java now try to contribute upstream.
No idea what to do about all this.
One obvious thing, I guess, is that we should no longer feel obligated
to provide any meaningful feedback just because someone posted code.
