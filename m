Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5BB3C5546
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 17:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787420576; cv=none; b=MbbOnyyUfWOPYLbkBAwyqZnKtoJqNU5A3ivoIYFn1IqxLE46Vt/AE8NVTr5ypbPgmOsqBrDlgh1audGsP3eNA+gGm0xBSUHr1KOScmJPGPdhx492urlq3lYht9kUA6rga1a6/c39Ip799cUcpPuiNOUK4zgTDBL1YyGKKlmqESI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787420576; c=relaxed/simple;
	bh=adjed2Hy4DEWGBtuktuo8EK9T6T5WjSo9jJFAMK+vbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrU/Rx8cF3TEwTRm3o8Ext9Zzs1mBcn2PRFKVbvd0DngCfehe/TFebIDf7PZapRgeGO/shm38YETH/s+IEkC4/DHYs/ovwWnFvbgC2eL9+6zhQfROWTW+8QJMn8b0rJlNYMM8MNYzI+kNCkddob8ASNLJ8VzKbNqmPv8KUqrWYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EN1wfLlA; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EN1wfLlA"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15e592da74so297193266b.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 10:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787420572; x=1788025372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iQs/duy1Io4jPyKW0CDz51PrPyrvQNfaFvdSBwJs7/0=;
        b=EN1wfLlA57kfZySqiIdD2YKzBfgV0Jvdw8+Sj61rZBNSRx8IgqPiMqruILY7VjFnF/
         iGrnzXu3vbmvV5RskyUlgznLKaali3sEdnDsKZ++4ItzG3okDzgpGaVxWlNAkLZENoU3
         Sa9o757aY8adAkemGWO40TkI0+hrznpAnqxA6rW3AeO41dPMw5/OG9xLFtBNGmy6hEPE
         ChauP3e2ho/ZFwkoTpZArjWruDSsVv6wBrcjGcq48TQdNyIks55oJ5US0UpmDn6JzNtL
         X24mfiQ02zSVasAiT9uH+hP5UQCDOSNSCTyRnjbeZO5vpuNcbvnFPzvLZo+X4vYzoJJK
         iZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787420572; x=1788025372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iQs/duy1Io4jPyKW0CDz51PrPyrvQNfaFvdSBwJs7/0=;
        b=Vm5Ms7xM9RnuVUZRX7kcnQBOyZFBj7yz2BqykFkbUMMXyYqr6fY3R5gxTZevQ/l8MK
         1rWmAlR1RODDQGs0of91CBSKRblwzKmvRRqasUhtHULpyDf1UAWze6F6SfMtAZ89EfXT
         hyRvN+/CRXFKiAYgFADGPc+pDgyTB872XW/B24i4qXotIEEkIXiQ2rW28R5TGr2hOns7
         5YbHZxZFrM4WhY7reoVUQ1mACxddkAVpRrVHAAwNIL9fTWW/vaXmqsMyshbcd30X73bo
         ISalw9UBv63oxzkHLMx6Szqic65fEPuJPwxIqQZ2RouEcWnwZKODFQOZJm/tf04+e/z9
         AJmA==
X-Gm-Message-State: AFuF++nS1om4WtRSuxFF+zZF2Cg6edm/R59HcQvemB1uC0VnVKMWh5eh
	5pS9A0igw5CjMPntE1RD46SUi4Cv/UANtVC9n2qPoSd5HI9VE98zQ1NG3k9QhdYa
X-Gm-Gg: AR+sD13BifZQ8eMaLZ4bXH3YoZOLfkxl72qEcK7AqrBPht7PyG311C1BPJHBFcaWQHq
	vYvhC7KR8IVAzxawlOqz2lalGjlqjH/tPvNmStfOCI0Fl5W/qFcJnb5Jhb8/i3lx58uTG6dhZAv
	AVzBeZ4vzJug3wU6NHpY3b/gOFKt/LwrL0VG1uj3V/YvHPfQIo5Ud2BuWvEl6K0U7UjDWlKuvX7
	WG4W22Dh9D454ks+fwbhvwloS7voLyXrcZXx9rmF9hiNHu71t9LWbi/046EuRL191KI8K6jfQ8Z
	Fu5X/l6JXfIuOtro3dft2ZgjMoj+IwB07m+uJqljPV0mOP+gbOulxV/+wMKkE5lRSbCYWSKLf+n
	+creP/g43YOn43i4N3uQtldY/TXzEv/HivmpDebBdOefJZLAizQ26ixdHAOWfD//CfpSiGkLDzX
	TUSztYKhkq2qRfkudC1Iu/gHCS3KVva34RtAXoDq3zLG8REkOmP20Np7qS1QxpZPKdm1yCK8xwq
	wKaOSNhUc6/UX56XlIkJ0a4IGoGvK+syQtNvl4=
