Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793663771;
	b=c9eRqWfZomwwPoFyJJSd65B7Yf58pUsQ6K0HlDDyP2TdqpcEKQ52ckyUwjSfxHjpMXX4
	 HOhBVQN3Bfn58efVZVKUlUkSaRHRgcrwgy/DdHofx+twlc/aSOGxW384xsKBdyFBEc1OC
	 SGu7c2WbRYAotd2Y+TnjhnLv5dBc8hoYI+VKaOQ7f+J7Y9OgMWA1DdtKcGHqCvi1E8Crq
	 M+q1eeiiRMaxDXx/+MRJqDb9DhXmdMWx1mcVEvxgNPLt60XSaYFF22eRyiwA0ev2ENvZl
	 aXgL4MhPzVOMK/cc0UIUYE3A5vggy2V3YsSCl7ezLV8XQy/1Bg6JPzrI0REcmU5k0Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793663771;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=hwCD2FnrSRm99CA0kXbahxZy9i6Gor92XeClnh3FOvA=;
	b=UKOAvW7eWAPJrPLzNIoNY5GPexDJQ41peub0pIRXYxUDAbBG6PILV4RbQfKHSXE6ehhw
	 47xFDd2vUsn3P1mJpTAJ81bNCFYfcT5oijaCL+zffMhb8HSmwCMzPFArXuarXQOfpqpW+
	 XwxjX75dUmuBLiRXP00vDssMewnk/46nCRbOJkXkPvLXVZTWZVhZInJNte+H5xPoPPc5F
	 DKf3VMdf/3x6ZTzRT/md560sNJkU8qGTf9lCpeD88s0d6POpPdmegwRJ2RihluQbPhdu1
	 nX3NQyg39JDh4L2BMT11MtBwuloM63NteiTUepu6hQhQWWzxBMZCkKGBKk+n7K6EDxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=dGrHsdRT;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA61606A33B
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 23:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=dGrHsdRT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=hwCD2FnrSRm99CA0kXbahxZy9i6Gor92XeClnh3FOvA=;
	t=1793663771; x=1794873371; b=dGrHsdRTvRkBZwTVQYQWQ9RMLcxjtxDqURDDKQOWVzTSDCb
	EMJFpbY1YJk8uyiSFevS/1WRBKVnJAkfFmdc8yijjU0b8D4zj2Rb9F9A94CFPobCQhLEtRekyPy12
	P/PgxEqgYGNg7kvjetUPanUz2YsXM9E6YmG6Xumv2RnC7Jv2zgVrUbuAci5sDXDXn4nyeg7D+0vIY
	9XMu6PnZfhJnFK9iTJwnJyLsLWuZHr144fQlpjvLf2ah4sgGtRRs+sz6cSqbpsm1y9JswX/IprPTZ
	/6FIh0rZpZGKbTmZRh6mGqJ+OCsBib9cRXD+XcTzwd6BMwRh2hG80FYzYvi7xicA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO1sm-00000002AZf-3Ut3;
	Tue, 03 Nov 2026 00:56:09 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 4/7] wifi: cfg80211: add wiphy_rcu_work
Date: Tue,  3 Nov 2026 00:54:01 +0100
Message-ID: <20261102235603.1181883-13-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102235603.1181883-9-johannes@sipsolutions.net>
References: <20261102235603.1181883-9-johannes@sipsolutions.net>
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

From: Johannes Berg <johannes.berg@intel.com>

Add a wiphy work variant that's run after an RCU grace period
has elapsed since queueing. This allows splitting operations
more easily that need to release/free something under wiphy
mutex, but would otherwise synchronize_rcu() with it held.

