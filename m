Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:48101 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaBZUiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 15:38:08 -0500
Received: by mail-pd0-f182.google.com with SMTP id g10so368779pdj.27
        for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 12:38:08 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v3] cfg80211: processing regulatory requests on netdev notifier
Date: Wed, 26 Feb 2014 12:38:00 -0800
Message-Id: <1393447080-9783-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20140226_213813_457661_517EEE15)
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

A timer just waiting upon init is not that appropriate
as when it should be triggered will depend on systems,
a much better approach is to use and add opportunistic
triggers. The interface coming up is typically a good
indicator that filesystems have been mounted since
firmware is required for some devices.

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/core.c | 2 ++
 net/wireless/reg.c  | 5 +++++
 net/wireless/reg.h  | 1 +
 3 files changed, 8 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 276cf93..7110631 100644
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
@@ -874,6 +875,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		wake_up(&rdev->dev_wait);
 		break;
 	case NETDEV_UP:
+		reg_process_pending_work();
 		cfg80211_update_iface_num(rdev, wdev->iftype, 1);
 		wdev_lock(wdev);
 		switch (wdev->iftype) {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7203b74..b358856 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -192,6 +192,11 @@ static DECLARE_WORK(reg_work, reg_todo);
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
index 37c180d..51912b3 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -37,6 +37,7 @@ unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
 				   const struct ieee80211_reg_rule *rule);
 
 bool reg_last_request_cell_base(void);
+void reg_process_pending_work(void);
 
 /**
  * regulatory_hint_found_beacon - hints a beacon was found on a channel
-- 
1.8.5.3

