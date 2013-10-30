Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:48713 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3J3RJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 13:09:39 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so810084eae.38
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 10:09:38 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] nl80211: better document NL80211_CMD_TDLS_MGMT
Date: Wed, 30 Oct 2013 19:09:34 +0200
Message-Id: <1383152974-13097-1-git-send-email-arik@wizery.com> (sfid-20131030_180942_598206_17F58F87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This command has different semantics depending on the action code sent.
Document this fact and detail the supported action codes.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/uapi/linux/nl80211.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f752e98..877c048 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -581,7 +581,14 @@
  *	operation, %NL80211_ATTR_MAC contains the peer MAC address, and
  *	%NL80211_ATTR_REASON_CODE the reason code to be used (only with
  *	%NL80211_TDLS_TEARDOWN).
- * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame.
+ * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame. The
+ *	%NL80211_ATTR_TDLS_ACTION attribute determines the typ of frame to be
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

