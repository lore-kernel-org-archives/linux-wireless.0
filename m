Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46289 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab3LSUxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 15:53:39 -0500
Received: by mail-pd0-f176.google.com with SMTP id w10so1604319pde.35
        for <linux-wireless@vger.kernel.org>; Thu, 19 Dec 2013 12:53:39 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux@eikelenboom.it, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/3] cfg80211: processing regulatory requests on netdev notifier
Date: Thu, 19 Dec 2013 12:53:19 -0800
Message-Id: <1387486399-4053-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131219_215342_688722_79CA05BA)
In-Reply-To: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a trigger to review any pending regulatory
requests whenever an 802.11 device interface is brought
down or up. We use this as an opportunistic trigger
for checking the regulatory work queues as otherwise
they they're only checked upon an initial regulatory
request or when beacon hints are found.

This opportunistic mechanism can be used to trigger
kicking the queues regulatory queues at any time from
userspace without having to change the regulatory state.

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/core.c | 2 ++
 net/wireless/reg.c  | 5 +++++
 net/wireless/reg.h  | 1 +
 3 files changed, 8 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d89dee2..bc0f518 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -812,6 +812,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		SET_NETDEV_DEVTYPE(dev, &wiphy_type);
 		break;
 	case NETDEV_REGISTER:
+		reg_process_pending_work();
 		/*
 		 * NB: cannot take rdev->mtx here because this may be
 		 * called within code protected by it when interfaces
@@ -871,6 +872,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		wake_up(&rdev->dev_wait);
 		break;
 	case NETDEV_UP:
+		reg_process_pending_work();
 		cfg80211_update_iface_num(rdev, wdev->iftype, 1);
 		wdev_lock(wdev);
 		switch (wdev->iftype) {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ecf364e..1a049b3 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -196,6 +196,11 @@ static DECLARE_WORK(reg_work, reg_todo);
 static void reg_timeout_work(struct work_struct *work);
 static DECLARE_DELAYED_WORK(reg_timeout, reg_timeout_work);
 
+void reg_process_pending_work(void)
+{
+	schedule_work(&reg_work);
+}
+
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 6,
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 02bd8f4..063fb7a 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -36,6 +36,7 @@ void regulatory_exit(void);
 int set_regdom(const struct ieee80211_regdomain *rd);
 
 bool reg_last_request_cell_base(void);
+void reg_process_pending_work(void);
 
 /**
  * regulatory_hint_found_beacon - hints a beacon was found on a channel
-- 
1.8.4.3

