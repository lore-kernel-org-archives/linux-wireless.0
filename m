Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50645 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab1AXS2w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 13:28:52 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix a crash in ieee80211_beacon_get_tim on change_interface
Date: Mon, 24 Jan 2011 19:28:49 +0100
Message-Id: <1295893729-5700-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers (e.g. ath9k) do not always disable beacons when they're
supposed to. When an interface is changed using the change_interface op,
the mode specific sdata part is in an undefined state and trying to
get a beacon at this point can produce weird crashes.

To fix this, add a check for ieee80211_sdata_running before using
anything from the sdata.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 net/mac80211/tx.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e46c801..ffc6749 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2230,6 +2230,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 
 	sdata = vif_to_sdata(vif);
 
+	if (!ieee80211_sdata_running(sdata))
+		goto out;
+
 	if (tim_offset)
 		*tim_offset = 0;
 	if (tim_length)
-- 
1.7.3.2

