Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ag-out-0708.google.com ([72.14.246.245]:32556 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762930AbYBBWxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 17:53:38 -0500
Received: by ag-out-0708.google.com with SMTP id 35so348157aga.10
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 14:53:37 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: Fix WARN_ON() with ieee802.11b
Date: Sat, 2 Feb 2008 23:53:10 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802022353.10286.IvDoorn@gmail.com> (sfid-20080202_225341_015109_F769CCDC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver registers a IEEE80211_BAND_2GHZ band,
it can either be 802.11b or 802.11g. But when 802.11b rates
are registered "want" will be 3 (since 4 rates are being registered,
and each of those 4 rates will decrease "want").
Since this is a correct situation, there is no need to trigger
a WARN_ON() for this.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 0dcccbf..5304c62 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -80,7 +80,7 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 				sband->bitrates[i].flags |=
 					IEEE80211_RATE_ERP_G;
 		}
-		WARN_ON(want != 0 && want != 6);
+		WARN_ON(want != 0 && want != 3 && want != 6);
 		break;
 	case IEEE80211_NUM_BANDS:
 		WARN_ON(1);
