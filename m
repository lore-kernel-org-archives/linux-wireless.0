Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:39608 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbZBUHdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 02:33:38 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: SIOCGIWSCAN-race
Date: Sat, 21 Feb 2009 08:33:06 +0100
Message-ID: <B944EEED4BC94818AF57142C1687A0A0@gotws1589> (sfid-20090221_083344_959030_C38ED4E3)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0311_01C993FF.05498E60"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0311_01C993FF.05498E60
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Johannes,

I have discovered and patched a race in the scanning function since a couple
of releases.
To day I checked the current Linux git and the problem is still there.

The problem is the sequence of events when the scan result is reported back.
The wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL); 
is called before ieee80211_hw_config(local);

ieee80211_hw_config(local) will trig the wpa_supplicant to select an AP. 
That may happen before the ieee80211_hw_config() is executed since the
wpa_supplicant
generated actions is executed by an other thread (wpa_supplicant).

The result is that:
- wpa_supplicant setup for an association to an ap using correct channel.
- ieee80211_hw_config() reset the channel to the value before the SCAN
started.
- the association request will be sent out using the wrong channel.


Attached you will find the patch for 2.6.27. 
It is not a perfect patch since the code is duplicated but it works :)


Regards
Lars

------=_NextPart_000_0311_01C993FF.05498E60
Content-Type: application/octet-stream;
	name="lae-mac80211-mlme-SIOCGIWSCAN-race.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="lae-mac80211-mlme-SIOCGIWSCAN-race.patch"

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c=0A=
old mode 100644=0A=
new mode 100755=0A=
index b404537..fd9e726=0A=
--- a/net/mac80211/mlme.c=0A=
+++ b/net/mac80211/mlme.c=0A=
@@ -3788,10 +3788,6 @@ void ieee80211_scan_completed(struct ieee80211_hw =
*hw)=0A=
 	struct ieee80211_sub_if_data *sdata;=0A=
 	union iwreq_data wrqu;=0A=
 =0A=
-	local->last_scan_completed =3D jiffies;=0A=
-	memset(&wrqu, 0, sizeof(wrqu));=0A=
-	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);=0A=
-=0A=
 	if (local->sta_hw_scanning) {=0A=
 		local->sta_hw_scanning =3D 0;=0A=
 		if (ieee80211_hw_config(local))=0A=
@@ -3803,6 +3799,10 @@ void ieee80211_scan_completed(struct ieee80211_hw =
*hw)=0A=
 			ieee80211_restart_sta_timer(sdata);=0A=
 		rcu_read_unlock();=0A=
 =0A=
+		local->last_scan_completed =3D jiffies;=0A=
+		memset(&wrqu, 0, sizeof(wrqu));=0A=
+		wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);=0A=
+=0A=
 		goto done;=0A=
 	}=0A=
 =0A=
@@ -3811,6 +3811,9 @@ void ieee80211_scan_completed(struct ieee80211_hw =
*hw)=0A=
 		printk(KERN_DEBUG "%s: failed to restore operational "=0A=
 		       "channel after scan\n", dev->name);=0A=
 =0A=
+	local->last_scan_completed =3D jiffies;=0A=
+	memset(&wrqu, 0, sizeof(wrqu));=0A=
+	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);=0A=
 =0A=
 	netif_tx_lock_bh(local->mdev);=0A=
 	local->filter_flags &=3D ~FIF_BCN_PRBRESP_PROMISC;=0A=

------=_NextPart_000_0311_01C993FF.05498E60--

