Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab2GEIZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 04:25:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/9] iwlwifi: use __get_str in tracing
Date: Thu,  5 Jul 2012 10:24:49 +0200
Message-Id: <1341476695-6889-4-git-send-email-johannes@sipsolutions.net> (sfid-20120705_102544_721734_DE99651D)
In-Reply-To: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
References: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

__get_str() is identical to (char *)__get_dynamic_array()
that is in the code now, substitute __get_str to make the
code more readable.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index ad2dba8..06ca505 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -189,7 +189,7 @@ DECLARE_EVENT_CLASS(iwlwifi_msg_event,
 				       MAX_MSG_LEN, vaf->fmt,
 				       *vaf->va) >= MAX_MSG_LEN);
 	),
-	TP_printk("%s", (char *)__get_dynamic_array(msg))
+	TP_printk("%s", __get_str(msg))
 );
 
 DEFINE_EVENT(iwlwifi_msg_event, iwlwifi_err,
-- 
1.7.10

