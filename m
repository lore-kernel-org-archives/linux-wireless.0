Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:22605 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754495Ab0ELI1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 04:27:46 -0400
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0451912865
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 17:27:45 +0900 (JST)
Subject: [PATCH 2/3] iw: sync nl80211.h with wireless-testing
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Date: Wed, 12 May 2010 17:27:46 +0900
Message-ID: <20100512082746.26746.58172.stgit@tt-desk>
In-Reply-To: <20100512082516.26746.19520.stgit@tt-desk>
References: <20100512082516.26746.19520.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adding antenna settings

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 nl80211.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index b7c77f9..46a2c76 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -341,6 +341,9 @@
  *	of any other interfaces, and other interfaces will again take
  *	precedence when they are used.
  *
+ * @NL80211_CMD_SET_ANTENNA: Set a bitmap of antennas to use.
+ * @NL80211_CMD_GET_ANTENNA: Get antenna configuration from driver.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -441,6 +444,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_CHANNEL,
 
+	NL80211_CMD_SET_ANTENNA,
+	NL80211_CMD_GET_ANTENNA,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -725,6 +731,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_AP_ISOLATE: (AP mode) Do not forward traffic between stations
  *	connected to this BSS.
  *
+ * @NL80211_ATTR_ANTENNA_TX: Bitmap of antennas to use for transmitting.
+ * @NL80211_ATTR_ANTENNA_RX: Bitmap of antennas to use for receiving.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -882,6 +891,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_AP_ISOLATE,
 
+	NL80211_ATTR_ANTENNA_TX,
+	NL80211_ATTR_ANTENNA_RX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,

