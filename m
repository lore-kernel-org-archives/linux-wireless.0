Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:39169 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab3LaRQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:37 -0500
Received: by mail-ee0-f41.google.com with SMTP id t10so5667780eei.0
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:36 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/28] iwlwifi: mvm: change the parameters for calculating an AP TBTT
Date: Tue, 31 Dec 2013 19:15:53 +0200
Message-Id: <1388510157-23345-24-git-send-email-egrumbach@gmail.com> (sfid-20131231_183437_046532_5A55B41E)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Change the parameters for calculating an AP TBTT to 64/36 instead of
80/20, to increase the interval between a station vif and an AP
vif TBTT events.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 761cca3..510cf9f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1012,7 +1012,7 @@ static void iwl_mvm_mac_ctxt_cmd_fill_ap(struct iwl_mvm *mvm,
 			iwl_mvm_mac_ap_iterator, &data);
 
 		if (data.beacon_device_ts) {
-			u32 rand = (prandom_u32() % (80 - 20)) + 20;
+			u32 rand = (prandom_u32() % (64 - 36)) + 36;
 			mvmvif->ap_beacon_time = data.beacon_device_ts +
 				ieee80211_tu_to_usec(data.beacon_int * rand /
 						     100);
-- 
1.7.9.5

