Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793035556;
	b=fKu0IJ8rLm+DQ162xF9Gd1TW1c2kjgfNgCVz10wCzMPewSlJKCNi/MVIWBMubra8DI3w
	 Y6rxEzv4oR26UbrFHJb/lXL0x54qiFJae3m8PKTq/94ofWU8dZInow19EwvRKhrpYl9mb
	 lH+CMUNY+DIwTKrPRG0OoHqdJ8NeueFQ/yTL4qaL2IQ54rt3WThMztD7Hzo9nb5lbyb4n
	 EraLwUs3rFhRk1LaPlWlgcthyyIT8s7Oltz7M7KO5o6j4WnKltbhh3dhhdjN16puO63Xa
	 29L8UrrFPsCRLQTbAp9zu57jZfNWd3itS9xAv4nc/ntBYkOjHgVGXdkBXvO7RoE5OWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793035556;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4flWI2WVnwFI/fTrvl/y9DbpMdHilW4fazMAT/2C8K4=;
	b=qkzgOO8Suc/CN1AxQcIQvciFT7/Pmhqb4uasS64yzFYBjyJpERXWAUOJOFveuFOX3bnM
	 5lzoXICIcBsonzoL+sKMFQIVSKFuIfp3RzqMsaDFRAtA5gCjz/nKihaPSK83fEB9Q6KgP
	 f/eqcpnyhrfCqLAsQ4sSm68lptZIJUuFL9uAGT1BniYjwS5rq8veFvM3tA0QtQhEBLe3R
	 tyqFJh2IZ56diq303jCpv1pw4RSsDOsE8olFdaOdCGN+9S0E3d8SwJaRHpe1x8ao3FPxn
	 HnaTFBT2YFYN4hP5UNDcyjTappFzbMr8o7WrPuFr5VV167HI40E6g+J3di7h3G61vtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="do/DnN1s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45643606A31D;
	Mon, 26 Oct 2026 17:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=do/DnN1s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8AA1F031E1;
	Mon, 26 Oct 2026 17:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793035556;
	bh=4flWI2WVnwFI/fTrvl/y9DbpMdHilW4fazMAT/2C8K4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=do/DnN1sS/BFglJXOVc3eSqMWCTulTWj7p+/8C3vlAjiIZXkLfkFq6Swf3Uyn1IUU
	 Sj1q08ywy4L7I4hshh4mggb81RpchiYROxIIos+HPKXxZmsJ6WcqSD+8S3CZOOTE9g
	 qjvHFXmXB9W2eRZQ9Jogkt8laFHm4/M19aEW2a/HErOn2EIkWygQkWrYrUSW4IStr4
	 EMsE9KAHgg9TF3Vtb88B8eqVr1iH0YB3LV9tnrFmp8odKW4wOjD7ovpWx49ulxtBmA
	 9X+Qvsz7hDgthb4wgYZRcfYNPc8g60Spyim+kDi2YZ3E5HhzAyp9dei5iTrZqY+deG
	 jA0LRiGwZaZBA==
Date: Mon, 26 Oct 2026 17:25:50 +0000
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
Subject: Re: [PATCH v4 3/4] wifi: ath11k: Connect to the QMI server belonging
 to the device owned by this driver
Message-ID: <20261026172550.GJ257209@horms.kernel.org>
References: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com>
 <20261022-qrtr-multi-ep-v4-3-c6fdb75fcd3e@oss.qualcomm.com>
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
In-Reply-To: <20261022-qrtr-multi-ep-v4-3-c6fdb75fcd3e@oss.qualcomm.com>

On Thu, Oct 22, 2026 at 07:43:09PM +0200, Manivannan Sadhasivam wrote:
> When two identical ath11k PCIe devices are connected to the same host, both
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

