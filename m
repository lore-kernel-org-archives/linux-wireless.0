Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22D43B05B8
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 09:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791018931; cv=none; b=lDuWIs/XFruyezJP6hk+ZOHdUNrp2NJ7EJTRafPopMRfbEiXNeqRxdbwwp4NM8jDuUESX/ZkRTSJj4I0uRXlbeDCuY7tFupVz6640Y0o6kZY4RJ9QrPl5qNEhuCySESGVIylSOnn7ckHS/yU/aDyoksjODU18N3g0lOkoxQCg5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791018931; c=relaxed/simple;
	bh=1VdfXtjk1IWiBRIjglsN7Ax9puUJ4ykuJi0WIKUi3zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS253bjpXJpYzc/NfCEtCfqHDct2xwbC00AuLvGvRGNdZdUwZLx5ezbMLz9XLdOAOMuX24g9gOkMeeJAQ+8TgVf9WOj7A5zXd0TudrvFIZ+Fibb25GaMkmuDageCxZaxsBbLwgO4wXqZnqu7qP5SgzFgoC0vV6IYzPbkzOAyEFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s6yDFug9; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s6yDFug9"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6351831so77650f8f.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 02:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791018928; x=1791623728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KGUcNzjtQXTGJm0X6jZGQPUmM1QBqOgA+Fbqqq48w68=;
        b=s6yDFug9JfWs/ngyyVwN6Z/ta4WVIvORd04zR8EKAguNpB2LlktDF7ZRPGc81ZbgN8
         dcJgLXw+mrpET46eFVIAcp2FlazD5ZO5edmub2mwmu5mdjSWYc2Mhe3DoCaOXMLUdH0w
         eKpXAWk7Tbb3VA92ULOM1ZIPtcTAk5UOWsF98ZUpBT4Nczsubp7QD9uBuKdD1rho5ZdM
         8+Iz8Ej70md1mqN9vU3Eov3At+JmXssNLBvj2cFZ57GSdJRoP5nLjaTNJgYuL8vP6nvN
         VInPE56aZLGkensHPWctVEvK0Xbv/rsswQia44risgjAe3YyVCsqX1/u/Vzhckdi5aEd
         XBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791018928; x=1791623728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KGUcNzjtQXTGJm0X6jZGQPUmM1QBqOgA+Fbqqq48w68=;
        b=lKrmbYB8EFccL8mPNjCNfFgumgMvc9O8DNbdtM1qrPtE6RKLOMlN1ODfUbmIb9Pj9C
         gvN6wwFcwXgCg17PsQMCBp9i7zDCKI+WUJQ7BvkRtaI8LEqyx04pRS3sLasMNgKakeQa
         i9Oi2njJfH68o6OP4UIyE7PlvzDK4dW7zMFruz8+Y9UP0nOY0i0MOgO0JxLKNsFuLIjk
         rOPF6j3s1I6lIY9iq1d80AWYa2aiTB+PQwBOzNo8p197g2RXvE0kYMDcz5hZIZwexW/v
         KAkYLhy5TRjClPfqNeeWe4rqenb8pLkBnqLkk1e27wa4vWwJY+9V7z1wo+COuM6OLojq
         qVPA==
X-Forwarded-Encrypted: i=1; AKwUvBxfuZyDYl5h/A/S0oCGk0TVPWOvwk8TMsfCQm9KIXed3gCor6czxRzxDcNxIlSMPwmQB44Qoj566RPkicRrQg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKbfTPzOW+B/21D57hLA0ltZRpMReA1GeHJgTF3CHKytapoh9Y/
	UwE9OFV17QMCe61UMsIYA5ATLFN2TznZenNuHHXUJ1G9mz2IgMji3A9D
X-Gm-Gg: AYBFou25jarVf9a44f8p1AJU9dVhLMAIzGxCGnDyls0Xgk/OBQO/CBxByb4+K7OGCyt
	NuDBkC0MvhIHLTZ7nszkxTtJ2LEm+fpU8vy7or81uQvrFa/8JpL3kD7YJGPy1KSA0SBlDsIV+8Q
	l6OUN6bLhOb0SeBFTYlEQcI18UlRgd3Xd+3owVsbVkxx7ekjacqU5nzcHOvnT9K1nt+ufLvSMXY
	lBbz+WqBwaBqv1bIT8NEPYXau3/rEhVihXN0irTDe+NFAkda1ic155Du0dmzBmgCFZ/bYUtwmYH
	qq9TeIDkclghG0Y+F+tufMEiR8SUgm37SA5a1PbtEiX4UlOBqQnovbvIcX+cBz7r7evwFQqyz2a
	rA7+IgX5hmkjR0GZ8vy+QCwcAo8SxyWtSIgmIkI9q6uYUv4JgS4NtJxgJ5z9Y33xKdEmLZFeNGh
	bLs1sTvxe2HxhowcAH5VRd0yxoWsJMLlMDvt76Mz4WdP+J19qKXIxKT1266hWsVLTSXdN7IMMnD
	c548iB7Vj4=
X-Received: by 2002:a05:6000:26c8:b0:487:35c:6513 with SMTP id ffacd0b85a97d-48b12720148mr9951532f8f.42.1791018928132;
        Sat, 03 Oct 2026 02:15:28 -0700 (PDT)
Received: from FranzSP11.fritz.box ([31.31.60.25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b82253dc9sm11336161f8f.3.2026.10.03.02.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 02:15:27 -0700 (PDT)
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
Subject: [PATCH RFC 2/3] wifi: ath12k: honour disable-rfkill from the device tree
Date: Sat,  3 Oct 2026 11:15:08 +0200
Message-ID: <20261003091509.4822-3-franzelfranzel@gmail.com>
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

ath12k_core_rfkill_config() skips the hardware rfkill setup only when
ACPI says so. DT-based boards have no equivalent. On the Microsoft
Surface Pro 11 (X1E80100), the WCN7850 rfkill input reads as "radio
off", so the interface is hard-blocked:

  iwd: Error bringing interface 4 up: Operation not possible due to RF-kill

Also skip the setup when the device's DT node has "disable-rfkill". The
PCI core attaches the node to the pci_dev, so ab->dev->of_node sees it.

Tested on a Surface Pro 11 with next-20260929 and the matching DT
change: the interface comes up and connects (5 GHz, 160 MHz).

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Franz <franzelfranzel@gmail.com>
---
 drivers/net/wireless/ath/ath12k/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 0c72948f3..8cac84917 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -83,6 +83,9 @@ static int ath12k_core_rfkill_config(struct ath12k_base *ab)
 	if (ath12k_acpi_get_disable_rfkill(ab))
 		return 0;
 
+	if (of_property_read_bool(ab->dev->of_node, "disable-rfkill"))
+		return 0;
+
 	for (i = 0; i < ab->num_radios; i++) {
 		ar = ab->pdevs[i].ar;
 
-- 
2.56.0

