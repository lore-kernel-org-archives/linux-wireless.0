Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:35894 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0BQQGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 11:06:05 -0500
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1HG5ivm030514
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 10:06:02 -0600
Received: from [127.0.1.1] (essapo-nirac253144.europe.nokia.com [10.162.253.144])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1HG5gGj015823
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 18:05:42 +0200
Subject: [PATCH v2 1/3] iw: update nl80211.h to include the new action commands
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 17 Feb 2010 18:05:40 +0200
Message-ID: <20100217160540.4598.45771.stgit@tikku>
In-Reply-To: <20100217155810.4534.69338.stgit@tikku>
References: <20100217155810.4534.69338.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---
 nl80211.h |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 127a730..8e6384f 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -3,7 +3,7 @@
 /*
  * 802.11 netlink interface public header
  *
- * Copyright 2006, 2007, 2008 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006-2010 Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2008 Michael Wu <flamingice@sourmilk.net>
  * Copyright 2008 Luis Carlos Cobo <luisca@cozybit.com>
  * Copyright 2008 Michael Buesch <mb@bu3sch.de>
@@ -299,6 +299,31 @@
  *	rate selection. %NL80211_ATTR_IFINDEX is used to specify the interface
  *	and @NL80211_ATTR_TX_RATES the set of allowed rates.
  *
+ * @NL80211_CMD_REGISTER_ACTION: Register for receiving certain action frames
+ *	(via @NL80211_CMD_ACTION) for processing in userspace. This command
+ *	requires an interface index and a match attribute containing the first
+ *	few bytes of the frame that should match, e.g. a single byte for only
+ *	a category match or four bytes for vendor frames including the OUI.
+ *	The registration cannot be dropped, but is removed automatically
+ *	when the netlink socket is closed. Multiple registrations can be made.
+ * @NL80211_CMD_ACTION: Action frame TX request and RX notification. This
+ *	command is used both as a request to transmit an Action frame and as an
+ *	event indicating reception of an Action frame that was not processed in
+ *	kernel code, but is for us (i.e., which may need to be processed in a
+ *	user space application). %NL80211_ATTR_FRAME is used to specify the
+ *	frame contents (including header). %NL80211_ATTR_WIPHY_FREQ (and
+ *	optionally %NL80211_ATTR_WIPHY_CHANNEL_TYPE) is used to indicate on
+ *	which channel the frame is to be transmitted or was received. This
+ *	channel has to be the current channel (remain-on-channel or the
+ *	operational channel). When called, this operation returns a cookie
+ *	(%NL80211_ATTR_COOKIE) that will be included with the TX status event
+ *	pertaining to the TX request.
+ * @NL80211_CMD_ACTION_TX_STATUS: Report TX status of an Action frame
+ *	transmitted with %NL80211_CMD_ACTION. %NL80211_ATTR_COOKIE identifies
+ *	the TX command and %NL80211_ATTR_FRAME includes the contents of the
+ *	frame. %NL80211_ATTR_ACK flag is included if the recipient acknowledged
+ *	the frame.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -387,6 +412,10 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_TX_BITRATE_MASK,
 
+	NL80211_CMD_REGISTER_ACTION,
+	NL80211_CMD_ACTION,
+	NL80211_CMD_ACTION_TX_STATUS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -653,6 +682,12 @@ enum nl80211_commands {
  *	rates based on negotiated supported rates information. This attribute
  *	is used with %NL80211_CMD_SET_TX_BITRATE_MASK.
  *
+ * @NL80211_ATTR_FRAME_MATCH: A binary attribute which typically must contain
+ *	at least one byte, currently used with @NL80211_CMD_REGISTER_ACTION.
+ *
+ * @NL80211_ATTR_ACK: Flag attribute indicating that the frame was
+ *	acknowledged by the recipient.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -798,6 +833,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TX_RATES,
 
+	NL80211_ATTR_FRAME_MATCH,
+
+	NL80211_ATTR_ACK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,

