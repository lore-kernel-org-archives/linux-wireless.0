Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F70397E8A
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 17:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787420584; cv=none; b=oKCsbPNANudXzb+FJi/usfJl1SSdcF9NM0MBF6aSXBSHIcsB3SsDCNGFgt6fNv5ykgCoBO3+b/jSxLup/OmUv8CUNvdcoK0dhQcLhGcNFSRfdeMjH0OuZ4DWkbTnHTXAmpy1SqpSFhSyu8ZstiwfQo53BWt2l84ae6uOj5xn9MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787420584; c=relaxed/simple;
	bh=XaVXBkdgo5uChRXSHUQE+f90wx/pjzdm+aFfLX5wVO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEOugvUvuplpQ61DFW/mF/xeHMFAJO7nZjvoT0BPckavZFa8N65dgX26sydcfIICgqQTTkcFiRw3wtfgXmkXuh10JwVfvIh9kdqoOJ0uOcjV/dU5a3Lv2IQdr0z3NCBEVX0z8luImHC9yFFIWhPr8OIZiEreYAxiFRKgR+HuFYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ol0V56pR; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ol0V56pR"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a378f90555so3549652a12.3
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 10:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787420579; x=1788025379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KrbyE4aDt+HTCYrFhwWg7uCyuM3HPm006rl8AqvEDns=;
        b=Ol0V56pRdMKha3+ZP+v1PnzG1Cg8qHUoNzPtYMRnZN6mG0xIwgNv3LHtpaBSm2IKdh
         guqEjAXEewqcijCl8fvw0uFj94CnIEWkgwe0eXXszb6z/uxwLmC+RcVqmD3rhkSvaZsp
         vHbRgji0oz/GAYb/MfK1aflEX9oqHYK65ENhvhAY2AVIfdKnGSDrrJ01NoOaHMFoE/67
         +Qvnt3ctyJ3WTCn4X+7BZR/ARFFIAba4WcVn9vKeYo/VbSlpZ9kuKrDOJqxu9PsON0mU
         gShlOTLx/4NosXRpkBScf9xui1bUxgfQsFz5UjEKbvPJiCKILIvVgtUn8z/7jaamqHO8
         nN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787420579; x=1788025379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KrbyE4aDt+HTCYrFhwWg7uCyuM3HPm006rl8AqvEDns=;
        b=CMySkmAnUp6NtAzrphh00Uc/kraOKBKMthbqeSsu+9c14t3YuoksFyQCVNXq4+gcgq
         vufX9S1fvp3HvH8DahF8DtwpOn48TXJyg3KICfZGPUmYTuQ+BqqGPYMlvvrA4oJfSW5D
         eKVKJWtOCnMn9TE1yAc3hIUDUpRAezTjpHHUpzkNUXGjuagvXKlXas96ZWpSBUOd04Lu
         TNY5ECiNUsIACBVyrdNKRW4QHKAzfn3GBIl3Ij7UaEgpZ+OBFKvpgMo0+LXuV2eN9CQi
         TTD0M2sHO2vXMb7i7B2eez/ix3i06nntlIliqfrfOzSjlf7fgvbGexnJtQ57NJk88yO5
         vrqg==
X-Gm-Message-State: AFuF++nk+oalQi8zx6nJZlLC9FMN9QEHTp3z6Je4VswxmCgdPeAhHW6p
	8cRe13vxU6zIV1BXcqTSOIL/ZkasYJxyr8ImHD5dUtbmIkU1yWnKFmRko+1Yo3q4
X-Gm-Gg: AR+sD10ck6Ycro65tyID2P0JgqIiG/JqxOjAdcGjOQkp6MDK/ReLPBJo3+yPCT6BA5K
	8PZkieXuKVLHaS2aOCbhELkxglD8u5fUtZrwwDt/v8xl5ZHNT69F+5giPISuCpnUiCpP+OWcedS
	1keDJmGKra36jdOgHW/Bmrk6LCLxDjLLPKa67RdxEBIVA6i7bHD83Clbdq3GUpXQlMWYap2awXo
	uB9njSV7KCiihPsTkEAAWE7GhALlL2GRQWer4e/+6+rw9eIsQYODLfdeXPdr/8LPqrw971D0IY7
	spP9ReD9redEXgMGqDEx+66XcsDA/goeMmXi7P6Ks3Zf2kKXnhogLLQvWNudF6ES3KBieaO57SV
	dMnuoGbamqIJ1K8jFi/NeUVSSrhQKUnUqYMhidZad/Ywk/kDvN019SiSY9qQ8MjEpQanqvj/O//
	8mE5pHQv2D827Rrc9SCYgv0vLwRMy3wViWt5++1Gxdxj3zyCfaFgd2Bf1K7s7ElU1jS2AH2gMAq
	JqyCZcIUV0jMQTXx32nbJF8MjFXfLWLEjr+oIk=
