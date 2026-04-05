Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75C27081E;
	Sun,  5 Apr 2026 22:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775428124; cv=none; b=EE35lUakk7fVAfNOkCLomVGNnrvXFzh9I0/9SC1rthqA1l61rFDb8hET3stNRveaDrHKqIZm7PNIsVsp+pGKvdaRbcRd44Ei3KHe1bEWvmD9iJzDp27SBE9SD2Id2uyl7xBXLf0pNOhlJNgd6y2p5R1eI3PDO7bzMwUeG2UZT7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775428124; c=relaxed/simple;
	bh=sbn7cSt43ByRtf5P3IZPaeZopVX1YvGYKd1MKlCCcAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b6Niw5d0eJnbTT7vI1l5Bmc0P1ueb+wqYkS7N47Gi5LRlYGeq44Lv5VgI8vdBrOFkNBGz/ZCqK6Gn5D7VhxF/ToOFsIFkmADLT6Eg5NdlqGztJKDUqwXpbiSOmB4RizKU2Vr3uunl+m34fJID3ynd/ICd0cLQshnIPVuOQ/gP2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pSSRAZ6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pSSRAZ6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D3BC116C6;
	Sun,  5 Apr 2026 22:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775428124;
	bh=sbn7cSt43ByRtf5P3IZPaeZopVX1YvGYKd1MKlCCcAg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pSSRAZ6uFllVa4WTmvevDT1RFY0M6Uyk8CQaZjE8TmGJeocgkzazCFH7IhxytBtd5
	 QE+LFHDEyuDgQDzYdwLBR0/ccFzoAQn/Va1m8DKTMyxlF8mZKbNqFpotCYLTdToIZ6
	 h29e0CezOrumd3pcc6+1bagOyoDE7iG8uSf35Wn3HXjhLpAWj7eb3cewwzd+6bclnW
	 a2zYWnYPwOEUPervov4yFvAKC89M4yr9tmJU1LrYC2OOSpYG14Khmmhtged+8hnClv
	 H1g7F7sASIbxBbNnzcw8vMZr0bhCMB47jIPc62YAA8c+SbpE8MWPURDCcKNOG6dC8P
	 PcdnWItiZxY2g==
Message-ID: <b7520942-865a-450f-8b06-1b5cbc95c7c2@kernel.org>
Date: Sun, 5 Apr 2026 15:28:42 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] dt-bindings: net: wireless: ath11k: Document
 WCN6755 WiFi
To: Luca Weiss <luca.weiss@fairphone.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Alexander Koskovich <AKoskovich@pm.me>,
 Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
 Bartosz Golaszewski <brgl@kernel.org>, Marcel Holtmann
 <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
 Rocky Liao <quic_rjliao@quicinc.com>,
 Johannes Berg <johannes@sipsolutions.net>, Jeff Johnson <jjohnson@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
References: <20260403-milos-fp6-bt-wifi-v2-0-393322b27c5f@fairphone.com>
 <20260403-milos-fp6-bt-wifi-v2-3-393322b27c5f@fairphone.com>
From: Jeff Johnson <jjohnson@kernel.org>
Content-Language: en-US
In-Reply-To: <20260403-milos-fp6-bt-wifi-v2-3-393322b27c5f@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/3/2026 6:52 AM, Luca Weiss wrote:
> Document the WCN6755 WiFi using a fallback to WCN6750 since the two
> chips seem to be completely pin and software compatible. In fact the
> original downstream kernel just pretends the WCN6755 is a WCN6750.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>

Bjorn, will you take this entire series through your tree?

Acked-by: Jeff Johnson <jjohnson@kernel.org>


