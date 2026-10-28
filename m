Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197451;
	b=Iejq9BOxeT8omcX+NZFhd0mkAE+UshoXfbAKAtYrbLYcgMrhO5HxDPriyC80/pCS1hVD
	 LMwAyfmUpW97jKdflXaHj1om1qjfCaH1eF+3syUb02nNo9HUFTIGg6Ir6OmBnj0uEihRp
	 SlVvH1z+hx4qjZa/q4OuD6EJfyDdvnzzuVYzUxsr9nCPekZncvvEnWsx+wLa/9SGJFYKQ
	 WgsyNUatH8VGwLJ4xhltVuHGEM3Ws+iRd21etNOEAAt+bKKHgCAKpKo23U1Hk0ZMuyq+g
	 WB2YcR2GVWZDK8iCJa9GNrbRG6c9hF++tc7ArhaDc1Zrvs5HrlnCDxwBUmlMS+LlslA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197451;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=660T/j6szyMYX2cJqw9EXFv5X7NWkuG7benZxmM9Szs=;
	b=5NxWGmqzCJ7uoWlm6TyaTTAzOdRxn/XgsRXyuaW7lmDlJhMvZTa+T/V2nt+EtBGQgj1z
	 E2+siZFYTrHPghny5oKXVKey0Oh9RsWEQts7vJHxraCAgZxjOAcrqWw3UI+qZaR6Q+kIb
	 Fza0d3UDtXYr9BnLuLABr2O4p63L84D+tdDk2JlQqYghan0OFG6mIbMUVjcCX19LQ6Rxo
	 lKyrVdE6wc7DiUs7zXE/xt5odbJnvfFpEZNeYy83a3Bo+yPJBJ89mpEnWGjkGkUsZyWCj
	 JI30Af/ChqkN4AjT0YdZ6+09RAqXZSc/Pyeo3h89h99oGzH+Og2eUYTsS6yaZv/MnHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zK61OYZt;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE5760A2639
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:24:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DE5760A2639
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zK61OYZt
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ab60ff4273so921499a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197450; x=1793802250; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=660T/j6szyMYX2cJqw9EXFv5X7NWkuG7benZxmM9Szs=;
        b=zK61OYZtAVgUCp/JFTqhE9re+jZLYZst9EUpWbl9zk1eujT9d1ZBBnpgroXqL8alrm
         vCTMNJvWzRGWLgH8nl5dawueHJAUKLpWjikU19XJIrKTlivQVSU/9cqQd1arr4n7P1AZ
         r1GE4hTVEZw2UCNNl3ou1VHlgCqsKQRZt7sLBq3y//fQM6dBIPV0Py0Ebb2ApHw0qHLM
         Fw9HSxv+D1xui+An2+t5y3LLkjyd7E+thRSu7wQ0DX7TfdApyBv0+cUMb2Zn0ot/wXxA
         wToMV59t3vLN0Vw/t6CaCZ1B33Fv9QMyV2aeHMlnmDZnHRe6D8v6vQ1CemQhX4tcmpJf
         7txQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197450; x=1793802250;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=660T/j6szyMYX2cJqw9EXFv5X7NWkuG7benZxmM9Szs=;
        b=kAtcjTcm4mbgXtBDIbpg/tdVT4svLTqP9Barvlq1Y+QzOmRwRxL+8EIJEzys/Tepcj
         Tvybstcpwr0Pptxs7rwQ8W8x9japiikwawXVj8/q2TPi8O7skOT1wYnpN68gr0kx7hBF
         wfaSRkifxneRcecyQWZ0615dN+N7apwmJMkR3VP+d0rj2TpnSVca/cPfJ0IgkBswJnJE
         9MBIyH6C6PojVcdQf9xThJ7eq/S4gvkNdUcWu811lpMGm0g8pL5OO9rhEfBgZq6zIc+4
         bCWniaxZJVsn5LM5ofYBkvT9iryaHDUSu9A6QukQNW/n8Vxq5+OTaZJxvDHiS7d0z+3n
         JHdQ==
X-Forwarded-Encrypted: i=1; AKwUvBz6nDerEV2C8A5tbhrJMQfer1hZwDYqLZ6lv3ZOJa2L0PNqtiGGJGCzJoJC2heaOvKuW1R0CZiMU6klzCu76g==@vger.kernel.org
X-Gm-Message-State: AFq9FYK2dydKA/65pHmKTGJp8A+OWrKr+fqsf623SRgshrvlzOr0Cox1
	wu1T/ncztYX/eBEiyHJn8OGu0h6yIpzgA1IlKcUWmRdJY/Y/YdNtMRUe
