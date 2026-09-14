Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2533481AB5
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397715; cv=none; b=H1DC+xm6G7qhcHztybU5FZEatn67tGeyvQm4bUW4IzgoeF9DU8cXHEkb6eQmsTUo5FsZyoTftHbRZ1za/0trTBq381vdJk4LUghnsAgvKs+hb/rAa+1XXw3Qr4yyw9azFnDGfkU6r4Ecveef+iWIXlLgeqW/2wWALoFGXj4ihzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397715; c=relaxed/simple;
	bh=7RPJv7BhuOaAk+Mo0IOhmSNSIZQ5l94dLDpG1fs2pa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8QFzxTjatb6SbfdceSfEpn28F34Lod/Pqr1qWGsbUnA/swnjODoXSpgfboI3LjAGl2rhzyHnO3Urf+sgUvh5hNQYgcn7LsRE05LFJWAIoMkk2KjGLID1W2LGTtXxU1U2tAu4cao9O2i18Nb56Z53FGO+Ijr52QRgITjZfIM7EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V5k7ZkI1; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V5k7ZkI1"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cebad4afso2065816a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 07:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789397713; x=1790002513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mmvklgvi0ef/+u5dzaWwSRR1qwVq3sDKvk1AzDRlDKI=;
        b=V5k7ZkI1exdUJwB0QQ1Mamh3QBtnjzpKGTJWi1tE8mRHrgf/KWYsJLBixMnJrWNjZT
         Ewa3m5PzP4hbPv06vOMq8W40FPR7j79Dy5gZS1VBshz7PLzuGIn+OgEGVwRHeO3G6SDe
         edAYhvqxbrsQXK5huw9QNASL/kmuYBRovLFoeEDVG4fjwtpYV+jtnJUExz8uFWT6RM3/
         B3BC3R5WH1jlDteHRv4l8lOT97RQ4xopf4OJD2zOWNBEkn2UR2jnH9X3K0Z3QnJnEsz9
         4pKCFbyWx9EaNaKgXdguJHVYLFjJVAMihpJodGgHipRp+tC6NGuYSfpNGofuDT6XSuIe
         Z0Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789397713; x=1790002513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mmvklgvi0ef/+u5dzaWwSRR1qwVq3sDKvk1AzDRlDKI=;
        b=hH7wspsQtY13OwzN/7gZp0LdIGGDawW9w8RZk9sbCsxY4wo5wLB/rMCBgVHRLFzXoN
         OF/wUy86fdUkotcVB7xwv5WHUrZyqjHUJ1HX7h65Y5lGNqVvO1B23fK7mMUZG7ZqXGh+
         XD9q6BBQpVuSM1rzxF9ONUrFBxErkIWTn/SQOFPaHetoNkyC+P+Z2KlJTqjPRRbZ1YkJ
         4b5AFpII1k5v+2NQdeR53vLaLnsu1mu97l5RDE8ds25PVIwUlDh9sMqAvzbZ7+2jmu9a
         bMYY2/qT5Tf+OpawSEywmSsc2jI8vTHfI4Qh0Lo02SpmMED9yAljiRn3PJ0FYeAKLLLK
         WRnQ==
X-Gm-Message-State: AFuF++m7OJ5ge7WBHvS+uN/+JHiFijhppTOTBi4mqh4Ek9SKC3dvcc6p
	ccPOr1D3KjaxKVteQ3BBXgRo8yclnst8CiYvtT5bjzYQUosrV8VaqvmIxtaDpLNs
X-Gm-Gg: AYBFou0MErFxMIjCBahfEY2dPAXwpZ37RDid007mfbqHiSdZDRAi20TvPYy94kWAbyY
	Tg/0pK3WcpHacqRoz4N/SDXG1E06b4kgL3r6A5e1JTf/v5hc3sJw++XoaXVdT9KLSZNHiUScCxT
	F8n8xES3HQfAisjompaau4JHHCrsJgsrHrjYqi93gSgwPo8dHBNEyLEpkN13+NE3cKWSCjbvQAk
	SvZiPAMxjDzTMf4k5jWTqVZeR0dCDROFvYKYrA1XlQGNmaPWOE/8ZF+4/Cz1NPf0HYCg0/St6/d
	+smg5ndR7YRE2XA6ZhS+xfK/TaQwD0Wxz6+mc7irVl5SH0sc/riUa/2J+kdwxBACXT76P2pjlWD
	a9uUqrAoT/Gv/wV1VSFA5O6O2o2UOfXaeoCwkgKHPeMhvCBBTXlcJBjDhOuB03IxCqSaVCQt6Pz
	Z9OZXKqILqIiQ24X252O6C4CPK3R9y25U5iNeORVU0YX1vbtPmEUQXLG+UNsMu8CgS0ZuzpD7PE
	C46PY4PSu05Roi65MmmgzxVgq9hGKDJay+ig6U=
X-Received: by 2002:a05:6a20:a105:b0:3d0:ba81:79b9 with SMTP id adf61e73a8af0-3db4052bebcmr5751503637.12.1789397712639;
        Mon, 14 Sep 2026 07:55:12 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c615a65bsm5338805a12.3.2026.09.14.07.55.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 07:55:12 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/3] wifi: iwlwifi: mld: defer freeing PTK PN state on key failure
Date: Mon, 14 Sep 2026 22:54:32 +0800
Message-ID: <20260914145433.42830-3-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914145433.42830-1-enderaoelyther@gmail.com>
References: <20260914145433.42830-1-enderaoelyther@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The PTK packet-number state is published to RCU readers before the key is
installed in firmware.

If firmware rejects the key, the error path clears the pointer and
immediately frees the state while an RX reader may still hold it.

Defer the free until after an RCU grace period, matching the normal key
removal path.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 3a4c8fda68d0..693f2092a781 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2265,7 +2265,7 @@ static int iwl_mld_set_key_add(struct iwl_mld *mld,
 	if (ret) {
 		if (ptk_pn) {
 			RCU_INIT_POINTER(mld_sta->ptk_pn[keyidx], NULL);
-			kfree(ptk_pn);
+			kfree_rcu(ptk_pn, rcu_head);
 		}
 
 		return -EOPNOTSUPP;
-- 
2.55.0

