Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.162
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793098140;
	b=ZEp+Y5eSPZ8PYwuw32ldQSsxZPTjhMT/omZKRApEm/H2p4n0S1yQXREHCpmGAKFkIJog
	 /QSELGTWcnviCmO0ExkbF5Z8dNdOwT+285RiA3cwaJj6UIcZssF5t0TvCUDuE5D3NpN2Q
	 HvVMCZ/kMdkByYU0BVbnN6f1+2VYrXnDPPS0ZT6X9OgG7/UU58xV9LrxzJfeWDDNDk1y7
	 rQtKL61SwNsXNqc1Tt+1s8zYIMcgCZz9oYU2jaktzvpiEwvgai6bKDZimUgOA06UC9nyr
	 TdbG0bWOso++xKxclwR8rn2LY1H94hBFVTNnhmZEm+6MnoBlmmriSrBVuGeh2mot3+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793098140;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=DdfPHLsH7kc/+1cgS+rlu0pCzzpU0AOxet3fG9LRYIg=;
	b=f8NxvALl+44WJtUyJ3DLzK95i0Fw/rQo+w5Zt/8+mOhnUakWqHGscMl+u1Qy7GEhwzuj
	 bqI4viA1Zg2zLvzEA+YzbdVnsAIg6EtXHDxw07yNWp8qcrwMo9q/kGWMqDnPTCPAWXlVY
	 eoVEZA1uAfz3tG0gxYBBkFpVj8o+t4cO0/P8Ms6U0LvIKTcJy0X19zLUUqYljkVP0JoCJ
	 x2EUfDOLk7beM/V+iELZDjdvdRpCFyq/a4qlrIR4R2UIemKQXn9C3KZPEZBKnR8HrXCTy
	 vxelb115QEjxc9b3UZBi6x2tEedtFqX7pYbPXU0cjYs25hhD0ZqUMwOzjpycJ1CnIkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	arc=none smtp.remote-ip=62.149.156.162
