Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.76.27.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792762628;
	b=NZnnhJsLuzo9vTkIHe5Pc2XmkGFq6MSVgJKgYwIV+vzYhVxdc5rfNTrSJoOBZLy+F/Bi
	 d7HMuhkwEvgFJzFARS1tgCwKghB/uLpQU9cALXVhEoD76uxDkqT+44xE/JpHsbQDXsrcn
	 QVizRifA7A16XgHrfyywk+gkWCrgJH2mRiisDyno0pq2JtTm0ZKBnHdXmU8Xd44qZTE0N
	 jNjpYLXSEch/CYD6DLXBG4kXM5Y7zaEOClCwSo7Bw3gLY6xoPhzNWSGaGwx8fZnaXTyBf
	 apdghpcaXHx8kUxHSucgJhGgrxIxZh6nOzgQS5Nwi6pdXynP+jlFwpDE1mfCwjnsMZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792762628;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=fV6lG8cL6H9TvOQBCaJbZ5e3BAf/D65lP3q+B2S2MWc=;
	b=4fFDZc5Xe5ZNX29iMY9zAiptZGbQFu/kn+mEm4s6wBnznYU07wQYOUbSMHNcc6qLuI0h
	 eRnXxnVjzWLVPz4FccfsStT4Zv1OoUIYMYjHV0rqv5u6xSbcgyZ3jbL9vkcDewcmh9Kbd
	 6SUNKaNUxovs2z/+Dn5I3ppoSaLats5jj3LYQB3/rSatatTDG7/fSGk+CgGcnuaqKtSnF
	 U3HGG8P6m6ZCtjvkJv9YUc9eIAirENWb+l36AXN/1okNUGNmIMVkqI1+9xgiLG+dpGFo2
	 DaQ1tGOpNdl+Rdw2ShjFxlAVH6qXGGr2Eu57hrs/tmibtSQnpUIHpsM5AwRYHxxvvSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=andrei-z.com;
	spf=pass smtp.mailfrom=andrei-z.com;
	dkim=pass header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=iaKBBNPJ;
	arc=none smtp.remote-ip=82.76.27.144
Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F878606A31B;
	Fri, 23 Oct 2026 13:37:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F878606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=iaKBBNPJ
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 15CAA216A8;
	Fri, 23 Oct 2026 16:37:06 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:message-id:mime-version:reply-to:subject:subject:to
	:to; s=sig1; bh=fV6lG8cL6H9TvOQBCaJbZ5e3BAf/D65lP3q+B2S2MWc=; b=
	iaKBBNPJ9Bgs9fARz/sxih1sVoPOMfzgPP3oEeA1edtr7jeMmB6lei6rUfga+icO
	L86ZsJTjl/ileKOx4zXXUkfdeAJICTCNkiLUIlaUTIHmi1w6Oys76PBZMsy8zsnN
	QWy81CM72QN1ybXMcOnVfZHhDXog6aYEk8FgyBmBpGDt/MgCbeNdc28SOv2I1fqC
	3IvHCvwku8iowabzwOcZHFq4a70WPSEz4qEsZke6OY1CQy+O1AEuriJLbLHax91q
	6BGk1LiVL5z46imgSnCt0gaXIdMfEnWch2YFAqNFhZEqrjn13eokSdxFInFBHMuS
	NuawwIARpHc2BQy8gmsvGw==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id D0F142189C;
	Fri, 23 Oct 2026 16:37:05 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 16:37:05 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, Konrad Dybcio
	<konradybcio@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob
 Herring <robh@kernel.org>
CC: <ath11k@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v3 0/4] arm64: dts: qcom: ipq5018: add Ubiquiti UniFi U6 Enterprise
Date: Fri, 23 Oct 2026 16:36:56 +0300
Message-ID: <cover.1792761470.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
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

Changes in v3:
- New patch 3: the PRNG is enabled in the SoC dtsi rather than by the
  board (Konrad).
- Board: the reset button's label is "Reset", and a blank line precedes
  every status property (Konrad).

Changes in v2:
- Collected Krzysztof's Acked-by on the two binding patches.
- Squashed "label the PCIe1 root port" into the board patch, its only
  user (Krzysztof).

v2: https://lore.kernel.org/all/cover.1791110510.git.me@andrei-z.com/
v1: https://lore.kernel.org/all/20261003083410.3126453-1-me@andrei-z.com/

Andrei-Alexandru Bleortu (4):
  dt-bindings: net: wireless: qcom,ath11k-pci: add QCN9074
  dt-bindings: arm: qcom: add Ubiquiti UniFi U6 Enterprise
  arm64: dts: qcom: ipq5018: enable the PRNG by default
  arm64: dts: qcom: ipq5018: add Ubiquiti UniFi U6 Enterprise

 .../devicetree/bindings/arm/qcom.yaml         |   1 +
 .../net/wireless/qcom,ath11k-pci.yaml         |   1 +
 arch/arm64/boot/dts/qcom/Makefile             |   1 +
 .../dts/qcom/ipq5018-ubnt-u6-enterprise.dts   | 235 ++++++++++++++++++
 arch/arm64/boot/dts/qcom/ipq5018.dtsi         |   3 +-
 5 files changed, 239 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/boot/dts/qcom/ipq5018-ubnt-u6-enterprise.dts


base-commit: bd1ecbb61afefc6a8b876ccbc31e9228b44e9eab
-- 
2.47.3