X-Received: by 2002:a17:906:9c93:b0:c24:6687:bf6a with SMTP id a640c23a62f3a-c2492663ee3mr725551666b.21.1787420571964;
        Sat, 22 Aug 2026 10:42:51 -0700 (PDT)
Received: from lenovocachyos.home (c83-251-3-7.bredband.tele2.se. [83.251.3.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249689fa97sm334367466b.57.2026.08.22.10.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 10:42:51 -0700 (PDT)
From: andres parra <andres.parrab@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: andres parra <andres.parrab@gmail.com>
Subject: [RFC PATCH 1/4] wifi: rtw89: declare P2P_DEVICE in interface modes/combinations
Date: Sat, 22 Aug 2026 19:42:26 +0200
Message-ID: <20260822174229.65643-2-andres.parrab@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260822174229.65643-1-andres.parrab@gmail.com>
References: <20260822174229.65643-1-andres.parrab@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add BIT(NL80211_IFTYPE_P2P_DEVICE) to hw->wiphy->interface_modes, and a
dedicated { .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) } limit
entry to both rtw89_iface_limits[] and rtw89_iface_limits_mcc[],
mirroring how mt792x (mt7921/7922/7925) scopes the same interface type
in its own iface_limit tables rather than merging it into the existing
AP/P2P_CLIENT/P2P_GO bucket.

RTW89_MAX_INTERFACE_NUM (2) is left untouched: it also sizes
rtw89_entity_mgnt's active_roles[]/chanctx_tbl[][] arrays, a real
firmware-resource-tracking constraint, not just a wiphy-advertised
limit. This keeps the new P2P-Device bucket within the existing cap
(e.g. STATION + P2P-Device concurrently), and explicitly defers full
3-way concurrency (STATION + P2P-Client/GO + P2P-Device at once) to a
later change, rather than growing those tracking arrays speculatively.

This commit is purely declarative: no code path creates a P2P-Device
vif yet, so no runtime behavior change is expected for any existing
interface type. Part 1 of 2 for NL80211_IFTYPE_P2P_DEVICE support;
see rtw89-p2p-device-project's PLAN.md/BUILD_LOG.md for the full
research and design behind this change.

Signed-off-by: andres parra <andres.parrab@gmail.com>
---
 core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/core.c b/core.c
index 397ebbf..5cf29bf 100644
--- a/core.c
+++ b/core.c
@@ -176,6 +176,10 @@ static const struct ieee80211_iface_limit rtw89_iface_limits[] = {
 			 BIT(NL80211_IFTYPE_P2P_GO) |
 			 BIT(NL80211_IFTYPE_AP),
 	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_DEVICE),
+	},
 };
 
 static const struct ieee80211_iface_limit rtw89_iface_limits_mcc[] = {
@@ -188,6 +192,10 @@ static const struct ieee80211_iface_limit rtw89_iface_limits_mcc[] = {
 		.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			 BIT(NL80211_IFTYPE_P2P_GO),
 	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_DEVICE),
+	},
 };
 
 static const struct ieee80211_iface_combination rtw89_iface_combs[] = {
@@ -7517,7 +7525,8 @@ static int rtw89_core_register_hw(struct rtw89_dev *rtwdev)
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				     BIT(NL80211_IFTYPE_AP) |
 				     BIT(NL80211_IFTYPE_P2P_CLIENT) |
-				     BIT(NL80211_IFTYPE_P2P_GO);
+				     BIT(NL80211_IFTYPE_P2P_GO) |
+				     BIT(NL80211_IFTYPE_P2P_DEVICE);
 
 	if (hal->ant_diversity) {
 		hw->wiphy->available_antennas_tx = 0x3;
-- 
2.55.0