The implementation uses get_state_synchronize_rcu_full() to
know which item needs to wait for how long still.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |  60 +++++++++++++++++
 net/wireless/core.c    | 148 ++++++++++++++++++++++++++++++++++++++++-
 net/wireless/core.h    |   6 +-
 3 files changed, 212 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 516f6fa591fe..0fe35206a755 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7222,6 +7222,66 @@ void wiphy_hrtimer_work_flush(struct wiphy *wiphy,
 bool wiphy_hrtimer_work_pending(struct wiphy *wiphy,
 				struct wiphy_hrtimer_work *hrwork);
 
+struct wiphy_rcu_work {
+	struct wiphy_work work;
+	struct list_head rcu_entry;
+	struct rcu_gp_seq rcu_state;
+};
+
+static inline void wiphy_rcu_work_init(struct wiphy_rcu_work *rwork,
+				       wiphy_work_func_t func)
+{
+	INIT_LIST_HEAD(&rwork->rcu_entry);
+	wiphy_work_init(&rwork->work, func);
+}
+
+/**
+ * wiphy_rcu_work_queue - queue work for the wiphy after an RCU grace period
+ * @wiphy: the wiphy to queue for
+ * @rwork: the RCU worker
+ *
+ * Queue the work to run (with the wiphy mutex held, see wiphy_work_queue())
+ * after a full RCU grace period has elapsed since this call. If the work is
+ * already pending do nothing. If a new grace period were needed, the caller
+ * has to handle that, e.g. by calling wiphy_rcu_work_cancel() first.
+ *
+ * This can be used to split operations that would need to synchronize_rcu()
+ * with the wiphy mutex held, but of course state may disappear without the
+ * mutex held.
+ *
+ * Can be called from any context.
+ *
+ * Return: %true if the work was queued, %false if it was already pending,
+ *	in which case it may run before a grace period relative to this call
+ *	has elapsed
+ */
+bool wiphy_rcu_work_queue(struct wiphy *wiphy, struct wiphy_rcu_work *rwork);
+
+/**
+ * wiphy_rcu_work_cancel - cancel previously queued RCU work
+ * @wiphy: the wiphy, for debug purposes
+ * @rwork: the RCU work to cancel
+ *
+ * Cancel the work *without* waiting for it or for an RCU grace period.
+ *
+ * Must be called with the wiphy mutex held.
+ */
+void wiphy_rcu_work_cancel(struct wiphy *wiphy, struct wiphy_rcu_work *rwork);
+
+/**
+ * wiphy_rcu_work_flush - run RCU work now if pending
+ * @wiphy: the wiphy
+ * @rwork: the RCU work to flush
+ *
+ * If the work is pending, wait for the RCU grace period it's waiting for
+ * (if it hasn't elapsed yet) and then run it immediately.
+ *
+ * Note: unlike wiphy_work_flush() this only runs the single work.
+ *
+ * Must be called with the wiphy mutex held.
+ */
+void wiphy_rcu_work_flush(struct wiphy *wiphy, struct wiphy_rcu_work *rwork);
+
 /**
  * enum ieee80211_ap_reg_power - regulatory power for an Access Point
  *
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f4153c249599..2838836552be 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -705,6 +705,7 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	spin_lock_init(&rdev->mgmt_registrations_lock);
 	INIT_WORK(&rdev->wiphy_work, cfg80211_wiphy_work);
 	INIT_LIST_HEAD(&rdev->wiphy_work_list);
+	INIT_LIST_HEAD(&rdev->wiphy_rcu_work_list);
 	spin_lock_init(&rdev->wiphy_work_lock);
 
 #ifdef CONFIG_CFG80211_DEFAULT_PS
@@ -1330,6 +1331,37 @@ void wiphy_rfkill_start_polling(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(wiphy_rfkill_start_polling);
 
+static void cfg80211_wiphy_rcu_work_ready(struct cfg80211_registered_device *rdev,
+					  struct wiphy_rcu_work *rwork)
+{
+	lockdep_assert_held(&rdev->wiphy_work_lock);
+
+	list_del_init(&rwork->rcu_entry);
+	if (list_empty(&rwork->work.entry))
+		list_add_tail(&rwork->work.entry, &rdev->wiphy_work_list);
+}
+
+static void cfg80211_flush_wiphy_rcu_works(struct cfg80211_registered_device *rdev)
+{
+	struct wiphy_rcu_work *rwork, *tmp;
+	bool armed;
+
+	spin_lock_irq(&rdev->wiphy_work_lock);
+	if (!list_empty(&rdev->wiphy_rcu_work_list)) {
+		spin_unlock_irq(&rdev->wiphy_work_lock);
+		synchronize_rcu();
+		spin_lock_irq(&rdev->wiphy_work_lock);
+	}
+	list_for_each_entry_safe(rwork, tmp, &rdev->wiphy_rcu_work_list,
+				 rcu_entry)
+		cfg80211_wiphy_rcu_work_ready(rdev, rwork);
+	armed = rdev->wiphy_rcu_work_pending;
+	spin_unlock_irq(&rdev->wiphy_work_lock);
+
+	if (armed)
+		rcu_barrier();
+}
+
 void cfg80211_process_wiphy_works(struct cfg80211_registered_device *rdev,
 				  struct wiphy_work *end)
 {
@@ -1406,6 +1438,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 #endif
 
 	/* surely nothing is reachable now, clean up work */
+	cfg80211_flush_wiphy_rcu_works(rdev);
 	cfg80211_process_wiphy_works(rdev, NULL);
 	wiphy_unlock(&rdev->wiphy);
 	mutex_unlock(&cfg80211_mutex);
@@ -1440,7 +1473,9 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&rdev->wiphy_work_lock, flags);
-	WARN_ON(!list_empty(&rdev->wiphy_work_list));
+	WARN_ON(!list_empty(&rdev->wiphy_work_list) ||
+		!list_empty(&rdev->wiphy_rcu_work_list) ||
+		rdev->wiphy_rcu_work_pending);
 	spin_unlock_irqrestore(&rdev->wiphy_work_lock, flags);
 	cancel_work_sync(&rdev->wiphy_work);
 
