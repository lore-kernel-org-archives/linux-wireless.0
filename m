Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:22690 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab0BLHyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2010 02:54:51 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Subject: [PATCH 1/1] mac80211: fix handling of null-rate control in rate_control_get_rate
Date: Fri, 12 Feb 2010 09:52:08 +0200
Message-Id: <1265961128-21301-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For hardware with IEEE80211_HW_HAS_RATE_CONTROL the rate controller is not
initialized. However, calling functions such as ieee80211_beacon_get result
in the rate_control_get_rate function getting called, which is accessing
(in this case uninitialized) rate control structures unconditionally.

Fix by exiting the function before setting the rates for HW with
IEEE80211_HW_HAS_RATE_CONTROL set. The initialization of the ieee80211_tx_info
struct is intentionally still executed.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/rate.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index c74b7c8..7f366d8 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -303,6 +303,9 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 		info->control.rates[i].count = 1;
 	}
 
+	if (sdata->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
+		return;
+
 	ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
 
 	/*
-- 
1.6.3.3

