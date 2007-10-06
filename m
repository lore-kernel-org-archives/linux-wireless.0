Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:18176 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbXJFMER (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:04:17 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605539ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:04:17 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/16] rt2x00: Clean disabling of rt73usb_get_tsf
Date: Sat, 6 Oct 2007 14:18:00 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061418.00743.IvDoorn@gmail.com> (sfid-20071006_131651_128979_E71896FC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By defining rt73usb_get_tsf to NULL we only
have 1 location that needs to be edited
when rt73usb_get_tsf can be enabled again.
This also reduces the number of #ifdefs in
the code which is also a "good thing"

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt73usb.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index a3555e5..71699a7 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1908,6 +1908,8 @@ static u64 rt73usb_get_tsf(struct ieee80211_hw *hw)
 
 	return tsf;
 }
+#else
+#define rt73usb_get_tsf	NULL
 #endif
 
 static void rt73usb_reset_tsf(struct ieee80211_hw *hw)
@@ -1968,12 +1970,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.erp_ie_changed		= rt2x00mac_erp_ie_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
-#if 0
-/*
- * See comment at the rt73usb_get_tsf function.
- */
 	.get_tsf		= rt73usb_get_tsf,
-#endif
 	.reset_tsf		= rt73usb_reset_tsf,
 	.beacon_update		= rt73usb_beacon_update,
 };
-- 
1.5.3.4

