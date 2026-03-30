Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C714B3939BD;
	Mon, 30 Mar 2026 06:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774852200; cv=none; b=ZE8+zWOH/xFU4y0/V7Av4QvE3iF1mXtb2BRrU6M3nnuahze+9aoxdV/qYsh2QdxieB1f45IMcMLlFhpRiNJ+SP/OCjwyH2ORc5Tj3uGCH3q8+Jb/N2hOmgdmuyc7/aTWSVl36rnqXlksnuedHEXcnlcriLHhYR1P003ngQJ9wwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774852200; c=relaxed/simple;
	bh=035aYXpJRW2cnLWGbph4ptLu8VVBvXeKIlejv+8hpVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rKUB/HvM8idLE+VChDpRclsygw3OWSUrmo1TIejpatG0W/ADcsIyvc6h+ZF/sAIhlToychHSLMzLTFp6iCKD+Ks0Q7RYYQiV/FFpMzAmgeSFdNxeiZjCfimqeyjuJ3bhywmWeYDpF3vIXajMQhUNbuDd/ZV7ie5vlrtYCNUAZKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sAap5ILN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sAap5ILN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0708CC4CEF7;
	Mon, 30 Mar 2026 06:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774852200;
	bh=035aYXpJRW2cnLWGbph4ptLu8VVBvXeKIlejv+8hpVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sAap5ILNduf99Z2ehiqgpjwUfo5MqIvhYLE72v04gGyFNT1vPdmm2znMIBN/1WPxv
	 KFsmu4d/uEKwe4XwHGphBp0Vw7GsXJYYR6ENvjTAL0kG+11TPgBF7lAskT6NKaKXv3
	 SqpRuekj2IYI74IFT03P/UKrpKruyJc/fJrbTlvXFEZhcfnBYmP2r3QBNjMbvr6xs6
	 X0Rgga6H6yaX5JaJ96l+QcsN4bSAW7HOePJIybS6egOCDftuDv/k3vMpPAGFTMgv5p
	 zdmnBwa7Ysw4rlo8bnuuyuRkb457dCwRAwGl8aiZEoem/hIHfd217rZEav/6X6pLnq
	 CcrmVuNPPxuXw==
Date: Mon, 30 Mar 2026 11:59:41 +0530
From: Sumit Garg <sumit.garg@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
	linux-media@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
	linux-remoteproc@vger.kernel.org, andersson@kernel.org,
	konradybcio@kernel.org, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, robin.clark@oss.qualcomm.com, sean@poorly.run,
	akhilpo@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
	jesszhan0024@gmail.com, marijn.suijten@somainline.org,
	airlied@gmail.com, simona@ffwll.ch, vikash.garodia@oss.qualcomm.com,
	dikshita.agarwal@oss.qualcomm.com, bod@kernel.org,
	mchehab@kernel.org, elder@kernel.org, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, jjohnson@kernel.org, mathieu.poirier@linaro.org,
	trilokkumar.soni@oss.qualcomm.com, pavan.kondeti@oss.qualcomm.com,
	jorge.ramirez@oss.qualcomm.com, tonyh@qti.qualcomm.com,
	vignesh.viswanathan@oss.qualcomm.com,
	srinivas.kandagatla@oss.qualcomm.com,
	amirreza.zarrabi@oss.qualcomm.com, jens.wiklander@linaro.org,
	op-tee@lists.trustedfirmware.org, apurupa@qti.qualcomm.com,
	skare@qti.qualcomm.com, linux-kernel@vger.kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: Re: [PATCH v2 02/15] firmware: qcom: Add a generic PAS service
Message-ID: <acoYVdr4wBEqwFoM@sumit-xelite>
References: <20260312062756.694390-1-sumit.garg@kernel.org>
 <20260312062756.694390-3-sumit.garg@kernel.org>
 <20260313072450.sx7vqtvh62nflhff@hu-mojha-hyd.qualcomm.com>
 <acE3MR4SVCPUzcgR@sumit-xelite>
 <2da6cbcc-677d-4ba8-9762-ecb47b157f21@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2da6cbcc-677d-4ba8-9762-ecb47b157f21@kernel.org>

On Fri, Mar 27, 2026 at 02:39:24PM +0100, Krzysztof Kozlowski wrote:
> On 23/03/2026 13:50, Sumit Garg wrote:
> >>> +
> >>> +#include <linux/device/devres.h>
> >>> +#include <linux/firmware/qcom/qcom_pas.h>
> >>> +#include <linux/kernel.h>
> >>> +#include <linux/module.h>
> >>> +
> >>> +#include "qcom_pas.h"
> >>> +
> >>> +struct qcom_pas_ops *ops_ptr;
> >>
> >> Should this be static ?
> > 
> > It was static earlier in v1. I dropped it based on earlier v1 discussion
> > with Krzysztof. Let me conclude that discussion on the other thread
> > again.
> 
> The discussion was whether this should be singleton in the first place,
> not making it a global singleton.
> 
> Of course it cannot be anything else than static - nothing should poke here.

Sure, I have put the static back for v3.

-Sumit
