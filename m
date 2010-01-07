Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:39180 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab0AGOBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 09:01:45 -0500
Date: Thu, 7 Jan 2010 15:01:42 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: mac80211: fix queue selection for packets injected via monitor interface
Message-ID: <20100107140137.GA32125@mail.wantstofly.org>
References: <1262710858.28653.5.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1262710858.28653.5.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 'mac80211: fix skb buffering issue' added an ->ndo_select_queue()
for monitor interfaces which can end up dereferencing ieee802_1d_to_ac[]
beyond the end of the array for injected data packets (as skb->priority
isn't guaranteed to be zero or within [0:7]), which then triggers the
WARN_ON in net/core/dev.c:dev_cap_txqueue().  Fix this by always setting
the priority to zero on injected data frames.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
--
We have seen some crashing with crypto enabled with the multiqueue
patch due to this issue, so some fix along these lines is fairly
important.

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c20dddd..2f34662 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -699,6 +699,7 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 		return ieee802_1d_to_ac[skb->priority];
 	}
 
+	skb->priority = 0;
 	return ieee80211_downgrade_queue(local, skb);
 }
 
---
