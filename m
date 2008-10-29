Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:58602 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYJ2Q2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 12:28:51 -0400
Received: by nf-out-0910.google.com with SMTP id d3so44523nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 09:28:49 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/5] rt2x00: Improve interface_modes initialization
Date: Wed, 29 Oct 2008 17:18:46 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200810291716.47342.IvDoorn@gmail.com> <200810291717.57687.IvDoorn@gmail.com> <200810291718.22724.IvDoorn@gmail.com>
In-Reply-To: <200810291718.22724.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810291718.46231.IvDoorn@gmail.com> (sfid-20081029_172915_538201_79203D5E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All operating modes which require beaconing should
depend on the availability of beacon entries from
the hardware.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c42e4fd..477a944 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1056,10 +1056,16 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->hw->vif_data_size = sizeof(struct rt2x00_intf);
 
-	rt2x00dev->hw->wiphy->interface_modes =
-	    BIT(NL80211_IFTYPE_AP) |
-	    BIT(NL80211_IFTYPE_STATION) |
-	    BIT(NL80211_IFTYPE_ADHOC);
+	/*
+	 * Determine which operating modes are supported, all modes
+	 * which require beaconing, depend on the availability of
+	 * beacon entries.
+	 */
+	rt2x00dev->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	if (rt2x00dev->ops->bcn->entry_num > 0)
+		rt2x00dev->hw->wiphy->interface_modes |=
+		    BIT(NL80211_IFTYPE_ADHOC) |
+		    BIT(NL80211_IFTYPE_AP);
 
 	/*
 	 * Let the driver probe the device to detect the capabilities.
-- 
1.5.6.1

