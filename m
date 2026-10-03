Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FF337D131;
	Sat,  3 Oct 2026 08:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791016460; cv=none; b=WGt8lXATsvVO18zHG+bAH3YYuXEsOdrpPaxrajbf9dM1ZvQng6yDqeFz9yA0495N/fzYgi6StfuFwna8LZyXJe2YVPJoAal2FSdQ5VT5aHb6xj12tfO/fu7VLR5CiqleGzvYkSf8d7YYwZdNIJHTr/0AXzjdWIfT+9R47dxEFTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791016460; c=relaxed/simple;
	bh=j5r+lKJK4Mfu+IMoAlEX8+iIKmx0MPOFa5ONeAN0yW4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u6VcGWp1/x2ylCOw+s7YKSS+A46TDovEryc9ABv+NWg7nrOmid40JUl49UZpKNuahmotaqijQJiImcJTiX3p+gJvy9WQjy4vyKOMayJqu14AXyyjJIHYqu64WodEVkgY8B9yhTourcBk5uy8ZIs7/DJ71EozKUUacgtIlsPp2dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=DCfOTKJn; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="DCfOTKJn"
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id E805713C3B;
	Sat, 03 Oct 2026 11:34:16 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:message-id:mime-version:reply-to:subject:subject:to
	:to; s=sig1; bh=KcOZ4rwrY67axUV2kPqeeNP1yqn1qeXQBfqy6CQQNDU=; b=
	DCfOTKJnH7+eVqsmo5hW5gpuEzxSCrPztbxyEk7sw1O2v+MJgmSUNJBoTZE4NHSw
	b6AXvsJh0aIqzeuq69Eim4zKNEKuDUfJzJzUVDG5nB9WKd7UHO1LdVUpdulh74QL
	+AliLWfClXFlPNlGsHT3d6tdmpIdyFzeAr04YAkxv14dWCHxpfT0z6XPFNRCPEXr
	cWIpllNqbxRPRsdTBjpBhcKvvU3MJirwyOfhT0KPCY+Gvkwew+B4AisYwO/HmhqJ
	HOICAPUFDUYkp1sBEw64kmlN4pyqA3ivL9RurCSUXTHgbNQYbmnga7HPl74oR9Nt
	v5O1cBAvTUCA+YVKLDo3ew==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 2325B14013;
	Sat, 03 Oct 2026 11:34:16 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sat, 3 Oct 2026 11:34:15 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, Konrad Dybcio
	<konradybcio@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob
 Herring <robh@kernel.org>
CC: <ath11k@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 0/4] arm64: dts: qcom: ipq5018: add Ubiquiti UniFi U6 Enterprise
Date: Sat, 3 Oct 2026 11:34:06 +0300
Message-ID: <20261003083410.3126453-1-me@andrei-z.com>
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
carry the calibration variants their board data is looked up by; the
third labels the PCIe1 root port the way PCIe0's already is.

The Ethernet port (GMAC1 with a QCA8081 PHY) and the IPQ5018's own
2.4 GHz radio are left out until the GMAC and the WCSS remoteproc have
bindings.

The vendor U-Boot only boots Ubiquiti-signed images, so the board was
booted by chainloading from it. Tested on hardware with Linux 7.2 and
the out-of-tree board description these nodes come from: both QCN9074
radios come up with ath11k and their board data selected by these variants,
and the eMMC and the SPI NOR (including U-Boot environment writes) are
in use. The reset button and the accelerometer are described as in the
vendor device tree and were not exercised.

Patch 1 is for the ath11k binding; the rest go through the qcom tree.

The patches were written with an AI coding assistant (Claude Code),
which also drafted the changelogs; the testing above was done on the
device.

Andrei-Alexandru Bleortu (4):
  dt-bindings: net: wireless: qcom,ath11k-pci: add QCN9074
  dt-bindings: arm: qcom: add Ubiquiti UniFi U6 Enterprise
  arm64: dts: qcom: ipq5018: label the PCIe1 root port
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


