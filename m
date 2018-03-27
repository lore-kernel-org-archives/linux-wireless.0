Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40962 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752040AbeC0IoW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 04:44:22 -0400
From: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Subject: [RFC 4/4] mac80211: Advertise per-peer NoAck policy support
Date: Tue, 27 Mar 2018 14:12:51 +0530
Message-Id: <1522140171-10926-5-git-send-email-vthiagar@codeaurora.org> (sfid-20180327_104450_084762_1661B705)
In-Reply-To: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables per-peer NoAck handling in mac80211 when
the functionality is not offloaded to the drivers.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
---
 net/mac80211/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 78f2574..2b136fb 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -565,6 +565,10 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_RRM);
 
+	if (!ops->set_noack_tid_bitmap)
+		wiphy_ext_feature_set(wiphy,
+				      NL80211_EXT_FEATURE_PER_STA_NOACK_MAP);
+
 	wiphy->bss_priv_size = sizeof(struct ieee80211_bss);
 
 	local = wiphy_priv(wiphy);
-- 
1.9.1
