Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793035499;
	b=w5pmyyXNJ2r6lcV0HRD9TjEzXJLQ9QAFlSRxei3jEG38Mak28Hhiv0T1JyK8ytqAwTU9
	 8Ncko9d6jdtTJuXtxhggoIW8A6BoCa0v9UXTew0MNRI3gU+RsE80hwBRnQyL1ITQOW770
	 wXDVGJ5LQgJE/U+y7HSJEA/gejl4oH3dJBP2VcBXiJIOOb7RbFlXznlXVygDLH2bWQAB0
	 TAMrDhnUk1e5AAiOuf5dzBvi5+pk6Y/ZUg4oebdhhIWIOcSrib/C/6nheYmevXIxXepYM
	 qj5pP2vIpE//dmw+cLnXiALpLwy2bQ7RPTBgkHx/ifD7du4sIlg/EnjKaJbwvT1lneg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793035499;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=k6TWqe6a8TrmnSxPzfBWojZNqbAoIQPtwFE2RKyIVPo=;
	b=U3hFpPNZ0yJsA9l0b2aRh5x+iV/5tZ3afO0umWT1FOBpvHp2icgzrh5O7WzQnY+IwI72
	 ZpyW0VriIRh+dxSOezDOo11Ghhy/0XwutiCt8fhjj7kfhlxQDq69+PyOeigT70v1MDkjr
	 gZYDg5lHITMB+Ffmh/zIL6NjK4pTvMELlh1IL0y3rmC4bouuo+o1GCrwKIyE/19P8W5jI
	 JIjTCz2vmqtqfXO0wGBXhcAph9nL6OUWAFgkvgENdQ7xXE//cYPTGbOhQDjRMC/4uusqg
	 eB/QLs3/uPyBuEtVdfRE4Uezhs8BUYkgEe0AnNwOKooNb+EjXRecF4NJxviKw+NxJng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S0wpvMbb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1644E606A322;
	Mon, 26 Oct 2026 17:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S0wpvMbb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFCA1F01825;
	Mon, 26 Oct 2026 17:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793035498;
	bh=k6TWqe6a8TrmnSxPzfBWojZNqbAoIQPtwFE2RKyIVPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S0wpvMbbVmxyhuPDPxnibJKXyr98XwfGMMYyQCZgyII0zZsb/jkU+b0YClSZ9eLzn
	 RdNJHWwEivyLczV3NKuj+MsGaYwfFqWF3coUXb7J9OGiHbWhPYsg9BLqiNL3Q7xNBw
	 dIVrKldAHUJNEsp9z6eIlBoa75zuUlIZbi5imjb0bt27O3BIZ+GrZapOR/wDx49ZGA
	 H1GJNim+Gw7Nm4XOJQuloa33dSxLqjELFiwMXItMUX2+Fp8LP1TpkkFG1oTU1r7P4/
	 pzCCDVZ1gA1Tv1vqdr0PVOFOs743YmtM9sN4XGvjloi854i6azmpsNeWutnu7nHi/x
	 lEkcvWdGSsyPA==
Date: Mon, 26 Oct 2026 17:24:53 +0000
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
Subject: Re: [PATCH v4 1/4] net: qrtr: Allow the host QRTR to assign a unique
 node id
Message-ID: <20261026172453.GH257209@horms.kernel.org>
References: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com>
 <20261022-qrtr-multi-ep-v4-1-c6fdb75fcd3e@oss.qualcomm.com>
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
In-Reply-To: <20261022-qrtr-multi-ep-v4-1-c6fdb75fcd3e@oss.qualcomm.com>

On Thu, Oct 22, 2026 at 07:43:07PM +0200, Manivannan Sadhasivam wrote:
> Currently, QRTR identifies each remote node by the value of the
> 'src_node_id' field in the received packet and uses the node id as the key
> to store the node to the internal 'qrtr_nodes' radix tree.
> 
> But this approach comes with a limitation. When more than one remote node
> share the same id, then QRTR can only add the first node to the radix tree
> and has to drop the successive nodes with the same node id as the 'key' in
> radix tree has to be unique. This prevents connecting identical Qcom PCIe
> WLAN devices to a single host at the same time.
> 
> To fix this limitation, allow the host QRTR to use the node id (nid)
> received from the endpoint driver during qrtr_endpoint_register() as the
> unique node id and use it as the 'key' for the internal radix tree. Also,
> store the received 'src_id' in a new 'qrtr_node->ep_nid' field and replace
> the 'ep_nid' with the unique 'nid' in the QRTR control packets if both
> differ i.e., an endpoint driver has passed a unique 'nid' during
> qrtr_endpoint_register(). To maintain symmetry, replace the 'nid' with the
> 'ep_nid' while sending the packet back to the remote node if both differ.
> 
> A node can also bridge other distant nodes, so the source id of an
> incoming packet is not always the id the endpoint advertises for itself.
> Keep adding such ids to the radix tree as additional keys for the same
> node, as it was done before this change. Otherwise the bridged nodes would
> lose their route and qrtr_sendmsg() would start failing with -ECONNRESET
> for them.
> 
> Currently, all QRTR endpoint drivers pass 'QRTR_EP_NID_AUTO' as the 'nid'
> during qrtr_endpoint_register(). So 'ep_nid' and 'nid' are same and the
> routing behavior is not changed.
> 
> Finally, since qrtr_node_rewrite_ctrl() dereferences the control packet for
> DEL_SERVER and DEL_CLIENT as well, extend the existing length check in
> qrtr_endpoint_post() to cover both types.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---
>  net/qrtr/af_qrtr.c | 132 ++++++++++++++++++++++++++++++++++++++++++++++-------

Reviewed-by: Simon Horman <horms@kernel.org>

