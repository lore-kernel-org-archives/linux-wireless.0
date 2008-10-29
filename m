Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:53049 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbYJ2Q2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 12:28:49 -0400
Received: by ug-out-1314.google.com with SMTP id 39so662679ugf.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 09:28:47 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/5] rt2x00: Remove ieee80211_bss_conf from rt2x00_intf
Date: Wed, 29 Oct 2008 17:18:22 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200810291716.47342.IvDoorn@gmail.com> <200810291717.57687.IvDoorn@gmail.com>
In-Reply-To: <200810291717.57687.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810291718.22724.IvDoorn@gmail.com> (sfid-20081029_172914_722020_CE4E5D70)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can safely remove ieee80211_bss_conf from rt2x00_intf,
it is provided by mac80211 in ieee80211_vif as well.
(rt2x00_intf is the drv_priv field of ieee80211_vif).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    7 -------
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c |    1 -
 3 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 4d983e6..ca1f9fe 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -348,13 +348,6 @@ struct rt2x00_intf {
 	spinlock_t lock;
 
 	/*
-	 * BSS configuration. Copied from the structure
-	 * passed to us through the bss_info_changed()
-	 * callback funtion.
-	 */
-	struct ieee80211_bss_conf conf;
-
-	/*
 	 * MAC of the device.
 	 */
 	u8 mac[ETH_ALEN];
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e1feab8..c42e4fd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -417,7 +417,7 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 	 */
 	spin_lock(&intf->lock);
 
-	memcpy(&conf, &intf->conf, sizeof(conf));
+	memcpy(&conf, &vif->bss_conf, sizeof(conf));
 	delayed_flags = intf->delayed_flags;
 	intf->delayed_flags = 0;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 3a3b5ad..8fc2315 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -634,7 +634,6 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	spin_lock(&intf->lock);
-	memcpy(&intf->conf, bss_conf, sizeof(*bss_conf));
 	if (delayed) {
 		intf->delayed_flags |= delayed;
 		schedule_work(&rt2x00dev->intf_work);
-- 
1.5.6.1

