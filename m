Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbXLHAdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 19:33:23 -0500
Subject: [PATCH] introduce WEXT scan capabilities
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jean Tourrilhes <jt@hpl.hp.com>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 19:22:46 -0500
Message-Id: <1197073366.4563.15.camel@localhost.localdomain> (sfid-20071208_003335_134955_04BFA298)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce scan capabilities to WEXT so that userspace can do intelligent
things with scan behavior, partly in an attempt to handle hidden SSIDs
more gracefully.  If the driver reports a specific scan capability, the
driver must respect the options specified in the iw_scan_req structure
when handling the SIOCSIWSCAN call, unless it's mode or state does not
allow it to do so, in which case it must return an error.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index d8f5efc..3a57d48 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -1089,6 +1089,9 @@ static int prism2_ioctl_giwrange(struct net_device *dev,
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 		IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
+	if (local->sta_fw_ver >= PRISM2_FW_VER(1,3,1))
+		range->scan_capa = IW_SCAN_CAPA_ESSID;
+
 	return 0;
 }
 
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
index 0987aa7..07e3d01 100644
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
+#define IW_SCAN_CAPA_DWELL_TIME	0x00000040
+
 /* Max number of char in custom event - use multiple of them if needed */
 #define IW_CUSTOM_MAX		256	/* In bytes */
 
@@ -1040,6 +1049,16 @@ struct	iw_range
 	 * because each entry contain its channel index */
 
 	__u32		enc_capa;	/* IW_ENC_CAPA_* bit field */
+
+	/* Do *NOT* use those fields, they are just used as padding to get
+	 * proper alignement with user space */
+	__s32		reserved1;
+	__s32		reserved2;
+	__u16		reserved3;
+	__s32		reserved4;
+	__u32		reserved5;
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
 
+	range->scan_capa = IW_SCAN_CAPA_ESSID;
+
 	return 0;
 }
 

