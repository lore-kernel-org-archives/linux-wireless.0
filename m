Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441DC38B7C3
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 12:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784722367; cv=none; b=dwBM4CGqtpJi/M8bNIpVmzmB/+EKythLLsGb50LH0uHDE0GlkJr4g1zXmEr9cc6V160HzP0FGHMGzjoI3mdV6DVSnbFo9t9jx/Lh4CNVsHyuwkGWCh6Iju4RJNfsLtcwpci4q72wlvSRsGaxiOX+9/cSW5C4Ck0ESTwLhJKzfNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784722367; c=relaxed/simple;
	bh=79j7NnDjv0QihjdfhzUpWvNFrgM+H6kwI0tyHE/S/UI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oRnSAtfRXoD0KGaQZ3L09uDpqyMRsYWQkf75Mrtwj6/471VxQ2isULUwFropngay13slpAyUmagKRZcADYAf5149s8kAHlaGtAYY4G54HHmldiLb4keFjOu61rldlAYPKEU0y8Subt5viklHBB3H4BxSdnKTs/X/BO59Me5/CU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=SlGU3Cqk; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="SlGU3Cqk"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8453427d3f4so11646041b3a.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 05:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1784722364; x=1785327164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fHYM3ypwNgSEsVx6UcghJ4+KBn7vHb7BLLcIj3NJUsk=;
        b=SlGU3CqksJg3LxVsi+nxHv8sxnQpEwiv9+Y5xp4ofUPM+SjmiXbhzdEN3eoOlJ+5M8
         guUcnA8ztpiPUrn1CVvkDGnZQj4VDuyhOcPLobRSDprOrrij0lMet5u5AHyEsSmuMAZr
         otrAr0560Sr3IcJUkd6qZ4zibcZ1vDHRXmThKdVRIbNwSBc+WrUC3MgEK/PeSVyPBrhm
         E6A0qp2j6I7GrZjO1VD4GNJd6v3wr6500klIVLgcE4p2W+InyqXXFz1kwH6gawIuNcxC
         k4bNpcSxe+melEFNfo3QBpYewkVuPCp7H3Ib9b8XCluDgMxyRpN42AzqO+y+Rk1cBHu3
         c9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784722364; x=1785327164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fHYM3ypwNgSEsVx6UcghJ4+KBn7vHb7BLLcIj3NJUsk=;
        b=ZF0LT/vzMbNyAJ1/ycjQllLqxCu8vQVyQSc2oxQJBNW+Dx7BooAHtpxCd0drk6RwWC
         jXjXo1viMOiRolzJw8ReObzbEjJQ/NGAoD5rYNIphAlh6GEB+8Y4PfhRE/iUGd8cbS7y
         yMOOu5AnBtPUKLc+UCyKd12PZToY68/KktlKjNAOALTh6Lpeh3Y2xlXt7BhH9liZJKzm
         5LIcFVbGfYl6+B5RryaM5ftupZDXd+yymF9GkfFb3Tn6k4QJwXc100IyolRU0UE3nnjp
         c2npitnSRZ4fvEYGbRSNI306+9ziV8mi7cfINkyJp1N0EoMEgGx63aQPu9ltMDoF5OBJ
         mAvQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr4XJUp9SlsJMv3yIy+dTwd6GwEXzKXpl5WZJSRnW1Gj176bcAO5ekLMf7wTlyPY08ndDHWx7qJDrncjow0iw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxeSJhtdUF+XpdOCopK1xC6cWnQc8rLcql7wNDQi1sR4KY6kLRB
	AipzNHSbq4rzEVxhPXo6P/t71LjIwnM5kBYxV+Y4k1ljlEG+0vZRu5ee1RzqjGNEfUnubN1dHq6
	CHTZCccnZsg==
