Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49468 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933175AbcJRUM1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 16:12:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 18 Oct 2016 23:12:13 +0300
Message-Id: <20161018201213.18873-8-luca@coelho.fi> (sfid-20161018_221237_612473_ACD011AE)
In-Reply-To: <20161018201213.18873-1-luca@coelho.fi>
References: <20161018201213.18873-1-luca@coelho.fi>
Subject: [PATCH 7/7] cfg80211: Call rdev_disconnect() when connection is in progress
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

On a disconnect request from user space, cfg80211 would have
called rdev_disconnect() only in case that 'current_bss' was set, i.e.,
connection has been established.

Change this, so rdev_disconnect() would be called also in case that
connection is in progress, so the connection attempt would be stopped.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h | 7 ++++---
 net/wireless/sme.c     | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 10a26f0..2bbbcc3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2564,9 +2564,10 @@ struct cfg80211_nan_func {
  *	cases, the result of roaming is indicated with a call to
  *	cfg80211_roamed() or cfg80211_roamed_bss().
  *	(invoked with the wireless_dev mutex held)
- * @disconnect: Disconnect from the BSS/ESS. Once done, call
- *	cfg80211_disconnected().
- *	(invoked with the wireless_dev mutex held)
+ * @disconnect: Disconnect from the BSS/ESS or stop connection attempts if
+ *      connection is in progress. Once done, call cfg80211_disconnected() in
+ *      case connection was already established (invoked with the
+ *      wireless_dev mutex held), otherwise call cfg80211_connect_timeout().
  *
  * @join_ibss: Join the specified IBSS (or create if necessary). Once done, call
  *	cfg80211_ibss_joined(), also call that function when changing BSSID due
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index a77db33..2b5bb38 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1088,7 +1088,7 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 		err = cfg80211_sme_disconnect(wdev, reason);
 	else if (!rdev->ops->disconnect)
 		cfg80211_mlme_down(rdev, dev);
-	else if (wdev->current_bss)
+	else if (wdev->ssid_len)
 		err = rdev_disconnect(rdev, dev, reason);
 
 	return err;
-- 
2.9.3
