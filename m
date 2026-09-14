Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2727847A872
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 14:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397711; cv=none; b=OmPhNQ1gA3dJuPRv5nBhA9ytg5t18fxwKhtHtnS9fy6arnf3UCdRMnWUJ9zI1pGoDKe5mI6QGqHCq2j43iK58NlvbZpgUFvVKp7etFCRPaDW10EnPxpraXwp2tiJKTyEPqz+0ylz1j9OCMRPaVnwhwgX5KhkKZSEdz5q8DdRkbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397711; c=relaxed/simple;
	bh=eYMKmu0TspLLrpI7Dq/rAwnjuVZWjXe2BfIsHDWlOMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDSKqev/s6WtI4bJFI59RYVj9sC9xMyNM/emD/oKWv34M5Eyf5YuAu4VeNSw7BWC/2HviMu3SVr2+J736wdwk3tByr4YCq9JTc21UDRj97Do92WsRGfEOzYsuMgBlDqIlVi5E2ocOplJu5U3TjL/o6wyo4DnT0MHxIXJrhBZAro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0I3EdtH; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0I3EdtH"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-869ac301739so2784007b3a.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 07:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789397709; x=1790002509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K40D55+QEw0tJrishTnnZFQc54eXC6WooG3rrnRojok=;
        b=g0I3EdtHJEOecnsphh05qTqrPZnm8t9vaNGW2qPUrPdtKmCV6z1pFyMmBq0MkpvWOH
         MjIoGj2HhKrijaRRRLrrC+YPw1ZKUBJsXIhuy/ZMKscTixDS0oYiPxKUKI/Cv/1c25PO
         sp89qp/hboCTlyLCL0xuUia6cvdoFqkkA33hdFQchL3BZwAeKzB1Wmv7D91b7vMIHk2X
         ZD7L9/6vkvqGFZQXOJabJBl5tfoKGQyMzAVgFX6C7+tN229Ai6dh8SWScdhsNLt+dsiL
         hgu6EWqmL70MRTmctMZg4qpOIkq8CidZkVqUJR1KkolcHA1/TjgrT9POn7pxTwaeQ6bL
         I1Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789397709; x=1790002509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K40D55+QEw0tJrishTnnZFQc54eXC6WooG3rrnRojok=;
        b=sm/gpqX3g6c6ZomK6vWLIy1vNbA8NwgkVGEijEjYdupXXgbFpTR70h3pHMo2KgHzVx
         empkzlnYl/CTHSFPH3nGVNM1WD4pat6dAye3tyP6cekF/Z7HOFDznPFB2RqUAWdE1eoI
         YhQOsSejfqowrrSW63HO1SeYPvTf5mVvlr/2p6ODAHDvkoq/iwCCsgxYHcezw4zcjzdz
         M19Op/Ttg8FdJ992tITpaZKaHz8rfnTh+02BvpQivsEuU7IHn5ZJKaIsuucCVCZHSorV
         jABpRg+26pFlz/QmzeYVTvN8vRRPMTAPFJ2/GBS5mGO5Mr0EfSV2ro6txaV7O9sDqLbg
         +r8w==
X-Gm-Message-State: AFuF++nfbg7XjU3r1lCc3aYQm8naHfJpj/SyQ7Yij0UZBG5CuKuhyS+d
	alWYiBNcnZzVirWl47iOnU+7vIutpsi7W9A3navb9HpJ/Lcz5ng8zTvJ
X-Gm-Gg: AYBFou0LeTKHdFgWLu8rmDIMdjee6Nr2eaOmh1rWgytcrv1lxc4sZmZn6OuwxG8vnkX
	Gk7cE/F4smzH47CPXBwZW16OiAyguJo3i05JmsEeiuG0iMylVYEvKnJ01NtpUmUkw/7zv+wkJ45
	Jj/x5dyCstPTjX+I2q+czEBDCtuobCTEGig57AxiuNoCIUJcjPHc2pvFzDnHK5OVs3hapTKcQ94
	+/gbAIJrzy3kIRqMubtMzV0PmcrTLaKjQVzM+mmNm+EXRO0zwYGP7bj/CdgGShsB54W7ruCDx1U
	85qoOX1pHmC4c18/Td+2BQz2fbOzQ4UuRp1/7LQnu6/DLW3IaFqKeuVJ3Kijhgn1R5SQKBovCv6
	+K6ZKsood6sdjj8zPVgfWyYmodfVaySwiRzojsjdCr9aFKxnQOwrcAEsv2R27lavFYNEy0Jkqnd
	9/Oqn0X6x1I0IpEHVuNedcIdNW/3S74yu78lELHL50s+NytfVUHhqkVZuf2yDA1RBbXGBrDQBxA
	N+7gS1/RSdPamqikZDZ5p3nexF3xeLj7DcIuc4=
X-Received: by 2002:a05:6a20:c88b:b0:3d1:c0e2:936b with SMTP id adf61e73a8af0-3db404269e1mr7176490637.7.1789397709022;
        Mon, 14 Sep 2026 07:55:09 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c615a65bsm5338805a12.3.2026.09.14.07.55.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 07:55:08 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/3] wifi: iwlwifi: mvm: defer freeing PTK PN state on key failure
Date: Mon, 14 Sep 2026 22:54:31 +0800
Message-ID: <20260914145433.42830-2-enderaoelyther@gmail.com>
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

Fixes: d066a530af8e ("wifi: iwlwifi: mvm: fix ptk_pn memory leak")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5bd246e37943..b0c4f245c88f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4385,7 +4385,7 @@ static int __iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 			key->hw_key_idx = STA_KEY_IDX_INVALID;
 			if (ptk_pn) {
 				RCU_INIT_POINTER(mvmsta->ptk_pn[keyidx], NULL);
-				kfree(ptk_pn);
+				kfree_rcu(ptk_pn, rcu_head);
 			}
 			/*
 			 * can't add key for RX, but we don't need it
-- 
2.55.0

