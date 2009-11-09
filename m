Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:43551 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbZKIMlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:41:47 -0500
Received: by fg-out-1718.google.com with SMTP id d23so703490fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:41:51 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 17/21] mac80211: add the DS params to the beacon
Date: Mon,  9 Nov 2009 12:39:37 +0000
Message-Id: <1257770381-7680-18-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
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

