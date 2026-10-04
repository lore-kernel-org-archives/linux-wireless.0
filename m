Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C15542050;
	Sun,  4 Oct 2026 11:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791112239; cv=none; b=kq3ibFXL8GPtttkg1NMcm15/RVDM1GOw3C0zzyJPdufzqisRLblE3zD/So9FvAsdCtJOGp9t/XaRL3bPyqW9EhkG08KC73KXw8Aa9cD2OLMNGi2x9QqWGyGjzP/RrV8DMnI7YKwiwOJG2s2B3qQG/3QwPcmo/LISpOHuFoe2xU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791112239; c=relaxed/simple;
	bh=3vIFmGrXaGE0g6dRKtNgfftMUM92UGtys/54Q9Xt7/I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=il8tnJgVCa8d0wLbRCRbkC7wIy+IWkf1v0eITruxr92HCVcVckzPYFtbYyPxkhkEVsGU578pLR82kTSvM7tn4IUKfUMhhY9pJFhpyPwyPR3kP2nS1/GzFkU+yB+HYFWeO6XZqdRqHauLAjaISr1GgWjTmMYG3cMwoamNB6EPNAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=U81sRnJt; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="U81sRnJt"
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 05F731BA2D;
	Sun, 04 Oct 2026 14:10:35 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:message-id:mime-version:reply-to:subject:subject:to
	:to; s=sig1; bh=WGQ81jU+l2MkFM+CIYGORGxoh8ZVvXmfJ0xa0fOYQCo=; b=
	U81sRnJtx6voqjqKtnEnugJlf/Ni7CstbzpKIy5TU347RIngiT/SBsR9ndFLRbZG
	LHHHEcwIVRSw3oPsRxLFDU+tKw2oOOUL6KL4IN13k2ya5huTFi5y3YH6HFfZE24a
	h9zDamG0nWwP2UjzMJRqJVRxgH9kcm6JuTBVJ5qhBYPtpBe324f0cIOfbYKxh0mI
	DOe2FgqId+mF75AnVF6ovp3HTmEguaVsWutGjanS/QJLJrEm8JlibSQ/nirgzY3x
	Dl5TnnjbO4Elm0SsxWPU/Ap9N19XiW20ryUwAFADVmFbo4xd3eCEAopUj55k9t94
	C+QlTCoD2Gy5ryuX2GzMuQ==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id DA8D61BB28;
	Sun, 04 Oct 2026 14:10:33 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:10:33 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Bjorn Andersson <andersson@kernel.org>, Conor Dooley
	<conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, Johannes Berg
	<johannes@sipsolutions.net>, Konrad Dybcio <konradybcio@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>
CC: <ath11k@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2 0/3] arm64: dts: qcom: ipq5018: add Ubiquiti UniFi U6 Enterprise
Date: Sun, 4 Oct 2026 14:10:25 +0300
Message-ID: <cover.1791110510.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

Add the Ubiquiti UniFi U6 Enterprise, an IPQ5018 access point with two
QCN9074 radios on PCIe (5 GHz and 6 GHz). The first patch documents the
QCN9074's PCI ID in the ath11k PCI binding, so the radios' nodes can
carry the calibration variants their board data is looked up by.

The Ethernet port (GMAC1 with a QCA8081 PHY) and the IPQ5018's own
2.4 GHz radio are left out until the GMAC and the WCSS remoteproc have
bindings.

The vendor U-Boot only boots Ubiquiti-signed images, so the boards were
booted by chainloading from it. Tested on two units with Linux 7.2 and
the out-of-tree board description these nodes come from: both QCN9074
radios come up with ath11k and their board data selected by these
variants, and the eMMC and the SPI NOR (including U-Boot environment
writes) are in use. The reset button and the accelerometer are described
as in the vendor device tree and were not exercised.

Patch 1 is for the ath11k binding; the rest go through the qcom tree.

The patches were written with an AI coding assistant (Claude Code),
which also drafted the changelogs; the testing above was done on the
devices.

Changes in v2:
- Collected Krzysztof's Acked-by on the two binding patches.
- Squashed "label the PCIe1 root port" into the board patch, its only
  user (Krzysztof).
- No code changes otherwise.

v1: https://lore.kernel.org/all/20261003083410.3126453-1-me@andrei-z.com/

Andrei-Alexandru Bleortu (3):
  dt-bindings: net: wireless: qcom,ath11k-pci: add QCN9074
  dt-bindings: arm: qcom: add Ubiquiti UniFi U6 Enterprise
  arm64: dts: qcom: ipq5018: add Ubiquiti UniFi U6 Enterprise

 .../devicetree/bindings/arm/qcom.yaml         |   1 +
 .../net/wireless/qcom,ath11k-pci.yaml         |   1 +
 arch/arm64/boot/dts/qcom/Makefile             |   1 +
 .../dts/qcom/ipq5018-ubnt-u6-enterprise.dts   | 236 ++++++++++++++++++
 arch/arm64/boot/dts/qcom/ipq5018.dtsi         |   2 +-
 5 files changed, 240 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/qcom/ipq5018-ubnt-u6-enterprise.dts

-- 
2.47.3


