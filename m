Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:53501 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab3DJLsi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 07:48:38 -0400
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH] mac80211: clear SSID when stoping AP
Date: Wed, 10 Apr 2013 13:47:45 +0200
Message-ID: <1365594465-6405-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20130410_134842_392801_584081AD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When AP interface was stopped ssid and ssid_len from bss configuration
was not cleared. This caused a problem when after AP interface was stopped
another AP with shorter ssid was created. Previous ssid was not
overwriten by new one shorter.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 net/mac80211/cfg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c50c194..5c4cb08 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1048,6 +1048,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	ieee80211_free_keys(sdata);
 
 	sdata->vif.bss_conf.enable_beacon = false;
+	sdata->vif.bss_conf.ssid_len = 0;
+	memset(sdata->vif.bss_conf.ssid, 0, IEEE80211_MAX_SSID_LEN);
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
-- 
1.7.0.4