X-Received: by 2002:a17:907:6094:b0:c1f:9c3b:96a7 with SMTP id a640c23a62f3a-c246a6269d2mr1569284166b.17.1787420579410;
        Sat, 22 Aug 2026 10:42:59 -0700 (PDT)
Received: from lenovocachyos.home (c83-251-3-7.bredband.tele2.se. [83.251.3.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249689fa97sm334367466b.57.2026.08.22.10.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 10:42:58 -0700 (PDT)
From: andres parra <andres.parrab@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: andres parra <andres.parrab@gmail.com>
Subject: [RFC PATCH 4/4] wifi: rtw89: raise RTW89_MAX_INTERFACE_NUM to 3 for P2P-Device concurrency
Date: Sat, 22 Aug 2026 19:42:29 +0200
Message-ID: <20260822174229.65643-5-andres.parrab@gmail.com>
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

Live-tested last night: a real GO negotiation against an actual TV
succeeded (P2P-GO-NEG-SUCCESS), but forming the actual data connection
failed with P2P-GROUP-FORMATION-FAILURE while the laptop stayed
connected to its normal STA WiFi -- completing the cast needs three
concurrent interfaces (STA + P2P-Device + the new P2P-Client group
link), and RTW89_MAX_INTERFACE_NUM was deliberately left at 2 in the
v1 design.

Traced whether raising this strains the driver's separate,
firmware-capability-tied MCC (Multi-Channel-Concurrent) role limit,
NUM_OF_RTW89_MCC_ROLES (= 2, unrelated to this constant, chan.h:51):
it does not. rtw89_entity_mgnt's active_roles[]/chanctx_tbl[][] arrays
(sized by RTW89_MAX_INTERFACE_NUM) are only populated for links with
chanctx_assigned == true, which is set in exactly one place --
rtw89_chanctx_ops_assign_vif(), the assign_vif_chanctx driver op --
and a P2P-Device vif's remain_on_channel is dispatched straight to the
driver's native ROC op, bypassing assign_vif_chanctx entirely (already
established: this only applies to emulate_chanctx-less drivers, which
this chip is not). So a P2P-Device link's chanctx_assigned stays false
for its whole lifetime and never occupies an MCC-role slot -- in the
real STA+P2P-Device+P2P-Client scenario, only STA and the P2P-Client
link ever get a real chanctx assignment, exactly matching
NUM_OF_RTW89_MCC_ROLES = 2, unchanged and unstrained.

The actual P2P-GROUP-FORMATION-FAILURE originates purely at the
mac80211/cfg80211 layer (ieee80211_check_combinations(), a plain
interface-count check against wiphy->iface_combinations[].max_interfaces,
itself set from this constant) -- this one-line change is the complete
fix for that. rtw89_iface_combs[]'s max_interfaces fields and
rtw89_entity_mgnt's array sizes already reference the macro
symbolically, so both grow automatically with no separate edit.
static_assert(RTW89_MAX_INTERFACE_NUM >= NUM_OF_RTW89_MCC_ROLES) still
holds (3 >= 2). Full research trail in this project's BUILD_LOG.md.

Signed-off-by: andres parra <andres.parrab@gmail.com>
---
 core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/core.h b/core.h
index 2b21d96..83675f0 100644
--- a/core.h
+++ b/core.h
@@ -6340,7 +6340,7 @@ enum rtw89_entity_mode {
 	RTW89_ENTITY_MODE_UNHANDLED = -ESRCH,
 };
 
-#define RTW89_MAX_INTERFACE_NUM 2
+#define RTW89_MAX_INTERFACE_NUM 3
 
 /* only valid when running with chanctx_ops */
 struct rtw89_entity_mgnt {
-- 
2.55.0

