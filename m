Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46271 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbZKIXri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:38 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so3717715ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:44 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2 16/20] mac80211: add the DS params to the beacon
Date: Mon,  9 Nov 2009 23:46:54 +0000
Message-Id: <1257810418-30075-17-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 63427d9..222a313 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -247,6 +247,13 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 		}
 	}
 
+	if (sband->band == IEEE80211_BAND_2GHZ) {
+		pos = skb_put(skb, 2 + 1);
+		*pos++ = WLAN_EID_DS_PARAMS;
+		*pos++ = 1;
+		*pos++ = ieee80211_frequency_to_channel(local->hw.conf.channel->center_freq);
+	}
+
 	pos = skb_put(skb, 2 + sdata->u.mesh.mesh_id_len);
 	*pos++ = WLAN_EID_MESH_ID;
 	*pos++ = sdata->u.mesh.mesh_id_len;
-- 
1.5.6.5

