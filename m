Received: from smtpcmd14161.aruba.it (smtpcmd14161.aruba.it [62.149.156.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0E63B6C16
	for <linux-wireless@vger.kernel.org>; Tue,  2 Jun 2026 22:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780438913; cv=none; b=qRXPLuRv0FX+S3aELyLlBPl0Kpw46w/eM1sEWzndsO6n54UiKxcTH+2ukqOW3uoVxvMy+7OotoHAYvvLek/q88TEnJvK9NxcOVuy/GYIuPgrZdd198775M6N7g5vUWEMfEaaRqyIjxSbdwjSDY7l53QdjcVGcmSuNZOk+qzssDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780438913; c=relaxed/simple;
	bh=yxylBBvHC4MI+/sGio2ZTsDA9f+yXeKuTPj/6M7xbMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=odiC5RvaLemd3+baJmr7WIPUuBBljg1gi1ofRbWpo3CLcp/k2GJ/2uUdlbV+tpW/+mCzWzk0CtQktbjZz4iebULIrZ29x5Txx5FQgcEkW12WKNSGpDLinJ/432AmKUkLDwiP8SgN6I459PsJQiw26BuCQoe+on2aeDyki91PKoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=cYZYEU8W; arc=none smtp.client-ip=62.149.156.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="cYZYEU8W"
Received: from [192.168.1.83] ([79.20.159.46])
	by Aruba SMTP with ESMTPSA
	id UXRXwqUS14OeoUXRXw4OV7; Wed, 03 Jun 2026 00:18:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1780438719; bh=yxylBBvHC4MI+/sGio2ZTsDA9f+yXeKuTPj/6M7xbMU=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=cYZYEU8WsHsqr2FKt/wWxrqohSucPl7S1xEd0xNDKIkYyC+0pmhA39QP3FQVpmvib
	 PsY3gcCbVMVCe/4sGn7s5BkW61F6VKRlq/Ub2R8cXGwTTZOcpFlgU18xSRI2pMD3ZV
	 Zg+d1HfGFY5QltQGVMk2O3ul6m3d9SfMBJv6y7t4GUWSEB/I0DyKn5oA6Kwtvc47rk
	 AZoQ1LL0BQLcJfMSUcXQd8hWAHNWiBKLxrgFAFU4/5ve5KgOeK4A6DJG1PDqhaR7Oh
	 R739akBDqnps/PUAA5VR6ROfiPGKFh1DkDE7huxWZkA2XEaoWyYjhPQGOWgW/LNf95
	 6P1mL0Ofs+YyA==
Message-ID: <d2b62530-2f9b-4ac3-8de6-dabe70994e97@mythread.it>
Date: Wed, 3 Jun 2026 00:18:39 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] dt-bindings: bus: add brcm,bcm6362-wlan
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20260529-add-bcm6362-wlan-v1-0-722242777f58@gmail.com>
 <20260529-add-bcm6362-wlan-v1-3-722242777f58@gmail.com>
 <20260530-psychedelic-cyber-seagull-140adf@quoll>
Content-Language: it
From: Alessio Ferri <alessio.ferri@mythread.it>
In-Reply-To: <20260530-psychedelic-cyber-seagull-140adf@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfKbqOYmpd1hiin7c3dRXZOyWZ9VpWySOYT0P0im5FE7DcsG/9wDEYC8ELRB+03jLaRTQ+H/pZc/g8ee1BV+E8criswdsvpBuiqfpa+tOEMcPGZ7r222q
 SmHh7TyDhH6mYRcj9aPmhGO3MKXCcitceWyccoKiUQfKLNRGkdyM1qfQXZr79dMTlbwPySGNeUFQAP948L8yZbKIOPKjSCOc3anAEXTUHqHoM7i5JkEXuK8s
 ZEgYZ+GDdSvM3F85/7bJcP0C1qA7jiTZv6GdlTvuOZ7uWBRx3aEcF47YDGDNOKAsFVP+AdRD+F+83A8jssAMYRACNp7R7t+L6/LNY5fSAJeS8FtCyfl10yva
 rbHqv/EU7joKpjlxRCWPhtMDhUcRgTOJzKXeKE0Tu0rVOa4ed/cGDjc0dC6DmSn3kTrh1/TCrZ6gpLnMuGuDnLtgVtvrJCKqnMcTSZL46NQbJtZA11WuN6by
 izTLL8EC5ZVfXg26fvEJKsTa6AXT6VOwv4uVNg==


Il 30/05/2026 13:50, Krzysztof Kozlowski ha scritto:
> On Fri, May 29, 2026 at 02:06:01AM +0200, Alessio Ferri wrote:
>> Document the binding for the SHIM bridge that gates the on-chip
>> 2.4 GHz WLAN block of the Broadcom BCM6362 SoC. The bridge owns the
>> SHIM peephole, a single clock for the macro, and two resets (the
>> SHIM macro itself and its ubus side). It is also a bus: it carries
>> one brcm,bus-axi child describing the bcma backplane behind the
>> SHIM, with a standard interrupt-map routing the d11 core's IRQ to
>> the SoC interrupt controller.
>>
>> Assisted-by: Claude:claude-4.8-opus
>> Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
>> ---
>>  .../devicetree/bindings/bus/brcm,bcm6362-wlan.yaml | 106 +++++++++++++++++++++
>>  1 file changed, 106 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan.yaml b/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan.yaml
>> new file mode 100644
>> index 000000000000..c8d49ccdd2c1
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan.yaml
>> @@ -0,0 +1,106 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/bus/brcm,bcm6362-wlan.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Broadcom BCM6362 on-chip WLAN SHIM bridge
>> +
>> +maintainers:
>> +  - Alessio Ferri <alessio.ferri@mythread.it>
>> +
>> +description: |
>> +  The BCM6362 SoC integrates a 2.4 GHz Broadcom WLAN block whose
>> +  register backplane uses the Broadcom AMBA (bcma) architecture. The
>> +  backplane is gated by a small SHIM bridge that holds the WLAN macro
>> +  in reset and disables its clocks until released by software. CFE
>> +  does not release this block, so software bring-up is required
>> +  before bcma can enumerate the backplane.
>> +
>> +  This binding describes the SHIM bridge node. The SHIM driver brings
> 
> Do not describe binding. Do not describe driver.
> Describe hardware.
> 
>> +  the macro up and then populates the brcm,bus-axi child node, which
>> +  describes the bcma backplane behind the SHIM and is bound by the
>> +  bcma-host-soc driver. The SoC-specific configuration (big-endian
>> +  accessors, SHIM-attached topology, SHIM Control register peephole
>> +  pointer) is delivered to bcma via platform_data injected at
>> +  populate time, so the brcm,bus-axi child stays SoC-agnostic.
> 
> How is it relevant?
> 
>> +
>> +properties:
>> +  compatible:
>> +    const: brcm,bcm6362-wlan
>> +
>> +  reg:
>> +    maxItems: 1
>> +    description: SHIM peephole registers.
> 
> What is SHIM?
> 
>> +
>> +  reg-names:
>> +    items:
>> +      - const: shim
>> +
>> +  clocks:
>> +    maxItems: 1
>> +
>> +  resets:
>> +    items:
>> +      - description: SHIM macro reset
>> +      - description: SHIM ubus reset
>> +
>> +  reset-names:
>> +    items:
>> +      - const: shim
>> +      - const: shim-ubus
>> +
>> +  '#address-cells':
>> +    const: 1
>> +
>> +  '#size-cells':
>> +    const: 1
>> +
>> +  ranges: true
>> +
>> +patternProperties:
>> +  "^axi@[0-9a-f]+$":
> 
> Use consistent quotes.
> 
>> +    type: object
>> +    description: The bcma AXI backplane behind the SHIM.
>> +    $ref: /schemas/types.yaml#
> 
> Need proper ref. You could easily check instead of sending Claude slop -
> is there any binding with above syntax?
> 
> You don't get subnodes for buses for devices not being the actual
> buses.
> 
> Best regards,
> Krzysztof
> 

Sorry for letting AI-slop pass through in this patch and excessive 
descriptions. 

SHIM is just the control block for the integrated wlan. Copied verbatim 
from the original broadcom 96362 code.

For the last sentence, how should i map it? At the very least I need to 
tell bcma that this is big-endian before it touches anything, otherwise 
it will read/write garbage or even cause a panic. If necessary i can 
pick up the quirks after reading the chip-id from the bus, skipping the
new driver and the new bindings.
