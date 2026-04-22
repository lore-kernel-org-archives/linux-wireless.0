Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689BA32A3FD;
	Wed, 22 Apr 2026 10:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776853329; cv=none; b=Fpg6hG4PCwxjxmQM0fA15FxDrxW9wccz/gLaT372rZqb/2qU4sZEUZogp8s7BTpPy5Kk754yCT+t+bE/vtRa66+lL9itu8ppavZl+r5qcgKNTJrBtARJb/7BFShvRP8kmOb4JteT0/WuOoTX17UY2zFa3kG+6/HJwfVlu4llMbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776853329; c=relaxed/simple;
	bh=OPAbtCeUFu5JQU7TB2Kk6V+iYdS0gEp+U2RDLrMxNU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=got8GBTqay52EsPxWSpCrnn62c+s4kQ4+kXnGqCi/KFnRVDz6Pfpidiv32xL78UkmV8r6DqcASxe56aiRaQqnPMxu3r5tG5ZSo7+ffsNFMfWEJqh3nsrV8h0b1O87+3Zj1pSTJH0gmpjiT/3iPgd9U4BQ3t7FEiZCliosMjPobE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ISHZRTRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ISHZRTRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F42C19425;
	Wed, 22 Apr 2026 10:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776853329;
	bh=OPAbtCeUFu5JQU7TB2Kk6V+iYdS0gEp+U2RDLrMxNU4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ISHZRTRAUYJFeJR/cUWU0CBCQXfQw0RozDpWLUic3YUtoO9VlWqIk8NUOTGRQ0dTE
	 /oQxzoWYcTaQZuJF77gP0B61fvks1hoCvpyZ+66ezYOgllbvO62vuIN2bwxrnqO67b
	 RJoGnM7tiICpF4IgqQ+9Fjko4m9aFnObl/Zj6JJcs3Y38Jeko8QYgDu18V8wk3dNN8
	 3VubBO+riGP0xCjaU+LNgxt32MbYM1a1cZTjTnk6muBifbpFzz7k5EYnGI7RQ2OB3X
	 2eln2Le6dSfccx4GyyIIPtxB2Mpbeu4bl9bShgWH+sdP+Mv3GkkvtL2BeQuV5W7Nma
	 lK5iblz9HoOJg==
Date: Wed, 22 Apr 2026 12:22:06 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, 
	Stephan Gerhold <stephan@gerhold.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Jeff Johnson <jjohnson@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Sylwester Nawrocki <s.nawrocki@samsung.com>, Mark Brown <broonie@kernel.org>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Yang Xiwen <forbidden405@outlook.com>, Alex Elder <elder@kernel.org>, 
	Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>, Sibi Sankar <sibi.sankar@oss.qualcomm.com>, 
	Rao Mandadapu <quic_srivasam@quicinc.com>, Patrice Chotard <patrice.chotard@foss.st.com>, 
	Xu Yang <xu.yang_2@nxp.com>, Peng Fan <peng.fan@nxp.com>, 
	Thomas Zimmermann <tzimmermann@suse.de>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, ath11k@lists.infradead.org, 
	linux-pci@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-sound@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix phandle-array constraints, again
Message-ID: <20260422-spectral-caped-albatross-9debf2@quoll>
References: <20260421195836.1547469-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260421195836.1547469-1-robh@kernel.org>

On Tue, Apr 21, 2026 at 02:55:25PM -0500, Rob Herring (Arm) wrote:
> diff --git a/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml b/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
> index b30544410d09..e47e1e09300a 100644
> --- a/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
> @@ -42,7 +42,13 @@ properties:
>      description: State bits used by the AP to signal the modem.
>      items:
>        - description: Power control
> +        items:
> +          - description: Phandle to ???
> +          - description: ???
>        - description: Power control acknowledgment
> +        items:
> +          - description: Phandle to ???
> +          - description: ???
>  

Here and in all cases except qcom,msm8916-mss-pil:

 - description: Phandle to the Shared Memory Point 2 Point device
     handling the communication with a remote processor

 - description: Single bit index to toggle in the value sent to
     the remote processor
   maximum: 32

...

> diff --git a/Documentation/devicetree/bindings/remoteproc/qcom,msm8916-mss-pil.yaml b/Documentation/devicetree/bindings/remoteproc/qcom,msm8916-mss-pil.yaml
> index c179b560572b..3c614cb7ce88 100644
> --- a/Documentation/devicetree/bindings/remoteproc/qcom,msm8916-mss-pil.yaml
> +++ b/Documentation/devicetree/bindings/remoteproc/qcom,msm8916-mss-pil.yaml
> @@ -104,6 +104,9 @@ properties:
>      description: States used by the AP to signal the Hexagon core
>      items:
>        - description: Stop modem
> +        items:
> +          - description: Phandle to ???
> +          - description: ???

 - description: Phandle to the Shared Memory Point 2 Point or Shared
     Memory Manager device handling the communication with a remote
     processor

 - description: Single bit index to toggle in the value sent to
     the remote processor
   maximum: 32


Best regards,
Krzysztof

