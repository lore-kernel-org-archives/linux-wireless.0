Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42743 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab0INRMn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 13:12:43 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	lrodriguez@atheros.com
Subject: [PATCH 2/2] mac80211: add a note about iterating interfaces during add_interface()
Date: Tue, 14 Sep 2010 18:37:20 +0200
Message-Id: <1284482240-57922-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1284482240-57922-1-git-send-email-nbd@openwrt.org>
References: <1284482240-57922-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f91fc33..19a5cb4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2293,6 +2293,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted);
  * This function allows the iterator function to sleep, when the iterator
  * function is atomic @ieee80211_iterate_active_interfaces_atomic can
  * be used.
+ * Does not iterate over a new interface during add_interface()
  *
  * @hw: the hardware struct of which the interfaces should be iterated over
  * @iterator: the iterator function to call
@@ -2310,6 +2311,7 @@ void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
  * hardware that are currently active and calls the callback for them.
  * This function requires the iterator callback function to be atomic,
  * if that is not desired, use @ieee80211_iterate_active_interfaces instead.
+ * Does not iterate over a new interface during add_interface()
  *
  * @hw: the hardware struct of which the interfaces should be iterated over
  * @iterator: the iterator function to call, cannot sleep
-- 
1.7.2.2

