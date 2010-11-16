Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55773 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab0KPUkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 15:40:02 -0500
Message-ID: <4CE2EC1F.7010808@candelatech.com>
Date: Tue, 16 Nov 2010 12:39:59 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC/PATCH:  Allow wpa_supplicant to share scan results.
References: <4CE1CEC6.2050103@candelatech.com> <20101116094512.GB21872@jm.kir.nu> <4CE2B953.9090509@candelatech.com> <20101116193156.GA32723@jm.kir.nu>
In-Reply-To: <20101116193156.GA32723@jm.kir.nu>
Content-Type: multipart/mixed;
 boundary="------------090707060102070302030703"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090707060102070302030703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Please let me know if this is moving in the right direction.  The
ath9k crash actually killed my file-system, so still re-installing
the OS on my test box...  This code is un-tested, but it does compile.

diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index aef8554..0f81b41 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -718,6 +718,11 @@ struct wpa_driver_ops {
  	 */
  	int (*get_ssid)(void *priv, u8 *ssid);

+	/** Return the physical radio name for this device, if known.
+	 * The returned data must not be modified by the caller.
+	 */
+	const char* (*get_radio_name)(void *priv);
+
  	/**
  	 * set_key - Configure encryption key
  	 * @ifname: Interface name (for multi-SSID/VLAN support)
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index 51bf446..ec9b0be 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -18,6 +18,9 @@

  #include "includes.h"
  #include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
  #include <net/if.h>
  #include <netlink/genl/genl.h>
  #include <netlink/genl/family.h>
@@ -27,6 +30,7 @@
  #include <linux/filter.h>
  #include "nl80211_copy.h"

+
  #include "common.h"
  #include "eloop.h"
  #include "common/ieee802_11_defs.h"
@@ -104,6 +108,7 @@ struct i802_bss {
  	struct i802_bss *next;
  	int ifindex;
  	char ifname[IFNAMSIZ + 1];
+	char phyname[32];
  	unsigned int beacon_set:1;
  };

@@ -364,6 +369,12 @@ static int wpa_driver_nl80211_get_ssid(void *priv, u8 *ssid)
  	return drv->ssid_len;
  }

+static const char *wpa_driver_nl80211_get_radio_name(void *priv)
+{
+	struct i802_bss *bss = priv;
+	return bss->phyname;
+}
+

  static void wpa_driver_nl80211_event_link(struct wpa_driver_nl80211_data *drv,
  					  char *buf, size_t len, int del)
@@ -1673,6 +1684,29 @@ static void * wpa_driver_nl80211_init(void *ctx, const char *ifname)
  		return NULL;
  	}

+	/* Find phy this interface belongs to. */
+	{
+		char buf[90];
+		int f;
+		int rv;
+
+		bss->phyname[0] = 0;
+		snprintf(buf, sizeof(buf) - 1, "/sys/class/net/%s/phy80211/name", ifname);
+		f = open(buf, O_RDONLY);
+		if (f < 0)
+			wpa_printf(MSG_DEBUG, "Could not open file: %s, error: %s",
+				   buf, strerror(errno));
+		else {
+			rv = read(f, bss->phyname, sizeof(bss->phyname) - 1);
+			close(f);
+			if (rv < 0)
+				wpa_printf(MSG_DEBUG, "Could not read file: %s  error: %s",
+					   buf, strerror(errno));
+			else
+				bss->phyname[rv] = 0;
+		}
+	}
+
  	drv->ioctl_sock = socket(PF_INET, SOCK_DGRAM, 0);
  	if (drv->ioctl_sock < 0) {
  		perror("socket(PF_INET,SOCK_DGRAM)");
@@ -5952,6 +5986,7 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
  	.desc = "Linux nl80211/cfg80211",
  	.get_bssid = wpa_driver_nl80211_get_bssid,
  	.get_ssid = wpa_driver_nl80211_get_ssid,
+	.get_radio_name = wpa_driver_nl80211_get_radio_name,
  	.set_key = wpa_driver_nl80211_set_key,
  	.scan2 = wpa_driver_nl80211_scan,
  	.get_scan_results2 = wpa_driver_nl80211_get_scan_results,
diff --git a/wpa_supplicant/events.c b/wpa_supplicant/events.c
index 39ac33b..d7d2227 100644
--- a/wpa_supplicant/events.c
+++ b/wpa_supplicant/events.c
@@ -44,7 +44,6 @@
  #include "mlme.h"
  #include "scan.h"

-
  static int wpa_supplicant_select_config(struct wpa_supplicant *wpa_s)
  {
  	struct wpa_ssid *ssid, *old_ssid;
@@ -810,8 +809,7 @@ static int wpa_supplicant_need_to_roam(struct wpa_supplicant *wpa_s,
  	return 1;
  }

-
-static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
+static void _wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
  					      union wpa_event_data *data)
  {
  	struct wpa_bss *selected;
@@ -851,7 +849,7 @@ static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
  		return;
  	}

-	wpa_printf(MSG_DEBUG, "New scan results available");
+	wpa_printf(MSG_DEBUG, "%s: New scan results available", wpa_s->ifname);
  	wpa_msg_ctrl(wpa_s, MSG_INFO, WPA_EVENT_SCAN_RESULTS);
  	wpas_notify_scan_results(wpa_s);

@@ -910,6 +908,46 @@ static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
  		}
  	}
  }
