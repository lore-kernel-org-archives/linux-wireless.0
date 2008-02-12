Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57003 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYBLTN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 14:13:26 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH #2] mac80211: Extend filter flag documentation about unsupported flags
Date: Tue, 12 Feb 2008 20:12:45 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Message-Id: <200802122012.45307.mb@bu3sch.de> (sfid-20080212_191333_067678_F8C30205)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends the filter flags documentation to make it clear
what clearing a flag really means.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

Index: wireless-2.6/include/net/mac80211.h
===================================================================
--- wireless-2.6.orig/include/net/mac80211.h	2008-02-08 22:54:22.000000000 +0100
+++ wireless-2.6/include/net/mac80211.h	2008-02-12 20:07:19.000000000 +0100
@@ -790,14 +790,24 @@ static inline void SET_IEEE80211_PERM_AD
  *
  * If your device has no multicast address filters your driver will
  * need to check both the %FIF_ALLMULTI flag and the @mc_count
  * parameter to see whether multicast frames should be accepted
  * or dropped.
  *
- * All unsupported flags in @total_flags must be cleared, i.e. you
- * should clear all bits except those you honoured.
+ * All unsupported flags in @total_flags must be cleared.
+ * Hardware does not support a flag if it is incapable of _passing_
+ * the frame to the stack. Otherwise the driver must ignore
+ * the flag, but not clear it.
+ * You must _only_ clear the flag (announce no support for the
+ * flag to mac80211) if you are not able to pass the packet type
+ * to the stack (so the hardware always filters it).
+ * So for example, you should clear @FIF_CONTROL, if your hardware
+ * always filters control frames. If your hardware always passes
+ * control frames to the kernel and is incapable of filtering them,
+ * you do _not_ clear the @FIF_CONTROL flag.
+ * This rule applies to all other FIF flags as well.
  */
 
 /**
  * enum ieee80211_filter_flags - hardware filter flags
  *
  * These flags determine what the filter in hardware should be
