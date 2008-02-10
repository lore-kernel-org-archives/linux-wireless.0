Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:38996 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYBJVxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:53:39 -0500
Received: by fk-out-0910.google.com with SMTP id z23so4239380fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:53:38 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 07/14] rt2x00: Fix scheduling while atomic errors in usb drivers
Date: Sun, 10 Feb 2008 22:50:04 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102250.04269.IvDoorn@gmail.com> (sfid-20080210_215342_242593_944C4CE4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Call rt2x00_config_intf() outside of the spinlock context since
the call will sleep for USB drivers. By using the ieee80211_if_conf
values as arguments we make keep access tp rt2x00_intf thread safe
even without the lock.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 8c24d3b..91b62dd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -334,11 +334,18 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw,
 	 */
 	if (conf->type != IEEE80211_IF_TYPE_AP)
 		memcpy(&intf->bssid, conf->bssid, ETH_ALEN);
-	rt2x00lib_config_intf(rt2x00dev, intf, conf->type, NULL, intf->bssid);
 
 	spin_unlock(&intf->lock);
 
 	/*
+	 * Call rt2x00_config_intf() outside of the spinlock context since
+	 * the call will sleep for USB drivers. By using the ieee80211_if_conf
+	 * values as arguments we make keep access to rt2x00_intf thread safe
+	 * even without the lock.
+	 */
+	rt2x00lib_config_intf(rt2x00dev, intf, conf->type, NULL, conf->bssid);
+
+	/*
 	 * We only need to initialize the beacon when master mode is enabled.
 	 */
 	if (conf->type != IEEE80211_IF_TYPE_AP || !conf->beacon)
-- 
1.5.4

