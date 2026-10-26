Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793058838;
	b=tBFZFnksDpAs4OCEp7CxX2H3yKzLRPBRiM79rt4pQU8uQlWTxJE+4GHo5prD8urbTMSQ
	 OgsaEpWdiizdwBJYfCF6PJH7uRP8FOaFEO5/HkKDkFdpMktDWBQPD6fCsytSEHJtonHaY
	 D7FQj63Tobes0Mp8PjJvcZ81JBCbUJVCzGqsESKd6/Hci/Ha/i7xJZVpZlovFjiUgILdj
	 C5BaiXbsjpM5dSwenX61eLoUvwjR2AJIUpeOTNcW7WD9eswUVk3mJCuxHVpG8KFBTYIDu
	 T7GinxLbbJpFIJi+qzcxP9QGu5Q4hxccNdqxKpczo5V1kNWutjNU3rt+UicG5zvEIYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793058838;
	h=DMARC-Filter:Received:DKIM-Signature:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=DbLagvg0jRmrztO9r4kvqZ5QLfCw4O2QtXbNUxwpg50=;
	b=A4GZRtklrG67pIFbAeHPxzRgkYUDW8vcOz3dKbemyuiSIP7JE7HBw0WUbqnZcB2dVkoV
	 Is1DQ5QudlZmSuYQ6+QlH1TB7g/iXEJmGX3rY07JIIGtTwo4hHJWPfRhDNz9aYyHuDxbX
	 bYPfnNCfzSij20uZ5WpMfyT4fNl8yAzdQFSo7p6x0bMudgFMU2vgWsMkTY0PewV58GMur
	 pHPkYCPzMtjg8LENGFNqCcaujXECd4XklnQWHB/Sp+UYL6lY7xVXSFrBs6Gj+cfAsTgC6
	 ibF0+PNFmZgkh1A8nERr+etJCWIAqlFzMFUpNbqUkv/8RxfgTGJNesLwq3EWxDJVcOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=R45Ekib9;
	arc=none smtp.remote-ip=62.149.156.101
