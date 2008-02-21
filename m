Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2134 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759666AbYBURcN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 12:32:13 -0500
Date: Thu, 21 Feb 2008 12:25:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull request: wireless-2.6.26 2008-02-21
Message-ID: <20080221172525.GI3094@tuxdriver.com> (sfid-20080221_173220_952105_631262EC)
References: <20080221021530.GG3825@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080221021530.GG3825@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2008 at 09:15:30PM -0500, John W. Linville wrote:

> Here are a slew of developments intended for 2.6.26.  The patches are
> too diverse to comment upon in this summary... :-)

David,

This is additive on top of the pull request from last night.  Only
Pavel's fix for the brown-paper-bag CONFIG_MAC80211_IBSS_DEBUG build
issue is applied on top of the previous commits.

Please let me know if there are problems!

Thanks,

John

---

The following changes since commit 4d161f9d7f3f3ce069006b53dc8a84ed8a33753f:
  Johannes Berg (1):
        p54: fix sparse warnings

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git

Pavel Roskin (1):
      mac80211: fix incorrect use of CONFIG_MAC80211_IBSS_DEBUG

 net/mac80211/ieee80211_sta.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 05cc908..453d14a 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2452,10 +2452,12 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 		       jiffies);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 		if (beacon_timestamp > rx_timestamp) {
-			if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+			if (net_ratelimit())
 				printk(KERN_DEBUG "%s: beacon TSF higher than "
 				       "local TSF - IBSS merge with BSSID %s\n",
 				       dev->name, print_mac(mac, mgmt->bssid));
+#endif /* CONFIG_MAC80211_IBSS_DEBUG */
 			ieee80211_sta_join_ibss(dev, &sdata->u.sta, bss);
 			ieee80211_ibss_add_sta(dev, NULL,
 					       mgmt->bssid, mgmt->sa);
-- 
John W. Linville
linville@tuxdriver.com
