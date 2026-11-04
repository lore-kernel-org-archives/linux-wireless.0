Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820657;
	b=Nql3joNY9mThi2L6d2OUkslf+wBsnjd8+5unq/aw96vMdjNasdk/R29HltOjpjMQecn+
	 KEChzfAw4k3INNwxwZFlsSBSiYbywm3pmvlbyFNsdTf+ATMyzJTrgo3QPRiRbyu8nEl9W
	 rxrt1PRmJbeovHoqc/aEyhPjxQyjM12YLJGSY5JC4wcHt3phSEoH47lAVenEjixwZRxGx
	 4K6qAyLQCQohxw8UTgz13z/1Of7+nZLtPm8gwrsAvpZQwj2y9PdmfI7GaeyiukqgnFGXF
	 +H+vT5aw2hUfqNydLhVSBZlWXAc4anUaTwjmaqptcTLj52D7LyULsS0kPf7DR4QHKfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820657;
	h=DMARC-Filter:Received:DKIM-Signature:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=TRMyW9/DrVgmOS7Aq8HdI8WRw1qeBXydS7xDzEqPUnc=;
	b=gvksDlWOI9UIvQV0YEbhgxyInpZ+hJPFxAhGvLR+p+4bvf+TsnvjwRSqEjPxf00VQsAs
	 XIudYzux7ODID/3V+TWVamhHdEXVpgt906K7NFr1sr7J/BhwU9mZAEjU2oqPIMIPgxDPi
	 4gFa7dxp5uPuSzoGPnhUhGZmBeR1ySd6Opupc1DWPb5jqRm7Us9uoZMpD+QopydH+iR4q
	 rzmUsG3veApQrVB/06oecfOca525LwXY+6wHyr4hVxEulPibscyc76c997IqgkMfkTmEP
	 6Fo/xo3uEcEb/MM5H3RbmLL1CVP80D+VjWgd8VU+EX0rJ2mhtlK2LLa31w2jTTSI+rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=M+ESQc2l;
	arc=none smtp.remote-ip=62.149.156.56
Received: from smtpcmd0756.aruba.it (smtpcmd0756.aruba.it [62.149.156.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A6A6096082
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 19:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4A6A6096082
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=M+ESQc2l
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id Ogh3xxDlIuuRMOgh3xJX6j; Wed, 04 Nov 2026 20:30:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793820646; bh=bGcg5jnGoPmYKwgcM9JVWIXm8MizZ1eSFtIhv/FD2nY=;
	h=From:Subject:Date:MIME-Version:Content-Type:To;
	b=M+ESQc2lImSGR035HPK2PZxJY7BHNP4vig7i8FCXf8hGQVDM5ElX6X8QUBRAc0thF
	 ekhp7kCeUVkfekcVjN+0cqrcTOpSa4+uHvi2tPpPbAYyddupeW6sphqXiSNMj53ky3
	 MrFSpnkHO09gkMVXAFN18ezG5fU1NQh0PKa6VMt08HcjH0+NttSN4CY0yYKsrxs5vN
	 hlvW9S0LmxZsvQKU8JdZexEYaizAyLMYp1WaOIi/Gectq8L5CZSVHd7Tmv70UDgFCT
	 ogXu4y9eJcyMgV1QaRicRf/e5dz4KkBx7zf3HKojQjUIo/eQ91SCK3Y60nsgyXte/6
	 3I7BlmlLjq4yA==
From: Alessio Ferri <alessio.ferri@mythread.it>
Subject: [PATCH v4 0/5] bcma: support the BCM6362 integrated WLAN backplane
Date: Wed, 04 Nov 2026 20:30:43 +0100
Message-Id: <20261104-bcm6362-wlan-v4-0-f001f6d75dc3@mythread.it>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13OTQqDMBCG4atI1o0kY0y0K+9Ruohm1IA/JRFbE
 e/eaKGlLr+B52VW4tFZ9OQarcThbL0dhzDEJSJVq4cGqTVhE2AgOeOcllUvEwn02emBGiFUUhp
 eAzISyMNhbV9H7nYPu7V+Gt1y1Ge+X48QSyGn2pj/2MwpowoABCil6jQrml7bLq7GnuyxGb6B8
 AmcMAQsVApGK2R5BkW/TK1DbWI7fXjy45yJE08CRyFTCSXoip/4tm1vV2/h/yoBAAA=
X-Change-ID: 20261011-bcm6362-wlan-d4473bd1f2e0
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Jonas Gorski <jonas.gorski@gmail.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfIRwhac84wbXo9VECU0DHaAKnY1rE1DV2KeJfsIi4OYJeMrh9+umvn813y1/n5XC2FHQ4GVjf8Pj5aciqrxd9dax3j2nPWj8q4X3RBqR7cK/jBhExe3m
 QXePPBXU1w7etHk9Wcz3oKxWa5QaDRiCgiA8XKAucsxI5QI0v9Lpwv1gGdZmmeQSGkuBsYLez/R67p8m12cFXMprNa5alhVR6Oz5b6EzzFKUrSa5U8U5mSiv
 mPuEjdWZPuG62z8D2AkU4keIle9hRKxMnImCZ3xWOZgWiLI/kBriRWYIi/IaVxNLVPoqFNS/Cdz8NcDL62wPYLs6QG6Uw/MBnjO2aaALV+a59Epy5y3HUnkQ
 m/H+cwr9sa+O5Bj5QFbmmGXa6FXi1jKk9PNnakVm4aF+qEHT0BjgFwO1L+xJcNGf6HqBdFJAuoCJ7FRKY8Bnw/WA0zkhCJX19wm4N9TRLZJsd0mCrNHexu2h
 hnK+docw7bDqz5ppBlUzlI0hBf9DRlrXeE+i9klhtJgpYCCz0LxwYtqWkme4GgYhjcVJ/0UL7UnGHYqbsBELxIdkkRDdTeJpMeQnAVQgUwPHcVjXOB/c++wv
 3NpKCUVxnGNXxIgO4GsE1LnTCy6IB2piIlPiMBVLhrBh/N5nFOWzRbVduTaRW0UGSx4BDFrYGycCi/wc+Nun3lPF9q5ye3XgZfUjtnaTwXPz9w==

The BCM6362 integrates a WLAN macro (802.11n core) on its own 
bcma backplane. The backplane differs from the ones bcma supports 
because: 1) its registers are big-endian, 2) none of its cores has 
a wrapper and make bcma loop crash, and 3) the macro has to be 
clocked, taken out of reset and enabled through a SoC-level WLAN
control block before the backplane can be accessed.

