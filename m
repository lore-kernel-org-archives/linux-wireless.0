Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166D2414421;
	Sun,  4 Oct 2026 11:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791112368; cv=none; b=Y/ePiXxPm1E2mZHeb1cnpjRaXafPlJzBBrBsjV1yit7O06PsusU0NuBC1Y7mXvRFIBBVMwwK6eCj5Lz2rO0DjQlfrMR4r37NI7ECERp8rTPorHO2g0WDPq6ZYWLGuX5jhpNtJ4YLV4W8KAfDK5+TOK+5AQ6a+TsNAexgU88+rvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791112368; c=relaxed/simple;
	bh=wOSXyj53zul0eWWsWf7YHkMamd6jAObuqJXkgj0ZrwU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lsQxi5vqny6griXq+1pJdkbpeEZnCoo0JZJCV1m3fPkQwAnygEgONSfSjrBiWu2LE7Zd6nZYXqB0lTe7x9MviSPJuZhuPGWLoUlmIHSYvoE+lDhFzSRqDx8kaQ80UYsE8vKLdbdv7CwwB64tMJzeztan8G7AOFf5//5Kd34areI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=bBFkTqdR; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="bBFkTqdR"
Received: from MAILGW-BIG.big.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id C8DF2102ED;
	Sun, 04 Oct 2026 14:12:44 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=ddsfmpn0HeRxhSOer3sH
	R5O9BrgbtEBLrHx3YZTuNDQ=; b=bBFkTqdRbZToXrcZ67wfN5dWHZUWxcqOpa5F
	yD/8I7qhPAUdeNfWpczMBn8kARtJzxlDacAwI8QrA2wbzELgj+uad4DJbjPQIlQb
	CugFQeuu0iK7QlAgwfrLCdydRBYi1uZP11QnTlpEI2ECxVsCoqWT06ipHMSiGl+R
	6EFQJIp9eW9TFLPpYrFjlUZg77noetqWpv6JPeZ0Yda2okpk9uzT/Rc5F8uldU2W
	E2sbob4IjDi5OofFh6YbMZxxWBd2g4nG0aCqOzZdo2qJ6ZGw3fb08NKTb+8kIxBt
	2CuKUsijuE6PF2u0IL8rbXHZroqEEy3jXcIeY4sOEvMvkv4rWA==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 521E3103B1;
	Sun, 04 Oct 2026 14:12:44 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:12:44 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Bjorn Andersson <andersson@kernel.org>, Conor Dooley
	<conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, Johannes Berg
	<johannes@sipsolutions.net>, Konrad Dybcio <konradybcio@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>
CC: <ath11k@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/3] dt-bindings: arm: qcom: add Ubiquiti UniFi U6 Enterprise
Date: Sun, 4 Oct 2026 14:10:27 +0300
Message-ID: <3c19155a87b94faf4e16f3d15c7875a525e63ae8.1791110510.git.me@andrei-z.com>
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

Document the Ubiquiti UniFi U6 Enterprise, an IPQ5018 based access
point.

Assisted-by: LLM
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 Documentation/devicetree/bindings/arm/qcom.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 121ca557c..4524f76b4 100644
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


