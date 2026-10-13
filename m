Received: from smtpcmd11117.aruba.it (smtpcmd11117.aruba.it [62.149.156.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B37C519922
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 16:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791907774; cv=none; b=eYLMcXFUAj1Dg8GfFADguLxYJmFdd6CcBV7YGmBR0HUvgtM7YTnJipnz6G7x0VEY94yVa5CBDwSXSM3qhkVPh0beH01dEp/TeQ32Fc3Yi6781UJx1+fNETaWtxt7wmA0zYmPu3FidMRhnCQmnwqvv2h+iNcyBNVcV0U8AtkVGFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791907774; c=relaxed/simple;
	bh=Qfh5QWCjb4o37+8Uqlgy4Xz2ZTocmWaQo5YDRfozQks=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DTCwtCVo9BYF6kwdl0CPgpnpzCyorgsocoA1hiURhXsGZmfG2m8d3XTeXU3FkYpMYNL+GokDVQ2dLs8JEEQoVnR7N0Ejsar5p6PZLvaTPAn0w9WbzbrWlTp5nd8qUjFjWX5CCKMIV3X7vaumP9Z/1Uf1SVfeGePcvGvYoHrMd5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=kAaSHeWq; arc=none smtp.client-ip=62.149.156.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="kAaSHeWq"
Received: from DELL-MOBILE03.ad.smart.it ([77.89.54.34])
	by Aruba SMTP with ESMTPSA
	id Gf4BxHTh8XXg5Gf4Bxkq6f; Tue, 13 Oct 2026 18:09:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791907767; bh=Qfh5QWCjb4o37+8Uqlgy4Xz2ZTocmWaQo5YDRfozQks=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=kAaSHeWqKM/+iyRc6vrbC1vXQ+gaThr7R+mrKW9H3C+YJ2ep4XLbwmePTaQyyJv29
	 PNjXCR0bv+05uud9+TR+sYEIN2dr0vPJqNFvMBfhnNgN3EnONDARbakPEwWf+cn2sA
	 oh8vu8yM4xmMrYz1OyTL7AcZhMcLCHDxvg6O+ZCGbF335hIUrh/lNKN9N66Jb6ccGu
	 YgF9MxsEleFH5akj05NtZJqT5ceUsbnft+IoNCibXpuwoGOR1zh6c7BmvgOo+YcC7y
	 bw4wdlt/XFQhD6vYY7b0HeTAdmAqa5jUKWWnFSWS1hdRC42pV7EQqdc1gTchkOKzMo
	 2pthwA1y3g1IA==
Date: Tue, 13 Oct 2026 18:09:25 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Conor Dooley <conor@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?=
 <zajec5@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>, Florian
 Fainelli <florian.fainelli@broadcom.com>, Broadcom internal kernel review
 list <bcm-kernel-feedback-list@broadcom.com>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, linux-wireless@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dt-bindings: bus: add Broadcom BCM6362 WLAN AXI
 backplane
Message-ID: <20261013180925.2c93e460@DELL-MOBILE03.ad.smart.it>
In-Reply-To: <20261012-shaping-runway-7e6065b8d730@spud>
References: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
	<20261012-bcm6362-wlan-v2-1-4752da7e0982@mythread.it>
	<20261012-shaping-runway-7e6065b8d730@spud>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfGQX3VdRN1HOHP/JcptkJy03D++bct1R0AeS9Utgrcmk7XP11EilVRO6ecTm5pn/q/QaTP6CLWvBmTPSVN0VcwMxTzSELqvhhqJS/87ll+VSqZdCvqyv
 dNZRmpA/PGQzsZhOXcV7/bgFTpy9S0TXRw9fhisHGDlwAgTkh18kgCv09oRfeX8YgtmIXhi+UkTZHagCKFaVr+82EVu0EFzIFoikZMysQROgoKqyJ9vkjIk8
 J9QFeLCD0RO7n/FSVVZNcqIy5ixFbPW+9e5NsD1KrBWHrTfWZ8mxM7CVDvGXBcOCI0jQlXQJGdHBjklaQvmRsQ9ynkOJESgFvwPiDPwavJm202m/xHzQrSpX
 6SVyblNeMt2/FaEpN7qCXK1HQkF34xhIpdr95knq4GxzPLVEZq5JiiVSj24MaK1jj9uk3y6s7oBlKcwqvbArTqeWm4i3qmwffZz1eaPmDcc6b30gTMqpCYMv
 3zo+GH+2NiM8TKqfQxNoSNtwxp7VTd61yT5ALmE5k4VUdoeIYXuGMgQkpTUU+Um5gN8dYcHQCtJAO7hQfMPLCZOE9d0k1XSovVNNeYKbD3I7dPA3Jp/GUlQg
 uN6k0Hfmxi9mxHBnzMD7T3RHNU4XY5bg5FvJGbAbdx2XEl2fQV/w0Z0HUQfx6z+2+zE=

On Mon, 12 Oct 2026 20:13:46 +0100
Conor Dooley <conor@kernel.org> wrote:

> On Mon, Oct 12, 2026 at 12:45:25AM +0200, Alessio Ferri wrote:
> > The BCM6362 integrates a WLAN macro on its own AXI backplane.
> > Unlike the backplanes covered by brcm,bus-axi, its cores have no
> > wrappers: clock gating and reset are driven through a separate
> > WLAN control register block, and the macro needs a clock, two
> > resets and the WLAN pads power domain before the backplane can be
> > accessed. The backplane registers are big-endian.
> > 
> > Add a binding describing the ChipCommon and WLAN control register
> > blocks, the clock, resets and power domain, and the interrupt-map
> > used to route core interrupts, following the brcm,bus-axi
> > convention.
> > 
> > Assisted-by: LLM
> > Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
> > ---
> >  .../bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml    | 100
> > +++++++++++++++++++++ 1 file changed, 100 insertions(+)
> > 
> > diff --git
> > a/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
> > b/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
> > new file mode 100644 index 000000000000..183de28fd032 --- /dev/null
> > +++
> > b/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
> > @@ -0,0 +1,100 @@ +# SPDX-License-Identifier: (GPL-2.0-only OR
> > BSD-2-Clause) +%YAML 1.2
> > +---
> > +$id:
> > http://devicetree.org/schemas/bus/brcm,bcm6362-wlan-bus-axi.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml# +
> > +title: Broadcom BCM6362 integrated WLAN AXI backplane
> > +
> > +maintainers:
> > +  - Alessio Ferri <alessio.ferri@mythread.it>
> > +
> > +description: |
> > +  The BCM6362 integrates a WLAN macro on a dedicated AXI backplane
> > +  (bcma), whose cores are discovered at runtime from the backplane
> > +  EROM.
> > +
> > +  The cores have no DMP wrappers: clock gating and reset of the
> > +  ChipCommon and 802.11 cores are controlled through a separate
> > WLAN
> > +  control register block. The backplane registers are big-endian.
> > +
> > +  Interrupts of the cores are described with an interrupt-map,
> > keyed
> > +  by the core base address and the core interrupt index, as for
> > +  brcm,bus-axi.
> > +
> > +properties:
> > +  compatible:
> > +    const: brcm,bcm6362-wlan-bus-axi
> > +
> > +  reg:
> > +    items:
> > +      - description: ChipCommon core registers
> > +      - description: WLAN control registers
> > +
> > +  reg-names:
> > +    items:
> > +      - const: chipcommon
> > +      - const: wlan-ctrl
> > +
> > +  clocks:
> > +    maxItems: 1
> > +
> > +  resets:
> > +    items:
> > +      - description: WLAN macro reset
> > +      - description: WLAN UBUS interface reset
> > +
> > +  reset-names:
> > +    items:
> > +      - const: wlan
> > +      - const: wlan-ubus
> > +
> > +  power-domains:
> > +    maxItems: 1
> > +
> > +  "#address-cells":
> > +    const: 1
> > +
> > +  "#interrupt-cells":
> > +    const: 1
> > +
> > +  interrupt-map-mask: true
> > +
> > +  interrupt-map: true  
> 
> I'd like to see some constraints on these, particularly since there's
> a very high chance the mask is fixed and the map has a fixed number of
> elements.

Yes, you're right, i'll add them in the next batch. 

> 
> I'd also like to see what the child nodes on this bus look like. Do
> you have some dts examples?
> 

the children are enumerated dynamically by bcma itself, so i don't
expect any. I know that a childless bus is suspect, but bcma seems to
work this way.

> Thanks,
> Conor.
> 
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - reg-names
> > +  - clocks
> > +  - resets
> > +  - reset-names
> > +  - power-domains
> > +  - "#address-cells"
> > +  - "#interrupt-cells"
> > +  - interrupt-map-mask
> > +  - interrupt-map
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/clock/bcm6362-clock.h>
> > +    #include <dt-bindings/reset/bcm6362-reset.h>
> > +    #include <dt-bindings/soc/bcm6362-pm.h>
> > +
> > +    bus@10004000 {
> > +        compatible = "brcm,bcm6362-wlan-bus-axi";
> > +        reg = <0x10004000 0x1000>, <0x10007000 0x100>;
> > +        reg-names = "chipcommon", "wlan-ctrl";
> > +
> > +        #address-cells = <1>;
> > +        clocks = <&periph_clk BCM6362_CLK_WLAN_OCP>;
> > +        #interrupt-cells = <1>;
> > +        interrupt-map = <0x00005000 0 &periph_intc 7>;
> > +        interrupt-map-mask = <0x000fffff 0xffff>;
> > +        power-domains = <&periph_pwr
> > BCM6362_POWER_DOMAIN_WLAN_PADS>;
> > +        resets = <&periph_rst BCM6362_RST_WLAN_SHIM>,
> > +                 <&periph_rst BCM6362_RST_WLAN_UBUS>;
> > +        reset-names = "wlan", "wlan-ubus";
> > +    };
> > 
> > -- 
> > 2.56.0
> >   

Thanks for the inputs,
Alessio
