Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:43931 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbYJWVtd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 17:49:33 -0400
Received: by yw-out-2324.google.com with SMTP id 9so195270ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 14:49:32 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: ivdoorn@gmail.com
From: Andrey Yurovsky <andrey@cozybit.com>
Subject: [RFC] mac80211 rx filter in mesh mode, rt2x00 mesh point operation
Date: Thu, 23 Oct 2008 14:49:31 -0700 (PDT)
Message-ID: <4900f16b.0b0c360a.2bc3.ffffa11a@mx.google.com> (sfid-20081023_234939_327415_9F99109E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've come across a problem with the RX filter setting while testing mesh point
operation in the rt2x00 driver (my hardware is rt73usb).  We transmit and 
receive mesh beacons but mesh peer link action frames are dropped.  A patch
for enabling mesh point mode is included here, this works except that:

The RX filter, as set by mac80211 in mesh mode is 0x02, that is FIF_ALLMULTI is
set.  This is sufficient for other drivers but not for rt2x00.  I noticed that
running tcpdump on the MP interface sets the filter to 0x43, this adds
FIF_OTHER_BSS and FIF_PROMISC_IN_BSS, and rt2x00 is then able to make peer
links and mesh point mode works correctly.

Actually for rt2x00, setting either FIF_OTHER_BSS or FIF_PROMISC_IN_BSS is the 
key here because they are both treated as FIF_PROMISC_IN_BSS, which causes the 
driver to enable TXRX_CSR0_DROP_TO_DS.

To solve this problem, it seems that we can either:
1. change the RX filter specified in mesh point mode.  I am concerned that this
   would pass up unnecessary frames to the other drivers which otherwise work
   fine with just FIF_ALLMULTI set.  Are there any opinions on this?
2. modify the rt2x00 rx filter setting implementation to set additional flags,
   possibly with knowledge that the interface is in mesh point mode.  This 
   seems hacky as the filter setting is supposed to be fairly generic.
3. revisit the setting of TXRX_CSR0_DROP_TO_DS and possibly other bits in the
   HW rx filter, CCing Ivo regarding this.

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 7910147..3021c2a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -42,6 +42,7 @@ void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 	switch (type) {
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
 		conf.sync = TSF_SYNC_BEACON;
 		break;
 	case NL80211_IFTYPE_STATION:
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 697806c..2b9d0a0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -466,7 +466,8 @@ static void rt2x00lib_beacondone_iter(void *data, u8 *mac,
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 
 	if (vif->type != NL80211_IFTYPE_AP &&
-	    vif->type != NL80211_IFTYPE_ADHOC)
+	    vif->type != NL80211_IFTYPE_ADHOC &&
+	    vif->type != NL80211_IFTYPE_MESH_POINT)
 		return;
 
 	/*
@@ -1053,7 +1054,8 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->wiphy->interface_modes =
 	    BIT(NL80211_IFTYPE_AP) |
 	    BIT(NL80211_IFTYPE_STATION) |
-	    BIT(NL80211_IFTYPE_ADHOC);
+	    BIT(NL80211_IFTYPE_ADHOC) |
+	    BIT(NL80211_IFTYPE_MESH_POINT);
 
 	/*
 	 * Let the driver probe the device to detect the capabilities.
@@ -1208,10 +1210,11 @@ static void rt2x00lib_resume_intf(void *data, u8 *mac,
 
 
 	/*
-	 * Master or Ad-hoc mode require a new beacon update.
+	 * Master, Ad-hoc, or Mesh Point mode require a new beacon update.
 	 */
 	if (vif->type == NL80211_IFTYPE_AP ||
-	    vif->type == NL80211_IFTYPE_ADHOC)
+	    vif->type == NL80211_IFTYPE_ADHOC ||
+	    vif->type == NL80211_IFTYPE_MESH_POINT)
 		intf->delayed_flags |= DELAYED_UPDATE_BEACON;
 
 	spin_unlock(&intf->lock);
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index da7b49a..d4bd072 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -229,6 +229,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 		/*
 		 * We don't support mixed combinations of
 		 * sta and ap interfaces.


