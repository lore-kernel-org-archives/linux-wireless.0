Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbXHSSbW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:31:22 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:31:21 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 19/30] rt2x00: Remove IEEE80211_HW_WEP_INCLUDE_IV flag
Date: Sun, 19 Aug 2007 20:28:14 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192028.15050.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From ca00a3af4a65db963b2ca268d4de11276208f8b1 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 13:10:26 +0200
Subject: [PATCH 19/30] rt2x00: Remove IEEE80211_HW_WEP_INCLUDE_IV flag

The IEEE80211_HW_WEP_INCLUDE_IV flag implies that the device
has done arc4 and has passed the rest on to mac80211.
Since rt2x00 doesn't perform hardware encryption this flag
should not be set.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |    1 -
 drivers/net/wireless/rt2500pci.c |    1 -
 drivers/net/wireless/rt2500usb.c |    1 -
 drivers/net/wireless/rt61pci.c   |    1 -
 drivers/net/wireless/rt73usb.c   |    1 -
 5 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index b673d61..1e935fd 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -1448,7 +1448,6 @@ static void rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_GEN_BEACON |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_WEP_INCLUDE_IV |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index bfd6426..28b2c73 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -1747,7 +1747,6 @@ static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_GEN_BEACON |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_WEP_INCLUDE_IV |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index f29dbe9..0c0076c 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -1469,7 +1469,6 @@ static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 	    IEEE80211_HW_RX_INCLUDES_FCS |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_WEP_INCLUDE_IV |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 47a915d..a6fcef7 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -2112,7 +2112,6 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_GEN_BEACON |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_WEP_INCLUDE_IV |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 7b1d8e1..98d3acc 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -1703,7 +1703,6 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_WEP_INCLUDE_IV |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
-- 
1.5.3.rc5

