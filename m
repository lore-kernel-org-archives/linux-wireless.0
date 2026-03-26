Received: from courrier.aliel.fr (pouet.aliel.fr [65.21.61.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6863BFE2B;
	Thu, 26 Mar 2026 10:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.61.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519319; cv=none; b=VudjX3PXhthRHp0ip/loiksytTriTepvsJN8zgcFvNmP/RQ5VI9NERlqM1J4ibEO/fGNYg00ZyQD7cfSoxkGV3m8ghx0dzIFEZkwV+9BYUIsrgGxOIPmkdKcrou5EO25Ued1GN6QWZhpsXFmMaKMWA0Z6bQguzpXgfpI9YltNYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519319; c=relaxed/simple;
	bh=4WK30/mE0MGHHvTXMGsXTEKwE0mrHfTNI8g5HO+FiMg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kxn57dMa/Cs8O+KJVp7SQdS1nmq8DuEKVxCcWpSawcG9sjt7k0k707GNzhBzEgI5X/anjMmn/V7fSELSuwuyhHv2MgF9ERByWsbEbZG6/Mikr4KRpagqfRuXrIQ5MQMItH5UOhH8SOTg4MCz3imDziITXSsOcBjf7TcXCWRDkYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr; spf=pass smtp.mailfrom=aliel.fr; dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b=oGrkkFd1; arc=none smtp.client-ip=65.21.61.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliel.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b="oGrkkFd1"
From: Ronald Claveau <linux-kernel-dev@aliel.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aliel.fr;
	s=courrier-s1; t=1774519316;
	bh=4WK30/mE0MGHHvTXMGsXTEKwE0mrHfTNI8g5HO+FiMg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oGrkkFd1zOs3ySzdOwyRM9EVn7n8QnnMAkuq/Bh+hlp8R/GKlC79PjVCw/Wy+GGKC
	 wy3l35Cg8swFuEQgw+tGIauuCUe+5n831a8UoaOO4JG+qqHSHyg/CQ1XmUSczc3QcP
	 XX2wDr4aP382F+na6GGdbYdcFnEooZj2VEoOlxWA=
Date: Thu, 26 Mar 2026 10:59:13 +0100
Subject: [PATCH v5 2/9] dt-bindings: mmc: amlogic: Add compatible for T7
 mmc
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260326-add-emmc-t7-vim4-v5-2-d3f182b48e9d@aliel.fr>
References: <20260326-add-emmc-t7-vim4-v5-0-d3f182b48e9d@aliel.fr>
In-Reply-To: <20260326-add-emmc-t7-vim4-v5-0-d3f182b48e9d@aliel.fr>
To: Neil Armstrong <neil.armstrong@linaro.org>, 
 Kevin Hilman <khilman@baylibre.com>, Jerome Brunet <jbrunet@baylibre.com>, 
 Martin Blumenstingl <martin.blumenstingl@googlemail.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, 
 Johannes Berg <johannes@sipsolutions.net>, van Spriel <arend@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-amlogic@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, 
 Ronald Claveau <linux-kernel-dev@aliel.fr>, 
 Conor Dooley <conor.dooley@microchip.com>, 
 Xianwei Zhao <xianwei.zhao@amlogic.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openssh-sha256; t=1774519311; l=1102;
 i=linux-kernel-dev@aliel.fr; s=id_ed25519; h=from:subject:message-id;
 bh=4WK30/mE0MGHHvTXMGsXTEKwE0mrHfTNI8g5HO+FiMg=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgMGec55oxeeisqykQiUedekMYyOnR9
 BG9E/7rDWyqdNoAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QHjtzkCO+mbkgAitvZ1hKC/yMPbECLq55c68kPiBCAxtp5xAebFbUsp3xd3zSw1A9HKigUyGO8z
 qiIdWRfulZwg=
X-Developer-Key: i=linux-kernel-dev@aliel.fr; a=openssh;
 fpr=SHA256:kch4osYZ6A1BrPps5AUs6KnfdE2wm4ocMtyTc8TmZMs

Add amlogic,t7-mmc compatible string, falling back to amlogic,meson-axg-mmc
as the T7 MMC controller is compatible with the AXG implementation.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
---
 Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml b/Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml
index 57646575a13f8..976f36de2091c 100644
--- a/Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml
+++ b/Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml
@@ -19,6 +19,10 @@ allOf:
 properties:
   compatible:
     oneOf:
+      - items:
+          - enum:
+              - amlogic,t7-mmc
+          - const: amlogic,meson-axg-mmc
       - const: amlogic,meson-axg-mmc
       - items:
           - const: amlogic,meson-gx-mmc

-- 
2.49.0

