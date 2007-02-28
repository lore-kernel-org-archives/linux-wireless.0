Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48611 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436AbXB1OHR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:17 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562551nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:16 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 20/28] rt2x00: Move channel time detection to rt2x00lib
Date: Wed, 28 Feb 2007 15:07:09 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.09281.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the rt2x00lib provided function for detecting channel time.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index f7347e3..fa1437c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -1184,46 +1184,6 @@ continue_csr_init:
 	return 0;
 }
 
-static int rt2400pci_init_channel_time(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned long jiffies_start;
-	unsigned long jiffies_end;
-
-	/*
-	 * Only initialize the channel_change_time
-	 * if it has not been set previously.
-	 */
-	if (rt2x00dev->hw->channel_change_time)
-		return 0;
-
-	/*
-	 * Invalidate the rx_status.channel value to make sure
-	 * the config channel will be correctly executed.
-	 */
-	rt2x00dev->rx_status.channel = 0;
-
-	/*
-	 * Determine channel_change_time
-	 * by measuring the time it takes
-	 * to switch the channel.
-	 */
-	jiffies_start = jiffies;
-	rt2400pci_config_channel(rt2x00dev,
-		rt2x00dev->hwmodes[0].channels[0].val,
-		rt2x00dev->hwmodes[0].channels[0].chan,
-		rt2x00dev->hwmodes[0].channels[0].freq,
-		0);
-	jiffies_end = jiffies;
-
-	rt2x00dev->hw->channel_change_time =
-		jiffies_to_usecs((long)jiffies_end - (long)jiffies_start);
-
-	NOTICE("Channel change time has been set to %d.\n",
-		rt2x00dev->hw->channel_change_time);
-
-	return 0;
-}
-
 /*
  * Device initialization functions.
  */
@@ -1333,7 +1293,7 @@ static int rt2400pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Determine channel change time.
 	 */
-	if (rt2400pci_init_channel_time(rt2x00dev))
+	if (rt2x00lib_detect_channel_time(rt2x00dev))
 		goto exit_fail;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 40c3fb2..8ad17ba 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -1307,46 +1307,6 @@ continue_csr_init:
 	return 0;
 }
 
-static int rt2500pci_init_channel_time(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned long jiffies_start;
-	unsigned long jiffies_end;
-
-	/*
-	 * Only initialize the channel_change_time
-	 * if it has not been set previously.
-	 */
-	if (rt2x00dev->hw->channel_change_time)
-		return 0;
-
-	/*
-	 * Invalidate the rx_status.channel value to make sure
-	 * the config channel will be correctly executed.
-	 */
-	rt2x00dev->rx_status.channel = 0;
-
-	/*
-	 * Determine channel_change_time
-	 * by measuring the time it takes
-	 * to switch the channel.
-	 */
-	jiffies_start = jiffies;
-	rt2500pci_config_channel(rt2x00dev,
-		rt2x00dev->hwmodes[0].channels[0].val,
-		rt2x00dev->hwmodes[0].channels[0].chan,
-		rt2x00dev->hwmodes[0].channels[0].freq,
-		rt2x00dev->hwmodes[0].channels[0].power_level);
-	jiffies_end = jiffies;
-
-	rt2x00dev->hw->channel_change_time =
-		jiffies_to_usecs((long)jiffies_end - (long)jiffies_start);
-
-	NOTICE("Channel change time has been set to %d.\n",
-		rt2x00dev->hw->channel_change_time);
-
-	return 0;
-}
-
 /*
  * Device initialization functions.
  */
@@ -1456,7 +1416,7 @@ static int rt2500pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Determine channel change time.
 	 */
-	if (rt2500pci_init_channel_time(rt2x00dev))
+	if (rt2x00lib_detect_channel_time(rt2x00dev))
 		goto exit_fail;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index d593d18..4244e9d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -1213,46 +1213,6 @@ continue_csr_init:
 	return 0;
 }
 
