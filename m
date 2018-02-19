Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59724 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752897AbeBSMs7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:48:59 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Feb 2018 14:48:38 +0200
Message-Id: <20180219124847.27169-5-luca@coelho.fi> (sfid-20180219_134904_427772_D1F20C7C)
In-Reply-To: <20180219124847.27169-1-luca@coelho.fi>
References: <20180219124847.27169-1-luca@coelho.fi>
Subject: [PATCH v2 04/13] cfg80211: clear wep keys after disconnection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

When a low level driver calls cfg80211_disconnected(), wep keys are
not cleared. As a result, following connection requests will fail
since cfg80211 internal state shows a connection is still in progress.

Fix this by clearing the wep keys when disconnecting.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/sme.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index fdb3646274a5..701cfd7acc1b 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1032,6 +1032,8 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 	wdev->current_bss = NULL;
 	wdev->ssid_len = 0;
 	wdev->conn_owner_nlportid = 0;
+	kzfree(wdev->connect_keys);
+	wdev->connect_keys = NULL;
 
 	nl80211_send_disconnected(rdev, dev, reason, ie, ie_len, from_ap);
 
-- 
2.15.1
