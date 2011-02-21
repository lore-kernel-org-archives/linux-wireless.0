Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36290 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab1BUWbr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 17:31:47 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/7] compat-wireless: brcm80211 fix is in upstream now
Date: Mon, 21 Feb 2011 23:31:21 +0100
Message-Id: <1298327484-16938-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1298327484-16938-1-git-send-email-hauke@hauke-m.de>
References: <1298327484-16938-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/38-brcm80211-mac80211-backport.patch |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)
 delete mode 100644 patches/38-brcm80211-mac80211-backport.patch

diff --git a/patches/38-brcm80211-mac80211-backport.patch b/patches/38-brcm80211-mac80211-backport.patch
deleted file mode 100644
index 329a119..0000000
--- a/patches/38-brcm80211-mac80211-backport.patch
+++ /dev/null
@@ -1,14 +0,0 @@
-This patch is a temporary solution as long as staging uses an older 
-version of mac80211.
-
---- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
-+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
-@@ -2312,7 +2312,7 @@ static s32 wl_inform_single_bss(struct w
- 	notif_bss_info->frame_len =
- 	    offsetof(struct ieee80211_mgmt,
- 		     u.beacon.variable) + wl_get_ielen(wl);
--	freq = ieee80211_channel_to_frequency(notif_bss_info->channel);
-+	freq = ieee80211_channel_to_frequency(notif_bss_info->channel, notif_bss_info->band);
- 	channel = ieee80211_get_channel(wiphy, freq);
- 
- 	WL_DBG("SSID : \"%s\", rssi %d, channel %d, capability : 0x04%x, bssid %pM\n",
-- 
1.7.1

