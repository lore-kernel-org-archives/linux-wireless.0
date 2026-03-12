Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F84D3976B0
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334865; cv=none; b=GDJTEaq1uxklE/ws4+AKGauapHJiXBDeeOCTpcxglw+UdzstBFpBUJvWsQ1hKSOCEZpKuLcA3qXlEl4as0eJnKDMQLk7xxhM1dc81NhmRtiK7jN+9AGSrsMKzC3f74+Jf3MzL1norAS1ymX+ULQcLBCGk92BtXdeHcNQ1J6eRhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334865; c=relaxed/simple;
	bh=vwY/GGcAms18Dpnp9HGaFOyKVZsyjFJJqlMhBQq18Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI9n3tCCB/GJE/mSTzNk/h7ApPLHI+iRAtjTLkGKlpyPbRcd6uRV1DhI7p5CRs09VcDHMiX6kZn7/wX05C8yzaUQRGYoD7Rlvv/zIIvXKvda1oOWEZGEGe8A01jHjZuCOKvrHa80tSnhpAa6nxOIOzUJPeQe5nujk4IUbBJPvZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=EQg9Ga9q; arc=none smtp.client-ip=148.163.129.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="EQg9Ga9q"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EDCAE34006E
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:01 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 05EAF13C2B6;
	Thu, 12 Mar 2026 10:00:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 05EAF13C2B6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773334859;
	bh=vwY/GGcAms18Dpnp9HGaFOyKVZsyjFJJqlMhBQq18Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQg9Ga9q8KaReodFdV6ajqt532CBOwGVYA77erBOJKKvRkH4cienHIGrcQtrXffoo
	 uI4+/GvAHVtcb+90WyZDTf7SjGS44GfJFn2/0/hx7aqWKw+taPrmUsl5880zgHtQrb
	 FjyIGcuwBg3esun+x8sx6Q5pBoI9ZoYic/f38RS8=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next v2 05/28] wifi: mac80211: do not fail taking sta to lower state.
Date: Thu, 12 Mar 2026 10:00:03 -0700
Message-ID: <20260312170026.285494-6-greearb@candelatech.com>
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
X-MDID: 1773334862-D8WXQdRmzEFn
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1773334862;D8WXQdRmzEFn;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

If sdata-in-driver-check fails, then we assume STA is definitely
not in the driver, and so going to less connected states should not
fail.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/driver-ops.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 49753b73aba2..59998d0af3ff 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -143,8 +143,12 @@ int drv_sta_state(struct ieee80211_local *local,
 	lockdep_assert_wiphy(local->hw.wiphy);
 
 	sdata = get_bss_sdata(sdata);
-	if (!check_sdata_in_driver(sdata))
+	if (!check_sdata_in_driver(sdata)) {
+		/* Going down should not fail in this case. */
+		if (new_state < old_state)
+			return 0;
 		return -EIO;
+	}
 
 	trace_drv_sta_state(local, sdata, &sta->sta, old_state, new_state);
 	if (local->ops->sta_state) {
-- 
2.42.0

