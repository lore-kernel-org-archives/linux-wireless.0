Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab1CVKAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 06:00:39 -0400
Subject: [PATCH] iwlagn: fix error in command waiting
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 11:00:37 +0100
Message-ID: <1300788037.3746.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clearly a mistake, since pointers won't suddenly
change their value...

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c	2011-03-21 15:14:48.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c	2011-03-21 15:14:52.000000000 +0100
@@ -2266,7 +2266,7 @@ signed long iwlagn_wait_notification(str
 	int ret;
 
 	ret = wait_event_timeout(priv->_agn.notif_waitq,
-				 &wait_entry->triggered,
+				 wait_entry->triggered,
 				 timeout);
 
 	spin_lock_bh(&priv->_agn.notif_wait_lock);


