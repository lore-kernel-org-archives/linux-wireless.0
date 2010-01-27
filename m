Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56313 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0A0Oph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 09:45:37 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Joerg Pommnitz <pommnitz@yahoo.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] cfg80211: fix wext-compat for setting rate to 'auto'
Date: Wed, 27 Jan 2010 09:44:48 -0500
Message-Id: <1264603488-31858-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <868377.1443.qm@web51406.mail.re2.yahoo.com>
References: <868377.1443.qm@web51406.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Haven't had a chance to test yet, but I suspect this fixes the issue...?

 net/wireless/wext-compat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 966d2f0..b17eeae 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1214,7 +1214,7 @@ int cfg80211_wext_siwrate(struct net_device *dev,
 
 	memset(&mask, 0, sizeof(mask));
 	fixed = 0;
-	maxrate = 0;
+	maxrate = (u32)-1;
 
 	if (rate->value < 0) {
 		/* nothing */
-- 
1.6.2.5

