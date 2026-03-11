Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B76B3A381F
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270470; cv=none; b=Lwu4g5lQ8n30l1JF2MRisf7HykikDW8meSvfDKtFV9BwN8dFpjvgdTH8/atY3WcXCCrWynrAODOTJFodpQlPyg0CU6ffCEuYc6dbQ0SO4qI1AzMy6UX9cgEK7csDyig/SqSuE75mK98bfDCtGGOvvRZrlL/qaTlhdqOEaJ2A1Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270470; c=relaxed/simple;
	bh=mRQpnpMqVqBj1C++P+SgMnDw3psGcoLR1NEbkaNg2so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1brIfRHFqsuyht8edwM1S4eo1ymZBlqQlYNtdMoxpWN8fWs3qjtmBcNvN56lvrNzo6IzVNCC9JFb5CjjHTnhxJPXf867fUETroMGDekjFkGPVjhC1ikKJHgFMREkH7hD6SglvKugaFACmmGCoqe15LWvE9B2urz8rE41s4MlGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=DRAyP6yK; arc=none smtp.client-ip=67.231.154.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="DRAyP6yK"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2132B440086
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:45 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id B5CD313C2B3;
	Wed, 11 Mar 2026 16:07:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com B5CD313C2B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270462;
	bh=mRQpnpMqVqBj1C++P+SgMnDw3psGcoLR1NEbkaNg2so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRAyP6yKkUcxwDTXcupy7kbLqGbDx4yH78ZQH/Vrsrz19gGaPK0T4BJ3NBP1N3KIe
	 aSoqqGEX3KIkdOw8ENOYhni/SVT58z3l0Fl2uFxIJvZXgmAQNjXf9UzGcqQy2uUnDl
	 qRZqIjS7oNWjS64YxBh4K2pAw5UvvbH07K4cd5kA=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 27/28] wifi: iwlwifi: mld: Convert to WARN_ONCE in link removal path.
Date: Wed, 11 Mar 2026 16:07:29 -0700
Message-ID: <20260311230730.163348-28-greearb@candelatech.com>
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
X-MDID: 1773270465-gDlBCxFjxBpx
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270465;gDlBCxFjxBpx;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

While the comment indicates this should not happen, it does at least
when firmware is being problematic.  Change to WARN_ON_ONCE to
decrease log spam.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/sta.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/sta.h b/drivers/net/wireless/intel/iwlwifi/mld/sta.h
index 1897b121aae2..44c54e6d68e6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/sta.h
@@ -170,7 +170,7 @@ iwl_mld_cleanup_sta(void *data, struct ieee80211_sta *sta)
 			continue;
 
 		/* Should not happen as link removal should always succeed */
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 		RCU_INIT_POINTER(mld_sta->link[link_id], NULL);
 		RCU_INIT_POINTER(mld_sta->mld->fw_id_to_link_sta[mld_link_sta->fw_id],
 				 NULL);
-- 
2.42.0

