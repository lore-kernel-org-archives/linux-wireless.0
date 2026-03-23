Received: from courrier.aliel.fr (pouet.aliel.fr [65.21.61.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B1C389E1F;
	Mon, 23 Mar 2026 10:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.61.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774260517; cv=none; b=o4QxFmsIZf34X8ZYasb0W6iHdcpNIuWbeSFSzOankvZcBacMoXhzwGjbpeoPlJN43Pwv+VmK8m2y2FpEsRCvio7xZjQabZfJQZAjPck8Glpvz577wWsaJwFm5Yr5Apvhe0j3wAVwmx7bZE9o2ufaK956eFIAG4eRpgjU1nJWh4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774260517; c=relaxed/simple;
	bh=HEk6TEzOtM91mjfH4G/gA0WRcmn4ewAqqaYnYDr2u6M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U+mDLg8M8ETuoyPmFpQzBsnPQaK4z1b7dKSMaRuwbinqp0Bkonr5b3rpfKWwDGfTZ1Db7GtuGM8YC+PnbnBiIUXg5h9jEml4RcfzhQmJEP8E1jaUsJalFjQnLTZklcWCMgAx4ogsf+F2Qmu6PSyO4I+PRmfiPKJQKWyTeNdIMUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr; spf=pass smtp.mailfrom=aliel.fr; dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b=RfuJL8F/; arc=none smtp.client-ip=65.21.61.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliel.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b="RfuJL8F/"
From: Ronald Claveau <linux-kernel-dev@aliel.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aliel.fr;
	s=courrier-s1; t=1774259899;
	bh=HEk6TEzOtM91mjfH4G/gA0WRcmn4ewAqqaYnYDr2u6M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RfuJL8F/1TH2Xq19mYcLTOiJ+jSp77kgzU/0hqByMUgEZSeE8tjwfV2xhUewcx2Hf
	 HXRc1Ee3p9fHL4UFTKcZqHYfBANdP76dd9hmDxMCnh0ZyNqRxmjxOa42J5IBbET71e
	 iYNyIUvd+OOiEPLh1Bxmd83/7GZmSFYupOT5OpiI=
Date: Mon, 23 Mar 2026 10:55:27 +0100
Subject: [PATCH v3 2/9] dt-bindings: mmc: amlogic: Add compatible for T7
 mmc
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-add-emmc-t7-vim4-v3-2-5159d90a984c@aliel.fr>
References: <20260323-add-emmc-t7-vim4-v3-0-5159d90a984c@aliel.fr>
In-Reply-To: <20260323-add-emmc-t7-vim4-v3-0-5159d90a984c@aliel.fr>
To: Neil Armstrong <neil.armstrong@linaro.org>, 
 Kevin Hilman <khilman@baylibre.com>, Jerome Brunet <jbrunet@baylibre.com>, 
 Martin Blumenstingl <martin.blumenstingl@googlemail.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, 
 Johannes Berg <johannes@sipsolutions.net>, van Spriel <arend@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-amlogic@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, 
 Ronald Claveau <linux-kernel-dev@aliel.fr>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openssh-sha256; t=1774259894; l=1008;
 i=linux-kernel-dev@aliel.fr; s=id_ed25519; h=from:subject:message-id;
 bh=HEk6TEzOtM91mjfH4G/gA0WRcmn4ewAqqaYnYDr2u6M=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgMGec55oxeeisqykQiUedekMYyOnR9
 BG9E/7rDWyqdNoAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDVLAOKolTOjlCFNMip2F+ZQ5qNM40GZZeT/VYe8fG8hUx+xrsfO2/aVKj06NEU0HXYHwKdOEmf
 WXXMN/RTBRg4=
X-Developer-Key: i=linux-kernel-dev@aliel.fr; a=openssh;
 fpr=SHA256:kch4osYZ6A1BrPps5AUs6KnfdE2wm4ocMtyTc8TmZMs

Add amlogic,t7-mmc compatible string, falling back to amlogic,meson-axg-mmc
as the T7 MMC controller is compatible with the AXG implementation.

Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
---
 Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml b/Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml
index 57646575a13f8..40dccf9715781 100644
--- a/Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml
+++ b/Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml
@@ -19,7 +19,10 @@ allOf:
 properties:
   compatible:
     oneOf:
-      - const: amlogic,meson-axg-mmc
+      - items:
+          - enum:
+              - amlogic,t7-mmc
+          - const: amlogic,meson-axg-mmc
       - items:
           - const: amlogic,meson-gx-mmc
           - const: amlogic,meson-gxbb-mmc

-- 
2.49.0