@@ -2126,6 +2161,117 @@ bool wiphy_hrtimer_work_pending(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL_GPL(wiphy_hrtimer_work_pending);
 
+static void cfg80211_wiphy_rcu_work_cb(struct rcu_head *head)
+{
+	struct cfg80211_registered_device *rdev =
+		container_of(head, struct cfg80211_registered_device,
+			     wiphy_rcu_work_head);
+	struct wiphy_rcu_work *rwork, *tmp;
+	unsigned long flags;
+	bool ready = false;
+
+	spin_lock_irqsave(&rdev->wiphy_work_lock, flags);
+	list_for_each_entry_safe(rwork, tmp, &rdev->wiphy_rcu_work_list,
+				 rcu_entry) {
+		/* the list is in queueing order, so stop at the first one */
+		if (!poll_state_synchronize_rcu_full(&rwork->rcu_state))
+			break;
+		cfg80211_wiphy_rcu_work_ready(rdev, rwork);
+		ready = true;
+	}
+
+	if (ready)
+		queue_work(system_dfl_wq, &rdev->wiphy_work);
+
+	if (list_empty(&rdev->wiphy_rcu_work_list))
+		rdev->wiphy_rcu_work_pending = false;
+	else
+		call_rcu_hurry(&rdev->wiphy_rcu_work_head,
+			       cfg80211_wiphy_rcu_work_cb);
+	spin_unlock_irqrestore(&rdev->wiphy_work_lock, flags);
+}
+
+bool wiphy_rcu_work_queue(struct wiphy *wiphy, struct wiphy_rcu_work *rwork)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	unsigned long flags;
+	bool queued = false;
+
+	trace_wiphy_work_queue(wiphy, &rwork->work);
+
+	spin_lock_irqsave(&rdev->wiphy_work_lock, flags);
+	if (!list_empty(&rwork->rcu_entry) || !list_empty(&rwork->work.entry))
+		goto out;
+
+	queued = true;
+
+	get_state_synchronize_rcu_full(&rwork->rcu_state);
+	list_add_tail(&rwork->rcu_entry, &rdev->wiphy_rcu_work_list);
+	/* the work will requeue itself if needed, based on the ->rcu_state */
+	if (!rdev->wiphy_rcu_work_pending) {
+		rdev->wiphy_rcu_work_pending = true;
+		call_rcu_hurry(&rdev->wiphy_rcu_work_head,
+			       cfg80211_wiphy_rcu_work_cb);
+	}
+out:
+	spin_unlock_irqrestore(&rdev->wiphy_work_lock, flags);
+
+	return queued;
+}
+EXPORT_SYMBOL_GPL(wiphy_rcu_work_queue);
+
+void wiphy_rcu_work_cancel(struct wiphy *wiphy, struct wiphy_rcu_work *rwork)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	unsigned long flags;
+
+	lockdep_assert_held(&wiphy->mtx);
+
+	spin_lock_irqsave(&rdev->wiphy_work_lock, flags);
+	list_del_init(&rwork->rcu_entry);
+	spin_unlock_irqrestore(&rdev->wiphy_work_lock, flags);
+
+	wiphy_work_cancel(wiphy, &rwork->work);
+}
+EXPORT_SYMBOL_GPL(wiphy_rcu_work_cancel);
+
+void wiphy_rcu_work_flush(struct wiphy *wiphy, struct wiphy_rcu_work *rwork)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct rcu_gp_seq rcu_state;
+	bool wait, run;
+
+	lockdep_assert_held(&wiphy->mtx);
+
+	trace_wiphy_work_flush(wiphy, &rwork->work);
+
+	spin_lock_irq(&rdev->wiphy_work_lock);
+	wait = !list_empty(&rwork->rcu_entry);
+	run = wait || !list_empty(&rwork->work.entry);
+	rcu_state = rwork->rcu_state;
+	spin_unlock_irq(&rdev->wiphy_work_lock);
+
+	if (!run)
+		return;
+
+	/*
+	 * While pending it can't be requeued, it can't be canceled or run
+	 * (requires wiphy mutex), so still pending here. Synchronize if
+	 * needed and then run it after deleting it from the lists.
+	 */
+	if (wait)
+		cond_synchronize_rcu_full(&rcu_state);
+
+	spin_lock_irq(&rdev->wiphy_work_lock);
+	list_del_init(&rwork->rcu_entry);
+	list_del_init(&rwork->work.entry);
+	spin_unlock_irq(&rdev->wiphy_work_lock);
+
+	trace_wiphy_work_run(wiphy, &rwork->work);
+	rwork->work.func(wiphy, &rwork->work);
+}
+EXPORT_SYMBOL_GPL(wiphy_rcu_work_flush);
+
 static int __init cfg80211_init(void)
 {
 	int err;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 729f6f4aa3a8..bc9c3c1456d5 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -136,7 +136,11 @@ struct cfg80211_registered_device {
 
 	struct work_struct wiphy_work;
 	struct list_head wiphy_work_list;
-	/* protects the list above */
+	/* RCU works waiting for a grace period, in queueing order */
+	struct list_head wiphy_rcu_work_list;
+	struct rcu_head wiphy_rcu_work_head;
+	bool wiphy_rcu_work_pending;
+	/* protects the lists and pending flag above */
 	spinlock_t wiphy_work_lock;
 	bool suspended;
 
-- 
2.56.0

