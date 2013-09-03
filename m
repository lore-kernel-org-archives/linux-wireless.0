Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:51719 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827Ab3ICRne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 13:43:34 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 1/4] nl80211: allow CAC only if no operation is going on
Date: Tue,  3 Sep 2013 19:43:18 +0200
Message-Id: <1378230201-25446-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130903_194340_423135_C26CF35A)
In-Reply-To: <1378230201-25446-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1378230201-25446-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A CAC should fail if it is triggered while the interface is already
running.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/wireless/nl80211.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index da8de5b..cbbef88 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5591,6 +5591,9 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (err)
 		return err;
 
+	if (netif_carrier_ok(dev))
+		return -EBUSY;
+
 	if (wdev->cac_started)
 		return -EBUSY;
 
-- 
1.7.10.4

