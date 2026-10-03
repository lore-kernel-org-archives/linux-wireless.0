Received: from mail-wr2-f33.google.com (mail-wr2-f33.google.com [74.125.225.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597DB3AFCFE
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 09:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791018945; cv=none; b=bqyz1rh4ivFh4IW7OaXYqPgpGx3x/cCCwL8opROnXJOyVFomVwKL5rTlLphVO7r4Ety3chfEATUiPYdvBUUHoUw/k+wo7VNFCXKNuVhXv5BknlX0t4LycukHTrcOHHx+g7riU3C8vThdhbh2Vhle9vZG8dZX8vhzz3FVWbHO1zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791018945; c=relaxed/simple;
	bh=5Amsj13Ypf+VNbZXqe2Aip4i68WKcfoJI3MkINWORYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rE4xI1W0CKPaIXzmOMHtslJDO/1AS5gxI5a37OHAphUsoeS7pZJMPp1ZKPVZBxibwGlm/9/9N2bBQ96jb1FwV3ldNRtuHkGbLuv+DJycIhB1DC8cPwyCFExygIB67Zn8lr/MhWKYfmhHsullMgZNHD4nD85rK2pfYvDKj/7Lc/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KuoQv8oS; arc=none smtp.client-ip=74.125.225.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KuoQv8oS"
Received: by mail-wr2-f33.google.com with SMTP id ffacd0b85a97d-48b104f6aa3so95876f8f.0
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 02:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791018941; x=1791623741; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EL7Wt7gCvxigatArl4vYdYfYVLxu4uqJTJstEATQ4Rk=;
        b=KuoQv8oSidVn5GsKfTxOq11yuq8ZhuV1nwJ00BuiMrqVHuHD1G4mWS6cvwiPJZptEO
         qzQTTAd5cFrF9MAjvoKNOZgS/K7TmSUfDhVbHrUnstp6T/Igou1ATf/lwUaEo+3SDbHa
         xcO1wuUr8NvjE/9MubWS0sVij+uXZMQt/WJW0IBfvJjgGZVSJYs2C90rnyGDA9GnDLU6
         o6aQKSZukNOsEP4cMqNUN3NSeu2+blA76zvg1NVhAnIadlgmgEiB3j+D5vDDX4VcdBYX
         5TmZC69xKbWzQlxIpHWhzn2cjifKY3oN1yXXaM23Iy/EOa0ii+XZ58duPNkfFCshk5r+
         sdpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791018941; x=1791623741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EL7Wt7gCvxigatArl4vYdYfYVLxu4uqJTJstEATQ4Rk=;
        b=pxeq+ejGEEJPQS946x6iUmqhxnDMY11D2f9oDZWs//AQXy64OFsryMYjvhKBIU1v4Q
         yv5jT6u5dxWrENUsr2mj39b1CzEB44yBrdUjf3N8ZG/VFNFPRi+JXdFxfk6aDucsnWbQ
         Egyp6lD7IrKzXKF//KgiWh6v0IAmTX0nczbGeRbUl3h8l9C2RXrWU2dQ8an628Hedg4C
         Pn14q5l/3ahtFhi/v1VXpI9xShzHgKcHsQUtvH8rXZOvj2MkGV9xAlCd1HrdmvrN9Int
         PKmw6Dt3ajOdAH8guK0bmFs1OQkx9smKWjNAohtHhhmugNDXYv9bbwjcYKJs4Dsd8GS6
         1MwQ==
X-Forwarded-Encrypted: i=1; AKwUvByCinoVSwz6Zr+zXIEbKeXKm3I9QjwCzwn9yztYvesir/rsiGMVUdl2NPGcgw20mbKAEmy0i3aVWGSIe7F1gg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJP8TNV5j7uxXG8soWrPAmnfUDDmKXQD2Y+aLnqaoCZ2W0ttvsK
	K7ijrvmBCib+Yc6aYNIvrh69WraMwuzLs1b8gBL89O+OHOqs/r3PT0qo
X-Gm-Gg: AYBFou16N5chdVbh6Q/KVFmEvaxm4eJJ2dCI3MlFkHHe1vtAi/DWk8wnCloq0/YUtuy
	VrlTVpo/pRCnKrrTLuhUECNVqWjCtKMP+PBO7AUs5Fyn6/VEWZd/eMQgQTwHtVNu7yr8MaUZ2pW
	nYBE3zZXXhCIsM+weEPeZ/ktmXIxf7Ehau/X+J+aQJCsjNr8mflgbaZw5rdUOwxLCm7YyISWqF+
	l2yJKCOX0BNCSbroPRM1QYrl20n08pQf8U0qfDyX8nkV3t7AGMcldGJ7PaRmIXbUjHMdtts3T2m
	Ug2AC7jrHN8Gv/8ehI+M9kPdFm4cTzoFIBjY4ZbUlNIsMQ3m0aX8j5kqr/zrfiJFm1TWelP6XEJ
	jN+uLQAoM+JKmJQsOBJ/YbniFk80344Ofq3k7SsFR11LK5cwns6xQgThWcAQG0DYoTzjcSQtHSw
	BgIsDuLNVd46/+Sfzbslc/vN/RY2TpGiZk26487F3AOvrSzRTW1dUq68qfIoctlkSf9LjNwyGQA
	3K43eVu1go=
X-Received: by 2002:a05:6000:2c0a:b0:48b:7179:59da with SMTP id ffacd0b85a97d-48b71795ad8mr8328190f8f.1.1791018941391;
        Sat, 03 Oct 2026 02:15:41 -0700 (PDT)
Received: from FranzSP11.fritz.box ([31.31.60.25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b82253dc9sm11336161f8f.3.2026.10.03.02.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 02:15:40 -0700 (PDT)
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
Subject: [PATCH RFC 3/3] arm64: dts: qcom: x1-microsoft-denali: disable WCN7850 hardware rfkill
Date: Sat,  3 Oct 2026 11:15:09 +0200
Message-ID: <20261003091509.4822-4-franzelfranzel@gmail.com>
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

The WCN7850 hardware rfkill input reads as "radio off" on the Surface
Pro 11, which keeps Wi-Fi hard-blocked. Mark it as unusable.

Tested by adding the property to the installed DTB with fdtput, on
next-20260929 with the matching ath12k change.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Franz <franzelfranzel@gmail.com>
---
 arch/arm64/boot/dts/qcom/x1-microsoft-denali.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1-microsoft-denali.dtsi b/arch/arm64/boot/dts/qcom/x1-microsoft-denali.dtsi
index a71c29762..36592b8ed 100644
--- a/arch/arm64/boot/dts/qcom/x1-microsoft-denali.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-microsoft-denali.dtsi
@@ -1009,6 +1009,8 @@ wifi@0 {
 		vddrfa1p8-supply = <&vreg_pmu_rfa_1p8>;
 		vddpcie0p9-supply = <&vreg_pmu_pcie_0p9>;
 		vddpcie1p8-supply = <&vreg_pmu_pcie_1p8>;
+
+		disable-rfkill;
 	};
 };
 
-- 
2.56.0

