Received: from mail-wr2-f33.google.com (mail-wr2-f33.google.com [74.125.225.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E1E3D093C
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 16:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791132701; cv=none; b=gZnbos1IwZ3QSFbdvyVGFuf3FPymLDSjfgyf1NvhwsB1lv4GTjyEOLmJZZ4lQPUezaEDyleG/SId1eFLoil2DEvBOHgGIWxmwkQhE+zbM4zStxW/qDtdiF/WPRe3wOzC87vRCeJqJXhWHPvJAsRl5epA9VIHukAr37C+NUVrW7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791132701; c=relaxed/simple;
	bh=cfsNm7503j44sOYlP5f+jD1LcOO+2TqY7kSRBWzmdDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Nez+bwHAzPbETvTXskDhJkYMeLULbI+Kh3UcVyT/6KJKotRJKGtwnAaMvLLPuvg5MW64GDf1Ox3ikXFf/0Tfny0ftl4Kn59XmGk7vm84N2obJ6GoxDoMKDmoY/09uHFXwEShwKPnV4bjjaTmFi/5wt8+sav+qwUDMksJ/nHMgN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CpBn55z3; arc=none smtp.client-ip=74.125.225.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CpBn55z3"
Received: by mail-wr2-f33.google.com with SMTP id ffacd0b85a97d-48b0fc598f8so543296f8f.2
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 09:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791132698; x=1791737498; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5kZgL2+cYaxBr/D7kAopy+ikvsQSWrTTQUGKjBNRtaQ=;
        b=CpBn55z3SHSdMsixLhW1sMmWFUXoihP2CetQQJt7dFV89Szsrt3fXgXzKMA5+VpHKz
         brFIN5MiDW3xUm1Z9rLIe7FSTOcfRRsIN5F0JzLM/xaCzsroGSpBuwjuQNBwRTZEkBZu
         9V97RXlhw96Z8W7Czo3XStbe7m5SwcjNPgURwge0BWc0Gayk51c9M+NBUX0ttFVwshyd
         uRN6zAckn6fGKdzrZgmvDGdLc8fph4qV6bS1jEaDMdhQNBmbFYzfcXcbPgprETNsoyQ9
         E8SfO4fpqPN70IFwe9cAtpkCuEZkGn4tCEMAAfYvBaXuNVeVa0W+fhG5oLzo/2NfLYkk
         yTVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791132698; x=1791737498;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5kZgL2+cYaxBr/D7kAopy+ikvsQSWrTTQUGKjBNRtaQ=;
        b=Q1wiLLtbMeZillkol1A8pKbWqsX7xm2sBK/riEoiiPOf9+9zRpdJ4c68VMuxMhQj+g
         /Ka0NWHUmEIyGBuBOBLseVDQ7i3N4/8JLPk+hY5Mxy6ZgSWTnMnpItQ94pqmztOPG3Pq
         6L8QnCrkSB8UI8pQ9l/QttYIqOTxKHWLXRzD76Wo68q4zlkwK4LxjYqlCxtSqFoiYyoW
         PrB1ROTDzcJtmx/s+/jMJZzzvEkWrmu9oHm4KaMeqq+jSX03FHPo0NOQPLxSDIGXvOwS
         fZLMfoOjubVIdKc9M7K7yGO6TEX8higiMuviehi4v91L/QtmY4LzjW1k6/RqbdgGntjj
         Ev4g==
X-Forwarded-Encrypted: i=1; AKwUvBwWW3S3n+iwvLRvVT5hIcx0ZdGlNINMYKpw1U8R2JO0wCzWU/D2PmRfrDTaiKiz7RmQv+TA8d9J1kpMcn0ggA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKWj2n+EKbznC4O/bqgV2hvCV1cIlDiPpcuAzYEZgQ5AmzNR8Dp
	kFNv458vfYhs5fWhB9upG+5K8LuqpCyWQopA19V1Iuw/47dVxWhpFkKH
X-Gm-Gg: AYBFou3Y/Msti4Qzjd3ruwjnzBpsuI5RLAxsZIbO8Kk1L0OfKPfQxWdRNwTVN8MYuuw
	0HqTvhbR7NGAlPuXoUPAjp63tqcofIvngtC2bXv2uykm1cK+YYnId1QVuVKcGBImBP60J8F7aan
	Nkqw7ZO0UuzNk3PeiYd/oxjbbOjIdLi9KPJIwFG2YQE/VcTw1WlnlsYD5Awr5Vn26x+9iQ/pGHW
	kiCZC+aP+DV36Y7ftjpzB6I16ZrhKthjPyMBqSUyLFrPImWTKNnn2a2IsQGvgYwoNY6VenkkMWL
	McvWY1jtxpgfSESHiOOT8gMfzhO48IpgTO6d9l6k9OQIZpBXpKQJ9S8A225ASnXF2hBStfDs8yw
	8DfWGfojVKp790IaRUJrQ6Wltqx5A6NOARiJyMqR7MIAKjWOfHQCwOBPyobQEf+4J0mg7cEnJ00
	smiwnE9uoYCLSbgapFRLdtnhlqyuYWx/OVo8/qhkSGHT1/ivF1o2sYTP/6tTTTW3VkAQbU66meK
	2qH9ADvAiae
X-Received: by 2002:a5d:5d13:0:b0:487:8b9:526a with SMTP id ffacd0b85a97d-48b12763357mr18047204f8f.36.1791132698112;
        Sun, 04 Oct 2026 09:51:38 -0700 (PDT)
Received: from FranzSP11.fritz.box ([31.31.60.25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b383065a4sm18144545f8f.44.2026.10.04.09.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 09:51:37 -0700 (PDT)
From: =?UTF-8?q?Fran=C3=A7ois=20Roux?= <franzelfranzel@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20de=20Bretagne?= <jerome.debretagne@gmail.com>,
	Dale Whinham <daleyo@gmail.com>,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath12k: skip hardware rfkill setup on Microsoft Surface Pro 11
Date: Sun,  4 Oct 2026 18:51:32 +0200
Message-ID: <20261004165132.4313-1-franzelfranzel@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On the Microsoft Surface Pro 11 (X1E80100, "microsoft,denali"), the
WCN7850 hardware rfkill input reads as "radio off" and the OS has no
way to control it. ath12k enables hardware rfkill handling, so Wi-Fi
stays hard-blocked:

  iwd: Error bringing interface 4 up: Operation not possible due to RF-kill

ACPI platforms can opt out through ath12k_acpi_get_disable_rfkill(),
but DT platforms cannot. A DT property was proposed for this and
rejected, because it describes what the OS should do rather than the
hardware. The suggested alternative was to handle this machine in the
driver, keyed on the board compatible and the device ID, until a
connector binding can describe a broken rfkill line. Do that.

Tested on a Surface Pro 11 with next-20260929, booted with the
unmodified mainline DTB: the interface is no longer blocked and
connects.

Link: https://lore.kernel.org/all/2ixwny6hzumlqmok5cjwutvtk7nzmx4t3dhxc44ao4l2u755pj@n6m7jyxf2o62/
Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
Assisted-by: LLM
Signed-off-by: François Roux <franzelfranzel@gmail.com>
---
This replaces my RFC series "Allow DT boards to disable WCN7850 hardware
rfkill", which duplicated the disable-rfkill DT property already proposed
and rejected in the Surface Pro 11 series:

https://lore.kernel.org/all/20261003091509.4822-1-franzelfranzel@gmail.com/
https://lore.kernel.org/all/20251220-surface-sp11-for-next-v5-2-16065bef8ef3@gmail.com/

The code is Manivannan's suggestion from that thread. Jérôme reported
there that the Surface Laptop 7 (microsoft,romulus13/15) has the same
problem. I left it out because I cannot test it.

 drivers/net/wireless/ath/ath12k/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 0c72948f3..dc41a2a7d 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -83,6 +83,16 @@ static int ath12k_core_rfkill_config(struct ath12k_base *ab)
 	if (ath12k_acpi_get_disable_rfkill(ab))
 		return 0;
 
+	/*
+	 * TODO: On the Microsoft Surface Pro 11, the OS cannot control the
+	 * WCN7850 hardware rfkill input, which reads as "radio off". Keep
+	 * hardware rfkill disabled there. Ideally this would come from the
+	 * connector node of the board DT, but that binding does not exist
+	 * yet, so handle it in the driver for now.
+	 */
+	if (of_machine_is_compatible("microsoft,denali") && ab->id.device == 0x1107)
+		return 0;
+
 	for (i = 0; i < ab->num_radios; i++) {
 		ar = ab->pdevs[i].ar;
 

base-commit: 6474fa070f2b8013b4b87350b775b8c3be6e8aac
prerequisite-patch-id: aafe3fac38f4020441979665509928f8cc832095
-- 
2.56.0