X-Gm-Gg: AYBFou3479R7k5KYrE3q2739RaXVw4uFWoGWvKpVUq/HUFV9Ljp6VEXtSJvIMQPRnmc
	TqTkEGujFaTCqZcIZrYHrrg/84ykvi3GucM47X78rg2s9RPmFyfRetR1q0R7y+4LQn6HVsZse+h
	GAwp5mHQTsj9GQmIRLj+dE3gTrAD+9HsZNZzThSGIZOuigCGFO/k0lrh1Bw7GHJJH1o0FSHjfbE
	MzJVdggKypzvaPQPOpEWKPpRHUpPZc9B5PvsIVvlqHE9LSaRI0o19ksWOCFUjovyFGQ0ZCTbR8H
	k3BmGTOqiVYMUBKri6uGJo7/1hiVZYKeYAs0FYI5L6W21FMFXLlGCS/UpTOTRzQhr2xM33uBnRP
	0gBA3RW6Tuv3bhIihpmyL9tKPgwcZSWsTEENIC/ZHRtiIkLlxRNz4pCX08LgaXL5QXw+jRG5rci
	3vM7uI4ktUev7B4PwjxL5bICsc0c3aTvNNS0ba7RzzLb9pnC5Xpy9U4ssJKzZ3w7yCrzTbPz8Fw
	9EHEDFcu+Oz1jGSujGeLRZ701xn6+IoN58zFW/zu9YqCcxXtwPyvVHx4+x5HVG6P1z4nR6Lsenl
	LVKFKhvq88Gsq/RxxuFYqSuxXu/e3ExGdj7YC3bwOKuH14LXJxEE4hf+d2ToAgkzlcUb
X-Received: by 2002:a17:90b:4a4b:b0:3aa:6b5d:a02e with SMTP id 98e67ed59e1d1-3ae58318a19mr1972701a91.54.1793197449365;
        Wed, 28 Oct 2026 07:24:09 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a48c2d3sm3324593a91.5.2026.10.28.07.24.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:24:09 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: stable@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.10.y] wifi: mac80211: shut down RX BA session timer on teardown
Date: Wed, 28 Oct 2026 22:23:49 +0800
Message-ID: <20261028142349.19894-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit e588e83e5c7a0f6d7a77dbbb58927c8c8cfd598e upstream.

Tearing down an RX BA session while a BlockAckReq frame is being
processed can rearm the session timer after teardown deletes it. A later
expiry then accesses the freed tid_rx state.

___ieee80211_stop_rx_ba_session() uses del_timer_sync() before RCU
readers have finished with tid_rx. del_timer_sync() does not prevent a
concurrent ieee80211_rx_h_ctrl() reader from calling mod_timer()
afterward.

Mark tid_rx removed under reorder_lock before deleting the timers, and
serialize the BAR removed check and mod_timer() call with the same lock.

This differs from the upstream commit, which uses timer_shutdown_sync()
instead. Linux 5.10 does not provide that helper.

LLM assistance was used to find the bug and review.

Fixes: a87f736d942c ("mac80211: use RCU for RX aggregation")
Cc: stable@vger.kernel.org # 5.10.x
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed on v5.10.272,
with no diagnostics beyond the baseline. A forced QEMU/KASAN interleaving
changed 9 use-after-free reports to 0 and produced no lockdep or
atomic-sleep splats. Natural race frequency was not measured. A reproducer
is available on request.
Sparse C=2 and targeted Smatch introduced no new diagnostics.

The affected files are identical in v5.10.270 and v5.10.272.
Equivalent fixes are present in 6.6.160, 6.12.113, 6.18.56 and 7.2.10;
adapted 5.15.y and 6.1.y backports were queued when reviewed.

 net/mac80211/agg-rx.c | 5 ++---
 net/mac80211/rx.c     | 5 +++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 6ef8ded4ec76..b23ff9793fac 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -103,12 +103,11 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	if (!tid_rx)
 		return;
 
-	del_timer_sync(&tid_rx->session_timer);
-
-	/* make sure ieee80211_sta_reorder_release() doesn't re-arm the timer */
+	/* Prevent BAR and reorder release from rearming the timers. */
 	spin_lock_bh(&tid_rx->reorder_lock);
 	tid_rx->removed = true;
 	spin_unlock_bh(&tid_rx->reorder_lock);
+	del_timer_sync(&tid_rx->session_timer);
 	del_timer_sync(&tid_rx->reorder_timer);
 
 	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8ec630a4d069..c7504dff7b4b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3101,12 +3101,13 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
 		event.u.ba.ssn = start_seq_num;
 		event.u.ba.sta = &rx->sta->sta;
 
+		spin_lock(&tid_agg_rx->reorder_lock);
+
 		/* reset session timer */
-		if (tid_agg_rx->timeout)
+		if (tid_agg_rx->timeout && !tid_agg_rx->removed)
 			mod_timer(&tid_agg_rx->session_timer,
 				  TU_TO_EXP_TIME(tid_agg_rx->timeout));
 
-		spin_lock(&tid_agg_rx->reorder_lock);
 		/* release stored frames up to start of BAR */
 		ieee80211_release_reorder_frames(rx->sdata, tid_agg_rx,
 						 start_seq_num, frames);

base-commit: aca95a35f1bcc0626c4fa4d1252bf2d4c990a1a2
-- 
2.56.0

