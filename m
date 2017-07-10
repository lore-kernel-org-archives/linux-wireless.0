Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36811 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753446AbdGJMow (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:44:52 -0400
Received: by mail-wr0-f195.google.com with SMTP id 77so24694932wrb.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:44:52 -0700 (PDT)
From: Simon Dinkin <simondinkin@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Simon Dinkin <simon.dinkin@tandemg.com>
Subject: [PATCH] mac80211: fix incorrect assignment of reassoc value
Date: Mon, 10 Jul 2017 15:44:38 +0300
Message-Id: <1499690678-28147-1-git-send-email-simon.dinkin@tandemg.com> (sfid-20170710_144533_628437_8B347A1A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this fix minor issue in the log message.
in ieee80211_rx_mgmt_assoc_resp function, when assigning the
reassoc value from the mgmt frame control:
ieee80211_is_reassoc_resp function need to be used, instead of
ieee80211_is_reassoc_req function.

Signed-off-by: Simon Dinkin <simon.dinkin@tandemg.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7be7917..0467f9f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3159,7 +3159,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	if (len < 24 + 6)
 		return;
 
-	reassoc = ieee80211_is_reassoc_req(mgmt->frame_control);
+	reassoc = ieee80211_is_reassoc_resp(mgmt->frame_control);
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
 	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
-- 
2.7.4
