Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EADF320A34;
	Tue, 29 Sep 2026 19:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790710357; cv=none; b=hg3Aq2lcr8M/WIr0iZHfzfYx3VGkbQzkRWJPEXaG9UWIp8g141Al2RL3Ld+5EWjKHqqxbA50rVkHwPQ4qvY+4uBhuLQ1fyC/wtlMCThf8qMReOrZ9fcwwezSO4MBXMa4wcaCCpSFXdneEkFSIag0UjXJmHS/lRFg29Nk91qagms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790710357; c=relaxed/simple;
	bh=fOBN9zdig8J1ANNWazAidsCd07YBfhIBgNCVQwwkK0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HvR/yxX3sTLl1r3EjAsWuy2eH9wnNuVBzkM7v+IKgu+qYKlMx9mFJxZUdd0For0tp8K6slZq9DGqJ5YztGJfnxK+NH6y3N4kNFplF7HnFSQzedi5RgGgKCUpQHny6iXegqd/Ya7n13Xt0wdQ88+wj4j5unCRBHQniYRTW/m218c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dliHjACD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dliHjACD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCF61F000FF;
	Tue, 29 Sep 2026 19:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790710356;
	bh=DYT1pzhI3fvjvNKGoV0gv49pvi/bcg98Rzpa+iMF22U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dliHjACD6G8cM6hYVY4XjJBOleZdtkVYSGu1FX1+CxqinZZxM0wele4GyNm/fiiuN
	 LVNGN+oMVkKa9DJ4wbQGjrtKwaKPpmuPJ/+dKknRavmrMDXFM6K+moRrhCpnj80ojC
	 9/aGRsjL/3ybLo6/PBiAiVGK8gSM7Aa58ftoQwaumcUIkSdNuMz0PHH8sBktzfwe/D
	 ZESGCpQ1Q+2xq1xWukZ+P0uGJGBWs1Y3vJ9ivqeTPR+fc6oJzBenWHAmVVxN4wS/qw
	 sdpfczACclbENStrycVY5MgbtCRZCuiEbWcd3CIbkD65UUC+khs49257qzI+kDuRb+
	 ehY6BsRSmlMdw==
Date: Tue, 29 Sep 2026 21:32:27 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, Bjorn Andersson <andersson@kernel.org>, 
	Chris Lew <christopher.lew@oss.qualcomm.com>, Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, 
	Juha-Matti Tilli <juha-matti.tilli@iki.fi>, Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: Re: [PATCH v3 2/4] net: qrtr: Assign unique node id for MHI endpoints
Message-ID: <erwghnlgy7bv7bjiut6f3cidzm4gpblevrfvxfe7yllwf6aqaw@d6w5d4jp5kr5>
References: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
 <20260922-qrtr-multi-ep-v3-2-c00831e88957@oss.qualcomm.com>
 <7aed969d-0868-4c9c-967e-7766dbba427e@oss.qualcomm.com>
 <13BFC5B0-77E6-48F2-B857-37686EA1DB2C@holtmann.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13BFC5B0-77E6-48F2-B857-37686EA1DB2C@holtmann.org>

On Tue, Sep 29, 2026 at 07:05:31PM +0200, Marcel Holtmann wrote:
> Hi Deepak,
> 
> >> Now that the QRTR driver allows using the unique node id for each device,
> >> which is different from the node id received from the remote node, compute
> >> a unique node id using a new API, qrtr_host_node_id().
> >> 
> >> This API takes the 'index' parameter and adds it to QRTR_NODE_HOST_BASE,
> >> whose value is outside of the node id range used by the remote nodes (0 to
> >> 0xffff).
> >> 
> >> Finally, call the new API from MHI endpoint driver by passing the MHI
> >> controller index as the parameter. The MHI controller index is unique for
> >> each controller, thereby for each MHI endpoint device.
> >> 
> >> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> >> ---
> >>  MAINTAINERS        |  1 +
> >>  include/net/qrtr.h | 21 +++++++++++++++++++++
> >>  net/qrtr/mhi.c     |  4 +++-
> >>  3 files changed, 25 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index df8ab9b82402..9c8bb086be28 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -22511,6 +22511,7 @@ QUALCOMM IPC ROUTER (QRTR) DRIVER
> >>  M: Manivannan Sadhasivam <mani@kernel.org>
> >>  L: linux-arm-msm@vger.kernel.org
> >>  S: Maintained
> >> +F: include/net/qrtr.h
> >>  F: include/trace/events/qrtr.h
> >>  F: include/uapi/linux/qrtr.h
> >>  F: net/qrtr/
> >> diff --git a/include/net/qrtr.h b/include/net/qrtr.h
> >> new file mode 100644
> >> index 000000000000..745d51b4a6ba
> >> --- /dev/null
> >> +++ b/include/net/qrtr.h
> >> @@ -0,0 +1,21 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +
> >> +#ifndef _NET_QRTR_H
> >> +#define _NET_QRTR_H
> >> +
> >> +#include <linux/types.h>
> >> +
> >> +/* The offset is chosen carefully to not collide with the node ids allocated by
> >> + * the remote nodes. All the remote nodes use node ids in range 0 to 0xffff.
> >> + */
> >> +#define QRTR_NODE_HOST_BASE 0x10000u
> > 
> > Can it be exposed with include/uapi/linux/qrtr.h also. There are user space clients like modem manager
> > which need to calculate modified node id to distinguish same service from multi modem over mhi.
> > This is same as wlan use case.
> 
> did anybody actually looked at the proposal that Denis and I came up with. It was exactly addressing this properly.
> 

I did review the proposal from Juha and shared my review feedback.

> It seems you guys came up with some hot fix and want to run with it. After month and month of silence and not bothering to review the proposal, you are trying to push your thing?
> 

I aplologized for the very late review. But the series I shared was not just
some hot fix, but a proper solution (without userspace ABI though as I didn't
forsee the requirement) that works for the multi-WLAN setups.

> If you don’t support userspace, your proposal is broken. Plain and simple.
> 

Small correction: broken for some setups, not all. But I do get the point. I'll
incorporate this ABI in next version.

Thanks for the review!

- Mani

-- 
மணிவண்ணன் சதாசிவம்
