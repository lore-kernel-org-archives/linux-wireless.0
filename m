Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.76.27.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792762694;
	b=VNprXfgUm0nMoeXU4QCklvTNs0YQshUsy2xd+wuFx377yIIp4YROc5sY5y5xjkyjwHsz
	 vp8+EgOGz1Hzrs5vJMAxc5T4ZuCBZQ7h9OsQKHmouR63eFTY21oeKpfCGuagaJ1NfmGXT
	 jOL1mB44EGshmozkbzt+CvIr/XLGGNHpxvLIap4m697XMv6ttiQixx6NiAjHEM7sX6NsY
	 obH0nlNKRCnAms7QTGsvO/Y+CqXl/YgCJ3OHo15rB+WRj0LjMA16wpv2dZ6F/3gvJuQ+T
	 yq5VE8WPagE3kRmQQGnylKt0DWD1ESOuJiCiTVTg2fJM0DvGNXWxgyKI5uQzX0jJ2RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792762694;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=bO/ySbw6Wy2tlDziwBPGxxBRPseyc5qUYsYdDeHqHWI=;
	b=jVYZc1oPOZPeNWTDDgZaaZCXId0VFBaiamzBk92550Woy3R6CQuG69YCAXYIOMKhPEg/
	 l9C+ADUO3da5Smpf33fEWtsF8za5Z2tAjVPwlg8Mvm+Gh6XPpLH4GEYu3WW7PlvWJ4Fjr
	 egy/aWcsmSKFBogaEkWWhx7N0Yo4mo37GxMCDwupz2MqULo4/ZG+1vysc8FW0S7SQinSv
	 EU2/aWkfO6AoDu9p/XT6o/w532QCcJ5DyOLIlv5qMue+8Gw5Q2qcJknJna9Jxf5jxOeqS
	 XGaQ4Nz6fyumcQ+RMVkxr9UX1KRlDGULcS/uy/H30fviKWMvnXkmcR5UoIzB0++yeSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=andrei-z.com;
	spf=pass smtp.mailfrom=andrei-z.com;
	dkim=pass header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=WELMJaNg;
	arc=none smtp.remote-ip=82.76.27.144
Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C72606A31A;
	Fri, 23 Oct 2026 13:38:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4C72606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=WELMJaNg
Received: from MAILGW-DELL.dell.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 6808989ED;
	Fri, 23 Oct 2026 16:38:11 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=bO/ySbw6Wy2tlDziwBPG
	xxBRPseyc5qUYsYdDeHqHWI=; b=WELMJaNg+kQTpciqPACrxLoscJEsXRAlkVSI
	3yQWWNUo8OfsWoneriFD4hqEVP8sxxU9iv0ppQqilhb5ZTQ3LzRW4TYgGRAgM8xP
	COR94Qm5MDxQJt86SyP6w6vVBbgri1ZkJvHH+VjIUzc6PKLdG3ip/d7gGpdS9PO3
	WWx1OMF1oF42MncidewQfaRjy89aZeyV/mAeoU6qxGbEmXSYfC4A8k6sjen1j3gV
	AWv+jSp3AHDBfjPsV9UPkS67kvCDl53M11XyCrsi3OBV6h2ZzdMVUm1COFE0Huyc
	cu21eHYHu/ixYv+ed0jSoGhlw4W5EmS96X9wrSQwPDdTmVeAOA==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 0C71D9014;
	Fri, 23 Oct 2026 16:38:11 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 16:38:10 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, Konrad Dybcio
	<konradybcio@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob
 Herring <robh@kernel.org>
CC: <ath11k@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v3 1/4] dt-bindings: net: wireless: qcom,ath11k-pci: add QCN9074
Date: Fri, 23 Oct 2026 16:36:57 +0300
Message-ID: <b12f9b35def027947e5a4b6328c68d1a70d3c97e.1792761470.git.me@andrei-z.com>
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
index 0162e36579..605ac5e01e 100644
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


