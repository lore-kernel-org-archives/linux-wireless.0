Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A07378D8D;
	Mon, 21 Sep 2026 11:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789989956; cv=none; b=g2xgiemIwfwWna+FYlWLGlzxF/z/Z9A6Z5500gywrz9htUu/PLhuqPiEztfhpUlRLv8jaTZZ1d/FwOSyYjCnNfVxX/dqUUi1EvmTbQv+kUNnf/jNQtnruYFJNQmnIC4r9mjvmsuV/pzotc5D2hc7d/bXr7D18GwTes0tuSybmfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789989956; c=relaxed/simple;
	bh=uPQtscV8Z0GXUBHpFrT+jeW0D1Q6eUCptzebFCXmqdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UMv+5semD5Bf0FAmyUZ/HpeiS2F+4CjIKHvhS/9ZnQpjv1OWDpO6wyxqxihwABh7ZpvL2C+DOgTq6FmQtGPY/XND8V5hdjMGs6PQLeN/+dZqslxgCL7kF+qyC35F8oE3U00kZEdzr3cO4+QF07nbv9tX2+9rjMIxhC9O8S+q+oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k9sz3N4G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k9sz3N4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E571F1F00893;
	Mon, 21 Sep 2026 11:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789989955;
	bh=+IU8t1JRfWrIGINdVDCgScYXPyiqDlZ/6ergXEl1tFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k9sz3N4GdpeJEzRzX4jMR2FXUFXpxSvoIQYfMv+R2t1GqT2//p4GZwP/X/5+lve4P
	 yJIZfXwQFM7SRsc7dIWr4GDAzOp5hKtW56b2FfiEkEaAom6R0zXFsILi5cqa0nwAeB
	 Ipbk3eVN87PthYRWyyCgEO1rsbq8CtAlwQcy3yW8u3YYfLOpzs5/aPSC6AgpZ53slR
	 YdAvUqqm2cODG7VtK1Pe/zJm31JPk0KQgaJqFDbVat+Ci38dXlb5HDZRJ497kPDFWT
	 bHMJ8ad+byfEUFK0AMK/xQxgqrqIFfK1246dPIBxqRILgKDGmereFtay3nJ2aZt5mr
	 9a6T/QpCBEeWw==
Date: Mon, 21 Sep 2026 13:25:45 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Cc: "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, Bjorn Andersson <andersson@kernel.org>, 
	Chris Lew <christopher.lew@oss.qualcomm.com>, Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, 
	Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: Re: [PATCH 3/4] wifi: ath11k: Connect to the QMI server belonging to
 the device owned by this driver
Message-ID: <zozo7e42rvf4evl2q5ugrb2ccvkb6l3um56yuqfgi7ghx5rfou@57b4pqg7fpfk>
References: <20260918-qrtr-multi-ep-v1-0-8a06caa368d3@oss.qualcomm.com>
 <20260918-qrtr-multi-ep-v1-3-8a06caa368d3@oss.qualcomm.com>
 <da0421b8-bf31-43d1-8d71-520753c8344c@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <da0421b8-bf31-43d1-8d71-520753c8344c@app.fastmail.com>

On Fri, Sep 18, 2026 at 07:39:09PM +0300, Juha-Matti Tilli wrote:
> On Fri, Sep 18, 2026, at 19:28, Manivannan Sadhasivam via B4 Relay wrote:
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
> 
> Tested-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
> Tested-on: 2x WCN6855 hw2.1 PCI WLAN.HSP.1.1-04685-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1
> 
> (assuming the patch is the same and hasn't been updated since 17.9:
> https://github.com/Mani-Sadhasivam/linux/commits/qrtr-multi-ep/ )
> 

I just sent v2. Could you please test this version? I had made some changes
while rebasing to net-next/main, so making sure I didn't regress, thanks!

- Mani

-- 
மணிவண்ணன் சதாசிவம்
