Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-4.linta.de ([136.243.71.142]:40310 "EHLO
        isilmar-4.linta.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752124AbeANWXW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Jan 2018 17:23:22 -0500
Date: Sun, 14 Jan 2018 23:22:55 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: regressions@leemhuis.info, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] nl80211: take RCU read lock when calling
 ieee80211_bss_get_ie()
Message-ID: <20180114222255.GA9036@light.dominikbrodowski.net> (sfid-20180114_232343_903803_D9759E03)
References: <20171222072012.GA3110@light.dominikbrodowski.net>
 <20171230131132.GA2624@light.dominikbrodowski.net>
 <20180108100403.GA4715@light.dominikbrodowski.net>
 <20180114180338.GA1569@light.dominikbrodowski.net>
 <1515967102.26804.31.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515967102.26804.31.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As ieee80211_bss_get_ie() derefences an RCU, it needs to be called with
rcu_read_lock held.

Fixes: 44905265bc15 ("nl80211: don't expose wdev->ssid for most interfaces")
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
---

> This uses the ssid_ie, so that doesn't really seem right? The
> protection should extend beyond the usage.

Indeed -- I had misread the code and hadn't thought of ssid_ie also needing
the protection during its lifetime. So here's a new version 2 -- which I
will only be able to test tomorrow, though...

Thanks,
	Dominik

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2b3dbcd40e46..b53bd8db7974 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2618,12 +2618,15 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		const u8 *ssid_ie;
 		if (!wdev->current_bss)
 			break;
+		rcu_read_lock();
 		ssid_ie = ieee80211_bss_get_ie(&wdev->current_bss->pub,
 					       WLAN_EID_SSID);
 		if (!ssid_ie)
-			break;
+			goto nla_rcu_unlock;
 		if (nla_put(msg, NL80211_ATTR_SSID, ssid_ie[1], ssid_ie + 2))
-			goto nla_put_failure_locked;
+			goto nla_put_failure_rcu_locked;
+ nla_rcu_unlock:
+		rcu_read_unlock();
 		break;
 		}
 	default:
@@ -2635,6 +2638,8 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	genlmsg_end(msg, hdr);
 	return 0;
 
+ nla_put_failure_rcu_locked:
+	rcu_read_unlock();
  nla_put_failure_locked:
 	wdev_unlock(wdev);
  nla_put_failure:
