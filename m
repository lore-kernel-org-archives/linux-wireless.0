Received: from rudorff.com (rudorff.com [193.31.26.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827E847ECF1;
	Fri, 16 Oct 2026 12:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.31.26.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792153593; cv=none; b=YS04xZ3t9E3nkmSO94gwqaImLPpkJ6kDMEyWnHK+nVCZnMyMJLQ8aWY57R26Ufo79Rbz8VObfoMa7DyAJqS1QwhQqErSmIPdQK1Fp7fW0ZkwtkFv9cTW+YoHrOq2tgzVOf3rJOuW9p7lsubIZaA+lnWD+jYyMWuwtU6YLzItAxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792153593; c=relaxed/simple;
	bh=QnDhVNHVmdaHIhwFcMsjkpmDrAHwnVUcW6FvfLkpixE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Krnforka2H4XN5iJMUyZssC7Z/9DJxmYfiOKNho3FUQgxEfTt8S1Asm6/qw22ZA0UJ42mJvedzzoJcJ1UDnlIxUo+LDJCu49LgPe1wJzC3kQojjbHRly2Iw5dzy7mLIHLoBPSs6aF1G1lOtZQvmqL3Xr6+h8HTwvso/DdqlEg6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rudorff.com; spf=pass smtp.mailfrom=rudorff.com; arc=none smtp.client-ip=193.31.26.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rudorff.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rudorff.com
Received: from [127.0.0.1] (dynamic-2a02-3102-b60c-0d00-92f6-52ff-0000-04cc.310.pool.telefonica.de [IPv6:2a02:3102:b60c:d00:92f6:52ff:0:4cc])
	by rudorff.com (Postfix) with ESMTPSA id EFA7B40049;
	Fri, 16 Oct 2026 14:21:02 +0200 (CEST)
From: Christoph Rudorff <chris@rudorff.com>
Date: Fri, 16 Oct 2026 14:20:20 +0200
Subject: [PATCH] mac80211: fix ieee80211_set_antenna() return value
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-fix-set-antenna-v1-1-e071d66f7f89@rudorff.com>
X-B4-Tracking: v=1; b=H4sIAIMW0moC/yXMQQqDMBCF4avIrDuQBAziVaSLmIztuBglkxYhe
 HfTuvzgvb+CUmZSGLsKmb6svEmDfXQQ30FehJyawRnnrbEeFz5QqWCQQiIBe+NMn+Lg4+yhvfZ
 MbfIvTs/b+plXiuWXgfO8AEudFEFzAAAA
X-Change-ID: 20261016-fix-set-antenna-50205dc86cb6
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Christoph Rudorff <chris@rudorff.com>
X-Mailer: b4 0.16.0

To set up antenna the device must be disabled, "not started".
So return -EBUSY instead of -EOPNOTSUPP

$ iw phy0 set antenna 0x3
command failed: Operation not supported (-95)

expected output:
command failed: Device or resource busy (-16)

Signed-off-by: Christoph Rudorff <chris@rudorff.com>
---
I was confused that none of my wifi devices can set_antenna.

Code review, turns out, the device must be disabled "not started".

So correct the return value and later drv_set_antenna()
handles the "not supported" case.

This is a good candidate for backport.
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a1753335eb9d..87a9ead7c638 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4920,7 +4920,7 @@ static int ieee80211_set_antenna(struct wiphy *wiphy, int radio_idx,
 	int ret;
 
 	if (local->started)
-		return -EOPNOTSUPP;
+		return -EBUSY;
 
 	ret = drv_set_antenna(local, tx_ant, rx_ant);
 	if (ret)

---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20261016-fix-set-antenna-50205dc86cb6

Best regards,
--  
Christoph Rudorff <chris@rudorff.com>

