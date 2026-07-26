Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DE82EEE86
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 05:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785044322; cv=none; b=LHL66qjJ+QS2Ag2XUpa13TtTI6i8DoLzN7GHsfTYp4TOWAjEwG1jX1GARo0NDhQvDwcX9wKpzI9ypuIxu/ByAcG0vSKBqsa9aPNHKjVo+vHF/5EqUGSNREOwWGq/KkJMnICBMxeet4ZltxkOlcRPfB+P6R3EfQr9oLY+4ff5vs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785044322; c=relaxed/simple;
	bh=j7FUZwB9pjASzphoYEYSQhWkw4XGgszx7T8FJ8ZX9DU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AIRPbh6x2WF+d5GvnOrR/Iw9Bczs/wwqkA5DTSvCYBokyY/nje3RwDhcPJaptVQ0q7NvaETVZ3/F/EbQAW4eq0tCqq1zEeYObbHCypoB4AUFAzo/Pa73iNhaSAhX5aYAa31i7wYcJIVBcJ3zP1dBsaFJtmimQqALAX8Tc5l1M84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O9ybJm0l; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O9ybJm0l"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84864086bfeso1629516b3a.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 22:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785044320; x=1785649120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ev/3L8OQlWgePlw96lEzXKu7EjQVakUCH3mo3g6zOGU=;
        b=O9ybJm0lTEmu0uhTeWzgQ1ubuC61AW5RnX19fVa8/wCqla2JpLk4rmgZ+7lDoJWDVl
         NxwPLEIJVdW2zgUKcebQLCeOIZswg6UoBBXSY5KlA4aTjmba1Vq/EIMYWNpqbRjtufQN
         z7VTkgoKc8qzHqne83pXuSdSZ6olxB/pk0jkM7vSzyDxqswVe3Qs7YX9KKn4LS3ybJPE
         tXppdifDVWjffturkOSTceBg0CZzWfYXxZ30Mct/VUJqTTgA0szzLsMBRgIbm8q8R9iu
         O6ziIUhKAOTq4+iYfi1fQs18YI2KeBIzWUOVo2SxyO+kZCev0khl16RwtW0YlgD2CZU5
         USjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785044320; x=1785649120;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ev/3L8OQlWgePlw96lEzXKu7EjQVakUCH3mo3g6zOGU=;
        b=ULBSeRPu8S0B+jNbRjW7KKNVMO57Jd/aCYzUP5q+RZlrh6FnUjyA8yPpAZBahXGa4l
         /hBW9tqtmaZ299A03iqwdUE2NImLI+Ihk3VD+pafiKuMXxxJV4UoJOrzYb2OijOnyzRU
         8bQRZtnMwdmSA3JpZfd23oC00VE1a834Yw/HjDhtrsOtx+prZyN26FxoSLnF771T0dkV
         vPqUwF2qE+1C0JOiRCU753RYVS7bmY2vQkQErd1nBoszwpmgEWKTOExxCq2gPCaQV8D0
         2FgJWp6pMz5+coYsYfoZpI+JYByW4vO6ZuBACxpAJkXtafM39lplpOeGl1HHyzFkueNG
         Xykw==
X-Gm-Message-State: AOJu0YzpRyDIt0ijKut1g/KjSoJ3u8C6hZcmPr240QzP9XTfAjtASjEl
	NXmHm1LUv6hFpIyfZ9aENuxTbn181v6VA76jJcW7zKpwh36JU0wgAeqF
