Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19415 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbZAMT6t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:58:49 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 11:58:49 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 11/12] mac80211: allow mac80211 drivers to get to driver priv from wiphy
Date: Tue, 13 Jan 2009 11:57:54 -0800
Message-ID: <1231876675-20518-12-git-send-email-lrodriguez@atheros.com> (sfid-20090113_210904_312688_0CC01FAE)
In-Reply-To: <1231876675-20518-11-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-5-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-7-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-8-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-9-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-10-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-11-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a driver is given a wiphy and it wants to get to its private
mac80211 driver area it can use mac80211_wiphy_driver_priv(). The
wiphy_priv() is already being used internally by mac80211 and drivers
should not use this. This can be helpful a drivers reg_notifier().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/mac80211.h |   11 +++++++++++
 net/mac80211/util.c    |    9 +++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 00f7ec0..b73c379 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -966,6 +966,17 @@ struct ieee80211_hw {
 };
 
 /**
+ * mac80211_wiphy_driver_priv - return a mac80211 driver's priv from a wiphy
+ *
+ * @wiphy: the &struct wiphy which we want to query
+ *
+ * mac80211 drivers can use this instead of wiphy_priv() to get to their
+ * driver's private area. wiphy_priv() is used internally by mac80211 for
+ * its own private area and should not be used by mac80211 drivers.
+ */
+void *mac80211_wiphy_driver_priv(struct wiphy *wiphy);
+
+/**
  * SET_IEEE80211_DEV - set device for 802.11 hardware
  *
  * @hw: the &struct ieee80211_hw to set the device for
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 963e047..81d2cbb 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -41,6 +41,15 @@ const unsigned char rfc1042_header[] __aligned(2) =
 const unsigned char bridge_tunnel_header[] __aligned(2) =
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 
+void *mac80211_wiphy_driver_priv(struct wiphy *wiphy)
+{
+	struct ieee80211_local *local;
+	BUG_ON(!wiphy);
+
+	local = wiphy_priv(wiphy);
+	return local->hw.priv;
+}
+EXPORT_SYMBOL(mac80211_wiphy_driver_priv);
 
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type)
-- 
1.6.1.rc3.51.g5832d

