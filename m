Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33348 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbeH2FYm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 01:24:42 -0400
From: Yuan-Chi Pang <fu3mo6goo@gmail.com>
To: johannes@sipsolutions.net
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuan-Chi Pang <fu3mo6goo@gmail.com>
Subject: [PATCH] mac80211: fix HWMP sequence numbering to follow standard
Date: Wed, 29 Aug 2018 09:30:08 +0800
Message-Id: <1535506208-17680-1-git-send-email-fu3mo6goo@gmail.com> (sfid-20180829_033031_622336_682F54F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE 802.11-2016 14.10.8.3 HWMP sequence numbering says:
If it is a target mesh STA, it shall update its own HWMP SN to
maximum (current HWMP SN, target HWMP SN in the PREQ element) + 1
immediately before it generates a PREP element in response to a
PREQ element.

Signed-off-by: Yuan-Chi Pang <fu3mo6goo@gmail.com>
---
 net/mac80211/mesh_hwmp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 35ad398..daf9db3 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -572,6 +572,10 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		forward = false;
 		reply = true;
 		target_metric = 0;
+
+		if (SN_GT(target_sn, ifmsh->sn))
+			ifmsh->sn = target_sn;
+
 		if (time_after(jiffies, ifmsh->last_sn_update +
 					net_traversal_jiffies(sdata)) ||
 		    time_before(jiffies, ifmsh->last_sn_update)) {
-- 
2.7.4
