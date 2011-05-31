Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48654 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab1EaTQp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:16:45 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 1/3] mac80211: remove the useless WLAN_STA_WDS station flag
Date: Tue, 31 May 2011 21:16:32 +0200
Message-Id: <1306869394-83047-1-git-send-email-nbd@openwrt.org> (sfid-20110531_211649_879867_A829A162)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/debugfs_sta.c |    3 +--
 net/mac80211/sta_info.h    |    2 --
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index a01d213..4a20722 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -59,7 +59,7 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 	char buf[100];
 	struct sta_info *sta = file->private_data;
 	u32 staflags = get_sta_flags(sta);
-	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s%s",
+	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s",
 		staflags & WLAN_STA_AUTH ? "AUTH\n" : "",
 		staflags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
 		staflags & WLAN_STA_PS_STA ? "PS (sta)\n" : "",
@@ -67,7 +67,6 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 		staflags & WLAN_STA_AUTHORIZED ? "AUTHORIZED\n" : "",
 		staflags & WLAN_STA_SHORT_PREAMBLE ? "SHORT PREAMBLE\n" : "",
 		staflags & WLAN_STA_WME ? "WME\n" : "",
-		staflags & WLAN_STA_WDS ? "WDS\n" : "",
 		staflags & WLAN_STA_MFP ? "MFP\n" : "");
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c6ae871..a5c231c 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -31,7 +31,6 @@
  *	frames.
  * @WLAN_STA_ASSOC_AP: We're associated to that station, it is an AP.
  * @WLAN_STA_WME: Station is a QoS-STA.
- * @WLAN_STA_WDS: Station is one of our WDS peers.
  * @WLAN_STA_CLEAR_PS_FILT: Clear PS filter in hardware (using the
  *	IEEE80211_TX_CTL_CLEAR_PS_FILT control flag) when the next
  *	frame to this station is transmitted.
@@ -54,7 +53,6 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_SHORT_PREAMBLE	= 1<<4,
 	WLAN_STA_ASSOC_AP	= 1<<5,
 	WLAN_STA_WME		= 1<<6,
-	WLAN_STA_WDS		= 1<<7,
 	WLAN_STA_CLEAR_PS_FILT	= 1<<9,
 	WLAN_STA_MFP		= 1<<10,
 	WLAN_STA_BLOCK_BA	= 1<<11,
-- 
1.7.3.2

