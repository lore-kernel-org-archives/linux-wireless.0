Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384064F68B1;
	Wed, 23 Sep 2026 12:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165123; cv=none; b=dzzDprI7q0YsQ/6c/kgcyOia/hMeGksnnw/PyN6X+0YbRTkegOoI+B7yQi4/DOskomew+ai40WcIx48GF2V7EoBovlOZ4B28d+IhquCxGSaV5mVoTHF8GAaHc9TuP02JHC1zfRyPtsDvgUvphnTaVW6qCJsYY4K1euE+yc/IjhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165123; c=relaxed/simple;
	bh=aiu5BQmooqpYpTxUiTsFRkUauq9c6vOlNTSSE9Hp2cE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fTbd6uyHXF659FJHZezhd4z4s5036RDKUIYb2hP/INynWjSJo5B3spd6e7FmkGB2sGjyZLK5WEUqIEyidxxZCIQTgnjkInnBGMUQmztVFXRK4+ExC08gy8bWr73PNeXiX2U1MbeJBtQZm4MjXz5wxD2+BCLpHkfiNAe5YtW1oe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hhMXezZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhMXezZC"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3B8AC2BCB8;
	Wed, 23 Sep 2026 12:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790165120;
	bh=aiu5BQmooqpYpTxUiTsFRkUauq9c6vOlNTSSE9Hp2cE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hhMXezZC4F734ZEYTNu0ImTcn1++ayl23Vp6sFKPd6wz8iUNWKd5dHihz69NbPipQ
	 8zuPIAfqcHJxmsfBJqaky2XT7Qo/iSLlEWyAU30rqRAm/+OwRhvnJFxEzD1AMbu2Ep
	 p61wbSSdcNbKEkOv6szKDylR69JS0Ar+gB+4Az7yh17MqU6AkA+YYpaZ9OFirPcKtC
	 OAL3U7RwgixpYLNcKoIgv8yEwrvuuNgsR3Ib3g9SIiBM9HtAp+vWafn8THhRtWcj44
	 gWYi98hZ/3qaNXGLtoK2uLdg5U+3feDHBfqTXqCXZ3eDH7mkcOTpk2pL4EPQmhCSn4
	 6f8nPg6jXOWJA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F91C98307;
	Wed, 23 Sep 2026 12:05:20 +0000 (UTC)
From: George Moussalem via B4 Relay <devnull+george.moussalem.outlook.com@kernel.org>
Date: Wed, 23 Sep 2026 16:05:07 +0400
Subject: [PATCH ath-next 01/16] dt-bindings: net: wireless: ath11k: Sort
 compatible names alphabetically
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-ipq5018-qcn6122-mpd-v1-1-86729521a75c@outlook.com>
References: <20260923-ipq5018-qcn6122-mpd-v1-0-86729521a75c@outlook.com>
In-Reply-To: <20260923-ipq5018-qcn6122-mpd-v1-0-86729521a75c@outlook.com>
To: Johannes Berg <johannes@sipsolutions.net>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 ath11k@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Vignesh Viswanathan <vignesh.viswanathan@oss.qualcomm.com>, 
 Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>, 
 linux-arm-msm@vger.kernel.org, 
 George Moussalem <george.moussalem@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790165117; l=1172;
 i=george.moussalem@outlook.com; s=20250321; h=from:subject:message-id;
 bh=8Rc10oeOzKG46Y973OUa46HiYgABQNhQH09OMbqE0/A=;
 b=3+IjZNJc/3kIEHzthob1GBb8swjvmJm3tT2XGZdAeVqB3+1bxIGOUS3jPiFtH7zw2XhSFeb45
 S8mdKrSK7N/DUNla87oYJd+YhC7B6MW3DhOtcsbJ2gvPyGxpPV27ex4
X-Developer-Key: i=george.moussalem@outlook.com; a=ed25519;
 pk=/PuRTSI9iYiHwcc6Nrde8qF4ZDhJBlUgpHdhsIjnqIk=
X-Endpoint-Received: by B4 Relay for george.moussalem@outlook.com/20250321
 with auth_id=364
X-Original-From: George Moussalem <george.moussalem@outlook.com>
Reply-To: george.moussalem@outlook.com

From: George Moussalem <george.moussalem@outlook.com>

Sort the compatible names in the binding file alphabetically for
legibility and correct ordering.

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
---
 Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
index d4aa56e2f823..a846cd704b19 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
@@ -17,10 +17,10 @@ description: |
 properties:
   compatible:
     enum:
-      - qcom,ipq8074-wifi
+      - qcom,ipq5018-wifi
       - qcom,ipq6018-wifi
+      - qcom,ipq8074-wifi
       - qcom,wcn6750-wifi
-      - qcom,ipq5018-wifi
 
   reg:
     maxItems: 1
@@ -108,8 +108,8 @@ allOf:
         compatible:
           contains:
             enum:
-              - qcom,ipq8074-wifi
               - qcom,ipq6018-wifi
+              - qcom,ipq8074-wifi
     then:
       properties:
         interrupts:

-- 
2.53.0


