Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56453 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0BSVer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 16:34:47 -0500
Received: by bwz1 with SMTP id 1so445371bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 13:34:45 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: Enable HW_REPORTS_TX_ACK_STATUS
Date: Fri, 19 Feb 2010 22:34:39 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201002192234.39945.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P54 devices always generate a full tx_status report
(ACK, PSM, rate control, etc..) for every xmitted frame.

Therefore, I think The driver qualifies for the
REPORTS_TX_ACK_STATUS hardware feature flag.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 3fe6366..199b70b 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -535,6 +535,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_BEACON_FILTER |
+		     IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		     IEEE80211_HW_NOISE_DBM;
 
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
