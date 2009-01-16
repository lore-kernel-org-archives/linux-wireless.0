Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11031 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758603AbZAPAN1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 19:13:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 16:13:27 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 12/13] mac80211: allow mac80211 drivers to get to struct ieee80211_hw from wiphy
Date: Thu, 15 Jan 2009 16:12:25 -0800
Message-ID: <1232064746-17134-13-git-send-email-lrodriguez@atheros.com> (sfid-20090116_013903_193161_3E241E59)
In-Reply-To: <1232064746-17134-12-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-9-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-10-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-11-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-12-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a driver is given a wiphy and it wants to get to its private
mac80211 driver area it can use wiphy_to_ieee80211_hw() to get first
to its ieee80211_hw and then access the private structure via hw->priv. The
wiphy_priv() is already being used internally by mac80211 and drivers
should not use this. This can be helpful in a drivers reg_notifier().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/mac80211.h |   13 +++++++++++++
 net/mac80211/util.c    |    9 +++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9a5869e..b29c41b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -965,6 +965,19 @@ struct ieee80211_hw {
 };
 
 /**
+ * wiphy_to_ieee80211_hw - return a mac80211 driver hw struct from a wiphy
+ *
+ * @wiphy: the &struct wiphy which we want to query
+ *
+ * mac80211 drivers can use this to get to their respective
+ * &struct ieee80211_hw. Drivers wishing to get to their own private
+ * structure can then access it via hw->priv. Note that mac802111 drivers should
+ * not use wiphy_priv() to try to get their private driver structure as this
+ * is already used internally by mac80211.
+ */
+struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy);
+
+/**
  * SET_IEEE80211_DEV - set device for 802.11 hardware
  *
  * @hw: the &struct ieee80211_hw to set the device for
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 963e047..9016c8d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -41,6 +41,15 @@ const unsigned char rfc1042_header[] __aligned(2) =
 const unsigned char bridge_tunnel_header[] __aligned(2) =
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 
+struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy)
+{
+	struct ieee80211_local *local;
+	BUG_ON(!wiphy);
+
+	local = wiphy_priv(wiphy);
+	return &local->hw;
+}
+EXPORT_SYMBOL(wiphy_to_ieee80211_hw);
 
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type)
-- 
1.6.1.rc3.51.g5832d