Patches 2 and 3 add two opt-in bus flags to the scan code for the
endianness and for wrapper-less cores. Patch 4 adds a dedicated host
driver that brings the macro up, provides big-endian ops and emulates
the agent registers on top of the WLAN control block. Patches 1 and 5
add the binding and the SoC dtsi node.

My router run with this series backported to kernel 6.12, and has a 
bcm4352 and the integrated wlan targeted by this patch; bcma scans both 
without problems, both chips transmit just fine. The bcm4352 is pcie and
has a normal backplane, so the changes are tested as non-breaking.

This is a small module and i have plenty of hardware to test it (3x 
6362), I am able to maintain it as long as my hardware allows. 
It is also low risk: the flags that change the behaviour of bcma are 
opt-in and it is "complete", at least for the 6362.
Further code is only expected if the bcm63168, that i also have in high 
numbers (5 routers), requires it.

Proof that it scan and works (macs edited):

bcma-sprom bcm6362-sprom: patching SPROM with 38 fixups...
bcma-sprom bcm6362-sprom: mtd mac X
bcma-sprom bcm6362-sprom: registered SPROM for SoC bcma [bus]
bcma-sprom bcm4352-sprom: patching SPROM with 35 fixups...
bcma-sprom bcm4352-sprom: mtd mac X
bcma-sprom bcm4352-sprom: registered SPROM for [1:0]
bcma-host-soc-bcm6362 10004000.bus: bus0: Found chip with id 0x6362, rev 0x01 and package 0x00
bcma-host-soc-bcm6362 10004000.bus: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x23, class 0x0)
bcma-host-soc-bcm6362 10004000.bus: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x16, class 0x0)
bcma-host-soc-bcm6362 10004000.bus: bus0: Core 2 found: SHIM (manuf 0x4BF, id 0x837, rev 0x01, class 0x0)
bcma-host-soc-bcm6362 10004000.bus: bus0: Found rev 6 PMU (capabilities 0x084C2806)
bcma-host-soc-bcm6362 10004000.bus: bus0: Flash type not supported
bcma-sprom bcm6362-sprom: requested by SoC bcma [bus]
bcma-host-soc-bcm6362 10004000.bus: bus0: Using SPROM revision 8 provided by platform.
bcma-host-soc-bcm6362 10004000.bus: bus0: PMU res mask pre-write: min=0x0000005d max=0x0000ffff
bcma-host-soc-bcm6362 10004000.bus: bus0: Bus registered
bcma-pci-bridge 0000:01:00.0: enabling device (0000 -> 0002)
bcma-pci-bridge 0000:01:00.0: bus1: Found chip with id 0x4352, rev 0x03 and package 0x01
bcma-pci-bridge 0000:01:00.0: bus1: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x2B, class 0x0)
bcma-pci-bridge 0000:01:00.0: bus1: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x2A, class 0x0)
bcma-pci-bridge 0000:01:00.0: bus1: Core 2 found: ARM CR4 (manuf 0x4BF, id 0x83E, rev 0x02, class 0x0)
bcma-pci-bridge 0000:01:00.0: bus1: Core 3 found: PCIe Gen2 (manuf 0x4BF, id 0x83C, rev 0x01, class 0x0)
bcma-pci-bridge 0000:01:00.0: bus1: Core 4 found: USB 2.0 Device (manuf 0x4BF, id 0x81A, rev 0x11, class 0x0)
bcma-pci-bridge 0000:01:00.0: bus1: Found rev 17 PMU (capabilities 0x10A22B11)
bcma-pci-bridge 0000:01:00.0: bus1: Found SPROM revision 11
bcma-pci-bridge 0000:01:00.0: bus1: PMU PLL pre-write: ctl2=0x00000c31 ctl3=0x0000100e
bcma-pci-bridge 0000:01:00.0: bus1: PMU res mask pre-write: min=0x000007fb max=0x000007ff
bcma-pci-bridge 0000:01:00.0: bus1: Bus registered

