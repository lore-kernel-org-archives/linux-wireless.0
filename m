Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54180 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759474Ab2DZWBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 18:01:19 -0400
Received: by pbbrr13 with SMTP id rr13so215650pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2012 15:01:19 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 2/2] mac80211: don't transmit 40MHz frames to 20MHz peer
Date: Thu, 26 Apr 2012 15:01:07 -0700
Message-Id: <1335477667-1625-2-git-send-email-thomas@cozybit.com> (sfid-20120427_000129_651675_9F4D2CF7)
In-Reply-To: <1335477667-1625-1-git-send-email-thomas@cozybit.com>
References: <1335477667-1625-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a mesh peer indicates it is operating as 20MHz-only in its HT
operation IE, have the rate control algorithm respect this by disabling
the equivalent bit in the ieee80211_sta HT capabilities.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index f4124d7..6209327 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -302,6 +302,12 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 	else
 		memset(&sta->sta.ht_cap, 0, sizeof(sta->sta.ht_cap));
 
+	if (elems->ht_operation)
+		if (!(elems->ht_operation->ht_param &
+		      IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
+			sta->sta.ht_cap.cap &=
+					    ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+
 	rate_control_rate_init(sta);
 	spin_unlock_bh(&sta->lock);
 
-- 
1.7.5.4

