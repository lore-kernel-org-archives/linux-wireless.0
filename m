Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791AbZAUMo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 07:44:26 -0500
Subject: [PATCH] mac80211: constify ieee80211_if_conf.bssid
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andrey Yurovsky <andrey@cozybit.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 12:47:05 +0100
Message-Id: <1232538425.4358.8.camel@johannes.local> (sfid-20090121_134429_477169_683724AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Then one place can be a static const.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/libertas_tf/cmd.c         |    2 +-
 drivers/net/wireless/libertas_tf/libertas_tf.h |    2 +-
 drivers/net/wireless/rt2x00/rt2x00config.c     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h        |    2 +-
 include/net/mac80211.h                         |    2 +-
 net/mac80211/main.c                            |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-01-21 12:43:32.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-01-21 12:44:02.000000000 +0100
@@ -643,7 +643,7 @@ enum ieee80211_if_conf_change {
  */
 struct ieee80211_if_conf {
 	u32 changed;
-	u8 *bssid;
+	const u8 *bssid;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/main.c	2009-01-21 12:43:33.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-01-21 12:44:02.000000000 +0100
@@ -176,7 +176,7 @@ int ieee80211_if_config(struct ieee80211
 	else if (sdata->vif.type == NL80211_IFTYPE_AP)
 		conf.bssid = sdata->dev->dev_addr;
 	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		u8 zero[ETH_ALEN] = { 0 };
+		static const u8 zero[ETH_ALEN] = { 0 };
 		conf.bssid = zero;
 	} else {
 		WARN_ON(1);
--- wireless-testing.orig/drivers/net/wireless/libertas_tf/cmd.c	2009-01-21 12:43:32.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas_tf/cmd.c	2009-01-21 12:44:02.000000000 +0100
@@ -286,7 +286,7 @@ void lbtf_set_mode(struct lbtf_private *
 	lbtf_cmd_async(priv, CMD_802_11_SET_MODE, &cmd.hdr, sizeof(cmd));
 }
 
-void lbtf_set_bssid(struct lbtf_private *priv, bool activate, u8 *bssid)
+void lbtf_set_bssid(struct lbtf_private *priv, bool activate, const u8 *bssid)
 {
 	struct cmd_ds_set_bssid cmd;
 
--- wireless-testing.orig/drivers/net/wireless/libertas_tf/libertas_tf.h	2009-01-21 12:43:31.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas_tf/libertas_tf.h	2009-01-21 12:44:02.000000000 +0100
@@ -463,7 +463,7 @@ int lbtf_set_radio_control(struct lbtf_p
 int lbtf_update_hw_spec(struct lbtf_private *priv);
 int lbtf_cmd_set_mac_multicast_addr(struct lbtf_private *priv);
 void lbtf_set_mode(struct lbtf_private *priv, enum lbtf_mode mode);
-void lbtf_set_bssid(struct lbtf_private *priv, bool activate, u8 *bssid);
+void lbtf_set_bssid(struct lbtf_private *priv, bool activate, const u8 *bssid);
 int lbtf_set_mac_address(struct lbtf_private *priv, uint8_t *mac_addr);
 
 int lbtf_set_channel(struct lbtf_private *priv, u8 channel);
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00config.c	2009-01-21 12:43:32.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00config.c	2009-01-21 12:44:02.000000000 +0100
@@ -32,7 +32,7 @@
 void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 			   struct rt2x00_intf *intf,
 			   enum nl80211_iftype type,
-			   u8 *mac, u8 *bssid)
+			   const u8 *mac, const u8 *bssid)
 {
 	struct rt2x00intf_conf conf;
 	unsigned int flags = 0;
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00lib.h	2009-01-21 12:43:32.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00lib.h	2009-01-21 12:44:02.000000000 +0100
@@ -76,7 +76,7 @@ void rt2x00lib_stop(struct rt2x00_dev *r
 void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 			   struct rt2x00_intf *intf,
 			   enum nl80211_iftype type,
-			   u8 *mac, u8 *bssid);
+			   const u8 *mac, const u8 *bssid);
 void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 			  struct rt2x00_intf *intf,
 			  struct ieee80211_bss_conf *conf);


