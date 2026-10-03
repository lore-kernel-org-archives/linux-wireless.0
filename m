Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50173B059C
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 09:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791018921; cv=none; b=MVriGs+DwrKRGITKIswiTpESb5oeYRCi+/9SpQQCaWaSsscb/MKKXMS3RBg0FILjIvhA/Kajp8YIplOLu75gcy0pRYYmyOazut2aBbJfSp9CtjsCOS5SDdmXI5YgLVtA7Vbpq0ppmxM6ue5omaL07Rtjh7h9KwAkQlR7V8/T1MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791018921; c=relaxed/simple;
	bh=7mIMzpWt7Kv6nfILtop51S8DtZZgj6RXsaVJr/LrYuM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PvfAOYkeiQlRibgJOhJr2bQrNmxQHCRILUxL4EyCjjMLE/JRpmdyAFi2+WJxREScTQObxoI/voPp1+M2SqbrYZSetso+nfSsNFZF87mq2DLQUPTM7qF5KjlLGWZHAru1Ut0opAKVSizTJ2BcBNNiCbhYnb5lDhRL9pkcuMEoQyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l/yAwybu; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l/yAwybu"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e79a408deso2683815e9.2
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 02:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791018917; x=1791623717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=L+D0wcMiZw7JqhFEXAX/EBPaHQLIVoMlrQj5WJPMGog=;
        b=l/yAwybuaFd8Usw2K5olMfjJmTthqbvLtGJZME8MUa6ndH/jY9pFcJoL4hj7nDh6/t
         sfZICwt2y+F5HqlK4JS3zBnKKfHoGUD7CQsVGhKQdYNu0gu5yvcYa1PI3zw8yuP9lglO
         ZwZd2TysCDZr66fi6T1kVbRpWO+sE+wUtJVrtCw7oiXmdx5y/BgwSInqxOuJYXcuwSTD
         7ym8iOBpm3rIVfErwnShz7HEfvJwS2hWeAQkzCcTHvwyetnvYF1ctuUYaRKlQa+u3l95
         jrWzmttgJIlfBj4ngtPWyWkd6TeFPxQ1JqDprIfX1jCt2XwItJ4hYBsCmbkLSStoZsMO
         ocAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791018917; x=1791623717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L+D0wcMiZw7JqhFEXAX/EBPaHQLIVoMlrQj5WJPMGog=;
        b=auHrJYrrv187/rzJYixk8ufOql3q/sxkufoV5RD5Y65OhLqe/Fx1Y5M9r/p/17NNRa
         a2YkRcPdaGcInZDAfOPgXLE9J04douT3gyDxczFEjHWThF5DRysMFHJCV5f3bYaGggxL
         iEHycPmIzUjyTwjMH5boMtBCRH3jP0B7IEY4KU0hK4+gs8pOyckA2QoQPrX7Z0BKnJLJ
         MwRY4KCM/iaNhdTk5XvadNavlcPW99PBf3ZfSslg9M3AG6xPNPxldeDNxBw+1lpNmph2
         Dj4Ij39nmJ+urvTUZccW1zoTyg03ojb2CB0oDQZMoTixg3I1f7taFcGkxfT/VcNUhGs4
         F6Ug==
X-Forwarded-Encrypted: i=1; AKwUvBz25OwSc4RXDiOyw0Db3VpjZVfP8X55vKk2nFf59X7xJj/JsBOtDwy+5rPGK2/sXGYJ1ncOgfxKdOkx4Go8+w==@vger.kernel.org
X-Gm-Message-State: AFuF++lwK852Tvjyh1Op8Ryl/Y+bpzO5cHTBgFS+uuBanwsFBzauAiFC
	HBo/PqBis9R9fC6CR7kP1z/KrNWFa40P+C0ihgUALWeV4nTFiEWftxB8
