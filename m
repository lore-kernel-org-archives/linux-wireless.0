Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C79B1BD9C9;
	Sun,  4 Oct 2026 11:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791112304; cv=none; b=IsLH4Gx5KNnGpgG6cfbCuzyCNOSgDL/3h7jp6CE2nlAvizr+JwVxfxu9MTlVpo6iffvPOl77IwFqpcL+SDl5oQYrLdFPBHHgoknZTd5DeHimwdy1g5wAZ7ySrXS0bQamNYTj89sRuaD67K31GZKXX/EjKh6Ra1CGQusZnRJGR1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791112304; c=relaxed/simple;
	bh=nhJV9gKjSCBgTfrE3fmD0sPlTYAT7D+TUaZcklxx+A4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hmy4BIdLrEUDIyXy+XCGjhRG2IF+YNbZbd9JoGj17u6coQHFbpn3OTf8SyFz24b91W09KANFHneo61VY26P99gfrVa068+PeF4u1dZlvChpL8QbPq/F/UbpTryhiSM7OehiSFFjxRtZ6myRNVU1tYPIV4cCoSfW7V24TT4VDPQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=EMdag/MZ; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="EMdag/MZ"
Received: from MAILGW-DELL.dell.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 37B9F13B99;
	Sun, 04 Oct 2026 14:11:40 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=E2WGB2A7tu0a8i34W5JO
	eUaiuMMyPiQRvFycqCxQOJs=; b=EMdag/MZ0S9dIfXUp117x6ThKM66vQUmFI2p
	N3t7y++2msbGU6Z36RJuAmzgzvkLNmGrmfCStT0BNdiVKgyuIM1tIxWTkfPmOyEK
	LzFiL3EGE5HZo+rd0oZJbnhfNHQg6TM0/rk2R4G9qYPrkbBCNtoj9b39Gb561hcE
	Bo618lkm4xCPYYyyH+6FsBYkq/VvlRdh35fClrFJ/tS7VIw/3ldj5GUibWg5LNY/
	XZpaRlz5AoirbxnjZ8japHW8PSEZTmY9gsmnjmcAWyQT+PO6SIfPzIAUVVbTONsi
	ftaR6VIkBABnHEU/lf5NCSkq/+BIMmJsZUeUMG8OXafx4kXNlA==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 372D613C9B;
	Sun, 04 Oct 2026 14:11:39 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:11:38 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Bjorn Andersson <andersson@kernel.org>, Conor Dooley
	<conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, Johannes Berg
	<johannes@sipsolutions.net>, Konrad Dybcio <konradybcio@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>
CC: <ath11k@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2 1/3] dt-bindings: net: wireless: qcom,ath11k-pci: add QCN9074
Date: Sun, 4 Oct 2026 14:10:26 +0300
Message-ID: <99957f59a1728b21386128f1f2133e068da3c5dd.1791110510.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791110510.git.me@andrei-z.com>
References: <cover.1791110510.git.me@andrei-z.com>
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

QCN9074 is a PCIe 802.11ax radio that boards such as the IPQ5018-based
Ubiquiti UniFi U6 Enterprise solder down, two of them on different
bands. Like the other ath11k PCIe devices, each needs
qcom,calibration-variant to select its board data. Document its PCI ID.

No supplies are added: on these boards the radio's rails are fixed and
not under software control.

Assisted-by: LLM
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 .../devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml        | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml
index 0162e3657..605ac5e01 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml
@@ -18,6 +18,7 @@ properties:
     enum:
       - pci17cb,1101  # QCA6390
       - pci17cb,1103  # WCN6855
+      - pci17cb,1104  # QCN9074
 
   reg:
     maxItems: 1
-- 
2.47.3


