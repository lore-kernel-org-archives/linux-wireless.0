Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10773 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbcDFOj3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 10:39:29 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Improve Connect/Associate command documentation
Date: Wed, 6 Apr 2016 17:38:44 +0300
Message-ID: <1459953524-12590-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20160406_163933_986534_5890A1FB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The roaming cases for the Connect command were not fully covered and
neither Connect nor Associate command uses of the prev_bssid parameter
were very clear. Add details to describe how the prev_bssid argument is
supposed to be used and when the driver should use association or
reassociation.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       | 26 +++++++++++++++++++++++---
 include/uapi/linux/nl80211.h | 16 +++++++++++++---
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b39277e..5ec2036 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1750,7 +1750,12 @@ enum cfg80211_assoc_req_flags {
  * @ie_len: Length of ie buffer in octets
  * @use_mfp: Use management frame protection (IEEE 802.11w) in this association
  * @crypto: crypto settings
- * @prev_bssid: previous BSSID, if not %NULL use reassociate frame
+ * @prev_bssid: previous BSSID, if not %NULL use reassociate frame. This is used
+ *	to indicate a request to reassociate within the ESS instead of a request
+ *	do the initial association with the ESS. When included, this is set to
+ *	the BSSID of the current association, i.e., to the value that is
+ *	included in the Current AP address field of the Reassociation Request
+ *	frame.
  * @flags:  See &enum cfg80211_assoc_req_flags
  * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
  *	will be used in ht_capa.  Un-supported values will be ignored.
@@ -1925,7 +1930,12 @@ struct cfg80211_bss_selection {
  * @pbss: if set, connect to a PCP instead of AP. Valid for DMG
  *	networks.
  * @bss_select: criteria to be used for BSS selection.
- * @prev_bssid: previous BSSID, if not %NULL use reassociate frame
+ * @prev_bssid: previous BSSID, if not %NULL use reassociate frame. This is used
+ *	to indicate a request to reassociate within the ESS instead of a request
+ *	do the initial association with the ESS. When included, this is set to
+ *	the BSSID of the current association, i.e., to the value that is
+ *	included in the Current AP address field of the Reassociation Request
+ *	frame.
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
@@ -2377,7 +2387,17 @@ struct cfg80211_qos_map {
  * @connect: Connect to the ESS with the specified parameters. When connected,
  *	call cfg80211_connect_result() with status code %WLAN_STATUS_SUCCESS.
  *	If the connection fails for some reason, call cfg80211_connect_result()
- *	with the status from the AP.
+ *	with the status from the AP. The driver is allowed to roam to other
+ *	BSSes within the ESS when the other BSS matches the connect parameters.
+ *	When such roaming is initiated by the driver, the driver is expected to
+ *	verify that the target matches the configured security parameters and
+ *	to use Reassociation Request frame instead of Association Request frame.
+ *	The connect function can also be used to request the driver to perform
+ *	a specific roam when connected to an ESS. In that case, the prev_bssid
+ *	parameter is set to the BSSID of the currently associated BSS as an
+ *	indication of requesting reassociation. In both the driver-initiated and
+ *	new connect() call initiated roaming cases, the result of roaming is
+ *	indicated with a call to cfg80211_roamed() or cfg80211_roamed_bss().
  *	(invoked with the wireless_dev mutex held)
  * @disconnect: Disconnect from the BSS/ESS.
  *	(invoked with the wireless_dev mutex held)
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6da52d7..b460628 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -429,7 +429,11 @@
  * @NL80211_CMD_ASSOCIATE: association request and notification; like
  *	NL80211_CMD_AUTHENTICATE but for Association and Reassociation
  *	(similar to MLME-ASSOCIATE.request, MLME-REASSOCIATE.request,
- *	MLME-ASSOCIATE.confirm or MLME-REASSOCIATE.confirm primitives).
+ *	MLME-ASSOCIATE.confirm or MLME-REASSOCIATE.confirm primitives). The
+ *	%NL80211_ATTR_PREV_BSSID attribute is used to specify whether the
+ *	request is for the initial association to an ESS (that attribute not
+ *	included) or for reassociation within the ESS (that attribute is
+ *	included).
  * @NL80211_CMD_DEAUTHENTICATE: deauthentication request and notification; like
  *	NL80211_CMD_AUTHENTICATE but for Deauthentication frames (similar to
  *	MLME-DEAUTHENTICATION.request and MLME-DEAUTHENTICATE.indication
@@ -479,6 +483,9 @@
  *	set of BSSID,frequency parameters is used (i.e., either the enforcing
  *	%NL80211_ATTR_MAC,%NL80211_ATTR_WIPHY_FREQ or the less strict
  *	%NL80211_ATTR_MAC_HINT and %NL80211_ATTR_WIPHY_FREQ_HINT).
+ *	%NL80211_ATTR_PREV_BSSID can be used to request a reassociation within
+ *	the ESS in case the device is already associated and an association with
+ *	a different BSS is desired.
  *	Background scan period can optionally be
  *	specified in %NL80211_ATTR_BG_SCAN_PERIOD,
  *	if not specified default background scan configuration
@@ -1287,8 +1294,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_RESP_IE: (Re)association response information elements as
  *	sent by peer, for ROAM and successful CONNECT events.
  *
- * @NL80211_ATTR_PREV_BSSID: previous BSSID, to be used by in ASSOCIATE
- *	commands to specify using a reassociate frame
+ * @NL80211_ATTR_PREV_BSSID: previous BSSID, to be used in ASSOCIATE and CONNECT
+ *	commands to specify a request to reassociate within an ESS, i.e., to use
+ *	Reassociate Request frame (with the value of this attribute in the
+ *	Current AP address field) instead of Association Request frame which is
+ *	used for the initial association to an ESS.
  *
  * @NL80211_ATTR_KEY: key information in a nested attribute with
  *	%NL80211_KEY_* sub-attributes
-- 
1.9.1

