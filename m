Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:18176 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750AbXJFMEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:04:06 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605539ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:04:06 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/16] rt2x00: get_duration expects values in 100kbs
Date: Sat, 6 Oct 2007 14:14:58 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061414.59128.IvDoorn@gmail.com> (sfid-20071006_130411_783853_415F1597)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_duration expects all speeds to be passed in 100kbs,
this means that passing 2 is incorrect and should be raised to 20

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 5f8df7a..edb5bd1 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -277,7 +277,7 @@ static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 	 */
 	rt2x00pci_register_read(rt2x00dev, BCNCSR1, &reg);
 	rt2x00_set_field32(&reg, BCNCSR1_PRELOAD,
-			   PREAMBLE + get_duration(IEEE80211_HEADER, 2));
+			   PREAMBLE + get_duration(IEEE80211_HEADER, 20));
 	rt2x00pci_register_write(rt2x00dev, BCNCSR1, reg);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index cac9430..68baccc 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -277,7 +277,7 @@ static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 	 */
 	rt2x00pci_register_read(rt2x00dev, BCNCSR1, &reg);
 	rt2x00_set_field32(&reg, BCNCSR1_PRELOAD,
-			   PREAMBLE + get_duration(IEEE80211_HEADER, 2));
+			   PREAMBLE + get_duration(IEEE80211_HEADER, 20));
 	rt2x00_set_field32(&reg, BCNCSR1_BEACON_CWMIN,
 			   rt2x00lib_get_ring(rt2x00dev,
 					      IEEE80211_TX_QUEUE_BEACON)
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 234b34e..c1f217b 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -280,7 +280,7 @@ static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 	 */
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR20, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR20_OFFSET,
-			   (PREAMBLE + get_duration(IEEE80211_HEADER, 2)) >> 6);
+			   (PREAMBLE + get_duration(IEEE80211_HEADER, 20)) >> 6);
 	if (type == IEEE80211_IF_TYPE_STA)
 		rt2x00_set_field16(&reg, TXRX_CSR20_BCN_EXPECT_WINDOW, 0);
 	else
-- 
1.5.3.4

