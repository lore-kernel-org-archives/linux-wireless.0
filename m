Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65677471439
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 11:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784807151; cv=none; b=O7fYC9AI2QS3gt+8wm2M7ebAHAah/jbXi/gODWSva4Ypj/AnirKqb0Ik+qW1X+ePzVeLbl2I7tP1EcM+E+sBtIaBBNrg3np5eCDT3qFbBrPUAonjct18t0sjZWrh8lMOqGqxqv8GzNlNy0l5LLSyoRVDOF6/eHd9QPLIwjKOnoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784807151; c=relaxed/simple;
	bh=rnQRIx9nr5Pt9psdgxOkFunoRdX6Lj3wKYuEaoFGItM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aUsFTW0uar+6Qh+qNCga79h23hskCiWE6BwKX2fTWqiJn5Ge0Y7V/1ojVEW1fDENjpI7TJHtxBIrJIOciaEXT/AqrzI+sSZYqmKviAJQTUwDGr8NChm7hLlobUmRw5gm3wX+H5fpJ2b8om5XGVpt+a/0hUGcPAU2bLXAszDOi0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=zRSwyafH; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="zRSwyafH"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so5849055ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 04:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1784807146; x=1785411946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qW5FtRGSlPIuifYqC0uvc8wKrWKuGaKd/2/4BPZB+Yw=;
        b=zRSwyafHeEBVEgI0lXX37qd8vyO0T2BR5gC2Hah9+rBG8ExIARFVe6GB8Gk6ujmeh8
         3rjss4wDFlLmdmLnZPULpwQutc+GDEMqJTugY7Yz9qV5Qy+t9+FGk4z/hssRNR9yeZO/
         EmmwE2B8sBMwsvfYgb5hLjStarLm5ylj+DtDdQ9Y5P2K6SUqW//qkJIxBgagW4eMB1//
         VjnoToNZ1TY0Q/gF0jdBGSXm8eQYA0jMmCzA9SehQneUBJbOvy8j8B64G7D99uvSG/Dg
         RiVkQpapN4VG68nQqlxDFAabNwtbdwbf6UnNGeHo5VPf2L4VGzKcNCETRdwbUQuF3Z1O
         y7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784807146; x=1785411946;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qW5FtRGSlPIuifYqC0uvc8wKrWKuGaKd/2/4BPZB+Yw=;
        b=s5E62+rAGyJUt2HGGmwk4pQ+YPhhPdq0a7HOwr9Ytr0dCMV80bdyPJlK3qE7Az5q83
         hfom9FagZ/0kxVSsq259/xdep06WtJ9lD/GoRUwpZu7MPzcph1sq/3+m6KZwQhRjmkky
         Ve3HQw0Wq/0YfLson2zR+R3HG7iGCG7ADBaKVvmzoQxnc8n34vPniK+tD0BOHmYmDAj2
         a48eKoN3pX3Bkj9PBjqnu+glZFtV4VWPgIMdICtnAql9iVelGBe4jnMN08/CFl4cM/QJ
         6oWtpBTCUlE2ZFy7gNHkpED+OFRQCu20D14Qtcj95B0+uFoodM5c1HyYXn6SVMBOkCpn
         RlCg==
X-Forwarded-Encrypted: i=1; AHgh+RpD6wllkUBuIsY9CjMzSUvE0P01hjBRbGQiQvl+QciZsQ9917Qf88gqJ4SvNaCRMFpJ9FdrELnXNyZChm1DBw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvciqFi3BQhTwU1NHgMmu8P9oMHhzVZ2ZTBsBhmwDBe8dfR8xK
	9lEpznenWg/KHI32OSFEPWS1P8U+E3VbQG73bvJHjEMBwMe633ClBfFlIuxe8JPbHsw=
X-Gm-Gg: AR+sD10ZRmQjOkiRS5ivaQPVWr/DCWfvUYHk7ugK0C1dFauGJXrYIFupwzhXDl7tPHh
	1DU0jPgXKz6NFFVlAcko3kugX8FiEcD8cCnId/9wKjBNRfNIoZ8+/251TxjA2wxLDG4uBaluh8V
	JcAKRSA/MYRr08fMa/Y4cM0itfOBC5zfsjTTnMvgJVoCY4+H6J+4Ci199ndK1HmdDCfjt5eLz0T
	yWdnck1lCaapeT7RqLm8u5ID/jgsAconrxP7CbTR068fWgqf+AsNF5JKeiHjkFbzz4qoM2i2bhN
	MNYMf3C0k5I6XUm61DVmrhCIxNFLwAJ1fC+ltearv/n3+VbbzglENCsO1XqVP3OdbGPCfe/ZKlj
	FbluFuc37/REIjfJId74UCZX3fFKj8uU77DFpkOIlZE/gkditnJ36a799E4qLsTWVp4wRm82cHD
	2347d3lZdf7qJfkARE+L45ttB85YiNYRYXPAxnO6yuc6Y/a0yIcARyeBUh63uOI41nMSKa9uV3y
	EaeHZmqWttl6sO5QQQHevDSIjcUiWiI
X-Received: by 2002:a17:903:3bc7:b0:2cf:4c0f:5116 with SMTP id d9443c01a7336-2cfa6c5e50bmr34449455ad.28.1784807146525;
        Thu, 23 Jul 2026 04:45:46 -0700 (PDT)
Received: from Metius.iitm.ac.in ([103.158.43.43])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2cf8f310644sm32175005ad.55.2026.07.23.04.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 04:45:45 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: pkshih@realtek.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rtl8821cerfe2@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2] wifi: rtlwifi: rtl8192du: Fix possible memory leak in rtl92du_init_sw_vars()
Date: Thu, 23 Jul 2026 17:15:37 +0530
Message-ID: <20260723114539.136986-1-nihaal@cse.iitm.ac.in>
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
Compile tested only. Issue found using static analysis.

v1->v2:
- Avoid jumping to error path when rtl92du_init_shared_data() fails,
  since in that error path, the memory is already freed even on error.
  Thanks to Ping-Ke Shih for pointing this out.

v1 link: https://patchwork.kernel.org/project/linux-wireless/patch/20260722121236.136754-1-nihaal@cse.iitm.ac.in/

 drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
index 7bafb051d5ec..88e8cc590c54 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192du/sw.c
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

