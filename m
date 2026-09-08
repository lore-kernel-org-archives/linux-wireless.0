Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2CE3A3E7A;
	Tue,  8 Sep 2026 20:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788898807; cv=none; b=BDCQAl/FKUsEgOcA1FyA+oRSKdJKMD+I7JUIFiMNa/x4B/0F/H4FWxziIRWWNgT8H3YMZKTWHDZB7hWvvp8YW2Vzl2boTUYVht929SLmerXHdJtfaI2rVhEtrAkoctml2NqFnLyPzYy5i9/IP0AvsvEHotzU7fX5asBe7ZItHow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788898807; c=relaxed/simple;
	bh=wmMHnqxk8q60AJnJVVj3zTZJVm/HnV6zv0pQLk9pmgM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hfr4naVDAFfOS0sD6wE0u539pWr+bNT1evvBCIaGZOjKyJPlqYxLw3UifX5EykAvwVyzX0npxNmvTt+ZBA3eygvBvnJSCvFsw3Ee5TizwZCiLiMcr81YrHXAt5+tH2y9kd5k8k78Lrxa7mhHMA2quzLjkA6b1r7/0Ty06WKepBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOabZrJQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOabZrJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA45E1F00A3E;
	Tue,  8 Sep 2026 20:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898806;
	bh=YtM6ZBb5h2CRolygbcwA6f3pnESQ99pbKeVUhF3gqXo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OOabZrJQsOKcJEig2RJSsKwpur8+CO5YXZBKOvoFn4TeoZU1vRazWZD4F5bVZzD4W
	 mtX/5k+5VhjogmyQlbUhbrlGTDp3GGlZWGgw1z5LKv4adNYx/J1h/k1DUHtFmBacvK
	 E2g/2xi5nmszOZSnbrJ48RiGRcZTBI5ISkmR6qHBCKXW+MTxxh1XWkd0VRAmNewnej
	 kmeza6JjaGeIkAVfW1LP1siGMjiiRMS1EJ6yfQOXBdGg/ktqkT4HmHJhjfhYRIxTuk
	 KgTE8a8a6zAPapIA82T8DTaMAoUWBD4knb8g3qESHrwemWVo7ZaUrDtYFjgT2rd3Ve
	 BjcMyA2rFo1zg==
Date: Tue, 8 Sep 2026 13:20:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pooventhiran G  <pooventhiran.g@oss.qualcomm.com>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org
Subject: Re: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility
 Domain (SMD) AP support
Message-ID: <20260908132004.29176fec@kernel.org>
In-Reply-To: <80266eb9666d6106110d998cb6330868da55bf59.camel@sipsolutions.net>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
	<20260908125017.0fb226c5@kernel.org>
	<404004c4c97bf776077685b7ec33a14fa777cd70.camel@sipsolutions.net>
	<80266eb9666d6106110d998cb6330868da55bf59.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 08 Sep 2026 21:57:52 +0200 Johannes Berg wrote:
> On Tue, 2026-09-08 at 21:51 +0200, Johannes Berg wrote:
> > On Tue, 2026-09-08 at 12:50 -0700, Jakub Kicinski wrote:  
> > > On Tue,  8 Sep 2026 22:39:28 +0530 Pooventhiran G wrote:  
> > > Why are you sending this To: core networking maintainers.
> > > This is wireless code, what do we know.
> > > Drop the core maintainers and netdev@ going forward please.  
> > 
> > They have patch 1 but I already told them a long time ago that was
> > completely broken, I don't know why this is happening ...  

Ah, missed the skb extension. Obvious AI slop. Fun times.

> Actually, they did fix the free issue in there, but ... dunno. I guess
> I'll discuss it with them tomorrow.
