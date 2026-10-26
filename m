Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793035540;
	b=3mnm3m3T5/wc6ypj7tqeBMaeSL7S3EzOLaJ/fCqrt362s8gfPbQ6lGmA/MumhhEX6Lcn
	 E/4ilE7uAtezsAIxzpb5cU1rGX2o3gMLIQvYq+ZxTwBHTB1joYJnKXttJljPCiIlBhZrA
	 hu9/PkV5Q10e4lE/Re7jLDiZvqXNtF2ybE91U8XnwVhBFAWIYmSDTc2vftsSJsBmvt8zP
	 b21Ni/N/5ghCnJNly4a0LFNJrF28DBz4i3+BVWJ3MOUsZHpWOVdz4cIslRFjfyejmAJKo
	 jDHwJ96IEjnGrLvOxSkI4kIslkuQaq2ynAzASTk3YzyV5F5WcX8aEqA4r5G7a2YSLPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793035540;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=vtU+kBzBPd6DlQELqlotiDLJ3HaHy3LtAxD3GeegWhs=;
	b=fHa+j+exXn2Y3BeZ5QTEMcQzyDsuHPv8Oqkal4ElWJMUYVKv0tb0Ig63DotfCIDH9EBg
	 CziMHu66gjY7iCBBMgdXIGPW4ab98QjFvmaA1dEM6hWqQwajPvc+L+AoZ3vOQPz35HnxY
	 IXp4aJYUuv4cT8m9t5PTRoW31q3hE5tnMy++qI+VWMU/GHz9MvhyzLeOciT4L6b0+y9mg
	 z1sWQZS9uq6O+CbKzxtZiXtZqFNVZrboxh4xEFaMbBBhQ9ojMZMIrVYU/3Qy3wPGWZb9J
	 WbPKw9E4q4m2HwnyoScikzUKYuuGcpc+HMI5YoAjpiGvLfiE0mvg758WFm+8gpJqkZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bachbU0d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEDB606A323;
	Mon, 26 Oct 2026 17:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bachbU0d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75F71F01825;
	Mon, 26 Oct 2026 17:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793035540;
	bh=vtU+kBzBPd6DlQELqlotiDLJ3HaHy3LtAxD3GeegWhs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bachbU0dKGwcBYfW42KWyzvr8NDrZSvBhcmnOgwCtYFmnFjXJ6X0+FhrZkBztKbMJ
	 wQ3Nc2YGmiV/XYHQgULEdGinAd9edH/fw2ICcIESbKiWC5QnCgOZe6/jQCZdaW3UZT
	 rJEm5UuOzb+ey2m/sOKzGmOSsvlhO2Sz+0uLRCvYAqNPlKNryYvDg3Or2UYJHh+zUi
	 4cAoK9xZWf3sxeWch3e+H0aueN8TcrnkoQgxh2XsJteKdwYGxBfeEZ5X9jq4+8bPUo
	 h/wxuGYbHhJ2KGcGCEeDjUcgShKUKE9oE34HweBWNHYj91p+PPxfL44szG2+KAX/yd
	 HM8qBOExM7Wog==
Date: Mon, 26 Oct 2026 17:25:34 +0000
From: Simon Horman <horms@kernel.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	ath12k@lists.infradead.org, Bjorn Andersson <andersson@kernel.org>,
	Chris Lew <christopher.lew@oss.qualcomm.com>,
	Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
	Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
	Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: Re: [PATCH v4 2/4] net: qrtr: Assign unique node id for MHI endpoints
Message-ID: <20261026172534.GI257209@horms.kernel.org>
References: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com>
 <20261022-qrtr-multi-ep-v4-2-c6fdb75fcd3e@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022-qrtr-multi-ep-v4-2-c6fdb75fcd3e@oss.qualcomm.com>

On Thu, Oct 22, 2026 at 07:43:08PM +0200, Manivannan Sadhasivam wrote:
> Now that the QRTR driver allows using the unique node id for each device,
> which is different from the node id received from the remote node, compute
> a unique node id using a new API, qrtr_host_node_id().
> 
> This API takes the 'index' parameter and adds it to QRTR_NODE_HOST_BASE.
> The base is chosen well above the node ids in use by the remote nodes, so
> that the host assigned ids never collide with the pre-existing ones.
> 
> Since the ids at and above the base now belong to the host, reject any
> packet carrying one as the source node id or as the node id of an
> announced server in qrtr_endpoint_post().
> 
> Finally, call the new API from MHI endpoint driver by passing the MHI
> controller index as the parameter. The MHI controller index is unique for
> each controller, thereby for each MHI endpoint device.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---
>  MAINTAINERS        |  1 +
>  include/net/qrtr.h | 22 ++++++++++++++++++++++
>  net/qrtr/af_qrtr.c |  9 +++++++++
>  net/qrtr/mhi.c     |  4 +++-
>  4 files changed, 35 insertions(+), 1 deletion(-)

Reviewed-by: Simon Horman <horms@kernel.org>

