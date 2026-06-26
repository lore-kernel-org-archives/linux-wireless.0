Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550DA3EFFC4;
	Fri, 26 Jun 2026 10:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782471231; cv=none; b=jWsQH57JA5g/Uknm0+nLU5kRYaFHGjzpNtK8NJDxy7/xnpfaQWOSvQwuvnn/J4KMuLZCkhebp2MoEtd3yzUZ0CSF7gX6HwQhxjDt2bkQ0NMDFr0ElVuyEPHpYTqsrC2n2Yl34G5zHOKEfzyx9Gxi7hx4uZVneNTw5RN8pbb7ZUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782471231; c=relaxed/simple;
	bh=buHFoFbfTBSfi9LRPdDkR5ZejiADqlu7Fa/JhVvyYGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kszCJCzOY4cktI76gFqjUVO1OvLbwADYYNaxZ5vZJmgbQuyuA7gko8KQaOVJjdIfGb+CJiFhwaoLIJULO18CYrLo4qSro8cReCBwto3bG828duDWgoPA9j7IO5kLXwbJevMQtDngsAJe3D7STi1GwvjiP98gYUBA1I9P9R3/ZCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyMyQ5k5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyMyQ5k5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7CA1F000E9;
	Fri, 26 Jun 2026 10:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782471230;
	bh=Xs6FIqn23+iaFq+b1/TbaOk/+AW8nbnoFpHSIh+iuY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MyMyQ5k5eC+YQNXJ3vov1PPg4H9nfA90hYwbEBY+Mt+75uH5zvIu0vDC1rzl7/UER
	 RWeQyzy3ARhZaEokyNgcPSQvlvaSbsQpGnjuDLIH0jkSVYE4uXNa/80WW/Rk7RE8V2
	 iZeiMC9PJ9nRkeA3lGSnaKlqCCSM/ZutmprVVXFLDhYF8YXuq45P1yLkW1HAS+uAcZ
	 IIna8k9uLW2XXPP8smZx9yfNcM7xTVqcKDwYr5J1gQsjWZHtI5W7T4TovIr1+nw1pW
	 as6PQ6QfwhFz+fkuqJrclbjRzywjzJ2lEwLl563AaALbDbEPt0gQ8xAkDGE3j9hMyD
	 puZGXD4AeFwHw==
Date: Fri, 26 Jun 2026 12:53:46 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: George Moussalem <george.moussalem@outlook.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulfh@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, Rocky Liao <quic_rjliao@quicinc.com>, 
	Saravana Kannan <saravanak@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
	Heiner Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Philipp Zabel <p.zabel@pengutronix.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
	linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org
Subject: Re: [PATCH 4/6] dt-bindings: net: bluetooth: Document Qualcomm
 IPQ5018 Bluetooth controller
Message-ID: <20260626-discerning-light-swan-6b599c@quoll>
References: <20260625-ipq5018-bluetooth-v1-0-d999be0e04f7@outlook.com>
 <20260625-ipq5018-bluetooth-v1-4-d999be0e04f7@outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260625-ipq5018-bluetooth-v1-4-d999be0e04f7@outlook.com>

On Thu, Jun 25, 2026 at 06:10:08PM +0400, George Moussalem wrote:
> Document the Qualcomm IPQ5018 Bluetooth controller.
> 
> Signed-off-by: George Moussalem <george.moussalem@outlook.com>
> ---
>  .../bindings/net/bluetooth/qcom,ipq5018-bt.yaml    | 63 ++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/bluetooth/qcom,ipq5018-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/qcom,ipq5018-bt.yaml
> new file mode 100644
> index 000000000000..afd33f851858
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/bluetooth/qcom,ipq5018-bt.yaml
> @@ -0,0 +1,63 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/bluetooth/qcom,ipq5018-bt.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm IPQ5018 Bluetooth
> +
> +maintainers:
> +  - George Moussalem <george.moussalem@outlook.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - qcom,ipq5018-bt
> +
> +  interrupts:
> +    items:
> +      - description:
> +          Interrupt line from the M0 Bluetooth Subsystem to the host processor

What is M0?

Anyway, this part feels completely redundant. Can "interrupts" property
be anything else than an interrupt line from the device to the host
processor?


> +          to notify it of events such as re

This feels useful, but cut/incomplete.

> +
> +  qcom,ipc:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    items:
> +      - items:
> +          - description: phandle to a syscon node representing the APCS registers
> +          - description: u32 representing offset to the register within the syscon
> +          - description: u32 representing the ipc bit within the register
> +    description: |
> +      These entries specify the outgoing IPC bit used for signaling the remote
> +      M0 BTSS core of a host event or for sending an ACK if the remote processor
> +      expects it.
> +
> +  qcom,rproc:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Phandle to the remote processor node representing the M0 BTSS core.
> +
> +required:
> +  - compatible
> +  - interrupts
> +  - qcom,ipc
> +  - qcom,rproc
> +
> +allOf:
> +  - $ref: bluetooth-controller.yaml#
> +  - $ref: qcom,bluetooth-common.yaml
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    bluetooth: bluetooth {

Drop unused label

> +      compatible = "qcom,ipq5018-bt";
> +
> +      qcom,ipc = <&apcs_glb 8 23>;
> +      interrupts = <GIC_SPI 162 IRQ_TYPE_EDGE_RISING>;

No firmware to load?

It feels like remoteproc node split is fake. The property qcom,rproc is
even more supporting that case. Shouldn't this be simply one device -
bluetooth? What sort of two devices do you have exactly? How can I
identify them in the hardware?

> +
> +      qcom,rproc = <&m0_btss>;

Best regards,
Krzysztof

