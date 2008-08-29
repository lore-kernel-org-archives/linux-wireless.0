Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:52045 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYH2SZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 14:25:29 -0400
Received: by ey-out-2122.google.com with SMTP id 6so314164eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 11:25:28 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] rt2x00: Need to set wiphy->interface_modes
Date: Fri, 29 Aug 2008 20:25:16 +0200
Cc: linux-wireless@vger.kernel.org,
	"rt2400-devel" <rt2400-devel@lists.sourceforge.net>,
	Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808292025.16870.IvDoorn@gmail.com> (sfid-20080829_202535_574951_8E5CB9BF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Below patch was created by Stephen Blackheath.

Could you merge this patch with your patch: 008-cfg80211-interface-types.patch
This is the required rt2x00 change for registering the supported interface types.

Thanks,

Ivo
---

Signed-off-by: Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 5278ae2..b363fad 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1052,6 +1052,11 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->hw->vif_data_size = sizeof(struct rt2x00_intf);
 
+	rt2x00dev->hw->wiphy->interface_modes =
+	    BIT(NL80211_IFTYPE_AP) |
+	    BIT(NL80211_IFTYPE_STATION) |
+	    BIT(NL80211_IFTYPE_ADHOC);
+
 	/*
 	 * Let the driver probe the device to detect the capabilities.
 	 */
-- 
1.5.6.1

