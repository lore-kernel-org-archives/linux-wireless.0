Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3F828F5;
	Thu, 12 Feb 2026 07:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770882623; cv=none; b=o5vjpusl1wk2dERYbhTtZFX6yhl/r1ZwWkY9wOWGBdCLlmUxemtJskS2Vyx+Xw8vl38svtWDfWNongzD2a6m7JHz0PDp1XqhYx6PZAJwLBehtmIySfIkVZPjH22OZ27jH8kxJmgNvCrPYTFIxU9yCPRwK66hp8ik2mZfoXUVx6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770882623; c=relaxed/simple;
	bh=1U0C4j4IRPA7SGJDOiYWsjuxUsF/Yn+InqOZr+cYhSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VM74HQYntLCtXKMMsw4jq2F/hfEr4WM1eRGYFLaEyEEkFCxXNAVu4yBNfxyO2+Cib5zzbPwfyqpl9Vvn7zXCTvKwJPl0Jft7LItXseuHlA96puAqEURdiAlv09coIzuMXO6Y6W6ThMaOJqjzvDXOdvm6+OdNy8HOiKWZXjWDjiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UW7NcYfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UW7NcYfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC780C4CEF7;
	Thu, 12 Feb 2026 07:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770882623;
	bh=1U0C4j4IRPA7SGJDOiYWsjuxUsF/Yn+InqOZr+cYhSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UW7NcYfnLcmYeuwcnCWMFCnTnAJiWZGMuFtNCzQcC89Q59KqG+UtJJ/t63wzf+gXp
	 zJFV7X24BaSFrqc2D++308FFCFoswzbkONC9TEKbY3OQ1Nz34y2LxFPYeLVPeh2wwd
	 B3qPrFX2eVEzXghkptS5ggmXgNs/cJFidRqxQ/FfmcnPVJf95a/X8cmUwceN+RvORy
	 h918CF+m68eNbyRZsV6824QrNdbQNdD85JxTxaBbz1GE4No6UfIToRqtpNRTH52JGO
	 tlUy0zbOjJsXZxltWyn3FlL6ud8iSt+xNfPFl7vjrqtFa8zeZ/NpXegNxJTb9hbgIg
	 CmfYBX2pXAI2g==
Date: Thu, 12 Feb 2026 08:50:21 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Ryder Lee <ryder.lee@mediatek.com>
Cc: Felix Fietkau <nbd@nbd.name>, Rob Herring <robh@kernel.org>, 
	devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-wireless@vger.kernel.org, Allen Ye <allen.ye@mediatek.com>
Subject: Re: [PATCH v5 2/2] dt-bindings: net: wireless: mt76: clarify backoff
 limit usage
Message-ID: <20260212-benevolent-peacock-of-rain-afbb6b@quoll>
References: <8fa8ec500b3d4de7b1966c6887f1dfbe5c46a54c.1770856296.git.ryder.lee@mediatek.com>
 <e39bff1d56a3f8b5146b881eef3442a4af97078b.1770856296.git.ryder.lee@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e39bff1d56a3f8b5146b881eef3442a4af97078b.1770856296.git.ryder.lee@mediatek.com>

On Wed, Feb 11, 2026 at 04:36:06PM -0800, Ryder Lee wrote:
> Clarify the usage of path backoff limit properties in mt76 binding.
> Add explicit documentation for old generation (mt7915, mt7916, mt7981,
> mt7986) and new generation (mt7990, mt7992, mt7996) devices, including
> the difference in beamforming and non-beamforming entries.
> 
> Rephrase the paths-ru/paths-ru-bf description to make them more precise.
> 
> Co-developed-by: Allen Ye <allen.ye@mediatek.com>
> Signed-off-by: Allen Ye <allen.ye@mediatek.com>
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> ---
> v4:
> - revise commit message
> - use PCI id as the compatible string to replace "connac2/3"
> 
> v5: fix missing starting space in comment(comments)
> ---
>  .../bindings/net/wireless/mediatek,mt76.yaml  | 21 +++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> index ae6b97cdc..20b868f7d 100644
> --- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> @@ -27,6 +27,11 @@ properties:
>        - mediatek,mt7622-wmac
>        - mediatek,mt7981-wmac
>        - mediatek,mt7986-wmac
> +      - pci14c3,7915  # mt7915
> +      - pci14c3,7906  # mt7916
> +      - pci14c3,7990  # mt7996
> +      - pci14c3,7992  # mt7992
> +      - pci14c3,7993  # mt7990

These are two separate commits with their own separate rationale.

>  
>    reg:
>      minItems: 1
> @@ -252,6 +257,14 @@ properties:
>                        followed by 10 power limit values. The order of the
>                        channel resource unit settings is RU26, RU52, RU106,
>                        RU242/SU20, RU484/SU40, RU996/SU80 and RU2x996/SU160.
> +                      - For mt7981/mt7986/mt7915/mt7916
> +                        - Beamforming entries for BW20~BW160 and OFDM do not
> +                          include 1T1ss.
> +                        - When 1T1ss is not used, it should be filled with 0.

Shouldn't be skipped in such case? Why filling with 0 matters?

Best regards,
Krzysztof

