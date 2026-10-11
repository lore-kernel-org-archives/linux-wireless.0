Received: from smtpdh17-2.aruba.it (smtpdh17-2.aruba.it [62.149.155.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0A146982C
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 22:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791758923; cv=none; b=txYnxBPx6978uJzYMjF1jM9qvwSv9cbN97TRLRgT4kvuRt1W8i2B2ZUgHOYXHXhyEA7DVKUpT9k7Hc5gjbyNHQKXawv3WB03MJNKwipgD4f0ClAA9km9Ghp1YiLwqgIpYGH0nkW7yn1yY6nvanuEM9am0hmVshr8ZMkg0ANup14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791758923; c=relaxed/simple;
	bh=qQqyaXWLD2K3Z2lR/AzzZk2iPIT6dvjjn3pITWnNGLk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=pbhBNSKzDTCtG0GGDKktjNNBZhUn3vEdsHlM7DU7chYebaszwz9KonBStniSOLfvh0SQEa+HF//t9r20n10ZKda6g9bGIxeP3ZiL15wvf8dT9t9sueY1A/9+sABUFpJ7Bzotu9iYH28U1aaV71XlRvKSQORi3X/gsJUX4lMnHYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=JmTn5S7Q; arc=none smtp.client-ip=62.149.155.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="JmTn5S7Q"
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id G2INxu7ww76R9G2INxOsxV; Mon, 12 Oct 2026 00:45:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791758731; bh=qQqyaXWLD2K3Z2lR/AzzZk2iPIT6dvjjn3pITWnNGLk=;
	h=From:Subject:Date:MIME-Version:Content-Type:To;
	b=JmTn5S7QqedDjMNHmaCOccgliK7nDFP1gWADg9NKOFUZVLFnLsAiF38IpfwxIdIpW
	 7Kk/njFuYGvsny6l+q0Yil5s/iXpRac7IQ08TgcLijL0dQkFUpxn9P6tR3nbkDu0+Q
	 kzqmiL3TPKLrzX/MZkDe6BVT1lvIAij83fYB4RmTNL3GrQ5rwEDEvMnf9RyHN5iL5x
	 9XX2zg2yeP/lzb/9IStObYt4lZsxIu3Kf3Tb/oS4Vaoj2awCdUWgQGxafqNnd+/oq6
	 pezfOya7MhbpFsFnPvdWWOibRKgK0esc+I40RxXjVBSJobQ2UR9tJ5ZVSgFW4dPZMA
	 LVNrVJaoFDRgQ==
From: Alessio Ferri <alessio.ferri@mythread.it>
Subject: [PATCH v2 0/5] bcma: support the BCM6362 integrated WLAN backplane
Date: Mon, 12 Oct 2026 00:45:24 +0200
Message-Id: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/1XMQQ6CMBCF4auQWTumHaBVV97DsCi0wCSUktagh
 nB3KzuX/0vet0FykV2CW7FBdCsnDnMOOhXQjWYeHLLNDSRISSEltp1XpSJ8TWZGW1W6bK3syQn
 IlyW6nt8H92hyj5yeIX4OfZW/9YBETVc01v5jq0SBmogq0lr39eU+eMPTuQsemn3fv5yQCfusA
 AAA
X-Change-ID: 20261011-bcm6362-wlan-d4473bd1f2e0
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfGBn5QViVIzH9fq4p2T55c8cFMDFaJ768Zu3veygAZDBuwZbRsQAmTdiaBVlBwz1c2TIustuNf/Z/0mi1uP8KgfVyxY3ER+Gsdhst1liIszGvfg2FIDF
 hNqr01gJHNNkp81nVs0vAPCrdV/t8IwUwxjBDyHCEtzADMisupy3GcYGAcq08H9/Ztr6LpNjh72z1fuSybj7hqreWULgQ+FHJU1s9h8dAA3EBalKsm8lqMUe
 l07IZw7uftrId5QhlztTuh4LCdcTTp3rWbhDUXWoO6xUvfpU7FxjV1qByiEfieIKi6g6xNRaZeqr8KVo/Ri6cS0WjJuVlfJjPYo1IYPb9FEpPnIfgpc4yBrj
 HY7iVrJ5I9ZnRdawFJRJm+2+JNB3sPJ05ch3qu0UKKjF3oDLAq8BuxLZmA8cv+bB0YaJS3Kl3avWqH1A263eyZx3f3jpJn2lzbJbL+w+1JzE0qXD0zlyITNR
 thliuJtkQFoNwGPcKgvUDX7iFchIYZaHr3ZCqcL11PGUF+ZToraUjeQ9aVaUg2JtyT7NEVBZLZ2IELzp0iO5u+VlBeiV9PJDowl/abi2p1hz+PdoZohczPYR
 dLe0ejFcVloO0eybaf3AQJFlATmhvwGOMOQzIrgSl4ZGEQWcScnUpqJQ840+X6Q/Fvs=

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

My router is running daily with it, using openwrt kernel 6.12. It 
seems to work fine. I had to add a fallback sprom as the integrated
wlan has none. PIO was not tested as OpenWRT disables it, but i
suspect it is not so important, as it is also the most probable
OS for the bmips 6362 SoC.

This is a reworked series after the initial RFC was met with some
criticism regarding the choice of naming (the spamming of "shim" 
everywhere) and the choice of using a separate bus driver for 
something that clearly related to bcma.

This was drafted with the help of an LLM and cross built with gcc 
mips cross compiler and checked with the dev version of sparse.
This time i also ran dt-check-style and it didn't flag anything.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
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

 .../bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml    | 100 +++++
 MAINTAINERS                                        |   7 +
 arch/mips/boot/dts/brcm/bcm6362.dtsi               |  20 +
 drivers/bcma/Kconfig                               |  12 +
 drivers/bcma/Makefile                              |   1 +
 drivers/bcma/bcma_private.h                        |  15 +
 drivers/bcma/host_soc_bcm6362.c                    | 418 +++++++++++++++++++++
 drivers/bcma/main.c                                |   6 +
 drivers/bcma/scan.c                                |  10 +-
 include/linux/bcma/bcma.h                          |   5 +
 10 files changed, 593 insertions(+), 1 deletion(-)
---
base-commit: d6d3455d8751854e0d1820f14184682e23ac4475
change-id: 20261011-bcm6362-wlan-d4473bd1f2e0

Best regards,
-- 
Alessio Ferri <alessio.ferri@mythread.it>

