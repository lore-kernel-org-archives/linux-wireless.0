Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A6376A19
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 19:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476513; cv=none; b=fTHk7H1ihmjoFsC7N3V6S1BS3u6RR7QWLqdNaydrgHojM0VU2lm6XbmPhBnPFwXwgjPxXP7j6fc7iYy3J1IS3rlkrlwrPWFMuJe5oinAFgic5Q9bY1beV6d8t48y17/+uOcUjdAzOxWwJRhYoVjxjNkN4Z7mRV2Bg9ow/dRnQn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476513; c=relaxed/simple;
	bh=sjpcrFYB8d+bC4S7LoKkxpYWX/LF0bafJ7X8YU4y/ww=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bD1NFE6/EyvzSf6Vj02YlB/v480abC03QKEJReoWS8zJBs/6cXXDc5uV/oi5oDHBB4X42ZZ/NNzWIvy+ZSKAJuAb9aCko4dz2Iv4vDl0vGJ+kskR4EEw5nnc35mlbvD5lhaw4pgUO3tRBlsJKbSnYJ23QTHSQ1HbxU/RnFg0RJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qq7AgghM; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qq7AgghM"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38e58034d05so84518a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 12:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786476511; x=1787081311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0BfcN7LOBZWD+vttsIPj25gnBx710XzvAdMMZWdWWbk=;
        b=qq7AgghMEdMMgxPXjvaiD0dkuV5gTME57y8ycAm32eEyOp3boIXAiUbA3yT+rhUPwf
         4iFq8BI3Wv4YuDed4htLEhuVP85kRNMXH4a7BgVUtpwmlu+noeezzmYo0MLWVqct7jAS
         BMUxNsMC+w+ynDVMoBmuNX8SCeDJFozGWy6ggawfVlUm9lnqt1cu1fSOnh9B3qqFKNZu
         VJ68G4Bn1pR+x99KFikNEk9NVh67oqIMk5lFwNAdRHICWBBGBQa0Vhv3AdO77QQZxZtY
         a2nlK99uvfzOc4axUzwJXomO1hAephU1SQXNULi4rweW9yuReg5qwZSh8TtcW6osqmBN
         VfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786476511; x=1787081311;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0BfcN7LOBZWD+vttsIPj25gnBx710XzvAdMMZWdWWbk=;
        b=n49WkUDfCJX2rSLD0BYNiEjLnq8ZDvP4LkiFxtGR5l2y1V8es+lgpKdxv46+vsFnQZ
         SvqwbVDMmLta/+BLHsfUZO+Gsdbu+dU0xZfRVJR+3AwxX5ntW6JUVV98IwH4uR0EJOUa
         /J+n/px15BsAEVfy2IOHcLjtvdlPBFcSMxdpQvABPW5ZweADsnXtFZUQ+YP7dgtmU3ak
         kAlTTF36mXEqsWofj8wqjG62FXiskwgRKSwByVoLzyECHh6IZwX867oitqifH+yp9WIC
         pzDywCBw7/NkLlsHBuEGlr1S/5vpqj8CeuULZyP37uwDg4QaKAA5qfP3vflutb+3xlgI
         dSxw==
X-Forwarded-Encrypted: i=1; AHgh+Ro20GXAjWx6681oHQg50dZDHlWqiRfF02gLAmpa9c1+GYx0PZ0eI0HA4337XuZXpOHMhjUwgBIfiIa3onjdKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwrHFl0AFb69nOS0zN/oo1epRY7W5W2UcrD6Wdnc9aMZ+bV/2hS
	Wq6vuLUZxFTs8miiQJsw4IoUGv14gDzPqGRsQdqjAZh8zCKsc2BA+QGC
X-Gm-Gg: AR+sD115iXhfTxgdjQg0+Ufqi7Qcm92Ku3epE6NLEhsFPPAf9rkKfa5MY2y+WaJW28K
	NjH6X6Y1tnrNw5F6RXsG6mhIHCDxCJKDhSRq5Kex0Nm/PSLIjFB9DWmtLHQM4QqXiCMXoT3UNZV
	9vDNxRw4Dyt15dIWuIlxQu6zunxWoU0QfNh0KvBRhytsvidt0E168G/JaRNp8YcF1Ej/QJWYeqD
	UHQR/OKUNe2IwsdYBxPZHs1i/2GIgGPMEMyq7uderU/vKql79mHvv/zycTknJT6th5YeHjlV83L
	oXvDLz+wM/iyKYnHUo9eyIpVcXfMd7uaJVTDu+SaoksCTkd2u9BvFd/hGgsizi3f8WKk23g5L7K
	JDKEcyItGoZfFpvDAdhRJXDf5Kgt7Ixvb5Nu51mqjg8LJ++HsvQ2ZV3f7o1Gck7gYkuQBbFQozS
	R7Dj1gmrij0737hF7Wo6mXyFgm8naGoDtE3gBfgfKuHFxm0GwM2bOt7lK/U938nx29cEm7OHPJ4
	M8q6gFcFZjxoHH8Gnn6Q6R7ta4zMmrZ1QkpFu8nw5czKthJvR29RG1BG+4hDnl3lk/5/GdLJB1u
	jxnB2Eus2GEZg3wJpkTyf75lBYcpEiCUoPSOGA==
X-Received: by 2002:a17:90a:d885:b0:381:bc4c:da5b with SMTP id 98e67ed59e1d1-392f487a046mr2643427a91.18.1786476511329;
        Tue, 11 Aug 2026 12:28:31 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392f8e3f565sm746425a91.13.2026.08.11.12.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 12:28:30 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: devicetree@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] dt-bindings: net: brcm,bcm4329-fmac: add nvmem-cells for MAC address
Date: Tue, 11 Aug 2026 12:28:29 -0700
Message-ID: <20260811192829.123410-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nvmem-cells and nvmem-cell-names properties are used to supply a
MAC address to the brcmfmac wireless controller. Nodes such as
bcm4709-linksys-ea9200.dts fail dtbs_check with:

    Unevaluated properties are not allowed ('nvmem-cell-names',
    'nvmem-cells' were unexpected)

nvmem-consumer.yaml cannot be referenced from the common
network-class.yaml because it does not constrain the number of entries
or their names, and not all network devices use the same cell names.
Each binding that uses nvmem must therefore define its own
nvmem-cells/nvmem-cell-names constraints, like ethernet-controller.yaml
and qca,ath9k.yaml already do.

Add the single-cell, mac-address-only constraints to the
brcm,bcm4329-fmac binding.

Assisted-by: opencode:deepseek-v4-flash-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: don't use nvmem-consumer.yaml
 .../bindings/net/wireless/brcm,bcm4329-fmac.yaml           | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
index 81fd3e37452a..88d0099871b1 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
@@ -57,6 +57,13 @@ properties:
           - pci14e4,4434  # BCM4388
           - pci14e4,449d  # BCM43752
 
+  nvmem-cells:
+    maxItems: 1
+    description: Reference to an nvmem node for the MAC address
+
+  nvmem-cell-names:
+    const: mac-address
+
   reg:
     description: SDIO function number for the device (for most cases
       this will be 1) or PCI device identifier.
-- 
2.55.0

