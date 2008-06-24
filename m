Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23304 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbYFXKiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 06:38:08 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/4] mac80211: update the authentication method
Date: Tue, 24 Jun 2008 13:37:59 +0300
Message-Id: <1214303881-31525-3-git-send-email-tomas.winkler@intel.com> (sfid-20080624_123814_966877_416C2351)
In-Reply-To: <1214303881-31525-2-git-send-email-tomas.winkler@intel.com>
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
 <1214303881-31525-2-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch updates the authentication method upon giwencode ioctl.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/wext.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 53f8767..308b953 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -952,6 +952,19 @@ static int ieee80211_ioctl_giwencode(struct net_device *dev,
 	erq->length = sdata->keys[idx]->conf.keylen;
 	erq->flags |= IW_ENCODE_ENABLED;
 
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+		switch (ifsta->auth_alg) {
+		case WLAN_AUTH_OPEN:
+		case WLAN_AUTH_LEAP:
+			erq->flags |= IW_ENCODE_OPEN;
+			break;
+		case WLAN_AUTH_SHARED_KEY:
+			erq->flags |= IW_ENCODE_RESTRICTED;
+			break;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

