Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45012 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752987AbbKIKRy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 05:17:54 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: samueltan@google.com, linux-wireless@vger.kernel.org
Date: Mon,  9 Nov 2015 12:17:37 +0200
Message-Id: <1447064257-723-1-git-send-email-luca@coelho.fi> (sfid-20151109_111757_220951_6DB57B2D)
Subject: [PATCH v2] nl80211: clarify NL80211_ATTR_SCHED_SCAN_DELAY usage with net-detect
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

In this attribute's documentation, it was not clear whether the delay
started counting when WoWLAN net-detect was enabled or when the system
was suspended.  The correct answer is that it starts when the system
suspends (which is when, in practice, the scan is scheduled).  Clarify
that in the nl80211.h documentation.

Suggested-by: Samuel Tan <samueltan@google.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/uapi/linux/nl80211.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1f0b4cf..07099cb 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1764,8 +1764,9 @@ enum nl80211_commands {
  *	over all channels.
  *
  * @NL80211_ATTR_SCHED_SCAN_DELAY: delay before the first cycle of a
- *	scheduled scan (or a WoWLAN net-detect scan) is started, u32
- *	in seconds.
+ *	scheduled scan is started.  Or the delay before a WoWLAN
+ *	net-detect scan is started, counting from the moment the
+ *	system is suspended.  This value is a u32, in seconds.
 
  * @NL80211_ATTR_REG_INDOOR: flag attribute, if set indicates that the device
  *      is operating in an indoor environment.
-- 
2.6.2

