Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21061D5CC9
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 13:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785073223; cv=none; b=GS6SThIp7up70bDIuF/C+ew9rS1rl/iO3a8cn7aQ917BrBW+AsbcyqOfWIwGaFttkoBPqFx7Xq7m3x52q9wM9nm+lzMR/k+pDwZIF+iJOZAAYbpb+hjyKhiPRIZTQH+87ZCXm8S6Ectp7cDO39N6texn3m9i8h1sW6oxygU8sn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785073223; c=relaxed/simple;
	bh=s0CA5V0vgA72nlg09Yc9UPayq9V2AnPuJPJxCBYRuNU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=APp67pbtrNUENB22+yJ69oX2TQbVzru4yUlxnjwK+Lwzs3BHCy1sEVZwT2yPTQIb+5C2qJnILWL8BHo/51OjcRm1jKvpkRvlNL7RUbNmJQb2PIgND+8jR8sZ6OWd/rzdYbzIatNfOt9boLo7iqh3gpUSCMflp0/dFUTyBpozyeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qp7qKc9W; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qp7qKc9W"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cc73e322dbso18058225ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 06:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785073221; x=1785678021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZXwNfgC5w0qDW+rcmUe/6tFoUi0TXzVHEf5TTFdEsyw=;
        b=Qp7qKc9W2ev42SW1GGNpIGMgOKr4eVcne8DzIEUigT/xUkydK10LSDUOR2hPyp/UPN
         FT/KXpg8G0Txb0MsXEU5fCfIXYOxdTNT01sdVK3hsZV6skukzAJLQ6p3VUQkdhLG5evJ
         RFAhEEHXTQbY3axBteb+uBx8gScXVj7tISC7XQSG4fCgYSN8DKddtPqF2wWTc9A5ueZI
         Emd3jCtmeKZOk74l8IriWNS/y07fsqkNXMB/YT0oLdNjwfPUNcjyOUIBDQdiaEG89f3O
         BfmPMYDlHXiWK9zrJ9olHHX9JbEaw9kmjz3+PZ/oAPNc+NNl7uqwn6dpvMTNhVRz1kPk
         Tr3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785073221; x=1785678021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZXwNfgC5w0qDW+rcmUe/6tFoUi0TXzVHEf5TTFdEsyw=;
        b=CmkQrBjGy3kedhlLcp644dLFdWaUI5FqXTgrQza2oqntsi+8ChxgVJcvpMRtkyGvJa
         AEdiPQgWPQcoAqx5/igHLsKL+8OfivU5Hy6284Ir6dRFd4HfefAsupUKXCWSYsI85Gla
         KaW7LuXeM7ZFLJlcfR1TrJdq2+6Ta+7L2gLoCO28xB8iAdGLbQErBVJ3O7sp0O/1k310
         sQzSuufwARQKKQSq+LFnoP+6Km6U/e3/AInNqmMJenRbEiO6lylMzaCIjVvspuQOokrV
         0/roVrDN6iqPJXjcUT2Tfnd2z5ImjCIibn8uaXtLeY85Xzgg1BTS5HMzarpkDUtkXZED
         zWfA==
X-Gm-Message-State: AOJu0Yx+2q2fOU+r9zLOr3vXz2G5Rp34rEYYXkVCw1XPntC4JhIbDApE
	5QvZmcI8WMkO8OI1+lVNx9HBIcr7j7jsuhiNX/BBDvkvJbzOI6zW7fec
X-Gm-Gg: AR+sD13rlSVCYri8jUcQQF+w7872FMGYr1aG9qYdvEaQExDNaGnocPAZING9o7EY3Wz
	ljOUio+sJTGXZW7wSBr/DP7hcfPQgJVnJjR3AwgCnDaplzqspA9f2342XoGZNiYJRh1NFinEzap
	FVV4XsS7redIkFHRKzsp/FOwTTbB8pu9n3sCueTfn3R7gf9Pd3LO/xNODtcFUWyvL8zSt8LOPcB
	y2lTwdYdOpoGh+gmSDqSgx3YeD5WIAIjXTJrys3flkSpl7lqibpLMw0qBU1inWmqU2prZQSDRnx
	TDX6c/7Pib5A+lWkdMasNu5ulOoNCAkFvpePbBpYfcz6VMFvh+8QOUjFYH90FDX6pgv0CutLLGi
	JDRDTxG2p2uYLT1aGlFceue8OFdK5xus2vOZh2erHsnncTqopfsvtGewOG7yYQ+EpDT1QEQ+d
X-Received: by 2002:a17:903:2b04:b0:2c0:e5ee:f55e with SMTP id d9443c01a7336-2cfde78d1d4mr45120095ad.7.1785073221286;
        Sun, 26 Jul 2026 06:40:21 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfe1ab9c7dsm16683595ad.70.2026.07.26.06.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 06:40:20 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwl-next v2] wifi: iwlwifi: mvm: remove conditional return with no effect
Date: Sun, 26 Jul 2026 22:40:15 +0900
Message-ID: <20260726134017.1385602-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both branches of the check return the same value, so the check has
no effect. Remove it and return the value directly.

This is the result of running the Coccinelle script from
scripts/coccinelle/misc/cond_return_no_effect.cocci.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
As suggested by Ping-Ke, the wifi patch of the treewide v1 series [1]
is split per driver and posted separately. You can find the Coccinelle
script in v1 [1].

---
Changes from v1 [1]
- Split the wifi patch per driver
- Change base to iwlwifi-next/next
- Filter only iwlwifi changes

[1] https://lore.kernel.org/all/20260723184538.3888637-1-ekffu200098@gmail.com/
---

 drivers/net/wireless/intel/iwlwifi/mvm/link.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/link.c b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
index b5d252ece2d9..76a548f9aea2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
@@ -278,11 +278,7 @@ int iwl_mvm_disable_link(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	ret = iwl_mvm_remove_link(mvm, vif, link_conf);
-	if (ret)
-		return ret;
-
-	return ret;
+	return iwl_mvm_remove_link(mvm, vif, link_conf);
 }
 
 void iwl_mvm_init_link(struct iwl_mvm_vif_link_info *link)
-- 
2.43.0

