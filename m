Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63637 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaBZBKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 20:10:05 -0500
Received: by mail-pa0-f54.google.com with SMTP id fa1so220349pad.13
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 17:10:05 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux@eikelenboom.it,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/3] cfg80211: processing regulatory requests on netdev notifier
Date: Tue, 25 Feb 2014 17:09:42 -0800
Message-Id: <1393376982-28276-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20140226_021016_046465_BE841D87)
In-Reply-To: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
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
 net/wireless/reg.h | 1 +
 1 file changed, 1 insertion(+)

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

