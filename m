Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:32924 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754919AbZGMUYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 16:24:53 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Ivo van Doorn'" <ivdoorn@gmail.com>
Cc: <linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>
Subject: RT61 antenna diversity in 2.6.30
Date: Mon, 13 Jul 2009 22:24:50 +0200
Message-ID: <0DC66442F4FF4076964868A5ECAB9790@gotws1589>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo,

I recently moved from 2.6.26 to 2.6.30 with a HW that do 
SW antenna diversity with .26 but not with .30

I have found two problems:
1) The rt2x00mac_config() calls rt2x00lib_config_antenna() and reset the
rt2x00dev->default_ant.
2) The rt2x00lib_antenna_diversity_sample() does not update the sampled
antenna rssi.

I have applied the following patches to correct the problems:

1)
--- a/drivers/net/wireless/rt2x00/rt2x00link.c	2009-07-13
21:48:45.000000000 +0200
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c	2009-07-13
21:52:42.000000000 +0200
@@ -146,8 +151,13 @@ static void rt2x00lib_antenna_diversity_
 {
 	struct link_ant *ant = &rt2x00dev->link.ant;
 	struct antenna_setup new_ant;
-	int sample_a = rt2x00link_antenna_get_rssi_history(rt2x00dev,
ANTENNA_A);
-	int sample_b = rt2x00link_antenna_get_rssi_history(rt2x00dev,
ANTENNA_B);
+	int rssi_curr, sample_a, sample_b;
+			
+	rssi_curr = rt2x00link_antenna_get_link_rssi(rt2x00dev);
+	rt2x00link_antenna_update_rssi_rx_history(rt2x00dev, rssi_curr);
+	
+	sample_a = rt2x00link_antenna_get_rssi_history(rt2x00dev,
ANTENNA_A);
+	sample_b = rt2x00link_antenna_get_rssi_history(rt2x00dev,
ANTENNA_B);
 
 	memcpy(&new_ant, &ant->active, sizeof(new_ant));
---

2)
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c	2009-07-13
21:51:26.000000000 +0200
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c	2009-07-13
21:54:28.000000000 +0200
@@ -375,10 +375,12 @@ int rt2x00mac_config(struct ieee80211_hw
 		 * diversity. But for non-diversity configurations, we need
 		 * to have configured the correct state now.
 		 */
-		if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED)
+		if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED) {
+			rt2x00dev->link.ant.active = rt2x00dev->default_ant;
 			rt2x00lib_config_antenna(rt2x00dev,
-						 &rt2x00dev->default_ant);
-
+
&rt2x00dev->link.ant.active);
+		}
+		
 		/* Turn RX back on */
 		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
 	} else {


Regards
Lars