+
+static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
+					      union wpa_event_data *data)
+{
+	const char* rn = NULL;
+	_wpa_supplicant_event_scan_results(wpa_s, data);
+	
+	if (wpa_s->driver->get_radio_name) {
+		rn = wpa_s->driver->get_radio_name(wpa_s->drv_priv);
+	}
+
+	if (rn && rn[0]) {
+		struct wpa_supplicant *ifs;
+		wpa_printf(MSG_DEBUG, "%s: Checking for peer VIFS in event_scan_results.\n",
+			   wpa_s->ifname);
+
+		/* Ok, we know our phy...now check other interfaces
+		 * to see if they have the same phy.  If so, they get
+		 * updated with this same scan info.
+		 */
+		ifs = wpa_s->global->ifaces;
+		while (ifs) {
+			if ((ifs == wpa_s) ||
+			    !ifs->driver->get_radio_name)
+				ifs = ifs->next;
+			else {
+				const char* rn2;
+				rn2 = ifs->driver->get_radio_name(ifs->drv_priv);
+				if (rn2 && (strcmp(rn, rn2) == 0)) {
+					wpa_printf(MSG_DEBUG, "%s: Updating scan results from peer.",
+						   ifs->ifname);
+					/* Got a winner! */
+					_wpa_supplicant_event_scan_results(ifs, data);
+				}
+				ifs = ifs->next;
+			}
+		}
+	}
+}
+
  #endif /* CONFIG_NO_SCAN_PROCESSING */


