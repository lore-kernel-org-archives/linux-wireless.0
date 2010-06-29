Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38012 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab0F2Tuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:50:54 -0400
Received: by mail-wy0-f174.google.com with SMTP id 38so2999610wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:50:54 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/21] rt2x00: Remove unneeded variable
Date: Tue, 29 Jun 2010 21:39:29 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292138.56463.IvDoorn@gmail.com>
In-Reply-To: <201006292138.56463.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292139.30199.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <ivdoorn@gmail.com>

The update_bssid is set only when BSS_CHANGED_BSSID is used,
but the check if that field is true is done later in the function
but also only when BSS_CHANGED_BSSID is set. This makes the
variable useless, as it can never result in a negative check.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 2071cf3..3b838c0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -563,7 +563,6 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
-	int update_bssid = 0;
 
 	/*
 	 * mac80211 might be calling this function while we are trying
@@ -578,10 +577,8 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	 * conf->bssid can be NULL if coming from the internal
 	 * beacon update routine.
 	 */
-	if (changes & BSS_CHANGED_BSSID) {
-		update_bssid = 1;
+	if (changes & BSS_CHANGED_BSSID)
 		memcpy(&intf->bssid, bss_conf->bssid, ETH_ALEN);
-	}
 
 	spin_unlock(&intf->lock);
 
@@ -593,7 +590,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	 */
 	if (changes & BSS_CHANGED_BSSID)
 		rt2x00lib_config_intf(rt2x00dev, intf, vif->type, NULL,
-				      update_bssid ? bss_conf->bssid : NULL);
+				      bss_conf->bssid);
 
 	/*
 	 * Update the beacon.
-- 
1.6.6.1

