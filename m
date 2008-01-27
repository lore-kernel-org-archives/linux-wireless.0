Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54174 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbYA0OTd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 09:19:33 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: set assoc flag to bss_conf
Date: Sun, 27 Jan 2008 16:18:22 +0200
Message-Id: <12014435022755-git-send-email-tomas.winkler@intel.com> (sfid-20080127_141938_114099_DB9B65D9)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only BSS_CHANGED_ASSOC was set in the 'changed' bitmask. Assignment  to
bss_conf.assoc was absent.
This patch assign value to  bss_conf.assoc according the association state.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/ieee80211_sta.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index d252d09..2c4692b 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -492,6 +492,7 @@ static void ieee80211_set_associated(struct net_device *dev,
 	ifsta->last_probe = jiffies;
 	ieee80211_led_assoc(local, assoc);
 
+	sdata->bss_conf.assoc = assoc;
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
-- 
1.5.2.2

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

