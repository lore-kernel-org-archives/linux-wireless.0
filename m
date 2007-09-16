Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbXIPMHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:07:53 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:07:53 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/24] rt2x00: Don't allow configuration calls when uninitialized
Date: Sun, 16 Sep 2007 14:18:05 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161418.06645.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a device is being hot-unplugged or during suspend/resume
rt2x00 is not able to handle configuration calls from mac80211.
Check for the DEVICE_INITIALIZED flag to determine if a
configuration call from mac80211 is welcome or not.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index f25cf38..0001b79 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -245,6 +245,15 @@ int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
 	/*
+	 * If the device is not initialized we shouldn't accept
+	 * any configuration changes. Mac80211 might be calling
+	 * this function while we are trying to remove the device
+	 * or perhaps suspending it.
+	 */
+	if (!test_bit(DEVICE_INITIALIZED, &rt2x00dev->flags))
+		return 0;
+
+	/*
 	 * Check if we need to disable the radio,
 	 * if this is not the case, at least the RX must be disabled.
 	 */
@@ -285,6 +294,15 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw, int if_id,
 	int status;
 
 	/*
+	 * If the device is not initialized we shouldn't accept
+	 * any configuration changes. Mac80211 might be calling
+	 * this function while we are trying to remove the device
+	 * or perhaps suspending it.
+	 */
+	if (!test_bit(DEVICE_INITIALIZED, &rt2x00dev->flags))
+		return 0;
+
+	/*
 	 * Monitor mode does not need configuring.
 	 * If the given type does not match the configured type,
 	 * there has been a problem.
-- 
1.5.3
