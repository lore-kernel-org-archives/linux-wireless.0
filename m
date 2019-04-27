Return-Path: <SRS0=RVLw=S5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93180C43218
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 20:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F9ED20881
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 20:42:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cjyFJDsM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfD0UmG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Apr 2019 16:42:06 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38516 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfD0UmG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Apr 2019 16:42:06 -0400
Received: by mail-lf1-f65.google.com with SMTP id v1so5026733lfg.5;
        Sat, 27 Apr 2019 13:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cek2BPsyemoobXtnf84GWRhFmCw+wiqw2q5/tlFdlI4=;
        b=cjyFJDsM83WaapP0t10hBEOsqjwNVVmWAiD74gpArmBAzhaqiGOlD3GBaBPXW5aho3
         o5GlzKm5x1lgWF/kZDuedDcq/VNaTwOX3oB4pNaXAiuKNM8MiJIKwBoNw3mK51H4WBPx
         5kaouuh5WO4qhCFvdCmF1nAOFQYBW5I1xxAxs0Pa3rlEjc8o6kym1xOqY5nnS9ACsmfR
         P8LfIxd5CM12yLhtQnausbTjezzMaDsh0ZlzXoIOJsPT7qWvEJ+xVXCJ9W57z1F4yWuB
         +SeuY+JjBUBbp1i/QD0Wu9MWdd9FYtVYihpSCDxTJXgVwGFjafRnCxUYmOxgRmPzJmp9
         NfNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cek2BPsyemoobXtnf84GWRhFmCw+wiqw2q5/tlFdlI4=;
        b=hNbABkLhs0dFCnoEwlKG2sCyG6AuF1+GtN8mVifbcYo4q80NvwO1ahzcESK5f2/9k3
         f6F6g0U2eGZIYJYZD8mJsXHfXgdXW7g8bCeka7bmufpIT5WuyNdrDn1XyFVoGeE0QMty
         44zFzpXUvjJ3tPruAstS6HswE9ORYjbX9xz8cRK/FYOcMXGKeaPDkYPWFkFkDLO6bhgi
         yDH//prk/gpAv+IgQdkaQk7t5UcPfDUMDqMSc+TYoUGe/NfvWRdkDDPmkD1ps5Md6Leu
         wCw5JMDfgf4DLBpbNLDBhbnOj7WzK7yops9Uo+lBSKRdHtlBk72Rw3wMiwWpWEPL9Djp
         igoQ==
X-Gm-Message-State: APjAAAVrREWxUvQlV/sq8KmyiZW9DvoHiwdzWLNqXWaQZjJaWGC5DX8U
        e8zdkuzRuD0i/U79L7Qi0efG2XgiOKk=
X-Google-Smtp-Source: APXvYqxz2g8/RVp55bYxiMwGZcdT70Ucl5OdqydYDbMaW2Al5pvBkSuKj3WNLhae8ji8fiQWKNLiNw==
X-Received: by 2002:ac2:48bb:: with SMTP id u27mr3938534lfg.17.1556397722946;
        Sat, 27 Apr 2019 13:42:02 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id v28sm6504716lfi.33.2019.04.27.13.42.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Apr 2019 13:42:02 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH] mac80211: fix possible deadlock in TX path
Date:   Sat, 27 Apr 2019 22:41:55 +0200
Message-Id: <20190427204155.14211-1-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch fixes a possible deadlock when updating the TX statistics
(when calling into ieee80211_tx_stats()) from ieee80211_tx_dequeue().

ieee80211_tx_dequeue() might be called from process context.

Since we take a lock without softirq's disabled when updating the TX
statistics (u64_stats_update_begin() takes a lock), there is a risk that
we get an interrupt while in the write critical section (after the call
to u64_stats_update_begin() and before u64_stats_update_end()).

We could then have a softirq (in interrupt context) when the interrupt
exits. The softirq can then end up taking the same lock resulting in a
deadlock of a CPU.

By using the _irqsave and _irqrestore versions of u64_stats_update_begin,
we make sure softirq's are disabled in the critical write section.

This issue was reported by lockdep (see splat below).
In this case lockdep has detected a potential scenario where
ieee80211_tx_dequeue() is called from a threaded IRQ (SDIO IRQ thread).

The thread could be interrupted and a softirq also calling
ieee80211_tx_dequeue() could get scheduled while the lock is held.

