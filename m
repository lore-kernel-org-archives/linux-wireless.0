Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBC234041E
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 14:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788790649; cv=none; b=R6Pi7Ib4YXpNPAU2qlu+SnhgrA0CLuRIKztZOcLQMpOd52WNhSclv6jaRzevwvptLsrJwopPXhqoCDtZDpwzUp9eo03WI5kTn/GllSxnq/XR5SEST0WP3nB7pbwQFuKn750tgtEElbdowakDYKHRfDV9IA7ex8kwRXnOXJUeOVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788790649; c=relaxed/simple;
	bh=GZwA/MKtBxY3W7mT2sPBR1+zgdTlkURScZ02+uOP0RM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=rd3QZz/qYTctjTCqEgAq7yakmSeovUGwg6QPvPD6px4QWiG2h2svOehi95pj1qZ8EzuaEqyFwea/3TUcK5RkIFpktG2M1CWs2+9dxmKPh0QZiAyXjNJvy3Mm2OcPhMRORH4pNbzsy+qrKLm6SC9/sUm9yfGGfx398lPqOv7TE84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=osSy7y8g; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="osSy7y8g"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso40432765e9.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 07:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788790646; x=1789395446; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vQtLGaBEb+xd41WLDmqvQf+F9Q3EMz9NEqhORQulUCo=;
        b=osSy7y8gmz/N7beGGn39hDQPSWY5+bFtyExIZpDXzkwBRDbbgcMA1Mwad0rF7HWYLb
         OxJ7plobHs/GQEQTFFKKHudnfN03Fj+Plc1HyXmbwPGSlXDucepsY9FBXxWZqQ7TxigU
         6jrrv39IVmOKjRW73DJZAoO3qVnwhbnysNFKYnYlyPYfqAp3C2/mGSoN511sqRyRKMNc
         Nm3/LlUNJuthqOqdjY/v1MR9uHvM93CGrnmk544iHrNb5vFkfjKg+TgfsVrYWejzhMMs
         +RWZWAhfFvq8/ws25bP0riJPEhJzQRMBnv5MlnOh3ggXoaveX3y1Qw4kBb0aMFDvlDWg
         cv1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788790646; x=1789395446;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=vQtLGaBEb+xd41WLDmqvQf+F9Q3EMz9NEqhORQulUCo=;
        b=SiLiBrFmJ3IKEEprGWfrvlp/Ua92Ec+LY8qdzEzM9p2PVdKJ462QqfueNPaZEfSg8d
         g6KVBtGocEm1nNHPo94o3wYifQeK1dQIeJ6jO/Qq5jJSN6bgPlxeV3fA4SOXIoTBLoz1
         ADG7xou/xAK+xAlr1kvK10USddX7QoYmzCcoOwIyjhQORXhS45DOODjnh40FSahYfVzo
         BQX590nUPuk23haUoKm5HvElkBYQl2bkUkmUK3oIY5PEUVZJRKqRlbgpjzw/xbK+gNgI
         7xZ+dfTd7sNicc/g55RyXgSsrCgb7TrgZSNMetR7gSykiGcaaO5XN/R3lZYoOXHs/E9Y
         VuKQ==
X-Forwarded-Encrypted: i=1; AKwUvBxFav7du38zqPNN8a9zNEhzBobCGdjAV9cqZBL946ONXVCkZLYhoHtYPdl58Hc1U8oxs55yw2gW76AJxCHC+A==@vger.kernel.org
X-Gm-Message-State: AFuF++nTq6dgh7CKGwGUrHaQpZc2w2zcHg1OotoZ2AHpVMGUgG78fEPg
	0Z1aug5A86vQPVafXg9VVjvkwRCAUnWM6XNgVpZpV1BLSFEPi4ciRLjp
