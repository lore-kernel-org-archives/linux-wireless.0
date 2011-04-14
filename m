Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51074 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab1DNVzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 17:55:41 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 14:55:15 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	David Quan <david.quan@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH] ath: fix 0x6C for beaconing/passive scan flags based on country IE
Date: Thu, 14 Apr 2011 14:55:36 -0700
Message-ID: <1302818137-17938-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 0x6C regulatory domain is just like the 0x6A regulatory
domain but differs in that 0x6C will allow adhoc and active
scan on its channels only if we are associated to an AP
with a country IE that allows those channels. The
ath_reg_apply_beaconing_flags() does just this -- we respect
the manufacturer's intent on only enabling beaconing modes
of operation if and only if blessed by the country IE.

Cc: David Quan <david.quan@atheros.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/regd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 14952f0..028310f 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -334,6 +334,7 @@ static void ath_reg_apply_world_flags(struct wiphy *wiphy,
 	case 0x63:
 	case 0x66:
 	case 0x67:
+	case 0x6C:
 		ath_reg_apply_beaconing_flags(wiphy, initiator);
 		break;
 	case 0x68:
-- 
1.7.4.15.g7811d

