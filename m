Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36700 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbbLXId3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 03:33:29 -0500
Received: by mail-pa0-f42.google.com with SMTP id q3so125103279pav.3
        for <linux-wireless@vger.kernel.org>; Thu, 24 Dec 2015 00:33:29 -0800 (PST)
From: Bjorn Andersson <bjorn@kryo.se>
To: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: Make addr const in SET_IEEE80211_PERM_ADDR()
Date: Thu, 24 Dec 2015 00:33:26 -0800
Message-Id: <1450946006-7498-1-git-send-email-bjorn.andersson@sonymobile.com> (sfid-20151224_093418_427768_D17F7025)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the addr parameter const in SET_IEEE80211_PERM_ADDR() to save
clients from having to cast away a const qualifier.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 include/net/mac80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7c30faff245f..a6f3c9c4b7c2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2167,7 +2167,7 @@ static inline void SET_IEEE80211_DEV(struct ieee80211_hw *hw, struct device *dev
  * @hw: the &struct ieee80211_hw to set the MAC address for
  * @addr: the address to set
  */
-static inline void SET_IEEE80211_PERM_ADDR(struct ieee80211_hw *hw, u8 *addr)
+static inline void SET_IEEE80211_PERM_ADDR(struct ieee80211_hw *hw, const u8 *addr)
 {
 	memcpy(hw->wiphy->perm_addr, addr, ETH_ALEN);
 }
-- 
2.5.0

