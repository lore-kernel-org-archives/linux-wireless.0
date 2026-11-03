Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.158.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793748670;
	b=hv+5xm8oJBF0HFo39eFXDqzpwyOC6AnxfA6osN0dxPx7k/VXNJQMt32OsFuCrnxDMmz0
	 gmnzXoqB3aqwJ6/iSUKwmTemazzLU3r6KV6v+HXVWFkXGzVoGKLKD2x1c7KnDh7gB7d9N
	 RywEICddVOx54fA439+M2Dmw06YgkFPZiw76lH7kTDuP2dMz/Q7LwmPPI5g2SzALuiwfD
	 c6Ec3miph7jyM8XDdqQ9BGT9bbuLtAsOrVxvUCwjXiDhix9lJaLMMwctR3780B3mzGiF4
	 dlcezS00Gc1ha0QGpGksUI2JCXk+b/5QoB4QaCGoJHtDDVCMICURyePcCm24gshXeYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793748670;
	h=DMARC-Filter:Received:DKIM-Signature:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=WKQLHWRZio1dN76i1WSLjeb3l8a/hb2ct6nwJxShEjo=;
	b=QZRXv9wcyylDUQ828RaR7DIZkpnAj/R8IPoykvcYCvpMQaDMzAyJ+UXrnpmSh2zNh4ws
	 KjzIiFDsjhRG8XLHyw5PI4qgslVMnIG5qiDvpAewITcpXVBwlAo/WYfvhSjaPBtCGyYxa
	 47AcvC9yor0o1nipm5L8mHySVoo2VYVi5M8YsNYTuvgB+aZVYcNzCpTurIX3vmy6yWjp2
	 gnWtWu+w6FMR/YXXb/TuqMo7mW/EctaRvOnZMcIUfKJYPKoNlmELUV55XmOWt71qZjP0D
	 KxlWy1oNDcZ/ud5Cdr6Mtszy815txTMxYD0Ip+iFyFs6+56VSyKM4I+bK9VjYL7Ow8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=WpVneJfS;
	arc=none smtp.remote-ip=62.149.158.101
Received: from smtpcmd02101.aruba.it (smtpcmd02101.aruba.it [62.149.158.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28449606A328
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 23:31:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28449606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=WpVneJfS
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id ONxyxz48a7fl5ONxyxPx8w; Wed, 04 Nov 2026 00:30:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793748658; bh=xF9NuOAs2/6ZOJjbuK+NdIZWzOYDFiueOKMGlFktP5A=;
	h=From:Subject:Date:MIME-Version:Content-Type:To;
	b=WpVneJfS75lZnt7L1fZQ8DqY6ueGiDNaBOZtpQENtLUKvvV+oQ/On9WdDme9Lh8HG
	 Hu3IDbrFU6i84vmCy5PprrDTynlPFM3TJk9GIMjGfWle88dujoNlmghapbufnP7heK
	 FWqsFSs1XyyZDiqtG80HWWVTbXFsO947WD/7MeutciA8+36eM2CC+V5u/7mIhtQ1iM
	 kReough1EwzVheGvY3aeearBKS00wbYhi74hqmVBQEZF/7a43dB7+OcQ+a7zozIx4H
	 ZHWJmnI644ivlBUUfEox79LJudJiN8RQ8OeKCU3LFMzrzDHCzVjT3OBcY8iaWBIVLI
	 pmv8QQezOB3Ow==
From: Alessio Ferri <alessio.ferri@mythread.it>
Subject: [PATCH v3 0/5] bcma: support the BCM6362 integrated WLAN backplane
Date: Wed, 04 Nov 2026 00:30:56 +0100
Message-Id: <20261104-bcm6362-wlan-v3-0-e46562b2ac12@mythread.it>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13OQQ6DIBCF4auYWRcDI4p25T0aFyioJKINGFpjv
 HvRRZN2+U/yvswOXjujPdyTHZwOxptljpHdEuhGOQ+aGBUbkGLBKGOk7WyRFUhek5yJ4lxkrWI
 9agpx8nS6N++LezSxR+PXxW2XHth5vSCaY0WkUr9YYIQSgYgchRB9XtaDlWZKu8XCiQX8AvET/
 BtjHHORo5JC06rE2m7r6LRUqVmhOY7jAy76DZ/rAAAA
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
X-CMAE-Envelope: MS4xfLmGiJkychpsPm76iYrARIWszktUiAIDOcXBjfvxRQ95zjRPDHIEykfJXsE3qJYpjsFfri/HktlDX/v1deTKkQRZafmLhcutBqoOPNyG9dmyaOGNj8ex
 buX/5NkZTIVltIi6xu4tmTngGqfsv1zxH5gv/rawmfTAkMFogWB+JWsWouDb6f4M5ejzp01/svVyX9QCw46RWsRGL6Bbh9LrHtsCL2r+DI2M2HZn4sJ35SJ4
 BeaaGpU6kWT5lyNJThVQxWEc0WeR8ljlrbjyZBUaEoTgO2xzzbXtqq0hSWbMidEMzFQUpvnC6c0Gto01WhsDHjlhTGipkSYdBACD1Qv+C3z9lMMoBEavF4oR
 f8+Jw+rKmB0OjGBuCABwTGSvIOcLXVZzJbhiUr77a3KsxscNZ0ClOZPT9CoTxMgqpsyBGMf7P5tjR9DJxOsRWyB4rOVW29INsZW6yedlqoy+3pIFpctOK9xd
 q337RYjFYjJP8/KeUcKBPnB7TTQVTMOG3Va98z1l+/yoYHDwHZaggJheeNfRZkSQ4q7IR1vrlLKH5Rb/M4VBe8Cw9U7XTD439Ee3x5H/N004z8lzTBneQPXE
 7OShxg+UrTPYNB6Zg9mFo3S6+yf2XoX/JJHWZSfOW+84vjdXeN3U0bdgL+g003WKXk0EiHav38LkHNsojBlCI0L6BKXdQyFbA4KbXLzf+oSB1w==

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

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
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
 drivers/bcma/host_soc_bcm6362.c                    | 419 +++++++++++++++++++++
 drivers/bcma/main.c                                |   6 +
 drivers/bcma/scan.c                                |  10 +-
 include/linux/bcma/bcma.h                          |   5 +
 10 files changed, 603 insertions(+), 1 deletion(-)
---
base-commit: d6d3455d8751854e0d1820f14184682e23ac4475
change-id: 20261011-bcm6362-wlan-d4473bd1f2e0

Best regards,
-- 
Alessio Ferri <alessio.ferri@mythread.it>

