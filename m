Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514901D5CC9
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 13:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785073209; cv=none; b=QzOdWVIy3H45vhdT396fBsJ90iWT6Vb6OLyrOSPQiFgWzrfmkKOeO0+5L2SGMFh6DgioE1+RcYEk7Zedq5so7G+GvlvEvyd4jEy7uownIw6ddD5Wtjx/Sjz5pCu60NMdOvTn1rBG4ca090+ibewoLJCtP8BMvG+tu3XxRQCPnrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785073209; c=relaxed/simple;
	bh=6U7u4X01gUEiadrw8y9jEyWoOX9DakJk2Az2swXv+7U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EP7Y7ASHCNnxqxKwIHhisdLK99F6mU2QySVlCKidSaVFENdy85gZpv/cOgfOghDaRJJNvmPjDzjME2GOruuU14elfq6UJT44npuanT7/Qb0rH/XkyLnL8ezUcINQQFPA/Jn3FvfqnZ9e4iIQO5+qvRkcNY6cj5+K9nKC7UEWQ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1jSJegv; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1jSJegv"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84e27035206so1803713b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 06:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785073207; x=1785678007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ANG/5dTrnLBkTGc6ILDrQOa4oE83/uAhMCVdftg6RLA=;
        b=N1jSJegvJmxnrbcC66gepppGRzCS5PD8OP984R/EpdO4hhiZ1MdmycA3hwmgInZINa
         c4ay7Qb1zm6L5hlxKuH/66kKZFQH7klgfyPhcblv4yo+Da6kD/R3RvWl73IHdS5uQc8N
         aSgxTwsI9TUYQMCY8LqH0KhDHti29KT0hPn786vnU+qc547KjaZhAODQgLsF9kUMBoz3
         vK+Cm4rL/i9ZZ6Q4/SPrcYyJG2yAV1vm2hEUeugcWTBhZHe5mLppc6NT3nd6N2UtBs5R
         dxg3NBGnZ8oj+qvVjdNpWyNdO6U1PArazwyJqh2ltGrN9zFkXdvh8KLvVekxw3LTOumh
         LNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785073207; x=1785678007;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ANG/5dTrnLBkTGc6ILDrQOa4oE83/uAhMCVdftg6RLA=;
        b=YjxwhQYqe3bKGlCTUgjIfwXqzfqYi6p+I6xUyHdZqlqytfM4sWxpF39n450JkSq1EK
         IT1uz53tcJRli5uLphspVNdz2Dg4W//mIGNMBW0JI7PcG1CtZObkpLgbbKtVlakrcnML
         u/IhXJVdxYNxS2CBDMsBhwIG546EDjUUbIwae0az+mmusox5GSV912kBwgmc46XzteKV
         OK1dgZ3IAbon3iv5vdPyfyW0J8TPVcWSVLkXGPxZjesebSF0Umo0Qb5xPZR7US6Y+6lG
         6GLlrDWZJKuc0JzsJWH6gTpKDEq9SZU1icjboqhFM/xG8nhkisO3nuEUecpsP0kRa5lZ
         FhDA==
X-Gm-Message-State: AOJu0YzFgjZHqS5XnDGx6KOjLaVjuG/kKiL3FAk2wyYkQ9hBGZSQmUNM
	b5d1Sseo5/++FSzfiV9pMCOMWAwJhnO85Im4ajZhbKIbQHQPSJTZHi2t
X-Gm-Gg: AR+sD10Zszud5nmAmJA8ypjgqUsc7DHLyO2ze0+A2szSlePRlLXAA4rzXCrf1QvA0V6
	Qys0C32wuSguzhi7YbEYTt0Xp8J2/gqKBXtCEMxcGa0Nd5dDsFzc8qCa3YgSsZiJbCFuPw2Dz3B
	igZxeW8GbhQvsUTdmvXbr5Vc/933C7a6HbEgJ/NbfaeKdhT3/RwLTto23rzcHJvX36jOiiclVRQ
	BWG56jd1rcaXxCL2VdGTNGV85mYrUtgu+kRvTUVFEtC+2XEyyPo6dEkUHvBMjKveTq0ybAv6sbV
	bmKOhWhIfgl/EO8LneE6t+yccJYoKYphvl8rT/WYezjMZ0wDYx2wpdXMtwikz+wJY8S1QJUo1QI
	/lEFfzEuh6ewKkNg+pU6NKOHbBiP+ST3KRofnUpjpwCMHjXcyWEwL1juXfWygIhin18KXqXjrTs
	POqRHJ0i0=
X-Received: by 2002:a05:6a00:430c:b0:848:4754:28e5 with SMTP id d2e1a72fcca58-84e593fe292mr4096553b3a.16.1785073207470;
        Sun, 26 Jul 2026 06:40:07 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbbb6623294sm2042649a12.10.2026.07.26.06.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 06:40:06 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next v2] wifi: ath6kl: remove conditional return with no effect
Date: Sun, 26 Jul 2026 22:34:35 +0900
Message-ID: <20260726133851.1382095-1-ekffu200098@gmail.com>
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
- Change base to ath/for-next
- Filter only ath6kl changes

[1] https://lore.kernel.org/all/20260723184538.3888637-1-ekffu200098@gmail.com/
---

 drivers/net/wireless/ath/ath6kl/init.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 782209dcb782..61fa10d88714 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1566,11 +1566,7 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 
 	address = MBOX_BASE_ADDRESS + LOCAL_SCRATCH_ADDRESS;
 	param = options | 0x20;
-	status = ath6kl_bmi_reg_write(ar, address, param);
-	if (status)
-		return status;
-
-	return status;
+	return ath6kl_bmi_reg_write(ar, address, param);
 }
 
 int ath6kl_init_hw_params(struct ath6kl *ar)
-- 
2.43.0

