Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58510 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab1ASNnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 08:43:09 -0500
Received: by bwz15 with SMTP id 15so798493bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 05:43:07 -0800 (PST)
From: Alexander Simon <alexander.simon@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: ieee80211_ibss_add_sta called uneccessarily
Date: Wed, 19 Jan 2011 14:43:04 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_opuNNf2fqWePcZ0"
Message-Id: <201101191443.04743.alexander.simon@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_opuNNf2fqWePcZ0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

while creating a patch for IEEE802.11n with IBSS, i found that 
ieee80211_ibss_add_sta is called way to often by prepare_for_handlers in 
net/mac80211/rx.c.

In net/mac80211/rx.c we check if the IBSSs match with ieee80211_bssid_match(). 
If they dont and we are not scanning, we are leaving.
But ieee80211_bssid_match() will also return true if our BSSID is set to 
broadcast. And the interface is set to broadcast if we are scanning witch 
happens if we created an IBSS and are still "alone". So we will never return.

So i would change !ieee80211_bssid_match just into compare_ether_addr.

Well, this only affects CPU (and my printk output) as ieee80211_ibss_add_sta 
checks the BSSIDs on its own again, but we safe some needless function calls.

Hope i could give a understandable explanation of my patch

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>

--Boundary-00=_opuNNf2fqWePcZ0
Content-Type: text/x-patch;
  charset="utf-8";
  name="fix_ieee80211_ibss_add_sta_call.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix_ieee80211_ibss_add_sta_call.patch"

diff -Nrup compat-wireless-2011-01-17.orig/net/mac80211/rx.c compat-wireless-2011-01-17/net/mac80211/rx.c
--- compat-wireless-2011-01-17.orig/net/mac80211/rx.c	2011-01-17 21:03:26.000000000 +0100
+++ compat-wireless-2011-01-17/net/mac80211/rx.c	2011-01-18 15:42:46.000000000 +0100
@@ -2601,7 +2601,7 @@ static int prepare_for_handlers(struct i
 		if (ieee80211_is_beacon(hdr->frame_control)) {
 			return 1;
 		}
-		else if (!ieee80211_bssid_match(bssid, sdata->u.ibss.bssid)) {
+		else if (compare_ether_addr(bssid, sdata->u.ibss.bssid)) {
 			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN))
 				return 0;
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;

--Boundary-00=_opuNNf2fqWePcZ0--
