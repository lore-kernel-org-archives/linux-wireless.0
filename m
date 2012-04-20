Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46398 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2DTQxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 12:53:05 -0400
Received: by dake40 with SMTP id e40so13246061dak.11
        for <linux-wireless@vger.kernel.org>; Fri, 20 Apr 2012 09:53:04 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Shinichi Hotori <hotorinn@gmail.com>,
	Yu Niiro <yu.niiro@gmail.com>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>,
	Pavel Zubarev <pavel.zubarev@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fixup for mesh TSF adjustment latency in Toffset setpoint
Date: Fri, 20 Apr 2012 09:52:56 -0700
Message-Id: <1334940776-5048-1-git-send-email-javier@cozybit.com> (sfid-20120420_185309_587755_AFF4328A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original patch defined the correction margin but did not apply it.

Signed-off-by: Shinichi Hotori <hotorinn@gmail.com>
Signed-off-by: Yu Niiro <yu.niiro@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_sync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index ff60d6b..38d30e8 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -195,7 +195,7 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		spin_unlock_bh(&ifmsh->sync_offset_lock);
 
 	} else {
-		sta->t_offset_setpoint = sta->t_offset;
+		sta->t_offset_setpoint = sta->t_offset - TOFFSET_SET_MARGIN;
 		set_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
 		msync_dbg("STA %pM : offset was invalid, "
 			  " sta->t_offset=%lld",
-- 
1.7.5.4