br-lan: port 5(phy0-ap0) entered blocking state
br-lan: port 5(phy0-ap0) entered disabled state
b43 bcma0:1 phy0-ap0: entered allmulticast mode
b43 bcma0:1 phy0-ap0: entered promiscuous mode
hostapd: phy0-ap0: interface state UNINITIALIZED->COUNTRY_UPDATE
bcma-host-soc-bcm6362 10004000.bus: bus0: Unknown spuravoidance settings for chip 0x6362, not changing PLL
br-lan: port 5(phy0-ap0) entered blocking state
br-lan: port 5(phy0-ap0) entered forwarding state
netifd: Network device 'phy0-ap0' link is up
hostapd: phy0-ap0: interface state COUNTRY_UPDATE->ENABLED
hostapd: phy0-ap0: AP-ENABLED
hostapd: phy0-ap0: STA Y IEEE 802.11: authenticated
hostapd: phy0-ap0: STA Y IEEE 802.11: associated (aid 1)
hostapd: phy0-ap0: AP-STA-CONNECTED Y auth_alg=open

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
Changes in v4:
- Incorporated Philipp Zebel suggestion about reset handling
- Link to v3: https://lore.kernel.org/r/20261104-bcm6362-wlan-v3-0-e46562b2ac12@mythread.it

Changes in v3:
- Restricted interrupt mask
- Link to v2: https://lore.kernel.org/r/20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it

Changes in v2:
- Replace the drivers/bus bridge driver and the host_soc platform_data
  quirks with a dedicated bcma host driver, drivers/bcma/host_soc_bcm6362.c;
  host_soc.c is left untouched
- DT: describe the WLAN backplane with a single
  "brcm,bcm6362-wlan-bus-axi" node instead of a bridge node with a
  brcm,bus-axi child; add the node to bcm6362.dtsi
- Drop the "SHIM" naming: reg-names "chipcommon"/"wlan-ctrl",
  reset-names "wlan"/"wlan-ubus", bus flag "wrapperless"
- Split the scan changes into two opt-in bus flags (big_endian,
  wrapperless)
- Move the MAINTAINERS entry to the new driver and binding
- Link to v1: https://lore.kernel.org/r/20260529-add-bcm6362-wlan-v1-0-722242777f58@gmail.com

---
Alessio Ferri (5):
      dt-bindings: bus: add Broadcom BCM6362 WLAN AXI backplane
      bcma: scan: support big-endian backplanes
      bcma: scan: accept wrapper-less cores on wrapper-less backplanes
      bcma: add host driver for the BCM6362 integrated WLAN backplane
      MIPS: dts: bcm6362: add the integrated WLAN backplane

 .../bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml    | 109 ++++++
 MAINTAINERS                                        |   7 +
 arch/mips/boot/dts/brcm/bcm6362.dtsi               |  20 +
 drivers/bcma/Kconfig                               |  12 +
 drivers/bcma/Makefile                              |   1 +
 drivers/bcma/bcma_private.h                        |  15 +
 drivers/bcma/host_soc_bcm6362.c                    | 423 +++++++++++++++++++++
 drivers/bcma/main.c                                |   6 +
 drivers/bcma/scan.c                                |  10 +-
 include/linux/bcma/bcma.h                          |   5 +
 10 files changed, 607 insertions(+), 1 deletion(-)
---
base-commit: d6d3455d8751854e0d1820f14184682e23ac4475
change-id: 20261011-bcm6362-wlan-d4473bd1f2e0

Best regards,
-- 
Alessio Ferri <alessio.ferri@mythread.it>

