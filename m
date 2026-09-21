Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3670F1A268;
	Mon, 21 Sep 2026 01:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789953462; cv=none; b=cMbVrJw4S4bGQg3fRHBBTOMLdLjE9ib472H6dfEzodxDSSEYg2p1fC9ISsENgDPvwl678k7gS4LuuZZJdE7DrU+Z0nCHb0Staoipf6Sm0lwC8H3G85HpRNxvyb940gtwpy7P6/Yns9ExeV62zYq5QpuZO0NMJvEYSdq5XnF0h3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789953462; c=relaxed/simple;
	bh=UQ8NBmTMd0E4UPS6zoz9vKry1PH3VwbAwCx0NIVupjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D5/dYbWZNHnlRd/JfdtN/ZMEhVtrN9uKNFGQ83CdB1EE0Q2KBR9UtKdvCzcjFcmAC/rQaG/luOt9xH756A1mDdQzJsdvRSDHG2sXHx0rxLuYKO8MqYUHik5B3x9f05pfkZ6b/M9x2eyNFmFwo0zy+iKJ1yrDeymVYguL6mGW5nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKkp+pe9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKkp+pe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACAB1F000FF;
	Mon, 21 Sep 2026 01:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789953460;
	bh=YDur6IwTSE7iTR0vxd9Zd48PXGF6FvROWSLYkOLIWkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OKkp+pe9xIpMgy2kIuEbPoZqVzeihqLQ6TA3Wyi8ZDStD+EeeVhcqIHBZahTRwweH
	 gDuQGyJGgLjdjZeKSS1Q1f/mP/OAt00rp2UnpAd8x9JboiDWnWQRIXUlUpiKJF8xN2
	 uwHi13TBks7vz1/jjQsf0kCMQguuDYhC7VISMQd34V/5j5d83h08IBRVk/3IwZOjm/
	 A8Pk14VPuIQQgNsaq7jLHuIEtYcAs06ZD/uSm3S8MeS0erbL1pOp+iBVErmRdMfHUt
	 vNURY/YTmu91VgAouiUqxw1RtA0ZShQcdOlUB40TQr1GYpNY2/Hla0iTqYRb6KzyPs
	 uwzcExwxuI3ag==
Date: Mon, 21 Sep 2026 03:17:24 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, Bjorn Andersson <andersson@kernel.org>, 
	Chris Lew <christopher.lew@oss.qualcomm.com>, Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, 
	Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, Juha-Matti Tilli <juha-matti.tilli@iki.fi>, 
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: Re: [PATCH 0/4] net: qrtr: Add support for using identical MHI
 endpoint devices
Message-ID: <j22jk53fhr7nkbb5vcjgp3xw6zoklbt7afzvfetmoh3om3ttsl@pobyf4t3zcsv>
References: <20260918-qrtr-multi-ep-v1-0-8a06caa368d3@oss.qualcomm.com>
 <4e0481c1-9288-42d4-94c9-e18da5cf8e5d@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e0481c1-9288-42d4-94c9-e18da5cf8e5d@oss.qualcomm.com>

On Fri, Sep 18, 2026 at 11:13:42AM -0700, Jeff Johnson wrote:
> On 9/18/2026 9:28 AM, Manivannan Sadhasivam via B4 Relay wrote:
> > Hi,
> > 
> > This series reworks the QRTR driver to add support for using identical MHI
> > endpoint devices at the same time. Currently, QRTR driver has a limitation on
> > using more than one identical MHI endpoint devices like QCS6490 or any Qcom
> > Endpoint device making use of QRTR at the same time. Because of the fact that
> > these devices will have the identical QRTR node id, they cannot be used at the
> > same time, on the same host machine.
> > 
> > This limitation is a blocker for running upstream kernel on devices like Qcom
> > based routers as they often have multiple identical WLAN Endpoint devices
> > connected to the Router SoC.
> > 
> > This series supersedes the following 2 series from Juha:
> > https://lore.kernel.org/all/20260915054207.2513877-1-juha-matti.tilli@iki.fi
> > https://lore.kernel.org/all/20260915074135.2567411-1-juha-matti.tilli@iki.fi
> > 
> > Compared to the series from Juha, this series simplifies the multi-endpoint
> > support by computing a unique node id for each MHI endpoint and uses it for the
> > internal QRTR book keeping. This ensures that even if the MHI endpoint devices
> > have same node ids, the host QRTR will always use a unique node id for each one
> > of them.
> > 
> > More details can be found in the individual patches.
> > 
> > Testing
> > =======
> > 
> > Juha tested this series on multi ath11k setup by backporting this series to
> > 6.6.156 kernel. I'd appreciate a formal tested-by tag from Juha and other folks
> > CCed to this series.
> > 
> > Merge Strategy
> > ==============
> > 
> > Since both QRTR and ath drivers are falling under the networking tree, the whole
> > series can be merged through netdev tree.
> > 
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> > ---
> > Manivannan Sadhasivam (4):
> >       net: qrtr: Allow the host QRTR to assign a unique node id
> >       net: qrtr: Assign unique node id for MHI endpoints
> >       wifi: ath11k: Connect to the QMI server belonging to the device owned by this driver
> >       wifi: ath12k: Connect to the QMI server belonging to the device owned by this driver
> > 
> >  MAINTAINERS                           |  1 +
> >  drivers/net/wireless/ath/ath11k/hif.h |  9 ++++++
> >  drivers/net/wireless/ath/ath11k/pci.c |  9 ++++++
> >  drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++
> >  drivers/net/wireless/ath/ath12k/hif.h |  9 ++++++
> >  drivers/net/wireless/ath/ath12k/pci.c |  9 ++++++
> >  drivers/net/wireless/ath/ath12k/qmi.c | 11 +++++++
> >  include/net/qrtr.h                    | 21 ++++++++++++
> >  net/qrtr/af_qrtr.c                    | 61 +++++++++++++++++++++++++++++++----
> >  net/qrtr/mhi.c                        |  4 ++-
> >  10 files changed, 136 insertions(+), 8 deletions(-)
> > ---
> > base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> 
> I see this is based upon v7.3-rc1 (current release tree).
> This series doesn't cleanly apply on the net-next tree.
> 

Ah, that's bad.

> Are you planning on netdev taking this through current or next?
> 

-next only. I will respin.

> And an alternate merge strategy would be for netdev to take the first two
> patches and then after wireless fast-forwards and ath fast-forwards, I could
> take the last two though the ath tree.
> 

Unfortunately, ath patches depend on API introduced by the 2nd patch. So they
can't be applied independently.

I will respin this series on top of ath-next so that the series can be applied
through netdev next.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
