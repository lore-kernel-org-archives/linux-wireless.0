Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE87054CF54;
	Wed, 23 Sep 2026 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790181630; cv=none; b=mhecWSxo3vfhKYn5/N5R7sMoxA9qDOFTyVmICyLzhVKfkcqDTmfy7KTgX4YhurMghRt1rI8X+GfwndlqSTb1aW/GhzBiUdIYIDtJ1nGAPXlv245XwlhJZ+m/pwMIDVeKL5oNSoG2bA3oWyBEh2PIYegJbivB2FhmeUakGnzkuR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790181630; c=relaxed/simple;
	bh=HMiV1lfIaDk5DHsbSxdwUFDcgU3l31krtmmNDs2cJrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uf1oBg/GUMti1dDUVVxE54bAGK0aQDv9+rF8VE5Xw3GMgAgOc6Kbat0c7djs/JzfwMImyjDmui0W5XtT2MIk5KLcdpF/FQ10f1rnLNrtFYHgSqYSR3Enys7oPJCXh049ULAFBBP4H/YvLkNNcy0eQbsFxFufHyW2uL/t9/OOw5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m9XbphuR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m9XbphuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279F11F00893;
	Wed, 23 Sep 2026 16:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790181614;
	bh=pJuvljr4VJrwhkS2WB5iCaspV3ZEJ4xcFgJqC1vtnGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m9XbphuRQlcHxv/dIcs/B0xX7P6p+A4iWPybU/3YwAAAaBzvF6sjQzP7t4HTjjjg9
	 ZeIIJ4x1eOXrnjwvp4pZvQaY7H2KL8ILGII9aZ2um1GBWK2/P/+6H0FTL5uJ2h1H5a
	 S6ks5u66CrHUX11jmZ1FONtFut0a047A27JLGTMDDVHxq+jd8nZq+qM4A9p1b1EIGY
	 pDtXT+VJZ6tysEBC7ykFlsFG2RLITC8gJjLCRFinsIKbSBEhaZhNrfoP+htoWErD44
	 a19iPOU6RI6I4/siJo9XYSzFpHC8C2zSx6YSLwXzJABl7FHYgz0acqKQCBlmdLvEqO
	 oWIMUu4hpYitw==
Date: Wed, 23 Sep 2026 18:40:02 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, Bjorn Andersson <andersson@kernel.org>, 
	Chris Lew <christopher.lew@oss.qualcomm.com>, Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, 
	Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, Juha-Matti Tilli <juha-matti.tilli@iki.fi>, 
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: Re: [PATCH v2 1/4] net: qrtr: Allow the host QRTR to assign a unique
 node id
Message-ID: <l32syvvxm7h22li5bj2n4unqjqor7bgehlbg3pzly7i43l4xkl@xr7xzaf4ydyj>
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-1-27dd80d841a0@oss.qualcomm.com>
 <3f5da6c9-7394-4452-92f8-b773cd34aecf@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f5da6c9-7394-4452-92f8-b773cd34aecf@oss.qualcomm.com>

On Tue, Sep 22, 2026 at 06:08:11PM +0100, Youssef Samir wrote:
> 
> 
> On 9/21/2026 12:23 PM, Manivannan Sadhasivam via B4 Relay wrote:
> > +/* Replace the node id in the control packet with 'node->nid', if both are
> > + * different.
> > + */
> > +static void qrtr_node_rewrite_ctrl(struct qrtr_node *node, unsigned int type,
> > +				   struct sk_buff *skb)
> > +{
> > +	struct qrtr_ctrl_pkt *pkt;
> > +	__le32 *nid;
> > +
> > +	if (node->nid == node->ep_nid)
> > +		return;
> > +
> > +	if (skb->len < sizeof(*pkt))
> > +		return;
> > +
> > +	pkt = (struct qrtr_ctrl_pkt *)skb->data;
> > +	if (type == QRTR_TYPE_DEL_CLIENT)
> qrtr_tx_wait() will create a qrtr_tx_flow object keyed by qrtr_node->nid.
> qrtr_tx_resume will attempt to retrieve it with qrtr_node->ep_nid, which
> will fail. This leads to the HTD path pending packets reaching
> QRTR_TX_FLOW_HIGH and block indefinitely. QRTR_TYPE_RESUME_TX should
> be handled here.> +		nid = &pkt->client.node;

You are right! I've already fixed this issue in v3.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
