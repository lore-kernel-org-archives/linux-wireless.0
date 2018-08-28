Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42087 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbeH1GOd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 02:14:33 -0400
From: Yuan-Chi Pang <fu3mo6goo@gmail.com>
To: johannes@sipsolutions.net
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fu3mo6goo@gmail.com
Subject: [PATCH] mac80211: fix to follow standard
Date: Tue, 28 Aug 2018 10:24:34 +0800
Message-Id: <1535423074-130862-1-git-send-email-fu3mo6goo@gmail.com> (sfid-20180828_042528_741119_C56CF38E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE 802.11-2016 14.10.8.3 HWMP sequence numbering says:
If it is a target mesh STA, it shall update its own HWMP SN to
maximum (current HWMP SN, target HWMP SN in the PREQ element) + 1
immediately before it generates a PREP element in response to a
PREQ element.

Signed-off-by: Yuan-Chi Pang <fu3mo6goo@gmail.com>
---
 net/mac80211/mesh_hwmp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 35ad398..6c21a26 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -572,6 +572,11 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		forward = false;
 		reply = true;
 		target_metric = 0;
+
+		if (SN_GT(target_sn, ifmsh->sn)) {
+			ifmsh->sn = target_sn;
+		}
+
 		if (time_after(jiffies, ifmsh->last_sn_update +
 					net_traversal_jiffies(sdata)) ||
 		    time_before(jiffies, ifmsh->last_sn_update)) {
-- 
2.7.4
