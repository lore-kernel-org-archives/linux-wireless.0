Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DF933B6FB;
	Sat, 19 Sep 2026 21:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789853267; cv=none; b=efiYXCD6diQLs3mo7iONbD0mTh9p0J4v2OSmDsPwq1/dj7Hpfsxpx7dBqAo109cHhJEKuQEKzV3WbU7Ytw+8rpyAdVLpzsBM89LATOv3TAr2NR59OpuZU1hQcpCsBPvAsqzE3tWu0mUBQ1Jwpp0+L5THQ7bKxGcvN8aK09hCuUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789853267; c=relaxed/simple;
	bh=nnKOL8NqdPAdR4FH+0ayTXxIoDFud+zD3rLOQKsvwVE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SL6LmmMwVzjHffzh3yfPfiRXA6+csAJjNqwLhVZP4RizoakBqME/N1gWERN75IK6fOp+iYcGAOkqXXaeeTPbMjGPsCNNZmcFCnU3TuDf+KJR+D7V1JHNr23MHr/Trh/c6twAsmvYEM/4pCqVk6Svl1ICTf4td2UjHjfZpbvpUck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXn5UcrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXn5UcrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229FE1F000FF;
	Sat, 19 Sep 2026 21:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789853265;
	bh=AO/Eu04UJkHc6pSrEXmXrNXJ1w9izsPoCjtzx+eKB7k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eXn5UcrPIov2YLgAUEs+GRTC+8uCr5IM1DP0vyBA2qlxh4fQK5tnoOvoWEaWgR4r2
	 U/3B5j/NxoS4SYFOzCfZ+gtTKqk9+7Op29pUVISKgjWk7qCuorDXWhZnVkkLH9CKW0
	 uoDNfzqFSVDROb47QsFnROg++blphKnKeKjHxk8IpvXIH1xDAHaCs+0r/KK0qBKkV2
	 /G5qb4/iOsUX/fkIj5XRMtJViPm7MtNpC+IOLqu1m+8naqg0UyOrjJRAap4wX5AyvO
	 /kcQ1jMEovLfvEO4ebv0Pl48VmcHlPV3WWjwyC5oLd6RwjYKnecyeqXxM4EMLRGvlL
	 REvYJP39Ig8zg==
Date: Sat, 19 Sep 2026 14:27:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Juha-Matti Tilli" <juha-matti.tilli@iki.fi>
Cc: "Manivannan Sadhasivam" <mani@kernel.org>,
 linux-arm-msm@vger.kernel.org, "Jeff Hugo" <jeff.hugo@oss.qualcomm.com>,
 "Jeff Johnson" <jjohnson@kernel.org>, "Bjorn Andersson"
 <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>, "Eric
 Dumazet" <edumazet@google.com>, "Kuniyuki Iwashima" <kuniyu@google.com>,
 "Paolo Abeni" <pabeni@redhat.com>, "Willem de Bruijn" <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>, "Simon Horman"
 <horms@kernel.org>, "Mihai Moldovan" <ionic@ionic.de>, "Denis Kenzior"
 <denkenz@gmail.com>, "Marcel Holtmann" <marcel@holtmann.org>, "Andy Gross"
 <agross@kernel.org>, linux-kernel@vger.kernel.org, mhi@lists.linux.dev,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 ath12k@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 00/15] QRTR Multi-endpoint support
Message-ID: <20260919142744.12982b1d@kernel.org>
In-Reply-To: <9837273a-c62f-456e-9aa0-567b0d3a6f29@app.fastmail.com>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
	<20260915154705.67cfb94f@kernel.org>
	<da6003cf-515b-4d97-8059-3f4553d0251d@app.fastmail.com>
	<9837273a-c62f-456e-9aa0-567b0d3a6f29@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Sep 2026 09:22:40 +0300 Juha-Matti Tilli wrote:
> Some positive news. There will be no next version, as Qualcomm is going
> to provide a superior patchset that I tested. It's easier to backport,
> cleaner design, fewer lines changed, has 1 author as opposed to 3, and
> most importantly, it worked just fine on my 2x card setup. 
> 
> Thus, I'm going to abandon this patchset.

Man, "superior" and "Qualcomm" in one sentence is really testing 
my resolution to be less sarcastic.
