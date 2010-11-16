Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48839 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0KPAWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 19:22:33 -0500
Message-ID: <4CE1CEC6.2050103@candelatech.com>
Date: Mon, 15 Nov 2010 16:22:30 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RFC/PATCH:  Allow wpa_supplicant to share scan results.
Content-Type: multipart/mixed;
 boundary="------------030608030703070201060902"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030608030703070201060902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


The attached (and inline) patch allows wpa_supplicant to share scan results
between all VIFS on the same radio (phy).  This patch is a bit rough, but
it does appear to do what I was hoping for.

Please let me know if this has any chance and upstream inclusion.

I know I need to at least strip out some of the debug code, and make
this optional via the global config file, but I was hoping early feedback
might save more work later...

Thanks,
Ben


diff --git a/wpa_supplicant/events.c b/wpa_supplicant/events.c
index 39ac33b..6c2617a 100644
--- a/wpa_supplicant/events.c
+++ b/wpa_supplicant/events.c
@@ -44,6 +44,11 @@
  #include "mlme.h"
  #include "scan.h"

+#ifdef __linux__
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#endif

  static int wpa_supplicant_select_config(struct wpa_supplicant *wpa_s)
  {
@@ -810,8 +815,7 @@ static int wpa_supplicant_need_to_roam(struct wpa_supplicant *wpa_s,
  	return 1;
  }

-
-static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
+static void _wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
  					      union wpa_event_data *data)
  {
  	struct wpa_bss *selected;
@@ -851,7 +855,7 @@ static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
  		return;
  	}

-	wpa_printf(MSG_DEBUG, "New scan results available");
+	wpa_printf(MSG_DEBUG, "%s: New scan results available", wpa_s->ifname);
  	wpa_msg_ctrl(wpa_s, MSG_INFO, WPA_EVENT_SCAN_RESULTS);
  	wpas_notify_scan_results(wpa_s);

@@ -910,6 +914,85 @@ static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
  		}
  	}
  }
+
+static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
+					      union wpa_event_data *data)
+{
+	_wpa_supplicant_event_scan_results(wpa_s, data);
+	
+#ifdef __linux__
+	{
+		char buf[90];
+		char phyname[30];
+		char phyname2[30];
+		int f;
+		int rv;
+		struct wpa_supplicant *ifs;
+
+		wpa_printf(MSG_DEBUG, "%s: Checking for peer VIFS in event_scan_results.\n",
+			   wpa_s->ifname);
+
+		snprintf(buf, sizeof(buf) - 1, "/sys/class/net/%s/phy80211/name", wpa_s->ifname);
+		f = open(buf, O_RDONLY);
+		if (f < 0) {
+			wpa_printf(MSG_DEBUG, "Could not open file: %s, error: %s",
+				   buf, strerror(errno));
+			return;
+		}
+
+		rv = read(f, phyname, sizeof(phyname) - 1);
+		close(f);
+		if (rv < 0) {
+			wpa_printf(MSG_DEBUG, "Could not read file: %s  error: %s",
+				   buf, strerror(errno));
+			return;
+		}
+		phyname[rv] = 0;
+		wpa_printf(MSG_DEBUG, "%s: Found phy name: %s", wpa_s->ifname, phyname);
+
+		/* Ok, we know our phy...now check other interfaces to see if they have the
+		 * same phy.  If so, they get updated with this same scan info.
+		 */
+		ifs = wpa_s->global->ifaces;
+		while (ifs) {
+			if (ifs == wpa_s)
+				ifs = ifs->next;
+			else {
+				snprintf(buf, sizeof(buf) - 1, "/sys/class/net/%s/phy80211/name",
+					 ifs->ifname);
+				wpa_printf(MSG_DEBUG, "Opening: %s", buf);
+				f = open(buf, O_RDONLY);
+				if (f < 0) {
+					wpa_printf(MSG_DEBUG, "Could not open file: %s, error: %s",
+						   buf, strerror(errno));
+					ifs = ifs->next;
+					continue;
+				}
+
+				rv = read(f, phyname2, sizeof(phyname2) - 1);
+				close(f);
+				if (rv < 0) {
+					wpa_printf(MSG_DEBUG, "Could not read file: %s  error: %s",
+						   buf, strerror(errno));
+					ifs = ifs->next;
+					continue;
+				}
+				phyname2[rv] = 0;
+				wpa_printf(MSG_DEBUG, "%s: Found phy name: %s",
+					   ifs->ifname, phyname2);
+				if (strcmp(phyname2, phyname) == 0) {
+					wpa_printf(MSG_DEBUG, "%s: Updating scan results from peer.",
+						   ifs->ifname);
+					/* Got a winner! */
+					_wpa_supplicant_event_scan_results(ifs, data);
+				}
+				ifs = ifs->next;
+			}
+		}
+	}
+#endif
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


--------------030608030703070201060902
Content-Type: text/plain;
 name="supplicant_share_scan_results.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="supplicant_share_scan_results.patch"

diff --git a/wpa_supplicant/events.c b/wpa_supplicant/events.c
index 39ac33b..6c2617a 100644
--- a/wpa_supplicant/events.c
+++ b/wpa_supplicant/events.c
@@ -44,6 +44,11 @@
 #include "mlme.h"
 #include "scan.h"
 
+#ifdef __linux__
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#endif
 
 static int wpa_supplicant_select_config(struct wpa_supplicant *wpa_s)
 {
@@ -810,8 +815,7 @@ static int wpa_supplicant_need_to_roam(struct wpa_supplicant *wpa_s,
 	return 1;
 }
 
-
-static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
+static void _wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
 					      union wpa_event_data *data)
 {
 	struct wpa_bss *selected;
@@ -851,7 +855,7 @@ static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
 		return;
 	}
 
-	wpa_printf(MSG_DEBUG, "New scan results available");
+	wpa_printf(MSG_DEBUG, "%s: New scan results available", wpa_s->ifname);
 	wpa_msg_ctrl(wpa_s, MSG_INFO, WPA_EVENT_SCAN_RESULTS);
 	wpas_notify_scan_results(wpa_s);
 
@@ -910,6 +914,85 @@ static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
 		}
 	}
 }