-static int rt2500usb_init_channel_time(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned long jiffies_start;
-	unsigned long jiffies_end;
-
-	/*
-	 * Only initialize the channel_change_time
-	 * if it has not been set previously.
-	 */
-	if (rt2x00dev->hw->channel_change_time)
-		return 0;
-
-	/*
-	 * Invalidate the rx_status.channel value to make sure
-	 * the config channel will be correctly executed.
-	 */
-	rt2x00dev->rx_status.channel = 0;
-
-	/*
-	 * Determine channel_change_time
-	 * by measuring the time it takes
-	 * to switch the channel.
-	 */
-	jiffies_start = jiffies;
-	rt2500usb_config_channel(rt2x00dev,
-		rt2x00dev->hwmodes[0].channels[0].val,
-		rt2x00dev->hwmodes[0].channels[0].chan,
-		rt2x00dev->hwmodes[0].channels[0].freq,
-		rt2x00dev->hwmodes[0].channels[0].power_level);
-	jiffies_end = jiffies;
-
-	rt2x00dev->hw->channel_change_time =
-		jiffies_to_usecs((long)jiffies_end - (long)jiffies_start);
-
-	NOTICE("Channel change time has been set to %d.\n",
-		rt2x00dev->hw->channel_change_time);
-
-	return 0;
-}
-
 /*
  * Device initialization functions.
  */
@@ -1354,7 +1314,7 @@ static int rt2500usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Determine channel change time.
 	 */
-	if (rt2500usb_init_channel_time(rt2x00dev))
+	if (rt2x00lib_detect_channel_time(rt2x00dev))
 		goto exit_fail;
 
 	SET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 1cd68d0..53dedcb 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -1589,46 +1589,6 @@ continue_csr_init:
 	return 0;
 }
 
-static int rt61pci_init_channel_time(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned long jiffies_start;
-	unsigned long jiffies_end;
-
-	/*
-	 * Only initialize the channel_change_time
-	 * if it has not been set previously.
-	 */
-	if (rt2x00dev->hw->channel_change_time)
-		return 0;
-
-	/*
-	 * Invalidate the rx_status.channel value to make sure
-	 * the config channel will be correctly executed.
-	 */
-	rt2x00dev->rx_status.channel = 0;
-
-	/*
-	 * Determine channel_change_time
-	 * by measuring the time it takes
-	 * to switch the channel.
-	 */
-	jiffies_start = jiffies;
-	rt61pci_config_channel(rt2x00dev,
-		rt2x00dev->hwmodes[0].channels[0].val,
-		rt2x00dev->hwmodes[0].channels[0].chan,
-		rt2x00dev->hwmodes[0].channels[0].freq,
-		rt2x00dev->hwmodes[0].channels[0].power_level);
-	jiffies_end = jiffies;
-
-	rt2x00dev->hw->channel_change_time =
-		jiffies_to_usecs((long)jiffies_end - (long)jiffies_start);
-
-	NOTICE("Channel change time has been set to %d.\n",
-		rt2x00dev->hw->channel_change_time);
-
-	return 0;
-}
-
 /*
  * Device initialization functions.
  */
@@ -1745,7 +1705,7 @@ static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Determine channel change time.
 	 */
-	if (rt61pci_init_channel_time(rt2x00dev))
+	if (rt2x00lib_detect_channel_time(rt2x00dev))
 		goto exit_fail;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 2418466..e628d43 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1370,46 +1370,6 @@ continue_csr_init:
 	return 0;
 }
 
-static int rt73usb_init_channel_time(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned long jiffies_start;
-	unsigned long jiffies_end;
-
-	/*
-	 * Only initialize the channel_change_time
-	 * if it has not been set previously.
-	 */
-	if (rt2x00dev->hw->channel_change_time)
-		return 0;
-
-	/*
-	 * Invalidate the rx_status.channel value to make sure
-	 * the config channel will be correctly executed.
-	 */
-	rt2x00dev->rx_status.channel = 0;
-
-	/*
-	 * Determine channel_change_time
-	 * by measuring the time it takes
-	 * to switch the channel.
-	 */
-	jiffies_start = jiffies;
-	rt73usb_config_channel(rt2x00dev,
-		rt2x00dev->hwmodes[0].channels[0].val,
-		rt2x00dev->hwmodes[0].channels[0].chan,
-		rt2x00dev->hwmodes[0].channels[0].freq,
-		rt2x00dev->hwmodes[0].channels[0].power_level);
-	jiffies_end = jiffies;
-
-	rt2x00dev->hw->channel_change_time =
-		jiffies_to_usecs((long)jiffies_end - (long)jiffies_start);
-
-	NOTICE("Channel change time has been set to %d.\n",
-		rt2x00dev->hw->channel_change_time);
-
-	return 0;
-}
-
 /*
  * Device initialization functions.
  */
@@ -1518,7 +1478,7 @@ static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Determine channel change time.
 	 */
-	if (rt73usb_init_channel_time(rt2x00dev))
+	if (rt2x00lib_detect_channel_time(rt2x00dev))
 		goto exit_fail;
 
 	SET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
