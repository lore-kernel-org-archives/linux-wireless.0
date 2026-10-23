Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.76.27.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792762759;
	b=vMlUa+KtpMcM4GUP1cyZN29pbLdH94qLT+61kc2fZOQ7Y/GNjr6CcKZ13TkrPbucs9nM
	 agfn53hYoxwO14PCl6ekO6Tljte7khqkaWMA2PG9aK6/dOyAvxMxe8ywgR36lhzmaSkLC
	 xFaaGva/m+0wm9dPUF674zTye1B58XNgSItG3XRioeUeLxnKhSiTNVKyldAD3t2mPyCC1
	 S+RRRzmCw6bakDTVK3k+0P8rWKI1y8NOEjFK4mHTndMvuFR3azpPxDt53GuBfrXzMrlgJ
	 ZQlNVPliXpjRXaIVNJlkIDep7zYqaCw3xoNNI8z6lYNwHN0Ma2WrSTQ+JdUitay0lBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792762759;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=jQJ8dhA2iKUXZKusDvMRU3BFsb6qq9+2GC+fIDmWGXA=;
	b=NgylPI2goJTdBmCKMUGNLzg8ZFRy63+WA32n8eJ1UNv/AcRrLxjy+syAf1s01r4nQBtN
	 Ogqr6PDdNcP0KZ0D7vKf38qloAoQqMOYewTto2bVdNhcXPzjDeluybOCJPn2MakGKF/ux
	 rMxiuZbKhVkrY2lXGQQxPvAp32qJi3IKNs6fq0QX4ytQQy+AqpPHYFP2eyVPwcDSmi55H
	 5o4kVT74GEi+SlP6nunvG7vgy0ESmTWYzX8ExA4hsQ2XY07+kh46v0aVb+Rvocx25FE1L
	 PGdBgVaerOwqMRq93oyDxuMyUEQaSxVjQz2U/qgN6gnQFInuBfexjnICwE1zASSEm+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=andrei-z.com;
	spf=pass smtp.mailfrom=andrei-z.com;
	dkim=pass header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=Lo4XvNwy;
	arc=none smtp.remote-ip=82.76.27.144
Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5C7606A31A;
	Fri, 23 Oct 2026 13:39:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A5C7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=Lo4XvNwy
Received: from MAILGW-BIG.big.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 697CBFC2B;
	Fri, 23 Oct 2026 16:39:16 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=jQJ8dhA2iKUXZKusDvMR
	U3BFsb6qq9+2GC+fIDmWGXA=; b=Lo4XvNwy/QaAkX7p29t05+GqQDnMF6BWKlg7
	SYI3mrq23IGm69YT4fzByMcj3Vdb8EIaGj039hz3dJ8rOi0M52qpuBphIuCaMFVp
	PfPq3LaIP61yatHSePaJlSY8J6qPoZn4suI4Jl5J4Fp5/zEaYCTtSGyJUMe/b3Bv
	QDsbZXDwmQvOpRnL/UCOXaro6//uGUUCyNEmJJb/b4XcWU1psWIn17WPPjta1cC6
	PD03brjcSw3TtW0N/olShm5JoeaqTbKlsV6CuA13ZTUyyRhBYnMpJcTyvkCHXg3o
	1/p84mzSB9ZLqIH4gJq83Jns23uP4BcEYJLZPaXFEiAQc4l/zw==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 3FFDBFC2A;
	Fri, 23 Oct 2026 16:39:16 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 16:39:16 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, Konrad Dybcio
	<konradybcio@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob
 Herring <robh@kernel.org>
CC: <ath11k@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v3 2/4] dt-bindings: arm: qcom: add Ubiquiti UniFi U6 Enterprise
Date: Fri, 23 Oct 2026 16:36:58 +0300
Message-ID: <19dda5d7c7a003452019eff0311a574e4b37bb84.1792761470.git.me@andrei-z.com>
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

Document the Ubiquiti UniFi U6 Enterprise, an IPQ5018 based access
point.

Assisted-by: LLM
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 Documentation/devicetree/bindings/arm/qcom.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 121ca557ce..4524f76b4b 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -113,6 +113,7 @@ properties:
           - enum:
               - qcom,ipq5018-rdp432-c2
               - tplink,archer-ax55-v1
+              - ubnt,u6-enterprise
           - const: qcom,ipq5018
 
       - items:
-- 
2.47.3


