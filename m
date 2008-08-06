Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:23664 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020AbYHFN6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 09:58:19 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1135892nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 06:58:18 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] rt2x00: Block all unsupported modes
Date: Wed, 6 Aug 2008 16:18:31 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200808061617.44704.IvDoorn@gmail.com>
In-Reply-To: <200808061617.44704.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808061618.31229.IvDoorn@gmail.com> (sfid-20080806_155823_665856_068BE29F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible for unsupported operating modes
to be accepted by the add_interface callback function.
This patch will block those modes until proper support
has been implemented for them.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |   54 +++++++++++++++++++++----------
 1 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index bb9d489..3af4273 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -210,23 +210,43 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	    !test_bit(DEVICE_STARTED, &rt2x00dev->flags))
 		return -ENODEV;
 
-	/*
-	 * We don't support mixed combinations of sta and ap virtual
-	 * interfaces. We can only add this interface when the rival
-	 * interface count is 0.
-	 */
-	if ((conf->type == IEEE80211_IF_TYPE_AP && rt2x00dev->intf_sta_count) ||
-	    (conf->type != IEEE80211_IF_TYPE_AP && rt2x00dev->intf_ap_count))
-		return -ENOBUFS;
-
-	/*
-	 * Check if we exceeded the maximum amount of supported interfaces.
-	 */
-	if ((conf->type == IEEE80211_IF_TYPE_AP &&
-	     rt2x00dev->intf_ap_count >= rt2x00dev->ops->max_ap_intf) ||
-	    (conf->type != IEEE80211_IF_TYPE_AP &&
-	     rt2x00dev->intf_sta_count >= rt2x00dev->ops->max_sta_intf))
-		return -ENOBUFS;
+	switch (conf->type) {
+	case IEEE80211_IF_TYPE_AP:
+		/*
+		 * We don't support mixed combinations of
+		 * sta and ap interfaces.
+		 */
+		if (rt2x00dev->intf_sta_count)
+			return -ENOBUFS;
+
+		/*
+		 * Check if we exceeded the maximum amount
+		 * of supported interfaces.
+		 */
+		if (rt2x00dev->intf_ap_count >= rt2x00dev->ops->max_ap_intf)
+			return -ENOBUFS;
+
+		break;
+	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_IBSS:
+		/*
+		 * We don't support mixed combinations of
+		 * sta and ap interfaces.
+		 */
+		if (rt2x00dev->intf_ap_count)
+			return -ENOBUFS;
+
+		/*
+		 * Check if we exceeded the maximum amount
+		 * of supported interfaces.
+		 */
+		if (rt2x00dev->intf_sta_count >= rt2x00dev->ops->max_sta_intf)
+			return -ENOBUFS;
+
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	/*
 	 * Loop through all beacon queues to find a free
-- 
1.5.6.1

