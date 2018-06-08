Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47998 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751027AbeFHHE5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Jun 2018 03:04:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  8 Jun 2018 10:04:47 +0300
Message-Id: <20180608070447.20252-1-luca@coelho.fi> (sfid-20180608_090501_202804_FAD37F77)
Subject: [PATCH] nl80211: fix some kernel doc tag mistakes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

There is a bunch of tags marking constants with &, which means struct
or enum name.  Replace them with %, which is the correct tag for
constants.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/uapi/linux/nl80211.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 28b36545de24..27e4e441caac 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -981,18 +981,18 @@
  *	only the %NL80211_ATTR_IE data is used and updated with this command.
  *
  * @NL80211_CMD_SET_PMK: For offloaded 4-Way handshake, set the PMK or PMK-R0
- *	for the given authenticator address (specified with &NL80211_ATTR_MAC).
- *	When &NL80211_ATTR_PMKR0_NAME is set, &NL80211_ATTR_PMK specifies the
+ *	for the given authenticator address (specified with %NL80211_ATTR_MAC).
+ *	When %NL80211_ATTR_PMKR0_NAME is set, %NL80211_ATTR_PMK specifies the
  *	PMK-R0, otherwise it specifies the PMK.
  * @NL80211_CMD_DEL_PMK: For offloaded 4-Way handshake, delete the previously
  *	configured PMK for the authenticator address identified by
- *	&NL80211_ATTR_MAC.
+ *	%NL80211_ATTR_MAC.
  * @NL80211_CMD_PORT_AUTHORIZED: An event that indicates that the 4 way
  *	handshake was completed successfully by the driver. The BSSID is
- *	specified with &NL80211_ATTR_MAC. Drivers that support 4 way handshake
+ *	specified with %NL80211_ATTR_MAC. Drivers that support 4 way handshake
  *	offload should send this event after indicating 802.11 association with
- *	&NL80211_CMD_CONNECT or &NL80211_CMD_ROAM. If the 4 way handshake failed
- *	&NL80211_CMD_DISCONNECT should be indicated instead.
+ *	%NL80211_CMD_CONNECT or %NL80211_CMD_ROAM. If the 4 way handshake failed
+ *	%NL80211_CMD_DISCONNECT should be indicated instead.
  *
  * @NL80211_CMD_CONTROL_PORT_FRAME: Control Port (e.g. PAE) frame TX request
  *	and RX notification.  This command is used both as a request to transmit
@@ -1029,9 +1029,9 @@
  *	initiated the connection through the connect request.
  *
  * @NL80211_CMD_STA_OPMODE_CHANGED: An event that notify station's
- *	ht opmode or vht opmode changes using any of &NL80211_ATTR_SMPS_MODE,
- *	&NL80211_ATTR_CHANNEL_WIDTH,&NL80211_ATTR_NSS attributes with its
- *	address(specified in &NL80211_ATTR_MAC).
+ *	ht opmode or vht opmode changes using any of %NL80211_ATTR_SMPS_MODE,
+ *	%NL80211_ATTR_CHANNEL_WIDTH,%NL80211_ATTR_NSS attributes with its
+ *	address(specified in %NL80211_ATTR_MAC).
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -2218,7 +2218,7 @@ enum nl80211_commands {
  * @NL80211_ATTR_EXTERNAL_AUTH_ACTION: Identify the requested external
  *     authentication operation (u32 attribute with an
  *     &enum nl80211_external_auth_action value). This is used with the
- *     &NL80211_CMD_EXTERNAL_AUTH request event.
+ *     %NL80211_CMD_EXTERNAL_AUTH request event.
  * @NL80211_ATTR_EXTERNAL_AUTH_SUPPORT: Flag attribute indicating that the user
  *     space supports external authentication. This attribute shall be used
  *     only with %NL80211_CMD_CONNECT request. The driver may offload
@@ -3491,7 +3491,7 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_AUTO_BW: maximum available bandwidth should be calculated
  *	base on contiguous rules and wider channels will be allowed to cross
  *	multiple contiguous/overlapping frequency ranges.
- * @NL80211_RRF_IR_CONCURRENT: See &NL80211_FREQUENCY_ATTR_IR_CONCURRENT
+ * @NL80211_RRF_IR_CONCURRENT: See %NL80211_FREQUENCY_ATTR_IR_CONCURRENT
  * @NL80211_RRF_NO_HT40MINUS: channels can't be used in HT40- operation
  * @NL80211_RRF_NO_HT40PLUS: channels can't be used in HT40+ operation
  * @NL80211_RRF_NO_80MHZ: 80MHz operation not allowed
@@ -5643,11 +5643,11 @@ enum nl80211_nan_func_attributes {
  * @NL80211_NAN_SRF_INCLUDE: present if the include bit of the SRF set.
  *	This is a flag.
  * @NL80211_NAN_SRF_BF: Bloom Filter. Present if and only if
- *	&NL80211_NAN_SRF_MAC_ADDRS isn't present. This attribute is binary.
+ *	%NL80211_NAN_SRF_MAC_ADDRS isn't present. This attribute is binary.
  * @NL80211_NAN_SRF_BF_IDX: index of the Bloom Filter. Mandatory if
- *	&NL80211_NAN_SRF_BF is present. This is a u8.
+ *	%NL80211_NAN_SRF_BF is present. This is a u8.
  * @NL80211_NAN_SRF_MAC_ADDRS: list of MAC addresses for the SRF. Present if
- *	and only if &NL80211_NAN_SRF_BF isn't present. This is a nested
+ *	and only if %NL80211_NAN_SRF_BF isn't present. This is a nested
  *	attribute. Each nested attribute is a MAC address.
  * @NUM_NL80211_NAN_SRF_ATTR: internal
  * @NL80211_NAN_SRF_ATTR_MAX: highest NAN SRF attribute
-- 
2.17.1
