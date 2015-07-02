Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34950 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbbGBRmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 13:42:46 -0400
Received: by iecuq6 with SMTP id uq6so61548759iec.2
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 10:42:46 -0700 (PDT)
From: Wei Zhong <wzhong@google.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Wei Zhong <wzhong@google.com>
Subject: [PATCH] wireless: regulatory: save user-specified alpha2 when request is dropped
Date: Thu,  2 Jul 2015 10:42:37 -0700
Message-Id: <1435858957-7527-1-git-send-email-wzhong@google.com> (sfid-20150702_194252_129618_3C7F5D43)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the case that user-initiated request is dropped because it has the
same alpha2 as last request, which could be from driver, save
user_alpah2[2], so that correct user_alpha2 can be restored in the
case of disassociation.

Signed-off-by: Wei Zhong <wzhong@google.com>
---
 net/wireless/reg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 91ef82b..9019617 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1534,6 +1534,11 @@ static int __regulatory_hint(struct wiphy *wiphy,
 		}
 		intersect = true;
 	} else if (r) {
+		/* Save alpha2 if initiated from user in case the request is dropped. */
+		if (pending_request->initiator == NL80211_REGDOM_SET_BY_USER) {
+			user_alpha2[0] = pending_request->alpha2[0];
+			user_alpha2[1] = pending_request->alpha2[1];
+		}
 		/*
 		 * If the regulatory domain being requested by the
 		 * driver has already been set just copy it to the
-- 
2.4.3.573.g4eafbef

