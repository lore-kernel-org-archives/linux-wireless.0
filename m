Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D85949D5B1;
	Fri,  9 Oct 2026 10:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791541809; cv=none; b=W94Nt2XKHkCBVi3TgC/+sxNdB77Xb2yYU4ILhmlM4Hn1P/k67jqO/zrZnIrkHPaUUH1GlQo6JfnP8chrsNC5ATiuv/Yzp/R1HMCI+TPozDaag/NERNh/RC1j9UN2kW/qhe6LH/zY1izkEb1h+bPzS/1eupluCcokoeDvjkHZE1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791541809; c=relaxed/simple;
	bh=wUKKD5uvsh1V47TRX60qialTIpDacu+370UBlWliLQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fya7muJ15lpN1GeE9u3UKA1Tm3N+bXlOklr65KVNa4VcS9mf3LWG0tSVvxaQtq+d6ohQlLL9oLnqbN/u4zdIrSWVcug2hEyJAeIgoUeSyiYuD9u2+fJ06nmhZ9+Dr+hwb5ZUJs/iSWids1ntnaND1A/H/3WzJNqh9KfslsekThk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6e2Qf0e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6e2Qf0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6241F000FF;
	Fri,  9 Oct 2026 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791541807;
	bh=gBkCeYVqmSb3prSHngCK69WNaY6mX9aeLJas4Zai/rc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R6e2Qf0eWYTgeySbgvyFPddjgtR3ExeP/Xp0JQc0LklEF2alM100T1WG7UwBX5Uca
	 TKN2QY0qD/mV6jUvSipzC9bSV4r580y6NU/OMkHCPLxMHLxZU1imTrA+2u3UkrCWO8
	 mfkc1XVJAG5Vn1VRfrXz6UG6Y/733EMcEEo3/xtUfYfYCBZzvGnGhcuuCsldBDpKua
	 Qgz6SRQldFvH73lyfWMinJ3sAHucgtg5sItzTwNbd+yF1/pXZJ88dnnTVkLfAFqwNF
	 DM+h49+3z5nnsNkOxiDBLwbnrVMy3uMrODCeth2kE3efVKDYxJlgN180Wh1Rp84yaI
	 AjivVt8fFdcIA==
Date: Fri, 9 Oct 2026 12:30:04 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ath12k@lists.infradead.org
Subject: Re: [PATCH ath-next 01/17] dt-bindings: net: wireless: Add QCN6432
 device tree binding documentation
Message-ID: <20261009-brainy-alpaca-of-focus-31fbbd@quoll>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
 <20261008-mpp_bringup-v1-1-2c5797b5e4ac@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261008-mpp_bringup-v1-1-2c5797b5e4ac@oss.qualcomm.com>

On Thu, Oct 08, 2026 at 03:53:57PM +0530, Aaradhana Sahu wrote:
> Add Devicetree binding documentation for the Qualcomm QCN6432 IEEE 802.11be
> wireless device.
> 
> QCN6432 is attached to the WCSS Q6 subsystem and is represented as an AHB
> platform device, even though the Wi-Fi hardware interfaces over PCIe.
> Document the compatible string and the resources, including the Q6 remote
> processor phandle, MSI interrupts, SMEM states and memory regions.
> 
> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
> ---
>  .../bindings/net/wireless/qcom,qcn6432-wifi.yaml   | 149 +++++++++++++++++++++
>  1 file changed, 149 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,qcn6432-wifi.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,qcn6432-wifi.yaml
> new file mode 100644
> index 000000000000..97d8885333fa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,qcn6432-wifi.yaml
> @@ -0,0 +1,149 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/wireless/qcom,qcn6432-wifi.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm Technologies QCN6432 wireless device
> +
> +maintainers:
> +  - Jeff Johnson <jjohnson@kernel.org>
> +
> +description: |

Do not need '|' unless you need to preserve formatting.

> +  Qualcomm Technologies QCN6432 is an IEEE 802.11be Wi-Fi device
> +  associated with the WCSS Q6 subsystem. The device is represented
> +  as a platform device and uses MSI interrupts for its Copy Engine
> +  (CE) and Data Path (DP) rings.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - qcom,qcn6432-wifi

Is there qcn6432-something-else as well? Neither commit msg nor
description explain that.

Best regards,
Krzysztof

