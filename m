Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f184.google.com ([209.85.222.184]:33260 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbZLCEPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 23:15:04 -0500
Received: by pzk14 with SMTP id 14so923738pzk.23
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2009 20:15:11 -0800 (PST)
From: John Daiker <daikerjohn@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: samuel.ortiz@intel.com, yi.zhu@intel.com,
	John Daiker <daikerjohn@gmail.com>
Subject: [PATCH] Remove double semicolons
Date: Wed,  2 Dec 2009 20:14:29 -0800
Message-Id: <1259813669-29946-1-git-send-email-daikerjohn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches eliminates a few double semicolons in the IWMC3200 driver.

Signed-off-by: John Daiker <daikerjohn@gmail.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 72c27a3..5e3cf5e 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -874,28 +874,28 @@ static int iwm_mlme_mgt_frame(struct iwm_priv *iwm, u8 *buf,
 		    le16_to_cpu(mgt_frame->len));
 
 	if (ieee80211_is_assoc_req(mgt->frame_control)) {
-		ie = mgt->u.assoc_req.variable;;
+		ie = mgt->u.assoc_req.variable;
 		iwm->req_ie_len =
 				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
 		kfree(iwm->req_ie);
 		iwm->req_ie = kmemdup(mgt->u.assoc_req.variable,
 				      iwm->req_ie_len, GFP_KERNEL);
 	} else if (ieee80211_is_reassoc_req(mgt->frame_control)) {
-		ie = mgt->u.reassoc_req.variable;;
+		ie = mgt->u.reassoc_req.variable;
 		iwm->req_ie_len =
 				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
 		kfree(iwm->req_ie);
 		iwm->req_ie = kmemdup(mgt->u.reassoc_req.variable,
 				      iwm->req_ie_len, GFP_KERNEL);
 	} else if (ieee80211_is_assoc_resp(mgt->frame_control)) {
-		ie = mgt->u.assoc_resp.variable;;
+		ie = mgt->u.assoc_resp.variable;
 		iwm->resp_ie_len =
 				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
 		kfree(iwm->resp_ie);
 		iwm->resp_ie = kmemdup(mgt->u.assoc_resp.variable,
 				       iwm->resp_ie_len, GFP_KERNEL);
 	} else if (ieee80211_is_reassoc_resp(mgt->frame_control)) {
-		ie = mgt->u.reassoc_resp.variable;;
+		ie = mgt->u.reassoc_resp.variable;
 		iwm->resp_ie_len =
 				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
 		kfree(iwm->resp_ie);
-- 
1.6.3.3

