Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:27870 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757294AbXD0VGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 17:06:45 -0400
Message-ID: <4632614B.8060102@linux.intel.com>
Date: Fri, 27 Apr 2007 13:47:07 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <20070423184814.7029.8413.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184814.7029.8413.stgit@magic.sourmilk.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> From: Michael Wu <flamingice@sourmilk.net>
> 
> The hw_scan callback breaks the auto AP selection code in ieee80211_sta.c.
> No in-tree drivers use it either. This patch removes it.

The auto AP selection code is broken because ieee80211_sta_config_auth wasn't selecting a network if the RSSI was negative.)

Thanks,
James

----

[PATCH] Fix ieee80211_sta_config_auth to select networks if rssi < 0

The rssi check was against the top_rssi being less than the network
rssi.  However, 0 is higher than all negative rssi, so if an adapter
returned negative rssi values, auto AP selection would never work.

This patch changes behavior such if no network is currently selected it
ignores the rssi comparison and picks the network that matches all other criteria.

Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
---
 net/mac80211/ieee80211_sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 92e575a..6889e79 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2249,7 +2249,7 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 		    !ieee80211_sta_match_ssid(ifsta, bss->ssid, bss->ssid_len))
 			continue;
 
-		if (top_rssi < bss->rssi) {
+		if (!selected || top_rssi < bss->rssi) {
 			selected = bss;
 			top_rssi = bss->rssi;
 		}
-- 
1.5.0.6
