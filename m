Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:16780 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752373Ab0EKIjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 04:39:21 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0666507159
	for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 17:39:19 +0900 (JST)
Subject: [RFC PATCH 2/3] iw: sync nl80211.h with wireless-testing
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Date: Tue, 11 May 2010 17:39:39 +0900
Message-ID: <20100511083939.28347.17889.stgit@tt-desk>
In-Reply-To: <20100511083933.28347.37155.stgit@tt-desk>
References: <20100511083933.28347.37155.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adding AP isolate, set channel and antenna settings

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 nl80211.h |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index daf6a34..46a2c76 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -52,6 +52,8 @@
  *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE, %NL80211_ATTR_WIPHY_RETRY_SHORT,
  *	%NL80211_ATTR_WIPHY_RETRY_LONG, %NL80211_ATTR_WIPHY_FRAG_THRESHOLD,
  *	and/or %NL80211_ATTR_WIPHY_RTS_THRESHOLD.
+ *	However, for setting the channel, see %NL80211_CMD_SET_CHANNEL
+ *	instead, the support here is for backward compatibility only.
  * @NL80211_CMD_NEW_WIPHY: Newly created wiphy, response to get request
  *	or rename notification. Has attributes %NL80211_ATTR_WIPHY and
  *	%NL80211_ATTR_WIPHY_NAME.
@@ -329,6 +331,18 @@
  * @NL80211_CMD_NOTIFY_CQM: Connection quality monitor notification. This
  *	command is used as an event to indicate the that a trigger level was
  *	reached.
+ * @NL80211_CMD_SET_CHANNEL: Set the channel (using %NL80211_ATTR_WIPHY_FREQ
+ *	and %NL80211_ATTR_WIPHY_CHANNEL_TYPE) the given interface (identifed
+ *	by %NL80211_ATTR_IFINDEX) shall operate on.
+ *	In case multiple channels are supported by the device, the mechanism
+ *	with which it switches channels is implementation-defined.
+ *	When a monitor interface is given, it can only switch channel while
+ *	no other interfaces are operating to avoid disturbing the operation
+ *	of any other interfaces, and other interfaces will again take
+ *	precedence when they are used.
+ *
+ * @NL80211_CMD_SET_ANTENNA: Set a bitmap of antennas to use.
+ * @NL80211_CMD_GET_ANTENNA: Get antenna configuration from driver.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -428,6 +442,11 @@ enum nl80211_commands {
 	NL80211_CMD_SET_CQM,
 	NL80211_CMD_NOTIFY_CQM,
 
+	NL80211_CMD_SET_CHANNEL,
+
+	NL80211_CMD_SET_ANTENNA,
+	NL80211_CMD_GET_ANTENNA,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -703,6 +722,18 @@ enum nl80211_commands {
  * @NL80211_ATTR_CQM: connection quality monitor configuration in a
  *	nested attribute with %NL80211_ATTR_CQM_* sub-attributes.
  *
+ * @NL80211_ATTR_LOCAL_STATE_CHANGE: Flag attribute to indicate that a command
+ *	is requesting a local authentication/association state change without
+ *	invoking actual management frame exchange. This can be used with
+ *	NL80211_CMD_AUTHENTICATE, NL80211_CMD_DEAUTHENTICATE,
+ *	NL80211_CMD_DISASSOCIATE.
+ *
+ * @NL80211_ATTR_AP_ISOLATE: (AP mode) Do not forward traffic between stations
+ *	connected to this BSS.
+ *
+ * @NL80211_ATTR_ANTENNA_TX: Bitmap of antennas to use for transmitting.
+ * @NL80211_ATTR_ANTENNA_RX: Bitmap of antennas to use for receiving.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -856,6 +887,13 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_CQM,
 
+	NL80211_ATTR_LOCAL_STATE_CHANGE,
+
+	NL80211_ATTR_AP_ISOLATE,
+
+	NL80211_ATTR_ANTENNA_TX,
+	NL80211_ATTR_ANTENNA_RX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,

