Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:57979 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935057AbcLPMQA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 07:16:00 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] nl80211: better describe field in struct nl80211_bss_select_rssi_adjust
Date: Fri, 16 Dec 2016 12:15:54 +0000
Message-Id: <1481890554-18019-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161216_131612_655873_D2BDA4ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The two fields in struct nl80211_bss_select_rssi_adjust did not state
their type or unit. Adding documentation.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/uapi/linux/nl80211.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6b76e3b..d74e10b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4964,8 +4964,9 @@ enum nl80211_sched_scan_plan {
 /**
  * struct nl80211_bss_select_rssi_adjust - RSSI adjustment parameters.
  *
- * @band: band of BSS that must match for RSSI value adjustment.
- * @delta: value used to adjust the RSSI value of matching BSS.
+ * @band: band of BSS that must match for RSSI value adjustment. The value
+ *	of this field is according to &enum nl80211_band.
+ * @delta: value used to adjust the RSSI value of matching BSS in dB.
  */
 struct nl80211_bss_select_rssi_adjust {
 	__u8 band;
-- 
1.9.1