X-Gm-Gg: AR+sD10CUgvx6QFsiwrx93q+dXU6j4G7WnHUNw5ieI2lc/yBmb/VIRUutMitC89LYZv
	KC52Tp1Os/vgMSlME2KJqV9vxUhXLGRzG9vV7ySPPB34Tv5NzPUp2gOJlU7/BRQwuNm1pHnAHlp
	t8tlHsZQuNAXG6b0b2MaMWp2EWve2QgrphbUVaK9zgyFrVYLtl4qrCPgiIg1YJ2klpG+z3JZ81Z
	w7s4K9jR62lo3JSegjEQ5O6X/D707dQR/7vd+dngGZAHtlYIr1dtKf8jkeMMaOy8qzVeDQFkYT0
	r6scJFiDLwwQ3TIKvpLAj63xOGwTT++06/TLKVNmWMuuaSIK7Bkob5JS6Vw6HI/kAdmwa3tiHSK
	bTXg7fbDRjaeSsdElIV+UOZmcSLyCcoGu+Xgb9fO3ha13DnSLJ6ZAPCCc5/jkPkfYWTYmmxMiUc
	hoR9XeUB2kpMiIIFiOmXWRZidxjR/+r/g=
X-Received: by 2002:a05:6a00:190c:b0:837:e9cc:d474 with SMTP id d2e1a72fcca58-84e593ff0efmr3181609b3a.2.1785044320319;
        Sat, 25 Jul 2026 22:38:40 -0700 (PDT)
Received: from acer-nitro-anv15-41.entro.com ([118.34.230.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5346dc8bsm1600912b3a.61.2026.07.25.22.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 22:38:39 -0700 (PDT)
From: "shaikh.kamal" <shaikhkamal2012@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless-next] dt-bindings: net: wireless: mediatek,mt76: fix 'spacial' spelling
Date: Sun, 26 Jul 2026 11:08:17 +0530
Message-ID: <20260726053817.17409-1-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix spelling error reported by codespell: spacial -> spatial
(spatial reuse). No functional change.

Signed-off-by: shaikh.kamal <shaikhkamal2012@gmail.com>
---
 .../bindings/net/wireless/mediatek,mt76.yaml           | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
index ae6b97cdc44b..e51acc544f15 100644
--- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
@@ -221,7 +221,7 @@ properties:
                     minItems: 4
                     maxItems: 4
                     description:
-                      4 half-dBm backoff values (1 - 4 antennas, single spacial
+                      4 half-dBm backoff values (1 - 4 antennas, single spatial
                       stream)
 
                   paths-ofdm:
@@ -229,7 +229,7 @@ properties:
                     minItems: 4
                     maxItems: 4
                     description:
-                      4 half-dBm backoff values (1 - 4 antennas, single spacial
+                      4 half-dBm backoff values (1 - 4 antennas, single spatial
                       stream)
 
                   paths-ofdm-bf:
@@ -238,13 +238,13 @@ properties:
                     maxItems: 4
                     description:
                       4 half-dBm backoff values for beamforming
-                      (1 - 4 antennas, single spacial stream)
+                      (1 - 4 antennas, single spatial stream)
 
                   paths-ru:
                     $ref: /schemas/types.yaml#/definitions/uint8-matrix
                     description:
                       Sets of half-dBm backoff values for 802.11ax rates for
-                      1T1ss (aka 1 transmitting antenna with 1 spacial stream),
+                      1T1ss (aka 1 transmitting antenna with 1 spatial stream),
                       2T1ss, 3T1ss, 4T1ss, 2T2ss, 3T2ss, 4T2ss, 3T3ss, 4T3ss
                       and 4T4ss.
                       Each set starts with the number of channel bandwidth or
@@ -262,7 +262,7 @@ properties:
                     $ref: /schemas/types.yaml#/definitions/uint8-matrix
                     description:
                       Sets of half-dBm backoff (beamforming) values for 802.11ax
-                      rates for 1T1ss (aka 1 transmitting antenna with 1 spacial
+                      rates for 1T1ss (aka 1 transmitting antenna with 1 spatial
                       stream), 2T1ss, 3T1ss, 4T1ss, 2T2ss, 3T2ss, 4T2ss, 3T3ss,
                       4T3ss and 4T4ss.
                       Each set starts with the number of channel bandwidth or

base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
prerequisite-patch-id: 912014811782d33538ddb17f00b64c15b364425e
-- 
2.43.0

