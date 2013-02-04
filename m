Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:56958 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055Ab3BDLBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 06:01:36 -0500
Message-ID: <510F950C.6000103@posedge.com> (sfid-20130204_120140_605293_85A9B214)
Date: Mon, 04 Feb 2013 16:31:32 +0530
From: Srinivasan B <srinivasanb@posedge.com>
MIME-Version: 1.0
To: johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org
Subject: [RFC v1 ] hostapd:  Beacon generation with Power Constraint IE -
 11h TPC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch includes modifications in hostapd to generate beacons and 
probe response packets with Power Constraint IE.

This patch is based on the initial design RFC proposed with subject 
"[RFC - v1 - design doc] hostapd:  Beacon generation with Power 
Constraint IE - 11h TPC".

Changes from the proposed design:
------------------------------------------------
Design document proposes to imply TPC only for devices operating in 
U-NII 2 band. As per further analysis of beacons transmitted by Netgear, 
CISCO APs and few other APs in 802.11A mode, the power constraint IE is 
also included in beacons transmitted in U-NII 1, U-NII 3 bands. Hence 
power constraint IE is included in all beacons/probe response packets 
for devices operating in 80211A mode (without restricting to U-NII 2 
band) and with 80211h flag enabled in hostapd.config

Signed-off-by: Srinivasan <srinivasanb@posedge.com>
---
  hostapd/config_file.c |    8 ++++++++
  hostapd/hostapd.conf  |    5 +++++
  src/ap/ap_config.h    |    3 +++
  src/ap/beacon.c       |   30 ++++++++++++++++++++++++++++++
  src/ap/ieee802_11.c   |    5 +++++
  5 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/hostapd/config_file.c b/hostapd/config_file.c
index 7b22dfd..b6a3b6e 100644
--- a/hostapd/config_file.c
+++ b/hostapd/config_file.c
@@ -1224,6 +1224,12 @@ static int hostapd_config_check(struct 
hostapd_config *conf)
          return -1;
      }

+    if (conf->ieee80211h && !conf->ieee80211d) {
+        wpa_printf(MSG_ERROR, "Cannot enable IEEE 802.11h without "
+               "enabling 802.11d ");
+        return -1;
+    }
+
      for (i = 0; i < conf->num_bss; i++) {
          if (hostapd_config_check_bss(&conf->bss[i], conf))
              return -1;
@@ -1785,6 +1791,8 @@ static int hostapd_config_fill(struct 
hostapd_config *conf,
              conf->country[2] = ' ';
          } else if (os_strcmp(buf, "ieee80211d") == 0) {
              conf->ieee80211d = atoi(pos);
+        } else if (os_strcmp(buf, "ieee80211h") == 0) {
+            conf->ieee80211h = atoi(pos);
          } else if (os_strcmp(buf, "ieee8021x") == 0) {
              bss->ieee802_1x = atoi(pos);
          } else if (os_strcmp(buf, "eapol_version") == 0) {
diff --git a/hostapd/hostapd.conf b/hostapd/hostapd.conf
index eca3996..759489f 100644
--- a/hostapd/hostapd.conf
+++ b/hostapd/hostapd.conf
@@ -105,6 +105,11 @@ ssid=test
  # (default: 0 = disabled)
  #ieee80211d=1

+# Enable IEEE 802.11h. This is a partial support for 802.11h which
+# includes Power Constraint IE in beacon and prb response.
+# (default: 0 = disabled)
+#ieee80211h=1
+
  # Operation mode (a = IEEE 802.11a, b = IEEE 802.11b, g = IEEE 802.11g,
  # ad = IEEE 802.11ad (60 GHz); a/g options are used with IEEE 802.11n, 
too, to
  # specify band)
diff --git a/src/ap/ap_config.h b/src/ap/ap_config.h
index 4742107..a0624b9 100644
--- a/src/ap/ap_config.h
+++ b/src/ap/ap_config.h
@@ -460,6 +460,8 @@ struct hostapd_bss_config {
      int *sae_groups;
  };

+/* Default value for pwr constraint */
+#define DEFAULT_PWR_CONSTRAINT 0

  /**
   * struct hostapd_config - Per-radio interface configuration
@@ -495,6 +497,7 @@ struct hostapd_config {
                */

      int ieee80211d;
+    int ieee80211h;

      struct hostapd_tx_queue_params tx_queue[NUM_TX_QUEUES];

diff --git a/src/ap/beacon.c b/src/ap/beacon.c
index 4c47c75..9749d45 100644
--- a/src/ap/beacon.c
+++ b/src/ap/beacon.c
@@ -172,6 +172,30 @@ static u8 * hostapd_eid_country(struct hostapd_data 
*hapd, u8 *eid,
      return pos;
  }

+static u8 * hostapd_eid_pwr_constraint(struct hostapd_data *hapd, u8 *eid)
+{
+    u8 *pos = eid;
+
+    if (!hapd->iconf->ieee80211h ||
+        hapd->iface->current_mode == NULL ||
+        hapd->iface->current_mode->mode != HOSTAPD_MODE_IEEE80211A)
+        return eid;
+
+    /* CRDA provides reduced TX power than actual regulatory max TX power.
+     * Value of 0 to the Local Power constraint provides an opportunity
+     * for the client devices to operate at Power Limit provided by CRDA
+     * (for client devices
+     * "Local max TX pwr" = regul max TX pwr - Local pwr constraint)*/
+
+    /* Element ID */
+    *pos++ = WLAN_EID_PWR_CONSTRAINT;
+    /* Length */
+    *pos++ = 1;
+    /* Local Power Constraint */
+    *pos++ = DEFAULT_PWR_CONSTRAINT;
+
+    return pos;
+}

  static u8 * hostapd_eid_wpa(struct hostapd_data *hapd, u8 *eid, size_t 
len)
  {
@@ -242,6 +266,9 @@ static u8 * hostapd_gen_probe_resp(struct 
hostapd_data *hapd,

      pos = hostapd_eid_country(hapd, pos, epos - pos);

+    /* Power Constraint element */
+    pos = hostapd_eid_pwr_constraint(hapd, pos);
+
      /* ERP Information element */
      pos = hostapd_eid_erp_info(hapd, pos);

@@ -631,6 +658,9 @@ void ieee802_11_set_beacon(struct hostapd_data *hapd)
      tailpos = hostapd_eid_country(hapd, tailpos,
                        tail + BEACON_TAIL_BUF_SIZE - tailpos);

+    /* Power Constraint element */
+    tailpos = hostapd_eid_pwr_constraint(hapd, tailpos);
+
      /* ERP Information element */
      tailpos = hostapd_eid_erp_info(hapd, tailpos);

diff --git a/src/ap/ieee802_11.c b/src/ap/ieee802_11.c
index 79235df..2a4f758 100644
--- a/src/ap/ieee802_11.c
+++ b/src/ap/ieee802_11.c
@@ -175,6 +175,11 @@ u16 hostapd_own_capab_info(struct hostapd_data 
*hapd, struct sta_info *sta,
          hapd->iface->num_sta_no_short_slot_time == 0)
          capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;

+    /* To Do: Also consider driver support for DFS to set Spectrum Mgmt*/
+    if (hapd->iface->current_mode &&
+        hapd->iface->current_mode->mode == HOSTAPD_MODE_IEEE80211A &&
+        hapd->iconf->ieee80211h)
+        capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
      return capab;
  }

