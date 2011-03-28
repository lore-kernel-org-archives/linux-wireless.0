Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58041 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab1C1Lgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 07:36:53 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so3686803wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 04:36:53 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/13] rt2x00: Remove DRIVER_SUPPORT_WATCHDOG flag
Date: Mon, 28 Mar 2011 13:30:59 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103281329.45470.IvDoorn@gmail.com> <201103281330.10560.IvDoorn@gmail.com> <201103281330.36856.IvDoorn@gmail.com>
In-Reply-To: <201103281330.36856.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103281331.00838.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

We can simply check if the driver registered the watchdog callback.
There's no need to have an additional flag for that.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c  |    1 -
 drivers/net/wireless/rt2x00/rt2800usb.c  |    1 -
 drivers/net/wireless/rt2x00/rt2x00.h     |    1 -
 drivers/net/wireless/rt2x00/rt2x00link.c |   11 +++++------
 drivers/net/wireless/rt2x00/rt73usb.c    |    1 -
 5 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 979fe65..d9e6cec 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1796,7 +1796,6 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 		__set_bit(DRIVER_REQUIRE_COPY_IV, &rt2x00dev->flags);
 	}
-	__set_bit(DRIVER_SUPPORT_WATCHDOG, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_SW_SEQNO, &rt2x00dev->flags);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f1a9214..f7737ca 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -564,7 +564,6 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
-	__set_bit(DRIVER_SUPPORT_WATCHDOG, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_HT_TX_DESC, &rt2x00dev->flags);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index a3940d7..60b1cb0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -674,7 +674,6 @@ enum rt2x00_flags {
 	DRIVER_SUPPORT_CONTROL_FILTER_PSPOLL,
 	DRIVER_SUPPORT_PRE_TBTT_INTERRUPT,
 	DRIVER_SUPPORT_LINK_TUNING,
-	DRIVER_SUPPORT_WATCHDOG,
 
 	/*
 	 * Driver configuration
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index c975b0a..fc8cee9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -413,12 +413,11 @@ void rt2x00link_start_watchdog(struct rt2x00_dev *rt2x00dev)
 {
 	struct link *link = &rt2x00dev->link;
 
-	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
-	    !test_bit(DRIVER_SUPPORT_WATCHDOG, &rt2x00dev->flags))
-		return;
-
-	ieee80211_queue_delayed_work(rt2x00dev->hw,
-				     &link->watchdog_work, WATCHDOG_INTERVAL);
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
+	    rt2x00dev->ops->lib->watchdog)
+		ieee80211_queue_delayed_work(rt2x00dev->hw,
+					     &link->watchdog_work,
+					     WATCHDOG_INTERVAL);
 }
 
 void rt2x00link_stop_watchdog(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 02f1148..149e4f9 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2209,7 +2209,6 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
-	__set_bit(DRIVER_SUPPORT_WATCHDOG, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
-- 
1.7.2.3