diff --git a/wpa_supplicant/wpa_supplicant.c b/wpa_supplicant/wpa_supplicant.c
index 0a603af..64f0ef5 100644
--- a/wpa_supplicant/wpa_supplicant.c
+++ b/wpa_supplicant/wpa_supplicant.c
@@ -530,8 +530,8 @@ void wpa_supplicant_set_state(struct wpa_supplicant *wpa_s,
  {
  	enum wpa_states old_state = wpa_s->wpa_state;

-	wpa_printf(MSG_DEBUG, "State: %s -> %s",
-		   wpa_supplicant_state_txt(wpa_s->wpa_state),
+	wpa_printf(MSG_DEBUG, "%s: State: %s -> %s",
+		   wpa_s->ifname, wpa_supplicant_state_txt(wpa_s->wpa_state),
  		   wpa_supplicant_state_txt(state));

  	if (state != WPA_SCANNING)

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


--------------090707060102070302030703
Content-Type: text/plain;
 name="supplicant_share_scan_results2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="supplicant_share_scan_results2.patch"

diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index aef8554..0f81b41 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -718,6 +718,11 @@ struct wpa_driver_ops {
 	 */
 	int (*get_ssid)(void *priv, u8 *ssid);
 
+	/** Return the physical radio name for this device, if known.
+	 * The returned data must not be modified by the caller.
+	 */
+	const char* (*get_radio_name)(void *priv);
+
 	/**
 	 * set_key - Configure encryption key
 	 * @ifname: Interface name (for multi-SSID/VLAN support)
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index 51bf446..ec9b0be 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -18,6 +18,9 @@
 
 #include "includes.h"
 #include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
 #include <net/if.h>
 #include <netlink/genl/genl.h>
 #include <netlink/genl/family.h>
@@ -27,6 +30,7 @@
 #include <linux/filter.h>
 #include "nl80211_copy.h"
 
+
 #include "common.h"
 #include "eloop.h"
 #include "common/ieee802_11_defs.h"
@@ -104,6 +108,7 @@ struct i802_bss {
 	struct i802_bss *next;
 	int ifindex;
 	char ifname[IFNAMSIZ + 1];
+	char phyname[32];
 	unsigned int beacon_set:1;
 };
 
@@ -364,6 +369,12 @@ static int wpa_driver_nl80211_get_ssid(void *priv, u8 *ssid)
 	return drv->ssid_len;
 }
 
+static const char *wpa_driver_nl80211_get_radio_name(void *priv)
+{
+	struct i802_bss *bss = priv;
+	return bss->phyname;
+}
+
 
 static void wpa_driver_nl80211_event_link(struct wpa_driver_nl80211_data *drv,
 					  char *buf, size_t len, int del)
@@ -1673,6 +1684,29 @@ static void * wpa_driver_nl80211_init(void *ctx, const char *ifname)
 		return NULL;
 	}
 
+	/* Find phy this interface belongs to. */
+	{
+		char buf[90];
+		int f;
+		int rv;
+
+		bss->phyname[0] = 0;
+		snprintf(buf, sizeof(buf) - 1, "/sys/class/net/%s/phy80211/name", ifname);
+		f = open(buf, O_RDONLY);
+		if (f < 0)
+			wpa_printf(MSG_DEBUG, "Could not open file: %s, error: %s",
+				   buf, strerror(errno));
+		else {
+			rv = read(f, bss->phyname, sizeof(bss->phyname) - 1);
+			close(f);
+			if (rv < 0)
+				wpa_printf(MSG_DEBUG, "Could not read file: %s  error: %s",
+					   buf, strerror(errno));
+			else
+				bss->phyname[rv] = 0;
+		}
+	}
+
 	drv->ioctl_sock = socket(PF_INET, SOCK_DGRAM, 0);
 	if (drv->ioctl_sock < 0) {
 		perror("socket(PF_INET,SOCK_DGRAM)");
@@ -5952,6 +5986,7 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.desc = "Linux nl80211/cfg80211",
 	.get_bssid = wpa_driver_nl80211_get_bssid,
 	.get_ssid = wpa_driver_nl80211_get_ssid,
+	.get_radio_name = wpa_driver_nl80211_get_radio_name,
 	.set_key = wpa_driver_nl80211_set_key,
 	.scan2 = wpa_driver_nl80211_scan,
 	.get_scan_results2 = wpa_driver_nl80211_get_scan_results,
diff --git a/wpa_supplicant/events.c b/wpa_supplicant/events.c
index 39ac33b..d7d2227 100644
--- a/wpa_supplicant/events.c
+++ b/wpa_supplicant/events.c
@@ -44,7 +44,6 @@
 #include "mlme.h"
 #include "scan.h"
 
-
 static int wpa_supplicant_select_config(struct wpa_supplicant *wpa_s)
 {
 	struct wpa_ssid *ssid, *old_ssid;
@@ -810,8 +809,7 @@ static int wpa_supplicant_need_to_roam(struct wpa_supplicant *wpa_s,
 	return 1;
 }
 
-
-static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
+static void _wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
 					      union wpa_event_data *data)
 {
 	struct wpa_bss *selected;
@@ -851,7 +849,7 @@ static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
 		return;
 	}
 
-	wpa_printf(MSG_DEBUG, "New scan results available");
+	wpa_printf(MSG_DEBUG, "%s: New scan results available", wpa_s->ifname);
 	wpa_msg_ctrl(wpa_s, MSG_INFO, WPA_EVENT_SCAN_RESULTS);
 	wpas_notify_scan_results(wpa_s);
 
@@ -910,6 +908,46 @@ static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
 		}
 	}
 }
+
+static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
+					      union wpa_event_data *data)
+{
+	const char* rn = NULL;
+	_wpa_supplicant_event_scan_results(wpa_s, data);
+	
+	if (wpa_s->driver->get_radio_name) {
+		rn = wpa_s->driver->get_radio_name(wpa_s->drv_priv);
+	}
+
+	if (rn && rn[0]) {
+		struct wpa_supplicant *ifs;
+		wpa_printf(MSG_DEBUG, "%s: Checking for peer VIFS in event_scan_results.\n",
+			   wpa_s->ifname);
+
+		/* Ok, we know our phy...now check other interfaces
+		 * to see if they have the same phy.  If so, they get
+		 * updated with this same scan info.
+		 */
+		ifs = wpa_s->global->ifaces;
+		while (ifs) {
+			if ((ifs == wpa_s) ||
+			    !ifs->driver->get_radio_name)
+				ifs = ifs->next;
+			else {
+				const char* rn2;
+				rn2 = ifs->driver->get_radio_name(ifs->drv_priv);
+				if (rn2 && (strcmp(rn, rn2) == 0)) {
+					wpa_printf(MSG_DEBUG, "%s: Updating scan results from peer.",
+						   ifs->ifname);
+					/* Got a winner! */
+					_wpa_supplicant_event_scan_results(ifs, data);
+				}
+				ifs = ifs->next;
+			}
+		}
+	}
+}
+
 #endif /* CONFIG_NO_SCAN_PROCESSING */
 
 
diff --git a/wpa_supplicant/wpa_supplicant.c b/wpa_supplicant/wpa_supplicant.c
index 0a603af..64f0ef5 100644
--- a/wpa_supplicant/wpa_supplicant.c
+++ b/wpa_supplicant/wpa_supplicant.c
@@ -530,8 +530,8 @@ void wpa_supplicant_set_state(struct wpa_supplicant *wpa_s,
 {
 	enum wpa_states old_state = wpa_s->wpa_state;
 
-	wpa_printf(MSG_DEBUG, "State: %s -> %s",
-		   wpa_supplicant_state_txt(wpa_s->wpa_state),
+	wpa_printf(MSG_DEBUG, "%s: State: %s -> %s",
+		   wpa_s->ifname, wpa_supplicant_state_txt(wpa_s->wpa_state),
 		   wpa_supplicant_state_txt(state));
 
 	if (state != WPA_SCANNING)

--------------090707060102070302030703--
