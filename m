Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-4.linta.de ([136.243.71.142]:55610 "EHLO
        isilmar-4.linta.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751622AbeANSML (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Jan 2018 13:12:11 -0500
Date: Sun, 14 Jan 2018 19:03:38 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: johannes.berg@intel.com
Cc: regressions@leemhuis.info, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nl80211: take RCU read lock when calling
 ieee80211_bss_get_ie()
Message-ID: <20180114180338.GA1569@light.dominikbrodowski.net> (sfid-20180114_191214_897937_AE8397B8)
References: <20171222072012.GA3110@light.dominikbrodowski.net>
 <20171230131132.GA2624@light.dominikbrodowski.net>
 <20180108100403.GA4715@light.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180108100403.GA4715@light.dominikbrodowski.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As ieee80211_bss_get_ie() derefences an RCU, it needs to be called with
rcu_read_lock held.

Fixes: 44905265bc15 ("nl80211: don't expose wdev->ssid for most interfaces")
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
---

This patch fixes the regression I reported in the last couple of weeks for
various v4.15-rcX revisions to netdev, where a "suspicious RCU usage"
showed up in net/wireless/util.c:778.

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2b3dbcd40e46..1eecc249fb5e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2618,8 +2618,10 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		const u8 *ssid_ie;
 		if (!wdev->current_bss)
 			break;
+		rcu_read_lock();
 		ssid_ie = ieee80211_bss_get_ie(&wdev->current_bss->pub,
 					       WLAN_EID_SSID);
+		rcu_read_unlock();
 		if (!ssid_ie)
 			break;
 		if (nla_put(msg, NL80211_ATTR_SSID, ssid_ie[1], ssid_ie + 2))