X-Gm-Gg: AYBFou1fF5TFreIEUSDXtHXU0Gp6t6F9FzOUzflfWYrBWFZ4zYmrQCu9Za8g3DfDzQX
	9CGib8PaiNJTEum2NR0Ru3x72qiquFzBW669aBAdlCKWbIGTYFRAp7BYE7zIT8nDBVBfrNN/GV1
	Xo+1bB4UHOCEFWVjP0zRHpHbROZqe25veT07Hgm8qtGPaQgTjdG9A9p3B0MoDUk0nAJTbJwAx86
	KANWNopo3Sitn9oSusQ76LeGsHwRHKDzcjMjlfTHU8Vi6dFKM8Ruv0ZTLRU3hPSzGUc5Jl14kFv
	CJ457uskX7+Vs6Itnjk9VRctZcZaVRHYe0exrMgjKdolPIrQmnog5pFxxso8VHwmYkdgSRDf6Dd
	U/F5TogsUlU2y/EGfkNSoEhjyKjtogTobJ01qkkJRG+YZBLGpiSrlgtVemmCAMkYM3ey1XJg47m
	IPL15c5uc9jrPVh29Xp6L+6LLD0DYmxE2brW3Gep4iNxD4CnQudsFBCKQXDxWcQiLcYBeKlzJ5Q
	jSFa6uWcr6T+1bNVzMSYg==
X-Received: by 2002:a05:600c:8710:b0:49f:ce73:5e96 with SMTP id 5b1f17b1804b1-4a02759555dmr75369925e9.34.1791018916839;
        Sat, 03 Oct 2026 02:15:16 -0700 (PDT)
Received: from FranzSP11.fritz.box ([31.31.60.25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b82253dc9sm11336161f8f.3.2026.10.03.02.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 02:15:16 -0700 (PDT)
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
Subject: [PATCH RFC 0/3] Allow DT boards to disable WCN7850 hardware rfkill
Date: Sat,  3 Oct 2026 11:15:06 +0200
Message-ID: <20261003091509.4822-1-franzelfranzel@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On the Microsoft Surface Pro 11 (X1E80100, board "denali"), the WCN7850
hardware rfkill input reads as "radio off". ath12k turns on hardware
rfkill handling, so Wi-Fi stays hard-blocked:

  iwd: Error bringing interface 4 up: Operation not possible due to RF-kill

ACPI platforms can already turn this off (ath12k_acpi_get_disable_rfkill()),
but DT-based boards have no way to. This series adds a boolean
"disable-rfkill" property to the ath12k binding, makes ath12k honour
it, and sets it on the Surface Pro 11. Out-of-tree Surface Pro 11
kernels already ship an equivalent change.

This is an RFC mainly because of the property itself. Is a generic
"disable-rfkill" acceptable, or would you prefer a vendor-prefixed
name, or a different way to describe a board whose rfkill line is not
usable?

Testing: next-20260929 on a Surface Pro 11, with the ath12k change and
the property added to the installed DTB with fdtput. The interface
comes up and connects (5 GHz, 160 MHz). The DTS change builds, and the
built DTB carries the property. dt_binding_check / dtbs_check were not
run, because dtschema is not installed here.

On this machine the endpoint is only enumerated with "power: sequencing:
qcom-wcn: power off WLAN at probe", sent separately as a fix for
b921aa3f8dec.

This series was prepared with the help of an AI coding assistant
(Claude): finding the cause, writing the code and the changelogs. I
reviewed it and tested it on the hardware.

Franz (3):
  dt-bindings: net: wireless: qcom,ath12k: add disable-rfkill
  wifi: ath12k: honour disable-rfkill from the device tree
  arm64: dts: qcom: x1-microsoft-denali: disable WCN7850 hardware rfkill

 .../devicetree/bindings/net/wireless/qcom,ath12k.yaml      | 7 +++++++
 arch/arm64/boot/dts/qcom/x1-microsoft-denali.dtsi          | 2 ++
 drivers/net/wireless/ath/ath12k/core.c                     | 3 +++
 3 files changed, 12 insertions(+)


base-commit: 6474fa070f2b8013b4b87350b775b8c3be6e8aac
prerequisite-patch-id: aafe3fac38f4020441979665509928f8cc832095
-- 
2.56.0

