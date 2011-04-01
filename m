Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43854 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab1DAVgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 17:36:47 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so3915791iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 14:36:46 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v6 05/10] mac80211: Let user space receive and send mesh auth/deauth frames
Date: Fri,  1 Apr 2011 13:35:46 -0700
Message-Id: <1301690151-14979-6-git-send-email-thomas@cozybit.com>
In-Reply-To: <1301690151-14979-1-git-send-email-thomas@cozybit.com>
References: <1301690151-14979-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/main.c |    4 +++-
 net/mac80211/rx.c   |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 562d298..0ae9b22 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -545,7 +545,9 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	},
 	[NL80211_IFTYPE_MESH_POINT] = {
 		.tx = 0xffff,
-		.rx = BIT(IEEE80211_STYPE_ACTION >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_DEAUTH >> 4),
 	},
 };
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5c1930b..fe0f1e3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -502,7 +502,8 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 
 		if (ieee80211_is_probe_req(hdr->frame_control) ||
 		    ieee80211_is_probe_resp(hdr->frame_control) ||
-		    ieee80211_is_beacon(hdr->frame_control))
+		    ieee80211_is_beacon(hdr->frame_control) ||
+		    ieee80211_is_auth(hdr->frame_control))
 			return RX_CONTINUE;
 
 		return RX_DROP_MONITOR;
-- 
1.7.4.1