X-Gm-Gg: AYBFou3PC/KbKsRatA5bVmokXgaKenIAn/Tzdkwq+n9Qy2yJk5i8qFZ0ourj8HOg8d2
	phd0v21eCpXZWbGBPw/CsN6/j7eP4s7oGzlX1jmiB6IGieHZeLmY/TD64fh3p7nHBam7j/8L/21
	3vV7b6cQwH/BrD0Orweb++nP4h0Dbyy55cUzWK3icYg6J5CPiP80nqPU9HBzS4Ik8IuHJ2zGrny
	K/G9l5TYo2CqUAo0T0tiBFJhTQYKsAyCdatm+UJhFeBy/eqdlfkY2v5FZkNAuqpshyJ6UQej/U+
	CM/YbaG+vyUW5BAWK5ymG8eaNlmEPwWmTswik42cYQQu6WO5D0TbJAnRT6Felq1UXrlVwQC8g97
	tnK8w4e9yEm8fQFR3x94ild6MiUDQDUtVM7UlKyi6F8MUeIVh5+67BKbtEh7WO5oQKNqVv4VhZv
	bxJJJgN54PQBe0p1jZjzuubi7Hjv2kBy82WAeh9FePK/kGA8MuiK5/uwMrDd0cbURFrgnD3qIpN
	sPBHPI9/ODoISCntQ0UiTJL8TuKzq0Zhd565ks+uMbtr0mompZ/yStntP+sPD/8SX8M/4ormw==
X-Received: by 2002:a05:600c:1c29:b0:49d:15f8:2bdb with SMTP id 5b1f17b1804b1-49d15f82becmr22689355e9.7.1788790645027;
        Mon, 07 Sep 2026 07:17:25 -0700 (PDT)
Received: from ernest.hoecke-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch. [83.173.201.248])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cfbe5b252sm270473075e9.3.2026.09.07.07.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 07:17:24 -0700 (PDT)
From: Ernest Van Hoecke <ernestvanhoecke@gmail.com>
Date: Mon, 07 Sep 2026 16:17:20 +0200
Subject: [PATCH v2] dt-bindings: wireless: ath12k: allow calibration
 variant for WCN7850
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-ath12k-calibration-variant-v2-1-1a9d6c47dade@toradex.com>
X-B4-Tracking: v=1; b=H4sIAG/HnmoC/42NQQ7CIBBFr9LM2jGAUYwr72G6GGCwE7U1QEhN0
 7uLPYHL9/P/+wtkTsIZLt0CiatkmcYGZteBH2i8M0poDEaZk7JKI5VBmwd6eopLVFodKyWhsaC
 z56OKNsZgPTTBO3GUeZPf+saD5DKlz/ZV9S/9S1s1agwHDoHIxTa4NgsFnvd+ekG/rusX6bvm0
 8YAAAA=
To: Johannes Berg <johannes@sipsolutions.net>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
 Andrew LaMarche <andrewjlamarche@gmail.com>, linux-wireless@vger.kernel.org, 
 devicetree@vger.kernel.org, ath12k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
X-Mailer: b4 0.13.0

From: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>

qcom,calibration-variant is the generic Qualcomm Wi-Fi DT property for
selecting board-specific calibration data when the device identity alone
is ambiguous.

Commit 06cca100ad08 ("wifi: ath12k: support calibration-variant from
device tree") implemented support for this property in the ath12k
driver.

WCN7850 can be used in systems where the PCI device ID and machine
compatible are identical across product variants, or across regions with
different regulations. For regulatory changes, the hardware description
does not change, but the vendor-provided calibration data can differ. In
that case neither the PCI identity nor the machine compatible can
identify the required data, so DT needs an explicit calibration variant.

The ath10k, ath11k and ath12k WSI bindings already allow this generic
property for the same class of board-data selection. Allow it for
WCN7850 PCIe devices as well.

Signed-off-by: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
---
Changes in v2:
- Rebased
- Updated commit message
- Link to v1: https://lore.kernel.org/r/20260701-ath12k-calibration-variant-v1-1-d3eddaabf026@toradex.com
---
 Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml
index dc68dd59988f..cf3e1fd99c12 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml
@@ -54,6 +54,12 @@ properties:
   vddpcie1p8-supply:
     description: VDD_PCIE_1P8 supply regulator handle
 
+  qcom,calibration-variant:
+    $ref: /schemas/types.yaml#/definitions/string
+    description:
+      String to uniquely identify variant of the calibration data for designs
+      with colliding bus and device ids
+
 required:
   - compatible
   - reg

---
base-commit: 1d8e73163ef933624341075f576e2f36ef9133f7
change-id: 20260701-ath12k-calibration-variant-b7850f7ffd7c

Best regards,
-- 
Ernest Van Hoecke <ernest.vanhoecke@toradex.com>

