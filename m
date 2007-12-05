Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbXLEV0X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 16:26:23 -0500
Subject: [RFC] fixing the ap_scan and hidden SSID mess
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: drago01 <drago01@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 16:20:57 -0500
Message-Id: <1196889657.6677.22.camel@localhost.localdomain> (sfid-20071205_212627_390359_6AD6651B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hidden SSID is a mess right now.  Here's why, and here's a proposal for
fixing it.


Background:
-----------

There are two settings for ap_scan with wpa_supplicant.  ap_scan=1 along
with scan_ssid=1 in a network block lets wpa_supplicant tell the driver
to probe for the SSID it wants to connect to, exposing hidden SSIDs to
the supplicant and allowing it to successfully connect.

ap_scan=2 just blows the settings to the driver via WEXT, and hopes the
driver can do the right thing.  That's problematic for a few reasons;
namely that WEXT doesn't have the concept of "packets" of association
settings (so drivers have to guess which settings to apply together and
which not to based on timeouts, or else just fail here entirely), and
that ordering relationships between WEXT commands are ambiguous.  This
leads to failure.

ap_scan=2 _should_ be supported by all drivers, because it is the
brute-force fallback.  Unfortunately, iwlwifi drivers are currently
broken with hidden SSIDs and ap_scan=2, and maybe all mac80211 drivers
too.  Regardless of whether ap_scan=2 should work or not, drivers that
support specific SSID scans can do better.  But keep in mind that
ap_scan=2 is ALWAYS the fallback and should ALWAYS work with any driver.
Drivers that can't do specific SSID scans mostly don't work with
ap_scan=1 because they usually don't do probe requests on command.

Some drivers (most fullmac ones) require ap_scan=2 for hidden SSID
support.  Those would include orinoco, airo, atmel, and ipw2100.

Other drivers (mostly softmac ones) work well with ap_scan=1 because
they support scanning for specific SSIDs.

However, userspace is f*cked because it can't figure out which one to
use, and trying both is not an option because you get unacceptable
latency for the user when trying to associate.  And special-casing based
on the driver name is NOT an option.  Ever. At all.

Solution
--------

Drivers should advertise the ability to do specific SSID scans (which
allows them to find hidden SSIDs).  As a requirement for supporting this
capability, the driver _MUST_ implement the required bits in its
SIOCSIWSCAN handler to scan for the requested SSID, or else the driver
is in error.

Userspace apps can then intelligently determine whether to use ap_scan=1
or ap_scan=2 with wpa_supplicant.  If the driver is not fixed to
advertise this capability, userspace can fall back to ap_scan=2 and the
driver is clearly the problem in this case, and the responsible piece of
code can be blamed and fixed.

The problem is that there isn't a nice, generic capabilities field in
WEXT.  So we have to abuse an existing one, and I picked enc_capa.


Notes
-----

I know that the ap_scan=1 or 2 is really supposed to be for selecting
roaming behavior.  However, it's also overloaded in wpa_supplicant to
control hidden SSID handling as a workaround for drivers not supporting
specific SSID scans.  Other utilities have to be able to figure out
which one to use for hidden SSIDs.

Obviously cfg80211/net80211 would be able to export this capability
directly in the capability bits for each driver.  This issue is only a
problem with WEXT (unless cfg80211 doesn't have this capability yet).

The patch below is just to show how this might be accomplished.
Obviously mac80211 drivers have this capability.  So does ipw2200.
ipw2100 does not have this capability, and therefore does not set the
bit in enc_capa.

Thoughts?  It's at the point where something just needs to be done to
fix the situation.

Dan


diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 54f44e5..726e30e 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -8901,6 +8901,8 @@ static int ipw_wx_get_range(struct net_device *dev,
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 		IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
+	range->enc_capa |= IW_ENC_CAPA_SPECIFIC_SSID_SCAN;
+
 	IPW_DEBUG_WX("GET Range\n");
 	return 0;
 }
diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 0987aa7..e2a8fd8 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -625,6 +625,10 @@
 #define IW_ENC_CAPA_CIPHER_TKIP	0x00000004
 #define IW_ENC_CAPA_CIPHER_CCMP	0x00000008
 
+/* Abuse enc_capa because there is no generic capabilties
+ * field in the range struct. */
+#define IW_ENC_CAPA_SPECIFIC_SSID_SCAN	0x00000010
+
 /* Event capability macros - in (struct iw_range *)->event_capa
  * Because we have more than 32 possible events, we use an array of
  * 32 bit bitmasks. Note : 32 bits = 0x20 = 2^5. */
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 646e2f2..fd842c4 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -190,6 +190,9 @@ static int ieee80211_ioctl_giwrange(struct net_device *dev,
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
+	/* All mac80211 drivers support this capability */
+	range->enc_capa |= IW_ENC_CAPA_SPECIFIC_SSID_SCAN;
+
 	list_for_each_entry(mode, &local->modes_list, list) {
 		int i = 0;
 

