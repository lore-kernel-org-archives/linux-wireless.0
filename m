Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36776 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1BJP0x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 10:26:53 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] compat-wireless: brcm80211 adapt changes in mac80211
Date: Thu, 10 Feb 2011 16:26:28 +0100
Message-Id: <1297351590-24019-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1297351590-24019-1-git-send-email-hauke@hauke-m.de>
References: <1297351590-24019-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interface to mac80211 changes and brcm80211 uses the old one.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/38-brcm80211-mac80211-backport.patch |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 patches/38-brcm80211-mac80211-backport.patch

diff --git a/patches/38-brcm80211-mac80211-backport.patch b/patches/38-brcm80211-mac80211-backport.patch
new file mode 100644
index 0000000..329a119
--- /dev/null
+++ b/patches/38-brcm80211-mac80211-backport.patch
@@ -0,0 +1,14 @@
+This patch is a temporary solution as long as staging uses an older 
+version of mac80211.
+
+--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
++++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+@@ -2312,7 +2312,7 @@ static s32 wl_inform_single_bss(struct w
+ 	notif_bss_info->frame_len =
+ 	    offsetof(struct ieee80211_mgmt,
+ 		     u.beacon.variable) + wl_get_ielen(wl);
+-	freq = ieee80211_channel_to_frequency(notif_bss_info->channel);
++	freq = ieee80211_channel_to_frequency(notif_bss_info->channel, notif_bss_info->band);
+ 	channel = ieee80211_get_channel(wiphy, freq);
+ 
+ 	WL_DBG("SSID : \"%s\", rssi %d, channel %d, capability : 0x04%x, bssid %pM\n",
-- 
1.7.1

