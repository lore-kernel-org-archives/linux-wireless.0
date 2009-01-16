Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10994 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105AbZAPAM5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 19:12:57 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 16:12:57 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 01/13] cfg80211: print correct intersected regulatory domain
Date: Thu, 15 Jan 2009 16:12:14 -0800
Message-ID: <1232064746-17134-2-git-send-email-lrodriguez@atheros.com> (sfid-20090116_011327_947919_EF1A6A8C)
In-Reply-To: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When CONFIG_CFG80211_REG_DEBUG is enabled and an intersection
occurs we are printing the regulatory domain passed by CRDA
and indicating its the intersected regulatory domain. Lets fix
this and print the intersection as originally intended.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b34fd84..ec8b3d9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1332,7 +1332,7 @@ static void reg_country_ie_process_debug(
 	if (intersected_rd) {
 		printk(KERN_DEBUG "cfg80211: We intersect both of these "
 			"and get:\n");
-		print_regdomain_info(rd);
+		print_regdomain_info(intersected_rd);
 		return;
 	}
 	printk(KERN_DEBUG "cfg80211: Intersection between both failed\n");
-- 
1.6.1.rc3.51.g5832d