================================
WARNING: inconsistent lock state
5.1.0-rc6-wt-ath+ #34 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
irq/64-mmc0/120 [HC0[0]:SC0[0]:HE1:SE1] takes:
2bf4fbe3 (&syncp->seq#4){+.?.}, at: ieee80211_tx_dequeue+0x30c/0xb9c
{IN-SOFTIRQ-W} state was registered at:
  lock_acquire+0xd0/0x1f4
  ieee80211_xmit_fast_finish+0xa8/0x2b4
  ieee80211_tx_dequeue+0x30c/0xb9c
  ath10k_mac_tx_push_txq+0x78/0x2a4 [ath10k_core]
  ath10k_mac_op_wake_tx_queue+0xb0/0xbc [ath10k_core]
  ieee80211_queue_skb+0x2e0/0x4c4
  __ieee80211_subif_start_xmit+0x6c4/0xc4c
  ieee80211_subif_start_xmit+0x4c/0x414
  dev_hard_start_xmit+0xd8/0x37c
  __dev_queue_xmit+0xcd0/0xe40
  dev_queue_xmit+0x1c/0x20
  neigh_resolve_output+0x15c/0x21c
  ip6_finish_output2+0x200/0xd68
  ip6_finish_output+0x124/0x2c8
  ip6_output+0x80/0x480
  mld_sendpack+0x340/0x7ec
  mld_ifc_timer_expire+0x1dc/0x2fc
  call_timer_fn+0xd0/0x33c
  expire_timers+0xe0/0x1ac
  run_timer_softirq+0xfc/0x1e4
  __do_softirq+0xf8/0x54c
  irq_exit+0x13c/0x190
  handle_IPI+0x120/0x3d4
  gic_handle_irq+0xb8/0xcc
  __irq_svc+0x70/0x98
  cpuidle_enter_state+0x188/0x5e4
  cpuidle_enter+0x24/0x28
  call_cpuidle+0x30/0x4c
  do_idle+0x230/0x2d0
  cpu_startup_entry+0x28/0x2c
  secondary_start_kernel+0x164/0x1ac
  0x10102b0c
irq event stamp: 90887157
hardirqs last  enabled at (90887157): [<c013417c>] __local_bh_enable_ip+0xb4/0x18c
hardirqs last disabled at (90887155): [<c0134130>] __local_bh_enable_ip+0x68/0x18c
softirqs last  enabled at (90887156): [<c0cb4444>] ieee80211_tx_dequeue+0x24c/0xb9c
softirqs last disabled at (90887152): [<c0cb4248>] ieee80211_tx_dequeue+0x50/0xb9c

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&syncp->seq#4);
  <Interrupt>
    lock(&syncp->seq#4);

 *** DEADLOCK ***

1 lock held by irq/64-mmc0/120:
 #0: e6439974 (rcu_read_lock){....}, at: ath10k_mac_tx_push_pending+0x48/0x2e0 [ath10k_core]

stack backtrace:
CPU: 0 PID: 120 Comm: irq/64-mmc0 Not tainted 5.1.0-rc6-wt-ath+ #34
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Backtrace:
[<c010ecec>] (dump_backtrace) from [<c010efec>] (show_stack+0x20/0x24)
 r7:00000000 r6:60010093 r5:00000000 r4:c14ea35c
[<c010efcc>] (show_stack) from [<c0cfaef4>] (dump_stack+0xdc/0x114)
[<c0cfae18>] (dump_stack) from [<c01867f0>] (print_usage_bug+0x1f4/0x2f0)
 r10:d2890000 r9:ff7b9c24 r8:c1415100 r7:c10ca668 r6:00000004 r5:c1994c58
 r4:d2890000 r3:fe066f04
[<c01865fc>] (print_usage_bug) from [<c0186a94>] (mark_lock+0x1a8/0x708)
 r8:00000004 r7:00000004 r6:d2890000 r5:00000006 r4:d2890518
[<c01868ec>] (mark_lock) from [<c01872bc>] (__lock_acquire+0x250/0x1fa4)
 r10:d2890000 r9:ff7b9c24 r8:00000004 r7:d2890518 r6:00000000 r5:00000001
 r4:00000420
[<c018706c>] (__lock_acquire) from [<c0189810>] (lock_acquire+0xd0/0x1f4)
 r10:c1414970 r9:00000000 r8:00000000 r7:00000000 r6:ff7b9c24 r5:00000000
 r4:60010013
[<c0189740>] (lock_acquire) from [<c0cb190c>] (ieee80211_xmit_fast_finish+0xa8/0x2b4)
 r10:ff7b9c24 r9:c0cb4504 r8:00000001 r7:00000000 r6:d2d60000 r5:d2f1a900
 r4:ff7b9c00
[<c0cb1864>] (ieee80211_xmit_fast_finish) from [<c0cb4504>] (ieee80211_tx_dequeue+0x30c/0xb9c)
 r10:d2f1a900 r9:d2d607a4 r8:d2cf20dc r7:d330b29c r6:d2cf2000 r5:d2c342ba
 r4:d2899d3c
[<c0cb41f8>] (ieee80211_tx_dequeue) from [<bf057f64>] (ath10k_mac_tx_push_txq+0x78/0x2a4 [ath10k_core])
 r10:d2d607cc r9:d2fe06a0 r8:00000000 r7:d2fe1e30 r6:d2fe1d38 r5:d2fe1540
 r4:d2cf20dc
[<bf057eec>] (ath10k_mac_tx_push_txq [ath10k_core]) from [<bf058364>] (ath10k_mac_tx_push_pending+0x1d4/0x2e0 [ath10k_core])
 r10:d2cf20dc r9:bf0582b4 r8:bf0b1dba r7:00000002 r6:c1429994 r5:00000000
 r4:d2fe06a0
[<bf058190>] (ath10k_mac_tx_push_pending [ath10k_core]) from [<bf0e25a4>] (ath10k_sdio_irq_handler+0x30c/0x4d8 [ath10k_sdio])
 r10:00005b5a r9:d2fcc040 r8:00180201 r7:d2fe6540 r6:d2fe6a7c r5:00000000
 r4:d2fe1540
[<bf0e2298>] (ath10k_sdio_irq_handler [ath10k_sdio]) from [<c08e9d20>] (process_sdio_pending_irqs+0x4c/0x1bc)
 r10:d288cb00 r9:d229f400 r8:00000001 r7:00000000 r6:d27fe800 r5:c1414948
 r4:d27f3000
[<c08e9cd4>] (process_sdio_pending_irqs) from [<c08e9edc>] (sdio_run_irqs+0x4c/0x68)
 r10:d288cb00 r9:d229f400 r8:00000001 r7:00000000 r6:d27f36a0 r5:00000100
 r4:d27f3000
[<c08e9e90>] (sdio_run_irqs) from [<c08f5360>] (sdhci_thread_irq+0x80/0xbc)
 r5:00000100 r4:d27f34c0
[<c08f52e0>] (sdhci_thread_irq) from [<c019a648>] (irq_thread_fn+0x2c/0x88)
 r7:00000000 r6:d288cb24 r5:d229f400 r4:d288cb00
[<c019a61c>] (irq_thread_fn) from [<c019a984>] (irq_thread+0x120/0x22c)
 r7:00000000 r6:d288cb24 r5:ffffe000 r4:00000000
[<c019a864>] (irq_thread) from [<c0155214>] (kthread+0x154/0x168)
 r10:d2101bd8 r9:c019a864 r8:d288cb00 r7:d2898000 r6:d288cb40 r5:d2198600
 r4:00000000
[<c01550c0>] (kthread) from [<c01010b4>] (ret_from_fork+0x14/0x20)
Exception stack(0xd2899fb0 to 0xd2899ff8)
9fa0:                                     00000000 00000000 00000000 00000000
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
 r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c01550c0
 r4:d288cb40

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 net/mac80211/tx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8037384fc06e..b033fbf1d1cd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -44,12 +44,13 @@
 
 static inline void ieee80211_tx_stats(struct net_device *dev, u32 len)
 {
+	unsigned long flags;
 	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
 
-	u64_stats_update_begin(&tstats->syncp);
+	flags = u64_stats_update_begin_irqsave(&tstats->syncp);
 	tstats->tx_packets++;
 	tstats->tx_bytes += len;
-	u64_stats_update_end(&tstats->syncp);
+	u64_stats_update_end_irqrestore(&tstats->syncp, flags);
 }
 
 static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
-- 
2.19.1

