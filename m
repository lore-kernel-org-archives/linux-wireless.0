Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38767 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab0L0OI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 09:08:26 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so8482816wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 06:08:26 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/10] rt2x00: Fix comment about removed spinlock
Date: Mon, 27 Dec 2010 15:07:35 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012271504.30848.IvDoorn@gmail.com> <201012271506.58485.IvDoorn@gmail.com> <201012271507.17065.IvDoorn@gmail.com>
In-Reply-To: <201012271507.17065.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012271507.36789.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

The comment doesn't match the code anymore. Fix that.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index b5dad04..658542d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -610,10 +610,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 		return;
 
 	/*
-	 * Call rt2x00_config_intf() outside of the spinlock context since
-	 * the call will sleep for USB drivers. By using the ieee80211_if_conf
-	 * values as arguments we make keep access to rt2x00_intf thread safe
-	 * even without the lock.
+	 * Update the BSSID.
 	 */
 	if (changes & BSS_CHANGED_BSSID)
 		rt2x00lib_config_intf(rt2x00dev, intf, vif->type, NULL,
-- 
1.7.2.3

