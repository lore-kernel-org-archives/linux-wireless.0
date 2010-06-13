Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57309 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab0FMSQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 14:16:12 -0400
Received: by wyb40 with SMTP id 40so3059281wyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jun 2010 11:16:11 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] rt2x00: Disable Mesh mode for USB drivers
Date: Sun, 13 Jun 2010 20:16:07 +0200
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <201006132015.10629.IvDoorn@gmail.com>
In-Reply-To: <201006132015.10629.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006132016.08975.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bss_info_changed must be atomic in Mesh mode.
As a result it must be disabled for all USB drivers.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 7d30efd..8661ada 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -852,13 +852,22 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	 * beacon entries.
 	 */
 	rt2x00dev->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
-	if (rt2x00dev->ops->bcn->entry_num > 0)
+	if (rt2x00dev->ops->bcn->entry_num > 0) {
 		rt2x00dev->hw->wiphy->interface_modes |=
 		    BIT(NL80211_IFTYPE_ADHOC) |
 		    BIT(NL80211_IFTYPE_AP) |
-		    BIT(NL80211_IFTYPE_MESH_POINT) |
 		    BIT(NL80211_IFTYPE_WDS);
 
+		/*
+ 		 * The bss_info_changed() callback function is not
+ 		 * allowed to sleep in mesh mode. As a result, we
+ 		 * can't support Mesh mode for the USB drivers.
+ 		 */
+		if (!rt2x00_is_usb(rt2x00dev))
+			rt2x00dev->hw->wiphy->interface_modes |=
+			    BIT(NL80211_IFTYPE_MESH_POINT);
+	}
+
 	/*
 	 * Let the driver probe the device to detect the capabilities.
 	 */
-- 
1.6.6.1

