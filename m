Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFCB53B5FD
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875562; cv=none; b=Gm3afU0IzQMb6z1u//o46zW6bq4XAUz9oJjjqPCWT5Suovd2f1iNY98ELyBdqgZjxmohSWgI1mKspjoMFZOv/cjjP0N1L8Kx3CvlkfjY/UuS7fH3GT68an0/o7c8mLmy2dHlVxC+ha6ACWSjDblXlzDtgyDe92kW5A0SrICxK5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875562; c=relaxed/simple;
	bh=JqnflKCMXfLMcXqfVpvP1mGs3iXwrVLNRVEH0gbwpG4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tHmqLYKII/2LUoxXIWdXxGKMkZjJl3Wv7pNISCfQJdL7WHbt4TUEUGtMhjWkeZgSyvt3V4eW57kIaC86/9Fy7R2GJQst4kZyhaAESvZ6nvuP0FrvkFkVKuXTu425NdXC3mxg/WD/doAGKdCkpx/bXqPPnk0Azp9iNrE8lq9sOEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=ZmS9CFLC; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="ZmS9CFLC"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a60591bb18so862366a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 06:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788875546; x=1789480346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=flz0wNvmnVRusUP3hn8kAtt2I3M80JZpc+uYtc7PGY4=;
        b=ZmS9CFLCDP9aEtfK4Zo4RQO0aLz62TIUYzsHWm1IhC5guWDYdbVWxechEw1wSGvh4k
         K+a+fQjCKTwq8HHzYm2RXodSaoSEWsGMrXSbtpWNQtiz8uWanfGY0ekeMQsLqyXwo5X4
         HrpP3vdK3TyUvCI2ZVGINpFPIURuhnYeSV/pONBTHhVLKyc+fd0ezYFK/TlaRls9tcYJ
         JsoN5uypj5We7Y3k/Kn/oejNaD0ESnKFhlXtPm/3sPrhY9Zf3nP22yTrd/cSsMHKfDII
         c7+/t/bN/ejGGA8Gcc/u00gXxqqMI7TelcuVRvMCOmmzfXrWzX8BbCuwo2oA6daEWJgs
         rp7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875546; x=1789480346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=flz0wNvmnVRusUP3hn8kAtt2I3M80JZpc+uYtc7PGY4=;
        b=HkVA3QNCN/2ReWvI2eGLQf2LVm+7RbwUoidr20gx06WWe7BxaOycVEVqnPktZDPqRO
         8nt6AZSbwKKt5fgXGxK48gFQndU7HeEgTLc1AdpMjo4Cb6SPlYzDbLX8knIk6oisbUXC
         w1HTd3rwUYcp5MlXl5Q9T1d3X/fvH+UxukyF97WGCr/YgI3yuJNOvfeAUGvxstk4dI2+
         qB+DCHGB6BsORZPZbcAWS6dconzXeL40DXAgIKXESOdM0dsxuVyrSqh1Hc/kqIduGSVk
         rIow/forjSGNewCBkOdXUvVW5Q4n1b/rgQGg7m+u5NZUDEzmzviKaSqIx+eY0fdzXDNj
         HCSw==
X-Forwarded-Encrypted: i=1; AKwUvBxGOCSfb8ofwOQ7skoksaQkxGdO4zqF0BWnHbWqr+wlYz55mvkarvB1njpmg3++emfrxS4nEOVGR8JcBjXQ9A==@vger.kernel.org
X-Gm-Message-State: AFuF++nESjGzQmgXkJIPKHiVHqK3OZS6P/1EovTEhiOrF539FbMGIfrB
	N8Sm/IZ/PYAS4X1j7DMsV2tcAoN9TsisyvmFNYjQIJzUUrFOw7mKDAnw4wlcL+ZgzFrjfhUZqrS
	rY0vd6MMb7EQ=
X-Gm-Gg: AYBFou1aBK8nROx/P8aLG3THSrPHFaG7U/MToHznGFYGql8IMI0spBQz26AS+0QodU+
	/dXngshCgRidIbv64LjDmy/nEUXDqsuK+HKn0Em9rzsW+mKb7JeRqAziKvToR3Zf4IGSpMy2Ejr
	oc5i3OzPZu32WXCt26CGm7H01BLE+A/EZVD88GyLMnAP3hAutcu2qNGODSkZ2J93BvksGVWH/oL
	KkldFbP5L4eoyTTeh339S+HZQNbKLfOhfE/DkLfMaCpgbZLh0IH2HP8W31C2QfK7/WdcweQQy7E
	GWXcDc4LTVc4dw4J509QlnU6cyTnDHxfwHgiVsopfz9cv+yyGECRFn/BAdEmRLZTFx9eRXjoLKR
	q2VlPM1qjJGPlRqBlEOn9SSlsgOFBYGoYJ2dqwq1h16Km/LpeoD50NGAGKr97toXvrr8KAO/P8j
	mEraKJOqf2ti16wJ5RXRLsUeChox+FfTloM93xqc2Qez36jQcGDsFxn05kl5uiVwHVvA70hLdF8
	bLkbCg9bcYdSVvI8CjHAI/Sn3LXJ5+V47b8BVt6riFVZqiCEJ/WAFsi1hWrMHIIrsKWRg9nA3xw
	lnAPQQnLHxaKdP2cixd8eYu+m9fx5FfJcjaudHCDKeOqsfAvQJpV6Dt5kmwE49IqFOnXmy+Kwz9
	wHKTTIbweWqrJpe8I+TXLnAN4FdsWKMQM9E9ol7Se94ItHMLgOBVkGWjbqQZNd+GaHbUqmMxLCC
	oEKfQL0Ns+wqlZ9Q==
