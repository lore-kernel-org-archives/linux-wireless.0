Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:1238
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816Ab1KIIeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 03:34:20 -0500
From: Steven Miao <realmz6@gmail.com>
To: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<libertas-dev@lists.infradead.org>
CC: Steven Miao <realmz6@gmail.com>,
	"open list:NETWORKING [WIREL..." <linux-wireless@vger.kernel.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] wireless: libertas: fix unaligned le64 accesses
Date: Wed, 9 Nov 2011 16:30:40 +0800
Message-ID: <1320827440-16904-1-git-send-email-realmz6@gmail.com> (sfid-20111109_093424_351402_BEA725D9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use get_unaligned_le64() to get timestamp

Signed-off-by: Steven Miao <realmz6@gmail.com>
---
 drivers/net/wireless/libertas/cfg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index b456a53..f23c2b1 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -630,7 +630,7 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 			if (channel &&
 			    !(channel->flags & IEEE80211_CHAN_DISABLED))
 				cfg80211_inform_bss(wiphy, channel,
-					bssid, le64_to_cpu(*(__le64 *)tsfdesc),
+					bssid, get_unaligned_le64(tsfdesc),
 					capa, intvl, ie, ielen,
 					LBS_SCAN_RSSI_TO_MBM(rssi),
 					GFP_KERNEL);
-- 
1.7.0.4


