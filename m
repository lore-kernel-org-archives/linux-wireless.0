Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1270 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbZLCE4G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 23:56:06 -0500
Subject: Re: [PATCH] Remove double semicolons
From: Joe Perches <joe@perches.com>
To: John Daiker <daikerjohn@gmail.com>
Cc: linux-wireless@vger.kernel.org, samuel.ortiz@intel.com,
	yi.zhu@intel.com
In-Reply-To: <1259813669-29946-1-git-send-email-daikerjohn@gmail.com>
References: <1259813669-29946-1-git-send-email-daikerjohn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 20:56:11 -0800
Message-ID: <1259816171.22783.15.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-12-02 at 20:14 -0800, John Daiker wrote:
> This patches eliminates a few double semicolons in the IWMC3200 driver.

How about this instead:

Avoid an offset calculation for each management frame.
Determine the offset at compile time.

Signed-off-by: Joe Perches <joe@perches.com>

 drivers/net/wireless/iwmc3200wifi/rx.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index bdb1d7e..097144a 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -868,36 +868,35 @@ static int iwm_mlme_mgt_frame(struct iwm_priv *iwm, u8 *buf,
 	struct iwm_umac_notif_mgt_frame *mgt_frame =
 			(struct iwm_umac_notif_mgt_frame *)buf;
 	struct ieee80211_mgmt *mgt = (struct ieee80211_mgmt *)mgt_frame->frame;
-	u8 *ie;
 
 	IWM_HEXDUMP(iwm, DBG, MLME, "MGT: ", mgt_frame->frame,
 		    le16_to_cpu(mgt_frame->len));
 
 	if (ieee80211_is_assoc_req(mgt->frame_control)) {
-		ie = mgt->u.assoc_req.variable;;
-		iwm->req_ie_len =
-				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
+		iwm->req_ie_len = le16_to_cpu(mgt_frame->len)
+				  - offsetof(struct ieee80211_mgmt,
+					     u.assoc_req.variable);
 		kfree(iwm->req_ie);
 		iwm->req_ie = kmemdup(mgt->u.assoc_req.variable,
 				      iwm->req_ie_len, GFP_KERNEL);
 	} else if (ieee80211_is_reassoc_req(mgt->frame_control)) {
-		ie = mgt->u.reassoc_req.variable;;
-		iwm->req_ie_len =
-				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
+		iwm->req_ie_len = le16_to_cpu(mgt_frame->len)
+				  - offsetof(struct ieee80211_mgmt,
+					     u.reassoc_req.variable);
 		kfree(iwm->req_ie);
 		iwm->req_ie = kmemdup(mgt->u.reassoc_req.variable,
 				      iwm->req_ie_len, GFP_KERNEL);
 	} else if (ieee80211_is_assoc_resp(mgt->frame_control)) {
-		ie = mgt->u.assoc_resp.variable;;
-		iwm->resp_ie_len =
-				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
+		iwm->resp_ie_len = le16_to_cpu(mgt_frame->len)
+				   - offsetof(struct ieee80211_mgmt,
+					      u.assoc_resp.variable);
 		kfree(iwm->resp_ie);
 		iwm->resp_ie = kmemdup(mgt->u.assoc_resp.variable,
 				       iwm->resp_ie_len, GFP_KERNEL);
 	} else if (ieee80211_is_reassoc_resp(mgt->frame_control)) {
-		ie = mgt->u.reassoc_resp.variable;;
-		iwm->resp_ie_len =
-				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
+		iwm->resp_ie_len = le16_to_cpu(mgt_frame->len)
+				   - offsetof(struct ieee80211_mgmt,
+					      u.reassoc_resp.variable);
 		kfree(iwm->resp_ie);
 		iwm->resp_ie = kmemdup(mgt->u.reassoc_resp.variable,
 				       iwm->resp_ie_len, GFP_KERNEL);


