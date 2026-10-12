Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301CC43031A;
	Mon, 12 Oct 2026 19:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791832432; cv=none; b=Y9Xta/XnSHVoePhy3JtKvITp7IpQdbZHRKUvRq8MWuvJwtWwy7nLaE541Mj/jlfwLJElinyuLoGPmmIeGq2Ott2KeEn2d782vItGMx8SZ91rkE4KdnmAXC+tINaspi2uLDQQYAIHtZHcofT+r5VuUQvoa2vXtVPOXPs0di6mstA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791832432; c=relaxed/simple;
	bh=WiBpaWrneHsdT0O3JeZ6v96qWwB7nkTXHuzdbJJO0lQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8k0G5ckEq+IPUb6KaJP1gesRj0oJkKHahqGi98XlmofgSwIs0S877ME+Z0TUU1krZZHSa0FuhOsacbfseCqKUTMFmitKeTHvvnXEEz8e8AD0p7LkoNGHqx8OCwTcbmALJXUPZi5tmAoyl06gZIhxj3Iuxh1hSRovZ/8sxrK9/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQHOBtyi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQHOBtyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E18C1F0089B;
	Mon, 12 Oct 2026 19:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791832430;
	bh=e+1HL+K4E7k1ZUW68HwqofIsZ+ul0vVMKVQnqqa2TS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HQHOBtyi7WrGEmcuw//F0IeOzS7vm8Tqhd4zbZjYEaIVz6E4kJdpg1BXHDz0fVvSO
	 Yt7hYO+kAZFbNBGpeMDsyHaFE3XxufZ7xHLbwsfpCugyrFG7RVgWHFcEqtyvxtk3bJ
	 l8rtTCh+Qp9Y5HCn0KyC4w5Ynwcm9I3hs0xi0NmiOH3l4U/pb8fVLCcCMUsUmjQ6Pu
	 JCROvbyDn7liNDZ47dFdt1l9HYohMWtW62JiO+3lhkjNHzQKN7HPm/5WJDru69Kniu
	 KB+I4RYXltAPrZUjLLk0bYWEUs3mhmLyhIGoPSdolmIRvIFkjvU/ekhpgPlkG5lP1O
	 66taWHBFQk3Ag==
Date: Mon, 12 Oct 2026 20:13:46 +0100
From: Conor Dooley <conor@kernel.org>
To: Alessio Ferri <alessio.ferri@mythread.it>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dt-bindings: bus: add Broadcom BCM6362 WLAN AXI
 backplane
Message-ID: <20261012-shaping-runway-7e6065b8d730@spud>
References: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
 <20261012-bcm6362-wlan-v2-1-4752da7e0982@mythread.it>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XLK6Wp0Pn8M8z16J"
Content-Disposition: inline
In-Reply-To: <20261012-bcm6362-wlan-v2-1-4752da7e0982@mythread.it>

--XLK6Wp0Pn8M8z16J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 12:45:25AM +0200, Alessio Ferri wrote:
> The BCM6362 integrates a WLAN macro on its own AXI backplane.
> Unlike the backplanes covered by brcm,bus-axi, its cores have no
> wrappers: clock gating and reset are driven through a separate
> WLAN control register block, and the macro needs a clock, two
> resets and the WLAN pads power domain before the backplane can be
> accessed. The backplane registers are big-endian.
>=20
> Add a binding describing the ChipCommon and WLAN control register
> blocks, the clock, resets and power domain, and the interrupt-map
> used to route core interrupts, following the brcm,bus-axi
> convention.
>=20
> Assisted-by: LLM
> Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
> ---
>  .../bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml    | 100 +++++++++++++++=
++++++
>  1 file changed, 100 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-=
axi.yaml b/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.=
yaml
> new file mode 100644
> index 000000000000..183de28fd032
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
> @@ -0,0 +1,100 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/bus/brcm,bcm6362-wlan-bus-axi.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Broadcom BCM6362 integrated WLAN AXI backplane
> +
> +maintainers:
> +  - Alessio Ferri <alessio.ferri@mythread.it>
> +
> +description: |
> +  The BCM6362 integrates a WLAN macro on a dedicated AXI backplane
> +  (bcma), whose cores are discovered at runtime from the backplane
> +  EROM.
> +
> +  The cores have no DMP wrappers: clock gating and reset of the
> +  ChipCommon and 802.11 cores are controlled through a separate WLAN
> +  control register block. The backplane registers are big-endian.
> +
> +  Interrupts of the cores are described with an interrupt-map, keyed
> +  by the core base address and the core interrupt index, as for
> +  brcm,bus-axi.
> +
> +properties:
> +  compatible:
> +    const: brcm,bcm6362-wlan-bus-axi
> +
> +  reg:
> +    items:
> +      - description: ChipCommon core registers
> +      - description: WLAN control registers
> +
> +  reg-names:
> +    items:
> +      - const: chipcommon
> +      - const: wlan-ctrl
> +
> +  clocks:
> +    maxItems: 1
> +
> +  resets:
> +    items:
> +      - description: WLAN macro reset
> +      - description: WLAN UBUS interface reset
> +
> +  reset-names:
> +    items:
> +      - const: wlan
> +      - const: wlan-ubus
> +
> +  power-domains:
> +    maxItems: 1
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#interrupt-cells":
> +    const: 1
> +
> +  interrupt-map-mask: true
> +
> +  interrupt-map: true

I'd like to see some constraints on these, particularly since there's a
very high chance the mask is fixed and the map has a fixed number of
elements.

I'd also like to see what the child nodes on this bus look like. Do you
have some dts examples?

Thanks,
Conor.

> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - clocks
> +  - resets
> +  - reset-names
> +  - power-domains
> +  - "#address-cells"
> +  - "#interrupt-cells"
> +  - interrupt-map-mask
> +  - interrupt-map
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/bcm6362-clock.h>
> +    #include <dt-bindings/reset/bcm6362-reset.h>
> +    #include <dt-bindings/soc/bcm6362-pm.h>
> +
> +    bus@10004000 {
> +        compatible =3D "brcm,bcm6362-wlan-bus-axi";
> +        reg =3D <0x10004000 0x1000>, <0x10007000 0x100>;
> +        reg-names =3D "chipcommon", "wlan-ctrl";
> +
> +        #address-cells =3D <1>;
> +        clocks =3D <&periph_clk BCM6362_CLK_WLAN_OCP>;
> +        #interrupt-cells =3D <1>;
> +        interrupt-map =3D <0x00005000 0 &periph_intc 7>;
> +        interrupt-map-mask =3D <0x000fffff 0xffff>;
> +        power-domains =3D <&periph_pwr BCM6362_POWER_DOMAIN_WLAN_PADS>;
> +        resets =3D <&periph_rst BCM6362_RST_WLAN_SHIM>,
> +                 <&periph_rst BCM6362_RST_WLAN_UBUS>;
> +        reset-names =3D "wlan", "wlan-ubus";
> +    };
>=20
> --=20
> 2.56.0
>=20

--XLK6Wp0Pn8M8z16J
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCas0xagAKCRB4tDGHoIJi
0u/EAQDgSrA59Z414eccbC0OF8UPlkzMqv2ddepVsuiTykXP3AEArYD6znyM4ixO
OsQ7/F7ggIliNwYKsIhk4aqAZsU8fAI=
=zvgx
-----END PGP SIGNATURE-----

--XLK6Wp0Pn8M8z16J--
