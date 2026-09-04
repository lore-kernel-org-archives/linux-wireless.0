Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC44F3E92BB
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 21:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788556952; cv=none; b=pBU4sjCpexgduY8IkSYQ80R/S6X243Yk/OEzgImRuDTynQwNpjDaV3lrlx6dHGV6oxuRj//fL6UD0DFWSUHYfcJ7/Dkj+QOLyJK9xIdcAOfjngyo1v97AK2YPQUjC1LJymYUTOHQ+TLwrBuGPaZqQu+o1acPl/bf06yRtPNr1vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788556952; c=relaxed/simple;
	bh=sAxci377fn8+FnyuNLAMrG/6nTy5cwTzjBUe0YrHgbw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k1cq0C8TkLB5yT4CCC8KZXRg8z/BtV/oKO9iThU2rdtCzTh113LXKeePbZWPggSxbEOEEZ09k8VFUkR/3EeqVp/zqCIX46Yg7RbW5U5pk6hB0kCDv+qc8K4/3gqCgXfAZ/9R5XNJ3atETtShpnA/x2zLwITZJuyIDsOZqXrwdKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UA3ujme3; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UA3ujme3"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc328b43a56so1310438a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 14:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788556950; x=1789161750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zDZS/yUUq6qUoww9Sgh++cO+lJPE83G9J2KfDK5Wa1w=;
        b=UA3ujme3JkDKYZCyllqcSLDJIV8YV8hes/pRUDbBGHf3PkfFZE2ezXXpzOp4E+ERw8
         6H6aRJBBeprBil7/pgqZ1+w1B+GCLOxDzJqp0gbEel27HXUQOvyAkm0PctWVsjQK7ZzU
         Hw3E462g9tSWoQ61SZ0/28ohkEshTzsqLxHCgqnp3Oh86+HVeeaR7Choad1g02TaBVps
         1AO7J4KuYUpchZ3S7V8iCtnREym3ytqqeUK80FZFyTFDF4nmSIJnm0ubWsBMc4uSjqos
         PXVixrbJP9HUeS9okVUjycGPSQlon7LrBt9o5aXYGDpUElF2LILVZPbpeVrghdVsbvPS
         h1aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788556950; x=1789161750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zDZS/yUUq6qUoww9Sgh++cO+lJPE83G9J2KfDK5Wa1w=;
        b=tVZByI4ZU2Zi3DgMGdVXtFrDtuUIz01aL6LQ0Dib26YhNH3h0kWlXDf4lWkCPox5Xb
         amScup2JKHnmHMIuCmR30Szq+I62mU8B9BqgdZnfBOQ1xSanx3JVuDfzzG0RTcD/IPBx
         r9G7ttcPQJHp4y1vybXI6vRjFDxRMXKHqXXxV520XB8KCUEUv3oFmPYCVIzAotzQIMy1
         PYuFwq+DlusNyXH9IriJimk8vJjtyg7DWc/njh68w5qWZSI1Ut7y1IRiWCa/5IozssuV
         0YmQBRVfKSrGOqqjLnpr561VuLZXz8gtdWnOMokwKQbVOUwuj49R7GlpODLsdPAZCKy5
         D7Vg==
X-Gm-Message-State: AFuF++kAzbZF78yRVkf3bajeLG+IVtUrGFKP7oQjnpkCEcMZ8rXiVTPZ
	Qy1b2AMUn2nLQX4syCKXDxjsYV+kSx44/ZeNp49j5Ook82MN+nBJuAaYZ1q9pQ==
X-Gm-Gg: AYBFou27MUtfax5Bs5gSgVAsidYce8hclghqXgMhd90Osu0fM6gXns+CAecnteRNAcc
	qUFS26oZz8G7cQRpOaiZV5MyyHjBABbzsBVWtHsWShqBrzO27htfV7t4LYd9WbaNFxHJEqZ644K
	qWJW4N2ii2otdn7TGE6SztWHr0spGfkusMcNQKnDrFSWZE2nhT8OlY+CVDOW6HWAGTdkvsXlrSk
	nVS+ALA34GoSfRhQVDHlnoh8Yy2aw2fHxIheyfPQn5AegjZO4jjxe4W+KJNwdzaSplDSQArQb6z
	TmU6ow+QE7nomvvQmqy/opvmLEmEy0TDN2NOfvn6lABXtGRwGv8ZQXPjSeR3hcf4zOvdacI5JIo
	hyfFbmF+sZxk6kbdQkRzsZbgeTlHd/F8AbjUttdqG6dWWxy5kPkbT3fsvdhklQ9JakstO1aZTTY
	Nguk0xKXg+YVintI81jsyfCcI78Zhf0qVaKVgRol5Xnyp4jxdJt2PgOXpNvIQF4kgAfO1jUHwNI
	azrSS52FMOnNzQnwBz4Dn5KY5WQgVnwV1boHnDkJ7nfR4qP+UKcvcAW1iT0L9zjv3DytQKPmk3p
	F0bXzLqhl12NHvCey19BSK/IUWSdoYB95UhP8AXW4sCUjejirA==
X-Received: by 2002:a17:90b:224c:b0:398:9bd5:490f with SMTP id 98e67ed59e1d1-39b2624cf31mr11476690a91.22.1788556949925;
        Fri, 04 Sep 2026 14:22:29 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc45542dbbesm1315056a12.13.2026.09.04.14.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 14:22:29 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH ath-next] ath9k: delete channel-context timers on deinit
Date: Fri,  4 Sep 2026 14:22:25 -0700
Message-ID: <20260904212225.84813-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath9k_deinit_channel_context() cancels chanctx_work but does not delete
the offchannel and sched timers set up by ath9k_init_channel_context().
If either timer fires after deinit (e.g. during driver unload or
suspend), it accesses sc->sc_ah which may already be freed by
ath9k_hw_deinit(), causing a use-after-free.

Delete both timers with timer_delete_sync() before cancelling the work
item.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 8b27d8cc086a..92241c24a0a4 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1363,6 +1363,8 @@ void ath9k_init_channel_context(struct ath_softc *sc)
 
 void ath9k_deinit_channel_context(struct ath_softc *sc)
 {
+	timer_delete_sync(&sc->sched.timer);
+	timer_delete_sync(&sc->offchannel.timer);
 	cancel_work_sync(&sc->chanctx_work);
 }
 
-- 
2.55.0

