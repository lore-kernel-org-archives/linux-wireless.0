Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:53678 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933748AbXGMSwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 14:52:17 -0400
Message-ID: <4697C9DF.2030200@lwfinger.net>
Date: Fri, 13 Jul 2007 13:52:15 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
CC: Jiri Benc <jbenc@suse.cz>, benmcahill@gmail.com,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
Subject: [RFC/T] mac80211: Remove overly "sticky" averaging filters for rssi,  signal, noise.
References: <4220499A1B034C4FA93B547BA01E1FF0017461F8@orsmsx413.amr.corp.intel.com>
In-Reply-To: <4220499A1B034C4FA93B547BA01E1FF0017461F8@orsmsx413.amr.corp.intel.com>
Content-Type: multipart/mixed;
 boundary="------------060700060308090802020402"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060700060308090802020402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

As has been discussed on the wireless list, the averaging in the current version
of mac80211 has a bug. This trial patch is to see if removing averaging leads to
wireless statistics that are too jittery to be useful.

If you are using a mac80211-based driver, please test and report your findings.

Thanks,

Larry
------ patch follows ------

The current version of wireless statistics contains a bug in the averaging
that makes the numbers be too sticky and not react to small changes. This
test patch removes all averaging for testing if averaging is needed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/net/mac80211/ieee80211.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211.c
+++ wireless-dev/net/mac80211/ieee80211.c
@@ -3615,12 +3615,9 @@ ieee80211_rx_h_sta_process(struct ieee80

  	sta->rx_fragments++;
  	sta->rx_bytes += rx->skb->len;
-	sta->last_rssi = (sta->last_rssi * 15 +
-			  rx->u.rx.status->ssi) / 16;
-	sta->last_signal = (sta->last_signal * 15 +
-			    rx->u.rx.status->signal) / 16;
-	sta->last_noise = (sta->last_noise * 15 +
-			   rx->u.rx.status->noise) / 16;
+	sta->last_rssi = rx->u.rx.status->ssi;
+	sta->last_signal = rx->u.rx.status->signal;
+	sta->last_noise = rx->u.rx.status->noise;

  	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
  		/* Change STA power saving mode only in the end of a frame



---

--------------060700060308090802020402
Content-Type: text/plain;
 name="mac80211_no_average"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mac80211_no_average"

The current version of wireless statistics contains a bug in the averaging
that makes the numbers be too sticky and not react to small changes. This
test patch removes all averaging for testing if averaging is needed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/net/mac80211/ieee80211.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211.c
+++ wireless-dev/net/mac80211/ieee80211.c
@@ -3615,12 +3615,9 @@ ieee80211_rx_h_sta_process(struct ieee80
 
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
-	sta->last_rssi = (sta->last_rssi * 15 +
-			  rx->u.rx.status->ssi) / 16;
-	sta->last_signal = (sta->last_signal * 15 +
-			    rx->u.rx.status->signal) / 16;
-	sta->last_noise = (sta->last_noise * 15 +
-			   rx->u.rx.status->noise) / 16;
+	sta->last_rssi = rx->u.rx.status->ssi;
+	sta->last_signal = rx->u.rx.status->signal;
+	sta->last_noise = rx->u.rx.status->noise;
 
 	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
 		/* Change STA power saving mode only in the end of a frame


--------------060700060308090802020402--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
