Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60593 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3KQJlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Nov 2013 04:41:02 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.13] cfg80211: disable 5/10 MHz support for all drivers
Date: Sun, 17 Nov 2013 10:40:55 +0100
Message-Id: <1384681255-17152-1-git-send-email-johannes@sipsolutions.net> (sfid-20131117_104107_954410_B26E4250)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to nl80211 API breakage, 5/10 MHz support is broken for
all drivers. Fixing it requires adding new API, but that
can't be done as a bugfix commit since that would require
either updating all APIs in the trees needing the bugfix or
cause different kernels to have incompatible API.

Therefore, just disable 5/10 MHz support for all drivers.

Cc: stable@vger.kernel.org [3.12]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index aff959e..00a65ba 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -451,6 +451,9 @@ int wiphy_register(struct wiphy *wiphy)
 	int i;
 	u16 ifmodes = wiphy->interface_modes;
 
+	/* support for 5/10 MHz is broken due to nl80211 API mess - disable */
+	wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_5_10_MHZ;
+
 #ifdef CONFIG_PM
 	if (WARN_ON(wiphy->wowlan &&
 		    (wiphy->wowlan->flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&
-- 
1.8.4.rc3

