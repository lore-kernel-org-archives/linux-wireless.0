Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49414 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935381Ab0KQVei (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 16:34:38 -0500
Received: by vws13 with SMTP id 13so1363081vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 13:34:37 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 17 Nov 2010 16:34:37 -0500
Message-ID: <AANLkTi=Z+60nkSv4umXyDdSp0_SUR84he5GYTZLO9=5E@mail.gmail.com>
Subject: [PATCH] cfg80211: fix can_beacon_sec_chan, reenable HT40
From: Mark Mentovai <mark@moxienet.com>
To: linux-wireless@vger.kernel.org
Cc: stable@kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This follows wireless-testing 9236d838c920e90708570d9bbd7bb82d30a38130
("cfg80211: fix extension channel checks to initiate communication") and
fixes accidental case fall-through. Without this fix, HT40 is entirely
blocked.

Cc: stable@kernel.org
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Mark Mentovai <mark@moxienet.com>
---
 net/wireless/chan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index c8d190d..17cd0c0 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -54,8 +54,10 @@ static bool can_beacon_sec_chan(struct wiphy *wiphy,
 	switch (channel_type) {
 	case NL80211_CHAN_HT40PLUS:
 		diff = 20;
+		break;
 	case NL80211_CHAN_HT40MINUS:
 		diff = -20;
+		break;
 	default:
 		return false;
 	}
-- 
1.7.0.4
