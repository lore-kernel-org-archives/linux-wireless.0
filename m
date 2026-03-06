Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595F039E6D6;
	Fri,  6 Mar 2026 15:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772812326; cv=none; b=VLUzrr2dg8vx9waSq7/aWfZiGm4G/qvTh9L2gkKDbYj2zLB7jF6NVkDrC+VZrC58JkJlHvjzYZRpOffWFhDZ1ktWE7N4Jtqm+3RuvRjvQZoGYwXqOHG4X/PCPYWFvz/JeiBy55zGT5YwqppMU2QJEqPLzghEFShEBXwXwfDwgG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772812326; c=relaxed/simple;
	bh=VB7z6G4/ZLlDD7r7FKPmMsl9wkW7kNZ+4WwUIRbuOyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=boad8oRT+wr68MU2yuk/HftAfLcHGZNPuDz/yhGVqSmPyMzmAatKRrgyj4WkjqRjp2Ivnc86eZafEb+uOgbrhkeprLs4c+XLnddBNCnUdmsisa8S4PqdchvhlgUvl90ALbdIXAbY1KwLB88sDD+rB5BIziXRjHF7ZsCI1zZ0tvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sDoh2dpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sDoh2dpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153C4C4CEF7;
	Fri,  6 Mar 2026 15:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772812326;
	bh=VB7z6G4/ZLlDD7r7FKPmMsl9wkW7kNZ+4WwUIRbuOyo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sDoh2dpx7TsNXplh355AlqTBYRr5byBVn6JZf1XoqnYR1K+T+maAULQRE1A8qMTKg
	 xHtDnGP3+GPygxGHbqLIvytNB/VHWUllxD053WfzTs9wBqALLwbozdBF0kwn8YAiHi
	 Xu+QgLYJOxkJYXesCociGAm3EP56F0PYeEeSS654JMCMTmP6hSLKZ10k+hxyes9CS7
	 fc1mRKGwqqkaaOT8ht0+Lr30ETzX5q8TdzY8TBMqGfrLO191G538lT12CTQC62TveW
	 Unm/228UfIdJvqzUYQpEGHVCvmMkdgkcg+yf2e0/KQQIz8ISf60N9dK2kpAVokD3WG
	 +CtPHgNkHZr8w==
Message-ID: <eb0ef26d-d1db-43b9-8113-a7c977d4b8cd@kernel.org>
Date: Fri, 6 Mar 2026 07:52:01 -0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/14] wifi: ath12k: Switch to generic PAS TZ APIs
To: Sumit Garg <sumit.garg@kernel.org>, linux-arm-msm@vger.kernel.org,
 devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, linux-media@vger.kernel.org,
 netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath12k@lists.infradead.org, linux-remoteproc@vger.kernel.org
Cc: andersson@kernel.org, konradybcio@kernel.org, robh@kernel.org,
 krzk+dt@kernel.org, conor+dt@kernel.org, robin.clark@oss.qualcomm.com,
 sean@poorly.run, akhilpo@oss.qualcomm.com, lumag@kernel.org,
 abhinav.kumar@linux.dev, jesszhan0024@gmail.com,
 marijn.suijten@somainline.org, airlied@gmail.com, simona@ffwll.ch,
 vikash.garodia@oss.qualcomm.com, dikshita.agarwal@oss.qualcomm.com,
 bod@kernel.org, mchehab@kernel.org, elder@kernel.org, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, jjohnson@kernel.org, mathieu.poirier@linaro.org,
 trilokkumar.soni@oss.qualcomm.com, mukesh.ojha@oss.qualcomm.com,
 pavan.kondeti@oss.qualcomm.com, jorge.ramirez@oss.qualcomm.com,
 tonyh@qti.qualcomm.com, vignesh.viswanathan@oss.qualcomm.com,
 srinivas.kandagatla@oss.qualcomm.com, amirreza.zarrabi@oss.qualcomm.com,
 jens.wiklander@linaro.org, op-tee@lists.trustedfirmware.org,
 apurupa@qti.qualcomm.com, skare@qti.qualcomm.com,
 Sumit Garg <sumit.garg@oss.qualcomm.com>
References: <20260306105027.290375-1-sumit.garg@kernel.org>
 <20260306105027.290375-14-sumit.garg@kernel.org>
From: Jeff Johnson <jjohnson@kernel.org>
Content-Language: en-US
In-Reply-To: <20260306105027.290375-14-sumit.garg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/6/2026 2:50 AM, Sumit Garg wrote:
> From: Sumit Garg <sumit.garg@oss.qualcomm.com>
> 
> Switch ath12k client driver over to generic PAS TZ APIs. Generic PAS TZ
> service allows to support multiple TZ implementation backends like QTEE
> based SCM PAS service, OP-TEE based PAS service and any further future TZ
> backend service.
> 
> Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>

Acked-by: Jeff Johnson <jjohnson@kernel.org>

