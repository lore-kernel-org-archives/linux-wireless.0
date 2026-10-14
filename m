Received: from smtpdh16-2.aruba.it (smtpdh16-2.aruba.it [62.149.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5ED4AA59D
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 20:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010661; cv=none; b=XHwFzH7wQx3QfvAnup9wIOkT5LV+RRn27bl3com3ab/gjdLn7jJIAsy/77hG9pq5fyPRD/rz6HvlKzsfgzl4FPBgidygfOBnk1CvAT2xNqY9lRi9mnbadWMLMDNqJV9tmpxRCsIbzoadL5+hVmAPTlzibalW+YKXDRokfxhXjJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010661; c=relaxed/simple;
	bh=auwQN0umgDzOfivk0BFsvEz4unOSTBWb0S9bDoprS+0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=bYk88KHU0ceqsjRGjydhXOb4M7jMi9NeVlTI3y4h0TGaf7dtWmDji3V2K/WeD3viIaGi3yXnHIbqRSDhD+qlQAsXYczUE5K7WrdJENQDoCUY79SZhhN+ZbsyoLgQWXDErr1uAc+m4paMvscFYPQgejQV1is61Bm5nLXiGAbpbzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=mpjHS9ia; arc=none smtp.client-ip=62.149.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="mpjHS9ia"
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id H5mdx2rTsgYw4H5mjxSpCA; Wed, 14 Oct 2026 22:41:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1792010473; bh=auwQN0umgDzOfivk0BFsvEz4unOSTBWb0S9bDoprS+0=;
	h=From:Subject:Date:MIME-Version:Content-Type:To;
	b=mpjHS9iaXubnnuWyMxxefHxMMs+2YYmbbVVroBOZW3lsv3WSHTUSum5KvOUX2vioN
	 6FRNY6AcErz8TrRzhQuWHSgOycQIQBmw8v40Foyc1tdlwvfAOQ8BrP5A8WHJdFScKt
	 CFpxTuA74HOdna+KzxzH71KzxxEMtAkQCh/cNDSWp3/odEx56xdiTz5pLb6xivWm65
	 lTVZmJbRZVoia3Jp9sbpZNS1KHwbJXbQIh14L6WB2JBeknLhrNkdChCq4vMhJmqOuh
	 WisMSQg7U4LXemSukNg4kgJnjwIOkZTf5rqx+IdzrUkoI1Tp8IFD2JUTIgNnISGLCC
	 MvYCiZu3er0Eg==
From: Alessio Ferri <alessio.ferri@mythread.it>
Subject: [PATCH 0/8] bcma-ac-rev1: support 4352/4360 rev3 chips
Date: Wed, 14 Oct 2026 22:41:01 +0200
Message-Id: <20261014-bcma-ac-rev1-v1-0-b608e99d3f56@mythread.it>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN3oz2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDA0MT3aTk3ETdxGRdoGJD3ZREC0sTQxMjc0uDNCWgloKi1LTMCrBx0bE
 QfnFpUlZqcgnIDKXaWgCZApXRcAAAAA==
X-Change-ID: 20261014-bcma-ac-rev1-da894142790f
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfJN6aUMWVTjyiHFlqSbsKeZSW6xP+jdx1SjIjpoGY4uWNTV0gKvUVw3FYL84pLgtYmg2ix5Zm0gW9AVNUJLIbPfPl1QskPJ3vyGbj4Ybljjw2cn/sy1r
 kAwGpZvGggFAILdBvKhGK3Rjnvlt4AsnfqlNxePDQJTlIBQrr9UuMJbAou4bmLe23JIQ9HedYNo5tCZj+wFlsKG+bbDvn97Itywim6szkQOzgS9m2pul/tyy
 j3fG3Zs2Yzqv+ubZI5ejLxhKLMw3yIZfJGQkTLWsN+zyt67CzpiKJr0f033vTS5RNZuB48UQ2XMOnb+WcnKQq+yU7WrGwcPA7t+nXwAvVkv7WIyUP1YDj3Ji
 d7G0fMYXqhutk5HN9A41YgVlgc+Asw==

Preparatory work in the bring up of AC family rev1 chips, in particular,
the bcm4352 rev3 and bcm4360 rev3. I don't own nor I can find any mmio 
captures for other revs, so everything is gated on rev3 of the two chips..

Initialize the PMU, the PCIe2 core and chipcommon of the BCM4352/BCM4360
family on chip rev 3, parse SPROM revision 11, read the NVRAM variables
the family's boards set on top of the SPROM, and bind bcma-pci-bridge to
the BCM4352.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
Alessio Ferri (8):
      bcma: core: clear only FORCEHT for BCMA_CLKMODE_DYNAMIC
      bcma: pmu: init PLL and resources on BCM4352/BCM4360
      bcma: pcie2: request HT on BCM4352/BCM4360
      bcma: chipcommon: set corecontrol bits 5:2 on BCM4352/BCM4360
      bcma: extract SPROM revision 11
      firmware: bcm47xx_sprom: read ledbh4..ledbh15 from NVRAM
      firmware: bcm47xx_sprom: read boardflags3 and AvVmid_c0..2 from NVRAM
      bcma: add the BCM4352 PCI ID

 drivers/bcma/core.c                         |   2 +-
 drivers/bcma/driver_chipcommon.c            |   5 +
 drivers/bcma/driver_chipcommon_pmu.c        |  41 ++++++
 drivers/bcma/driver_pcie2.c                 |   3 +
 drivers/bcma/host_pci.c                     |   1 +
 drivers/bcma/sprom.c                        | 204 +++++++++++++++++++++++++++-
 drivers/firmware/broadcom/bcm47xx_sprom.c   | 118 +++++++++++++---
 include/linux/bcm47xx_sprom.h               |  15 ++
 include/linux/bcma/bcma_driver_chipcommon.h |   4 +
 include/linux/ssb/ssb.h                     |  62 +++++++++
 include/linux/ssb/ssb_regs.h                |  94 +++++++++++++
 11 files changed, 525 insertions(+), 24 deletions(-)
---
base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
change-id: 20261014-bcma-ac-rev1-da894142790f

Best regards,
--  
Alessio Ferri <alessio.ferri@mythread.it>