Received: from smtpcmd10101.aruba.it (smtpcmd10101.aruba.it [62.149.156.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E2D606A324
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 23:53:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28E2D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=R45Ekib9
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id LUVexsCYFW41bLUVgxjBdj; Tue, 27 Oct 2026 00:53:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793058828; bh=mWbqmlXCyS4JkdDtJqjhI9Ulp/HmHGa+a5cO3F0/UfA=;
	h=From:Subject:Date:MIME-Version:Content-Type:To;
	b=R45Ekib9IYcjD36qyxAD2FDRSkM2Rttok8c4AyZeAcx/QmMtKBt5Ud2BDddRqQRFv
	 ffezA/u3qcd4EmWO6woaD62E9yq/dq5T2Hl4n4uLx2yG0nDIqjYKaV+cjh08ii9jQJ
	 gsSgnxo/I89tIo+svJRVmq/jXutucMCSaaGz6svg5XtveWdb+KvOTbhO+34L8VKZqk
	 saxPVoxJqUiJ5nqPOBU4++mPtFyeH+c9+cq1zKXvXGHXrIjEKXTuYNbOvxwFsZn90O
	 M2+qqfiK3vVME9r0Ku5VO7RdWGxtqFnAthWxv94XtKRRqCOM8Pfpj6dqWVAB5ryrXl
	 3L66XKx5z26fA==
From: Alessio Ferri <alessio.ferri@mythread.it>
Subject: [PATCH wireless-next v2 0/8] bcma-ac-rev1: support 4352/4360 rev3
 chips
Date: Tue, 27 Oct 2026 00:53:43 +0100
Message-Id: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
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
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAfo32oC/22NQQ6CMBBFr0JmbU1bEakr72FclHaQMQKmUxFCu
 LsFtyaz+Zn/3p+BMRAynLMZAg7E1Hcp6F0GrrHdHQX5lEFLXSipclG51grrRCor4W1pcpXrk5E
 1JOQVsKZx013hQwGfyCw6HCPcfm9+Vw90cVWuQEMc+zBt84PasP9L6aSoClmiMf5QH4tLO8Umo
 PV7SvJlWb56GzVvywAAAA==
X-Change-ID: 20261014-bcma-ac-rev1-da894142790f
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfOP1m5cBT0mHWlN8umXGisWkEp9/jgvHoBa7uIoBF1B+yIlT9XDT3/9JKUGr6e3p78sFPjhFb9GXxU/vDEOfN0utpqE6e70Lc67e6Dqp41D61uSKYxMs
 EpQn5B532ks7fjLqa6EYlb8sLi8IqGH0QYntpb7dyRq2S+zGmXppoe6e3+X+G8maAiIPrHBaXKhtHkspY90+lHg+SjcPYqZy7k3QI9JZ4MGg0MgV+Le7JBm8
 CIvo3Xe+Le3oqi9DSL7CPINhRx1MqkcWj7UDIcujgNSpLFRRcVMQl/WYV7GSh4HjuTgiac/6gG8REsrmiZ/WVI0SqUsSUfvlzcxQejDKye4m2ym+jy7uD90k
 3MmkKopY7n1KVxz9wmyunHSTEkQEHgTtxq1IOrTABKqY4GjpJW4=

Preparatory work in the bring up of AC family rev1 chips, in particular,
the bcm4352 rev3 and bcm4360 rev3. I don't own nor I can find any mmio 
captures for other revs, so everything is gated on rev3 of the two chips
 except for the CORECTL_ASYNCGPIO taht is gated on cc rev >= 21.

Initialize the PMU, the PCIe2 core and chipcommon of the BCM4352/BCM4360
family on chip rev 3, parse SPROM revision 11, read the NVRAM variables
the family's boards set on top of the SPROM, and bind bcma-pci-bridge to
the BCM4352.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
Changes in v2:
- gated chipcommon behaviour on its own revision instead of chip rev as
  pointed out by Vitaly
- Link to v1: https://patch.msgid.link/20261014-bcma-ac-rev1-v1-0-b608e99d3f56@mythread.it

To: Rafał Miłecki <zajec5@gmail.com>
To: Michael Buesch <m@bues.ch>
Cc: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@vger.kernel.org

---
Alessio Ferri (8):
      bcma: core: clear only FORCEHT for BCMA_CLKMODE_DYNAMIC
      bcma: pmu: init PLL and resources on BCM4352/BCM4360
      bcma: pcie2: request HT on BCM4352/BCM4360
      bcma: chipcommon: enable asynchronous GPIO interrupts
      bcma: extract SPROM revision 11
      firmware: bcm47xx_sprom: read ledbh4..ledbh15 from NVRAM
      firmware: bcm47xx_sprom: read boardflags3 and AvVmid_c0..2 from NVRAM
      bcma: add the BCM4352 PCI ID

 drivers/bcma/core.c                         |   2 +-
 drivers/bcma/driver_chipcommon.c            |   3 +
 drivers/bcma/driver_chipcommon_pmu.c        |  41 ++++++
 drivers/bcma/driver_pcie2.c                 |   3 +
 drivers/bcma/host_pci.c                     |   1 +
 drivers/bcma/sprom.c                        | 204 +++++++++++++++++++++++++++-
 drivers/firmware/broadcom/bcm47xx_sprom.c   | 118 +++++++++++++---
 include/linux/bcm47xx_sprom.h               |  15 ++
 include/linux/bcma/bcma_driver_chipcommon.h |   5 +
 include/linux/ssb/ssb.h                     |  62 +++++++++
 include/linux/ssb/ssb_regs.h                |  94 +++++++++++++
 11 files changed, 524 insertions(+), 24 deletions(-)
---
base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
change-id: 20261014-bcma-ac-rev1-da894142790f

Best regards,
--  
Alessio Ferri <alessio.ferri@mythread.it>