X-Received: by 2002:a17:907:3e0c:b0:c25:f7db:4bef with SMTP id a640c23a62f3a-c2904519fdamr357705366b.21.1788875545958;
        Tue, 08 Sep 2026 06:52:25 -0700 (PDT)
Received: from Desktop (pd951346e.dip0.t-ipconnect.de. [217.81.52.110])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c262f97f1a3sm456400866b.19.2026.09.08.06.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:52:25 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: johannes@sipsolutions.net
Cc: toke@toke.dk,
	nbd@nbd.name,
	linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: mac80211: keep the TXQ scheduling round number across a closed round
Date: Tue,  8 Sep 2026 15:52:24 +0200
Message-ID: <20260908135224.754049-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_txq_schedule_start() sets local->schedule_round[ac] to 0 when
the access category is over its airtime limit, so that
ieee80211_next_txq() serves nothing until a round passes the check
again. That round is then numbered 1. ieee80211_next_txq() ends a round
when it reaches a txq whose schedule_round equals the current number,
so a txq served in a round numbered 1 is skipped in the next round
numbered 1 as well.

Where the airtime queue limit binds, closed and open rounds alternate,
so half of the rounds that could refill the queue return nothing.

Track whether a round is open in its own flag and leave the round
number alone. Checking the limit in ieee80211_next_txq() instead would
walk the active list once per txq served rather than once per round.

Measured on an IPQ8074 AP with ath11k advertising AQL through the
series "wifi: ath11k: airtime queue limits, fairness and a driver TXQ
scheduler", one 1x1 VHT80 station, BE aql_txq_limit 500/1000 us, 20 s
runs, three interleaved runs per arm, the skipped selections counted
where ieee80211_next_txq() ends the round. With a TCP download
forwarded from a wired host, 4227, 4195 and 4268 selections are skipped
per run without this change and 15, 24 and 41 with it, at 99 to 100
Mbit/s either way: the network stack's arrivals start rounds often
enough to cover the loss. With the download generated on the access
point, where TCP small queues pace the arrivals, the skipped rounds are
the ones that would have refilled the queue: 35.6, 44.4 and 42.8 Mbit/s
without this change and 94.7, 94.6 and 95.0 with it.

Fixes: 8e4bac067105 ("wifi: mac80211: add a per-PHY AQL limit to improve fairness")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 net/mac80211/ieee80211_i.h | 1 +
 net/mac80211/tx.c          | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 53b0b08d3459..65311340db40 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1468,6 +1468,7 @@ struct ieee80211_local {
 	spinlock_t active_txq_lock[IEEE80211_NUM_ACS];
 	struct list_head active_txqs[IEEE80211_NUM_ACS];
 	u16 schedule_round[IEEE80211_NUM_ACS];
+	bool schedule_open[IEEE80211_NUM_ACS];
 
 	/* serializes ieee80211_handle_wake_tx_queue */
 	spinlock_t handle_wake_tx_queue_lock;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c33092960df2..c665ced9c05c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4122,7 +4122,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 
 	spin_lock_bh(&local->active_txq_lock[ac]);
 
-	if (!local->schedule_round[ac])
+	if (!local->schedule_open[ac])
 		goto out;
 
  begin:
@@ -4347,12 +4347,12 @@ void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
 
 	spin_lock_bh(&local->active_txq_lock[ac]);
 
-	if (ieee80211_txq_schedule_airtime_check(local, ac)) {
+	local->schedule_open[ac] =
+		ieee80211_txq_schedule_airtime_check(local, ac);
+	if (local->schedule_open[ac]) {
 		local->schedule_round[ac]++;
 		if (!local->schedule_round[ac])
 			local->schedule_round[ac]++;
-	} else {
-		local->schedule_round[ac] = 0;
 	}
 
 	spin_unlock_bh(&local->active_txq_lock[ac]);
-- 
2.53.0

