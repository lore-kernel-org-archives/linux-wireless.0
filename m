Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:42610 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756861AbXJLKqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 06:46:33 -0400
Received: from vs30d.wh2.ocn.ne.jp (222.146.55.198)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-019535990
	for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2007 19:46:31 +0900 (JST)
From: bruno randolf <bruno@thinktube.com>
To: linux-wireless@vger.kernel.org
Subject: atheros hardware needs padding for QoS data
Date: Fri, 12 Oct 2007 19:46:29 +0900
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710121946.30024.bruno@thinktube.com> (sfid-20071012_114641_137646_A74F979B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello!

it seems the atheros hardware needs a padding to 4 byte boundaries after the 
801.11 header when it sends QoS frames and it will add such a padding 
automatically when it receives QoS data frames. 

in my case this made the ath5k driver associate with an QoS enabled AP (same 
type of card with the madwifi driver in default config) fine, but i could not 
get any ARP requests thru - since the padding was missing there were 2 bytes 
lost in the packet received on the AP side, so no further communication...

this need for padding is also reflected in the madwifi code and this comment:
	/*
	 * Indicate we need the 802.11 header padded to a
	 * 32-bit boundary for 4-address and QoS frames.
	 */

i created the following simple hack, to see if the problem really is the 
missing padding. it just adds the padding all the time, so it will only work 
with QoS enabled APs, but it makes me able to communicate with my QoS AP.

i didn't see how mac80211 would allow to solve this elegantly at this time. 
are there any other drivers with a similar kind of padding requirement? how 
could that be implemented cleanly?

luis, does this hack fix your problem with DHCP too?

bruno


diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 064924c..bb11e63 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1019,6 +1019,8 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
                return TXRX_DROP;

        hdrlen = ieee80211_get_hdrlen(fc);
+       if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)
+               hdrlen = hdrlen + 2;

        /* convert IEEE 802.11 header + possible LLC headers into Ethernet
         * header
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 957ec3c..6be9b95 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1405,7 +1405,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
        if (sta) {
                if (sta->flags & WLAN_STA_WME) {
                        fc |= IEEE80211_STYPE_QOS_DATA;
-                       hdrlen += 2;
+                       hdrlen += 4; //2;
                }
                sta_info_put(sta);
        }
