Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33085 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaBWT51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:27 -0500
Received: by mail-wi0-f175.google.com with SMTP id hm4so2371805wib.2
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:26 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/17] iwlwifi: mvm: don't dump log of second CPU when not relevant
Date: Sun, 23 Feb 2014 21:57:00 +0200
Message-Id: <1393185428-8524-9-git-send-email-egrumbach@gmail.com> (sfid-20140223_211709_277190_81F1EB11)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The new API for ALIVE notification was misunderstood.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 4f398e6..979b35b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -130,7 +130,6 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 	} else {
 		palive2 = (void *)pkt->data;
 
-		mvm->support_umac_log = true;
 		mvm->error_event_table =
 			le32_to_cpu(palive2->error_event_table_ptr);
 		mvm->log_event_table =
@@ -141,6 +140,9 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 
 		alive_data->valid = le16_to_cpu(palive2->status) ==
 				    IWL_ALIVE_STATUS_OK;
+		if (mvm->umac_error_event_table)
+			mvm->support_umac_log = true;
+
 		IWL_DEBUG_FW(mvm,
 			     "Alive VER2 ucode status 0x%04x revision 0x%01X 0x%01X flags 0x%01X\n",
 			     le16_to_cpu(palive2->status), palive2->ver_type,
-- 
1.7.9.5

