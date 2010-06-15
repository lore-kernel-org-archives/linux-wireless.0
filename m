Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:60408 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0FOJRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 05:17:52 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o5F9HanE026403
	for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 12:17:49 +0300
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o5F9Hlin017059
	for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 12:17:47 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH] iw: Add support for setting transmit power
Date: Tue, 15 Jun 2010 12:17:47 +0300
Message-Id: <1276593467-28309-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the "set tx_power" command to allow specifying the transmit
power level to the WLAN stack. The transmit power configuration consists of
a mode (automatic, fixed, limited) and the limit mBm value.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 Makefile  |    3 ++-
 nl80211.h |   27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index d303f45..cbb9504 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,8 @@ CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
 OBJS = iw.o genl.o event.o info.o phy.o \
 	interface.o ibss.o station.o survey.o util.o \
 	mesh.o mpath.o scan.o reg.o version.o \
-	reason.o status.o connect.o link.o offch.o ps.o cqm.o
+	reason.o status.o connect.o link.o offch.o ps.o cqm.o \
+	txpower.o
 OBJS += sections.o
 ALL = iw
 
diff --git a/nl80211.h b/nl80211.h
index b7c77f9..c98a3a1 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -132,7 +132,7 @@
  * 	%NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN and
  * 	%NL80211_ATTR_REG_RULE_POWER_MAX_EIRP.
  * @NL80211_CMD_REQ_SET_REG: ask the wireless core to set the regulatory domain
- * 	to the the specified ISO/IEC 3166-1 alpha2 country code. The core will
+ * 	to the specified ISO/IEC 3166-1 alpha2 country code. The core will
  * 	store this as a valid request and then query userspace for it.
  *
  * @NL80211_CMD_GET_MESH_PARAMS: Get mesh networking properties for the
@@ -340,6 +340,7 @@
  *	no other interfaces are operating to avoid disturbing the operation
  *	of any other interfaces, and other interfaces will again take
  *	precedence when they are used.
+ * @NL80211_CMD_SET_TX_POWER: Set transmit power level and management type.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -441,6 +442,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_CHANNEL,
 
+	NL80211_CMD_SET_TX_POWER,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -725,6 +728,13 @@ enum nl80211_commands {
  * @NL80211_ATTR_AP_ISOLATE: (AP mode) Do not forward traffic between stations
  *	connected to this BSS.
  *
+ * @NL80211_ATTR_TX_POWER_SETTING: Setting of the transmit power, see
+ *	&enum nl80211_tx_power_setting for the possible values. This is
+ *	currently used with @NL80211_CMD_SET_TX_POWER to specify the transmit
+ *	power.
+ * @NL80211_ATTR_TX_POWER_LEVEL: Trasnmit power level in signed mBm format. This
+ *	is currently used with @NL80211_CMD_SET_TX_POWER to specify the transmit
+ *	power.
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -882,6 +892,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_AP_ISOLATE,
 
+	NL80211_ATTR_TX_POWER_SETTING,
+	NL80211_ATTR_TX_POWER_LEVEL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1624,6 +1637,18 @@ enum nl80211_ps_state {
 };
 
 /**
+ * enum nl80211_tx_power_setting - TX power adjustment
+ * @TX_POWER_AUTOMATIC: automatic TX power handling
+ * @TX_POWER_LIMITED: limit TX power to the specified level
+ * @TX_POWER_FIXED: fix TX power to the specified level
+ */
+enum nl80211_tx_power_setting {
+	NL80211_TX_POWER_AUTOMATIC,
+	NL80211_TX_POWER_LIMITED,
+	NL80211_TX_POWER_FIXED,
+};
+
+/**
  * enum nl80211_attr_cqm - connection quality monitor attributes
  * @__NL80211_ATTR_CQM_INVALID: invalid
  * @NL80211_ATTR_CQM_RSSI_THOLD: RSSI threshold in dBm. This value specifies
-- 
1.6.3.3

