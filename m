Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4494 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbYEPPUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 11:20:54 -0400
Date: Fri, 16 May 2008 10:58:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Association broken with wpa_supplicant
Message-ID: <20080516145832.GA6510@tuxdriver.com> (sfid-20080516_172058_836861_E227B5B8)
References: <200805160030.11244.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805160030.11244.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 16, 2008 at 12:30:10AM +0200, Michael Buesch wrote:
> Hi John,
> 
> Association is broken in latest wireless-testing when using
> wpa_supplicant. It tells me
> 
> Trying to associate with REAL_BSSID...
> Authentication with 00:00:00:00:00:00 timed out.
> 
> The commit responsible for the breakage is
> 
> Author: Abhijeet Kolekar <abhijeet.kolekar@intel.com>  2008-05-09 18:35:41
> Committer: John W. Linville <linville@tuxdriver.com>  2008-05-15 22:11:19
> Parent: 6d7ef8714c227884346aebd9f4e5eea302db6d22 (hostap: fix "registers" registration in procfs)
> Child:  d67ec7fb2b8ce69709def2421ab893517b101591 (libertas: fix command timeout after firmware failure)
> Branches: master, remotes/origin/master
> Follows: master-2008-05-14
> Precedes: master-2008-05-15
> 
>     mac80211 : Association with 11n hidden ssid ap.

Instead of reverting it, could you try applying this one on top of it?

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 508f675..76ad4ed 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3440,8 +3440,11 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 		if (!(bss->capability & WLAN_CAPABILITY_ESS))
 			continue;
 
-		if (!!(bss->capability & WLAN_CAPABILITY_PRIVACY) ^
-		    !!sdata->default_key)
+		if ((ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
+			IEEE80211_STA_AUTO_BSSID_SEL |
+			IEEE80211_STA_AUTO_CHANNEL_SEL)) &&
+		    (!!(bss->capability & WLAN_CAPABILITY_PRIVACY) ^
+		     !!sdata->default_key))
 			continue;
 
 		if (!(ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL) &&
-- 
John W. Linville
linville@tuxdriver.com
