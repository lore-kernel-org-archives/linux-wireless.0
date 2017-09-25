Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52210 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbdIYMaH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 08:30:07 -0400
From: "Dedy Lansky" <dlansky@codeaurora.org>
To: "'Johannes Berg'" <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
Cc: "wil6210" <wil6210@qca.qualcomm.com>
Subject: [RFC] Add cfg80211/nl80211 support for AP mode 802.11 FT roaming
Date: Mon, 25 Sep 2017 15:30:02 +0300
Message-ID: <000901d335fa$0483f7d0$0d8be770$@codeaurora.org> (sfid-20170925_143059_265312_0DC5E637)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <dlansky@codeaurora.org>

Drivers which have integrated AP SME can use this to communicate with
userspace (e.g. hostapd) for the purpose of FT roaming processing.

cfg80211 API added for driver to indicate received Authentication and
Reassociation frames from the roaming STA.
NL80211_CMD_AUTHENTICATE and NL80211_CMD_ASSOCIATE are enhanced to be used
in AP mode, for indication/response to/from userspace.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
---

In FT roaming, 4 way handshake is piggybacked on top of Authentication
request/response and Reassociation request/response frames.
This RFC provides API for WLAN drivers to communicate with userspace and
pass required information (e.g. Information Elements) so FT 4 way handshake
can be accomplished in userspace.

This RFC describes only documentation and header file changes. In case the
concept is accepted, a complete patch with implementation changes will be
provided.

---
 include/net/cfg80211.h       | 29 +++++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 19 +++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f12fa52..917e3ac 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6183,6 +6183,35 @@ void cfg80211_nan_func_terminated(struct wireless_dev
*wdev,
 				  enum nl80211_nan_func_term_reason reason,
 				  u64 cookie, gfp_t gfp);
 
+/**
+ * cfg80211_ft_auth - notify cfg80211 of FT authentication request
+ *
+ * @dev: network device
+ * @req: information about the authentication request
+ *
+ * This function is called by the driver when it receives FT Authentication
+ * frame in AP mode. This is used only with SME-in-device drivers.
+ * req should provide information about the Authentication frame which will
be
+ * forwarded to userspace.
+ */
+void cfg80211_ft_auth(struct net_device *dev,
+		      struct cfg80211_auth_request *req);
+
+/**
+ * cfg80211_ft_reassoc - notify cfg80211 of FT reassociation request
+ *
+ * @dev: network device
+ * @reassoc_data: Reassociation frame
+ * @reassoc_data_len: Reassociation frame length
+ *
+ * This function is called by the driver when it receives FT Reassociation
+ * frame in AP mode. This is used only with SME-in-device drivers.
+ * reassoc_data contains the Reassociation frame which will be forwarded to
+ * userspace.
+ */
+void cfg80211_ft_reassoc(struct net_device *dev,
+			 const u8 *reassoc_data, size_t reassoc_data_len);
+
 /* ethtool helper */
 void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo
*info);
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 51626b4..65cf0fc 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -496,6 +496,20 @@
  *	case the %NL80211_ATTR_FRAME attribute is replaced with a
  *	%NL80211_ATTR_TIMED_OUT flag (and %NL80211_ATTR_MAC to indicate
which
  *	pending authentication timed out).
+ *	In AP mode, this is used for FT roaming when driver has AP SME, as
an
+ *	authentication indication and response.
+ *	When used as an event, this reports reception of an Authentication
+ *	frame from a STA requesting authentication (i.e.
+ *	MLME-AUTHENTICATE.indication). %NL80211_ATTR_MAC is used to specify
+ *	PeerSTAAddress. %NL80211_ATTR_FRAME attribute contains the
management
+ *	frame.
+ *	When used as a command, it indicates whether authentication is
+ *	successful. WLAN driver should send authentication response to the
+ *	authenticating STA (i.e. MLME-AUTHENTICATE.response).
%NL80211_ATTR_MAC
+ *	is used to specify PeerSTAAddress. %NL80211_ATTR_STATUS_CODE is used
to
+ *	indicate success or failure. %NL80211_ATTR_IE contains FT
Information
+ *	Elements.
+ *
  * @NL80211_CMD_ASSOCIATE: association request and notification; like
  *	NL80211_CMD_AUTHENTICATE but for Association and Reassociation
  *	(similar to MLME-ASSOCIATE.request, MLME-REASSOCIATE.request,
@@ -504,6 +518,11 @@
  *	request is for the initial association to an ESS (that attribute not
  *	included) or for reassociation within the ESS (that attribute is
  *	included).
+ *	In AP mode, this is used for FT roaming when driver has AP SME, as a
+ *	Reassociation indication and response. like NL80211_CMD_AUTHENTICATE
+ *	but for Reassociation (similar to MLME-REASSOCIATE.indication,
+ *	MLME-REASSOCIATE.response).
+ *
  * @NL80211_CMD_DEAUTHENTICATE: deauthentication request and notification;
like
  *	NL80211_CMD_AUTHENTICATE but for Deauthentication frames (similar to
  *	MLME-DEAUTHENTICATION.request and MLME-DEAUTHENTICATE.indication
-- 
1.9.1
