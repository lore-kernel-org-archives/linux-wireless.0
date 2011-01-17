Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:27289 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab1AQQUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:20:05 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 14:07:21 +0100
Subject: [PATCH 4/8] hostap: sync nl80211_copy.h
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161327.88AE92093@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 src/drivers/nl80211_copy.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/src/drivers/nl80211_copy.h b/src/drivers/nl80211_copy.h
index 7483a89..960341c 100644
--- a/src/drivers/nl80211_copy.h
+++ b/src/drivers/nl80211_copy.h
@@ -406,6 +406,12 @@
  *	notification. This event is used to indicate that an unprotected
  *	disassociation frame was dropped when MFP is in use.
  *
+ * @NL80211_CMD_RADAR_CAC_START: Request a CAC
+ * @NL80211_CMD_RADAR_CAC_STOP: Stop as CAC earler
+ * @NL80211_CMD_RADAR_CAC_DONE: Notification sent if a CAC has completed.
+ * @NL80211_CMD_RADAR_FLAGS_CHANGED: Notification sent if channel flags
+ *	have changed.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -518,6 +524,11 @@ enum nl80211_commands {
 	NL80211_CMD_UNPROT_DEAUTHENTICATE,
 	NL80211_CMD_UNPROT_DISASSOCIATE,
 
+	NL80211_CMD_RADAR_CAC_START,
+	NL80211_CMD_RADAR_CAC_STOP,
+	NL80211_CMD_RADAR_CAC_DONE,
+	NL80211_CMD_RADAR_FLAGS_CHANGED,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1338,6 +1349,10 @@ enum nl80211_band_attr {
  *	(100 * dBm).
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
+ * @NL80211_FREQUENCY_ATTR_RADAR_CLEAR: during a full CAC no interference has
+ *	been detected
+ * @NL80211_FREQUENCY_ATTR_RADAR_INTERFERENCE: either during a CAC or
+ *	in-service monitoring radar interference was detected
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_frequency_attr {
@@ -1348,6 +1363,8 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_IBSS,
 	NL80211_FREQUENCY_ATTR_RADAR,
 	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
+	NL80211_FREQUENCY_ATTR_RADAR_CLEAR,
+	NL80211_FREQUENCY_ATTR_RADAR_INTEFERENCE,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
-- 
1.5.6.5

