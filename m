Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:59137 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab3GUNg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jul 2013 09:36:59 -0400
Received: by mail-ee0-f47.google.com with SMTP id e49so3233980eek.6
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jul 2013 06:36:58 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/2] regulatory: take RTNL when restoring settings on CRDA timeout
Date: Sun, 21 Jul 2013 16:36:49 +0300
Message-Id: <1374413809-26005-2-git-send-email-arik@wizery.com> (sfid-20130721_154508_123281_3A56647A)
In-Reply-To: <1374413809-26005-1-git-send-email-arik@wizery.com>
References: <1374413809-26005-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RTNL has to be held since this potentially changes the regdomain.
Locking was forgotten here due to recent locking simplification changes.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/wireless/reg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1ec3933..b25390a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2285,7 +2285,9 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 static void reg_timeout_work(struct work_struct *work)
 {
 	REG_DBG_PRINT("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
+	rtnl_lock();
 	restore_regulatory_settings(true);
+	rtnl_unlock();
 }
 
 int __init regulatory_init(void)
-- 
1.8.1.2

