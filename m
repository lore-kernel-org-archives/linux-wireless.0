Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZAFRMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 12:12:22 -0500
Subject: [PATCH] mac80211: validate SIOCSIWPOWER arguments better
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 18:12:35 +0100
Message-Id: <1231261955.3654.0.camel@johannes> (sfid-20090106_181225_537802_060B5F81)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't accept any arguments we don't handle, and return error codes
instead of using an uninitialised stack value.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/wext.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-01-06 18:10:07.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-01-06 18:10:23.000000000 +0100
@@ -852,9 +852,12 @@ static int ieee80211_ioctl_siwpower(stru
 		ps = true;
 		break;
 	default:                /* Otherwise we ignore */
-		break;
+		return -EINVAL;
 	}
 
+	if (wrq->flags & ~(IW_POWER_MODE | IW_POWER_TIMEOUT))
+		return -EINVAL;
+
 	if (wrq->flags & IW_POWER_TIMEOUT)
 		timeout = wrq->value / 1000;
 


