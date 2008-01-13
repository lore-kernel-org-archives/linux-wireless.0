Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:22788 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbYAMNCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 08:02:35 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1854425fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 05:02:33 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Initialize vif pointer
Date: Sun, 13 Jan 2008 14:02:26 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sf.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801131402.26165.IvDoorn@gmail.com> (sfid-20080113_130244_390201_5373C434)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before calling update_beacon() mac80211 must
initialize the control.vif pointer so it can
be used by the driver to determine which
interface is trying to send the beacon.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 4f5d5c6..8a35fed 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2536,6 +2536,7 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 		}
 
 		memset(&control, 0, sizeof(control));
+		control.vif = &sdata->vif;
 		rate_control_get_rate(dev, local->oper_hw_mode, skb, &ratesel);
 		if (!ratesel.rate) {
 			printk(KERN_DEBUG "%s: Failed to determine TX rate "
