Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D31221F06;
	Sat,  4 Apr 2026 11:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775300621; cv=none; b=MHoMaaSuZj5bUkHFN10kYLSwuK3LutYK52vehEwP7i8Jxt006+8gSWhRaENHu8HfiYEBNUKyNMPO8vT+TP2sMKCf3BxCasvTEvu62hsn30sDL68hGLGfq2jwC/fLCNvtwd5NbYhbYnCtIvWU/Q40hW6mOm4u4kbAlhEkSMc9uP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775300621; c=relaxed/simple;
	bh=6St2+FWQW6l2+yulRPhL9B9LaFWvnweTQb8aao65BJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eDTM0a33DY/185BaI19yg9+xmZSFoIy9Xx0bxj5FLCPvaVw+2zPtcIu3kVpd95WcfxFFfXUbgd0Q4yEDUXdUG/gF+6z6PtpYHLur9vDBK7uQI0OOBVbqDoSuO8rt4031/zW+zBWFjpxnAsM/BceF0rrtUBGy+l0prD4PADbl7JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlNyJzEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlNyJzEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B5BC19421;
	Sat,  4 Apr 2026 11:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775300621;
	bh=6St2+FWQW6l2+yulRPhL9B9LaFWvnweTQb8aao65BJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LlNyJzEP1vCy3VsXqvb+qYWW7ZgAAcWmqH3alo3kX5XyniTbUiC/P0mDfU/ml39KV
	 0bOSX5o1nV5jSsW3IXO9FT/REUxr+KXeBtDRpTjuZkw7/77HI04blC8qRB5T2S13nJ
	 dDgveJhRGnQ/4gyG9p2PLkN0UUEON9oS/fh764MK3IL2wt6ehQsFhK6+IX7BABewy4
	 3pEl+awEVmsfviM7h3WUMU1n5tz8UK+hZMbnkQnKRUjRciQ7LL9LdfathHb+BrLkM1
	 eM467LdIvq2ZKSCC5xLOH3WalCvBVkE93O1MValbuQh+qOmgjYS315D+J1ICMy678L
	 batJXhfwJvgzw==
Date: Sat, 4 Apr 2026 13:03:39 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Alexander Koskovich <AKoskovich@pm.me>, Liam Girdwood <lgirdwood@gmail.com>, 
	Mark Brown <broonie@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, Rocky Liao <quic_rjliao@quicinc.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Jeff Johnson <jjohnson@kernel.org>, 
	~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
Subject: Re: [PATCH v2 3/7] dt-bindings: net: wireless: ath11k: Document
 WCN6755 WiFi
Message-ID: <20260404-sceptical-benign-chachalaca-e13aa9@quoll>
References: <20260403-milos-fp6-bt-wifi-v2-0-393322b27c5f@fairphone.com>
 <20260403-milos-fp6-bt-wifi-v2-3-393322b27c5f@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260403-milos-fp6-bt-wifi-v2-3-393322b27c5f@fairphone.com>

On Fri, Apr 03, 2026 at 03:52:49PM +0200, Luca Weiss wrote:
> Document the WCN6755 WiFi using a fallback to WCN6750 since the two
> chips seem to be completely pin and software compatible. In fact the
> original downstream kernel just pretends the WCN6755 is a WCN6750.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  .../devicetree/bindings/net/wireless/qcom,ath11k.yaml    | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

