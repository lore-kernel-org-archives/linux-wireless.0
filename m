Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:32854 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab3JURXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:23:15 -0400
Received: by mail-wi0-f176.google.com with SMTP id l12so4328327wiv.9
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:23:14 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 14/14] cfg80211: remove internal passive-scan and no-ibss guards
Date: Mon, 21 Oct 2013 19:22:38 +0200
Message-Id: <1382376158-25586-15-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_193806_993218_1B70CACC)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The internal guards for no-ibss and passive-scan flags were
left in case drivers were still using them. All drivers
have now been converted so remove these guards.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/net/cfg80211.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 45eb9aa..54cc9f8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -122,9 +122,6 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
 };
 
-#define IEEE80211_CHAN_PASSIVE_SCAN	IEEE80211_CHAN_NO_IR
-#define IEEE80211_CHAN_NO_IBSS		IEEE80211_CHAN_NO_IR
-
 #define IEEE80211_CHAN_NO_HT40 \
 	(IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
 
-- 
1.8.4.rc3

