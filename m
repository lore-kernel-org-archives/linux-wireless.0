Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:49391 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYAMNQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 08:16:57 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1858188fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 05:16:55 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] mac80211: Initialize vif pointer
Date: Sun, 13 Jan 2008 14:16:47 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sf.net
References: <200801131402.26165.IvDoorn@gmail.com>
In-Reply-To: <200801131402.26165.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801131416.47515.IvDoorn@gmail.com> (sfid-20080113_131659_447500_2F73003D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before calling update_beacon() mac80211 must
initialize the control.vif pointer so it can
be used by the driver to determine which
interface is trying to send the beacon.

v2: ieee80211_beacon_get() should also initialize the
vif pointer since it can be called by mac80211 internally
before calling config_interface().

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

---
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 4f5d5c6..13046fb 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2542,6 +2542,7 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 			       "for IBSS beacon\n", dev->name);
 			break;
 		}
+		control.vif = &sdata->vif;
 		control.tx_rate =
 			(sdata->bss_conf.use_short_preamble &&
 			(ratesel.rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 382f24b..545ac30 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1753,6 +1753,7 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 			goto out;
 		}
 
+		control->vif = vif;
 		control->tx_rate =
 			(sdata->bss_conf.use_short_preamble &&
 			(rsel.rate->flags & IEEE80211_RATE_PREAMBLE2)) ?


