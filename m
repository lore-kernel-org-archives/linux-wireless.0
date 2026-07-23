Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6C43612F6;
	Thu, 23 Jul 2026 11:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806781; cv=none; b=Bxj1hv/cTS/ar7q68TE66PuBQ03xjZeJGAeA1C5OLW686zg05W/pnz/9JDlSPqv4e3R4Op+9Pf8tR8sGfKs30spmmxXHlAUYSZvzRrAEMPd9DfgIQ6mdI95eOUcZUbQOfsEFN+3QNMu/e9p4dP5VS+eZGPfd45SDjyEJ0wUzgL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806781; c=relaxed/simple;
	bh=575TBu6W2+tCfGbckTNcNd0wohcBX07RjBlg1Xg27ek=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JURukIOgi5CPVkGcYj+a0ie9/z/1bozx1HQDMnH/FmhvuHG2kjhh73vb7zHbdXaNxlVL0Io6mrDWIssqYC8KavenKZqN+0fpy5ilACq0ZozIHLVcXgqqMxNEv1Mk1GaODuutCl9UE2KSMTmwrYj3SSZE41fps3WTWWg/WOf1he8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2bd985d4868b11f1aa26b74ffac11d73-20260723
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:bcb6bdb2-3946-4ab7-ad6c-c8e6bb8310c5,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:e7bac3a,CLOUDID:cf0cbd2d3325b150b81db5541750b712,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2bd985d4868b11f1aa26b74ffac11d73-20260723
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1811612323; Thu, 23 Jul 2026 19:39:31 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Arien Judge <arien.judge@morsemicro.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH v2] wifi: mm81x: prevent timers from outliving teardown
Date: Thu, 23 Jul 2026 19:39:27 +0800
Message-Id: <20260723113927.2370301-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260723092357.2362744-1-lilinmao@kylinos.cn>
References: <20260723092357.2362744-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The three timer teardown paths call timer_delete_sync_try() and ignore
its return value. If a callback is running on another CPU it returns -1
without waiting, and it does not prevent a later rearm even when it does
deactivate a pending timer. mm81x_skbq_tx_complete() can rearm the
stale-status timer, and the rc and yaps callbacks queue work that rearms
their timers. Teardown can therefore continue with a callback still
running or the timer rearmed, so it fires after the associated state has
been freed.

Use timer_shutdown_sync() for these permanent teardowns: it waits for an
in-flight callback and prevents any future rearm. In mm81x_rc_deinit()
shut the timer down before cancel_work_sync() so the work can no longer
recreate the timer/work cycle.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
v2:
- reword the subject to describe the fix (Lachlan Hodges)

 drivers/net/wireless/morsemicro/mm81x/mac.c  | 2 +-
 drivers/net/wireless/morsemicro/mm81x/rc.c   | 2 +-
 drivers/net/wireless/morsemicro/mm81x/yaps.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 392dae5d7ce9..08ca116a68b4 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -2349,7 +2349,7 @@ static void mm81x_stale_tx_status_timer(struct timer_list *t)
 
 static void mm81x_stale_tx_status_timer_finish(struct mm81x *mors)
 {
-	timer_delete_sync_try(&mors->stale_status.timer);
+	timer_shutdown_sync(&mors->stale_status.timer);
 }
 
 static void mm81x_mac_stale_tx_status_timer_init(struct mm81x *mors)
diff --git a/drivers/net/wireless/morsemicro/mm81x/rc.c b/drivers/net/wireless/morsemicro/mm81x/rc.c
index 04aff66de4bd..28dd293df966 100644
--- a/drivers/net/wireless/morsemicro/mm81x/rc.c
+++ b/drivers/net/wireless/morsemicro/mm81x/rc.c
@@ -60,8 +60,8 @@ void mm81x_rc_init(struct mm81x *mors)
 
 void mm81x_rc_deinit(struct mm81x *mors)
 {
+	timer_shutdown_sync(&mors->mrc.timer);
 	cancel_work_sync(&mors->mrc.work);
-	timer_delete_sync_try(&mors->mrc.timer);
 }
 
 static void mm81x_rc_sta_config_guard_per_bw(struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/morsemicro/mm81x/yaps.c b/drivers/net/wireless/morsemicro/mm81x/yaps.c
index bdadb822bf9a..e98a2a58726f 100644
--- a/drivers/net/wireless/morsemicro/mm81x/yaps.c
+++ b/drivers/net/wireless/morsemicro/mm81x/yaps.c
@@ -597,7 +597,7 @@ static void mm81x_yaps_q_chip_full_timer_init(struct mm81x_yaps *yaps)
 
 static void mm81x_yaps_q_chip_full_timer_finish(struct mm81x_yaps *yaps)
 {
-	timer_delete_sync_try(&yaps->chip_queue_full.timer);
+	timer_shutdown_sync(&yaps->chip_queue_full.timer);
 }
 
 int mm81x_yaps_init(struct mm81x *mors)
-- 
2.25.1

