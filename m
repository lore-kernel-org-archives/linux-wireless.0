Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.dnainternet.fi ([87.94.96.72]:59265 "EHLO
	smtp4.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614AbZCZVkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 17:40:14 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/6] cfg80211: add cfg80211_inform_bss
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 26 Mar 2009 23:40:09 +0200
Message-ID: <20090326214009.19238.73003.stgit@fate.lan> (sfid-20090326_224019_001928_ADAECC4B)
In-Reply-To: <20090326213953.19238.59497.stgit@fate.lan>
References: <20090326213953.19238.59497.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added cfg80211_inform_bss() for full-mac devices to use.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 include/net/cfg80211.h |    8 ++++++++
 net/wireless/scan.c    |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5389afd..1993fd7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -864,6 +864,14 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 			  struct ieee80211_mgmt *mgmt, size_t len,
 			  s32 signal, gfp_t gfp);
 
+struct cfg80211_bss*
+cfg80211_inform_bss(struct wiphy *wiphy,
+		    struct ieee80211_channel *channel,
+		    const u8 *bssid,
+		    u64 timestamp, u16 capability, u16 beacon_interval,
+		    const u8 *ie, size_t ielen,
+		    s32 signal, gfp_t gfp);
+
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 2a00e36..bd1e756 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -388,6 +388,55 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 	return found;
 }
 
+struct cfg80211_bss*
+cfg80211_inform_bss(struct wiphy *wiphy,
+		    struct ieee80211_channel *channel,
+		    const u8 *bssid,
+		    u64 timestamp, u16 capability, u16 beacon_interval,
+		    const u8 *ie, size_t ielen,
+		    s32 signal, gfp_t gfp)
+{
+	struct cfg80211_internal_bss *res;
+	size_t privsz;
+
+	if (WARN_ON(!wiphy))
+		return NULL;
+
+	privsz = wiphy->bss_priv_size;
+
+	if (WARN_ON(wiphy->signal_type == NL80211_BSS_SIGNAL_UNSPEC &&
+			(signal < 0 || signal > 100)))
+		return NULL;
+
+	res = kzalloc(sizeof(*res) + privsz + ielen, gfp);
+	if (!res)
+		return NULL;
+
+	memcpy(res->pub.bssid, bssid, ETH_ALEN);
+	res->pub.channel = channel;
+	res->pub.signal = signal;
+	res->pub.tsf = timestamp;
+	res->pub.beacon_interval = beacon_interval;
+	res->pub.capability = capability;
+	/* point to after the private area */
+	res->pub.information_elements = (u8 *)res + sizeof(*res) + privsz;
+	memcpy(res->pub.information_elements, ie, ielen);
+	res->pub.len_information_elements = ielen;
+
+	kref_init(&res->ref);
+
+	res = cfg80211_bss_update(wiphy_to_dev(wiphy), res, 0);
+	if (!res)
+		return NULL;
+
+	if (res->pub.capability & WLAN_CAPABILITY_ESS)
+		regulatory_hint_found_beacon(wiphy, channel, gfp);
+
+	/* cfg80211_bss_update gives us a referenced result */
+	return &res->pub;
+}
+EXPORT_SYMBOL(cfg80211_inform_bss);
+
 struct cfg80211_bss *
 cfg80211_inform_bss_frame(struct wiphy *wiphy,
 			  struct ieee80211_channel *channel,

