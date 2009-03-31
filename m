Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55493 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZCaKQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 06:16:37 -0400
Message-Id: <20090331101316.247550869@sipsolutions.net> (sfid-20090331_121639_260028_F323AA34)
References: <20090331101204.540183860@sipsolutions.net>
Date: Tue, 31 Mar 2009 12:12:05 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Subject: [PATCH v3 1/3] cfg80211: introduce scan IE limit attribute
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces a new attribute for a wiphy that tells
userspace how long the information elements added to a probe
request frame can be at most. It also updates the at76 to
advertise that it cannot support that, and, for now until I
can fix that, iwlwifi too.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/at76c50x-usb.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c |    1 +
 include/linux/nl80211.h                 |    4 ++++
 include/net/wireless.h                  |    1 +
 net/mac80211/main.c                     |   13 ++++++++++++-
 net/mac80211/util.c                     |    2 ++
 net/wireless/nl80211.c                  |    7 +++++++
 7 files changed, 28 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/net/wireless.h	2009-03-31 11:42:22.000000000 +0200
+++ wireless-testing/include/net/wireless.h	2009-03-31 11:48:50.000000000 +0200
@@ -222,6 +222,7 @@ struct wiphy {
 
 	int bss_priv_size;
 	u8 max_scan_ssids;
+	u16 max_scan_ie_len;
 
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
--- wireless-testing.orig/net/wireless/nl80211.c	2009-03-31 11:42:22.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-03-31 11:48:50.000000000 +0200
@@ -151,6 +151,8 @@ static int nl80211_send_wiphy(struct sk_
 	NLA_PUT_STRING(msg, NL80211_ATTR_WIPHY_NAME, wiphy_name(&dev->wiphy));
 	NLA_PUT_U8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
 		   dev->wiphy.max_scan_ssids);
+	NLA_PUT_U16(msg, NL80211_ATTR_MAX_SCAN_IE_LEN,
+		    dev->wiphy.max_scan_ie_len);
 
 	nl_modes = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_IFTYPES);
 	if (!nl_modes)
@@ -2492,6 +2494,11 @@ static int nl80211_trigger_scan(struct s
 	else
 		ie_len = 0;
 
+	if (ie_len > wiphy->max_scan_ie_len) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*ssid) * n_ssids
 			+ sizeof(channel) * n_channels
--- wireless-testing.orig/include/linux/nl80211.h	2009-03-31 11:42:22.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-03-31 11:48:50.000000000 +0200
@@ -380,6 +380,8 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_MAX_NUM_SCAN_SSIDS: number of SSIDs you can scan with
  *	a single scan request, a wiphy attribute.
+ * @NL80211_ATTR_MAX_SCAN_IE_LEN: maximum length of information elements
+ *	that can be added to a scan request
  *
  * @NL80211_ATTR_SCAN_FREQUENCIES: nested attribute with frequencies (in MHz)
  * @NL80211_ATTR_SCAN_SSIDS: nested attribute with SSIDs, leave out for passive
@@ -492,6 +494,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_AUTH_TYPE,
 	NL80211_ATTR_REASON_CODE,
 
+	NL80211_ATTR_MAX_SCAN_IE_LEN,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/net/mac80211/main.c	2009-03-31 11:48:49.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-03-31 11:48:50.000000000 +0200
@@ -724,7 +724,18 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 		return NULL;
 
 	wiphy->privid = mac80211_wiphy_privid;
-	wiphy->max_scan_ssids = 4;
+
+	if (!ops->hw_scan) {
+		/* For hw_scan, driver needs to set these up. */
+		wiphy->max_scan_ssids = 4;
+
+		/* we support a maximum of 32 rates in cfg80211 */
+		wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN
+					 - 2 - 32 /* SSID */
+					 - 4 - 32 /* (ext) supp rates */;
+
+	}
+
 	/* Yes, putting cfg80211_bss into ieee80211_bss is a hack */
 	wiphy->bss_priv_size = sizeof(struct ieee80211_bss) -
 			       sizeof(struct cfg80211_bss);
--- wireless-testing.orig/net/mac80211/util.c	2009-03-31 11:48:49.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-03-31 11:48:50.000000000 +0200
@@ -891,6 +891,8 @@ void ieee80211_send_probe_req(struct iee
 		*pos = rate->bitrate / 5;
 	}
 
+	/* if adding more here, adjust max_scan_ie_len */
+
 	if (ie)
 		memcpy(skb_put(skb, ie_len), ie, ie_len);
 
--- wireless-testing.orig/drivers/net/wireless/at76c50x-usb.c	2009-03-31 11:42:22.000000000 +0200
+++ wireless-testing/drivers/net/wireless/at76c50x-usb.c	2009-03-31 11:48:50.000000000 +0200
@@ -2248,6 +2248,7 @@ static int at76_init_new_device(struct a
 
 	/* mac80211 initialisation */
 	priv->hw->wiphy->max_scan_ssids = 1;
+	priv->hw->wiphy->max_scan_ie_len = 0;
 	priv->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &at76_supported_band;
 	priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-03-31 11:42:22.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-03-31 11:48:50.000000000 +0200
@@ -1306,6 +1306,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
 
 	hw->wiphy->custom_regulatory = true;
 	hw->wiphy->max_scan_ssids = 1;
+	hw->wiphy->max_scan_ie_len = 0; /* XXX for now */
 
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;

-- 

