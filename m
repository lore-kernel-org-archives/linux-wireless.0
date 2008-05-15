Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:34303 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYEOWao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 18:30:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Association broken with wpa_supplicant
Date: Fri, 16 May 2008 00:30:10 +0200
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Message-Id: <200805160030.11244.mb@bu3sch.de> (sfid-20080516_003051_817717_1A6121D9)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Association is broken in latest wireless-testing when using
wpa_supplicant. It tells me

Trying to associate with REAL_BSSID...
Authentication with 00:00:00:00:00:00 timed out.

The commit responsible for the breakage is

Author: Abhijeet Kolekar <abhijeet.kolekar@intel.com>  2008-05-09 18:35:41
Committer: John W. Linville <linville@tuxdriver.com>  2008-05-15 22:11:19
Parent: 6d7ef8714c227884346aebd9f4e5eea302db6d22 (hostap: fix "registers" registration in procfs)
Child:  d67ec7fb2b8ce69709def2421ab893517b101591 (libertas: fix command timeout after firmware failure)
Branches: master, remotes/origin/master
Follows: master-2008-05-14
Precedes: master-2008-05-15

    mac80211 : Association with 11n hidden ssid ap.
    
    This patch fixes the association problem with 11n hidden ssid ap.
    Patch fixes the problem of associating with hidden ssid when
    all three parameters ap,essid and channel are given to iwconfig.
    This patch removes the condition of checking three parameters
    and always checks for bss in bss list while associating.
    
    Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

----------------------------- net/mac80211/mlme.c -----------------------------
index 7877d3b..508f675 100644
@@ -3434,13 +3434,6 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 	struct ieee80211_sta_bss *bss, *selected = NULL;
 	int top_rssi = 0, freq;
 
-	if (!(ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
-	    IEEE80211_STA_AUTO_BSSID_SEL | IEEE80211_STA_AUTO_CHANNEL_SEL))) {
-		ifsta->state = IEEE80211_AUTHENTICATE;
-		ieee80211_sta_reset_auth(dev, ifsta);
-		return 0;
-	}
-
 	spin_lock_bh(&local->sta_bss_lock);
 	freq = local->oper_channel->center_freq;
 	list_for_each_entry(bss, &local->sta_bss_list, list) {



Reverting this fixes the issue for me.

-- 
Greetings Michael.