X-Gm-Gg: AR+sD11JOAmDmAI6r8M3HNudxu6cIeQkQFxfWqPoXbZf6lktQb96Whflf3/eshbSYSR
	TG7zjAGDzaraNdbtiW+tD0gcXTpHGNxKWU5kKeOdWg/LxtFTBFn0OA2FON3jSoARhUTJD+Q/zf1
	eT7XJ38tbCVW9jWcEcM0fU2BJxn/sCgR4RtQUnrFfDrQRTi5ME6wF3rRzB7E2CTlLYg9MRx/QrV
	yhV0PB+EBfyO0m0V/xYf9mRzj5f37AiANWfPSwMu1+YPmshe7m32vsmm2G0DgEQhzBBUETNCtqe
	gFIvd5VyrOpCiFWnh94IL3x/9yZ77ep6O6GI0rSaW68ufZcNBexrtF1ZRyxUqNWNTZqpTGLcMpH
	6GyXE+Y7XI6PYD0sjeC8F6JZASM6FgQ6ujLBYRdXkd90fAvRNFYPqmFbUXF4OrQ+U15ufBdF6fP
	Uddo5y4pP/gjMy7zW8RjkRrNqlynv0qfXXrMg2YFvPk2uOr4ZhzOnx4IslbwFN2BtaETpJ9nEuw
	KszLm+5U+nhkJV4o9O3RX3Ote8mIhSS8kGO64uEs1w=
X-Received: by 2002:a05:6a00:a10:b0:847:926c:582c with SMTP id d2e1a72fcca58-84c292bc6aemr24736309b3a.29.1784722363558;
        Wed, 22 Jul 2026 05:12:43 -0700 (PDT)
Received: from Metius.iitm.ac.in ([103.158.43.43])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-84e1757488csm1205304b3a.33.2026.07.22.05.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 05:12:42 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: pkshih@realtek.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: rtlwifi: rtl8192du: Fix possible memory leak in rtl92du_init_sw_vars()
Date: Wed, 22 Jul 2026 17:42:35 +0530
Message-ID: <20260722121236.136754-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memory allocated inside rtl92du_init_shared_data() is not freed in
any of the subsequent error paths in rtl92du_init_sw_vars().
Fix that by adding a call to rtl92du_deinit_shared_data() in the error
path.

Fixes: b5dc8873b6ff ("wifi: rtlwifi: Add rtl8192du/sw.c")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Issue found with static analysis.

 .../net/wireless/realtek/rtlwifi/rtl8192du/sw.c    | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
index 7bafb051d5ec..c7eab3382b73 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
@@ -118,7 +118,7 @@ static int rtl92du_init_sw_vars(struct ieee80211_hw *hw)
 
 	err = rtl92du_init_shared_data(hw);
 	if (err)
-		return err;
+		goto error;
 
 	rtlpriv->dm.dm_initialgain_enable = true;
 	rtlpriv->dm.dm_flag = 0;
@@ -145,8 +145,10 @@ static int rtl92du_init_sw_vars(struct ieee80211_hw *hw)
 
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = kmalloc(0x8000, GFP_KERNEL);
-	if (!rtlpriv->rtlhal.pfirmware)
-		return -ENOMEM;
+	if (!rtlpriv->rtlhal.pfirmware) {
+		err = -ENOMEM;
+		goto error;
+	}
 
 	rtlpriv->max_fw_size = 0x8000;
 	pr_info("Driver for Realtek RTL8192DU WLAN interface\n");
@@ -160,10 +162,14 @@ static int rtl92du_init_sw_vars(struct ieee80211_hw *hw)
 		pr_err("Failed to request firmware!\n");
 		kfree(rtlpriv->rtlhal.pfirmware);
 		rtlpriv->rtlhal.pfirmware = NULL;
-		return err;
+		goto error;
 	}
 
 	return 0;
+
+error:
+	rtl92du_deinit_shared_data(hw);
+	return err;
 }
 
 static void rtl92du_deinit_sw_vars(struct ieee80211_hw *hw)
-- 
2.43.0

