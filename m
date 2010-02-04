Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:4564 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0BDNqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 08:46:18 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] libertas+cfg80211: better disconnect support
Date: Thu, 4 Feb 2010 14:44:36 +0100
Cc: Samuel Ortiz <sameo@linux.intel.com>,
	Dan Williams <dcbw@redhat.com>
References: <20100202000934.GA19847@sortiz.org>
In-Reply-To: <20100202000934.GA19847@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002041444.36131.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel !

This patch was necessary for me to make

   while true; iw wlan0 link; sleep 0.1; done

not hang in "iw" when moving out-of-reach of an AP.


--------------------------

An issue with "iw wlan0 link" hanging when moving out-of-reach of
an AP was observed. The reason was that lbs_get_signal()
returned "1" in case of an error from the firmware and that this
value was given back to cfg80211.

However a cfg80211-operation method should return standard -Exxx
error codes, not posive values. The positive value ended up in
iw, where a line like "while (ret > 0) ..." was looping endless.


For error recovery, it also helped to report link loss much
earlier to user-space. I actually have Cisco APs lying around, so
I know that the one-second delay doesn't upset neither an Cisco
1231/1241 nor wpa_supplicant 0.7.1 (at least not in -Dnl80211
mode). This made wpa_supplicant scan one second earlier and
re-connect therefore faster to another suitable AP.

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

---
 drivers/net/wireless/libertas/cfg.c     |   10 ++++++++--
 drivers/net/wireless/libertas/cmdresp.c |    5 -----
 2 files changed, 8 insertions(+), 7 deletions(-)

--- linux-wl.orig/drivers/net/wireless/libertas/cfg.c
+++ linux-wl/drivers/net/wireless/libertas/cfg.c
@@ -1478,6 +1478,7 @@ struct cmd_rssi {
 	__le16 avg_nf;
 } __attribute__ ((packed));
 
+
 static int lbs_get_signal(struct lbs_private *priv, s8 *signal, 
s8 *noise)
 {
 	struct cmd_rssi cmd;
@@ -1492,6 +1493,7 @@ static int lbs_get_signal(struct lbs_pri
 				le16_to_cpu(cmd.nf));
 		*noise  = CAL_NF(le16_to_cpu(cmd.nf));
 	}
+
 	return ret;
 }
 
@@ -1516,7 +1518,9 @@ static int lbs_cfg_get_station(struct wi
 
 	/* Get current RSSI */
 	ret = lbs_get_signal(priv, &signal, &noise);
-	if (ret == 0) {
+	if (ret)
+		ret = -EBUSY;
+	else {
 		sinfo->signal = signal;
 		sinfo->filled |= STATION_INFO_SIGNAL;
 	}
@@ -1564,7 +1568,9 @@ static int lbs_get_survey(struct wiphy *
 		ieee80211_channel_to_frequency(priv->channel));
 
 	ret = lbs_get_signal(priv, &signal, &noise);
-	if (ret == 0) {
+	if (ret)
+		ret = -EBUSY;
+	else {
 		survey->filled = SURVEY_INFO_NOISE_DBM;
 		survey->noise = noise;
 	}
--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -25,11 +25,6 @@ void lbs_mac_event_disconnected(struct l
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	/*
-	 * Cisco AP sends EAP failure and de-auth in less than 0.5 ms.
-	 * It causes problem in the Supplicant
-	 */
-	msleep_interruptible(1000);
 	lbs_send_disconnect_notification(priv);
 
 	/* report disconnect to upper layer */


-- 
http://www.holgerschurig.de
