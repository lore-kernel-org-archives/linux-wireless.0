Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD933905EC;
	Tue, 22 Sep 2026 13:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083677; cv=none; b=LU/YGXSx2NmvvmKKKhxxR5fmVa2DsEkjN4QH1m8Ij2oOEXjlB2FSPN/ZORcHF3BS4nFP+/LE7tMdQ2Cx+9mko8LMfwjyCD1fcFI26uAiQe6PkSyInpnfsRtIyLEzMfZt+2HUDihXQlSatCT7MyQhd/8BkF3+eblQyc4TdWSfbfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083677; c=relaxed/simple;
	bh=W+zZyY+/XSoXA6X2r9Zl04xwFs+BQBcAmbZKJRydPD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfKYHFPyH/sKmnGN2zWLiYhysVXxqR5Br2+xZO+R5cRJ+9eXFsYOmIWgMlbKu2bQRDMX+IpIuOWLw9ysCFDAkysTDNCYkC5vlbmDi28YgtUVy8vfLRkxakL4OmqmvlD+KqKpOktn3VVLyqKD//IDi4ED8v2//ENJ3JeCpXhLnZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FwhENWJk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FwhENWJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560641F000FF;
	Tue, 22 Sep 2026 13:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083676;
	bh=ApsZVBFkcyb1C7G7ucDacbOxA5hWzpJXw9SDkNt3hYw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FwhENWJkUL+Ph/E/ZL08lyizsjNyTtU6O+wgwczrNQQDJdxOGDr8Xkh7SjPAAT7pT
	 lnVQgC0Cf7WE3w8On+hyQLcfF2SrM437/whHiUMkQ3DZtWaY8x2ToWjM1eUJQ5ZQZY
	 qMGenCbLjWe/h8ax5QShb0raOqc+uLsvhMjUCplAmP2hyChI4W5FuhbPGSJc7+Myu0
	 FkP91zRSSM5mBvItuthSEdtgzWn/vG+JCEVXQ+/kjKJpIEO9ntAyiqHGASa28we9o1
	 GyOqxEu+9kDUVOGhOnH/9/vyu3oPSD1+i/12DF7cfNd1/hg/r2bHQ5lDI1tq4P9xOh
	 4HzsuT7Wof19g==
Date: Tue, 22 Sep 2026 15:27:45 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, Bjorn Andersson <andersson@kernel.org>, 
	Chris Lew <christopher.lew@oss.qualcomm.com>, Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, 
	Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, Juha-Matti Tilli <juha-matti.tilli@iki.fi>, 
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: Re: [PATCH v2 3/4] wifi: ath11k: Connect to the QMI server belonging
 to the device owned by this driver
Message-ID: <irhurowbxxpxrg7j3f4onxboxoxzj5jszyuq5ex5osedmx5k4u@r4d365t6kpze>
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-3-27dd80d841a0@oss.qualcomm.com>
 <3f31a185-b7ba-4ae4-a3c3-874bac0d66b3@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f31a185-b7ba-4ae4-a3c3-874bac0d66b3@oss.qualcomm.com>

On Tue, Sep 22, 2026 at 04:32:07PM +0530, Vasanthakumar Thiagarajan wrote:
> 
> 
> On 9/21/2026 4:53 PM, Manivannan Sadhasivam via B4 Relay wrote:
> > From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> > 
> > When two identical ath11k PCIe devices are connected to the same host, both
> > advertise the WLFW service with the same service and instance id. The QMI
> > lookup reports both servers to each device, so a device may connect to the
> > firmware running on the other device.
> > 
> > But now, QRTR provides each MHI endpoint a unique node id which is
> > different from the node id announced by the device. So use the same id to
> > pick the correct server. Add a get_qrtr_node_id() HIF callback that returns
> > the node id derived from the MHI controller index and zero for transports
> > that do not assign one. In the new_server callback, skip any service whose
> > node id does not match. A node id of zero disables the check, so transports
> > that do not assign one keep their current behavior.
> > 
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> > ---
> >   drivers/net/wireless/ath/ath11k/hif.h |  9 +++++++++
> >   drivers/net/wireless/ath/ath11k/pci.c |  9 +++++++++
> >   drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++++++
> >   3 files changed, 28 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/ath/ath11k/hif.h b/drivers/net/wireless/ath/ath11k/hif.h
> > index 017fed1b4bd1..0da9025c7ed8 100644
> > --- a/drivers/net/wireless/ath/ath11k/hif.h
> > +++ b/drivers/net/wireless/ath/ath11k/hif.h
> > @@ -32,6 +32,7 @@ struct ath11k_hif_ops {
> >   	void (*ce_irq_disable)(struct ath11k_base *ab);
> >   	void (*get_ce_msi_idx)(struct ath11k_base *ab, u32 ce_id, u32 *msi_idx);
> >   	void (*coredump_download)(struct ath11k_base *ab);
> > +	int (*get_qrtr_node_id)(struct ath11k_base *ab);
> >   };
> >   static inline void ath11k_hif_ce_irq_enable(struct ath11k_base *ab)
> > @@ -159,4 +160,12 @@ static inline void ath11k_hif_coredump_download(struct ath11k_base *ab)
> >   		ab->hif.ops->coredump_download(ab);
> >   }
> > +static inline int ath11k_hif_get_qrtr_node_id(struct ath11k_base *ab)
> > +{
> > +	if (!ab->hif.ops->get_qrtr_node_id)
> > +		return 0;
> > +
> > +	return ab->hif.ops->get_qrtr_node_id(ab);
> > +}
> > +
> >   #endif /* _HIF_H_ */
> > diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
> > index a163168f3617..4d327b5cc98a 100644
> > --- a/drivers/net/wireless/ath/ath11k/pci.c
> > +++ b/drivers/net/wireless/ath/ath11k/pci.c
> > @@ -10,6 +10,7 @@
> >   #include <linux/of.h>
> >   #include <linux/time.h>
> >   #include <linux/vmalloc.h>
> > +#include <net/qrtr.h>
> >   #include "pci.h"
> >   #include "core.h"
> > @@ -900,6 +901,13 @@ static int ath11k_pci_start(struct ath11k_base *ab)
> >   	return 0;
> >   }
> > +static int ath11k_pci_get_qrtr_node_id(struct ath11k_base *ab)
> > +{
> > +	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
> > +
> > +	return qrtr_host_node_id(ab_pci->mhi_ctrl->index);
> 
> nit: since qrtr_host_node_id() returns node_id in unsigned int,
> may be maintain that in the return type of the callers as well.
> Mostly harmless as it is unlikely that node_id is allocated with
> an extremely high id. Either way is fine with me. Same applicable
> for ath12k patch as well.
> 

Thanks for spotting it. For the sake of correctness, it makes sense to use same
type everywhere. I'll fix it in next version.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