+
+static void wpa_supplicant_event_scan_results(struct wpa_supplicant *wpa_s,
+					      union wpa_event_data *data)
+{
+	_wpa_supplicant_event_scan_results(wpa_s, data);
+	
+#ifdef __linux__
+	{
+		char buf[90];
+		char phyname[30];
+		char phyname2[30];
+		int f;
+		int rv;
+		struct wpa_supplicant *ifs;
+
+		wpa_printf(MSG_DEBUG, "%s: Checking for peer VIFS in event_scan_results.\n",
+			   wpa_s->ifname);
+
+		snprintf(buf, sizeof(buf) - 1, "/sys/class/net/%s/phy80211/name", wpa_s->ifname);
+		f = open(buf, O_RDONLY);
+		if (f < 0) {
+			wpa_printf(MSG_DEBUG, "Could not open file: %s, error: %s",
+				   buf, strerror(errno));
+			return;
+		}
+
+		rv = read(f, phyname, sizeof(phyname) - 1);
+		close(f);
+		if (rv < 0) {
+			wpa_printf(MSG_DEBUG, "Could not read file: %s  error: %s",
+				   buf, strerror(errno));
+			return;
+		}
+		phyname[rv] = 0;
+		wpa_printf(MSG_DEBUG, "%s: Found phy name: %s", wpa_s->ifname, phyname);
+
+		/* Ok, we know our phy...now check other interfaces to see if they have the
+		 * same phy.  If so, they get updated with this same scan info.
+		 */
+		ifs = wpa_s->global->ifaces;
+		while (ifs) {
+			if (ifs == wpa_s)
+				ifs = ifs->next;
+			else {
+				snprintf(buf, sizeof(buf) - 1, "/sys/class/net/%s/phy80211/name",
+					 ifs->ifname);
+				wpa_printf(MSG_DEBUG, "Opening: %s", buf);
+				f = open(buf, O_RDONLY);
+				if (f < 0) {
+					wpa_printf(MSG_DEBUG, "Could not open file: %s, error: %s",
+						   buf, strerror(errno));
+					ifs = ifs->next;
+					continue;
+				}
+
+				rv = read(f, phyname2, sizeof(phyname2) - 1);
+				close(f);
+				if (rv < 0) {
+					wpa_printf(MSG_DEBUG, "Could not read file: %s  error: %s",
+						   buf, strerror(errno));
+					ifs = ifs->next;
+					continue;
+				}
+				phyname2[rv] = 0;
+				wpa_printf(MSG_DEBUG, "%s: Found phy name: %s",
+					   ifs->ifname, phyname2);
+				if (strcmp(phyname2, phyname) == 0) {
+					wpa_printf(MSG_DEBUG, "%s: Updating scan results from peer.",
+						   ifs->ifname);
+					/* Got a winner! */
+					_wpa_supplicant_event_scan_results(ifs, data);
+				}
+				ifs = ifs->next;
+			}
+		}
+	}
+#endif
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

--------------030608030703070201060902--
