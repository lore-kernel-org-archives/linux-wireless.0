Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFB63A3820
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270471; cv=none; b=BWyQOnv0C03JQC3XhE2W2bUI8tMpxeqYlHuYlE6x37mqGlBkEabVbmsb0p2dMb1Rv6GLSWQLi0sZ4c5+UNyLw+VYfhMFORJoQqhAj+yWxR4KqGc5cfn1VchRMM0YDBQAifJdaPt1XxnHSd4QshTtZr+hnJ6UtvLJT/Fr9fkDtRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270471; c=relaxed/simple;
	bh=qVyjRTSLJ7AwHmFP2Es1oDqSyJJf9VZu2kWqwNaL+44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQP9zVtXomo1Xgvo5q4920f/ZrOqctmhJuVPeQD4Tl5EeHQ7bIRy9u9+BVJBdgN6PU9Rej/xvIdIGzBQ20qyBj8wUr27X2B9LcK74VPO6e6Yyhvll8soTmhC/du/u5mldKI2bnHCz4Ct95/HXd7m8I5jTSqXIPJ5Vswx5L5DrHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=h9HT1ivj; arc=none smtp.client-ip=67.231.154.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="h9HT1ivj"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 84C978C007F
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:43 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 08AAC13C2B6;
	Wed, 11 Mar 2026 16:07:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 08AAC13C2B6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270461;
	bh=qVyjRTSLJ7AwHmFP2Es1oDqSyJJf9VZu2kWqwNaL+44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9HT1ivjqF+8K4cX4cbP+0rcJ5+Ya28k7F2r4bRJtXFgon90xSw86VagBbG1u2Xkc
	 E1F0MY6pX7wNACZ1ZFQAWqHGh3IKtzz7RdQud+ryGQ7u6Vg8NgEoIvUODUWud4KpKW
	 IgKa0SvpPONIWMO4OwgVso7eoocQrzZJZadaYaGo=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 20/28] wifi: iwlwifi: mld: Improve logging message.
Date: Wed, 11 Mar 2026 16:07:22 -0700
Message-ID: <20260311230730.163348-21-greearb@candelatech.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260311230730.163348-1-greearb@candelatech.com>
References: <20260311230730.163348-1-greearb@candelatech.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1773270464-OIvq5nyW34x8
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270464;OIvq5nyW34x8;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

Indicate that the problem is being fixed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index d44ec81d2ce4..aa4d391ffc00 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -647,7 +647,7 @@ void iwl_mld_mac80211_stop(struct ieee80211_hw *hw, bool suspend)
 	 */
 	for (int i = 0; i < ARRAY_SIZE(mld->scan.uid_status); i++)
 		if (WARN_ONCE(mld->scan.uid_status[i],
-			      "UMAC scan UID %d status was not cleaned (0x%x 0x%x)\n",
+			      "mac80211-stop: UMAC scan UID %d status was not cleaned (0x%x 0x%x), forcing to 0\n",
 			      i, mld->scan.uid_status[i], mld->scan.status))
 			mld->scan.uid_status[i] = 0;
 }
-- 
2.42.0

