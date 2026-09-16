Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6663A3B38AA;
	Wed, 16 Sep 2026 06:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789541395; cv=none; b=KEpMiE1IQp27ps5iCl1o1mv/jKuHo+D3izxhFcoNdmvzOjQD5GcqdznO+Q5Q2YJPG2g23N29GRaE6K3Kl16wr0TtPyTwLRPWnnxdlwpNPzBZQR1g8O/sXu5Sh//enrk5mmVKyGcZb8Thgn+5PAkdbAmduYl8zD9CY4PBYgmC/Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789541395; c=relaxed/simple;
	bh=8l11pkf6kLuSYczE/hzPSes/sBFyaqQSnsP20F8Akpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XER5dqvA6x8eCKLBiMge2GoY3CrCMtxi8iqQ7y0iVG4rkINpPEHVOeZb2t9I2ytLuPTHrebrdhWlTO2dfBoVLWfnKErjb1PS1AWeIzxs5RXY8xSGG+imsRyzaCccYWgUE9xDzzsHHpPxizFDYaCtEM5Fyb5Kq2Esef29dmswiTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8LGoYWN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8LGoYWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1F31F000FF;
	Wed, 16 Sep 2026 06:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789541393;
	bh=IvF/lDWIxjmdBnUQu2pw5iZ8dJc+t4gXd603fw/T2So=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n8LGoYWNtpMnTBlGfCbN23m/T84d83Q38jhIFbxr1lPs5b23nLdcNIDWZlcnGYn4R
	 4rKmj2862NZ6AxDZFJ+elEghp1nUPg61brH6238b/4/CyRxtbD/7TpVrHvtjWevlHv
	 VvCS4DHnbNntVbtgjeNMEMBXagW7zo2guZcEWpa09TIp85JznGsoz0D6R+ccuxDWa4
	 OMFzFRr8/Ixyr16SS9C7RGiUuUhmNnXjPDd1KUrfSFvrhyERTTc5zmV1lRRFk4P4pR
	 BgXgRI0bEA/VJyfQT+GUWgNnoUCoJ6rLxS5net0RDlCfYSis+6vrRi9YaroCtLtK46
	 eHtIgBSrHsrPw==
Date: Wed, 16 Sep 2026 08:49:41 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Cc: linux-arm-msm@vger.kernel.org, Jeff Hugo <jeff.hugo@oss.qualcomm.com>, 
	Jeff Johnson <jjohnson@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Mihai Moldovan <ionic@ionic.de>, 
	Denis Kenzior <denkenz@gmail.com>, Marcel Holtmann <marcel@holtmann.org>, 
	Andy Gross <agross@kernel.org>, linux-kernel@vger.kernel.org, mhi@lists.linux.dev, 
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
	netdev@vger.kernel.org
Subject: Re: [PATCH v7 02/15] net: qrtr: allocate and track endpoint ids
Message-ID: <k3wxn3ga5gqj5dlhykgnslxfgj536ecfirfc34cd6tc7nbzgo7@jmz46unm7q6f>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
 <20260915054207.2513877-3-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260915054207.2513877-3-juha-matti.tilli@iki.fi>

On Tue, Sep 15, 2026 at 08:41:54AM +0300, Juha-Matti Tilli wrote:
> From: Denis Kenzior <denkenz@gmail.com>
> 
> Currently, QRTR endpoints are tracked solely by their pointer value,
> which is sufficient as they are not exposed to user space and it is
> assumed that each endpoint has a unique set of node identifiers
> associated with it.  However, this assumption does not hold when
> multiple devices of the same type are connected to the system.  For
> example, multiple PCIe based 5G modems.  Such a setup results in
> multiple endpoints with confliciting node identifiers.
> 
> To enable support for such scenarios, introduce the ability to track
> and assign unique identifiers to QRTR endpoints. These identifiers
> can then be exposed to user space, allowing for userspace clients to
> identify which endpoint sent a given message, or to direct a message
> to a specific endpoint.
> 
> A simple allocation strategy is used based on xa_alloc_cyclic.  Remote
> endpoint ids start at 'qrtr_local_nid' + 1.  Since qrtr_local_nid is
> currently always set to 1 and never changed, node identifiers start at
> '1' for the local endpoint and 2..INT_MAX for remote endpoints.
> 
> Signed-off-by: Denis Kenzior <denkenz@gmail.com>
> Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
> Reviewed-by: Andy Gross <agross@kernel.org>
> Signed-off-by: Mihai Moldovan <ionic@ionic.de>
> Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

- Mani

-- 
மணிவண்ணன் சதாசிவம்
