Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38081 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab1JFVyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 17:54:31 -0400
Received: by qadb15 with SMTP id b15so2393095qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 14:54:30 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH] mac80211: Fix regression that allowed mpaths between non-peers.
Date: Thu,  6 Oct 2011 14:54:22 -0700
Message-Id: <1317938062-1226-1-git-send-email-javier@cozybit.com> (sfid-20111006_235434_659805_F7FA4F4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh paths should only exist over established peer links.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 6df7913..174040a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -789,11 +789,20 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 	struct ieee802_11_elems elems;
 	size_t baselen;
 	u32 last_hop_metric;
+	struct sta_info *sta;
 
 	/* need action_code */
 	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
 		return;
 
+	rcu_read_lock();
+	sta = sta_info_get(sdata, mgmt->sa);
+	if (!sta || sta->plink_state != NL80211_PLINK_ESTAB) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
 	baselen = (u8 *) mgmt->u.action.u.mesh_action.variable - (u8 *) mgmt;
 	ieee802_11_parse_elems(mgmt->u.action.u.mesh_action.variable,
 			len - baselen, &elems);
-- 
1.7.6

