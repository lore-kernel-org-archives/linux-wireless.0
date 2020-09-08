Return-Path: <SRS0=ylPz=CR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF1C4C433E2
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Sep 2020 21:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A9A320768
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Sep 2020 21:18:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="gUq+k0zm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbgIHVSL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Sep 2020 17:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730145AbgIHVSE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Sep 2020 17:18:04 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3996C061756
        for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2020 14:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qQplBoS+uux1QSeLr2sU6wTnhqBYSuUtXS7dh7l4fLw=; b=gUq+k0zms5SkcrKmWF/tFre0Df
        BK2e8fD1iNWtZgqHrVArUvLYnpEwM58AG7UTeuhO7AQLRbSwglqy1ijn48C7Qj0sBVAsihoGHbDmr
        v4VAWa5bIyHSUKgbbaubCf6vSj/U5BY8+E8rYxtOM2RMbknC9bWRh2DZ8nIS8u0Jkf4U=;
Received: from p4ff13fcb.dip0.t-ipconnect.de ([79.241.63.203] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kFl02-0002Cx-N5
        for linux-wireless@vger.kernel.org; Tue, 08 Sep 2020 23:17:58 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 04/11] mt76: add utility functions for deferring work to a kernel thread
Date:   Tue,  8 Sep 2020 23:17:49 +0200
Message-Id: <20200908211756.15998-4-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908211756.15998-1-nbd@nbd.name>
References: <20200908211756.15998-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In order to avoid keeping work like tx scheduling pinned to the CPU it was
scheduled from, it makes sense to switch from tasklets to kernel threads.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/util.c | 28 +++++++++
 drivers/net/wireless/mediatek/mt76/util.h | 76 +++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/util.c b/drivers/net/wireless/mediatek/mt76/util.c
index f53bb4ae5001..581964425468 100644
--- a/drivers/net/wireless/mediatek/mt76/util.c
+++ b/drivers/net/wireless/mediatek/mt76/util.c
@@ -110,4 +110,32 @@ int mt76_get_min_avg_rssi(struct mt76_dev *dev, bool ext_phy)
 }
 EXPORT_SYMBOL_GPL(mt76_get_min_avg_rssi);
 
+int __mt76_worker_fn(void *ptr)
+{
+	struct mt76_worker *w = ptr;
+
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		if (kthread_should_park()) {
+			kthread_parkme();
+			continue;
+		}
+
+		if (!test_and_clear_bit(MT76_WORKER_SCHEDULED, &w->state)) {
+			schedule();
+			continue;
+		}
+
+		set_bit(MT76_WORKER_RUNNING, &w->state);
+		set_current_state(TASK_RUNNING);
+		w->fn(w);
+		cond_resched();
+		clear_bit(MT76_WORKER_RUNNING, &w->state);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__mt76_worker_fn);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/util.h b/drivers/net/wireless/mediatek/mt76/util.h
index fd1a68820e0a..1c363ea9ab9c 100644
--- a/drivers/net/wireless/mediatek/mt76/util.h
+++ b/drivers/net/wireless/mediatek/mt76/util.h
@@ -10,6 +10,19 @@
 #include <linux/skbuff.h>
 #include <linux/bitops.h>
 #include <linux/bitfield.h>
+#include <net/mac80211.h>
+
+struct mt76_worker
+{
+	struct task_struct *task;
+	void (*fn)(struct mt76_worker *);
+	unsigned long state;
+};
+
+enum {
+	MT76_WORKER_SCHEDULED,
+	MT76_WORKER_RUNNING,
+};
 
 #define MT76_INCR(_var, _size) \
 	(_var = (((_var) + 1) % (_size)))
@@ -45,4 +58,67 @@ mt76_skb_set_moredata(struct sk_buff *skb, bool enable)
 		hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 }
 
+int __mt76_worker_fn(void *ptr);
+
+static inline int
+mt76_worker_setup(struct ieee80211_hw *hw, struct mt76_worker *w,
+		  void (*fn)(struct mt76_worker *),
+		  const char *name)
+{
+	const char *dev_name = wiphy_name(hw->wiphy);
+	int ret;
+
+	if (fn)
+		w->fn = fn;
+	w->task = kthread_create(__mt76_worker_fn, w, "mt76-%s %s",
+				 name, dev_name);
+
+	ret = PTR_ERR_OR_ZERO(w->task);
+	if (ret) {
+		w->task = NULL;
+		return ret;
+	}
+
+	wake_up_process(w->task);
+
+	return 0;
+}
+
+static inline void mt76_worker_schedule(struct mt76_worker *w)
+{
+	if (!w->task)
+		return;
+
+	if (!test_and_set_bit(MT76_WORKER_SCHEDULED, &w->state) &&
+	    !test_bit(MT76_WORKER_RUNNING, &w->state))
+		wake_up_process(w->task);
+}
+
+static inline void mt76_worker_disable(struct mt76_worker *w)
+{
+	if (!w->task)
+		return;
+
+	kthread_park(w->task);
+	WRITE_ONCE(w->state, 0);
+}
+
+static inline void mt76_worker_enable(struct mt76_worker *w)
+{
+	if (!w->task)
+		return;
+
+	kthread_unpark(w->task);
+	mt76_worker_schedule(w);
+}
+
+static inline void mt76_worker_teardown(struct mt76_worker *w)
+{
+	if (!w->task)
+		return;
+
+	kthread_stop(w->task);
+	w->task = NULL;
+}
+
 #endif
-- 
2.28.0

