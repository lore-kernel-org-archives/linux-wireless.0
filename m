Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56425 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab0JHQnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 12:43:35 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath5k:  Print out opmode in debugfs.
Date: Fri,  8 Oct 2010 09:43:29 -0700
Message-Id: <1286556210-29643-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Helps debug multi-VIF scenarios.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 c2d549f... a342a9d... M	drivers/net/wireless/ath/ath5k/debug.c
:100644 100644 53e77bd... a9eb787... M	drivers/net/wireless/ath/debug.c
:100644 100644 fd3a020... a3a5a62... M	drivers/net/wireless/ath/debug.h
 drivers/net/wireless/ath/ath5k/debug.c |   10 ++++++++++
 drivers/net/wireless/ath/debug.c       |   29 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/debug.h       |    3 +++
 3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index c2d549f..a342a9d 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -60,6 +60,7 @@
 
 #include "base.h"
 #include "debug.h"
+#include "../debug.h"
 
 static unsigned int ath5k_debug;
 module_param_named(debug, ath5k_debug, uint, 0);
@@ -492,6 +493,7 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 	char buf[700];
 	unsigned int len = 0;
 	u32 filt = ath5k_hw_get_rx_filter(sc->ah);
+	const char *tmp;
 
 	len += snprintf(buf+len, sizeof(buf)-len, "bssid-mask: %pM\n",
 			sc->bssidmask);
@@ -524,6 +526,14 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 	else
 		len += snprintf(buf+len, sizeof(buf)-len, "\n");
 
+	tmp = ath_opmode_to_string(sc->opmode);
+	if (tmp)
+		len += snprintf(buf+len, sizeof(buf)-len, "opmode: %s\n",
+				tmp);
+	else
+		len += snprintf(buf+len, sizeof(buf)-len,
+				"opmode: UNKNOWN-%i\n", sc->opmode);
+
 	if (len > sizeof(buf))
 		len = sizeof(buf);
 
diff --git a/drivers/net/wireless/ath/debug.c b/drivers/net/wireless/ath/debug.c
index 53e77bd..a9eb787 100644
--- a/drivers/net/wireless/ath/debug.c
+++ b/drivers/net/wireless/ath/debug.c
@@ -30,3 +30,32 @@ void ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
 	va_end(args);
 }
 EXPORT_SYMBOL(ath_print);
+
+const char *ath_opmode_to_string(enum nl80211_iftype opmode)
+{
+	switch (opmode) {
+	case NL80211_IFTYPE_UNSPECIFIED:
+		return "UNSPEC";
+	case NL80211_IFTYPE_ADHOC:
+		return "ADHOC";
+	case NL80211_IFTYPE_STATION:
+		return "STATION";
+	case NL80211_IFTYPE_AP:
+		return "AP";
+	case NL80211_IFTYPE_AP_VLAN:
+		return "AP-VLAN";
+	case NL80211_IFTYPE_WDS:
+		return "WDS";
+	case NL80211_IFTYPE_MONITOR:
+		return "MONITOR";
+	case NL80211_IFTYPE_MESH_POINT:
+		return "MESH";
+	case NL80211_IFTYPE_P2P_CLIENT:
+		return "P2P-CLIENT";
+	case NL80211_IFTYPE_P2P_GO:
+		return "P2P-GO";
+	default:
+		return NULL;
+	}
+}
+EXPORT_SYMBOL(ath_opmode_to_string);
diff --git a/drivers/net/wireless/ath/debug.h b/drivers/net/wireless/ath/debug.h
index fd3a020..a3a5a62 100644
--- a/drivers/net/wireless/ath/debug.h
+++ b/drivers/net/wireless/ath/debug.h
@@ -77,4 +77,7 @@ ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
 }
 #endif /* CONFIG_ATH_DEBUG */
 
+/** Returns string describing opmode, or NULL if unknown mode. */
+const char *ath_opmode_to_string(enum nl80211_iftype opmode);
+
 #endif /* ATH_DEBUG_H */
-- 
1.7.2.2

