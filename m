Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from londo.lunn.ch ([80.238.139.98]:36073 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbXLLQID (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 11:08:03 -0500
Date: Wed, 12 Dec 2007 16:31:58 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: flamingice@sourmilk.net, linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix swapped parameters to ieee80211_set_channel()
Message-ID: <20071212153158.GB16947@lunn.ch> (sfid-20071212_160807_495838_2B0FE495)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Folks

I found a silly typo in
net/mac80211/ieee80211_ioctl.c:ieee80211_ioctl_siwfreq().

The parameters passed to ieee80211_set_channel() should be 
(local, channel, freq), but in one instance it passes 
(local, freq, channel) which results in an EINVAL.

        Andrew

Signed-off-by: Andrew Lunn, <andrew@lunn.ch>
---
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 7027eed..d4a032e 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -344,7 +344,7 @@ static int ieee80211_ioctl_siwfreq(struct net_device *dev,
                                        IEEE80211_STA_AUTO_CHANNEL_SEL;
                        return 0;
                } else
-                       return ieee80211_set_channel(local, freq->m, -1);
+                        return ieee80211_set_channel(local, -1, freq->m);
        } else {
                int i, div = 1000000;
                for (i = 0; i < freq->e; i++)
