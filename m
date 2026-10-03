Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FBB39FCB4;
	Sat,  3 Oct 2026 08:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791016460; cv=none; b=M2STJFFVFlBOVAEXgoAUik6ZjmLE+DOV3ltbXlUF8Bph8hjeP/3rmuTPDcCbXMA9Z2BDl4ZItQITOjfJOU4OB8uwjlOAorna/6565md+FRbVerAQ9cyD5WPtfDbsCA8bFnMt7J1k/UJfKhEujsAq7YKDm611Y692dbIsyCjJSkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791016460; c=relaxed/simple;
	bh=RO4nytf7lcKzxtiKCpH2c7aZA+7FuarZqaGNjY2VDQY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jp0+EO2MzUtZtf2gAR2xv9BUBF+7hssokVXMoWQFLZkNdgo6Xw4Hd+HpliSyRzZow77eoE0dItznvmBIwayhwi74KBu4ftjFPyEFFrF1SPRuI3xvdkmiOAzCjoOalvBhK74DY3Mfl/Y+sfSmDVmzQH/tv+6hSOQK7iIyMlzIEbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=a5SfUesX; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="a5SfUesX"
Received: from MAILGW-DELL.dell.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 78191CAE1;
	Sat, 03 Oct 2026 11:34:17 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=1IJs1SGXeSNWjv6z8/4u
	hGdL9UF8iMKOhCe2W9MDcSk=; b=a5SfUesXoyeKToa0l+bl+mkQ874Hn3MMuJZo
	NeYaD8gp1Qs/FCtMcUqrSXNJhm0C8wGtF5mcx39G7qg4OTYDTlsVGfljEe6cVJ/p
	aEv5NLUwcDEIhLDIGzcP94NzMwMEgZN1ZBlTIcJqMIowrKeR7Q3EzIKMVaSFskR2
	vNaOSYEvBNBX37sD7gp/GIKFQZSTrJY9EzKLR/DhGP0vA0Omc7W+7OmpGb2kaWYa
	iXBDw6NVAJrEkVjUqvo8q/wV92k+SAMZZvrWuQaLBWYqRbp3JNz4fiqhf0uSwtBh
	ntfv6OPhV0Qjx3tFb9gF8i/TOpy1rW1k8RGZEtplHDayL8k4Sg==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 64CA0C9E3;
	Sat, 03 Oct 2026 11:34:16 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sat, 3 Oct 2026 11:34:16 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, Konrad Dybcio
	<konradybcio@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob
 Herring <robh@kernel.org>
CC: <ath11k@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] arm64: dts: qcom: ipq5018: label the PCIe1 root port
Date: Sat, 3 Oct 2026 11:34:09 +0300
Message-ID: <20261003083410.3126453-4-me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261003083410.3126453-1-me@andrei-z.com>
References: <20261003083410.3126453-1-me@andrei-z.com>
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

The root port of pcie0 has a label, the one of pcie1 has none, so a
board cannot attach its PERST# GPIO or a device below it the same way.
Add pcie1_port0.

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 arch/arm64/boot/dts/qcom/ipq5018.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq5018.dtsi b/arch/arm64/boot/dts/qcom/ipq5018.dtsi
index fe1ed240d..2f3bcfa88 100644
--- a/arch/arm64/boot/dts/qcom/ipq5018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq5018.dtsi
@@ -838,7 +838,7 @@ pcie1: pcie@80000000 {
 
 			status = "disabled";
 
-			pcie@0 {
+			pcie1_port0: pcie@0 {
 				device_type = "pci";
 				reg = <0x0 0x0 0x0 0x0 0x0>;
 				bus-range = <0x01 0xff>;
-- 
2.47.3


