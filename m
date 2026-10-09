Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E0050EC01
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569671; cv=none; b=lUnYR+tVXHdW88bjrq3t0lLzPisAfMERwhXGbNz7q2/sSmCm5rREPaVcp06FGiizl3U7IJluHjRuL+P6sYchyeZZRXmy9ay2ucESh9JaMdgMJeUwvjR9uvXbhFuHDnr3gWvUBG8TU25FEX9bDs7JSwjzH10GL0bXv8GAnlPRdo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569671; c=relaxed/simple;
	bh=COgR/LiLY+sJiZ3odKy14a4EDGMH27n4Qt+94Bg4PmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lK+RsYwg/P2hRZgNH6pqnBZQwfoX7jDPlfU/yIQIwXWfO2/6wblD64c3gVb91hLS0zZW+EY07PUGddbqZO2rnO9N3w5p22S9M82Wa/7Lk73LYI3WqwY3T5urmZZ2E/HovkBB3/67Ek7GbfzIO7g3NJMQgT77l2BqRai6EyXXCZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=pq3Y46u/; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="pq3Y46u/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ChSCBROu9TB08YSFBXvpu5ipH/eo4SAK8/Y5jhUOE8E=;
	t=1791569670; x=1792779270; b=pq3Y46u/pKooDb2VA1yDCJ9sKqs6saH6Z5Bx3QTmwuxtuHI
	P68MPFX/J5pBomdvUsJm8hjWGJ+fQFKY+f/b15TxjdAzS6ApZjJXu+A6FYSI3see+ixHsLI4lEVOD
	hGyebN4iLQmZcHmoBSc67WWslASEY4IjS0aFWfovwWjVIWi2ahrfnPhRfM+aIenmVWZIO2IswcYrJ
	mAZukEsvwKIfRQHpl8Q8R++51IA92tUQIfv7Rw2Qowu8wQVIaA+kdE7NSXZlAzLLbvFAfVwX+PkJO
	aQMt2oh2Mr7k2z7Oc+JEO9VHXO9SEWHQ36u8CQ7Yk5odx8dnT5mcpH6jHz7Z+X3g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF6w-0000000AtGH-3Vjq;
	Fri, 09 Oct 2026 20:14:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 08/17] wifi: cfg80211: make cookie counter atomic
Date: Fri,  9 Oct 2026 20:10:07 +0200
Message-ID: <20261009201417.ec1dbc786a60.I83ec404d833100a798181234c797c558400c7145@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009181416.335754-19-johannes@sipsolutions.net>
References: <20261009181416.335754-19-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The cookie counter is currently protected by the
wiphy mutex, but in order to be able to transmit
management frames without holding that, we need
to assign cookies atomically.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 0e05d4247bea..07d7a68a7cfc 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -83,7 +83,9 @@ struct cfg80211_registered_device {
 	/* protected by RTNL only */
 	int num_running_ifaces;
 	int num_running_monitor_ifaces;
-	u64 cookie_counter;
+
+	/* atomic for unlocked users */
+	atomic64_t cookie_counter;
 
 	/* BSSes/scanning */
 	spinlock_t bss_lock;
@@ -171,10 +173,10 @@ cfg80211_rdev_free_wowlan(struct cfg80211_registered_device *rdev)
 
 static inline u64 cfg80211_assign_cookie(struct cfg80211_registered_device *rdev)
 {
-	u64 r = ++rdev->cookie_counter;
+	u64 r = atomic64_inc_return(&rdev->cookie_counter);
 
 	if (WARN_ON(r == 0))
-		r = ++rdev->cookie_counter;
+		r = atomic64_inc_return(&rdev->cookie_counter);
 
 	return r;
 }
-- 
2.56.0

