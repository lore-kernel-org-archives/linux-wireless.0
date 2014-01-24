Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:42582 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaAXN3i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 08:29:38 -0500
Received: by mail-ee0-f43.google.com with SMTP id c41so970852eek.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 05:29:35 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] cfg80211: set preset_chandef after channel switch
Date: Fri, 24 Jan 2014 14:29:21 +0100
Message-Id: <1390570161-25041-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140124_142941_176841_D4219BA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set preset_chandef in channel switch notification.
In other case we will have old preset_chandef.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/nl80211.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d0afd82..dc8621d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11144,6 +11144,7 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 		return;
 
 	wdev->channel = chandef->chan;
+	wdev->preset_chandef = *chandef;
 	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL);
 }
 EXPORT_SYMBOL(cfg80211_ch_switch_notify);
-- 
1.7.9.5

