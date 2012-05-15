Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54629 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab2EOLu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 07:50:59 -0400
Received: by bkcji2 with SMTP id ji2so4699970bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 04:50:58 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] nl80211: add new rssi event to indicate beacon loss
Date: Tue, 15 May 2012 14:50:58 +0300
Message-Id: <1337082658-25363-1-git-send-email-eliad@wizery.com> (sfid-20120515_135103_021575_42106914)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tell userspace about beacon loss event.
This event doesn't replace the deauth/disassoc that
might come if the AP is not available.

The driver can send this event in order to hint
userspace what might follow (which in turn can
use it as roaming trigger).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/linux/nl80211.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2540e86..01d2108 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2532,10 +2532,14 @@ enum nl80211_attr_cqm {
  *      configured threshold
  * @NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH: The RSSI is higher than the
  *      configured threshold
+ * @NL80211_CQM_RSSI_BEACON_LOSS_EVENT: The device experienced beacon loss.
+ *	(Note that deauth/disassoc will still follow if the AP is not
+ *	available. This event might get used as roaming event, etc.)
  */
 enum nl80211_cqm_rssi_threshold_event {
 	NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
 	NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+	NL80211_CQM_RSSI_BEACON_LOSS_EVENT,
 };
 
 
-- 
1.7.6.401.g6a319

