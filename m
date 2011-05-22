Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bytecamp.net ([212.204.60.9]:50081 "EHLO mail.bytecamp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab1EVNSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 09:18:17 -0400
From: Jo-Philipp Wich <jow@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Jo-Philipp Wich <jow@openwrt.org>
Subject: [PATCH] iw: Fix calculation of fractional multicast rates
Date: Sun, 22 May 2011 15:09:51 +0200
Message-Id: <1306069791-21079-1-git-send-email-jow@openwrt.org> (sfid-20110522_151821_674879_8740E2FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to missing brackets around the "(int) rate * 10" expression
the float value of "rate" is converted to an integer first and
then multiplied which results for example in "50" instead of the
expected "55" for a give rate of 5.5 Mbps, resulting in an invalid
argument error from iw.

This patch simply puts the multiplication expression in brackets,
so that the type cast is performed on the result and not the
first operand.

Signed-off-by: Jo-Philipp Wich <jow@openwrt.org>
---
 ibss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ibss.c b/ibss.c
index ca8a4ec..b70dee3 100644
--- a/ibss.c
+++ b/ibss.c
@@ -104,7 +104,7 @@ static int join_ibss(struct nl80211_state *state,
 		if (*end != '\0')
 			return 1;
 
-		NLA_PUT_U32(msg, NL80211_ATTR_MCAST_RATE, (int) rate * 10);
+		NLA_PUT_U32(msg, NL80211_ATTR_MCAST_RATE, (int)(rate * 10));
 		argv++;
 		argc--;
 	}
-- 
1.7.0.4