Received: from smtpcmd14162.aruba.it (smtpcmd14162.aruba.it [62.149.156.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6509C606A322
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 10:48:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6509C606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Received: from DELL-MOBILE03.ad.smart.it ([77.89.54.34])
	by Aruba SMTP with ESMTPSA
	id LejUxJRT2TDqGLejUxslGP; Tue, 27 Oct 2026 11:48:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793098125; bh=mNB86yC/7Ni2CUmBcCuRV8CRTkiHOe+lPSu680Pw83U=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=SVqO09vhtcsvagwyaPSRz6w1oNlK+2hIq3bKv9hXF+izgC8PLGm2xadhoQ1wT8V3s
	 qkqywW5Z3DgzDe17LmmUFszOk3h/b3k5ulTU7RwdSSSf+mPdM1rAOEdZQjuLLCMzmk
	 3hLhxI3hN8A5aHWNNivYV0P5KmtgkdcvbwjxvvqF7e0k/tQKv7aCECChq5t3juuiuR
	 SZ0GCETTMONQ9r5gZQzVVVdp4xlACw3urH33Qi0aRKIpI94abohB6KJ7OI3n4M/EQk
	 8rOmOroVYZhKxp/oPd/UfTmbBTQICFjMQB2YdaVdbLY8bqktK9e0IAeuwMjsUy1tt3
	 13QfYxbsVAlRQ==
Date: Tue, 27 Oct 2026 11:48:42 +0100
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
Message-ID: <20261027114842.04491599@DELL-MOBILE03.ad.smart.it>
In-Reply-To: <20261013-universe-emptier-0bd405092733@spud>
References: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
	<20261012-bcm6362-wlan-v2-1-4752da7e0982@mythread.it>
	<20261012-shaping-runway-7e6065b8d730@spud>
	<20261013180925.2c93e460@DELL-MOBILE03.ad.smart.it>
	<20261013-universe-emptier-0bd405092733@spud>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfJDxMCoQfjpAsNO9+IlLCDtmiGcxt+vWeMsFyYQARj8+o94/x/8H+/6l9j0y13g2HD3DkaNPJNyMA0JgBCzgeEK5ox1SPiBrTjvWRRYjQwsmlsktT3y+
 AERL13J0glSgTYMla7OZ1aHFaRFLAu2alHIHPBTbQMTu03gasC8H2LhbxmPkr8QKSaylgBosVnIv439/9nS2aPumSIGG3Lj1cON9Z09S59L3IwMVk1UX/sAy
 KsgkNoptaz+EU3mXH1ahePCXcPMsdAo6NqMZTA60BvKhXveW2/qNz7bR7mzuD/U7ftaLPiRzmI6w8Dh4ys2pqoQcRNNraexb4K08B8BKGvi9HiRoQSUkZqdM
 +zLE20nI1A1cuSKHax5Tm5Y9zLgCnNAAzugKKy3BMegulU2QSrf8DxiQQOkR9TA9wsYU7tL61xSoIBosuhEJ34Acks4lMg7blP9jWOMyxAUqltQ8MJXKlA/x
 j7QfkcP9GICKBKYVKfY5RPN5KmUc4nD4RdwzmlPXyyH4Tm0NX1Nquh1mWEwVXWzWcm+1HZd3vn/o7mwoTYeb7KNXoDFmSiKJNLN24z5buxTFsW5fvvZMXPFp
 09JuFk8akEXYcB8oHdsAtuVCAVsBQ4Sv0Mm4t8zHIkJk9Vz/DDAB0dPC4e9N0x8E1To=

On Tue, 13 Oct 2026 17:42:45 +0100
Conor Dooley <conor@kernel.org> wrote:

> On Tue, Oct 13, 2026 at 06:09:25PM +0200, Alessio Ferri wrote:
> > On Mon, 12 Oct 2026 20:13:46 +0100
> > Conor Dooley <conor@kernel.org> wrote:
> >   
> > > On Mon, Oct 12, 2026 at 12:45:25AM +0200, Alessio Ferri wrote:  
> > > > The BCM6362 integrates a WLAN macro on its own AXI backplane.
> > > > Unlike the backplanes covered by brcm,bus-axi, its cores have no
> > > > wrappers: clock gating and reset are driven through a separate
> > > > WLAN control register block, and the macro needs a clock, two
> > > > resets and the WLAN pads power domain before the backplane can
> > > > be accessed. The backplane registers are big-endian.
> > > > 
> > > > Add a binding describing the ChipCommon and WLAN control
> > > > register blocks, the clock, resets and power domain, and the
> > > > interrupt-map used to route core interrupts, following the
> > > > brcm,bus-axi convention.
> > > > 
> > > > Assisted-by: LLM
> > > > Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
> > > > ---
> > > >  .../bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml    | 100
> > > > +++++++++++++++++++++ 1 file changed, 100 insertions(+)
> > > > 
> > > > diff --git
> > > > a/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
> > > > b/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
> > > > new file mode 100644 index 000000000000..183de28fd032 ---
> > > > /dev/null +++
> > > > b/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
> > > > @@ -0,0 +1,100 @@ +# SPDX-License-Identifier: (GPL-2.0-only OR
> > > > BSD-2-Clause) +%YAML 1.2
> > > > +---
> > > > +$id:
> > > > http://devicetree.org/schemas/bus/brcm,bcm6362-wlan-bus-axi.yaml#
> > > > +$schema: http://devicetree.org/meta-schemas/core.yaml# +
> > > > +title: Broadcom BCM6362 integrated WLAN AXI backplane
> > > > +
> > > > +maintainers:
> > > > +  - Alessio Ferri <alessio.ferri@mythread.it>
> > > > +
> > > > +description: |
> > > > +  The BCM6362 integrates a WLAN macro on a dedicated AXI
> > > > backplane
> > > > +  (bcma), whose cores are discovered at runtime from the
> > > > backplane
> > > > +  EROM.
> > > > +
> > > > +  The cores have no DMP wrappers: clock gating and reset of the
> > > > +  ChipCommon and 802.11 cores are controlled through a separate
> > > > WLAN
> > > > +  control register block. The backplane registers are
> > > > big-endian. +
> > > > +  Interrupts of the cores are described with an interrupt-map,
> > > > keyed
> > > > +  by the core base address and the core interrupt index, as for
> > > > +  brcm,bus-axi.
> > > > +
> > > > +properties:
> > > > +  compatible:
> > > > +    const: brcm,bcm6362-wlan-bus-axi
> > > > +
> > > > +  reg:
> > > > +    items:
> > > > +      - description: ChipCommon core registers
> > > > +      - description: WLAN control registers
> > > > +
> > > > +  reg-names:
> > > > +    items:
> > > > +      - const: chipcommon
> > > > +      - const: wlan-ctrl
> > > > +
> > > > +  clocks:
> > > > +    maxItems: 1
> > > > +
> > > > +  resets:
> > > > +    items:
> > > > +      - description: WLAN macro reset
> > > > +      - description: WLAN UBUS interface reset
> > > > +
> > > > +  reset-names:
> > > > +    items:
> > > > +      - const: wlan
> > > > +      - const: wlan-ubus
> > > > +
> > > > +  power-domains:
> > > > +    maxItems: 1
> > > > +
> > > > +  "#address-cells":
> > > > +    const: 1
> > > > +
> > > > +  "#interrupt-cells":
> > > > +    const: 1
> > > > +
> > > > +  interrupt-map-mask: true
> > > > +
> > > > +  interrupt-map: true    
> > > 
> > > I'd like to see some constraints on these, particularly since
> > > there's a very high chance the mask is fixed and the map has a
> > > fixed number of elements.  
> > 
> > Yes, you're right, i'll add them in the next batch. 
> >   
> > > 
> > > I'd also like to see what the child nodes on this bus look like.
> > > Do you have some dts examples?
> > >   
> > 
> > the children are enumerated dynamically by bcma itself, so i don't
> > expect any. I know that a childless bus is suspect, but bcma seems
> > to work this way.  
> 
> How does the interrupt map work if nothing references the bus node as
> an interrupt parent?
> I assume there's some code in the driver for the bus that detects what
> bus-indexed interrupt the device wants, and the map is used to convert
> that into an interrupt number of the interrupt parent of the bus?

Yes, bcma enumerates the cores from the EROM, and for each core without
its own DT node bcma_of_irq_parse(), it builds the key <core base
address, core interrupt index> and runs of_irq_parse_raw() starting
from the bus node.

In the next version the binding description will say that the node
has no child nodes and how that the interrupt map is there only to
allow for the mechanism described above.

Thanks,
Alessio

> 
> >   
> > > Thanks,
> > > Conor.
> > >   
> > > > +
> > > > +required:
> > > > +  - compatible
> > > > +  - reg
> > > > +  - reg-names
> > > > +  - clocks
> > > > +  - resets
> > > > +  - reset-names
> > > > +  - power-domains
> > > > +  - "#address-cells"
> > > > +  - "#interrupt-cells"
> > > > +  - interrupt-map-mask
> > > > +  - interrupt-map
> > > > +
> > > > +additionalProperties: false
> > > > +
> > > > +examples:
> > > > +  - |
> > > > +    #include <dt-bindings/clock/bcm6362-clock.h>
> > > > +    #include <dt-bindings/reset/bcm6362-reset.h>
> > > > +    #include <dt-bindings/soc/bcm6362-pm.h>
> > > > +
> > > > +    bus@10004000 {
> > > > +        compatible = "brcm,bcm6362-wlan-bus-axi";
> > > > +        reg = <0x10004000 0x1000>, <0x10007000 0x100>;
> > > > +        reg-names = "chipcommon", "wlan-ctrl";
> > > > +
> > > > +        #address-cells = <1>;
> > > > +        clocks = <&periph_clk BCM6362_CLK_WLAN_OCP>;
> > > > +        #interrupt-cells = <1>;
> > > > +        interrupt-map = <0x00005000 0 &periph_intc 7>;
> > > > +        interrupt-map-mask = <0x000fffff 0xffff>;
> > > > +        power-domains = <&periph_pwr  
> > > > BCM6362_POWER_DOMAIN_WLAN_PADS>;  
> > > > +        resets = <&periph_rst BCM6362_RST_WLAN_SHIM>,
> > > > +                 <&periph_rst BCM6362_RST_WLAN_UBUS>;
> > > > +        reset-names = "wlan", "wlan-ubus";
> > > > +    };
> > > > 
> > > > -- 
> > > > 2.56.0
> > > >     
> > 
> > Thanks for the inputs,
> > Alessio  

