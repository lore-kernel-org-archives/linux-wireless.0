Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8963DCD9F
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2026 15:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776268457; cv=none; b=uzkII7BAnF0oGsFXUlHO+fmyTAL83IqnVf2Euoj24dG+F5FcijcdFwfeaf97L+FZu9UT0fTvYoDVQXQV0SaeEvyipg3YrvPOiY8AfL+9BL4PIlILE0RyHcLU7U0LR3oMOcQOYoVpApF9kmb7Ugqx0M0WCaYQklAFVn6q+OgqwiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776268457; c=relaxed/simple;
	bh=CwDFuq0E7Dnn+n9C1aZh15WYpNMx7wvOpWox6KSKqn4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FF3bXc5qNM7y3vvJjZzClKM2ElljlJrwt9+K2kX02gU49gcR1na/qYrhtTlmZbRjb08XCaX5ac1U1VUTzv14S5rizpu+41RxnraVj2I3J2TOOerIkm/4bXs555r8P9KWRWao/3pE042R3zVcaxFdwBecKPs48R2/9WHEtcNCU0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=jFt2s3ZG; arc=none smtp.client-ip=67.231.154.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="jFt2s3ZG"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id AAFF130A588
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2026 15:54:13 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A0E6098007B;
	Wed, 15 Apr 2026 15:54:05 +0000 (UTC)
Received: from pk3.candelatech.com (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id DC93113C2B0;
	Wed, 15 Apr 2026 08:54:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DC93113C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1776268443;
	bh=CwDFuq0E7Dnn+n9C1aZh15WYpNMx7wvOpWox6KSKqn4=;
	h=From:To:Cc:Subject:Date:From;
	b=jFt2s3ZGwyCUKpQJBHaZkwFKHreIdpoExed9A3ca2x2v1r/rVyDWUm/uU/qTBwxPe
	 lpl6a0WwEgRpC+CKaVTykUjPmHTqg4/zLF+69lSXSyet1gdpQAL9x5ghkn+an83Yad
	 r+iIv2sjYgKqjDpP+CcXjpToOfVnwc8jEV1zdLT0=
From: dylan.eskew@candelatech.com
To: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com
Cc: linux-wireless@vger.kernel.org,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	Dylan Eskew <dylan.eskew@candelatech.com>
Subject: [PATCH mt76] wifi: mt76: mt7996: reduce phy work in set_coverage
Date: Wed, 15 Apr 2026 08:53:55 -0700
Message-ID: <20260415155354.1135548-2-dylan.eskew@candelatech.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1776268446-kiURHJ7mdY5H
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1776268446;kiURHJ7mdY5H;<dylan.eskew@candelatech.com>;f49eb8a899f4a60c9b856bf22a60d609
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Dylan Eskew <dylan.eskew@candelatech.com>

In mt7996_set_coverage_class(), each phy is iterated over in calling
mt7996_mac_set_coverage_class(). Thus, the phy2 and phy3 configuration
logic in mt7996_mac_set_coverage_class() can be dropped.

Signed-off-by: Dylan Eskew <dylan.eskew@candelatech.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index e2a83da3a09c..55efa3df86a6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2059,8 +2059,6 @@ void mt7996_mac_set_coverage_class(struct mt7996_phy *phy)
 {
 	s16 coverage_class = phy->coverage_class;
 	struct mt7996_dev *dev = phy->dev;
-	struct mt7996_phy *phy2 = mt7996_phy2(dev);
-	struct mt7996_phy *phy3 = mt7996_phy3(dev);
 	u32 reg_offset;
 	u32 cck = FIELD_PREP(MT_TIMEOUT_VAL_PLCP, 231) |
 		  FIELD_PREP(MT_TIMEOUT_VAL_CCA, 48);
@@ -2072,14 +2070,6 @@ void mt7996_mac_set_coverage_class(struct mt7996_phy *phy)
 	if (!test_bit(MT76_STATE_RUNNING, &phy->mt76->state))
 		return;
 
-	if (phy2)
-		coverage_class = max_t(s16, dev->phy.coverage_class,
-				       phy2->coverage_class);
-
-	if (phy3)
-		coverage_class = max_t(s16, coverage_class,
-				       phy3->coverage_class);
-
 	offset = 3 * coverage_class;
 	reg_offset = FIELD_PREP(MT_TIMEOUT_VAL_PLCP, offset) |
 		     FIELD_PREP(MT_TIMEOUT_VAL_CCA, offset);
-- 
2.52.0

