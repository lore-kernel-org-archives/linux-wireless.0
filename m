Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52629 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0I1AOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 20:14:23 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH hostap] wpa_supplicant:  Support scanning single channel.
Date: Mon, 27 Sep 2010 17:14:19 -0700
Message-Id: <1285632859-2014-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This depends on patches recently submitted to the kernel.
When the can_scan_one flag is true, the kernel will not
scan other channels if at least one interface on this phy
is already associated.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 96dec77... 24e222d... M	src/drivers/driver.h
:100644 100644 b884acc... d812eb5... M	src/drivers/driver_nl80211.c
:100644 100644 2ea3ede... 24e5f37... M	src/drivers/nl80211_copy.h
:100644 100644 6e03760... 2c41622... M	wpa_supplicant/config.c
:100644 100644 246c65f... 49128cf... M	wpa_supplicant/config.h
:100644 100644 ee105d9... 52807e9... M	wpa_supplicant/scan.c
 src/drivers/driver.h         |    6 ++++++
 src/drivers/driver_nl80211.c |    3 +++
 src/drivers/nl80211_copy.h   |   12 ++++++++++++
 wpa_supplicant/config.c      |    2 ++
 wpa_supplicant/config.h      |    7 +++++++
 wpa_supplicant/scan.c        |    2 ++
 6 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 96dec77..24e222d 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -261,6 +261,12 @@ struct wpa_driver_scan_params {
 	 * num_filter_ssids - Number of entries in filter_ssids array
 	 */
 	size_t num_filter_ssids;
+
+	/* If true, attempt to only scan the current active channel if at least
+	 * one VIF on this interface's phy is associated.  This can help when
+	 * you are running lots of virtual interfaces.
+	 */
+	int can_scan_one;
 };
 
 /**
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index b884acc..d812eb5 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -1835,6 +1835,9 @@ static int wpa_driver_nl80211_scan(void *priv,
 
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, drv->ifindex);
 
+	if (params->can_scan_one)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_SCAN_ONE_IF_ASSOC);
+
 	for (i = 0; i < params->num_ssids; i++) {
 		wpa_hexdump_ascii(MSG_MSGDUMP, "nl80211: Scan SSID",
 				  params->ssids[i].ssid,
diff --git a/src/drivers/nl80211_copy.h b/src/drivers/nl80211_copy.h
index 2ea3ede..24e5f37 100644
--- a/src/drivers/nl80211_copy.h
+++ b/src/drivers/nl80211_copy.h
@@ -864,6 +864,18 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_LOCAL_STATE_CHANGE,
 
+	NL80211_ATTR_WIPHY_TX_POWER_SETTING,
+	NL80211_ATTR_WIPHY_TX_POWER_LEVEL,
+
+	NL80211_ATTR_TX_FRAME_TYPES,
+	NL80211_ATTR_RX_FRAME_TYPES,
+	NL80211_ATTR_FRAME_TYPE,
+
+	NL80211_ATTR_CONTROL_PORT_ETHERTYPE,
+	NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT,
+
+	NL80211_ATTR_SCAN_ONE_IF_ASSOC,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/wpa_supplicant/config.c b/wpa_supplicant/config.c
index 6e03760..2c41622 100644
--- a/wpa_supplicant/config.c
+++ b/wpa_supplicant/config.c
@@ -2143,6 +2143,7 @@ struct wpa_config * wpa_config_alloc_empty(const char *ctrl_interface,
 	config->eapol_version = DEFAULT_EAPOL_VERSION;
 	config->ap_scan = DEFAULT_AP_SCAN;
 	config->fast_reauth = DEFAULT_FAST_REAUTH;
+	config->can_scan_one = DEFAULT_CAN_SCAN_ONE;
 	config->p2p_go_intent = DEFAULT_P2P_GO_INTENT;
 	config->p2p_intra_bss = DEFAULT_P2P_INTRA_BSS;
 	config->bss_max_count = DEFAULT_BSS_MAX_COUNT;
@@ -2369,6 +2370,7 @@ static const struct global_parse_data global_fields[] = {
 	{ INT_RANGE(eapol_version, 1, 2), 0 },
 	{ INT(ap_scan), 0 },
 	{ INT(fast_reauth), 0 },
+	{ INT(can_scan_one), 0 },
 	{ STR(opensc_engine_path), 0 },
 	{ STR(pkcs11_engine_path), 0 },
 	{ STR(pkcs11_module_path), 0 },
diff --git a/wpa_supplicant/config.h b/wpa_supplicant/config.h
index 246c65f..49128cf 100644
--- a/wpa_supplicant/config.h
+++ b/wpa_supplicant/config.h
@@ -22,6 +22,7 @@
 #define DEFAULT_AP_SCAN 1
 #endif /* CONFIG_NO_SCAN_PROCESSING */
 #define DEFAULT_FAST_REAUTH 1
+#define DEFAULT_CAN_SCAN_ONE 0
 #define DEFAULT_P2P_GO_INTENT 7
 #define DEFAULT_P2P_INTRA_BSS 1
 #define DEFAULT_BSS_MAX_COUNT 200
@@ -382,6 +383,12 @@ struct wpa_config {
 	 * changed_parameters - Bitmap of changed parameters since last update
 	 */
 	unsigned int changed_parameters;
+
+	/* If true, attempt to only scan the current active channel if at least
+	 * one VIF on this interface's phy is associated.  This can help when
+	 * you are running lots of virtual interfaces.
+	 */
+	int can_scan_one;
 };
 
 
diff --git a/wpa_supplicant/scan.c b/wpa_supplicant/scan.c
index ee105d9..52807e9 100644
--- a/wpa_supplicant/scan.c
+++ b/wpa_supplicant/scan.c
@@ -383,6 +383,8 @@ static void wpa_supplicant_scan(void *eloop_ctx, void *timeout_ctx)
 		wpa_printf(MSG_DEBUG, "Starting AP scan for wildcard SSID");
 	}
 
+	params.can_scan_one = wpa_s->conf->can_scan_one;
+
 #ifdef CONFIG_P2P
 	wpa_s->wps->dev.p2p = 1;
 	if (!wps) {
-- 
1.7.2.2

