Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.76.27.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792762824;
	b=P1zSHZ2gS7XB32AiLZ8YlxOme7YUQeHBY82FqBELYU6ujFtxWunRCleqRPE3oBMxjSzv
	 j71Gns+6testX+D2Q1h5pLDW5H7BjqcnNz7juG1Jw01iQtucA+iQm5vnlOo4RLd581zLg
	 rwJMVUMrjw+cKLv9DotX1pT3ynvuRg/+3dynF/tz2IK7ZZ4EIi9Z6WuWziY6pBbtsm2b0
	 1SZTIglT6eERF8V3QBLvN4HlgEeOV0fZvNIRmt1BlsOIu4fkMRSHIJhGa3GgnPbwrYCMQ
	 /7PPEE2BEAFDTn3c0DfjWaxAVtQ/IWsMGNGr7csRKn8mWWkaUft0uENRs3iLxSLMnjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792762824;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=d3JCes+bAJNFau57gaORTkxgJhEs5zwwpin5iTYFEKg=;
	b=YCp9dAHyTYnbB5huYnIMZUFm2pj12VtkMKIKyDXvXQVES8ywaYYRamkCc1doe3mChQd3
	 ZC/y8QYKbaQO+/0H3Fw8EwKP89aAU4pHCdAX/Bixlfy8Z02BKkMbHf/oXBTiq5PRoNu8H
	 abmjhSlLMnszSmOGO7m6cppKnkmYdUYkpjdPmI80U57MK8VRYXLsYjWoV2YJKtqAeD8Mu
	 OgKr4iSuikF2aWJ1uQt6TzyVjs5o/R8HVn/ogc6fxFp9aMJxWr6heZqxeL0FtVoKXqxn2
	 /Cwc5n3RhVLEYoIF/a4aL87yEG1IccLUwgpxYXsnBaPsieQG7gfK41MkEdwaPyaIi8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=andrei-z.com;
	spf=pass smtp.mailfrom=andrei-z.com;
	dkim=pass header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=FfyyzXbf;
	arc=none smtp.remote-ip=82.76.27.144
Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AFF606A329;
	Fri, 23 Oct 2026 13:40:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93AFF606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=FfyyzXbf
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id BFCF1216AB;
	Fri, 23 Oct 2026 16:40:21 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=d3JCes+bAJNFau57gaOR
	TkxgJhEs5zwwpin5iTYFEKg=; b=FfyyzXbfWqkivF2f1aNNklFjEaf2DL9P7xBr
	O7ZbZQj7jrf9BhcTXkKMC5Xk+2SxjTmeQsM0UslpuSbwVt9p9H3vYBImHl3F3BoC
	RD8y2pH38kFrMXEqWWWFpyZjNdPOlnQjKFFpGuZHlac/y0DBVyfnUIKNILdW19yx
	ZJEDezl3Pbk1/P3NnI1fOAbS+WV2yf6Uk+zNzKD8tHYUK1SRyzH3hYfqo/K5H0qJ
	IKrsPJCTkmtsuzpKCmxzkzbM55PPQJigG29tN4QOi5lQm69NWAZSQHfQ7Jg9iU4x
	h6AuT2Hm21XgEKzQZrgYybGow7Lh8uK0hCI9WY0Lq2GcJZUtuw==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 91E27218BA;
	Fri, 23 Oct 2026 16:40:21 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 16:40:21 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, Konrad Dybcio
	<konradybcio@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob
 Herring <robh@kernel.org>
CC: <ath11k@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v3 3/4] arm64: dts: qcom: ipq5018: enable the PRNG by default
Date: Fri, 23 Oct 2026 16:36:59 +0300
Message-ID: <8a595ee4a7facd53a25f51790500a642c78c2e59.1792761470.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1792761470.git.me@andrei-z.com>
References: <cover.1792761470.git.me@andrei-z.com>
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

The PRNG needs nothing from the board: its only resource is a GCC clock,
and no IPQ5018 board has a reason to switch it off. Enable it in the SoC
dtsi, as ipq5332 and ipq9574 do, rather than in every board file.

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 arch/arm64/boot/dts/qcom/ipq5018.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq5018.dtsi b/arch/arm64/boot/dts/qcom/ipq5018.dtsi
index fe1ed240de..dde5435f69 100644
--- a/arch/arm64/boot/dts/qcom/ipq5018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq5018.dtsi
@@ -340,7 +340,6 @@ prng: rng@e3000 {
 			reg = <0x000e3000 0x1000>;
 			clocks = <&gcc GCC_PRNG_AHB_CLK>;
 			clock-names = "core";
-			status = "disabled";
 		};
 
 		tsens: thermal-sensor@4a9000 {
-- 
2.47.3


