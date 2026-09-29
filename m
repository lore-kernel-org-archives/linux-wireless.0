Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFEA2AD1B;
	Tue, 29 Sep 2026 19:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790710484; cv=none; b=gLgPcyxJjlCuRCJAqptdkpVDUQ4wyfOYNXRI88yJ2WA9za3tk/jRQAi1ewNL/2C5tOQRlylftxvV+pt4ERlfAENyVL3w1YsUxYMX/0wuQRrSErpFc0Tra4HRLyg+c5e1C1gW+vNoJbDAZOp90Tpr+txk3u7Grzffc9u87RpRnIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790710484; c=relaxed/simple;
	bh=y7XfGMrBX+DxkMWrLuqn10YVEymOK7yb2ayLRmMp/O8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ih2qkobwOaXlopdyDIhPEaZriONQxpRHJL72GY2Y+HfbXwWbG5gNv6wftnFmj9u51ncXuw5xfE4CZFeCr3F4t35jTSzVpFKh+c9v7+9b73xnYMOI/kgJX7vM6H5+NJff0JkAdqA13wi1YX0q/NZdSEUy3p8nQGjRRhCgqZBs2fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSkAu2Sg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSkAu2Sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDEB1F000FF;
	Tue, 29 Sep 2026 19:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790710483;
	bh=fG/J3vd/B9A0cwpUSTgiyouooSSQ2j/8aAKitxE1DSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MSkAu2SgPxb5xXZWx9l7m0CIIvimRdJmk1aorgz+3V5URkU/bootHHdS4ashK/AMC
	 aES4Z14XCg90aWTZWxF4nTE/QDAzxpXgwKDDD6loS4E4o4JUy76AbiXJ4WxfeOBL7k
	 +XRocKkHgEH4wpQGohqSZQQx6pC0ElnIjdbSreC7hH8kTGIBC0pLicRRe1D0PIxwnp
	 nc1KSErgpgcEbf93xW8LWEz/UCDFtaBEtu8kJbjOqANmDJ/6/QYcfT0LnjcVY7tNSF
	 uZb57CLxJnGaYHrzBevh/YDXD8yBLwK5su/N0sTDw/shkZXR/bQV7DmQKnz4vMeUpC
	 pmwTK4TPPbUyw==
Date: Tue, 29 Sep 2026 21:34:34 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Cc: Marcel Holtmann <marcel@holtmann.org>, 
	Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, Bjorn Andersson <andersson@kernel.org>, 
	Chris Lew <christopher.lew@oss.qualcomm.com>, Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, 
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: Re: [PATCH v3 2/4] net: qrtr: Assign unique node id for MHI endpoints
Message-ID: <m657dtesuagn7vdajsuzjb4mfysf5xabsu3s6n6lujj7yb3z4p@m2e7e3n4zyev>
References: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
 <20260922-qrtr-multi-ep-v3-2-c00831e88957@oss.qualcomm.com>
 <7aed969d-0868-4c9c-967e-7766dbba427e@oss.qualcomm.com>
 <13BFC5B0-77E6-48F2-B857-37686EA1DB2C@holtmann.org>
 <05e539f8-bb7c-4038-8a83-8ab0d1a5b917@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05e539f8-bb7c-4038-8a83-8ab0d1a5b917@app.fastmail.com>

On Tue, Sep 29, 2026 at 08:16:50PM +0300, Juha-Matti Tilli wrote:
> On Tue, Sep 29, 2026, at 20:05, Marcel Holtmann wrote:
> > >> +#define QRTR_NODE_HOST_BASE 0x10000u
> > > 
> > > Can it be exposed with include/uapi/linux/qrtr.h also. There are user space clients like modem manager
> > > which need to calculate modified node id to distinguish same service from multi modem over mhi.
> > > This is same as wlan use case.
> > 
> > did anybody actually looked at the proposal that Denis and I came up with. It was exactly addressing this properly.
> > 
> > It seems you guys came up with some hot fix and want to run with it. After month and month of silence and not bothering to review the proposal, you are trying to push your thing?
> > 
> > If you don’t support userspace, your proposal is broken. Plain and simple.
> 
> I'm still willing to submit a new version of that patchset originally by
> Denis, if the kernel devs so decide that it's the way. For example, the
> "radix tree of radix trees" approach could be replaced with a hash
> table.
> 
> There was also some criticism about a layering violation in storing the
> endpoint id to mhi controller. However, maybe that could be reduced by
> providing a correct abstraction around it, so that other code doesn't
> touch the mhi controller structure directly.
> 
> Other criticism for that patchset by Denis was its overt complexity.
> Yes, it has more lines of code changed.
> 
> This dual-card setup needs to be handled somehow, either by Denis's
> patchset or by Manivannan's patchset.
> 

I wish to go ahead with my series as it is simple and tested across the
multi-WLAN setups. For concern around exposing the nid to userspace, I'll
implement it in next version, thanks!

- Mani

-- 
மணிவண்ணன் சதாசிவம்
