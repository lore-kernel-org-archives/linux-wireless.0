Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3729748380C
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 14:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397719; cv=none; b=eTTN/ah4NuaSTQYmTDfyReYwwvHkxyz1BG8b1uUhAhGDQ4zouzz6/zvsPdfvXldEUpPDi/oK9u/r7akkgMbsFhZe0LYwymCxteS78IsRxTau6ZJ8q2YJZAwAPZH2oEbLVsFdUJyTIYv/MCTTeXaePWl8PeE4uzwhDEuYGMcC8nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397719; c=relaxed/simple;
	bh=lIGJu87IDArxEyWhL0iXD9acKrDMnyg5SF/6N1cb1BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTY0cvnMSIlGY1uePZ/kAeBa78l5FGlFtP6Uc9zZ9bUqNx0W/VoBGnZkU/gToxDGd9Rbzkd0ifcdzYe38RPEsqqBRWcRxIhJibIz4XssxFal+VV+IDhPmZcZE3MnF3Su6kqnI0o2qRP3xeo4zCXxJL28Sr5pd2UQhpKCmZOOVwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WT8sk6+L; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WT8sk6+L"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc4d64bcea5so1962768a12.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 07:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789397717; x=1790002517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ITlXRLngn2slKcOGycWl5+67jdUQ/52QuImnyuHZebY=;
        b=WT8sk6+LDlMZjTQlawqOtZieOWochMLXnJcHUuE7n5F9cOXz4785zLZJWZkCWtIzrg
         q0wobQDD5Qvo/rqKgiFPQ1N+6b9nrmJs/8z1y4AMZQvKoG67sQg71hLoZ+tsHPIXUFwy
         xfL/9YNbOcowJhr8YHWXoe663rvz5UKhjp0eYN4XbxzgmUBQCV8FyS3D3RrNHtWyBV3U
         9z8LoXF/6fSKQyco9A3lvusT03k0+cCx9ZWahzDf2HV0n5fn2kGaUzavPCrZl1jcTtKH
         3lFk1fopy3Z20iVwhIS0rkgif29fdxHDXLUCzXnsIf0UGzQNt4gpbFydkevYwRpdZEkt
         MjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789397717; x=1790002517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ITlXRLngn2slKcOGycWl5+67jdUQ/52QuImnyuHZebY=;
        b=bzJrAtAeU0X0C5z24KBVjU0QSLSJloV8p3QQiUIkfjTtg0tw8LO3L9oH3sBS3W8pGb
         vPCQ23y754hEcnPJYwI4OX89SwWFw+4YzoCo9+lUPLjsgHrvOcChl5eHGkiHolAGF+Cr
         trsriqMl/PGkWmF8zMaJGS91tTv3+5LOvF/nyfDMewU910CXwP1XXNI1GY48k0Dvm1ql
         0jFQTyWlFePAkY0G2jHmCqve10Y2yQ65jL5OK+W8ZQ4xbstYV66YqeducdMkeYei86my
         sRAptIVLS4HBsYiMe3+evBGSiYQnCt5/28PwblW7pdnjSL4bEREkiBXVdgtouwc2viIP
         fGTg==
X-Gm-Message-State: AFuF++lRPfcvjsVsYCJm2fBDY/ZS+3yHmpqXcRuO4liuLMfvR83z/i5y
	GgN/zO3lKWvL1LhUcOnx19tYZbRpK71t8vfdC7hsvi1mcPRFtPeoT0qAysdr8y8G
X-Gm-Gg: AYBFou2KhU6Jy+n7He5b8WHT62sNjXsFR38UzduNRw+pzyyO7tUdFez9YYcM8xbJJI8
	RFSoUj+cXtWNTPB5ecPWz00WXUl7dOU6hX9+AOF8q7cq/vYbyyWKUk3/jJ8rnj+6b2SnYI0GKkj
	nTqhdzqRYgXlqW2lDI92ozgAhoLIqulQ1ea6ob1NEmbD2qaBAfSCXdwMzHWSPlBSFhNJ31SIZMQ
	ds9OP6Uu9jyU2ENU8EoTGjAB13upBBRSmUmstNb7Li8yJtkZXWW+u56QdKpgP+rjbTYZTtQ44q1
	5MM3yp7MEzoAeK8iPKMH0mmDZ/5P5RoTNT+ECzeUerlKtoBSr0amAsKN1epj8pEs7ElxqFXB4L4
	FFkYJ1FY68F0UmXTqjZdZ0xojnR0Nxv4T3xUXqb7CoX6GZAxNtizQ3QD5pUZKFhHtH0Ruy2m6TA
	buVvJUnQdYHzWlY7NiEjO1jlY7QRzpqGP68stk1O68Hh4N5YnlotKeVya+0usv31Qo9N9ZDE32p
	cCgcYjyJNMXjLePepj4+bPzu9cTW+L+CovNGXo=
X-Received: by 2002:a05:6a20:43ac:b0:3d1:39e9:b267 with SMTP id adf61e73a8af0-3db4037cd96mr6822285637.3.1789397717314;
        Mon, 14 Sep 2026 07:55:17 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c615a65bsm5338805a12.3.2026.09.14.07.55.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 07:55:15 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 3/3] wifi: iwlwifi: mld: unpublish links before freeing on add failure
Date: Mon, 14 Sep 2026 22:54:33 +0800
Message-ID: <20260914145433.42830-4-enderaoelyther@gmail.com>
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

During firmware restart, iwl_mld_add_link() can reuse a link that is
already published in mld_vif->link[]. If link initialization fails, the
common error path frees the link without clearing that pointer.

A later firmware-add failure does clear the pointer, but then immediately
frees the link while an RCU reader may still hold it.

Clear mld_vif->link[] in the common error path and defer freeing dynamic
links until after an RCU grace period, matching normal link removal.

iwl_mld_link_from_mac80211() reads that same slot under the wiphy mutex, so
a NULL link means the slot is already NULL; the common clear cannot discard
another link.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/link.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/link.c b/drivers/net/wireless/intel/iwlwifi/mld/link.c
index 96e06940b34c..55b84801923d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/link.c
@@ -541,15 +541,15 @@ int iwl_mld_add_link(struct iwl_mld *mld,
 	ret = iwl_mld_add_link_to_fw(mld, bss_conf);
 	if (ret) {
 		RCU_INIT_POINTER(mld->fw_id_to_bss_conf[link->fw_id], NULL);
-		RCU_INIT_POINTER(mld_vif->link[bss_conf->link_id], NULL);
 		goto free;
 	}
 
 	return ret;
 
 free:
+	RCU_INIT_POINTER(mld_vif->link[bss_conf->link_id], NULL);
 	if (!is_deflink)
-		kfree(link);
+		kfree_rcu(link, rcu_head);
 	return ret;
 }
 
-- 
2.55.0

