Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793035581;
	b=DbFrr2ZeyfkXf0GX0KInGqIPHRNd8hE9S5pwoMuwUtSuzNCWr5vAKwxvtLPHsWP3Pvp/
	 9iYf6j1HD8X1uEDYhzxFsPm57nOhSzuaq4GnhGK5vIXLeqFN9/IdjrgwN22jEmheKTN0H
	 DZ8MS/RmCQik8bNszFmB02D2Uazu2MzxkmYGzalu9atNegyk8izvTf99oHTYszSlaHYjQ
	 Argtle0CxnWmzO4bchliFbGsmBtiF8oXjbaD/GqzRmlnupb0mfS14v3KHM9E8uB+8+dZ5
	 /MKQZLp2oLRryF9zwhfylOmlzGst3hVnozycSEJIMogX/cmnOy2u+LfVuUEjLqRtmWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793035581;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Y7fieeF7CmqetCmDW/QKoeVOfYtQRHVfDW9OzlsY0n4=;
	b=UF2h+cJQ+tGef6eGf8HVosGw8P/v7Rq6H4uDAo3HWStLzhpUWr6xN6/IPVuiwTWgK9hv
	 GvkUcOQDtIc5V7PA4uBgdFjcsL4AxjGu+ltzHQf3DCbtaSsEtp2JcxxMyoUkQt+gJTJnV
	 xClhaxnflG6fHiM3qbwUC8zITliaJ0ZVMC6KNnv8SexGCqgIo6oXksjGJUGRsVfWqHtCi
	 KtpZ5zqjYTGOL4tre5gbLYmEDzslrqhSIJMcI7SjmvDSFjTgT6eeYG6SvNs157FgR78Nr
	 TzzxDJNf6ovCYShmr2MWPW+2baKzJT4JFMTSf+Ca7UOQd7bOdYDtuY/pLJBr06S6/7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bIwrq3jc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E02606A327;
	Mon, 26 Oct 2026 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bIwrq3jc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893661F01825;
	Mon, 26 Oct 2026 17:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793035580;
	bh=Y7fieeF7CmqetCmDW/QKoeVOfYtQRHVfDW9OzlsY0n4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bIwrq3jcWrVWlKY8Ol4vI8+yt/qdkIhJvzjUsFnJcQWz3XJYeEXX2S4C0ZhimFzof
	 goBbek1dQU+wXfkoaPDg3K54VH/pP38R+714tMnt48sRGhzCxeYts7CkqGlCj5V+wM
	 MUvhfO4sZkf1zfcxsOHV016bxGhPv5P1SLg6l3H7T/dqml1fDcfdtBSNE8RYo8yXya
	 RxLGizVb2O5ZJry4Es3MXd/uAUOEio8S58XVeog9qr3kNNdiZLowA2thGEVkKW0iVF
	 2xmF4MLCyvZ3pC7/5uFhf/hgxEa94yrglFs/C+j2WjAPs3Cms7mHnWh/ClX/km5DZo
	 N20jrkg72XU4w==
Date: Mon, 26 Oct 2026 17:26:15 +0000
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
Subject: Re: [PATCH v4 4/4] wifi: ath12k: Connect to the QMI server belonging
 to the device owned by this driver
Message-ID: <20261026172615.GK257209@horms.kernel.org>
References: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com>
 <20261022-qrtr-multi-ep-v4-4-c6fdb75fcd3e@oss.qualcomm.com>
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
In-Reply-To: <20261022-qrtr-multi-ep-v4-4-c6fdb75fcd3e@oss.qualcomm.com>

On Thu, Oct 22, 2026 at 07:43:10PM +0200, Manivannan Sadhasivam wrote:
> When two identical ath12k PCIe devices are connected to the same host, both
> advertise the WLFW service with the same service and instance id. The QMI
> lookup reports both servers to each device, so a device may connect to the
> firmware running on the other device.
> 
> But now, QRTR provides each MHI endpoint a unique node id which is
> different from the node id announced by the device. So use the same id to
> pick the correct server. Add a get_qrtr_node_id() HIF callback that returns
> the node id derived from the MHI controller index and zero for transports
> that do not assign one. In the new_server callback, reject any service
> whose node id does not match. A node id of zero disables the check, so
> transports that do not assign one keep their current behavior.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Reviewed-by: Simon Horman <horms@kernel.org>

