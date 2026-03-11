Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493C13A1689
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270469; cv=none; b=HaFLDJfmUsDTAgO/2qZ27cSGU7/+ofJOgWzpUTb60lR1HoJCoaU6IxZ4ZJcWxKXRCIvjx7q0Kd9MHcuRkYNGvk9RZkQ4c3k4B7l5pog6ajTCAlHG1FZo1JMmxQFxChOwwzznUJgosYvJIV+fDgO6t9bgLrvpVENVkUy3UcLNgb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270469; c=relaxed/simple;
	bh=mi/nNh7zbAOlpgZ51NfdYcrHH2ZIlXOTxw3bthgh4QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZq/pu71qaBFYVX9q2pUEiW3bFkHjhZ0aDu1G5ZOFn32WO/fHvX4ZO7XVoSsM53l/oGrjZmY8BV/6SEp4ij/A+OL58TaMbv3o7dIpFwK+ZPgS/pcqdDSZBYLAVVuYMSBQVSe0h8OSuZ0Cj9RBPypzj7DY1kNQ4CBFGLJWVEpwxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=cHqNPgcz; arc=none smtp.client-ip=67.231.154.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="cHqNPgcz"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8AD5F44006C
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:41 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 3B90813C2BA;
	Wed, 11 Mar 2026 16:07:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 3B90813C2BA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270458;
	bh=mi/nNh7zbAOlpgZ51NfdYcrHH2ZIlXOTxw3bthgh4QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHqNPgczebaTw/0rta1aS7q9AdtBKChhnB/M3vSnwOorGx70B8ZDRX7BSb+q2+q8h
	 qS9n6oNtb++WRQ2iZWjVnhqEb4hYpOM0DPV+uZyd/ce2/gS2e2qJdkLPK5KtnTV+/p
	 84bbZAY1ZeDQHAepmi01iEkPF/inlQOd7HzXJfuA=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 09/28] wifi: mac80211: Use warn-on-once in drv_remove_chanctxt
Date: Wed, 11 Mar 2026 16:07:11 -0700
Message-ID: <20260311230730.163348-10-greearb@candelatech.com>
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
X-MDID: 1773270462-vRBI2wOP6wyj
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270462;vRBI2wOP6wyj;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

But still log it to dmesg.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/driver-ops.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 51bf3c7822a7..e2283d7dcd1e 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1035,8 +1035,10 @@ static inline void drv_remove_chanctx(struct ieee80211_local *local,
 	might_sleep();
 	lockdep_assert_wiphy(local->hw.wiphy);
 
-	if (WARN_ON(!ctx->driver_present))
+	if (WARN_ON_ONCE(!ctx->driver_present)) {
+		pr_err("drv-remove-chanctx, NOT driver_present, not sending request to driver.");
 		return;
+	}
 
 	trace_drv_remove_chanctx(local, ctx);
 	if (local->ops->remove_chanctx)
-- 
2.42.0

