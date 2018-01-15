Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-4.linta.de ([136.243.71.142]:58432 "EHLO
        isilmar-4.linta.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753926AbeAOHMl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 02:12:41 -0500
Date: Mon, 15 Jan 2018 08:12:15 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: regressions@leemhuis.info, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] nl80211: take RCU read lock when calling
 ieee80211_bss_get_ie()
Message-ID: <20180115071215.GA2639@light.dominikbrodowski.net> (sfid-20180115_081301_854981_3D204A89)
References: <20171222072012.GA3110@light.dominikbrodowski.net>
 <20171230131132.GA2624@light.dominikbrodowski.net>
 <20180108100403.GA4715@light.dominikbrodowski.net>
 <20180114180338.GA1569@light.dominikbrodowski.net>
 <1515967102.26804.31.camel@sipsolutions.net>
 <20180114222255.GA9036@light.dominikbrodowski.net>
 <1515969647.26804.33.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515969647.26804.33.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As ieee80211_bss_get_ie() derefences an RCU to return ssid_ie, both
the call to this function and any operation on this variable need
protection by the RCU read lock.

Fixes: 44905265bc15 ("nl80211: don't expose wdev->ssid for most interfaces")
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
---

> but after, perhaps it's easier to just do
> 
> 		if (ssid_ie &&
> 		    nla_put(...)
> 			goto nla_put_failure_rcu_locked;
> 
> and avoid the extra label (but yeah, it's getting late)

OK, done that (and updated the commit message), and testet it.

Thanks,
	Dominik

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2b3dbcd40e46..ed87a97fcb0b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2618,12 +2618,13 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		const u8 *ssid_ie;
 		if (!wdev->current_bss)
 			break;
+		rcu_read_lock();
 		ssid_ie = ieee80211_bss_get_ie(&wdev->current_bss->pub,
 					       WLAN_EID_SSID);
-		if (!ssid_ie)
-			break;
-		if (nla_put(msg, NL80211_ATTR_SSID, ssid_ie[1], ssid_ie + 2))
-			goto nla_put_failure_locked;
+		if (ssid_ie &&
+		    nla_put(msg, NL80211_ATTR_SSID, ssid_ie[1], ssid_ie + 2))
+			goto nla_put_failure_rcu_locked;
+		rcu_read_unlock();
 		break;
 		}
 	default:
@@ -2635,6 +2636,8 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	genlmsg_end(msg, hdr);
 	return 0;
 
+ nla_put_failure_rcu_locked:
+	rcu_read_unlock();
  nla_put_failure_locked:
 	wdev_unlock(wdev);
  nla_put_failure:
