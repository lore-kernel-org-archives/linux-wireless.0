Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA38D3793DF
	for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2026 22:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771884174; cv=none; b=l5UfbsEaNGSDO8J3UIkRN0iQ8LatKXlT57+z3lHdy8RirljRkbIuge2ikaldSTd5baU2ANm/rLo7g7QIDQvxWjvrK0nW6fLPdu0GEUwTsvpLFLCyL9qpx1g9NgOsqFjLbszxHzfnbAGreerun8IvFGf992+617Rf0IR+Y9SDIBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771884174; c=relaxed/simple;
	bh=3jSmph4A2N7yQxL96ij/BM7i+tiya0NcUMO9PHQotGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhTG9pq1+LaIzCly8Q/zhjWBTogO77HrHtD9G02EU1scjRHH+NhFVUzDtsaM4PBNJLAGDgwL2eFMtqQF6pahMXSO/1tTs1V8IuN7wP0BUfszjmmAcDwx+Xs4dxlCW4jg+L7dzjjjSWNyPLiIDOGO+5ma9s2QzGLmtt4GDZPuM80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GrMo0j4z; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GrMo0j4z"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771884172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EFLwmUr1cuLe9yVyWv2UD2BhxyCon9uyCsuitNP8gHs=;
	b=GrMo0j4zdk4QjIIJVcYUowrwpFi9lFIHlcLklxCUEJqJ67KaG4D5P9rETKGagoUzxLlyYA
	MOLJNRJj85TlMqxE1SUG5khkc2p4hdBHXfage0Uosl4qxaAueUWXh/GCscAR8DppYC+jxk
	oPw+DXJ53Sh8szgUlNta/ySaIn1gMnU=
From: Bart Van Assche <bart.vanassche@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jann Horn <jannh@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Eyal Reizer <eyalr@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 25/62] wlcore: Fix a locking bug
Date: Mon, 23 Feb 2026 14:00:25 -0800
Message-ID: <20260223220102.2158611-26-bart.vanassche@linux.dev>
In-Reply-To: <20260223220102.2158611-1-bart.vanassche@linux.dev>
References: <20260223220102.2158611-1-bart.vanassche@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Bart Van Assche <bvanassche@acm.org>

Make sure that wl->mutex is locked before it is unlocked. This has been
detected by the Clang thread-safety analyzer.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Eyal Reizer <eyalr@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Fixes: 45aa7f071b06 ("wlcore: Use generic runtime pm calls for wowlan elp configuration")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 17dd417756f2..1c340a4a0930 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1875,6 +1875,8 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		     wl->wow_enabled);
 	WARN_ON(!wl->wow_enabled);
 
+	mutex_lock(&wl->mutex);
+
 	ret = pm_runtime_force_resume(wl->dev);
 	if (ret < 0) {
 		wl1271_error("ELP wakeup failure!");
@@ -1891,8 +1893,6 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		run_irq_work = true;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
-	mutex_lock(&wl->mutex);
-
 	/* test the recovery flag before calling any SDIO functions */
 	pending_recovery = test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS,
 				    &wl->flags);
