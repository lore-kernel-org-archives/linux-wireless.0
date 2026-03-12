Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDD339D6FE
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334869; cv=none; b=ENNvUaMmZT5dMXYGwSJDOuQHfrkjYCYC4th3Rkj2tmC09Kj97c3Z8KAI0uBD1qyJrQemGOhvE6X1HZmHI0z+rHfInsaO1kPZu56vdS7DT3A/2wMefer2BbyaX3tMpICI03A/TRG/iFvro/ssVTiclxtOLL1EsbzPjedC9XH3ikE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334869; c=relaxed/simple;
	bh=gEVVvNf70ANsScjg/JxznChwr+2vlqFTitzzp5FsZF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hR8Cx3nhMrO+aaNuLW4KOEM5rm8aZtpaHiSwIuEIIx6lGPeSN+Shr4r5v1eKV5v5Ahb36ytTdM2dPFuFYI07sSSUqlQRJudk1IMc44+Smqn50PzHdj/oLfffzCNQyzBCHfWW3++Y+kIqTYapJHFMuvmLqS9e9KYSh8ZIijlBoEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=MqFbEIdR; arc=none smtp.client-ip=148.163.129.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="MqFbEIdR"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D197F3400A0
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:04 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id AD4C913C2BE;
	Thu, 12 Mar 2026 10:01:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com AD4C913C2BE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773334862;
	bh=gEVVvNf70ANsScjg/JxznChwr+2vlqFTitzzp5FsZF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqFbEIdRbwnywKlUZHt5+AgxSSfL6723oD/QfzznaSckvrzjv3e/lGy8gZ67UIOx2
	 1h59KUCGZLK/Qw2UOq9CuElJIr6Ewta/3yAJIfa542AwTVtF6gwUDEB6GiykQAtriT
	 8ut2UFxbc4g5b24B8Z11JPQxwvTIO5ZgOZ1bEny4=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next v2 20/28] wifi: iwlwifi: mld: Improve logging message.
Date: Thu, 12 Mar 2026 10:00:18 -0700
Message-ID: <20260312170026.285494-21-greearb@candelatech.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260312170026.285494-1-greearb@candelatech.com>
References: <20260312170026.285494-1-greearb@candelatech.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1773334865-sYsAOy70t7KE
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1773334865;sYsAOy70t7KE;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

Indicate that the problem is being fixed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 0c53d6bd9651..1557aa2a4866 100644
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

