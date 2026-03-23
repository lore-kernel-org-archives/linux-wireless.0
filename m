Received: from courrier.aliel.fr (pouet.aliel.fr [65.21.61.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B85C385507;
	Mon, 23 Mar 2026 09:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.61.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774259910; cv=none; b=lSm9AsZQslu6rHTqe05KGX3BzQc3k/UBEV/no8BqRNDHXVTN8Qx9hWfMHtwDXXiZjC6a4qK4IAvIViYy6H3Hx1t/1pfwoC7CA4R4CKkJt1ncnnjAjPosnth8oEXVUnwhmD4ntEKw5ALGwj/MNjg5LJyhpdm/JoO+1c+B5+2otZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774259910; c=relaxed/simple;
	bh=PAO6Z2Ay8+M9O7tMUw0wZiqIaHw2Mt0/shBBmfty138=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QQw/iEdbMrxeM2/G54uG6M6AC46wxI8UrExd5Z2ps0bNMzcSKIwp6ApifRgp0DkMjaPgjxHFXNAD6URYsOvbUT72JmahZHD//Mlwd33BQZ+tfgxSc1yGE1TjP9LX28f0Ld2AsbzjkqAobL/OkTQDAX02tvT8OXamjs2+1PJLRNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr; spf=pass smtp.mailfrom=aliel.fr; dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b=n+ARx0QO; arc=none smtp.client-ip=65.21.61.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliel.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b="n+ARx0QO"
From: Ronald Claveau <linux-kernel-dev@aliel.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aliel.fr;
	s=courrier-s1; t=1774259904;
	bh=PAO6Z2Ay8+M9O7tMUw0wZiqIaHw2Mt0/shBBmfty138=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n+ARx0QOVSI73gnbSYWYoc3FeYm6S0ZuS4gLh6vZorOhzOL2O7NgR0Y7vxBc0FPh9
	 tYLBdHXIl6VvsrR4MH5yKsYceKGDckIY31MxXGiJiOUadGL7KYIfZtYduutrudz/Wh
	 +sHj/ramNMCcN1R8gYEXtN4Nu8WaL7gPAZ+a/92c=
Date: Mon, 23 Mar 2026 10:55:33 +0100
Subject: [PATCH v3 8/9] dt-bindings: net: wireless: brcm: Add compatible
 for bcm43752
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-add-emmc-t7-vim4-v3-8-5159d90a984c@aliel.fr>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1774259896; l=906;
 i=linux-kernel-dev@aliel.fr; s=id_ed25519; h=from:subject:message-id;
 bh=PAO6Z2Ay8+M9O7tMUw0wZiqIaHw2Mt0/shBBmfty138=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgMGec55oxeeisqykQiUedekMYyOnR9
 BG9E/7rDWyqdNoAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QOLZ3+1Vg9dXpfnoDSeRCndObgEvaQXG1m2vupZ47DejBFobf7+EIYHilTiWgcPx4NElNSDZoRL
 B6GhSQAWK2AU=
X-Developer-Key: i=linux-kernel-dev@aliel.fr; a=openssh;
 fpr=SHA256:kch4osYZ6A1BrPps5AUs6KnfdE2wm4ocMtyTc8TmZMs

Add bcm43752 compatible with its bcm4329 compatible fallback.

Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
---
 Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
index 3be7576787644..81fd3e37452a6 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
@@ -42,6 +42,7 @@ properties:
               - brcm,bcm4356-fmac
               - brcm,bcm4359-fmac
               - brcm,bcm4366-fmac
+              - brcm,bcm43752-fmac
               - cypress,cyw4373-fmac
               - cypress,cyw43012-fmac
               - infineon,cyw43439-fmac

-- 
2.49.0

