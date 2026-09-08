Received: from mail-ej2-f7.google.com (mail-ej2-f7.google.com [74.125.228.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3CA534478
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 14:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788878535; cv=none; b=uSyglHL3xSOsg8IQXW07cRvm9MQYEt3+fZRHlpSXB5WdkDSwSNSPFAaHaQwcrp0p4nQqviND0pDUL32aSfMrX+GawOlAzKpoAQPCUpQh1n2gTEx+L5C/TxTha8mZ2r9bKabiHft1sBm5oHlyfViCNo0OdeWvO1iA26EgSX6VbUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788878535; c=relaxed/simple;
	bh=O72Eu7E/IYRO7aCdr2d+5ZiVXEK6ThYEg0f9U69sTYw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MPHEiUtzcdaZOAJ/enQ6P+olBpxK+2nOY2XXo3u6v4JH+AdS/oGGT0K5sCquwhVciFJFKggyteO6kGTw07KkD2emDbXvuHqrT3cb5nNgRHOyTBOybIxL3HQOv3BhNcpBXSQyj1zo7p2maWft7+r3lo9Kpn6/82lPgJwckDsIMlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=kFydHr/+; arc=none smtp.client-ip=74.125.228.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="kFydHr/+"
Received: by mail-ej2-f7.google.com with SMTP id a640c23a62f3a-c28e57ef0daso127365566b.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 07:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788878516; x=1789483316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5P0ZdSRKaTaZXsalhYTRK9OupuegscjDdJRNjgPwf1g=;
        b=kFydHr/+JP1g51zJtM9Q4s0Fw99xFdfmv55YiUBiybzOsq9DxG7peicXQPVF/+t0lu
         PT7+6hTAEcLfwTa1eSwBwLK/abCenCRyf+fIl6z6wVsDsPNHYYaJyngJopSVUeuOUM3v
         OlZzzVyKqQ33j+ofwKigsSW8vI7IqiLEPjYz0qtfu8cmRFHVkM5xNJXJs10yjtBeztpB
         jrYsOcS/tWgeP+sskA631bBgkhRNEAMwjcHpYnhqW0BSDuVMBrcKHRVQHDva+dok7hqt
         XLzNdeSHWrNvuQASRoW6eIqekOr9R84B9Q9LME4BNBeBH17dy40DBl3dP+y9fAIb5lun
         OgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788878516; x=1789483316;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5P0ZdSRKaTaZXsalhYTRK9OupuegscjDdJRNjgPwf1g=;
        b=UXKI8Da8yy0GFSlpJqbp4IHgluIjGEHfg/iOWLVSX/vhpEItzYo9e4srnEr/t4kBvH
         SX5HS+fYzalAljLuEilLXJlYLSKFuydhezwaoLNUWbrurFhLhqPzUiFc11hs9ZzA+3nf
         bux6swDFn8B/mW/mK/YwBYQdoEy/M2zkrIN9I7D7Ni5BNV7IBfgiOj5eePppQUzMJp3i
         wQANUypjZfTYeaP7nkW/R+kONiXwwMTmcmqSqHPUPsKUiDpnte7DeEKY2/QZzR6TRnKw
         Km0qxccKWbm/8Y0zbK9xWBfK3NCbc31z0fKRXbY8+2ReuaQTx+YfIWmTiSIXThxRoB1D
         QyKg==
X-Forwarded-Encrypted: i=1; AKwUvBy8EKaSxv6udqf616yNkTB9AHnAc7CkWQmcbpT+87lIcvYJ0w7pCLAfXDiW8+8fLoksvafNqQyY/GNO9/BKNA==@vger.kernel.org
X-Gm-Message-State: AFuF++mCCf+dOLzdXJXXUWSTuoW5DJbYQmynMHn1Yhxc7/MI86Te7we7
	9a/FB/stxnuoeVlZDrl1F02b27IVkODgq+7arphLEMheBbFMGqcI8aVGJlWCsPHq/A==
X-Gm-Gg: AYBFou0hgPvzJrjyKdW9tAP4ee5ECCBO1J7COLFQeCQFKzX/FJm+8fZ+giWHgsGB5sG
	mrFMzZvemAwTtle/iBJoi9umPbuDHaq0BTGFoOjJTOBZ3Jcqrfx960Hvhu8KorTg99OH5Vbj9WY
	pirc0/WkUe2ncarNA7SpqULvUpnxyG3DCdXyYcx8/3Wo0YZonlhZ3Qho48QkXwmqVHyeVu4CBTy
	txeuSpBNsBOKODpDlJUNflRSGZ13rM6iWqzlAK6e1F+HzimsA1DKKi75Jut37pfXqQOgCeggicI
	b6E5mUxXU+cfukRBIWPBr7Lzs+Yejp73IEkzivYmXaZvZw8D9zhQiwd3KRuPzzgLkN8QejWK5uM
	/9yxnYt3RAjFBESxg96YlDGNqoqtOUJk1p8FOzTcMe41HPFq4Sbnxbos9NG3gCU3WA/fTy91U7g
	Zyt6NV08alDB48zPoom9KoOa2eU5SdXzROc4hM0hQyHm6LCZ4wa2LYKfsyysUOt36LDL0V9lluf
	oCAaYkGG01bBjiSZGeEqYZYfVZYC82c1Sh+zlZpcycFRUxd5nJ8NzWMutTKFiBPtZ7wmPAPMDgy
	WJ1jHZYudPtnZ0skjZXKekspuDYuQqxtVa14TH21WLC82bPwgzG81gbo16HiDgS9P98gE7Mcemq
	E1lvKGTmINQ1mrx1+tvtx8lWeaDy4USIqOXPoNneuADLrEXOsj5uBbecvrBIEWejZbdXKYZ/OX9
	vgYL8TSnx4G8xmKiQQeJPOhxc=
X-Received: by 2002:a17:907:7203:b0:c25:cb9c:2e3 with SMTP id a640c23a62f3a-c260c65e02amr1225949866b.4.1788878516373;
        Tue, 08 Sep 2026 07:41:56 -0700 (PDT)
Received: from Desktop (pd951346e.dip0.t-ipconnect.de. [217.81.52.110])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d503f96sm626682366b.26.2026.09.08.07.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 07:41:55 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: johannes@sipsolutions.net
Cc: toke@toke.dk,
	nbd@nbd.name,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2] wifi: mac80211: don't reset the TXQ scheduling round number
Date: Tue,  8 Sep 2026 16:41:55 +0200
Message-ID: <20260908144155.756569-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A round is ended when ieee80211_next_txq() meets a txq whose remembered
round number is the current one, meaning it has gone full circle.

When the AC exceeds the airtime limit, ieee80211_txq_schedule_start()
sets the round number to 0 to close the round. The next open round is
1. A txq from an earlier round 1 still remembers the "1", so the next
round stops on it and serves nothing.

Fix: use a separate open/closed flag and let the round number keep
counting.

Testing: ~4200 skipped selections per 20s without the fix and 20
skipped selections per 20s with the fix on ath11k (with my AQL series
applied) at BE 500/1000.

Fixes: 8e4bac067105 ("wifi: mac80211: add a per-PHY AQL limit to improve fairness")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
v2: rewrote the message
v1: https://lore.kernel.org/linux-wireless/20260908135224.754049-1-julius@bairaktaris.de/

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

