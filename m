Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbXLFLiJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 06:38:09 -0500
Subject: [RFC PATCH] introduce WEXT scan capabilities
From: Dan Williams <dcbw@redhat.com>
To: Jean Tourrilhes <jt@hpl.hp.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 06:28:39 -0500
Message-Id: <1196940519.3980.51.camel@localhost.localdomain> (sfid-20071206_113813_153868_BF0D373C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

See the previous thread about fixing the ap_scan mess.  I think Jean's
correct in asserting that we need more bits for scan capability.

This patch introduces scan capability bits for WEXT; hopefully cfg80211
can also pick up equivalent functionality.  Capability bits are provided
for all the current options that may be passed to drivers in the
iw_scan_req structure.  It can be assumed that if the driver reports the
scan capability, that the driver respects the options specified in the
iw_scan_req structure when performing the scan.

Clients can use logic like (cribbed from wpa_supplicant's driver_wext.c)
this to figure out whether or not the capability bits are supported:

struct iwreq iwr;
struct iw_range *range;

<set up iwr/range for request>

if (ioctl(drv->ioctl_sock, SIOCGIWRANGE, &iwr) == 0) {
	u8 minlen = ((char *) &range->scan_capa) - (char *) range + sizeof(range->scan_capa);

	if (iwr.u.data.length >= minlen) {
		/* SCAN_CAPA is supported */
	}
}

Jean; what do you think?

Signed-off-by: Dan Williams <dcbw@redhat.com>


diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 54f44e5..e30ad24 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -8901,6 +8901,8 @@ static int ipw_wx_get_range(struct net_device *dev,
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 		IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
+	range->scan_capa = IW_SCAN_CAPA_ESSID | IW_SCAN_CAPA_TYPE;
+
 	IPW_DEBUG_WX("GET Range\n");
 	return 0;
 }
diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 0987aa7..9342801 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -541,6 +541,15 @@
 /* Maximum size of returned data */
 #define IW_SCAN_MAX_DATA	4096	/* In bytes */
 
+/* Scan capabilitiy macros - in (struct iw_range *)->scan_capa */
+#define IW_SCAN_CAPA_ESSID		0x00000001
+#define IW_SCAN_CAPA_BSSID		0x00000002
+#define IW_SCAN_CAPA_CHANNEL	0x00000004
+#define IW_SCAN_CAPA_MODE		0x00000008
+#define IW_SCAN_CAPA_RATE		0x00000010
+#define IW_SCAN_CAPA_TYPE		0x00000020
+#define IW_SCAN_CAPA_TIME		0x00000040
+
 /* Max number of char in custom event - use multiple of them if needed */
 #define IW_CUSTOM_MAX		256	/* In bytes */
 
@@ -1040,6 +1049,8 @@ struct	iw_range
 	 * because each entry contain its channel index */
 
 	__u32		enc_capa;	/* IW_ENC_CAPA_* bit field */
+
+	__u32		scan_capa;	/* IW_SCAN_CAPA_* bit field */
 };
 
 /*
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 646e2f2..0c52ed8 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -218,6 +218,8 @@ static int ieee80211_ioctl_giwrange(struct net_device *dev,
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWSCAN);
 
+	range->scan_capa |= IW_SCAN_CAPA_ESSID;
+
 	return 0;
 }
 

