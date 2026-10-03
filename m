Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3A9388881
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 09:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791018927; cv=none; b=pdpdLEvqfKHqxLaq8MdntmJJifIulkr0DWSA1BFPl9gUcg51M3Rf2CoDp//MKdUKQHWS49+e0wE6AsKD1zLZo8SLIWT+rkSil3yDkV5q9688+6mU4fSDgb5mQXdhcAC4WmY/YXjWn/a1kHuaqn8m2mKjQGby0OaC72cU3YON2OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791018927; c=relaxed/simple;
	bh=EdzahQprnb0c9a6ntcCV4R7dCiXc6EsdaJ6ixRzGubk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8iUEtEURodXQxLkhJ0WCqnZ/U9xRpAjeE63RsoA8g83vl3EFbp93jOlHYn8T537cCrmy/BO3EsaXbCOXkxDCOxInwT48hCo5A4pSBM1iTXg6wePlnTcb++BW4nq69Oh0QFtCLjZiiC97ORptYkSqUqhcOjcdHga84dddyZl834=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I1K5sVQV; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I1K5sVQV"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48b00a0ac65so97472f8f.0
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 02:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791018923; x=1791623723; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1xzpCaloDfGqbRqjVRILlsh6zNRsWeHOx+x+KXRywfI=;
        b=I1K5sVQVe7dUSDOh3v68UpFmLQQfOq10zg4yffaBKhU7cxCP0H0wspx3kY+GUxLsHY
         nB/ujfB8XTjP1LkwbIj01t59e0JEnpvwhiNhs4wfzuzOsu4xg4lkoE0so1tPyCC85lQP
         xXgLnpfRc81OwIR7cpOrLpp3UfClVq5AwcTzQp9CewK3ZtLxE2EERo8asz2Jdf6kbKv2
         Ro/ef5hxnXLkQAF1tyPYDjO8Wl8RVQ6KMmoBD7OjDcWFzeV8xBsZRR7oAvxPoqePMd6B
         vILoIbJ5encDzN7VZXZCLLKlJ+j0p+OySeP9ceSaOfhlA05Q153cehF6hdi+/ncmfE7f
         QATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791018923; x=1791623723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1xzpCaloDfGqbRqjVRILlsh6zNRsWeHOx+x+KXRywfI=;
        b=ye/WiTbIQKLZjAPRGR/+ShOX9JtuKlkpP/6OHTMecuKWnJ143ZQNMcx3rlVs8DQkpU
         SOThDnC/mJF/+Mhv6pAtsnJVcjZ9mBQe/cRc2JEeCPtjN1UXkxU6O3X1GuoSxQVQofDe
         vxFqJJ/gjyB+MaOp1dEtlb5O+XX6Y3mYIg8YjsPWL+JxLgpNNxzFlHlFzwPBd+t/sLtk
         YtCjUOo7fTvBH6ZW9Qp1UhY934d89H0Cf2YI/A8BGXlesW9DsyzqSkRT7FVQMTCdKfF5
         aPnSFbE7HIBp+kqJ1T3QE5AXvLUbzBDNA+Q+eErkKfWfDTYlgLXDwV6Uw5FamFzUkgzd
         lzkw==
X-Forwarded-Encrypted: i=1; AKwUvBzmtU7ARmBkzaW8QKUBhQiFf9hGGySwWc3m2ge29dyBuRYy4gBq4esNocSjh8pUlNaP6YJnuXQuzQeK4+Es9w==@vger.kernel.org
X-Gm-Message-State: AFq9FYJo3lB46vvUU0cuyTSNYYMiZTN1A8xU9dcCVKmJPppgiodN1zGW
	7crvdd8k4WXQZy6y88e3Sq2ZvkCYws+7dAURDQnZrimEBDX+1NgIlGGy
X-Gm-Gg: AYBFou07/ZZVOEqJvetikjg24nmVeYVq1wsSDvXIN+bzJ7WxsiX9E3NCF7kxEAmuywJ
	DzL2PTRRADh5f7yOdn8UgP8uRuBa8lHUhqXzRZqG3+70y3rNOBb++L7z8DKUwGFCC+N2ZAL3Ojn
	4TZjDID2JLCmpypyewvGkG5HTA5YeCC7XXiEAfV/QzEAczrFAXkq8YftNAM/0jDYRGTJjv2RgMs
	Ze5pCKHwor/FJ+NJgnYFgyARmElGYyPCpGI1JpPMz+K6vl9pSVvs6hT16BtiCMHh0cIyNM8tjWA
	KiJTs490T0IvmvL/wtKFps4Wls7vIeDQc84qyGLUiI3KpizDscfCXt0FUQdIvUZ9opOg5J93+8w
	YveS7byT3s0JcplArZU8r3QShz14cXnRsFtGvRx27akPWm70Lu2bsUFTIdTTfWZQrOT/vbDlD3E
	c67F9EiEV3EyH9B35FbElnzBC5v6JlA6ahueu+a3IKKo4pqBTrmumCyCvMGW3V9Ck4T2wxFCy4i
	vu+p+8Qf4A=
X-Received: by 2002:adf:e19d:0:b0:48b:11ee:de66 with SMTP id ffacd0b85a97d-48b1274c63amr9409397f8f.34.1791018922988;
        Sat, 03 Oct 2026 02:15:22 -0700 (PDT)
Received: from FranzSP11.fritz.box ([31.31.60.25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b82253dc9sm11336161f8f.3.2026.10.03.02.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 02:15:22 -0700 (PDT)
From: Franz <franzelfranzel@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Abel Vesa <abelvesa@kernel.org>,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/3] dt-bindings: net: wireless: qcom,ath12k: add disable-rfkill
Date: Sat,  3 Oct 2026 11:15:07 +0200
Message-ID: <20261003091509.4822-2-franzelfranzel@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261003091509.4822-1-franzelfranzel@gmail.com>
References: <20261003091509.4822-1-franzelfranzel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some boards do not wire the WCN7850 hardware rfkill input, or wire it so
that it always reads as "radio off". On the Microsoft Surface Pro 11
(X1E80100), ath12k enables hardware rfkill handling and the interface
ends up hard-blocked for good.

ACPI platforms can already turn this off through a firmware setting
that ath12k reads (ath12k_acpi_get_disable_rfkill()). Add a boolean
property so that DT-based boards can describe the same thing.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Franz <franzelfranzel@gmail.com>
---
 .../devicetree/bindings/net/wireless/qcom,ath12k.yaml      | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml
index dc68dd599..d56050e77 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml
@@ -27,6 +27,13 @@ properties:
       If present, a board or platform specific string used to lookup
       usecase-specific firmware files for the device.
 
+  disable-rfkill:
+    type: boolean
+    description:
+      The device's hardware rfkill input is not usable on this board (for
+      example, it is not wired and reads as "radio off"). The driver must
+      not enable hardware rfkill handling.
+
   vddaon-supply:
     description: VDD_AON supply regulator handle
 
-- 
2.56.0

