Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:46637 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3JaMyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 08:54:45 -0400
Received: by mail-ee0-f42.google.com with SMTP id b45so1675741eek.15
        for <linux-wireless@vger.kernel.org>; Thu, 31 Oct 2013 05:54:44 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] nl80211: better document NL80211_CMD_TDLS_MGMT
Date: Thu, 31 Oct 2013 14:54:35 +0200
Message-Id: <1383224075-15157-1-git-send-email-arik@wizery.com> (sfid-20131031_135447_677468_5AAE2975)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This command has different semantics depending on the action code sent.
Document this fact and detail the supported action codes.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/uapi/linux/nl80211.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f752e98..3d8325b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -581,7 +581,14 @@
  *	operation, %NL80211_ATTR_MAC contains the peer MAC address, and
  *	%NL80211_ATTR_REASON_CODE the reason code to be used (only with
  *	%NL80211_TDLS_TEARDOWN).
- * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame.
+ * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame. The
+ *	%NL80211_ATTR_TDLS_ACTION attribute determines the type of frame to be
+ *	sent. Public Action codes (802.11-2012 8.1.5.1) will be sent as
+ *	802.11 management frames, while TDLS action codes (802.11-2012
+ *	8.5.13.1) will be encapsulated and sent as data frames. The currently
+ *	supported Public Action code is %WLAN_PUB_ACTION_TDLS_DISCOVER_RES
+ *	and the currently supported TDLS actions codes are given in
+ *	&enum ieee80211_tdls_actioncode.
  *
  * @NL80211_CMD_UNEXPECTED_FRAME: Used by an application controlling an AP
  *	(or GO) interface (i.e. hostapd) to ask for unexpected frames to
-- 
1.8.1.2

