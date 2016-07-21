Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35474 "EHLO
	mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbcGUPkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 11:40:06 -0400
Received: by mail-qk0-f194.google.com with SMTP id q62so6640731qkf.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 08:40:05 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] iw: display 5/10 MHz channel widths
Date: Thu, 21 Jul 2016 11:39:48 -0400
Message-Id: <20160721153948.32171-1-me@bobcopeland.com> (sfid-20160721_174010_251857_C8C81C83)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iw was showing 'width: unknown' for channels on OCB interfaces; teach
it the values for 5/10 MHz so it will show the configured width.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 interface.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/interface.c b/interface.c
index 209561d..2802235 100644
--- a/interface.c
+++ b/interface.c
@@ -295,6 +295,10 @@ char *channel_width_name(enum nl80211_chan_width width)
 		return "80+80 MHz";
 	case NL80211_CHAN_WIDTH_160:
 		return "160 MHz";
+	case NL80211_CHAN_WIDTH_5:
+		return "5 MHz";
+	case NL80211_CHAN_WIDTH_10:
+		return "10 MHz";
 	default:
 		return "unknown";
 	}
-- 
2.9.0

