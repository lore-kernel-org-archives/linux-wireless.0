Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168DC3BBFB0;
	Thu, 24 Sep 2026 14:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790260102; cv=none; b=gLHK8WQvsCyP5gSJB5K2dt7Ou0ruSr/+6mn8zPYdjnjdnOo5Hx5wa+c097Uhl3WKvaccrMeso8DDmVbm5UVu097Xd9kAIPtjaYFIhkc55J7XtwjgxkKqzThCeJwOTSCDIAJw0z2ME1BdsL90Ra6FOm+jIdCNXzg7UXE9fxfzjuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790260102; c=relaxed/simple;
	bh=alBl+O2HSPgUzj0RFfoWl4iYOlDwdDDXSrV/YmvQhsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ml7S7hjgc1Z9D6sxmPWg5vosC4+QrO2vZqda8rGJgUWkXEqCBikogr1EMNg9uXzPrBe9VW8L62SPZZxQYAXFiwv8OF0dc8ml55I7RolcQIbGAI3s9BcNa9X7OsCYkcrDUkQgwFDBHfzmxrXATFdUVuhAAo2eYSyGhwH3gSGPfEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ldrv+j6p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldrv+j6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B2A1F000FF;
	Thu, 24 Sep 2026 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790260096;
	bh=oBGeYaT7U7Oeqkdin5+zXLHvnMbkDCbYA00G5ZSA5N4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ldrv+j6p5LSbs0gKXl3lUpryj2GVrvXfQO7w+yzvHX/puIJe0SyT2ixY6Ap283/Bl
	 THdzBIvSOpZCHKDOA8Fwv7K4xEopkOXLy0g2nAC9C73cfnX7EGgIAW+dEHxWG6Egvm
	 s7HqMhQWyHuDI+J6rxjPNtVx81CBA9lHlkRBmnIQsmC3IUb3XLxD/9Zl/YwSd4DAzc
	 0/iLXDyhvwte6ZknHWkveUdAN7+kc1MhgyKsoAuh+u2QkZC/hGeOb1vY11up9VBiHl
	 x0GuQY5UbLGW0KvGyHnCNZghAEI4VZ7fhAs3Ph5xyPrer9Z+nTvmYwshBUCybdMpWy
	 X1zzWPWNykrSw==
Date: Thu, 24 Sep 2026 16:27:57 +0200
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
Subject: Re: [PATCH v2 2/4] net: qrtr: Assign unique node id for MHI endpoints
Message-ID: <qu6bdcvaueap22snis66orodtwx4cwhkxfzk7kpr7laqbr2hxg@2iilvscjqtcx>
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-2-27dd80d841a0@oss.qualcomm.com>
 <a16d507e-17f7-4074-8817-4b8da3a71c3b@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a16d507e-17f7-4074-8817-4b8da3a71c3b@oss.qualcomm.com>

On Tue, Sep 22, 2026 at 06:14:21PM +0100, Youssef Samir wrote:
> 
> 
> On 9/21/2026 12:23 PM, Manivannan Sadhasivam via B4 Relay wrote:
> > +
> > +/* The offset is chosen carefully to not collide with the node ids allocated by
> > + * the remote nodes. All the remote nodes use node ids in range 0 to 0xffff.
> This assumption does not hold up for QRTR V1 headers where the node ids are 32bit.
> QAIC devices use BHI_SERIALNUM as the node ID, and it is definitely larger than
> 0xFFFF.> + */

This is true. I only considered the v2 devices. Will fix this comment and the
code.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
